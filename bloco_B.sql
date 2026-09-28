--Bloco B — JOINs

-- 1. Relatório com categoria do produto (traduzida), valor do item, cidade do vendedor.
--Pergunta de negócio: O que foi vendido, por quanto e de onde veio o vendedor?
select  
	coalesce(t.product_category_name_english, p.product_category_name) AS "Categoria",
	i.price as "Preço",
	s.seller_city as "Cidade do Vnededor",
	s.seller_state as "Estado do Vendedor"
from olist_order_items_dataset i 
join olist_products_dataset p on i.product_id = p.product_id
join olist_sellers_dataset s on i.seller_id = s.seller_id
left join product_category_name_translation t on t.product_category_name = p.product_category_name 
limit 100;

/*
Aqui estou juntando as tabelas dos itens, dos produtos e dos vendedores, com join para junta-las.
*/


-- 2. Identificar pedidos com atraso na entrega, comparando data estimada com data real de entrega (join entre orders e customers).
--Pergunta de negócio: Quais pedidos chegaram depois da data prometida?
SELECT
		o.order_id,
		c.customer_city,
		c.customer_state,
		o.order_estimated_delivery_date AS estimativa_entrega,
		o.order_delivered_customer_date AS entregue_ao_cliente_em,
	(
		COALESCE(
			NULLIF(o.order_delivered_customer_date, '')::date,
			CURRENT_DATE
		)
            -NULLIF(o.order_estimated_delivery_date, '')::date
	) AS dias_atraso
FROM olist_orders_dataset o
JOIN olist_customers_dataset c 
	ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
AND COALESCE(
		NULLIF(o.order_delivered_customer_date, '')::date,
		CURRENT_DATE
		) > NULLIF(o.order_estimated_delivery_date, '')::date
ORDER BY dias_atraso desc
LIMIT 20;

/*
 	Aqui estou fazendo uma consulta que me mostre as colunas de cidade e estado do cliente, estimativa de entrega e data que foi entregue,
 	mostrando apenas os que possuem atraso, ordenei por "dias de atraso" com desc, e limitei para 20 pedidos, pois alguns estão sem a data de entrega
 */

--3. Listar pedidos e suas formas de pagamento, incluindo pedidos pagos em mais de uma parcela (join entre orders e order_payments).
--Pergunta de negócio: Quais são as formas de pagamento dos pedidos?
select 
	o.order_id "Pedido",
	p.payment_type "Forma de Pagamento",
	p.payment_installments "Parcelas"
from olist_orders_dataset o
join olist_order_payments_dataset p on p.order_id = o.order_id
limit 15;
/*
 aqui selecionei a coluna de pedidos, forma de pagamento e quantidade de parcelas, juntei com join a tabela payments com orders para que listassem
 todos os pedidos que estão em ambas as tabelas, e limitei 15 para ficar mais fácil de visualizar
 */

--4. Listar produtos junto com a categoria traduzida, incluindo produtos cuja categoria não possui tradução cadastrada (LEFT JOIN com
--product_category_name_translation).
--Pergunta de negócio: Quais produtos não têm tradução de categoria cadastrada?

select  
	coalesce(t.product_category_name_english, p.product_category_name) AS "Categoria",
	i.price as "Preço",
	s.seller_city as "Cidade do Vnededor",
	s.seller_state as "Estado do Vendedor"
from olist_order_items_dataset i 
join olist_products_dataset p on i.product_id = p.product_id
join olist_sellers_dataset s on i.seller_id = s.seller_id
left join product_category_name_translation t on t.product_category_name = p.product_category_name 
limit 100;

/*
Aqui estou juntando as tabelas dos itens, dos produtos e dos vendedores, com join para junta-las.E um left join para ter a categoria traduzida
e incluir as que nao tem tradução também.
*/

-- 5. Identificar pedidos em que o cliente e o vendedor são do mesmo estado (join entre customers, orders, order_items e sellers).
--Pergunta de negócio: Em quais pedidos o cliente e o vendedor são do mesmo estado?
select 
	o.order_id "Pedidos",
	c.customer_state "Estado do Cliente",
	s.seller_state "Estado do Vendedor"
from olist_orders_dataset o
join olist_customers_dataset c on o.customer_id = c.customer_id 
join olist_order_items_dataset i on i.order_id = o.order_id
join olist_sellers_dataset s on i.seller_id = s.seller_id 
where c.customer_state = s.seller_state;

/*
  Aqui estou selecionando os pedidos, estado do cliente e estado do vendedor (para saber quais foram as vendas locais). Partindo da tabela
  orders, e juntando com as tabelas custumers e items.Juntando a tabela items com a sellers para saber se são do mesmo estado (cliente e vendedor)
 */




