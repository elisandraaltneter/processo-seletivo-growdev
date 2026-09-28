-- Bloco F — CTE / tabela temporária
--1. Construir uma CTE de faturamento mensal por estado e, a partir dela, calcular a variação percentual de um mês para o outro.
--Pergunta de negócio: Como o faturamento evoluiu mês a mês em cada estado?
with faturamento_mensal as (
    select 
        c.customer_state as estado,
        DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) as mes,
        SUM(i.price + i.freight_value) as faturamento
    from olist_orders_dataset o
    join olist_customers_dataset c on c.customer_id = o.customer_id
    join olist_order_items_dataset i on i.order_id = o.order_id
    where o.order_status = 'delivered'
    group by c.customer_state, DATE_TRUNC('month', o.order_purchase_timestamp::timestamp)
),
com_lag as (
    select 
        estado,
        mes,
        faturamento,
        LAG(faturamento) over (partition by estado order by mes) as faturamento_anterior
    from faturamento_mensal
)
select
    estado,
    mes,
    faturamento,
    faturamento_anterior,
    ROUND(
        (((faturamento - faturamento_anterior) / NULLIF(faturamento_anterior, 0)) * 100)::numeric,
        2
    ) as variacao_percentual
from com_lag
order by estado, mes;

-- Criei uma CTE com faturamento por estado e mês, e usei LAG para comparar com o mês anterior. Usei NULLIF para evitar divisão por zero.

-- 2. Construir uma CTE com volume de avaliações e nota média por categoria de produto, usada para identificar as categorias com pior reputação 
--(nota média mais baixa e volume relevante de avaliações).
--Pergunta de negócio: Quais categorias têm pior reputação na plataforma?
WITH avaliacoes_categoria as (
    SELECT 
        p.product_category_name "Categoria",
        COUNT(r.review_id) "Quant Avaliações",
        AVG(r.review_score) "Nota Média"
    from olist_order_reviews_dataset r
    join olist_orders_dataset o on o.order_id = r.order_id
    join olist_order_items_dataset i on i.order_id = o.order_id
    join olist_products_dataset p on p.product_id = i.product_id
    group by p.product_category_name
)
select 
    "Categoria",
    "Quant Avaliações",
    "Nota Média"
from avaliacoes_categoria
where "Quant Avaliações" >= 10
order by "Nota Média" asc
limit 10;

-- Utilizei o with para criar uma CTE com volume e nota média por categoria, e filtrei as com volume relevante e pior nota. E coloquei uma quantidade 
-- mínima de 10 avaliações para filtrar e ordenei de ordem crescente.


--3. Construir uma CTE de frete médio por estado do cliente, usada para comparar cada estado com a média geral de frete.
-- Pergunta de negócio: Quais estados têm frete médio acima da média geral?
with frete_por_estado as (
    select
        c.customer_state "Estado",
        AVG(i.freight_value) "Frete Médio"
    from olist_order_items_dataset i
    join olist_orders_dataset o on o.order_id = i.order_id
    join olist_customers_dataset c on c.customer_id = o.customer_id
    group by c.customer_state
)
select
    "Estado",
    "Frete Médio",
    (select AVG("Frete Médio") from frete_por_estado) "Média Geral",
    ROUND(
        (("Frete Médio" - (select AVG("Frete Médio") from frete_por_estado)) 
        / NULLIF((select AVG("Frete Médio") from frete_por_estado), 0))::numeric * 100,
        2
    ) as variacao_percentual
from frete_por_estado
order by "Frete Médio" desc;

 /*aqui eu selecionei a coluna estado do cliente que está na tabela customers, juntei com a tabela de pedidos e de itens e fiz a média do frete com AVG 
 para ter o frete médio de cada estado. Depois usei uma subquery para calcular a média geral de todos os estados e comparei cada estado com essa média,
 calculando a variação percentual. Depois ordenei de forma decrescente.
 */





