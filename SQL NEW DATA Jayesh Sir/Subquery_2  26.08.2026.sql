USE shop_db;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Correlated Subquery (Row-by-Row Evaluation)
-- Concept: The inner query references columns from the outer query, executing once per row evaluated.
-- Goal: Find employees who earn more than their own department's average salary.
-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Subquery Approach
SELECT e.first_name, e.department_id, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- CTE Equivalent
WITH dept_averages AS (
    SELECT department_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department_id
)
SELECT e.first_name, e.department_id, e.salary
FROM employees e
JOIN dept_averages da ON e.department_id = da.department_id
WHERE e.salary > da.avg_sal;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Set Existence Checking (EXISTS / NOT EXISTS)
-- Concept: Evaluates boolean existence rather than returning scalar values or list matches, stopping evaluation at the first matching record (short-circuiting).
-- Goal: Find departments that have at least one employee earning over $100,000.
-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Subquery Approach
SELECT d.department_id, d.department_name
FROM departments d
WHERE EXISTS (
    SELECT 1 
    FROM employees e 
    WHERE e.department_id = d.department_id 
      AND e.salary > 100000
);

-- CTE Equivalent
WITH high_earners AS (
    SELECT DISTINCT department_id
    FROM employees
    WHERE salary > 100000
)
SELECT d.department_id, d.department_name
FROM departments d
JOIN high_earners he ON d.department_id = he.department_id;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Recursive CTE (Hierarchical / Graph Traversal)
-- Concept: Self-referencing CTE using UNION ALL to traverse parent-child relationships. Subqueries cannot replicate this natively without explicit self-joins to a fixed depth.
-- Goal: Build the complete organizational reporting structure above/below a specific employee.
-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

-- CTE (Recursive)
WITH RECURSIVE OrgChart AS (
    -- Anchor member
    SELECT employee_id, first_name, manager_id, 1 AS depth
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member
    SELECT e.employee_id, e.first_name, e.manager_id, o.depth + 1
    FROM employees e
    JOIN OrgChart o ON e.manager_id = o.employee_id
)
SELECT * FROM OrgChart;



