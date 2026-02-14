use orders;
create table dish(
orderID int PRIMARY KEY,
Dish_name VARCHAR(50),
RestaurantID VARCHAR(50),
Quantity int,
order_date date );

INSERT INTO dish VALUES
(1,"Burger","R101",2,'2025-01-01'),
(2,"Pasta","R101",1,'2025-01-02'),
(3,"Burger","R101",1,'2025-01-03'),
(4,"Pizza","R102",3,'2025-01-04'),
(5,"Burger","R101",4,'2025-01-04'),
(6,"Pasta","R101",2,'2025-01-05');

select * from dish;

select dish_name, sum(quantity) as total
from dish
where restaurantID="R101"
group by dish_name
order by total desc
limit 5;

select dish_name, sum(quantity) as total
from dish
where restaurantID="R102"
group by dish_name
order by total desc
limit 5;
drop table dish;
