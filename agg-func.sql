CREATE DATABASE SHOP;
USE SHOP;

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_name VARCHAR(80) NOT NULL,
  city VARCHAR(50) NOT NULL,
  order_date DATE NOT NULL,
  category VARCHAR(40) NOT NULL,      -- Electronics, Grocery, Fashion, Home
  payment_method VARCHAR(30) NOT NULL, -- UPI, Card, Cash, NetBanking
  quantity INT NOT NULL,
  unit_price INT NOT NULL,
  discount INT NOT NULL,              -- flat discount amount for the order
  status VARCHAR(20) NOT NULL         -- Placed, Shipped, Delivered, Cancelled
);

INSERT INTO orders
(order_id, customer_name, city, order_date, category, payment_method, quantity, unit_price, discount, status)
VALUES
(101,'Asha Rao','Bengaluru','2024-01-10','Electronics','UPI',1,45000,2000,'Delivered'),
(102,'Ravi Kumar','Bengaluru','2024-01-12','Grocery','UPI',10,120,0,'Delivered'),
(103,'Meera Nair','Mysuru','2024-02-01','Fashion','Card',2,2500,300,'Delivered'),
(104,'John Mathew','Pune','2024-02-03','Electronics','Card',1,65000,5000,'Delivered'),
(105,'Sara Ali','Mumbai','2024-02-10','Home','NetBanking',3,3500,500,'Shipped'),
(106,'Kiran Das','Hyderabad','2024-02-15','Grocery','Cash',20,80,0,'Delivered'),
(107,'Neha Singh','Hyderabad','2024-03-02','Fashion','UPI',1,1800,0,'Cancelled'),
(108,'Vikram Iyer','Chennai','2024-03-10','Electronics','UPI',2,22000,1000,'Shipped'),
(109,'Priya Sharma','Chennai','2024-03-12','Home','Card',1,12000,1500,'Delivered'),
(110,'Amit Verma','Delhi','2024-03-20','Grocery','UPI',15,95,0,'Delivered'),
(111,'Fatima Khan','Delhi','2024-04-05','Fashion','Card',4,1500,200,'Delivered'),
(112,'Luis Fernandes','Bengaluru','2024-04-10','Home','NetBanking',2,8000,0,'Delivered'),
(113,'Chen Li','Mumbai','2024-04-18','Electronics','Card',1,30000,0,'Cancelled'),
(114,'Ananya Gupta','Kolkata','2024-05-01','Grocery','Cash',8,110,0,'Delivered'),
(115,'Divya Menon','Bengaluru','2024-05-11','Fashion','UPI',3,2200,400,'Shipped'),
(116,'Arjun Reddy','Mumbai','2024-05-20','Home','UPI',5,2000,0,'Delivered');

select * from orders;

#Find the total number of orders using COUNT(*).
select count(order_id)
from orders;

#Find the number of distinct cities that have orders.
select count(distinct(city)) as city_orders
from orders;

#Find the minimum unit_price across all orders.
select min(unit_price)
from orders;

#Find the maximum unit_price across all orders.
select max(unit_price)
from orders;

#Find the average unit_price across all orders.
select avg(unit_price)
from orders;

#Find the total quantity sold across all orders using SUM(quantity).
select sum(quantity) as total_quantity
from orders;

#Find the total discount given across all orders using SUM(discount).\
select sum(discount) as total_discount
from orders;

#Find the total number of orders with status = 'Delivered'.
select count(order_id) as orders, status
from orders
where status="delivered";

#Find the total revenue (before discount) across all orders as SUM(quantity * unit_price).
select sum(quantity * unit_price) as revenue
from orders;

#Find the net revenue (after discount) across all orders as SUM(quantity * unit_price - discount).
select sum((quantity * unit_price)-discount) as revenue
from orders;

#For each category, find the number of orders (COUNT(*)).
select distinct(category), count(order_id)
from orders
group by category;

#For each category, find the total quantity sold (SUM(quantity)).
select distinct(category), sum(quantity)
from orders
group by category;

#For each payment_method, find the average discount (AVG(discount)).
select distinct(payment_method), avg(discount)
from orders
group by payment_method;

#For each city, find the maximum order value before discount (MAX(quantity * unit_price)).
select max(quantity*unit_price), city
from orders
group by city;

#For each status, find the minimum and maximum unit_price.
select status,max(unit_price), min(unit_price)
from orders
group by status;