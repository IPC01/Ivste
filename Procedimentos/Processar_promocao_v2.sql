CREATE OR REPLACE PROCEDURE Processar_Promocao_v3 (
   data_inicio_promocao IN DATE,
    data_fim_promocao  IN DATE,
     data_inicio_busca IN DATE,
    data_fim_busca IN DATE,
  p_valor_minimo IN NUMBER,
  p_num_reservas IN NUMBER,
  p_desconto_percentual IN NUMBER
) IS
  -- Tipo de Nested Table para armazenar IDs de clientes
  TYPE nested_table_type IS TABLE OF NUMBER;
  Array_clientes nested_table_type;

  -- Variáveis para armazenar os valores dos cursores
  id_c NUMBER;
  id_r NUMBER;
  valor NUMBER := 0;
  valor_atual NUMBER;
  historico_id NUMBER;

  -- Cursor para selecionar ID_RESERVA baseado no ID_CLIENTE
  CURSOR reserva_id (client_id NUMBER) IS
    SELECT ID_RESERVA
    FROM RESERVA
    WHERE ID_CLIENTE = client_id;

  -- Cursor para selecionar ID_CLIENTE com mais de uma reserva
  CURSOR cliente_id IS
    SELECT ID_CLIENTE
    FROM RESERVA
    WHERE DATA_CHECKIN BETWEEN data_inicio_busca AND data_fim_busca
    GROUP BY ID_CLIENTE
    HAVING COUNT(ID_RESERVA) >= p_num_reservas;

  -- Verificar disponibilidade
  v_disponibilidade BOOLEAN;
  
BEGIN
  -- Verificar se as datas da promoção estão disponíveis
  v_disponibilidade := verificar_dispo_promocao(data_inicio, data_fim);
  
 
  
  -- Inicializa a Nested Table
  Array_clientes := nested_table_type();

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
        SELECT VALOR_ATUAL INTO valor_atual
        FROM HISTORICO_DE_RESERVAS
        WHERE ID_RESERVA = id_r
        AND DATA_CHECK_OUT IS NOT NULL;

        -- Soma o valor atual ao valor total
        valor := valor + valor_atual;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          valor_atual := 0;
      END;

    END LOOP;

    -- Fecha o cursor reserva_id após processar todas as reservas para o cliente
    CLOSE reserva_id;

    -- Adiciona o cliente à Nested Table se o valor total for superior ao valor mínimo
    IF valor > p_valor_minimo THEN
      Array_clientes.EXTEND;
      Array_clientes(Array_clientes.COUNT) := id_c;
    END IF;
  END LOOP;

  -- Fecha o cursor cliente_id após processar todos os clientes
  CLOSE cliente_id;

  -- Verifica se a data_fim é válida e se o desconto percentual é válido
  IF data_fim < SYSDATE THEN
    DBMS_OUTPUT.PUT_LINE('A data de término da promoção é anterior à data atual. Por favor, verifique a duração da promoção.');
  ELSIF p_desconto_percentual <= 0 OR p_desconto_percentual > 100 THEN
    DBMS_OUTPUT.PUT_LINE('Percentagem inválida! A percentagem deve ser um número natural entre 1 e 100.');
  ELSIF NOT v_disponibilidade THEN
    DBMS_OUTPUT.PUT_LINE('As datas da promoção conflitam com promoções existentes.');
  ELSE
    -- Verifica se há pelo menos um cliente no array
    IF Array_clientes.COUNT > 0 THEN
      -- Insere os clientes na tabela ESTADOS_DO_CLIENTE
      FOR i IN 1..Array_clientes.COUNT LOOP
        BEGIN
          -- Seleciona o ID_HISTORICO mais recente para o cliente, se existir
          BEGIN
            SELECT ID_HISTORICO
            INTO historico_id
            FROM (
              SELECT ID_HISTORICO
              FROM ESTADOS_DO_CLIENTE
              WHERE ID_CLIENTE = Array_clientes(i)
              ORDER BY DATA_FIM DESC
            )
            WHERE ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              -- Se não houver histórico, define como NULL
              historico_id := NULL;
          END;

          -- Insere o cliente na tabela com o valor percentual do desconto
          INSERT INTO ESTADOS_DO_CLIENTE (
            ID_CLIENTE, 
            ID_HISTORICO, 
            ESTADO_ANTERIOR,  
            DATA_INICIO, 
            DATA_FIM,
            PERCENTAGEM
          )
          VALUES (
            Array_clientes(i), 
            SEQ_HIST_ID.NEXTVAL, 
            historico_id,  -- Considerando estado anterior como NULL se não houver
            data_inicio_promocao, 
            data_fim_promocao,
            p_desconto_percentual / 100  -- Percentual de desconto convertido para fração
          );
          COMMIT;

        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao inserir cliente ID: ' || Array_clientes(i) || '. Erro: ' || SQLERRM);
        END;
      END LOOP;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Nenhum cliente qualificado para a promoção.');
    END IF;
  END IF;

END;
/
