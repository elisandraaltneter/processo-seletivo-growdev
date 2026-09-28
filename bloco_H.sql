--Bloco H — Procedure de leitura (parametrizada)
--1. Criar a procedure/function sp_relatorio_vendedor(id_vendedor, data_inicio, data_fim), que retorna faturamento, ticket médio e nota média
--de avaliação do vendedor no período informado — sem alterar nenhum dado.
-- Pergunta de negócio: Qual o faturamento, ticket médio e nota média de um vendedor em um período?
create or replace function sp_relatorio_vendedor(
    id_vendedor TEXT,
    data_inicio DATE,
    data_fim DATE
)
returns table(
    faturamento NUMERIC,
    ticket_medio NUMERIC,
    nota_media NUMERIC
) as $$
begin
    return QUERY
    select
        SUM(i.price)::numeric as faturamento,
        AVG(i.price)::numeric as ticket_medio,
        AVG(r.review_score)::numeric as nota_media
    from olist_order_items_dataset i
    join olist_orders_dataset o on o.order_id = i.order_id
    left join olist_order_reviews_dataset r on r.order_id = o.order_id
    where i.seller_id = id_vendedor
      and o.order_purchase_timestamp::date between data_inicio and data_fim;
end;
$$ language plpgsql;

select seller_id -- verificando o id de algum vendedor, escolhi  o "3442f8959a84dea7ee197c632cb2df15"
from olist_sellers_dataset 
limit 5;

select * from sp_relatorio_vendedor(
    '3442f8959a84dea7ee197c632cb2df15',  -- estou fazendo a pesquisa do id que eu escolhi ali em cima, para ver se funcionou.
    '2017-01-01',
    '2018-12-31'
);

/*
 aqui eu criei uma function que recebe o id do vendedor e um intervalo de datas. Ela retorna o faturamento (SUM), o ticket médio (AVG) e a nota 
 média das avaliações (AVG).Usei LEFT JOIN com reviews para não perder pedidos sem avaliação e filtrei pelo vendedor e período.
 */

--2. Criar a procedure/function sp_relatorio_categoria(categoria, data_inicio, data_fim), que retorna faturamento total e ticket médio da
--categoria de produto no período informado.
--Pergunta de negócio: Qual o faturamento total e ticket médio de uma categoria em um período?

create or replace function sp_relatorio_categoria(
    categoria TEXT,
    data_inicio DATE,
    data_fim DATE
)
returns table(
    faturamento_total NUMERIC,
    ticket_medio NUMERIC
) as $$
begin
    return QUERY
    select 
        SUM(i.price)::numeric as faturamento_total,
        AVG(i.price)::numeric as ticket_medio
    from olist_order_items_dataset i
    join olist_orders_dataset o on o.order_id = i.order_id
    join olist_products_dataset p on p.product_id = i.product_id
    where p.product_category_name = categoria
      and o.order_purchase_timestamp::date between data_inicio and data_fim;
end;
$$ language plpgsql;

select distinct product_category_name -- verificando as categorias válidas 
from olist_products_dataset 
where product_category_name is not null
limit 5;

SELECT * FROM sp_relatorio_categoria(
    'climatizacao',   -- escolhi a categoria "climatizacao" para me mostrar o faturamento_total e o ticket_medio no periodo que escolhi
    '2017-01-01',
    '2018-12-31'
);

/*
 	aqui eu criei uma function que recebe o nome da categoria e um intervalo de datas.Ela retorna o faturamento total (SUM) e o ticket médio (AVG) 
    dos itens daquela categoria.Usei JOIN com products para pegar a categoria e filtrei pelo período informado.
 */
