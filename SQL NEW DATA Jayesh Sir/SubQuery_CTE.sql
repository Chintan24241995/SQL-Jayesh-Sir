-- ==========================================
-- 1. SCALAR SUBQUERY (IN WHERE) VS. CTE
-- Concept: Returns 1 Row, 1 Column (Single Cell)
-- Goal: Find employees who earn more than the company average salary.
-- ==========================================
-- A. Subquery Approach
SELECT first_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) 
    FROM employees
);

-- B. CTE Equivalent
WITH company_avg AS (
    SELECT AVG(salary) AS avg_sal 
    FROM employees
)
SELECT e.first_name, e.salary
FROM employees e
CROSS JOIN company_avg ca
WHERE e.salary > ca.avg_sal;

-- ==========================================
-- 2. MULTI-ROW SUBQUERY (IN WHERE) VS. CTE
-- Concept: Returns 1 Column, Multiple Rows (List of Values)
-- Goal: Find employees working in departments located in 'New York'.
-- ==========================================

-- A. Subquery Approach
SELECT first_name, job_title
FROM employees
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE location = 'New York'
);

-- B. CTE Equivalent
WITH ny_departments AS (
    SELECT department_id 
    FROM departments 
    WHERE location = 'New York'
)
SELECT e.first_name, e.job_title
FROM employees e
JOIN ny_departments ny ON e.department_id = ny.department_id;

-- ==========================================
-- 3. DERIVED TABLE (IN FROM) VS. CTE
-- Concept: Multi-level aggregation where a FROM subquery is strictly required
-- Goal: Find the average department payroll across the company.
-- Note: SQL forbids AVG(SUM(salary)), so we MUST aggregate in two steps.
-- ==========================================

-- A. Subquery Approach
SELECT ROUND(AVG(dept_summary.total_payroll), 2) AS company_avg_dept_payroll
FROM (
    -- Step 1: Calculate total payroll for each department
    SELECT department_id, SUM(salary) AS total_payroll
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
) AS dept_summary; -- MANDATORY ALIAS

-- B. CTE Equivalent
WITH dept_summary AS (
    -- Step 1: Calculate total payroll for each department
    SELECT department_id, SUM(salary) AS total_payroll
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
-- Step 2: Calculate the average of those department totals
SELECT ROUND(AVG(total_payroll), 2) AS company_avg_dept_payroll
FROM dept_summary;

-- ==========================================
-- 4. SUBQUERY IN SELECT CLAUSE VS. CTE
-- Concept: Computes a single summary metric on every row
-- Goal: Show each employee alongside the maximum salary in the company.
-- ==========================================

-- A. Subquery Approach
SELECT 
    first_name, 
    salary,
    (SELECT MAX(salary) FROM employees) AS max_company_salary
FROM employees;

-- B. CTE Equivalent
WITH max_salary_cte AS (
    SELECT MAX(salary) AS max_sal 
    FROM employees
)
SELECT 
    e.first_name, 
    e.salary,
    m.max_sal AS max_company_salary
FROM employees e
CROSS JOIN max_salary_cte m;

-- ==========================================
-- 5. SUBQUERY IN HAVING CLAUSE VS. CTE
-- Concept: Filters aggregated groups using calculated metrics
-- Goal: Find departments whose payroll exceeds the Sales dept (Dept 3) payroll.
-- ==========================================

-- A. Subquery Approach
SELECT d.department_name, SUM(e.salary) AS total_payroll
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > (
    SELECT SUM(salary) 
    FROM employees 
    WHERE department_id = 3
);

-- B. CTE Equivalent
WITH sales_payroll AS (
    SELECT SUM(salary) AS sales_total
    FROM employees
    WHERE department_id = 3
),
dept_payrolls AS (
    SELECT d.department_name, SUM(e.salary) AS total_payroll
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name
)
SELECT dp.department_name, dp.total_payroll
FROM dept_payrolls dp
CROSS JOIN sales_payroll sp
WHERE dp.total_payroll > sp.sales_total;

-- ==========================================
-- 6. SUBQUERY IN JOIN/ON CLAUSE VS. CTE
-- Concept: Pre-aggregates or filters data directly in the join condition
-- Goal: Join employees with their department's average salary metrics.
-- ==========================================

-- A. Subquery Approach
SELECT e.first_name, e.salary, dept_stats.avg_salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
) AS dept_stats ON e.department_id = dept_stats.department_id;

-- B. CTE Equivalent
WITH dept_stats AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT e.first_name, e.salary, ds.avg_salary
FROM employees e
JOIN dept_stats ds ON e.department_id = ds.department_id;

-- ==========================================
-- 7. SUBQUERY IN CASE...WHEN (CONDITIONAL) VS. CTE
-- Concept: Uses dynamic evaluation inside conditional logic branches
-- Goal: Tag employees as 'Above Average' or 'Below Average' dynamically.
-- ==========================================

-- A. Subquery Approach
SELECT 
    first_name,
    salary,
    CASE 
        WHEN salary >= (SELECT AVG(salary) FROM employees) THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_bracket
FROM employees;

-- B. CTE Equivalent
WITH company_avg AS (
    SELECT AVG(salary) AS avg_sal 
    FROM employees
)
SELECT 
    e.first_name,
    e.salary,
    CASE 
        WHEN e.salary >= ca.avg_sal THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_bracket
FROM employees e
CROSS JOIN company_avg ca;

-- ==========================================
-- 8. MULTI-COLUMN / TUPLE SUBQUERY VS. CTE
-- Concept: Compares multiple columns simultaneously (col1, col2)
-- Goal: Find the highest-paid employee in each department.
-- ==========================================

-- A. Subquery Approach
SELECT first_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (
    SELECT department_id, MAX(salary)
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
);

-- B. CTE Equivalent
WITH max_dept_salaries AS (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
)
SELECT e.first_name, e.department_id, e.salary
FROM employees e
JOIN max_dept_salaries m 
    ON e.department_id = m.department_id 
   AND e.salary = m.max_salary;


