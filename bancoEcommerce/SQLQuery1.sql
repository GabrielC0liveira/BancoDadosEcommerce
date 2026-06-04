CREATE DATABASE ecommerceDB;
GO
 
USE eCommerceDB;
GO
 
CREATE TABLE Clientes (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
    nomeCliente VARCHAR(100) NOT NULL,
    emailCliente VARCHAR(150) UNIQUE,
    dataCadastroCliente DATETIME DEFAULT GETDATE()
);
 
CREATE TABLE Produtos (
    idProduto INT IDENTITY(1,1) PRIMARY KEY,
    nomeProduto VARCHAR(100),
    precoProdutos DECIMAL(10,2),
    estoqueProdutos INT,
    CONSTRAINT cKPrecoPositivo
    CHECK (precoProdutos > 0)
);
 
CREATE TABLE Pedidos (
    idPedidos INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT,
    dataPedidos DATETIME,
    valorTotalPedidos DECIMAL(10,2),
    CONSTRAINT FK_Pedidos_Clientes
    FOREIGN KEY (idCliente)
    REFERENCES Clientes(idCliente)
);
 
CREATE TABLE #LogAcessos (
    usuario VARCHAR(50),
    dataHora DATETIME
);
 
INSERT INTO Clientes (nomeCliente, emailCliente)
VALUES ('Lucas Santos', 'lucas@email.com');
 
INSERT INTO Produtos (NomeProduto, precoProdutos, estoqueProdutos)
VALUES
('Fundamentos de desenvolvimento web back-end', 57.99, 10),
('Gabinete gamer', 250.00, 5),
('Memoria RAM 32GB', 2500.00, 15);
 
INSERT INTO Pedidos (idCliente, dataPedidos, valorTotalPedidos)
VALUES (1, GETDATE(), 120.00);
 
CREATE TABLE HistoricoClientes (
    idHistoricoCliente INT,
    nomeHistoricoCliente VARCHAR(100),
    emailHistoricoCliente VARCHAR(150),
    dataCadastroHistoricoCliente DATETIME
);
 
INSERT INTO HistoricoClientes
SELECT * FROM Clientes;
 
UPDATE Clientes
SET emailCliente = 'novo_email@provedor.com'
WHERE idCliente = 1;
 
UPDATE Produtos
SET precoProdutos = precoProdutos * 1.10;
 
UPDATE Produtos
SET
    NomeProduto = 'Teclado Mecânico',
    estoqueProdutos = 50
WHERE idProduto = 3;
 
UPDATE Produtos
SET estoqueProdutos = estoqueProdutos - 1
WHERE idProduto = 2;
 
 
DELETE FROM Clientes
WHERE idCliente = 5;
 
DELETE FROM Produtos
WHERE estoqueProdutos = 0
AND precoProdutos < 10.00;
 
DELETE FROM Pedidos;
 
DELETE TOP (3)
FROM Pedidos
WHERE valorTotalPedidos = 0;
 
DELETE TOP (10) PERCENT
FROM Pedidos;
 
WITH CTE_Duplicados AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY emailCliente
               ORDER BY idCliente ASC
           ) AS RN
    FROM Clientes
)
DELETE TOP (1)
FROM CTE_Duplicados
WHERE RN > 1;
 
ALTER TABLE Clientes
ADD telefoneCliente VARCHAR(20) NULL;
 
ALTER TABLE Produtos
ALTER COLUMN nomeProduto VARCHAR(250);
 
ALTER TABLE HistoricoClientes
DROP COLUMN dataCadastroHistoricoCliente;
 
ALTER TABLE Produtos
ADD CONSTRAINT DF_Produtos_Estoque
DEFAULT 0 FOR estoqueProdutos;
 
CREATE VIEW vwProdutosDisponiveis AS 
SELECT nomeProduto, precoProdutos
FROM Produtos
WHERE estoqueProdutos > 0;
GO
 
CREATE VIEW vwResumoPedidos AS
SELECT
    C.nomeCliente,
    P.dataPedidos,
    P.valorTotalPedidos
FROM Clientes C
INNER JOIN Pedidos P
    ON C.idCliente = P.idCliente;
GO
 
ALTER VIEW vwResumoPedidos AS
SELECT
    C.nomeCliente,
    C.emailCliente,
    P.dataPedidos,
    P.valorTotalPedidos
FROM Clientes C
INNER JOIN Pedidos P
    ON C.idCliente = P.idCliente;
GO
 
CREATE VIEW vwDadosSensiveis
WITH ENCRYPTION
AS
SELECT nomeCliente, emailCliente
FROM Clientes;
GO
 
DROP VIEW vwProdutosDisponiveis;
GO
 
CREATE TABLE tabelaRascunho (
    ID INT
);
 
DROP TABLE tabelaRascunho;
 
DROP TABLE IF EXISTS ConfiguracoesAntigas;
 
ALTER TABLE Pedidos
DROP CONSTRAINT FK_Pedidos_Clientes;
 
DROP TABLE Clientes;