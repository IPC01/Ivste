create PROCEDURE processar_promocao_v6 (
    data_inicio_promocao  IN DATE,
    data_fim_promocao     IN DATE,
    data_inicio_busca     IN DATE,
    data_fim_busca        IN DATE,
    p_valor_minimo        IN NUMBER,
    p_num_reservas        IN NUMBER,
    p_desconto_percentual IN NUMBER
) IS
    -- Tipo de Nested Table para armazenar IDs de clientes
    TYPE nested_table_type IS TABLE OF NUMBER;
    array_clientes    nested_table_type;

    -- Variáveis para armazenar os valores dos cursores
    id_c              NUMBER;
    id_r              NUMBER;
    valor             NUMBER := 0;
    valor_atual       NUMBER;
    historico_id      NUMBER;

    -- Cursor para selecionar ID_RESERVA baseado no ID_CLIENTE que está em quartos de luxo
    CURSOR reserva_id (client_id NUMBER) IS
        SELECT r.id_reserva
        FROM reserva r
        INNER JOIN quarto q ON r.nr_quarto = q.nr_quarto
        WHERE q.id_categoria = 1
        AND r.id_cliente = client_id;

    -- Cursor para selecionar ID_CLIENTE com mais de uma reserva
    CURSOR cliente_id IS
        SELECT id_cliente
        FROM reserva
        WHERE data_checkin BETWEEN data_inicio_busca AND data_fim_busca
        GROUP BY id_cliente
        HAVING COUNT(id_reserva) >= p_num_reservas;

    -- Verificar disponibilidade
    v_disponibilidade BOOLEAN;

BEGIN
    -- Verificar se as datas da promoção estão disponíveis
    v_disponibilidade := verificar_dispo_promocao_v2(data_inicio_promocao, data_fim_promocao);

    dbms_output.put_line('Valor da disponibilidade: ' || CASE WHEN v_disponibilidade THEN 'Disponível' ELSE 'Indisponível' END);

    -- Inicializa a Nested Table
    array_clientes := nested_table_type();

    -- Abre o cursor cliente_id
    OPEN cliente_id;
    LOOP
        -- Busca o próximo valor de cliente_id
        FETCH cliente_id INTO id_c;

        -- Sai do loop se não houver mais linhas
        EXIT WHEN cliente_id%NOTFOUND;

        -- Inicializa o valor para cada cliente
        valor := 0;

        -- Abre o cursor reserva_id para o cliente atual
        OPEN reserva_id(id_c);
        LOOP
            -- Busca o próximo valor de reserva_id
            FETCH reserva_id INTO id_r;

            -- Sai do loop se não houver mais linhas
            EXIT WHEN reserva_id%NOTFOUND;

            -- Seleciona o valor da reserva atual
            BEGIN
                SELECT valor_atual
                INTO valor_atual
                FROM historico_de_reservas
                WHERE id_reserva = id_r
                AND data_check_out IS NOT NULL;

                -- Soma o valor atual ao valor total
                valor := valor + valor_atual;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    valor_atual := 0; -- Caso não haja valor na reserva
            END;

        END LOOP;

        -- Fecha o cursor reserva_id após processar todas as reservas para o cliente
        CLOSE reserva_id;

        -- Adiciona o cliente à Nested Table se o valor total for superior ao valor mínimo
        IF valor > p_valor_minimo THEN
            array_clientes.EXTEND;
            array_clientes(array_clientes.COUNT) := id_c;
        END IF;

    END LOOP;

    -- Fecha o cursor cliente_id após processar todos os clientes
    CLOSE cliente_id;

    -- Verifica se a data_fim é válida e se o desconto percentual é válido
    IF data_fim_promocao < data_inicio_promocao THEN
        dbms_output.put_line('A data de término da promoção é anterior à data de início. Verifique a duração da promoção.');
    ELSIF p_desconto_percentual <= 0 OR p_desconto_percentual > 100 THEN
        dbms_output.put_line('Percentagem inválida! A percentagem deve ser um número natural entre 1 e 100.');
    ELSIF NOT v_disponibilidade THEN
        dbms_output.put_line('As datas da promoção conflitam com promoções existentes.');
    ELSE
        -- Verifica se há pelo menos um cliente no array
        IF array_clientes.COUNT > 0 THEN
            -- Insere os clientes na tabela ESTADOS_DO_CLIENTE
            FOR i IN 1..array_clientes.COUNT LOOP
                BEGIN
                    -- Seleciona o ID_HISTORICO mais recente para o cliente, se existir
                    BEGIN
                        SELECT id_historico
                        INTO historico_id
                        FROM (
                            SELECT id_historico
                            FROM estados_do_cliente
                            WHERE id_cliente = array_clientes(i)
                            ORDER BY data_fim DESC
                        )
                        WHERE ROWNUM = 1;

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            -- Se não houver histórico, define como NULL
                            historico_id := NULL;
                    END;

                    -- Insere o cliente na tabela com o valor percentual do desconto
                    INSERT INTO estados_do_cliente (
                        id_cliente,
                        id_historico,
                        estado_anterior,
                        data_inicio,
                        data_fim,
                        percentagem
                    ) VALUES (
                        array_clientes(i),
                        seq_hist_id.NEXTVAL,
                        historico_id,  -- Considerando estado anterior como NULL se não houver
                        data_inicio_promocao,
                        data_fim_promocao,
                        p_desconto_percentual / 100  -- Percentual de desconto convertido para fração
                    );
                    COMMIT;

                EXCEPTION
                    WHEN OTHERS THEN
                        dbms_output.put_line('Erro ao inserir cliente ID: '
                                             || array_clientes(i)
                                             || '. Erro: '
                                             || SQLERRM);
                END;
            END LOOP;
        ELSE
            dbms_output.put_line('Nenhum cliente qualificado para a promoção.');
        END IF;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro no processamento da promoção: ' || SQLERRM);
END;
/

