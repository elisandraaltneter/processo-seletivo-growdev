--Bloco E — CASE WHEN
--1. Classificar pedidos por prazo de entrega: "adiantado", "no prazo" ou "atrasado" (comparando data real x estimada).
--Pergunta de negócio: Como se distribui a performance de entrega da plataforma?
SELECT
			o.order_id,
			o.order_estimated_delivery_date as estimativa_entrega,
			o.order_delivered_customer_date as entregue_ao_cliente_em,
case
when NULLIF(o.order_delivered_customer_date, '')::date is null then 'sem data de entrega'
when o.order_delivered_customer_date::date < o.order_estimated_delivery_date :: date then 'adiantado'
when o.order_delivered_customer_date::date = o.order_estimated_delivery_date::date then 'no prazo'
when o.order_delivered_customer_date::date > o.order_estimated_delivery_date :: date then 'atrasado'
else 'Não pode ser categorizado'
end as categoria
FROM olist_orders_dataset o
WHERE o.order_status = 'delivered';

--Usei CASE WHEN para comparar a data real com a estimada, e NULLIF para tratar datas vazias. Filtrei só os pedidos com status 'delivered'.

--2. Classificar clientes por faixa de gasto total: "bronze", "prata", "ouro".
--Pergunta de negócio: Como segmentar a base de clientes por valor?
select
		c.customer_unique_id,
		SUM(i.price + i.freight_value) "Gasto total",
		case
		when SUM(i.price + i.freight_value) <= 500 then 'bronze'
		when SUM(i.price + i.freight_value) <= 1500 then 'prata'
		else 'ouro'
		end "Faixa Cliente"
	
		from olist_customers_dataset c
		join olist_orders_dataset o on o.customer_id = c.customer_id
		join olist_order_items_dataset i on i.order_id = o.order_id
		group by c.customer_unique_id
		order by "Gasto total" desc;

-- Juntei clientes, pedidos e itens, somei o gasto total por cliente com GROUP BY.Usei CASE WHEN para classificar em bronze (até 500),
-- prata (até 1500) e ouro (acima de 1500).

--3. Classificar produtos por faixa de peso: "leve", "médio", "pesado" (com base em product_weight_g).
--Pergunta de negócio:Como se distribui o peso dos produtos na plataforma?		
select 
		p.product_id "Id do Produto",
		p.product_category_name "Categoria",
		p.product_weight_g  "Peso",
		case
		when p.product_weight_g is null then 'sem peso'
		when  p.product_weight_g <= 1000 then 'leve'
		when  p.product_weight_g <= 10000 then 'médio'
		else 'pesado'
		end "Faixa de Peso"
	from olist_products_dataset p
	order by p.product_weight_g desc;

-- Usei CASE WHEN para classificar em leve (até 1kg), médio (até 10kg) e pesado (acima de 10kg). Produtos sem peso cadastrado ficam como 'sem peso',
--por causa do "is null"

	
--4. Classificar pagamentos como "à vista" ou "parcelado", e dentro de parcelado sinalizar parcelamentos longos (payment_installments > 6).
--Pergunta de negócio:Qual é o perfil de parcelamento dos clientes?
select 
		p.order_id "Id Pedido",
		p.payment_type "Forma de Pagamento",
		p.payment_installments "Parcelas",
		case 
		when payment_installments = 0 then 'sem parcela'
		when p.payment_installments = 1 then 'à vista'	
		when p.payment_installments <= 6 then 'parcelado'
		else 'parcelamento longo'
		end "Parcelamento"
from olist_order_payments_dataset p
order by p.payment_installments desc;

-- Usei CASE WHEN para classificar em sem parcela (0), à vista (1), parcelado (até 6) e parcelamento longo (acima de 6).
-- Notei que há resultados com 0 parcelas, então deixei como "sem parcela"






