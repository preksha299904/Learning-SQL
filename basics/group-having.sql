create database sale;
use sale;

CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  sale_date DATE NOT NULL,
  region VARCHAR(30) NOT NULL,         -- South, North, West, East
  city VARCHAR(50) NOT NULL,
  salesperson VARCHAR(60) NOT NULL,
  product_category VARCHAR(40) NOT NULL, -- Electronics, Grocery, Fashion, Home
  units INT NOT NULL,
  unit_price INT NOT NULL,
  discount INT NOT NULL,               -- flat discount per sale row
  channel VARCHAR(20) NOT NULL         -- Online, Store
);

INSERT INTO sales
(sale_id, sale_date, region, city, salesperson, product_category, units, unit_price, discount, channel)
VALUES
(201,'2024-01-05','South','Bengaluru','Asha','Electronics',1,45000,2000,'Online'),
(202,'2024-01-06','South','Bengaluru','Ravi','Grocery',12,120,0,'Store'),
(203,'2024-01-10','South','Chennai','Vikram','Home',1,12000,1500,'Online'),
(204,'2024-01-12','South','Hyderabad','Kiran','Grocery',25,80,0,'Store'),
(205,'2024-01-15','West','Mumbai','Sara','Fashion',2,2500,300,'Online'),
(206,'2024-01-20','West','Pune','John','Electronics',1,65000,5000,'Store'),
(207,'2024-02-02','North','Delhi','Amit','Grocery',15,95,0,'Online'),
(208,'2024-02-05','North','Delhi','Fatima','Fashion',4,1500,200,'Store'),
(209,'2024-02-10','East','Kolkata','Ananya','Grocery',8,110,0,'Store'),
(210,'2024-02-12','East','Kolkata','Ananya','Home',2,8000,0,'Online'),
(211,'2024-03-01','South','Bengaluru','Asha','Fashion',3,2200,400,'Store'),
(212,'2024-03-03','West','Mumbai','Chen','Electronics',1,30000,0,'Online'),
(213,'2024-03-08','South','Chennai','Vikram','Electronics',2,22000,1000,'Store'),
(214,'2024-03-10','North','Delhi','Amit','Home',1,20000,0,'Online'),
(215,'2024-03-18','West','Mumbai','Sara','Home',5,2000,0,'Store'),
(216,'2024-04-01','South','Hyderabad','Neha','Fashion',1,1800,0,'Online'),
(217,'2024-04-05','South','Bengaluru','Ravi','Home',1,9000,0,'Store'),
(218,'2024-04-10','East','Kolkata','Ananya','Electronics',1,28000,1000,'Online'),
(219,'2024-04-12','West','Pune','John','Grocery',10,130,0,'Store'),
(220,'2024-05-02','North','Delhi','Fatima','Electronics',1,40000,2000,'Online');


select * from sales;

#Show total sales value per region as SUM(units * unit_price) and order by total sales descending.
select sum(units*unit_price) as total, region
from sales
group by region
order by total asc;

#Show total units sold per product_category and order by units descending.
select sum(units) as units, product_category
from sales
group by product_category
order by units desc;

#Show number of sales per city and order by the count descending.
select count(sale_id) as sales, city
from sales
group by city
order by sales desc;

#Show average discount per channel and order by average discount descending.
select channel, avg(discount) as avds
from sales
group by channel
order by avds desc;

#Show total discount per salesperson and order by total discount descending.
select salesperson, avg(discount) as avds
from sales
group by salesperson
order by avds desc;

#Show total sales value per (region, product_category) and order by region, then total sales descending.
select count(sale_id) as sales, region, product_category
from sales
group by region, product_category
order by region, sales desc;

#Show total units per (city, product_category) and order by city, then units descending.
select sum(units) as units, city, product_category
from sales
group by city, product_category
order by city, units desc;

#Show count of sales per (salesperson, channel) and order by salesperson, then count descending.
select count(sale_id) as sales, salesperson, channel
from sales
group by salesperson, channel
order by salesperson, sales desc;

#Show min and max unit_price per product_category and order by category name.
select min(unit_price), max(unit_price), product_category
from sales
group by product_category
order by product_category;

#Show average sale value per city where sale value is (units * unit_price - discount), ordered by average sale value descending.
select avg((units*unit_price)-discount) as asv, city
from sales
group by city
order by asv desc;

#List cities where total units sold is greater than 20 (use HAVING).
select city, units
from sales
group by city, units
having units > 20;

#List product categories where total sales value exceeds 50000 (use HAVING).
select product_category, units*unit_price as sale
from sales
group by product_category, sale
having sale > 50000;

#List salespeople who have made at least 2 sales (use HAVING COUNT(*)).
select salesperson, count(units) as s
from sales
group by salesperson
having count(units) >= 2;

#List regions where average discount is greater than 800 (use HAVING AVG(discount)).
select region, avg(discount) as avd
from sales
group by region
having avd > 800;

#List (city, channel) groups where net sales SUM(units*unit_price - discount) is at least 30000, ordered by net sales descending.
select city, channel, sum((units*unit_price)-discount) as net_sales
from sales
group by city, channel
having net_sales >= 30000;

#For each month (from sale_date), show total sales value and order by month ascending.
select sum((units*unit_price)-discount) as total_sales, month(sale_date) as mon
from sales
group by mon
order by mon asc;

#For each month and region, show total units sold; include only groups with total units >= 10 (HAVING) and order by month then region.
select region, year(sale_date) as mon, sum(units) as u
from sales
group by region, mon
having u >= 10
order by mon, region;

SELECT DATE_FORMAT(sale_date, '%Y-%m-01') AS sale_month, region, SUM(units) AS total_units
FROM sales
GROUP BY sale_month, region
HAVING SUM(units) >= 10
ORDER BY sale_month, region;

#For each salesperson, show total sales value; include only those with total sales >= 30000 and order by total sales descending.
select salesperson, units*unit_price as s
from sales
group by salesperson, s
having s >= 30000
order by s desc;

#For each city, show total sales value for Online channel only; include only cities with at least 2 online sales (HAVING), order by total value descending.
SELECT city, sum(units*unit_price) as u
from sales
where channel="Online"
group by city
having count(*) >= 2
order by u desc;

SELECT city, SUM(units * unit_price) AS total_online_sales
FROM sales
WHERE channel = 'Online'
GROUP BY city
HAVING COUNT(*) >= 2
ORDER BY total_online_sales DESC, city;


#For each region, show the number of distinct product categories sold; include only regions with at least 3 categories (HAVING), order by the distinct count descending.
select count(distinct(product_category)) as dpc, region
from sales
group by region
having dpc >= 3
order by dpc desc;

