create or replace FUNCTION percentual_desconto(
    cliente IN NUMBER
) RETURN NUMBER
DETERMINISTIC
IS
  p NUMBER := 0;
BEGIN
  -- Seleciona a percentagem mais recente para o cliente usando ROWNUM
  SELECT percentagem
  INTO p
  FROM (
    SELECT percentagem
    FROM ESTADOS_DO_CLIENTE
    WHERE ID_CLIENTE = cliente
    ORDER BY DATA_FIM DESC
  )
  WHERE ROWNUM = 1;

  RETURN p;

EXCEPTION
  -- Se nenhum dado for encontrado, retorna NULL
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  -- Tratamento de outras exceções (opcional)
  WHEN OTHERS THEN
    RETURN NULL;
END;
