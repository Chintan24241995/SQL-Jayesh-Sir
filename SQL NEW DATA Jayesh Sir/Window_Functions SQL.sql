-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE company_db;
USE company_db;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees VALUES
(1, 'Frank',   'Sales', 45000),
(2, 'Charlie', 'IT',    75000),
(3, 'Grace',   'Sales', 55000),
(4, 'David',   'IT',    75000),
(5, 'Eve',     'IT',    90000),
(6, 'Bob',     'HR',    60000),
(7, 'Alice',   'HR',    50000),
(8, 'Heidi',   'Sales', 55000);

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM employees;
-- 1. ROW_NUMBER()

-- Assigns a basic sequential row number to every row in table insertion order
SELECT 
    emp_id, name, department, salary,
    ROW_NUMBER() OVER () AS global_seq
FROM employees;

-- Assigns a unique row number ordered by highest salary first
SELECT 
    emp_id, name, department, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank_seq
FROM employees;

-- Assigns a unique sequence number within each department independently based on insertion order
SELECT 
    emp_id, name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department) AS dept_seq
FROM employees;

-- Assigns a unique sequence number within each department ordered by highest salary first
SELECT 
    emp_id, name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_seq
FROM employees;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. RANK()

-- Ranks all employees by salary globally (ties share the same rank, next rank skips)
SELECT 
    emp_id, name, department, salary,
    RANK() OVER (ORDER BY salary DESC) AS global_salary_rank
FROM employees;

-- Ranks employees by salary within their respective departments (ties share rank, next rank skips)
SELECT 
    emp_id, name, department, salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM employees;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. DENSE_RANK()

-- Ranks all employees by salary globally without skipping numbers after ties
SELECT 
    emp_id, name, department, salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS global_salary_dense_rank
FROM employees;

-- Ranks employees by salary within their respective departments without skipping numbers after ties
SELECT 
    emp_id, name, department, salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_dense_rank
FROM employees;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. LAG()

-- Retrieves the salary from the previous row based on table insertion order (returns NULL for the first row)
SELECT 
    emp_id, name, department, salary,
    LAG(salary) OVER () AS previous_row_salary
FROM employees;

-- Retrieves the salary from the previous row, returning 0 instead of NULL for the first row
SELECT 
    emp_id, name, department, salary,
    LAG(salary, 1, 0) OVER () AS previous_row_salary
FROM employees;

-- Retrieves the salary from 2 rows back, returning 0 instead of NULL for the first two rows
SELECT 
    emp_id, name, department, salary,
    LAG(salary, 2, 0) OVER () AS salary_2_rows_prev
FROM employees;

-- Retrieves the salary of the next higher-paid employee globally (ordered by salary descending)
SELECT 
    emp_id, name, department, salary,
    LAG(salary, 1, 0) OVER (ORDER BY salary DESC) AS next_higher_salary
FROM employees;

-- Retrieves the salary from the previous row within the same department based on insertion order
SELECT 
    emp_id, name, department, salary,
    LAG(salary, 1, 0) OVER (PARTITION BY department) AS dept_prev_salary
FROM employees;

-- Retrieves the salary of the next higher-paid employee within the same department
SELECT 
    emp_id, name, department, salary,
    LAG(salary, 1, 0) OVER (PARTITION BY department ORDER BY salary DESC) AS dept_next_higher_salary
FROM employees;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. LEAD()

-- Retrieves the salary from the next row based on table insertion order (returns NULL for the last row)
SELECT 
    emp_id, name, department, salary,
    LEAD(salary) OVER () AS next_row_salary
FROM employees; 

-- Retrieves the salary from the next row, returning 0 instead of NULL for the last row
SELECT 
    emp_id, name, department, salary,
    LEAD(salary, 1, 0) OVER () AS next_row_salary
FROM employees;

-- Retrieves the salary from 2 rows ahead, returning 0 instead of NULL for the last two rows
SELECT 
    emp_id, name, department, salary,
    LEAD(salary, 2, 0) OVER () AS salary_2_rows_ahead
FROM employees;

-- Retrieves the salary of the next lower-paid employee globally (ordered by salary descending)
SELECT 
    emp_id, name, department, salary,
    LEAD(salary, 1, 0) OVER (ORDER BY salary DESC) AS next_lower_salary
FROM employees;

-- Retrieves the salary from the next row within the same department based on insertion order
SELECT 
    emp_id, name, department, salary,
    LEAD(salary, 1, 0) OVER (PARTITION BY department) AS dept_next_salary
FROM employees;

-- Retrieves the salary of the next lower-paid employee within the same department
SELECT 
    emp_id, name, department, salary,
    LEAD(salary, 1, 0) OVER (PARTITION BY department ORDER BY salary DESC) AS dept_next_lower_salary
FROM employees;

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- 6. Aggregate Window Functions (SUM(), AVG(), MIN(), MAX(), etc)

-- Displays total company payroll alongside every individual employee record
SELECT 
    emp_id, name, department, salary,
    SUM(salary) OVER () AS total_company_payroll
FROM employees;

-- Calculates a cumulative running total of salary across the company ordered alphabetically by employee name
SELECT 
    emp_id, name, department, salary,
    SUM(salary) OVER (ORDER BY name) AS cumulative_payroll_by_name
FROM employees;

-- Displays the total department payroll alongside each employee record in that department
SELECT 
    emp_id, name, department, salary,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_payroll
FROM employees;

-- Calculates a cumulative running total of salary within each department ordered from highest to lowest salary
SELECT 
    name, department, salary,
    SUM(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS dept_running_total_by_salary
FROM employees;