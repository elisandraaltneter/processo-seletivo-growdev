# Desafio SQL 

## Sobre o projeto

Este repositório contém a resolução do desafio SQL do processo seletivo Growdev  utilizando o dataset público **Olist Brazilian E-Commerce**.

O objetivo foi explorar a base, entender seu modelo de dados e construir consultas SQL que respondem a perguntas de negócio reais.

## Estrutura do repositório

- `bloco_A.sql` — SELECT básico
- `bloco_B.sql` — JOINs
- `bloco_C.sql` — Funções agregadas + GROUP BY + HAVING
- `bloco_D.sql` — Subqueries
- `bloco_E.sql` — CASE WHEN
- `bloco_F.sql` — CTEs
- `bloco_G.sql` — Views
- `bloco_H.sql` — Procedures
- `bloco_I.sql` — Window Functions

## Principais insights

- Os 20 pedidos mais recentes com status `delivered` estão concentrados em 2018-09-12 à 2018-10-17.
- A categoria `beleza_saude` tem 2444 produtos cadastrados.
- As formas de pagamento mais comuns são boleto, credit_card, debit_card e voucher.
- Existem 1891 produtos com peso acima de 10kg.
- O estado que mais gera receita é SP, com R$ 5.769.791,50.
- O vendedor com maior faturamento possui R$ 229.473,58 em vendas.
- A categoria pcs é a que possui o maior ticket médio com R$ 1.098,34.
- Existem 34 vendedores com nota média de avaliação abaixo de 3.
- A forma de pagamento mais usada é "credit_card", com 76505 pedidos.
- A categoria com produtos mais pesados em média é "moveis_colchao_e_estofado", com 13.190g.
- A categoria com maior média de parcelas é "pcs", com média de 6,01.
- Existem 188 vendedores que venderam produtos de mais de 5 categorias diferentes.
- Os 3 estados com maior frete médio acima da média geral são RR, PB e RO.
- A view `vw_pedidos_completos` consolida pedido, cliente, itens, pagamento e vendedor.
- A view `vw_avaliacoes_categoria` consolida nota média e volume de avaliações por categoria.
- A function `sp_relatorio_vendedor` retorna faturamento, ticket médio e nota média por vendedor em um período.
-A function `sp_relatorio_categoria` retorna faturamento total e ticket médio por categoria em um período.

## Tecnologias usadas

- PostgreSQL 18
- DBeaver Community
- Dataset Olist Brazilian E-Commerce

## Como rodar

1. Instale o PostgreSQL localmente;
2. Instale o DBeaver Community;
3. Baixe o dataset Olist no Kaggle;
4. Importe os CSVs no PostgreSQL via DBeaver;
5. Execute os scripts.

