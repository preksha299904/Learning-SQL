use orders;

CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(80) NOT NULL,
  manager_id INT NULL,
  department VARCHAR(40) NOT NULL,
  city VARCHAR(50) NOT NULL,
  salary INT NOT NULL,
  join_date DATE NOT NULL
);

INSERT INTO employees (emp_id, emp_name, manager_id, department, city, salary, join_date) VALUES
(1,  'Asha',    NULL,  'Engineering', 'Bengaluru', 95000, '2020-01-10'),
(2,  'Ravi',     1,    'Engineering', 'Bengaluru', 85000, '2021-02-15'),
(3,  'Meera',    NULL,  'HR',         'Bengaluru', 70000, '2019-11-01'),
(4,  'John',     1,    'Engineering', 'Pune',      105000,'2018-07-20'),
(5,  'Sara',     3,    'HR',         'Mumbai',    68000,  '2021-05-05'),
(6,  'Kiran',    2,    'Engineering', 'Hyderabad', 88000, '2022-03-12'),
(7,  'Neha',     3,    'HR',         'Hyderabad', 72000,  '2020-09-30'),
(8,  'Vikram',   4,    'Engineering', 'Chennai',   91000, '2019-12-01'),
(9,  'Priya',    5,    'HR',         'Chennai',   65000,  '2022-01-18'),
(10, 'Amit',     2,    'Engineering', 'Delhi',     87000, '2020-08-22'),
(11, 'Fatima',   3,    'HR',         'Delhi',     71000,  '2023-04-01'),
(12, 'Luis',     4,    'Engineering', 'Bengaluru', 93000, '2021-02-14');

select * from employees;

#List each employee with their manager’s name. Show columns: employee_name, manager_name. For top-level managers (no manager_id), show them with NULL manager_name.
select a.emp_name, b.emp_name as manager_name
from employees as a
join employees as b
on b.emp_id=a.manager_id;

#List employees who are in the same department as their manager but located in a different city from their manager. Show employee_name, employee_city, manager_name, manager_city.
select a.emp_name, a.city, b.emp_name as manager_name, b.city as manager_city
from employees as a
join employees as b
on b.emp_id=a.manager_id
where b.city <> a.city;

#For each manager, show the number of direct reports and the total salary of those direct reports. Include only managers who have at least 2 direct reports. Show manager_name, report_count, total_report_salary.
select b.emp_name as manager_name, count(a.emp_id) , sum(a.salary)
from employees as a
join employees as b
on b.emp_id=a.manager_id
group by b.emp_name
having count(a.emp_id) >= 2;


#List all pairs of employees who work in the same city and same department, where one employee joined earlier than the other. Show older_emp_name, older_emp_join_date, 
#younger_emp_name, younger_emp_join_date. Avoid duplicate symmetric pairs.

select a.emp_name as old_emp_name, a.join_date as old_join_date, b.emp_name as new_emp_name, b.join_date as new_join_date, a.city, a.department
from employees as a
join employees as b
on b.city=a.city and b.department=a.department
where b.join_date > a.join_date;


#List managers whose average salary of direct reports is greater than the manager’s own salary. Show manager_name, manager_salary, avg_report_salary.
select  b.emp_name as manager_name, count(a.emp_id) , avg(a.salary) as avg_report_salary, b.salary as manager_salary
from employees as a
join employees as b
on b.emp_id=a.manager_id
group by b.emp_name, b.salary
having count(a.emp_id) >= 2 AND avg(a.salary) > b.salary;



#List all employees who share the same manager and also share the same city, i.e., “colleagues under the same manager in the same city.” 
#Show manager_name, emp1_name, emp2_name, city. Each pair should appear only once (no reversed duplicates).

select a.emp_name as emp_1, b.emp_name as emp_2, m.emp_name as manager_name, a.city
from employees as a
join employees as b
on a.manager_id=b.manager_id and a.city=b.city and a.emp_id < b.emp_id
join employees as m
on m.emp_id=a.manager_id;

SELECT
  m.emp_name AS manager_name,
  e1.city,
  e1.emp_name AS emp_1,
  e2.emp_name AS emp_2
FROM employees e1
JOIN employees e2
  ON e1.manager_id = e2.manager_id
 AND e1.city = e2.city
 AND e1.emp_id < e2.emp_id      
JOIN employees m
  ON m.emp_id = e1.manager_id;
  
  SELECT m.emp_name AS manager_name, e1.city,
       e1.emp_name AS emp1_name, e2.emp_name AS emp2_name
FROM employees e1
JOIN employees e2
  ON e1.manager_id = e2.manager_id
 AND e1.city = e2.city
 AND e1.emp_id < e2.emp_id
JOIN employees m
  ON m.emp_id = e1.manager_id
ORDER BY manager_name, e1.city, emp1_name, emp2_name;

  
  
  #output teeno me nahi ara hai
