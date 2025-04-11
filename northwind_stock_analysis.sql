-- 1. Informações Gerais do Estoque
-- Quantidade total de produtos distintos em estoque
SELECT COUNT(*) AS total_produtos FROM products;

-- Quantidade de produtos descontinuados
SELECT COUNT(*) AS produtos_descontinuados FROM products WHERE discontinued = 1;

-- Total de unidades em estoque
SELECT SUM(units_in_stock) AS total_unidades_estoque FROM products;

-- Total de unidades em estoque de produtos descontinuados
SELECT SUM(units_in_stock) AS total_unidades_estoque FROM products WHERE discontinued = 0;

/*
Análise Escrita:
A base de dados Northwind possui um total de 77 produtos distintos cadastrados. Dentre esses, 10 produtos estão descontinuados, 
restando 67 produtos ativos para a análise. O estoque atual apresenta cerca de 3100 unidades distribuídas. 
Entre esses 2900 são produtos ativos.
*/

-- 2. Produtos Mais Lucrativos (Pareto 80/20)
-- Identificação dos produtos que geram 80% da receita

SELECT p.product_name, SUM(od.unit_price * od.quantity * (1 - od.discount)) AS receita
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY receita DESC;

-- Percentual móvel
with sales as (
	select 
		p.product_id,
		p.product_name,
		sum(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue
	from order_details od
	inner join products p on od.product_id = p.product_id
	group by p.product_id, p.product_name
),

sales_ranked as (
	select 
		s.product_id,
		s.product_name,
		s.total_revenue,
		s.total_revenue * 100.0 / sum(s.total_revenue) over () as pct_total,
		sum(s.total_revenue) over (order by s.total_revenue desc) * 100.0 / sum(s.total_revenue) over () as running_pct
	from sales s
)

select 
	product_id,
	product_name,
	total_revenue,
	running_pct
from sales_ranked
where running_pct <= 80
order by total_revenue desc;

/*
Análise Escrita:
Os produtos identificados na análise de Pareto indica que 20 unidades do total de produtos (que representam 
cerca de 25% do estoque total) geram aproximadamente 50% da receita total da empresa. Isso mostra a importância
de priorizar esses produtos para reposição de estoque.

Deve-se priorizar, principalmente, os 5 primeiros produtos "Côte de Blaye", "Thüringer Rostbratwurst", 
"Raclette Courdavault", "Tarte au sucre" e "Camembert Pierrot", que representam, sozinhos, 30% do faturamento 
total da empresa.
*/


/*
3. Estoque Insuficiente vs. Demanda
Produtos com estoque insuficiente para atender à demanda do ano anterior
*/

SELECT p.product_name,
       p.units_in_stock,
       COALESCE(SUM(od.quantity), 0) AS qty_sold_last_year,
	   p.units_in_stock - sum(od.quantity) AS qty_replenishment,
       CASE WHEN p.units_in_stock < COALESCE(SUM(od.quantity), 0) THEN 'Replenishment' ELSE 'OK' END AS status
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
LEFT JOIN orders o ON od.order_id = o.order_id
WHERE o.order_date BETWEEN '1997-05-01' AND '1997-06-01' OR o.order_date IS NULL
AND p.discontinued = 0
GROUP BY p.product_name, p.units_in_stock
ORDER BY status DESC, qty_replenishment;

/* Análise Escrita:
-- A análise revela que 28 produtos, dos 55 ativos, possuem estoque insuficiente para atender à demanda do
mesmo período no ano anterior. 

Dentre esses produtos, "Côte de Blaye", o produto de maior faturamento da empresa está com estoque insuficiente, 
com metade da quantidade de unidades suficientes para atender a demanda do ano anterior.

"Tarte au sucre", quarto produto de maior faturamento, está com cerca de 25% da quantidade necessária.
anterior

"Camembert Pierrot", quinto produto de maior faturamento, com metade da quantidade necessária.

"Raclette Courdavault", por outro lado, tem unidades para atender 4x a demanda do ano anterior.

Além disso, é possível identificar produtos com estoque suficiente para atender mais de 10x a demanda do ano anterior,
ocupando espaço em excesso do armazém, sendo que nem participam em grande parte do faturamento da empresa.
*/


/*
4. Sazonalidade
Média de vendas por mês
*/

SELECT EXTRACT(MONTH FROM o.order_date) AS mes,
       SUM(od.quantity) AS total_vendas
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY mes
ORDER BY mes;

/*
Análise Escrita:
A distribuição das vendas ao longo do ano indica uma concentração maior nos meses entre janeiro e abril, o que sugere sazonalidade
nas vendas. A reposição de estoque deve considerar esses períodos de maior demanda para evitar insuficiência da oferta.
*/


/*
Conclusão Final:
A análise identificou os produtos mais lucrativos, sazonalidade de vendas, estoque insuficiente e ocupação indevida do armazém. Com base 
nessas informações, recomenda-se priorizar a reposição de produtos mais vendidos e lucrativos, ajustar o planejamento para períodos de alta 
demanda e revisar a reposição dos produtos para otimizar o estoque da empresa.
*/
