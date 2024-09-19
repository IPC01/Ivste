-- 1. o metodo recebe por parametro o
-- 1.1 p_num_clientes que recebe o numero de clientes que serao atribuidos uma promocao;
-- 1.2 data_fim que recebe a data do termino da promocao que deve ser maior ou igual em 1 dia data actual;
-- 1.3 p_valor_minimo que recebe o valor que deve ter sido acumulado durante o ano;
-- 1.3 p_num_reservas que recebe a quantidade de reservas que deve ter alcancado durante o ano;


CREATE OR REPLACE PROCEDURE ProcessarClientesPromocao (
  p_num_clientes IN NUMBER, 
  data_fim IN DATE,
  p_valor_minimo IN NUMBER,
  p_num_reservas IN NUMBER
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
    WHERE EXTRACT(YEAR FROM DATA_CHECKIN) = EXTRACT(YEAR FROM SYSDATE)
    GROUP BY ID_CLIENTE
    HAVING COUNT(ID_RESERVA) >= p_num_reservas;

BEGIN

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

  -- Verifica se a data_fim é válida e se há clientes suficientes
  IF data_fim < SYSDATE THEN
    DBMS_OUTPUT.PUT_LINE('A data de término da promoção é anterior à data atual. Por favor, verifique a duração da promoção.');
  ELSIF Array_clientes.COUNT < p_num_clientes THEN
    DBMS_OUTPUT.PUT_LINE('O número de clientes com valor total estipulado para a promoção é menor do que a quantidade de promoções que deseja atribuir.');
  ELSE
    -- Verifica se há pelo menos um cliente
    IF Array_clientes.COUNT > 0 THEN
      -- Cria uma lista temporária para IDs aleatórios
      DECLARE
        num_to_insert NUMBER;
        random_ids SYS.ODCINUMBERLIST;
        i INTEGER;
        temp NUMBER;
        idx INTEGER;
      BEGIN
        -- Inicializa a lista de IDs aleatórios
        random_ids := SYS.ODCINUMBERLIST();
        
        -- Adiciona IDs únicos à lista
        FOR i IN 1..Array_clientes.COUNT LOOP
          random_ids.EXTEND;
          random_ids(random_ids.COUNT) := Array_clientes(i);
        END LOOP;

        -- Embaralha a lista de IDs usando DBMS_RANDOM
        FOR i IN REVERSE 1..random_ids.COUNT LOOP
          idx := TRUNC(DBMS_RANDOM.VALUE(1, i + 1));
          temp := random_ids(i);
          random_ids(i) := random_ids(idx);
          random_ids(idx) := temp;
        END LOOP;

        -- Define o número de IDs a serem inseridos
        num_to_insert := LEAST(p_num_clientes, random_ids.COUNT);

        -- Insere os clientes na tabela, permitindo duplicações dentro da mesma execução
        FOR i IN 1..num_to_insert LOOP
          BEGIN
            -- Seleciona o ID_HISTORICO mais recente para o cliente, se existir
            BEGIN
              SELECT ID_HISTORICO
              INTO historico_id
              FROM ESTADOS_DO_CLIENTE
              WHERE ID_CLIENTE = random_ids(i)
              ORDER BY DATA_FIM DESC;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                -- Se não houver histórico, usa o SEQ_HIST_ID.nextval
                historico_id := NULL;
            END;

            -- Insere o cliente na tabela
            INSERT INTO ESTADOS_DO_CLIENTE (
              ID_CLIENTE, 
              ID_HISTORICO, 
              ESTADO_ANTERIOR,  
              DATA_INICIO, 
              DATA_FIM
            )
            VALUES (
              random_ids(i), 
              SEQ_HIST_ID.NEXTVAL, 
              historico_id,  -- Considerando estado anterior como NULL se não houver 
              SYSDATE, 
              data_fim
            );
            COMMIT;

          EXCEPTION
            WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('Erro ao inserir cliente ID: ' || random_ids(i) || '. Erro: ' || SQLERRM);
          END;
        END LOOP;
      END;
    END IF;
  END IF;

END;
/
BEGIN
  ProcessarClientesPromocao(
    p_num_clientes => 2, 
    data_fim => SYSDATE + 3,  -- Data de término da promoção 10 dias no futuro
    p_valor_minimo => 10000,  -- Valor mínimo para consideração
    p_num_reservas => 2  -- Número mínimo de reservas por cliente
  );
END;
/
