
create database orders;
use orders;
 
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  full_name VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  signup_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL  -- Active/Inactive
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date DATE NOT NULL,
  category VARCHAR(40) NOT NULL,        -- Electronics, Grocery, Fashion, Home
  channel VARCHAR(20) NOT NULL,         -- Online, Store
  payment_method VARCHAR(30) NOT NULL,  -- UPI, Card, Cash, NetBanking
  amount INT NOT NULL,                  -- final amount after discount (for simplicity)
  status VARCHAR(20) NOT NULL,          -- Placed, Shipped, Delivered, Cancelled, Returned
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
); 

INSERT INTO customers (customer_id, full_name, email, city, state, signup_date, status) VALUES
(1,'Asha Rao','asha.rao@gmail.com','Bengaluru','Karnataka','2023-01-10','Active'),
(2,'Ravi Kumar','ravi.kumar@outlook.com','Bengaluru','Karnataka','2023-02-15','Active'),
(3,'Meera Nair','meera.nair@yahoo.com','Mysuru','Karnataka','2022-11-01','Active'),
(4,'John Mathew','john.mathew@gmail.com','Pune','Maharashtra','2021-07-20','Active'),
(5,'Sara Ali','sara.ali@gmail.com','Mumbai','Maharashtra','2020-05-05','Inactive'),
(6,'Kiran Das','kiran.das@proton.me','Hyderabad','Telangana','2023-03-12','Active'),
(7,'Neha Singh','neha.singh@gmail.com','Hyderabad','Telangana','2022-09-30','Active'),
(8,'Vikram Iyer','vikram.iyer@outlook.com','Chennai','Tamil Nadu','2019-12-01','Active'),
(9,'Priya Sharma','priya.sharma@gmail.com','Chennai','Tamil Nadu','2021-01-18','Active'),
(10,'Amit Verma','amit.verma@yahoo.com','Delhi','Delhi','2020-08-22','Active'),
(11,'Fatima Khan','fatima.khan@gmail.com','Delhi','Delhi','2023-04-01','Active'),
(12,'Luis Fernandes','luis.fernandes@outlook.com','Bengaluru','Karnataka','2022-02-14','Active'),
(13,'Chen Li','chen.li@gmail.com','Mumbai','Maharashtra','2021-10-10','Inactive'),
(14,'Ananya Gupta','ananya.gupta@proton.me','Kolkata','West Bengal','2022-06-06','Active'),
(15,'Divya Menon','divya.menon@gmail.com','Bengaluru','Karnataka','2021-03-08','Active'),
(16,'Arjun Reddy','arjun.reddy@yahoo.com','Mumbai','Maharashtra','2023-08-19','Active');

INSERT INTO orders (order_id, customer_id, order_date, category, channel, payment_method, amount, status) VALUES
(1001,1,'2024-01-05','Electronics','Online','UPI',43000,'Delivered'),
(1002,2,'2024-01-06','Grocery','Store','UPI',1440,'Delivered'),
(1003,8,'2024-01-10','Home','Online','Card',10500,'Delivered'),
(1004,6,'2024-01-12','Grocery','Store','Cash',2000,'Delivered'),
(1005,5,'2024-01-15','Fashion','Online','Card',4700,'Delivered'),
(1006,4,'2024-01-20','Electronics','Store','Card',60000,'Delivered'),
(1007,10,'2024-02-02','Grocery','Online','UPI',1425,'Delivered'),
(1008,11,'2024-02-05','Fashion','Store','Card',5800,'Delivered'),
(1009,14,'2024-02-10','Grocery','Store','Cash',880,'Delivered'),
(1010,14,'2024-02-12','Home','Online','NetBanking',16000,'Shipped'),
(1011,1,'2024-03-01','Fashion','Store','UPI',6200,'Shipped'),
(1012,13,'2024-03-03','Electronics','Online','Card',30000,'Cancelled'),
(1013,8,'2024-03-08','Electronics','Store','UPI',43000,'Delivered'),
(1014,10,'2024-03-10','Home','Online','UPI',20000,'Returned'),
(1015,5,'2024-03-18','Home','Store','Cash',10000,'Delivered'),
(1016,7,'2024-04-01','Fashion','Online','UPI',1800,'Cancelled'),
(1017,2,'2024-04-05','Home','Store','Card',9000,'Delivered'),
(1018,14,'2024-04-10','Electronics','Online','Card',27000,'Delivered'),
(1019,4,'2024-04-12','Grocery','Store','Cash',1300,'Delivered'),
(1020,11,'2024-05-02','Electronics','Online','Card',38000,'Delivered'),
(1021,15,'2024-05-11','Fashion','Online','UPI',6200,'Delivered'),
(1022,16,'2024-05-20','Home','Online','UPI',10000,'Delivered');

