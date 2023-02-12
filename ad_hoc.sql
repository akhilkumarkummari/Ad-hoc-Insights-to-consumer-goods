SELECT customer,
		market,
        region
FROM gdb023.dim_customer
where customer = 'Atliq Exclusive' AND region = 'APAC'
group by market;


SELECT 
count(distinct case when fiscal_year = 2020 then product_code end) as unique_code_2020,
count(distinct case when fiscal_year = 2021 then	product_code end) as unique_code_2021,
round((count(distinct case when fiscal_year = 2021 then	product_code end)- count(distinct case when fiscal_year = 2020 then product_code end))/count(distinct case when fiscal_year = 2020 then product_code end) * 100.0,2) as per_chg
FROM gdb023.fact_sales_monthly;

SELECT segment,
count(distinct product) as product_count
FROM gdb023.dim_product
group by segment
order by count(distinct product) desc;


SELECT segment,
count(distinct case when fiscal_year = 2020 then    k.product_code end) as product_count_2020,
count(distinct case when fiscal_year = 2021 then	k.product_code end) as product_count_2021,
count(distinct case when fiscal_year = 2021 then	k.product_code end)- count(distinct case when fiscal_year = 2020 then k.product_code end) as difference
FROM gdb023.fact_sales_monthly as k
left join gdb023.dim_product as m on
   k.product_code = m.product_code
   group by segment order by segment;

SELECT k.product_code, product, manufacturing_cost
from gdb023.fact_manufacturing_cost as k
left join gdb023.dim_product as m on
k.product_code = m.product_code
where manufacturing_cost = (select min(manufacturing_cost)
							FROM gdb023.fact_manufacturing_cost)
		OR
			manufacturing_cost = (select max(manufacturing_cost)
                                 FROM gdb023.fact_manufacturing_cost);
                                 
SELECT customer_code,
		customer,
		avg(pre_invoice_discount_pct) as avg_dis_per
FROM gdb023.fact_pre_invoice_deductions 
join gdb023.dim_customer  using (customer_code)
where market = 'India' AND fiscal_year = 2021
group by customer
order by avg(pre_invoice_discount_pct) desc
LIMIT 5;
 
 select month(date) as month_, k.fiscal_year,
        sum(sold_quantity * gross_price) as gross_sales_amt
 from gdb023.fact_sales_monthly as k
 join gdb023.fact_gross_price using(product_code)
 join gdb023.dim_customer using(customer_code)
 where customer = 'Atliq Exclusive'
 group by month(date),k.fiscal_year
 order by sum(sold_quantity * gross_price) asc;
 
 select (
		CASE
			when month(date)  in (9,10,11) then 'Q1' when month(date) in (12,1,2) then 'Q2'
            when month(date) in (3,4,5) then 'Q3' when month(date) in (6,7,8) then 'Q4' end) as Quarter,
	sum(sold_quantity) as Total_sold_quantity
FROM gdb023.fact_sales_monthly
where fiscal_year = 2020
group by case
			when month(date)  in (9,10,11) then 'Q1' when month(date) in (12,1,2) then 'Q2'
            when month(date) in (3,4,5) then 'Q3' when month(date) in (6,7,8) then 'Q4' end;


select m.channel,
sum(p.sold_quantity*k.gross_price)/1000000 as gross_sales_min,
(sum(p.sold_quantity*k.gross_price)/ sum(sum(p.sold_quantity*k.gross_price)) over() ) *100.0 as per
From gdb023.fact_sales_monthly as p
join gdb023.fact_gross_price as k using (product_code)
join gdb023.dim_customer as m using(customer_code)
where p.fiscal_year = 2021
group by m.channel;

select k.division, product_code, k.product,sum(sold_quantity) as Total_sold_quantity,
        dense_rank() over(partition by k.division order by sum(sold_quantity) desc) as rank_order
FROM gdb023.fact_sales_monthly as m
join gdb023.dim_product as k using(product_code)
where m.fiscal_year = 2021 
group by k.product
limit 3;

        





     

         
                        

