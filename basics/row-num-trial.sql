USE temp;

CREATE TABLE employee_sales (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  employee_name VARCHAR(50) NOT NULL,
  department VARCHAR(30) NOT NULL,
  sale_date DATE NOT NULL,
  amount DECIMAL(10,2) NOT NULL
);

INSERT INTO employee_sales (employee_id, employee_name, department, sale_date, amount) VALUES
(101,'Asha','Payments','2025-01-10',1200.00),
(101,'Asha','Payments','2025-01-15', 800.00),
(101,'Asha','Payments','2025-02-02',1500.00),

(102,'Ravi','Payments','2025-01-11', 700.00),
(102,'Ravi','Payments','2025-02-01',1100.00),
(102,'Ravi','Payments','2025-02-20', 600.00),

(201,'Meera','Search','2025-01-05', 900.00),
(201,'Meera','Search','2025-01-25',1300.00),
(201,'Meera','Search','2025-02-10', 500.00),

(202,'Arjun','Search','2025-01-07', 400.00),
(202,'Arjun','Search','2025-02-05',1600.00),

(301,'Neha','Ads','2025-01-03',2000.00),
(301,'Neha','Ads','2025-02-03', 300.00),
(302,'Vikram','Ads','2025-01-21', 950.00),
(302,'Vikram','Ads','2025-02-14',1050.00);

SELECT * FROM employee_sales;

#For each department, return the single sale row with the highest amount (include all columns). Use ROW_NUMBER() to break ties by most recent sale_date.
WITH sales_cte as ( SELECT employee_id, employee_name, department, sale_date, amount,
ROW_NUMBER() OVER (PARTITION BY department ORDER BY sale_date, amount desc) as row_num
from employee_sales) 
select * from sales_cte 
WHERE row_num <= 1;

WITH ranked AS (
  SELECT
    es.*,
    ROW_NUMBER() OVER (
      PARTITION BY department
      ORDER BY amount DESC, sale_date DESC
    ) AS rn
  FROM employee_sales es
)
SELECT
  id, employee_id, employee_name, department, sale_date, amount
FROM ranked
WHERE rn = 1;



#For each employee_id, return only the latest sale (by sale_date; if same date, use higher amount as tie-breaker).
WITH sales_cte as (SELECT employee_id, sale_date,
RoW_NUMBER() OVER (PARTITION BY employee_id ORDER BY sale_date desc, amount desc) as row_num
from employee_sales )
SELECT employee_id,sale_date as max_sale 
from sales_cte
where row_num <= 1;

WITH ranked AS (
  SELECT
    es.*,
    ROW_NUMBER() OVER (
      PARTITION BY employee_id
      ORDER BY sale_date DESC, amount DESC
    ) AS rn
  FROM employee_sales es
)
SELECT
  id, employee_id, employee_name, department, sale_date, amount
FROM ranked
WHERE rn = 1;



#Within each department, list all sales and add a column dept_sale_seq that numbers sales in chronological order (sale_date ascending; if same date, id ascending).
WITH sales_cte as ( SELECT employee_id, employee_name, department, sale_date,
ROW_NUMBER () OVER (PARTITION BY department ORDER BY sale_date asc, id asc) as dept_sale_seq
from employee_sales )
SELECT * FROM sales_cte;

SELECT
  es.*,
  ROW_NUMBER() OVER (
    PARTITION BY department
    ORDER BY sale_date ASC, id ASC
  ) AS dept_sale_seq
FROM employee_sales es
ORDER BY department, dept_sale_seq;


#For each (department, month), return the top 2 sales by amount. Month should be derived from sale_date (e.g., 2025-01, 2025-02), and ties should be resolved by sale_date descending.
WITH sales_cte as (SELECT employee_id, employee_name, department, sale_date, amount,
ROW_NUMBER() OVER (PARTITION BY department ORDER BY amount desc, sale_date) as top_2 from employee_sales 
where month(sale_date)=1 or month(sale_date)=2)
SELECT * FROM sales_cte
where top_2 <= 2 ;

WITH ranked AS (
  SELECT
    es.*,
    DATE_FORMAT(sale_date, '%Y-%m') AS ym,
    ROW_NUMBER() OVER (
      PARTITION BY department, DATE_FORMAT(sale_date, '%Y-%m')
      ORDER BY amount DESC, sale_date DESC
    ) AS rn
  FROM employee_sales es
)
SELECT
  id, employee_id, employee_name, department, ym, sale_date, amount
FROM ranked
WHERE rn <= 2
ORDER BY department, ym, rn;









