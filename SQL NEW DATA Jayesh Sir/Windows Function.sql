CREATE DATABASE krishna_db;

USE krishna_db;

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

















