1)Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.

SELECT customer,
		market,
        region
FROM gdb023.dim_customer
where customer = 'Atliq Exclusive' AND region = 'APAC'
group by market;

2) What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
unique_products_2020,
unique_products_2021,
percentage_chg.

SELECT 
count(distinct case when fiscal_year = 2020 then product_code end) as unique_code_2020,
count(distinct case when fiscal_year = 2021 then	product_code end) as unique_code_2021,
round((count(distinct case when fiscal_year = 2021 then	product_code end)- count(distinct case when fiscal_year = 2020 then product_code end))/count(distinct case when fiscal_year = 2020 then product_code end) * 100.0,2) as per_chg
FROM gdb023.fact_sales_monthly;

3) Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. The final output contains
2 fields,
segment,
product_count.

SELECT segment,
count(distinct product) as product_count
FROM gdb023.dim_product
group by segment
order by count(distinct product) desc;

4) Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields,
segment,
product_count_2020,
product_count_2021,
difference.
SELECT segment,
count(distinct case when fiscal_year = 2020 then    k.product_code end) as product_count_2020,
count(distinct case when fiscal_year = 2021 then	k.product_code end) as product_count_2021,
count(distinct case when fiscal_year = 2021 then	k.product_code end)- count(distinct case when fiscal_year = 2020 then k.product_code end) as difference
FROM gdb023.fact_sales_monthly as k
left join gdb023.dim_product as m on
   k.product_code = m.product_code
   group by segment order by segment;

5) Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields,
product_code,
product,
manufacturing_cost.


SELECT k.product_code, product, manufacturing_cost
from gdb023.fact_manufacturing_cost as k
left join gdb023.dim_product as m on
k.product_code = m.product_code
where manufacturing_cost = (select min(manufacturing_cost)
							FROM gdb023.fact_manufacturing_cost)
		OR
			manufacturing_cost = (select max(manufacturing_cost)
                                 FROM gdb023.fact_manufacturing_cost);

6) Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output contains these fields,
customer_code,
customer,
average_discount_percentage.


SELECT customer_code,
		customer,
		avg(pre_invoice_discount_pct) as avg_dis_per
FROM gdb023.fact_pre_invoice_deductions 
join gdb023.dim_customer  using (customer_code)
where market = 'India' AND fiscal_year = 2021
group by customer
order by avg(pre_invoice_discount_pct) desc
LIMIT 5;

7) Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions.
The final report contains these columns:
Month,
Year,
Gross sales Amount.



 select month(date) as month_, k.fiscal_year,
        sum(sold_quantity * gross_price) as gross_sales_amt
 from gdb023.fact_sales_monthly as k
 join gdb023.fact_gross_price using(product_code)
 join gdb023.dim_customer using(customer_code)
 where customer = 'Atliq Exclusive'
 group by month(date),k.fiscal_year
 order by sum(sold_quantity * gross_price) asc;
 
 8) In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity,
Quarter,
total_sold_quantity.


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


9) Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields,
channel,
gross_sales_mln,
percentage.

select m.channel,
sum(p.sold_quantity*k.gross_price)/1000000 as gross_sales_min,
(sum(p.sold_quantity*k.gross_price)/ sum(sum(p.sold_quantity*k.gross_price)) over() ) *100.0 as per
From gdb023.fact_sales_monthly as p
join gdb023.fact_gross_price as k using (product_code)
join gdb023.dim_customer as m using(customer_code)
where p.fiscal_year = 2021
group by m.channel;

10) Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these
fields,
division,
product_code,
product,
total_sold_quantity,
rank_order.

select k.division, product_code, k.product,sum(sold_quantity) as Total_sold_quantity,
        dense_rank() over(partition by k.division order by sum(sold_quantity) desc) as rank_order
FROM gdb023.fact_sales_monthly as m
join gdb023.dim_product as k using(product_code)
where m.fiscal_year = 2021 
group by k.product
limit 3;

        





     

         
                        

