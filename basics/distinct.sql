create database Company;

USE Company;

CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  department VARCHAR(50) NOT NULL,
  salary INT NOT NULL,
  join_date DATE NOT NULL,
  manager_name VARCHAR(50),
  status VARCHAR(20) NOT NULL
);

INSERT INTO employees (emp_id, emp_name, city, state, country, department, salary, join_date, manager_name, status) VALUES
(1,'Asha','Bengaluru','Karnataka','India','Engineering',90000,'2023-01-10',NULL,'Active'),
(2,'Ravi','Bengaluru','Karnataka','India','Engineering',85000,'2023-02-15','Asha','Active'),
(3,'Meera','Mysuru','Karnataka','India','HR',60000,'2022-11-01',NULL,'Active'),
(4,'John','Pune','Maharashtra','India','Engineering',95000,'2021-07-20','Ravi','Active'),
(5,'Sara','Mumbai','Maharashtra','India','Finance',70000,'2020-05-05',NULL,'Inactive'),
(6,'Kiran','Hyderabad','Telangana','India','Engineering',88000,'2023-03-12','Asha','Active'),
(7,'Neha','Hyderabad','Telangana','India','HR',62000,'2022-09-30','Meera','Active'),
(8,'Vikram','Chennai','Tamil Nadu','India','Engineering',91000,'2019-12-01','John','Active'),
(9,'Priya','Chennai','Tamil Nadu','India','Finance',72000,'2021-01-18','Sara','Active'),
(10,'Amit','Delhi','Delhi','India','Engineering',87000,'2020-08-22','Ravi','Active'),
(11,'Fatima','Delhi','Delhi','India','HR',61000,'2023-04-01','Meera','Active'),
(12,'Luis','Bengaluru','Karnataka','India','Finance',73000,'2022-02-14','Sara','Active'),
(13,'Chen','Mumbai','Maharashtra','India','Engineering',92000,'2021-10-10','John','Inactive'),
(14,'Ananya','Kolkata','West Bengal','India','Engineering',86000,'2022-06-06','Asha','Active');

select * from employees;

#Write a query to list all distinct departments present in employees.
select distinct(department)
from employees;

#Write a query to list all distinct cities where employees are located.
select distinct(city)
from employees;

#Write a query to return distinct (city, department) combinations (each unique pair only once
select m.city, m.department
from employees as e
join employees as m
on e.department=m.department
group by city, department
having count(distinct(m.city))=1;

#OR

SELECT DISTINCT city, department
FROM employees
ORDER BY city, department;


#Write a query to find all distinct manager_name values, excluding NULLs.
select distinct(manager_name)
from employees
where manager_name is not null;

#Write a query to count how many distinct states appear in the table (single number output).
select count(distinct(state))
from employees;

#Write a query to list distinct status values for employees in the Engineering department only.
select distinct(status)
from employees
where department="Engineering";

#Write a query to list all distinct join years from join_date (e.g., 2019, 2020, …).
select distinct year(join_date) as join_year 
from employees
order by join_year;