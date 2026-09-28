--Bloco A — SELECT básico

-- 1. Listar os 20 pedidos com status delivered mais recentes, ordenados pela data de entrega.
--Pergunta de negócio: Quais foram os últimos pedidos efetivamente entregues?
select
    o.order_id,
    o.customer_id,
    o.order_delivered_customer_date
from olist_orders_dataset o
where o.order_status = 'delivered'
order by o.order_delivered_customer_date desc
limit 20;
/* Eu selecionei as colunas "order_id", "customer_id", "order_delivered_customer_date" da tabela "olist_orders_dataset" que apelidei de "o".
Então foi feita uma seleção dos 20 primeiros pedidos com status "delivered", em ordem de entrega do mais recente com o order by "desc".
*/
                                             
-- 2. Listar todos os produtos de uma categoria específica (usando a tabela de tradução para filtrar pelo nome em português).
--Pergunta de negócio: Quais produtos pertencem a uma categoria específica?

select * from product_category_name_translation   

select *                                          
from olist_products_dataset o 
where o.product_category_name = 'beleza_saude';

/* Para esta pergunta usei 2 selects separados, o primeiro foi para visualizar os nomes das categorias em português, usando a tabela "product_category_name_translation
 escolhendo então a categoria "beleza_saude" usei outro select para filtrar somente ela.
 */
	
--3. Listar os métodos de pagamento distintos utilizados na base (SELECT DISTINCT payment_type).
--Pergunta de negócio: Quais formas de pagamento existem na base?
select distinct p.payment_type
from olist_order_payments_dataset p 
order by p.payment_type;

/* aqui usei o distinct para visualizar os metodos de pagamentos distintos, usando a coluna "payment_type" que esta dentro da tabela 
olist_order_payments_dataset que apelidei de "p", depois ordenei com o "order by"
 */

-- 4. Listar os produtos com peso (product_weight_g) acima de 10kg, ordenados do mais pesado para o mais leve.
--Pergunta de negócio: Quais produtos pesam mais de 10kg?

select 
	o.product_id,
	o.product_category_name,
	o.product_weight_g
from olist_products_dataset o
where product_weight_g > '10000'
order by product_weight_g desc
/*
 Aqui selecionei as colunas "product_id", "product_category_name" e "product_weight_g" que estão na tabela "olist_products_dataset" que apelidei 
 de "o" e busquei os produtos com peso maior que 10kg e ordenei do mais pesado para o mais leve usando o order by desc
 */

