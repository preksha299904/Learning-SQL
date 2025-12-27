use shop;

CREATE TABLE sales_orders (
  order_id INT PRIMARY KEY,
  order_date DATE NOT NULL,
  customer_name VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL,
  region VARCHAR(20) NOT NULL,          -- South, North, West, East
  city VARCHAR(50) NOT NULL,
  category VARCHAR(40) NOT NULL,        -- Electronics, Grocery, Fashion, Home
  channel VARCHAR(20) NOT NULL,         -- Online, Store
  payment_method VARCHAR(30) NOT NULL,  -- UPI, Card, Cash, NetBanking
  status VARCHAR(20) NOT NULL,          -- Placed, Shipped, Delivered, Cancelled, Returned
  units INT NOT NULL,
  unit_price INT NOT NULL,
  discount INT NOT NULL,                -- flat discount per order row
  promo_code VARCHAR(20)                -- NULL or codes like NEW10, FESTIVE, WELCOME
);

INSERT INTO sales_orders
(order_id, order_date, customer_name, email, region, city, category, channel, payment_method, status, units, unit_price, discount, promo_code)
VALUES
(1001,'2024-01-05','Asha Rao','asha.rao@gmail.com','South','Bengaluru','Electronics','Online','UPI','Delivered',1,45000,2000,'NEW10'),
(1002,'2024-01-06','Ravi Kumar','ravi.kumar@outlook.com','South','Bengaluru','Grocery','Store','UPI','Delivered',12,120,0,NULL),
(1003,'2024-01-10','Vikram Iyer','vikram.iyer@outlook.com','South','Chennai','Home','Online','Card','Delivered',1,12000,1500,'WELCOME'),
(1004,'2024-01-12','Kiran Das','kiran.das@proton.me','South','Hyderabad','Grocery','Store','Cash','Delivered',25,80,0,NULL),
(1005,'2024-01-15','Sara Ali','sara.ali@gmail.com','West','Mumbai','Fashion','Online','Card','Delivered',2,2500,300,'FESTIVE'),
(1006,'2024-01-20','John Mathew','john.mathew@gmail.com','West','Pune','Electronics','Store','Card','Delivered',1,65000,5000,'FESTIVE'),
(1007,'2024-02-02','Amit Verma','amit.verma@yahoo.com','North','Delhi','Grocery','Online','UPI','Delivered',15,95,0,NULL),
(1008,'2024-02-05','Fatima Khan','fatima.khan@gmail.com','North','Delhi','Fashion','Store','Card','Delivered',4,1500,200,'NEW10'),
(1009,'2024-02-10','Ananya Gupta','ananya.gupta@proton.me','East','Kolkata','Grocery','Store','Cash','Delivered',8,110,0,NULL),
(1010,'2024-02-12','Ananya Gupta','ananya.gupta@proton.me','East','Kolkata','Home','Online','NetBanking','Shipped',2,8000,0,'WELCOME'),
(1011,'2024-03-01','Asha Rao','asha.rao@gmail.com','South','Bengaluru','Fashion','Store','UPI','Shipped',3,2200,400,NULL),
(1012,'2024-03-03','Chen Li','chen.li@gmail.com','West','Mumbai','Electronics','Online','Card','Cancelled',1,30000,0,NULL),
(1013,'2024-03-08','Vikram Iyer','vikram.iyer@outlook.com','South','Chennai','Electronics','Store','UPI','Delivered',2,22000,1000,'FESTIVE'),
(1014,'2024-03-10','Amit Verma','amit.verma@yahoo.com','North','Delhi','Home','Online','UPI','Returned',1,20000,0,'WELCOME'),
(1015,'2024-03-18','Sara Ali','sara.ali@gmail.com','West','Mumbai','Home','Store','Cash','Delivered',5,2000,0,NULL),
(1016,'2024-04-01','Neha Singh','neha.singh@gmail.com','South','Hyderabad','Fashion','Online','UPI','Cancelled',1,1800,0,'NEW10'),
(1017,'2024-04-05','Ravi Kumar','ravi.kumar@outlook.com','South','Bengaluru','Home','Store','Card','Delivered',1,9000,0,NULL),
(1018,'2024-04-10','Ananya Gupta','ananya.gupta@proton.me','East','Kolkata','Electronics','Online','Card','Delivered',1,28000,1000,'NEW10'),
(1019,'2024-04-12','John Mathew','john.mathew@gmail.com','West','Pune','Grocery','Store','Cash','Delivered',10,130,0,NULL),
(1020,'2024-05-02','Fatima Khan','fatima.khan@gmail.com','North','Delhi','Electronics','Online','Card','Delivered',1,40000,2000,'FESTIVE'),
(1021,'2024-05-06','Divya Menon','divya.menon@gmail.com','South','Bengaluru','Grocery','Online','UPI','Placed',6,150,0,'WELCOME'),
(1022,'2024-05-11','Divya Menon','divya.menon@gmail.com','South','Bengaluru','Fashion','Online','UPI','Delivered',3,2200,400,'NEW10'),
(1023,'2024-05-20','Arjun Reddy','arjun.reddy@yahoo.com','West','Mumbai','Home','Online','UPI','Delivered',5,2000,0,NULL),
(1024,'2024-06-02','Luis Fernandes','luis.fernandes@outlook.com','South','Bengaluru','Electronics','Store','NetBanking','Returned',1,32000,0,NULL),
(1025,'2024-06-10','Meera Nair','meera.nair@yahoo.com','South','Mysuru','Home','Store','Cash','Delivered',2,7000,500,'WELCOME');

