-- Script de criação do esquema para e-commerce

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    tipo_cliente CHAR(2) NOT NULL,
    CONSTRAINT chk_tipo_cliente CHECK (tipo_cliente IN ('PF', 'PJ'))
);

CREATE TABLE Endereco (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    rua VARCHAR(150),
    cidade VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Fornecedor (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE Vendedor (
    id_vendedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE VendedorFornecedor (
    id_vendedor INT NOT NULL,
    id_fornecedor INT NOT NULL,
    PRIMARY KEY (id_vendedor, id_fornecedor),
    FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor),
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

CREATE TABLE Produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    id_fornecedor INT NOT NULL,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

CREATE TABLE Estoque (
    id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade >= 0),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE ItemPedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

CREATE TABLE Pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL CHECK (valor >= 0),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

CREATE TABLE Entrega (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- Inserção de dados de teste

INSERT INTO Cliente (nome, email, tipo_cliente) VALUES
('João Silva', 'joao@mail.com', 'PF'),
('Empresa XPTO', 'contato@xpto.com', 'PJ');

INSERT INTO Endereco (id_cliente, rua, cidade) VALUES
(1, 'Rua A, 123', 'São Paulo'),
(2, 'Av. B, 456', 'Rio de Janeiro');

INSERT INTO Fornecedor (nome, telefone) VALUES
('Fornecedor 1', '1111-2222'),
('Fornecedor 2', '3333-4444');

INSERT INTO Vendedor (nome, telefone) VALUES
('Carlos Vendedor', '9999-8888'),
('Maria Vendedora', '7777-6666');

INSERT INTO VendedorFornecedor (id_vendedor, id_fornecedor) VALUES
(1, 1), -- Carlos é fornecedor 1
(2, 2); -- Maria é fornecedor 2

INSERT INTO Produto (nome, descricao, preco, id_fornecedor) VALUES
('Produto A', 'Descrição A', 100.00, 1),
('Produto B', 'Descrição B', 50.00, 2);

INSERT INTO Estoque (id_produto, quantidade) VALUES
(1, 10),
(2, 20);

INSERT INTO Pedido (id_cliente, data_pedido) VALUES
(1, NOW()),
(2, NOW());

INSERT INTO ItemPedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 100.00),
(1, 2, 1, 50.00),
(2, 2, 3, 50.00);

INSERT INTO Pagamento (id_pedido, forma_pagamento, valor) VALUES
(1, 'Cartão de Crédito', 250.00),
(2, 'Boleto', 150.00);

INSERT INTO Entrega (id_pedido, status, codigo_rastreio) VALUES
(1, 'Enviado', 'BR123456789BR'),
(2, 'Processando', NULL);

-- Queries complexas

-- 1) Quantos pedidos foram feitos por cada cliente?
SELECT c.nome, COUNT(p.id_pedido) AS total_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_pedidos DESC;

-- 2) Algum vendedor também é fornecedor?
SELECT v.nome AS vendedor, f.nome AS fornecedor
FROM Vendedor v
JOIN VendedorFornecedor vf ON v.id_vendedor = vf.id_vendedor
JOIN Fornecedor f ON vf.id_fornecedor = f.id_fornecedor
ORDER BY v.nome;

-- 3) Relação de produtos, fornecedores e estoques
SELECT p.nome AS produto, f.nome AS fornecedor, e.quantidade AS estoque
FROM Produto p
JOIN Fornecedor f ON p.id_fornecedor = f.id_fornecedor
LEFT JOIN Estoque e ON p.id_produto = e.id_produto
ORDER BY p.nome;

-- 4) Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.nome AS fornecedor, p.nome AS produto
FROM Fornecedor f
JOIN Produto p ON f.id_fornecedor = p.id_fornecedor
ORDER BY f.nome, p.nome;

-- 5) Total gasto por cliente (atributo derivado)
SELECT c.nome, SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
JOIN ItemPedido ip ON p.id_pedido = ip.id_pedido
GROUP BY c.id_cliente, c.nome
HAVING total_gasto > 0
ORDER BY total_gasto DESC;
