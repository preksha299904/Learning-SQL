use orders;

CREATE TABLE employee_payments (
  payment_id INT PRIMARY KEY,
  emp_id INT NOT NULL,
  emp_name VARCHAR(80) NOT NULL,
  department VARCHAR(40) NOT NULL,
  city VARCHAR(50) NOT NULL,
  pay_month DATE NOT NULL,      -- use first day of month (e.g., 2024-03-01)
  base_salary INT NOT NULL,
  bonus INT NOT NULL,
  status VARCHAR(20) NOT NULL   -- Active/Inactive
);

INSERT INTO employee_payments
(payment_id, emp_id, emp_name, department, city, pay_month, base_salary, bonus, status)
VALUES
(1, 101,'Asha','Engineering','Bengaluru','2024-01-01',90000,5000,'Active'),
(2, 102,'Ravi','Engineering','Bengaluru','2024-01-01',85000,3000,'Active'),
(3, 103,'Meera','HR','Mysuru','2024-01-01',65000,2000,'Active'),
(4, 104,'John','Engineering','Pune','2024-01-01',100000,8000,'Active'),
(5, 105,'Sara','Finance','Mumbai','2024-01-01',70000,0,'Inactive'),
(6, 101,'Asha','Engineering','Bengaluru','2024-02-01',90000,6000,'Active'),
(7, 102,'Ravi','Engineering','Bengaluru','2024-02-01',85000,0,'Active'),
(8, 103,'Meera','HR','Mysuru','2024-02-01',65000,2500,'Active'),
(9, 104,'John','Engineering','Pune','2024-02-01',100000,7000,'Active'),
(10,106,'Kiran','Engineering','Hyderabad','2024-02-01',88000,2000,'Active'),
(11,107,'Neha','HR','Hyderabad','2024-02-01',62000,1500,'Active'),
(12,108,'Vikram','Engineering','Chennai','2024-03-01',91000,0,'Active'),
(13,109,'Priya','Finance','Chennai','2024-03-01',72000,2500,'Active'),
(14,110,'Amit','Engineering','Delhi','2024-03-01',87000,1000,'Active'),
(15,111,'Fatima','HR','Delhi','2024-03-01',61000,1500,'Active'),
(16,112,'Luis','Finance','Bengaluru','2024-03-01',73000,0,'Active');

SELECT * FROM employee_payments;

#Find employees whose total pay (base_salary + bonus) is greater than the overall average total pay across all rows.
select emp_name, (base_salary + bonus)
from employee_payments
where (base_salary + bonus) > (select avg(base_salary + bonus) from employee_payments as t);

#Find the employee(s) who received the maximum bonus in the entire table and return their emp_name, department, and pay_month.
select *
from employee_payments
where bonus = (select max(bonus) from employee_payments);

#Return all rows for employees who have at least one payment row with bonus = 0, but exclude the rows where bonus = 0 from the final output.
select *
from employee_payments
where bonus <> 0 and emp_id in (select emp_id from employee_payments where bonus =0);

#List departments where the average base salary is greater than the average base salary of the HR department.
select department, avg(base_salary) as abs
from employee_payments
group by department
having abs > (select avg(base_salary) from employee_payments where department= "HR");

#For each city, return the row(s) corresponding to the highest total pay (base_salary + bonus) within that city.
select city, max(base_salary + bonus)
from employee_payments
group by city;

#Show the month(s) where total bonus paid (sum of bonus) is greater than the total bonus paid in 2024-02-01.
select pay_month, sum(bonus) as sb
from employee_payments
group by pay_month
having sb > (select sum(bonus) from employee_payments where pay_month='2024-02-01');
# iska output null aega kyoki value greater nahi hai

select distinct(pay_month),sum(bonus)
from employee_payments
group by pay_month;


#Return employees (unique emp_id, emp_name) who appear in every month present in the table.
select emp_name, emp_id, count(pay_month) as cp
from employee_payments
group by emp_name, emp_id
having cp > 1 and emp_name in (select emp_name from employee_payments);

# cp=month_count krne se jitne bhi months me nam repeat hua h vo show kr dega, yaha every month bola h to cp=3 use kr skte hain


