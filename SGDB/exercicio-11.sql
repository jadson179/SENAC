SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS DBPEDIDO;
CREATE DATABASE DBPEDIDO;

USE DBPEDIDO;

CREATE TABLE PRODUTO (
	IDPRODUTO INT NOT NULL AUTO_INCREMENT
    , NOME VARCHAR(45)
    , ESTOQUE INT
	, PRIMARY KEY(IDPRODUTO)
);

CREATE TABLE COMPRA (
	IDCOMPRA INT NOT NULL AUTO_INCREMENT
    , IDPRODUTO INT NOT NULL
	, QTDE INT
    , PRECOUNITARIO NUMERIC(8,2)
    , PRIMARY KEY (IDCOMPRA)
    , FOREIGN KEY (IDPRODUTO) REFERENCES PRODUTO(IDPRODUTO)
);

CREATE TABLE VENDA (
	IDVENDA INT NOT NULL AUTO_INCREMENT
    , IDPRODUTO INT NOT NULL
	, QTDE INT
    , PRECOUNITARIO NUMERIC(8,2)
    , PRIMARY KEY (IDVENDA)
    , FOREIGN KEY (IDPRODUTO) REFERENCES PRODUTO(IDPRODUTO)
);


DELIMITER $$ 

CREATE TRIGGER TR_COMPRAS_AI AFTER INSERT ON COMPRA FOR EACH ROW
BEGIN

    UPDATE 
    PRODUTO
    SET ESTOQUE = ESTOQUE + NEW.QTDE WHERE IDPRODUTO = NEW.IDPRODUTO;

END $$


CREATE TRIGGER TR_VENDAS_BI BEFORE INSERT ON VENDA FOR EACH ROW
BEGIN
    UPDATE 
    PRODUTO
    SET ESTOQUE = ESTOQUE - NEW.QTDE
    WHERE IDPRODUTO = NEW.IDPRODUTO;

END $$


CREATE TRIGGER TR_COMPRA_AD AFTER DELETE ON COMPRA FOR EACH ROW 
BEGIN   
    DECLARE QTD_PRODUTO INT;


    SELECT 
        PRODUTO.ESTOQUE
    INTO QTD_PRODUTO
    FROM PRODUTO
    WHERE  
        IDPRODUTO = OLD.IDPRODUTO;


    IF (QTD_PRODUTO <  OLD.QTDE ) THEN 
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ESTOQUE INSUFICIENTE PARA CANCELAR A COMPRA';
    ELSE 
         UPDATE
        PRODUTO
        SET ESTOQUE = ESTOQUE - OLD.QTDE
        WHERE 
            IDPRODUTO = OLD.IDPRODUTO;
    END IF;

END $$


CREATE TRIGGER TR_VENDA_AD AFTER DELETE ON VENDA FOR EACH ROW 
BEGIN
    DECLARE QTD_PRODUTO INT; 

    SELECT 
        PRODUTO.ESTOQUE
    INTO QTD_PRODUTO
    FROM PRODUTO
    WHERE  
        IDPRODUTO = OLD.IDPRODUTO;
    
    
    UPDATE 
    PRODUTO
    SET ESTOQUE = ESTOQUE + OLD.QTDE
    WHERE 
        IDPRODUTO = OLD.IDPRODUTO;
END $$

CREATE TRIGGER TR_VENDAS_BI BEFORE INSERT ON VENDA FOR EACH ROW
BEGIN

    DECLARE QTD_PRODUTO INT;

    SELECT 
        PRODUTO.ESTOQUE 
    INTO QTD_PRODUTO
    FROM PRODUTO 
    WHERE 
        PRODUTO.IDPRODUTO = NEW.IDPRODUTO;

    IF (QTD_PRODUTO <= NEW.QTDE) THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NÃO FOI POSSÍVEL REALIZAR A VENDA POIS A QUANTIDADE DE VENDA É MAIOR QUE A QUANTIDADE EM ESTOQUE PRESENTE';
    END IF;
END $$

