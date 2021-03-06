SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS DBMATRICULA;
CREATE DATABASE DBMATRICULA;
USE DBMATRICULA;

CREATE TABLE ALUNO (
	IDALUNO INT NOT NULL AUTO_INCREMENT
	, NOME VARCHAR(45)
    , PRIMARY KEY (IDALUNO)
);

CREATE TABLE DISCIPLINA(	
	IDDISCIPLINA INT NOT NULL AUTO_INCREMENT
	, NOME VARCHAR(45)
	, DT_INICIO DATE
	, DT_FIM DATE
    , PRIMARY KEY (IDDISCIPLINA)
);

CREATE TABLE MATRICULA (
	IDALUNO INT NOT NULL
	, IDMATRICULA INT NOT NULL
    , IDDISCIPLINA INT NOT NULL
	, DT_MATRICULA DATE
    , PRIMARY KEY (IDALUNO, IDMATRICULA)
    , FOREIGN KEY (IDALUNO) REFERENCES ALUNO (IDALUNO)
    , FOREIGN KEY (IDDISCIPLINA) REFERENCES DISCIPLINA (IDDISCIPLINA)
);



/*
Regra:
O CAMPO DT_MATRICULA DEVE SER PREENCHIDO NO MOMENTO DO INSERT
O campo DT_MATRICULA NÃO PODE SER MENOR QUE DT_FIM DA DISCIPLINA
O CAMPO DT_FIM DA DISCIPLINA NÃO PODE SER MENOR QUE DT_INICIO DA DISCIPLINA
CASO JA TENHA ALUNO MATRICULA A DT_INICIO E DT_FIM NÃO PODE SER ALTERADO;
*/


DELIMITER $$

CREATE TRIGGER TR_MATRICULA_BI BEFORE INSERT ON MATRICULA FOR EACH ROW 

BEGIN
    DECLARE vDT_FIM DATE;
    DECLARE vDT_INICIO DATE;
    

    SET NEW.DT_MATRICULA = NOW();

    SELECT 
    DT_FIM,DT_INICIO
    INTO vDT_FIM,vDT_INICIO
    FROM DISCIPLINA 
    WHERE 
        IDDISCIPLINA = NEW.IDDISCIPLINA;


    IF NEW.DT_MATRICULA > vDT_FIM THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="A DATA DA MATRICULA NÃO PODE SER MAIOR QUE DT_INICIO DA DISCIPLINA";
    END IF;

    IF NEW.DT_MATRICULA > vDT_INICIO THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="A DATA DA MATRICULA NÃO PODE SER MAIOR QUE DT_FIM DA DISCIPLINA";
    END IF;

END $$

CREATE TRIGGER TR_DISCIPLINA_BI BEFORE INSERT ON DISCIPLINA FOR EACH ROW 
BEGIN 
    
    IF NEW.DT_FIM < NEW.DT_INICIO THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="A DATA DA DISCIPLINA NÃO PODE SER MENOR QUE DT_INICIO DA DISCIPLINA";
    END IF;

END $$

CREATE TRIGGER TR_MATRICULA_BU BEFORE UPDATE ON MATRICULA FOR EACH ROW 
BEGIN
    DECLARE vDT_FIM DATE;
    DECLARE vDT_INICIO DATE;
    

    SET NEW.DT_MATRICULA = NOW();

    SELECT 
    DT_FIM,DT_INICIO
    INTO vDT_FIM,vDT_INICIO
    FROM DISCIPLINA 
    WHERE 
        IDDISCIPLINA = NEW.IDDISCIPLINA;


    IF NEW.DT_MATRICULA > vDT_FIM THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="A DATA DA MATRICULA NÃO PODE SER MAIOR QUE DT_INICIO DA DISCIPLINA";
    END IF;

    IF NEW.DT_MATRICULA > vDT_INICIO THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="A DATA DA MATRICULA NÃO PODE SER MAIOR QUE DT_FIM DA DISCIPLINA";
    END IF;
END $$

CREATE TRIGGER TR_DISCIPLINA_BU BEFORE UPDATE ON DISCIPLINA FOR EACH ROW 
BEGIN
    DECLARE vSTATUS INT;

    SELECT 
    COUNT(MATRICULA.IDMATRICULA)
    INTO vSTATUS
    FROM MATRICULA 
	INNER JOIN DISCIPLINA ON 
        MATRICULA.IDDISCIPLINA = DISCIPLINA.IDDISCIPLINA
    WHERE 
	   MATRICULA.IDDISCIPLINA = NEW.IDDISCIPLINA;

    IF(vSTATUS <> 0 ) THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="JÁ EXISTE MATRICULAS VINCULADAS AO ALUNO";
    END IF; 
    
END $$

DELIMITER ;

INSERT INTO ALUNO (IDALUNO, NOME) VALUES (1,"JADSON");
INSERT INTO DISCIPLINA (IDDISCIPLINA, NOME, DT_INICIO, DT_FIM) VALUES (1,"SEXO","2015-12-17","2016-12-17");
INSERT INTO MATRICULA (IDALUNO, IDMATRICULA,IDDISCIPLINA,DT_MATRICULA) VALUES (1,1,1,NULL);
UPDATE DISCIPLINA SET DT_INICIO = "2020-10-01", DT_FIM="2020-10-01" WHERE IDDISCIPLINA = 1