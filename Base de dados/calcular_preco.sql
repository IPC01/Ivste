set serveroutput on

CREATE OR REPLACE FUNCTION calcular_Preco(
    id_quarto IN NUMBER, 
    dias IN NUMBER, 
    data IN DATE
) 
RETURN NUMBER 
IS
    preco_Total NUMBER(20);
    preco_diario NUMBER(20);
    percentual_por_estacao NUMBER(20);
    percentual_dias NUMBER(20) := 1; -- Inicialmente sem desconto
BEGIN
    -- Primeira faixa de data
    IF data BETWEEN TO_DATE('2024-12-01', 'yyyy-mm-dd') AND TO_DATE('2025-01-31', 'yyyy-mm-dd') THEN
        SELECT preco_diario, percentual_desconto 
        INTO preco_diario, percentual_por_estacao  
        FROM preco_por_estacao pr 
        INNER JOIN estacoes e ON pr.id_estacao = e.id_estacao 
        WHERE nr_quarto = id_quarto AND pr.id_estacao = 1;
        
    -- Segunda faixa de data
    ELSIF data BETWEEN TO_DATE('2024-02-01', 'yyyy-mm-dd') AND TO_DATE('2024-11-30', 'yyyy-mm-dd') THEN
        SELECT preco_diario, percentual_desconto 
        INTO preco_diario, percentual_por_estacao  
        FROM preco_por_estacao pr 
        INNER JOIN estacoes e ON pr.id_estacao = e.id_estacao 
        WHERE nr_quarto = id_quarto AND pr.id_estacao = 2;
        
    -- Terceira faixa de data
    ELSIF data BETWEEN TO_DATE('2024-09-01', 'yyyy-mm-dd') AND TO_DATE('2024-11-30', 'yyyy-mm-dd') THEN
        SELECT preco_diario, percentual_desconto 
        INTO preco_diario, percentual_por_estacao  
        FROM preco_por_estacao pr 
        INNER JOIN estacoes e ON pr.id_estacao = e.id_estacao 
        WHERE nr_quarto = id_quarto AND pr.id_estacao = 3;
    END IF;

   

    -- Calcular o preço total
    preco_Total := preco_diario * percentual_por_estacao  * dias;
    
    RETURN preco_Total;
END;

DECLARE
    v_preco_total NUMBER;
    v_id_quarto NUMBER := 101;  -- Substitua pelo ID do quarto desejado
    v_dias NUMBER := 5;       -- Substitua pelo número de dias desejado
    v_data DATE := TO_DATE('2024-12-01', 'yyyy-mm-dd');  -- Substitua pela data desejada
BEGIN
    -- Chama a função calcular_Preco e armazena o resultado na variável v_preco_total
    v_preco_total := calcular_Preco(v_id_quarto, v_dias, v_data);
    
    -- Exibe o preço total
    DBMS_OUTPUT.PUT_LINE('O preço total é: ' || v_preco_total);
END;
/