select * from sales_orders;

#For each region, count orders where status is in (Delivered, Shipped) and payment_method is not in (Cash).
select count(order_id), region, status
from sales_orders
where status="delivered" or status="shipped" and payment_method not in ("cash")
group by region, status;

#For each city, compute total net sales for orders where category is in (Electronics, Home) OR promo_code is like F%.
select sum((units*unit_price)-discount) as net_sales, city, category
from sales_orders
where category="electronics" or category="Home" or promo_code like"F%"
group by city, category;

#For each customer_name, compute number of orders and total gross sales for customers whose email ends with @gmail.com OR @outlook.com.
select count(order_id), sum(units*unit_price), customer_name
from sales_orders
where email like "%@gmail.com" or "%@outlook.com"
group by customer_name;

#For each (region, channel), find average order value after discount for orders with order_date between 2024-02-01 and 2024-05-31.
select avg((units*unit_price)-discount) as avg_sales, region, channel
from sales_orders
where order_date between '2024-02-01' and '2024-05-31'
group by region, channel;

#For each category, list total units sold excluding orders with status in (Cancelled, Returned).
select count(units), category, status
from sales_orders
where status not in ("Cancelled","Returned")
group by category, status;

#For each payment_method, list number of orders where promo_code is not null AND promo_code not like %WELCOME%.
select count(order_id), payment_method
from sales_orders
where promo_code is not null and promo_code not like "%WELCOME%"
group by payment_method;

#For each city, list minimum and maximum unit_price considering only Online channel orders AND status not in (Cancelled).
select min(unit_price), max(unit_price), city, status
from sales_orders
where channel="Online" and status not in ("Cancelled")
group by city, status;

#For each region, list distinct customer count for orders where customer_name like %a% AND customer_name not like A%.
select region, count(distinct(customer_name))
from sales_orders
where customer_name like ("%a%") AND customer_name not like ("A%")
group by region;

#For each customer_name, list total discount for orders with discount between 200 and 2000 AND status not between Placed and Shipped.
select customer_name, sum(discount)
from sales_orders
where discount between 200 and 2000 and status not in ("placed","shipped")
group by customer_name;

#For each category, compute total net sales for orders where units between 1 and 5 AND city not in (Delhi, Mumbai).
select sum((units*unit_price)-discount) as net_sales, category
from sales_orders
where units between 1 and 5 and city not in ("Delhi","mumbai")
group by category;

#Show (region, category) groups where total gross sales is at least 30000 and order the result by gross sales descending.
select distinct(category), sum(units*unit_price) as tgs, region
from sales_orders
group by region, category
having sum(units*unit_price) >= 30000
order by tgs desc;

#Show city groups where total units is greater than 10 AND number of distinct customers is at least 2.
select sum(units) as tu, count(distinct(customer_name)) as dc ,city
from sales_orders
group by city
having sum(units) > 10 and dc >= 2;

#Show customer_name groups where average net order value is between 5000 and 25000 AND at least one order has a promo code.
select customer_name, avg((units*unit_price)-discount) as avn, count(promo_code) as cpc
from sales_orders
group by customer_name
having avn between 5000 and 25000 AND cpc >=1;


#Show payment_method groups where delivered-order count is at least 3 OR cancelled-order count is at least 2; order by total orders descending.
select payment_method, count(*) as status_count, status
from sales_orders
group by payment_method, status
having ((status="delivered") and count(*) >= 3) OR ((status="cancelled") and count(*) >= 2)
order by payment_method desc; 

#Show region groups where net sales is not between 20000 and 80000 AND the region has at least 2 distinct cities.
select region, sum((units*unit_price)-discount) as ns, count(distinct(city)) as cd
from sales_orders
group by region
having (sum((units*unit_price)-discount) not between 20000 and 80000) and count(distinct(city)) >= 2;


#Find all orders where email like %.proton.me OR %.yahoo.com AND status not in (Cancelled, Returned).
select *
from sales_orders
where email like "%.proton.me" OR email like "%.yahoo.com"
AND status not in ("Cancelled","Returned");

select *
from sales_orders
where email like ("%.proton.me") OR ("%.yahoo.com");

select email
from sales_orders
where email like '%.proton.me' OR email like '%.yahoo.com';

SELECT email
FROM sales_orders
WHERE email LIKE '%.proton.me' OR email LIKE '%.yahoo.com';

SELECT *
FROM sales_orders
WHERE (email LIKE '%.proton.me' OR email LIKE '%.yahoo.com')
  AND status NOT IN ('Cancelled', 'Returned');
  
#Find all orders where order_date not between 2024-02-01 and 2024-04-30 AND channel in (Online).
select *
from sales_orders
where order_date not between '2024-02-01' and '2024-04-30' 
AND channel in ("Online");

#Find all orders where customer_name like _a% AND city not in (Bengaluru, Delhi).
select *
from sales_orders
where customer_name like("_a%")
and city not in ("Bengaluru","Delhi");

#Find all orders where promo_code is null OR promo_code not like %NEW%.
select *
from sales_orders
where promo_code is null OR promo_code not like '%NEW%';

#Find all orders where net sales is between 10000 and 30000 AND payment_method not in (Cash).
select *
from sales_orders
where (units*unit_price)-discount between 10000 and 30000 
AND payment_method not in ("Cash");