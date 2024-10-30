-- Criando a tabela Categoria_quarto
CREATE TABLE Categoria_quarto (
    id_categoria NUMBER PRIMARY KEY,
    nome_categoria VARCHAR2(255) NOT NULL,
      preco_diario DECIMAL(10, 2)
);

-- Criando sequência para Categoria_quarto
CREATE SEQUENCE seq_categoria_quarto START WITH 1 INCREMENT BY 1;

-- Criando trigger para Categoria_quarto
CREATE OR REPLACE TRIGGER trg_categoria_quarto
BEFORE INSERT ON Categoria_quarto
FOR EACH ROW
WHEN (NEW.id_categoria IS NULL)
BEGIN
    SELECT seq_categoria_quarto.NEXTVAL INTO :NEW.id_categoria FROM dual;
END;
/

-- Criando a tabela Quarto
CREATE TABLE Quarto (
    Nr_quarto NUMBER PRIMARY KEY,
    id_categoria NUMBER,
    capacidade NUMBER,
    FOREIGN KEY (id_categoria) REFERENCES Categoria_quarto(id_categoria)
);

-- Criando sequência para Quarto
CREATE SEQUENCE seq_quarto START WITH 1 INCREMENT BY 1;

-- Criando trigger para Quarto
CREATE OR REPLACE TRIGGER trg_quarto
BEFORE INSERT ON Quarto
FOR EACH ROW
WHEN (NEW.Nr_quarto IS NULL)
BEGIN
    SELECT seq_quarto.NEXTVAL INTO :NEW.Nr_quarto FROM dual;
END;
/

-- Criando a tabela Estacoes
CREATE TABLE Estacoes (
    id_estacao NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    percentual_desconto DECIMAL(5, 2)
);

-- Criando sequência para Estacoes
CREATE SEQUENCE seq_estacoes START WITH 1 INCREMENT BY 1;

-- Criando trigger para Estacoes
CREATE OR REPLACE TRIGGER trg_estacoes
BEFORE INSERT ON Estacoes
FOR EACH ROW
WHEN (NEW.id_estacao IS NULL)
BEGIN
    SELECT seq_estacoes.NEXTVAL INTO :NEW.id_estacao FROM dual;
END;
/

-- Criando a tabela Clientes
CREATE TABLE Clientes (
    id_cliente NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    bi VARCHAR2(20),
    morada VARCHAR2(200),
    apelido VARCHAR2(100),
    data_nasc DATE,
    saldo DECIMAL(10, 2)
);

-- Criando sequência para Clientes
CREATE SEQUENCE seq_clientes START WITH 1 INCREMENT BY 1;

-- Criando trigger para Clientes
CREATE OR REPLACE TRIGGER trg_clientes
BEFORE INSERT ON Clientes
FOR EACH ROW
WHEN (NEW.id_cliente IS NULL)
BEGIN
    SELECT seq_clientes.NEXTVAL INTO :NEW.id_cliente FROM dual;
END;
/

-- Criando a tabela Reserva
CREATE TABLE Reserva (
    id_reserva NUMBER PRIMARY KEY,
    id_cliente NUMBER,
    id_estacao NUMBER,
    Nr_quarto NUMBER,
    data_checkin DATE,
    data_checkout DATE,
    data_reserva DATE,
    funcionario NUMBER,
    valor_total_pagar DECIMAL(10, 2),
    numero_hospedes NUMBER,
    parcela NUMBER,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_estacao) REFERENCES Estacoes(id_estacao),
    FOREIGN KEY (Nr_quarto) REFERENCES Quarto(Nr_quarto)
);

-- Criando sequência para Reserva
CREATE SEQUENCE seq_reserva START WITH 1 INCREMENT BY 1;

-- Criando trigger para Reserva
CREATE OR REPLACE TRIGGER trg_reserva
BEFORE INSERT ON Reserva
FOR EACH ROW
WHEN (NEW.id_reserva IS NULL)
BEGIN
    SELECT seq_reserva.NEXTVAL INTO :NEW.id_reserva FROM dual;
END;
/

-- Criando a tabela Estados_reserva
CREATE TABLE Estados_reserva (
    id_estado NUMBER PRIMARY KEY,
    nome VARCHAR2(100)
);

-- Criando sequência para Estados_reserva
CREATE SEQUENCE seq_estados_reserva START WITH 1 INCREMENT BY 1;

-- Criando trigger para Estados_reserva
CREATE OR REPLACE TRIGGER trg_estados_reserva
BEFORE INSERT ON Estados_reserva
FOR EACH ROW
WHEN (NEW.id_estado IS NULL)
BEGIN
    SELECT seq_estados_reserva.NEXTVAL INTO :NEW.id_estado FROM dual;
END;
/

-- Criando a tabela Historico_de_reservas
CREATE TABLE Historico_de_reservas (
    id_historico NUMBER PRIMARY KEY,
    id_reserva NUMBER,
    id_estado NUMBER,
    data_update DATE,
    data_check_in DATE,
    data_check_out DATE,
    valor_atual DECIMAL(10, 2),
    funcionario NUMBER,
    id_historico_anterior NUMBER,
    actual NUMBER,
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_estado) REFERENCES Estados_reserva(id_estado),
    FOREIGN KEY (id_historico_anterior) REFERENCES Historico_de_reservas(id_historico)
);

-- Criando sequência para Historico_de_reservas
CREATE SEQUENCE seq_historico_de_reservas START WITH 1 INCREMENT BY 1;

-- Criando trigger para Historico_de_reservas
CREATE OR REPLACE TRIGGER trg_historico_de_reservas
BEFORE INSERT ON Historico_de_reservas
FOR EACH ROW
WHEN (NEW.id_historico IS NULL)
BEGIN
    SELECT seq_historico_de_reservas.NEXTVAL INTO :NEW.id_historico FROM dual;
END;
/

-- Criando a tabela promocao
CREATE TABLE promocao (
    id_cliente NUMBER,
    id_historico NUMBER,
    estado_anterior NUMBER,
    estado_atual NUMBER,
    data_inicio DATE,
    data_fim DATE,
    percentagem Decimal(5,2),
    PRIMARY KEY (id_cliente, id_historico),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (estado_anterior) REFERENCES Estados_reserva(id_estado),
    FOREIGN KEY (estado_atual) REFERENCES Estados_reserva(id_estado)
);


-- Criando sequência para promocao
CREATE SEQUENCE seq_promocao START WITH 1 INCREMENT BY 1;

-- Criando trigger para promocao
CREATE OR REPLACE TRIGGER trg_promocao
BEFORE INSERT ON promocao
FOR EACH ROW
WHEN (NEW.id_historico IS NULL)
BEGIN
    SELECT seq_promocao.NEXTVAL INTO :NEW.id_historico FROM dual;
END;
/