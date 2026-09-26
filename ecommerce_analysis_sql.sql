SELECT * FROM e_commerce.sales;
SELECT * FROM e_commerce.store;
SELECT * FROM e_commerce.products;
SELECT * FROM e_commerce.dates;
SELECT * FROM e_commerce.customers;

select distinct product_key
from products;


#	 NUMBER OF CUSTOMERS @2000
select distinct s.customer_key
from sales s 
join customers c on c.customer_key = s.customer_key;

with testing as
(
select p.product_name,
		p.list_price,
        s.unit_price,
case when s.unit_price < p.list_price then 'less'
	when s.unit_price > p.list_price then 'more'
 	end as test
from sales s
join products p on p.product_key = s.product_key
)
select *,
		round(unit_price-list_price,2) as how
 from testing;
 
 # KPI'S 
 #TOTAL REVENU
 select round(sum(revenue),2) as total_revenu
 from sales;
 
 #TOTAL NUMBER OF SALES 
 SELECT count(*) as count_of						
 FROM sales;
 
 #TOTAL CUSTOMERS 
 select count(distinct customer_name) Total_customers
 from customers;
 
 #TOTAL PRODUCTS SOLD
 select count(distinct s.product_key) total_products_sold
 from products p
 join sales s on p.product_key = s.product_key;
 
 #TOTAL QUANTITY SOLD
 select sum(quantity) Total_quantity_sold
 from sales;
 
 #AVG ORDER VALUE 
 select round(avg(unit_price),2) as avg_order_value
 from sales s;
 
 #AVG DISCOUNT %
 with discount as
 (
 select round(avg(s.discount_pct),2) as avg_discount
 from sales s 
 )
 select (avg_discount*00.100) / sum(avg_discount) over() as percentage
 from discount;
 
 #LOSS MAKING SALES COUNT 
with loss as
(
 select p.product_name,
		p.unit_cost,
        s.unit_price,
case when s.unit_price < p.list_price then 'less'
	when s.unit_price > p.list_price then 'more'
 	end as sales_test
 from sales s
 join products p on p.product_key = s.product_key
 ),
 loss_makeing as
 (
 select *
 from loss
 where sales_test = 'less'
 )
 select count(*) as loss_makeing_sales
 from loss_makeing;
 
 #TOP 10 PRODUCTS BY REVENUE
 
 select p.product_name,
		round(sum(s.revenue),2) as revenue
 from sales s 
 join products p on p.product_key = s.product_key
 group by p.product_name
 order by revenue desc
 limit 10;
 
 with prod as
 (
 select p.product_name,
		round(sum(s.revenue),2) as revenue
 from sales s 
 join products p on p.product_key = s.product_key
 group by p.product_name
 ),
 ranks as (
 select * ,dense_rank() over(order by revenue desc) as ranking
 from prod
 )
 select *
 from ranks
 where ranking between 1 and 10;
 
 select p.category,
		round(sum(s.revenue),2) as revenue
 from sales s 
 join products p on p.product_key = s.product_key
 group by p.category
 order by sum(s.revenue) desc
 limit 1;
 
 #Which Product Categories Generate the Most Revenue?
  select a.store_name,
		round(sum(s.revenue),2) as revenue
 from sales s 
 join store a  on s.store_key = a.store_key
 group by a.store_name
 order by sum(s.revenue) desc
 limit 1 ;
 
 #Which Products Have Loss-Making Sales?
 with loss_check as
 (
 select p.product_name,
		p.unit_cost,
		s.unit_price,
 case when s.unit_price < p.list_price then 'less'
	when s.unit_price > p.list_price then 'more'
 	end as sales_test
 from sales s 
 join products p on p.product_key = s.product_key
 )
 select *
 from loss_check
 where sales_test = 'less';
 
 # Which Quarter Generates the Highest Revenue?
with qua as
(
 select d.quarter,
		round(sum(s.revenue),2) as revenu 
 from dates d 
 join sales s on s.date_key =  d.date_key
 group by d.quarter
 order by sum(s.revenue) desc
 ),
 rankss as 
 (
 select * ,rank()over(order by revenu desc) as ranks
 from qua
 )
 select * ,
		lead(revenu) over() as led,
			revenu- lead(revenu) over() as differents
 from rankss
 order by quarter;
 
 #Who Are the Top 10 Customers by Revenue?
 select c.customer_name,
		round(sum(s.revenue),2) as revenue
 from sales s 
 join customers c on c.customer_key = s.customer_key
 group by c.customer_name
 order by round(sum(s.revenue),2) desc
 limit 10 ;
 
 #Rank the Top Products Within Each Category
 with top as
 (
 select p.category,
		p.product_name,
        round(sum(revenue),2) revenue 
 from sales s
 join products p on p.product_key = s.product_key
 group by p.category ,p.product_name
 )
 select * ,dense_rank()over(partition by category order by revenue desc) as ranking
 from top;
 
 select   
		round(sum(p.unit_cost),2) ,
       round( sum(s.unit_price),2)
 from sales s 
 join products p on p.product_key = s.product_key
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