select * from customers;
select * from orders;

#List all orders with customer full_name, city, and order amount, only for customers in Bengaluru, ordered by amount descending.
select *
from customers as c
left join orders as o
on o.customer_id=c.customer_id
where c.city="Bengaluru"
order by o.amount desc;


#Show each customer with the total number of orders they have placed; include customers with zero orders; order by order count descending, then name ascending.
select c.full_name, c.customer_id, count(o.order_id) as co
from customers as c
left join orders as o
on c.customer_id=o.customer_id 
group by c.full_name, c.customer_id
having count(o.order_id) >= 0
order by co desc, c.full_name asc;


#Show each city and the total revenue (SUM(amount)) from delivered orders only; keep only cities where delivered revenue is at least 20000; order by revenue descending.
select sum(o.amount) as tr ,c.city, o.status
from customers as c
right join orders as o
on o.customer_id=c.customer_id
group by c.city, o.status
having o.status="Delivered" and sum(o.amount) >= 20000
order by tr desc;
#-------OR
SELECT c.city, SUM(o.amount) AS delivered_revenue
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.city
HAVING SUM(o.amount) >= 20000
ORDER BY delivered_revenue DESC;


#List customers who have at least 2 orders in the Online channel; show their name and order count; order by count descending.
select c.full_name, count(o.channel) as co, o.channel
from customers as c
right join orders as o
on o.customer_id=c.customer_id 
group by c.full_name,o.channel
having count(*) >= 2 and channel="Online"
order by co desc;


#For each payment method, show total revenue and average order amount for orders that are not cancelled; order by total revenue descending.
select o.payment_method, sum(o.amount) as tr, avg(o.amount), o.status
from orders as o
where o.status not in ("Cancelled")
group by o.payment_method, o.status
order by tr desc;

SELECT o.payment_method,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS avg_order_amount
FROM orders o
WHERE o.status <> 'Cancelled'
GROUP BY o.payment_method
ORDER BY total_revenue DESC;

# "<>" ka meaning kya hai ??  iska meaning not eaqual to hai


#For each customer status (Active/Inactive), show the count of distinct customers who have at least one delivered order.
select count(distinct(c.customer_id)), c.status, o.status
from customers as c
left join orders as o
on c.customer_id=o.customer_id
group by c.status, o.status
having o.status="delivered" and count(o.status) >=1;


#Show all customers who have never placed any order, along with their signup_date, ordered by signup_date.
select c.full_name, o.order_id, c. signup_date
from customers as c
left join orders as o
on c.customer_id=o.customer_id
where o.order_id is null
group by c.full_name, o.order_id, c. signup_date
order by signup_date;


#For each state, show the number of delivered orders and total delivered revenue; order by delivered revenue descending.
select c.state, count(o.status), sum(o.amount) as tr, o.status
from customers as c
left join orders as o
on c.customer_id=o.customer_id
where o.status="delivered"
group by c.state, o.status
order by tr desc;


