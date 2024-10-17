create FUNCTION verificar_dispo_promocao_v2(
    p_data_inicio DATE,
    p_data_fim DATE
) RETURN BOOLEAN IS
    v_count INT;
BEGIN
    -- Contar as promoções que entram em conflito com as novas datas
    SELECT COUNT(*)
    INTO v_count
    FROM ESTADOS_DO_CLIENTE
    WHERE
        (DATA_INICIO <= p_data_fim AND DATA_FIM >= p_data_inicio);

    -- Se v_count for maior que 0, há um conflito de datas
    IF v_count > 0 THEN
        RETURN FALSE;  -- Conflito encontrado
    ELSE
        RETURN TRUE;   -- Sem conflito
    END IF;
END;
/

