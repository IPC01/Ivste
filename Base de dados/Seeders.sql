--Categorias
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (1, 'Luxo');
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (2, 'Standard');
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (3, 'Econômico');


--Quarto
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade, preco_diario) VALUES (101, 1, 2, 300.00);
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade, preco_diario) VALUES (102, 2, 3, 150.00);
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade, preco_diario) VALUES (103, 3, 1, 80.00);

--Estacoes

INSERT INTO Estacoes (id_estacao, nome, percentual_desconto)
VALUES
(1, 'Inverno', 10.00),
(2, 'Verão', 5.00),
(2, 'Estação de Transição', 5.00);




--Clientes
INSERT INTO Clientes (id_cliente, nome, bi, morada, apelido, data_nasc, saldo) VALUES (1, 'João Silva', '123456789', 'Av. 25 de Setembro, 1000', 'Silva', TO_DATE('1985-07-15', 'YYYY-MM-DD'), 500.00);
INSERT INTO Clientes (id_cliente, nome, bi, morada, apelido, data_nasc, saldo) VALUES (2, 'Maria Santos', '987654321', 'Rua dos Alfeneiros, 50', 'Santos', TO_DATE('1990-04-10', 'YYYY-MM-DD'), 1000.00);

--Reserva
INSERT INTO Reserva (id_reserva, id_cliente, id_estacao, Nr_quarto, data_checkin, data_checkout, data_reserva, funcionario, valor_total_pagar, numero_hospedes) 
VALUES (1, 1, 1, 101, TO_DATE('2024-12-10', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), TO_DATE('2024-11-01', 'YYYY-MM-DD'), 1001, 1500.00, 2);
INSERT INTO Reserva (id_reserva, id_cliente, id_estacao, Nr_quarto, data_checkin, data_checkout, data_reserva, funcionario, valor_total_pagar, numero_hospedes) 
VALUES (2, 2, 2, 102, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), 1002, 600.00, 3);

--Estados reservaa
INSERT INTO Estados (id_estado, nome) VALUES (1, 'Confirmada');
INSERT INTO Estados (id_estado, nome) VALUES (2, 'Cancelada');
INSERT INTO Estados (id_estado, nome) VALUES (3, 'Concluída');

--Historico Reservas
INSERT INTO Historico_de_reservas (id_historico, id_reserva, id_estado, data_update, data_check_in, data_check_out, valor_atual, funcionario, id_historico_anterior) 
VALUES (1, 1, 1, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 1500.00, 1001, NULL);
INSERT INTO Historico_de_reservas (id_historico, id_reserva, id_estado, data_update, data_check_in, data_check_out, valor_atual, funcionario, id_historico_anterior) 
VALUES (2, 2, 2, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'), 600.00, 1002, NULL);

--Estados_do_cliente
INSERT INTO Estados_do_cliente (id_cliente, id_historico, estado_anterior, estado_atual, data_inicio, data_fim) 
VALUES (1, 1, NULL, 1, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'));
INSERT INTO Estados_do_cliente (id_cliente, id_historico, estado_anterior, estado_atual, data_inicio, data_fim) 
VALUES (2, 2, NULL, 2, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'));


select * from Estacoes;
