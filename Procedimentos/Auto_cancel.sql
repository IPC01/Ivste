BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'job_auto_cancel_diario',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN 
                              ivania.auto_cancel; 
                            END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY; BYHOUR=9; BYMINUTE=23; BYSECOND=0',
        enabled         => TRUE
    );
END;
/


CREATE OR REPLACE PROCEDURE auto_cancel IS
    CURSOR reservas IS
        SELECT h.id_historico, h.id_reserva, h.id_estado, h.data_check_in, h.data_check_out, 
               h.valor_atual, h.funcionario, h.id_historico_anterior
        FROM reserva r
        INNER JOIN historico_de_reservas h 
        ON r.id_reserva = h.id_reserva 
        WHERE h.actual = 1 
        AND h.id_estado=2 --alterar para comfirmado
        AND h.data_check_in = TO_DATE('29/10/24', 'DD/MM/YY');

    -- Variáveis para armazenar os valores do cursor
    v_id_historico historico_de_reservas.id_historico%TYPE;
    v_id_reserva historico_de_reservas.id_reserva%TYPE;
    v_id_estado historico_de_reservas.id_estado%TYPE;
    v_data_check_in historico_de_reservas.data_check_in%TYPE;
    v_data_check_out historico_de_reservas.data_check_out%TYPE;
    v_valor_atual historico_de_reservas.valor_atual%TYPE;
    v_funcionario historico_de_reservas.funcionario%TYPE;
    v_id_historico_anterior historico_de_reservas.id_historico_anterior%TYPE;

BEGIN
    OPEN reservas;
    LOOP
        FETCH reservas INTO v_id_historico, v_id_reserva, v_id_estado, 
                            v_data_check_in, v_data_check_out, 
                            v_valor_atual, v_funcionario, 
                            v_id_historico_anterior;

        EXIT WHEN reservas%NOTFOUND;

        -- Inserir um novo histórico com base no anterior
        INSERT INTO historico_de_reservas (id_historico,id_reserva, id_estado, data_update, data_check_in, 
                                            data_check_out, valor_atual, funcionario, 
                                            id_historico_anterior, actual)
        VALUES (seq_historico.nextval,v_id_reserva, 5, SYSDATE, v_data_check_in, 
                v_data_check_out, v_valor_atual, v_funcionario, 
                v_id_historico, 1);

        -- Atualizar o histórico anterior
        UPDATE historico_de_reservas
        SET actual = 0
        WHERE id_historico = v_id_historico;

    END LOOP;
    CLOSE reservas;

    -- Confirmar as alterações
    COMMIT;
END;
/

execute auto_cancel();

CREATE SEQUENCE seq_historico
START WITH 20       -- Valor inicial
INCREMENT BY 1      -- Incremento
NOCACHE             -- Sem cache para garantir que cada chamada obtenha o próximo valor
NOCYCLE;            -- A sequência não reinicia após atingir o valor máximo
