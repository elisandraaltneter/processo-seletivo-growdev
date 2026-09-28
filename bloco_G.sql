--Bloco G — View
--1. Criar a view vw_pedidos_completos, consolidando pedido, cliente, itens, pagamento e vendedor, para servir de base a consultas analíticas futuras.
--Pergunta de negócio: Ter uma base consolidada para consultas analíticas futuras
create view vw_pedidos_completos as
select 
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    c.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    i.order_item_id,
    i.product_id,
    i.seller_id,
    i.price,
    i.freight_value,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    s.seller_city,
    s.seller_state
from olist_orders_dataset o
join olist_customers_dataset c on c.customer_id = o.customer_id
join olist_order_items_dataset i on i.order_id = o.order_id
join olist_order_payments_dataset p on p.order_id = o.order_id
join olist_sellers_dataset s on s.seller_id = i.seller_id;

select * from vw_pedidos_completos limit 10; -- aqui estou visualizando para garantir que a  view foi criada.
/*
 aqui eu criei uma view que junta as 5 tabelas principais: orders, customers, order_items, payments e sellers.Peguei as colunas mais importantes de 
 cada uma para ter uma base completa de pedidos, clientes, itens, pagamentos e vendedores. Usei JOIN para ligar as tabelas pelos IDs em comum 
 (order_id, customer_id, product_id, seller_id).
 */

--2. Criar a view vw_avaliacoes_categoria, consolidando nota média e volume de avaliações por categoria de produto
--Pergunta de negócio: Quais categorias têm pior reputação na plataforma?
create view vw_avaliacoes_categoria as
select
    p.product_category_name "Categoria",
    COUNT(r.review_id)  "Volume Avaliacoes",
    AVG(r.review_score)  "Nota Média"
from olist_order_reviews_dataset r
join olist_orders_dataset o on o.order_id = r.order_id
join olist_order_items_dataset i on i.order_id = o.order_id
join olist_products_dataset p on p.product_id = i.product_id
group by p.product_category_name;

select * from vw_avaliacoes_categoria limit 10; -- aqui estou visualizando para garantir que a  view foi criada.
/*
 aqui eu criei uma view que junta as tabelas reviews, orders, order_items e products para calcular a nota média e o volume de avaliações por 
 categoria de produto. Usei AVG para a média e COUNT para o volume, e agrupei por categoria.
*/




