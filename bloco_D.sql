-- Bloco D — Subqueries
--1. Clientes cujo gasto total está acima da média geral de gasto por cliente.
--Pergunta de negócio:Quem são os clientes que gastam mais que a média?
select 
		c.customer_unique_id,
		c.customer_city,
		c.customer_state,
		SUM(i.price + i.freight_value)  "gasto total"
from olist_customers_dataset c
join olist_orders_dataset o on o.customer_id = c.customer_id 
join olist_order_items_dataset i on i.order_id = o.order_id 
group by c.customer_unique_id, c.customer_city, c.customer_state
having SUM(i.price + i.freight_value) > (
			select avg(gasto_por_cliente)
			from (
			select
				c.customer_unique_id,
				SUM(i.price + i.freight_value) as gasto_por_cliente
			from olist_customers_dataset c
			join olist_orders_dataset o on o.customer_id = c.customer_id 
			join olist_order_items_dataset i on i.order_id = o.order_id 
			group by c.customer_unique_id 
			)
)
order by "gasto total" asc
limit 10;
/*aqui eu selecionei o id do cliente, a cidade e o estado que estão na tabela customers, juntei com a tabela de pedidos e de itens e somei o preço
 com o frete para ter o gasto total de cada cliente. Depois usei uma subquery para calcular a média geral de gasto por cliente e filtrei com o 
 having apenas os clientes que gastam acima dessa média. Por fim, ordenei do menor para o maior e limitei a 10 registros.
 */

--2. Produtos que nunca receberam avaliação (NOT EXISTS / NOT IN).
--Pergunta de negócio: Existem produtos vendidos que jamais foram avaliados?

select *
from olist_products_dataset p
where p.product_id not in (
		select 
			i.product_id
		from olist_order_items_dataset i
		join olist_order_reviews_dataset r on r.order_id = i.order_id 
);

/* Aqui selecionei todos os produtos e usei not in para tirar os que já têm avaliação.A subquery traz os product_id que aparecem em pedidos 
 avaliados. E o not in filtra só os que não estão nessa lista.
 */

--3. Vendedores que venderam produtos de mais de 5 categorias diferentes (subquery com COUNT(DISTINCT ...)).
--Pergunta de negócio: Quais vendedores têm catálogo mais variado?
select *
from (
    select
        s.seller_id,
        count(distinct p.product_category_name)  "Categorias Diferentes"
    from olist_order_items_dataset i
    join olist_sellers_dataset s on s.seller_id = i.seller_id
    join olist_products_dataset p on p.product_id = i.product_id
    group by s.seller_id
    ) 
where "Categorias Diferentes" > 5
order by "Categorias Diferentes" desc;

-- Usei subquery com count(distinct categoria) para contar categorias diferentes por vendedor e filtrei os que têm mais de 5.

--4. Pedidos cujo valor de frete (freight_value) é maior que o valor total dos itens do próprio pedido (subquery correlacionada comparando as 
--duas somas).
--Pergunta de negócio: Existem pedidos em que o frete custa mais que os produtos?
SELECT 
    i.order_id AS "Pedido",
    SUM(i.freight_value) AS "Total Frete",
    SUM(i.price) AS "Total Itens"
FROM olist_order_items_dataset i
GROUP BY i.order_id
HAVING SUM(i.freight_value) > 
(
    SELECT SUM(i2.price)
    FROM olist_order_items_dataset i2
    WHERE i2.order_id = i.order_id
)
LIMIT 10;
-- Somei o frete por pedido com GROUP BY e usei uma subquery correlacionada no HAVING para comparar com a soma dos preços.



