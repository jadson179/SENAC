DROP DATABASE IF EXISTS DBCONTROLEGASTOS;
CREATE DATABASE DBCONTROLEGASTOS;

USE DBCONTROLEGASTOS;

CREATE TABLE USUARIO (
IDUSUARIO INT NOT NULL PRIMARY KEY AUTO_INCREMENT
, NOME VARCHAR(255)
, CPF CHAR(11)
, TELEFONE CHAR(14)
, LOGIN VARCHAR(255)
, SENHA VARCHAR(255)
);

CREATE TABLE RECEITA (
IDRECEITA INT NOT NULL PRIMARY KEY AUTO_INCREMENT
, IDUSUARIO INT, FOREIGN KEY (IDUSUARIO) REFERENCES USUARIO (IDUSUARIO)
, DESCRICAO VARCHAR(255)
, VALOR DECIMAL(10,2)
, DATARECEITA DATE
);

CREATE TABLE DESPESA (
IDDESPESA INT NOT NULL PRIMARY KEY AUTO_INCREMENT
, IDUSUARIO INT, FOREIGN KEY (IDUSUARIO) REFERENCES USUARIO (IDUSUARIO)
, DESCRICAO VARCHAR(255)
, VALOR DECIMAL(10,2)
, DATAVENCIMENTO DATE
, DATAPAGAMENTO DATE
, CATEGORIA VARCHAR(255)
);