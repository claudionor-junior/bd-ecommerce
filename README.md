# Projeto Lógico de Banco de Dados - E-commerce

## Descrição

Este projeto contempla o modelo lógico para um banco de dados de sistema de e-commerce, contendo entidades que representam clientes (Pessoa Física e Jurídica), fornecedores, vendedores, produtos, estoque, pedidos, pagamentos e entregas.

- Uma conta de cliente pode ser Pessoa Física (PF) ou Pessoa Jurídica (PJ), nunca ambas.
- Um cliente pode possuir múltiplos endereços.
- Pedidos são compostos por múltiplos itens.
- Um pedido pode ter várias formas de pagamento.
- A entrega possui status e código de rastreio.
- Relacionamento N:N entre vendedores e fornecedores para modelar casos em que um vendedor também seja fornecedor.

As tabelas estão normalizadas, com uso adequado de chaves primárias, estrangeiras e constraints para garantir a integridade dos dados.

## Scripts

- Criação do esquema do banco.
- Inserção de dados de teste.
- Consultas SQL complexas para recuperar informações de negócio, como total de pedidos por cliente, relação entre vendedores e fornecedores, controle de estoque e análise de gastos.

## Objetivo

Este modelo lógico visa dar suporte a funcionalidades típicas de um sistema de e-commerce, facilitando a gestão comercial, estoque, vendas, pagamentos e entregas com rastreamento.

