-- ==========================================
-- BASIC DQL & SELECTION
-- ==========================================

-- Select all records from tables
SELECT * FROM departments;
SELECT * FROM employees;

-- Finds the 3rd highest-paid employee earning at least $100,000
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary >= 100000
ORDER BY salary DESC 
LIMIT 1 OFFSET 2;


-- ==========================================
-- AGGREGATIONS (GROUP BY vs WHERE vs HAVING)
-- ==========================================

-- Demonstrating row-level filtering (WHERE) before grouping 
-- versus aggregate group filtering (HAVING)
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    SUM(e.salary) AS total_payroll
FROM employees e
JOIN departments d 
    ON e.department_id = d.department_id
WHERE 
    e.salary >= 90000
GROUP BY 
    d.department_name
HAVING 
    SUM(e.salary) > 200000;


-- ==========================================
-- BASIC JOIN TYPES
-- ==========================================

-- INNER JOIN: Only returns rows where a match exists in BOTH tables (9 rows)
SELECT e.first_name, e.job_title, d.department_name
FROM employees e
INNER JOIN departments d 
    ON e.department_id = d.department_id;

-- LEFT JOIN: Returns ALL employees, even if they have no department (11 rows)
SELECT e.first_name, e.job_title, d.department_name
FROM employees e
LEFT JOIN departments d 
    ON e.department_id = d.department_id;

-- RIGHT JOIN: Returns ALL departments, even if they have no employees (11 rows)
SELECT e.first_name, e.job_title, d.department_name
FROM employees e
RIGHT JOIN departments d 
    ON e.department_id = d.department_id;

-- FULL OUTER JOIN: Returns ALL records from both tables (13 rows)
SELECT e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d 
    ON e.department_id = d.department_id
UNION
SELECT e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d 
    ON e.department_id = d.department_id;

-- CROSS JOIN: Cartesian Product (11 employees x 5 departments = 55 rows)
SELECT e.first_name, d.department_name
FROM employees e
CROSS JOIN departments d 
ORDER BY e.first_name;

SELECT e.first_name, d.department_name
FROM employees e, departments d 
ORDER BY e.first_name;
-- ==========================================
-- ANTI-JOINS (ISOLATING UNMATCHED DATA)
-- ==========================================

-- Left Anti-Join (via LEFT JOIN): Find departments with ZERO employees
SELECT d.department_name
FROM departments d
LEFT JOIN employees e 
    ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- Right Anti-Join (via RIGHT JOIN): Equivalent way to find empty departments
SELECT d.department_name
FROM employees e
RIGHT JOIN departments d 
    ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- Full Anti-Outer Join: Returns all "orphaned" records (unassigned employees AND empty depts)
-- Employees without a department
SELECT e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d 
    ON e.department_id = d.department_id
WHERE d.department_id IS NULL
UNION ALL
-- Departments without any employees
SELECT e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d 
    ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;


-- ==========================================
-- SELF-JOIN
-- ==========================================

-- Self-Join: Pair employees with their direct managers using table aliases
SELECT 
    e.first_name AS employee_name,
    m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m 
    ON e.manager_id = m.employee_id;