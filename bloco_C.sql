-- Bloco C — Funções agregadas + GROUP BY + HAVING
--1. Faturamento total por estado do cliente.
--Pergunta de negócio: Qual estado gera mais receita para a plataforma?

select 
	c.customer_state "Estado do Cliente",
	SUM(i.price + i.freight_value) "Faturamento total"
from olist_orders_dataset o
join olist_customers_dataset c on c.customer_id = o.customer_id 
join olist_order_items_dataset i on i.order_id = o.order_id 
where o.order_status = 'delivered'
group by c.customer_state 
order by "Faturamento total" desc;
/*
 	aqui realizei uma seleção da coluna "estado do cliente" que esta na tabela customers e juntei com a tabela de pedidos e itens. Desde modo, somei
 	os preços e agrupei pelos estados e depois ordenei em ordem decrescente
 */

--2. Top 10 vendedores por faturamento.
--Pergunta de negócio: Quais são os 10 vendedores que mais faturaram?
select 
	s.seller_id "ID do Vendedor",
	s.seller_city "Cidade do Vendedor",
	s.seller_state "Estado do Vendedor",
	SUM(i.price)  "Faturamento"
from olist_order_items_dataset i 
join olist_sellers_dataset s on s.seller_id = i.seller_id 
group by s.seller_id, s.seller_city, s.seller_state
order by "Faturamento" desc
limit 10;
/*
 aqui quero selecionar as colunas id do vendedor, cidade e estado do vendedor que estão na tabela sellers, e somar os faturamentos dos vendedores
 e listar os 10 que estão no top, do que mais teve faturamento com o desc.
 */

--3. Ticket médio por categoria de produto.
--Pergunta de negócio: Qual o ticket médio por categoria de produto?
select 
    p.product_category_name  "Categoria",
    avg(i.price) "Ticket Médio"
from olist_order_items_dataset i
join olist_products_dataset p on p.product_id = i.product_id
group by p.product_category_name
order by "Ticket Médio" desc;
/*
 	aqui queria selecionar a tabela categoria da tabela products e fazer a média dos produtos de cada categoria.
 */

--4. Vendedores com nota média de avaliação abaixo de 3 (HAVING AVG(...) < 3).
--Pergunta de negócio: Quais vendedores têm reputação crítica (nota média < 3)?
select 
	s.seller_id "ID do Vendedor",
	s.seller_city "Cidade do Vendedor",
	s.seller_state "Estado do Vendedor",
	avg(r.review_score) "Nota Média",
	count(r.review_id) "Total de avaliações"
from olist_order_items_dataset i 
join olist_order_reviews_dataset r on r.order_id = i.order_id
join olist_sellers_dataset s on s.seller_id = i.seller_id 
group by s.seller_id, s.seller_city, s.seller_state
having avg(r.review_score) < 3
	   and 
	   count(r.review_id) >= 10
order by "Nota Média" asc;

/*
  aqui selecionei as colunas id do vendedor, cidade do vendedor e estado do vendedor que estão dentro da tabela seller. Juntei a tabela itens com a
  tabela reviews e a sellers filtrando os vendedores com nota média abaixo de 3, com o minimo de 10 avaliações e ordenei pelo asc.
 */
	   
--5. Quantidade de pedidos por forma de pagamento (GROUP BY payment_type).
--Pergunta de negócio: Quais formas de pagamento são mais usadas?
select
		p.payment_type "Forma de Pagamento",
		count(distinct p.order_id) "Quantidade de Pedidos"
from olist_order_payments_dataset p
group by p.payment_type 
order by "Quantidade de Pedidos" desc;
/*
	aqui selecionei a coluna forma de pagamento da tabela payments, e contei utilizando o count a quantidade de pagamentos por formas, usando o
	distinct para contar pedidos unicos por forma de pagamento e agrupei e ordenei de forma decrescente
 */

--6. Peso médio dos produtos por categoria.
--Pergunta de negócio: Quais categorias têm produtos mais pesados em média?
select 
	o.product_category_name "Categoria",
	avg(o.product_weight_g) "Peso Médio"
from olist_products_dataset o 
group by o.product_category_name
order by "Peso Médio" desc;

/*
 	aqui eu selecionei a coluna categoria da tabela products e fiz a média com AVG para ter a media de peso daquela categoria e mostrei com o desc
 */
 

--7. Número médio de parcelas (AVG(payment_installments)) por categoria de produto.
--Pergunta de negócio: Quais categorias são mais parceladas?
select
		p.product_category_name  "Categoria",
		AVG(payment_installments) "Média de Parcelas"
from olist_order_payments_dataset y
join olist_orders_dataset o on o.order_id = y.order_id
join olist_order_items_dataset i on i.order_id = o.order_id
join olist_products_dataset p on p.product_id = i.product_id
group by p.product_category_name
order by "Média de Parcelas" desc;

/*
 	aqui selecionei a coluna categoria da tabela product e fiz a media das parcelas de pagamento e pra isso utilizei joins que ligam as tabelas
 	payment > orders > items > products. Agrupei pela categoria e deixei em ordem decrescente
 */











