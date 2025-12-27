USE Company;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(50) NOT NULL,
  department VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  salary INT NOT NULL,
  join_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL,       -- Active/Inactive
  employment_type VARCHAR(20) NOT NULL -- Full-time/Contract
);

INSERT INTO employees (emp_id, emp_name, department, city, state, salary, join_date, status, employment_type) VALUES
(1,'Asha','Engineering','Bengaluru','Karnataka',92000,'2023-01-10','Active','Full-time'),
(2,'Ravi','Engineering','Bengaluru','Karnataka',85000,'2023-02-15','Active','Full-time'),
(3,'Meera','HR','Mysuru','Karnataka',60000,'2022-11-01','Active','Full-time'),
(4,'John','Engineering','Pune','Maharashtra',105000,'2021-07-20','Active','Contract'),
(5,'Sara','Finance','Mumbai','Maharashtra',70000,'2020-05-05','Inactive','Full-time'),
(6,'Kiran','Engineering','Hyderabad','Telangana',88000,'2023-03-12','Active','Full-time'),
(7,'Neha','HR','Hyderabad','Telangana',62000,'2022-09-30','Active','Contract'),
(8,'Vikram','Engineering','Chennai','Tamil Nadu',91000,'2019-12-01','Active','Full-time'),
(9,'Priya','Finance','Chennai','Tamil Nadu',72000,'2021-01-18','Active','Full-time'),
(10,'Amit','Engineering','Delhi','Delhi',87000,'2020-08-22','Active','Full-time'),
(11,'Fatima','HR','Delhi','Delhi',61000,'2023-04-01','Active','Full-time'),
(12,'Luis','Finance','Bengaluru','Karnataka',73000,'2022-02-14','Active','Contract'),
(13,'Chen','Engineering','Mumbai','Maharashtra',98000,'2021-10-10','Inactive','Full-time'),
(14,'Ananya','Engineering','Kolkata','West Bengal',86000,'2022-06-06','Active','Full-time'),
(15,'Divya','Marketing','Bengaluru','Karnataka',68000,'2021-03-08','Active','Full-time'),
(16,'Arjun','Marketing','Mumbai','Maharashtra',64000,'2023-08-19','Active','Contract');

select * from employees;

#Select all employees who are in Engineering AND located in Bengaluru.
select *
from employees
where department="Engineering" and city="bengaluru";

#Select employees who are in HR OR Marketing.
select *
from employees
where department="Marketing" OR department="HR";

#Select employees who are Active AND have salary greater than or equal to 90000.
select *
from employees
where status="Active" and salary>= 90000;

#Select employees who are in Mumbai OR Chennai AND are Active (use parentheses to make the logic explicit).
select *
from employees
where (city="mumbai" or city="chennai") and status="Active";

#Select employees who are NOT in the Engineering department.
select *
from employees
where not department="engineering";

#Select employees who are Active AND NOT Full-time (i.e., exclude full-time).
select *
from employees
where status="active" and not employment_type="Full-time";

#Select employees who joined on or after 2022-01-01 AND are either in Finance OR HR (use parentheses).
select *
from employees
where join_date>='2022-01-01' and (department="HR" or department="finance");

#Select employees whose state is Karnataka AND (department is Engineering OR Finance).
select *
from employees
where (department="Engineering" OR department="Finance") and state="Karnataka";

#Select employees who are Inactive OR (salary is greater than 95000 AND employment_type is Contract).
select *
from employees
where status="Inactive" or (salary> 95000 and employment_type="contract");

#Select employees who are NOT in Delhi AND NOT in Mumbai.
select *
from employees
where not (city="delhi") and not (city="mumbai");



