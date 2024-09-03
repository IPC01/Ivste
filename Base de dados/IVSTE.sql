CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY,
    nome_categoria VARCHAR(255) NOT NULL
);

CREATE TABLE Quarto (
    Nr_quarto INT PRIMARY KEY,
    id_categoria INT,
    capacidade INT,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);
CREATE TABLE Estacoes (
    id_estacao INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_inicio DATE,
    data_fim DATE,
    percentual_desconto DECIMAL(5, 2)
);
CREATE TABLE Preco_por_estacao (
    id_preco_por_estacao INT PRIMARY KEY,
    Nr_quarto INT,
    id_estacao INT,
    preco_diario DECIMAL(10, 2),
    FOREIGN KEY (Nr_quarto) REFERENCES Quarto(Nr_quarto),
    FOREIGN KEY (id_estacao) REFERENCES Estacoes(id_estacao)
);
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    bi VARCHAR(20) NOT NULL,
    morada VARCHAR(255),
    apelido VARCHAR(255),
    data_nasc DATE
);


CREATE TABLE Reserva (
    id_reserva INT PRIMARY KEY,
    id_cliente INT,
    id_preco_por_estacao INT,
    data_checkin DATE,
    data_checkout DATE,
    data_reserva DATE,
    id_funcionario INT,
    valor_total_pagar DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_preco_por_estacao) REFERENCES Preco_por_estacao(id_preco_por_estacao),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario)
);
CREATE TABLE Historico_de_reservas (
    id_historico INT PRIMARY KEY,
    id_reserva INT,
    estado_atual INT,
    data_update DATE,
    data_check_in DATE,
    data_check_out DATE,
    valor_atual DECIMAL(10, 2),
    id_funcionario INT,
    id_reserva_anterior INT,
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario)
);

CREATE TABLE Funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    apelido VARCHAR(255),
    morada VARCHAR(255),
    salario DECIMAL(10, 2),
    bi VARCHAR(20),
    cargo VARCHAR(255)
);
--CREATE TABLE Estados (
 --   id_estado INT PRIMARY KEY,
 --   nome VARCHAR(255) NOT NULL
--);
CREATE TABLE Estados_do_cliente (
    id_cliente INT,
    id_historico INT,
    estado_anterior INT,
    estado_atual INT,
    data_inicio DATE,
    data_fim DATE,
    PRIMARY KEY (id_cliente, id_historico),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_historico) REFERENCES Historico_de_reservas(id_historico)
);
desc Categorias;

--Categorias
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (1, 'Suite');
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (2, 'Quarto Duplo');
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (3, 'Quarto Simples');
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (4, 'Quarto Fam?lia');
INSERT INTO Categorias (id_categoria, nome_categoria) VALUES (5, 'Quarto Luxo');

