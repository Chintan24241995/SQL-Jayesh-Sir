CREATE DATABASE shop_db;

USE shop_db;

-- Create Department Table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

-- Create Employee Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    hire_date DATE,
    job_title VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- Populate Departments
INSERT INTO departments (department_id, department_name, location) VALUES
(1, 'Engineering', 'New York'),
(2, 'Sales', 'Chicago'),
(3, 'Marketing', 'San Francisco'),
(4, 'Human Resources', 'New York'),
(5, 'Legal', 'London');

-- Populate Employees
INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_title, salary, manager_id, department_id) VALUES
(101, 'Alice', 'Smith', 'alice@company.com', '2018-03-15', 'VP of Engineering', 160000.00, NULL, 1),
(102, 'Bob', 'Johnson', 'bob@company.com', '2019-06-01', 'Senior Developer', 120000.00, 101, 1),
(103, 'Charlie', 'Lee', 'charlie@company.com', '2021-01-20', 'Junior Developer', 75000.00, 102, 1),
(104, 'Diana', 'Prince', 'diana@company.com', '2020-11-10', 'Senior Developer', 125000.00, 101, 1),
(105, 'Evan', 'Wright', 'evan@company.com', '2017-08-22', 'Sales Director', 140000.00, NULL, 2),
(106, 'Fiona', 'Gallagher', 'fiona@company.com', '2022-02-14', 'Sales Rep', 65000.00, 105, 2),
(107, 'George', 'Clark', 'george@company.com', '2021-09-01', 'Sales Rep', 68000.00, 105, 2),
(108, 'Hannah', 'Abbott', 'hannah@company.com', '2019-04-12', 'Marketing Lead', 110000.00, NULL, 3),
(109, 'Ian', 'Malcolm', 'ian@company.com', '2023-05-18', 'Marketing Specialist', 58000.00, 108, 3),
(110, 'Julia', 'Roberts', 'julia@company.com', '2020-01-08', 'HR Manager', 95000.00, NULL, 4),
(111, 'Kevin', 'Bacon', 'kevin@company.com', '2023-10-01', 'Contractor', 50000.00, NULL, NULL);