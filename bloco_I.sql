--Bloco I — Window functions
--1. Ranking (RANK()) dos vendedores por faturamento dentro de cada estado.
-- Pergunta de negócio: Quem são os vendedores que mais faturam em cada estado?
select 
    s.seller_id  "Vendedor",
    s.seller_state  "Estado",
    SUM(i.price)  "Faturamento",
    RANK() over (partition by s.seller_state order by SUM(i.price) desc)  "Ranking"
from olist_order_items_dataset i
join olist_sellers_dataset s on s.seller_id = i.seller_id
group by s.seller_id, s.seller_state
order by s.seller_state, "Ranking";

/*Juntei itens e vendedores, somei o faturamento com SUM e agrupei por vendedor e estado.
Usei RANK() com PARTITION BY estado para criar um ranking separado por estado. Por fim, ordenei por estado e ranking.
*/

--2. Faturamento mensal acumulado (SUM(...) OVER (ORDER BY ...)) por vendedor.
--Pergunta de negócio: Como o faturamento de cada vendedor evolui ao longo dos meses?
with faturamento_mensal as (
    select 
        s.seller_id as vendedor,
        DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) as mes,
        SUM(i.price) as faturamento
    from olist_order_items_dataset i
    join olist_orders_dataset o on o.order_id = i.order_id
    join olist_sellers_dataset s on s.seller_id = i.seller_id
    group by s.seller_id, DATE_TRUNC('month', o.order_purchase_timestamp::timestamp)
)
select
    vendedor,
    mes,
    faturamento,
    SUM(faturamento) over (
        partition by vendedor 
        order by mes
    ) as faturamento_acumulado
from faturamento_mensal
order by vendedor, mes;

/*
aqui eu criei uma CTE com o faturamento mensal por vendedor, juntando as tabelas de itens, pedidos e vendedores.Depois usei a window function 
SUM() OVER (PARTITION BY vendedor ORDER BY mes) para calcular o faturamento acumuladode cada vendedor ao longo dos meses. Por fim, ordenei por 
vendedor e mês.
 */

--3. Percentual de participação de cada vendedor no faturamento total do seu estado (SUM(...) OVER (PARTITION BY estado)).
--Pergunta de negócio: Qual a relevância de cada vendedor dentro do faturamento do seu estado?
with faturamento_vendedor as (
    select 
        s.seller_id as vendedor,
        s.seller_state as estado,
        SUM(i.price) as faturamento
    from olist_order_items_dataset i
    join olist_sellers_dataset s on s.seller_id = i.seller_id
    group by s.seller_id, s.seller_state
)
select 
    vendedor,
    estado,
    faturamento,
    SUM(faturamento) over (partition by estado) as faturamento_estado,
    ROUND(
        (faturamento / SUM(faturamento) over (partition by estado))::numeric * 100,
        2
    ) as participacao_percentual
from faturamento_vendedor
order by estado, participacao_percentual desc;
/*
 aqui eu criei uma CTE com o faturamento por vendedor e estado, juntando as tabelas de itens e vendedores.Depois usei a window function 
 SUM() OVER (PARTITION BY estado) para calcular o faturamento total do estado e dividi o faturamento do vendedor por esse total, multiplicando por 
 100 para ter a participação percentual. Por fim, ordenei por estado e participação decrescente.
 */

--4. Variação de faturamento de um mês para o outro por vendedor, usando LAG().
--Pergunta de negócio: Como o faturamento de cada vendedor varia mês a mês?
with faturamento_mensal as (
    select 
        s.seller_id as vendedor,
        DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) as mes,
        SUM(i.price) as faturamento
    from olist_order_items_dataset i
    join olist_orders_dataset o ON o.order_id = i.order_id
    join olist_sellers_dataset s ON s.seller_id = i.seller_id
    group by s.seller_id, DATE_TRUNC('month', o.order_purchase_timestamp::timestamp)
),
com_lag as (
    select 
        vendedor,
        mes,
        faturamento,
        LAG(faturamento) over (partition by vendedor order by mes) as faturamento_anterior
    from faturamento_mensal
)
select 
    vendedor,
    mes,
    faturamento,
    faturamento_anterior,
    ROUND(
        ((faturamento - faturamento_anterior) / NULLIF(faturamento_anterior, 0))::numeric * 100,
        2
    ) as variacao_percentual
from com_lag
order by vendedor, mes;

/*
 aqui eu criei uma CTE com o faturamento mensal por vendedor, juntando as tabelas de itens, pedidos e vendedores.Depois usei a window function 
 LAG() com PARTITION BY vendedor ORDER BY mes para pegar o faturamento do mês anterior e calculei a variação percentual entre os dois meses.
 Usei NULLIF para evitar divisão por zero.Por fim, ordenei por vendedor e mês.
 */