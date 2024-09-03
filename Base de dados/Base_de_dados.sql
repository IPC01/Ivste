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