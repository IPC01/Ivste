CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY,
    nome_categoria VARCHAR(255) NOT NULL
);

CREATE TABLE Quarto (
    Nr_quarto INT PRIMARY KEY,
    id_categoria INT,
    capacidade INT,
    preco_diario DECIMAL(10, 2),
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

CREATE TABLE Estacoes (
    id_estacao INT PRIMARY KEY,
    nome VARCHAR(100),
    percentual_desconto DECIMAL(5, 2)
);

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    bi VARCHAR(20),
    morada VARCHAR(200),
    apelido VARCHAR(100),
    data_nasc DATE,
    saldo DECIMAL(10, 2)
);

CREATE TABLE Reserva (
    id_reserva INT PRIMARY KEY,
    id_cliente INT,
    id_estacao INT,
    Nr_quarto INT,
    data_checkin DATE,
    data_checkout DATE,
    data_reserva DATE,
    funcionario INT,
    valor_total_pagar DECIMAL(10, 2),
    numero_hospedes INT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_estacao) REFERENCES Estacoes(id_estacao),
    FOREIGN KEY (Nr_quarto) REFERENCES Quarto(Nr_quarto)
);

CREATE TABLE Estados (
    id_estado INT PRIMARY KEY,
    nome VARCHAR(100)
);

CREATE TABLE Historico_de_reservas (
    id_historico INT PRIMARY KEY,
    id_reserva INT,
    id_estado INT,
    data_update DATE,
    data_check_in DATE,
    data_check_out DATE,
    valor_atual DECIMAL(10, 2),
    funcionario INT,
    id_historico_anterior INT,
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_estado) REFERENCES Estados(id_estado),
    FOREIGN KEY (id_historico_anterior) REFERENCES Historico_de_reservas(id_historico)
);

CREATE TABLE Estados_do_cliente (
    id_cliente INT,
    id_historico INT,
    estado_anterior INT,
    estado_atual INT,
    data_inicio DATE,
    data_fim DATE,
    PRIMARY KEY (id_cliente, id_historico),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (estado_anterior) REFERENCES Estados(id_estado),
    FOREIGN KEY (estado_atual) REFERENCES Estados(id_estado)
);
