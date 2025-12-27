CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  full_name VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL,
  phone VARCHAR(20),
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  signup_date DATE NOT NULL,
  total_spend INT NOT NULL,
  loyalty_tier VARCHAR(20) NOT NULL,   -- Bronze/Silver/Gold/Platinum
  status VARCHAR(20) NOT NULL          -- Active/Inactive
);

INSERT INTO customers
(customer_id, full_name, email, phone, city, state, signup_date, total_spend, loyalty_tier, status)
VALUES
(1,'Asha Rao','asha.rao@gmail.com','9876500011','Bengaluru','Karnataka','2023-01-10',42000,'Gold','Active'),
(2,'Ravi Kumar','ravi.kumar@outlook.com','9876500012','Bengaluru','Karnataka','2023-02-15',15000,'Silver','Active'),
(3,'Meera Nair','meera.nair@yahoo.com','9876500013','Mysuru','Karnataka','2022-11-01',8000,'Bronze','Active'),
(4,'John Mathew','john.mathew@gmail.com','9876500014','Pune','Maharashtra','2021-07-20',65000,'Platinum','Active'),
(5,'Sara Ali','sara.ali@gmail.com','9876500015','Mumbai','Maharashtra','2020-05-05',12000,'Silver','Inactive'),
(6,'Kiran Das','kiran.das@proton.me','9876500016','Hyderabad','Telangana','2023-03-12',26000,'Gold','Active'),
(7,'Neha Singh','neha.singh@gmail.com','9876500017','Hyderabad','Telangana','2022-09-30',5000,'Bronze','Active'),
(8,'Vikram Iyer','vikram.iyer@outlook.com','9876500018','Chennai','Tamil Nadu','2019-12-01',31000,'Gold','Active'),
(9,'Priya Sharma','priya.sharma@gmail.com','9876500019','Chennai','Tamil Nadu','2021-01-18',18000,'Silver','Active'),
(10,'Amit Verma','amit.verma@yahoo.com','9876500020','Delhi','Delhi','2020-08-22',22000,'Gold','Active'),
(11,'Fatima Khan','fatima.khan@gmail.com','9876500021','Delhi','Delhi','2023-04-01',9000,'Bronze','Active'),
(12,'Luis Fernandes','luis.fernandes@outlook.com','9876500022','Bengaluru','Karnataka','2022-02-14',14000,'Silver','Active'),
(13,'Chen Li','chen.li@gmail.com','9876500023','Mumbai','Maharashtra','2021-10-10',47000,'Gold','Inactive'),
(14,'Ananya Gupta','ananya.gupta@proton.me','9876500024','Kolkata','West Bengal','2022-06-06',16000,'Silver','Active'),
(15,'Divya Menon','divya.menon@gmail.com','9876500025','Bengaluru','Karnataka','2021-03-08',29000,'Gold','Active'),
(16,'Arjun Reddy','arjun.reddy@yahoo.com','9876500026','Mumbai','Maharashtra','2023-08-19',11000,'Bronze','Active');

select* from customers;

#Find customers whose city is in (Bengaluru, Mumbai, Delhi).
select *
from customers
where city in ("bengaluru","mumbai","delhi")
order by city;
#order by is optional

#Find customers whose state is NOT IN (Karnataka, Maharashtra).
select *
from customers
where state not in ("karnataka","maharashtra");

#Find customers with total_spend BETWEEN 10000 and 20000 (inclusive).
select *
from customers
where total_spend BETWEEN 10000 and 20000;

#Find customers with signup_date BETWEEN 2022-01-01 and 2022-12-31.
select *
from customers
where signup_date BETWEEN '2022-01-01' and '2022-12-31';

#Find customers whose loyalty_tier is in (Gold, Platinum) AND status is Active.
select *
from customers
where loyalty_tier in ("Gold", "Platinum") AND status="Active";

#Find customers whose customer_id is NOT IN (1, 2, 3, 4).
select *
from customers
where customer_id NOT IN (1, 2, 3, 4);

#Find customers with total_spend NOT BETWEEN 15000 and 40000.
select *
from customers
where total_spend NOT BETWEEN 15000 and 40000;

#Find customers whose signup_date is NOT BETWEEN 2020-01-01 and 2021-12-31.
select *
from customers
where signup_date NOT BETWEEN '2020-01-01' and '2021-12-31';

#Find customers whose city is in (Hyderabad, Chennai) OR whose loyalty_tier is in (Platinum).
select *
from customers
where city in ("Hyderabad", "Chennai") OR loyalty_tier in ("Platinum");

#Find customers whose loyalty_tier is NOT IN (Bronze) AND total_spend BETWEEN 12000 and 30000.
select *
from customers
where loyalty_tier NOT IN ("Bronze") AND total_spend BETWEEN 12000 and 30000;

#Find customers whose full_name starts with A.
select *
from customers
where full_name like "a%";

#Find customers whose full_name ends with a.
select *
from customers
where full_name like "%a";

#Find customers whose email contains @outlook.com.
select *
from customers
where email like "%@outlook.com";

#Find customers whose email ends with @gmail.com.
select *
from customers
where email like "%@gmail.com";

#Find customers whose full_name contains a space (first name + last name)
select *
from customers
where full_name like "% %";

#Find customers whose city starts with Ben (example: Bengaluru).
select *
from customers
where city like "Ben%";

#Find customers whose state contains the word Nadu.
select *
from customers
where state like "%Nadu%";

#Find customers whose full_name has i as the second character (use _ wildcard).
select *
from customers
where full_name like "_i%";

#Find customers whose email starts with chen. (or more generally starts with chen).
select *
from customers
where email like "chen%";

#Find customers whose full_name contains Gupta OR Khan (use LIKE with OR).
select *
from customers
where full_name like"%GUPTA%" OR full_name like"%KHAN%";