CREATE TRIGGER TR_COMPRA_BU  BEFORE UPDATE ON COMPRA FOR EACH ROW
BEGIN

    DECLARE vQTDESTOQUE INT;

    SELECT
        ESTOQUE
    INTO vQTDESTOQUE
    FROM PRODUTO
    WHERE IDPRODUTO = OLD.IDPRODUTO;

    IF OLD.IDPRODUTO = NEW.IDPRODUTO THEN   
        
        IF OLD.QTD <= NEW.QTDE THEN
            UPDATE PRODUTO
            SET ESTOQUE + (NEW.QTDE - OLD.QTDE)
            WHERE 
                IDPRODUTO = NEW.IDPRODUTO;
        ELSE IF vQTDESTOQUE < (OLD.QTDE - NEW.QTDE) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ESTOQUE INSUFICIENTE PARA ALTERAR';
        ELSE 
            UPDATE PRODUTO
            SET ESTOQUE = ESTOQUE - (OLD.QTDE - NEW.QTDE)
            WHERE IDPRODUTO = NEW.IDPRODUTO;
            END IF;
        END IF;
    ELSE
        IF vQTDESTOQUE < OLD.QTDE THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ESTOQUE INSUFICIENTE PARA ALTERAR';
        ELSE  
            UPDATE PRODUTO
            SET ESTOQUE = ESTOQUE - OLD.QTDE
            WHERE IDPRODUTO = OLD.IDPRODUTO;

            UPDATE PRODUTO
            SET ESTOQUE = ESTOQUE + NEW.QTDE
            WHERE 
                IDPRODUTO = NEW.IDPRODUTO;
        END IF;
    END IF;


END $$ 

CREATE TRIGGER TR_VENDAS_AU AFTER UPDATE ON VENDA FOR EACH ROW
BEGIN
    DECLARE vQTDEESTOQUE INT;

    SELECT 
    PRODUTO
    INTO vQTDEESTOQUE 
    FROM PRODUTO
    WHERE 
        IDPRODUTO = NEW.PRODUTO;

    IF OLD.IDPRODUTO = NEW.IDPRODUTO THEN 
        IF NEW.QTDE <= OLD.QTDE THEN
            UPDATE PRODUTO
            SET ESTOQUE = ESTOQUE + (OLD.QTDE - NEW.QTDE)
            WHERE IDPRODUTO = OLD.IDPRODUTO;
        ELSE 
            
            IF vQTDEESTOQUE < (NEW.QTDE - OLD.QTDE) THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ESTOQUE INSUFICIENTE PARA ALTERAR A VENDA';
            ELSE 
                UPDATE PRODUTO
                SET ESTOQUE = ESTOQUE - (NEW.QTDE - OLD.QTDE)
                WHERE IDPRODUTO = OLD.IDPRODUTO;
            END IF;
        END IF;

    ELSE
        IF vQTDEESTOQUE < NEW.QTDE THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ESTOQUE INSUFICIENTE PARA ALTERAR A VENDA';
        ELSE 
                UPDATE PRODUTO
                SET ESTOQUE = ESTOQUE - OLD.QTDE
                WHERE IDPRODUTO = OLD.IDPRODUTO;

                UPDATE PRODUTO
                SET ESTOQUE = ESTOQUE + NEW.QTDE
                WHERE IDPRODUTO = NEW.IDPRODUTO;
        END IF;
    END IF;

END $$
DELIMITER ;

INSERT INTO PRODUTO (NOME,ESTOQUE) VALUES ("PAPEL",0);
INSERT INTO COMPRA (IDCOMPRA,IDPRODUTO,QTDE,PRECOUNITARIO) VALUES (NULL,1,50,1);
INSERT INTO VENDA (IDVENDA,IDPRODUTO,QTDE,PRECOUNITARIO) VALUES (NULL,1,40,1);
DELETE FROM COMPRA WHERE IDPRODUTO  = 1;
DELETE FROM VENDA WHERE IDVENDA = 1;
INSERT INTO VENDA (IDVENDA,IDPRODUTO,QTDE,PRECOUNITARIO) VALUES (NULL,1,520,1);
