-- DROP TABLE IF EXISTS public.zepto;

drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp numeric(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

select * from zepto;

select COUNT(*) FROM zepto;

---Sample data 
select *from zepto
limit (10);

--null values
select * from zepto
where name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
discountedSellingPrice is NULL
OR
weightInGms is NULL
OR
availableQuantity is NULL
OR
outOfStock is NULL
OR
quantity is NULL;

--here we get no null values----

--different prodcut categories 
select DISTINCT category
from zepto
order by category;

---product ins stock vs outstock 
select outOfStock,count(sku_id)
from zepto
group by outOfStock;


---PRODUCT NAMES Present multipele times 
select name, count(sku_id) as "Number of skus"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) DESC;

---Data cleaning 
-price mite be zero

select * from zepto where mrp =0 or
discountedSellingPrice =0;

delete from zepto where mrp =0;


select *from zepto
limit (1);

--convert into std rupess
update zepto set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto;

--	Q1.Find th top 10 best-value products based
--on the discount percentage

select distinct name ,mrp, discountPercent 
from zepto 
order by discountPercent DESC
LIMIT 10;

--Q2. What are the produts with high mrp but outof stock 
select distinct name,mrp 
from zepto
where outOfStock =TRUE and mrp >300
order by mrp desc;

--Q3 CALCULATR ESTIMATED REVENVU FOR EACH CATEGORY 
select category ,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto 
GROUP BY category
order by total_revenue;

select category,discountedSellingPrice,availableQuantity
from zepto
group by category;

--Q4 .Finds all products where mrp is greater than 500 and discount is less than 10%
select  distinct name , mrp ,discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent Desc; 

--Q5.Indentify the top5 categories offering the hightest avg discount percentage 

select category,
round(avg(discountPercent),2) AS avg_discount
from zepto 
group by category
order by avg_discount desc
limit 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
