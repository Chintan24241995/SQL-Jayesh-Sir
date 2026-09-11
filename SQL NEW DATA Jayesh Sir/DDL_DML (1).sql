-- Create departments table with auto-incrementing ID, unique code, and positive budget constraint
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_code VARCHAR(10) UNIQUE NOT NULL,
    dept_name VARCHAR(50) NOT NULL,
    budget DECIMAL(10, 2) CHECK (budget > 0)
);

-- Create employees table linked to departments with cascading updates and deletes
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    dept_code VARCHAR(10),
    salary DECIMAL(10, 2) DEFAULT 30000.00,
    CONSTRAINT fk_employees_dept 
        FOREIGN KEY (dept_code) REFERENCES departments(dept_code) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE
);

-- Insert initial sample records into departments
INSERT INTO departments (dept_code, dept_name, budget)
VALUES 
    ('IT', 'Information Technology', 100000.00),
    ('HR', 'Human Resources', 50000.00);

-- Insert initial employee records linked to departments
INSERT INTO employees (full_name, dept_code, salary)
VALUES 
    ('Alice Smith', 'IT', 60000.00),
    ('Bob Jones', 'IT', 55000.00),
    ('Charlie Brown', 'HR', 45000.00);

-- Add a new column to employees
ALTER TABLE employees 
ADD COLUMN phone_number VARCHAR(15);

-- Add a column with 'Active' as the default value for new rows
ALTER TABLE employees 
ADD COLUMN status VARCHAR(20) DEFAULT 'Active';

-- Remove the phone_number column and its data
ALTER TABLE employees 
DROP COLUMN phone_number;

-- Rename full_name column to employee_name
ALTER TABLE employees 
RENAME COLUMN full_name TO employee_name;

-- Rename the table from employees to staff
RENAME TABLE employees TO staff;

-- Expand maximum character length for employee_name
ALTER TABLE staff 
MODIFY COLUMN employee_name VARCHAR(150) NOT NULL;

-- Change salary data type from decimal to integer
ALTER TABLE staff 
MODIFY COLUMN salary INT;

-- Set a new default salary for future inserts
ALTER TABLE staff 
ALTER COLUMN salary SET DEFAULT 35000;

-- Remove the default value constraint from salary
ALTER TABLE staff 
ALTER COLUMN salary DROP DEFAULT;

-- Update salary for a specific employee ID
UPDATE staff 
SET salary = 65000 
WHERE emp_id = 1;

-- Update both salary and department for a specific employee ID
UPDATE staff 
SET salary = 70000, dept_code = 'HR' 
WHERE emp_id = 1;

-- Increase salary by 10% for all IT department staff
UPDATE staff 
SET salary = salary * 1.10 
WHERE dept_code = 'IT';

-- Set salary to 50000 across all rows
UPDATE staff 
SET salary = 50000;

-- Delete a specific employee record by ID
DELETE FROM staff 
WHERE emp_id = 1;

-- Delete all employees earning less than 40000
DELETE FROM staff
WHERE salary < 40000;

-- Display all rows and columns from departments
SELECT * FROM departments;

-- Display all rows and columns from staff
SELECT * FROM staff;

-- Delete all rows from staff line-by-line
TRUNCATE TABLE staff;

-- Insert fresh records into departments using default budget values
INSERT INTO departments (dept_code, dept_name) 
VALUES ('IT', 'Technology'), ('HR', 'Human Resources');

-- Insert fresh child records into staff referencing valid dept_codes
INSERT INTO staff (employee_name, dept_code, salary) 
VALUES ('Alice', 'IT', 20000), ('Bob', 'IT', 30000), ('Charlie', 'HR', 35000);

-- Delete HR department (automatically deletes HR employees due to ON DELETE CASCADE)
DELETE FROM departments 
WHERE dept_code = 'HR';

-- Update IT department code (automatically updates IT employees due to ON UPDATE CASCADE)
UPDATE departments 
SET dept_code = 'TECH' 
WHERE dept_code = 'IT';

-- Display final state of departments table
SELECT * FROM departments;

-- Display final state of staff table to verify cascaded changes
SELECT * FROM staff;

-- Remove staff table first to avoid foreign key dependency errors
DROP TABLE IF EXISTS staff;

-- Remove departments table
DROP TABLE IF EXISTS departments;