#List the top 3 customers by total delivered revenue; show customer name and total delivered revenue.
select c.full_name, sum(o.amount) as tr, o.status
from customers as c
left join orders as o
on c.customer_id=o.customer_id
where o.status="delivered"
group by c.full_name, o.status
order by tr desc limit 3;


#For each category, show (a) number of orders and (b) total revenue, but only for orders between 2024-02-01 and 2024-04-30; order by total revenue descending.
select count(o.order_id), sum(o.amount), c.signup_date, o.category
from customers as c
left join orders as o
on c.customer_id=o.customer_id
where c.signup_date between '2024-02-01' and '2024-04-30' and o.category in ("online","store")
group by o.category, c.signup_date
order by sum(o.amount) desc;
#iska output null aega kyoki signup_/dates table me hai hi nahi


#Show each customer with their latest order date (if they have orders), and list customers even if they have no orders; order by latest date descending, then name.
select c.full_name, max(o.order_date) as latest_order
from customers as c
left join orders as o
on c.customer_id=o.customer_id
group by c.full_name
order by max(o.order_date) desc, c.full_name asc;


#Show cities where the number of cancelled orders is greater than the number of returned orders; include both counts and order by cancelled count descending.
select c.city, count(o.status=("cancelled")) as sc, count(o.status=("returned")) as sr
from customers as c
right join orders as o
on o.customer_id=c.customer_id
group by c.city
having count(o.status=("cancelled")) > count(o.status=("returned"))
order by count(o.status=("cancelled")) desc;

#-----is question ka output aega city me hyderabad, mumbai jaha cancelled count dono me 1 hai aur returned count dono me 0 hai

SELECT c.city,
       SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_count,
       SUM(CASE WHEN o.status = 'Returned' THEN 1 ELSE 0 END) AS returned_count
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) >
       SUM(CASE WHEN o.status = 'Returned' THEN 1 ELSE 0 END)
ORDER BY cancelled_count DESC;


#For each customer, show total revenue from Electronics orders only; exclude customers whose email ends with @yahoo.com; order by electronics revenue descending.
select c.full_name, o.category, c.email, sum(o.amount)
from customers as c
left join orders as o
on c.customer_id=o.customer_id
where o.category=("electronics") and c.email not like "%@yahoo.com"
group by c.full_name, o.category, c.email
order by sum(o.amount) desc;

SELECT c.customer_id, c.full_name,
       COALESCE(SUM(o.amount), 0) AS electronics_revenue
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id  AND o.category = 'Electronics'
WHERE c.email NOT LIKE '%@yahoo.com'
GROUP BY c.customer_id, c.full_name
ORDER BY electronics_revenue DESC, c.full_name ASC;

#---AND operator ON ka extended part hai taaki customer count(ka matlab first table ke customers srf email ke basis me filter honge na ki email aur category dono) kam na ho 
#So: the AND is used in the ON clause to restrict which orders get joined without losing customers.
#COALESCE(SUM(o.amount), 0) kisi bhi table ke column ki value null hai to hum null show krne ke bjaye 0 show krte hai

#Show customers who have orders in more than one distinct category; display name and distinct category count; order by category count descending.
select count(distinct(o.category)) as cdo, c.full_name
from customers as c
left join orders as o
on c.customer_id=o.customer_id
group by c.full_name
having count(distinct(o.category)) > 1
order by cdo desc;


#For each month (based on order_date), show total revenue and number of distinct customers who ordered; order by month ascending.
select count(distinct(o.customer_id)) as dc,date_format(o.order_date,'%y-%m-01') as om, sum(o.amount)
from orders as o
group by om
order by om asc;

SELECT DATE_FORMAT(o.order_date, '%Y-%m-01') AS order_month,
       SUM(o.amount) AS total_revenue,
       COUNT(DISTINCT o.customer_id) AS distinct_customers
FROM orders o
GROUP BY order_month
ORDER BY order_month ASC;