--Quarto
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade) VALUES (101, 1, 2);
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade) VALUES (102, 2, 2);
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade) VALUES (103, 3, 1);
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade) VALUES (104, 4, 4);
INSERT INTO Quarto (Nr_quarto, id_categoria, capacidade) VALUES (105, 5, 3);
--Estacoes
INSERT INTO Estacoes (id_estacao, nome, data_inicio, data_fim, percentual_desconto) 
VALUES (1, 'Alta Temporada', TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2025-01-31', 'YYYY-MM-DD'), 10.00);

INSERT INTO Estacoes (id_estacao, nome, data_inicio, data_fim, percentual_desconto) 
VALUES (2, 'Baixa Temporada', TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-11-30', 'YYYY-MM-DD'), 0.00);

INSERT INTO Estacoes (id_estacao, nome, data_inicio, data_fim, percentual_desconto) 
VALUES (3, 'Primavera', TO_DATE('2024-09-01', 'YYYY-MM-DD'), TO_DATE('2024-11-30', 'YYYY-MM-DD'), 5.00);

INSERT INTO Estacoes (id_estacao, nome, data_inicio, data_fim, percentual_desconto) 
VALUES (4, 'Ver?o', TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-08-31', 'YYYY-MM-DD'), 15.00);

INSERT INTO Estacoes (id_estacao, nome, data_inicio, data_fim, percentual_desconto) 
VALUES (5, 'Inverno', TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2025-02-28', 'YYYY-MM-DD'), 20.00);

--Preco_por_estacao
INSERT INTO Preco_por_estacao (id_preco_por_estacao, Nr_quarto, id_estacao, preco_diario) 
VALUES (1, 101, 1, 300.00);

INSERT INTO Preco_por_estacao (id_preco_por_estacao, Nr_quarto, id_estacao, preco_diario) 
VALUES (2, 102, 2, 150.00);

INSERT INTO Preco_por_estacao (id_preco_por_estacao, Nr_quarto, id_estacao, preco_diario) 
VALUES (3, 103, 3, 100.00);

INSERT INTO Preco_por_estacao (id_preco_por_estacao, Nr_quarto, id_estacao, preco_diario) 
VALUES (4, 104, 4, 250.00);

INSERT INTO Preco_por_estacao (id_preco_por_estacao, Nr_quarto, id_estacao, preco_diario) 
VALUES (5, 105, 5, 350.00);

--Clientes
INSERT INTO Clientes (id_cliente, nome, bi, morada, apelido, data_nasc) 
VALUES (1, 'Jo?o Silva', 'BI12345', 'Maputo, Rua A', 'Silva', TO_DATE('1990-05-10', 'YYYY-MM-DD'));

INSERT INTO Clientes (id_cliente, nome, bi, morada, apelido, data_nasc) 
VALUES (2, 'Maria Santos', 'BI54321', 'Maputo, Rua B', 'Santos', TO_DATE('1985-08-15', 'YYYY-MM-DD'));

INSERT INTO Clientes (id_cliente, nome, bi, morada, apelido, data_nasc) 
VALUES (3, 'Carlos Almeida', 'BI67890', 'Beira, Rua C', 'Almeida', TO_DATE('1992-02-20', 'YYYY-MM-DD'));

INSERT INTO Clientes (id_cliente, nome, bi, morada, apelido, data_nasc) 
VALUES (4, 'Ana Costa', 'BI09876', 'Nampula, Rua D', 'Costa', TO_DATE('1995-11-25', 'YYYY-MM-DD'));

INSERT INTO Clientes (id_cliente, nome, bi, morada, apelido, data_nasc) 
VALUES (5, 'Paulo Nogueira', 'BI11223', 'Chimoio, Rua E', 'Nogueira', TO_DATE('1988-07-30', 'YYYY-MM-DD'));

--Funcionarios
INSERT INTO Funcionarios (id_funcionario, nome, apelido, morada, salario, bi, cargo) VALUES (1, 'Jos? Pereira', 'Pereira', 'Maputo, Rua F', 20000.00, 'BI22445', 'Recepcionista');
INSERT INTO Funcionarios (id_funcionario, nome, apelido, morada, salario, bi, cargo) VALUES (2, 'Laura Fernandes', 'Fernandes', 'Maputo, Rua G', 25000.00, 'BI55678', 'Gerente');
INSERT INTO Funcionarios (id_funcionario, nome, apelido, morada, salario, bi, cargo) VALUES (3, 'M?rio Gomes', 'Gomes', 'Maputo, Rua H', 15000.00, 'BI66789', 'Camareiro');
INSERT INTO Funcionarios (id_funcionario, nome, apelido, morada, salario, bi, cargo) VALUES (4, 'Rita Mendes', 'Mendes', 'Maputo, Rua I', 18000.00, 'BI78901', 'Seguran?a');
INSERT INTO Funcionarios (id_funcionario, nome, apelido, morada, salario, bi, cargo) VALUES (5, 'Pedro Costa', 'Costa', 'Maputo, Rua J', 22000.00, 'BI89012', 'Cozinheiro');

--Reserva
INSERT INTO Reserva (id_reserva, id_cliente, id_preco_por_estacao, data_checkin, data_checkout, data_reserva, id_funcionario, valor_total_pagar) VALUES (1, 1, 1, '2024-12-05', '2024-12-10', '2024-11-01', 1, 1500.00);
INSERT INTO Reserva (id_reserva, id_cliente, id_preco_por_estacao, data_checkin, data_checkout, data_reserva, id_funcionario, valor_total_pagar) VALUES (2, 2, 2, '2024-08-01', '2024-08-05', '2024-07-15', 2, 750.00);
INSERT INTO Reserva (id_reserva, id_cliente, id_preco_por_estacao, data_checkin, data_checkout, data_reserva, id_funcionario, valor_total_pagar) VALUES (3, 3, 3, '2024-09-10', '2024-09-15', '2024-08-20', 3, 500.00);
INSERT INTO Reserva (id_reserva, id_cliente, id_preco_por_estacao, data_checkin, data_checkout, data_reserva, id_funcionario, valor_total_pagar) VALUES (4, 4, 4, '2024-06-15', '2024-06-20', '2024-05-25', 4, 1250.00);
INSERT INTO Reserva (id_reserva, id_cliente, id_preco_por_estacao, data_checkin, data_checkout, data_reserva, id_funcionario, valor_total_pagar) VALUES (5, 5, 5, '2024-12-20', '2024-12-25', '2024-11-30', 5, 1750.00);



select * from Estacoes;
rollback;
