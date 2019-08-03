--1. List the following details of each employee: employee number, last name, first name, gender and salary:

SELECT 
	emp.emp_no, emp.last_name, emp.first_name, emp.gender, sal.salary
FROM 
	employees emp
INNER JOIN 
	salaries sal ON emp.emp_no = sal.emp_no
ORDER BY 
	emp.emp_no;

--2. List employees who were hired in 1986:

SELECT * FROM employees 
WHERE 
	hire_date >= '1986-01-01' AND hire_date <='1986-12-31'
ORDER BY 
	hire_date ASC;
	
--3. List the manager of each department with the following information: department number, 
--department name, the manager's employee number, last name, first name, and start and end employment dates:

SELECT 
	dm.emp_no, d.dept_name, dm.emp_no, emp.last_name, emp.first_name, dm.from_date, dm.to_date
FROM  
	employees emp
INNER JOIN
	dept_manager dm ON emp.emp_no = dm.emp_no
INNER JOIN departments d ON dm.dept_no = d.dept_no;

--4. List the department of each employee with the following information: employee number, last name, first name, and department name. 

SELECT
	de.emp_no, emp.last_name, emp.first_name, d.dept_name
FROM 
	employees emp
INNER JOIN 
	dept_emp de ON emp.emp_no = de.emp_no
INNER JOIN
	departments d ON d.dept_no = de.dept_no
ORDER BY
	emp_no ASC;

--5. List all employees whose first name is "Hercules" and last name begins with "B":

SELECT * FROM employees
WHERE
	first_name = 'Hercules' AND last_name LIKE 'B%';
	
--6. List all employees in Sales departmnet, including their employee number, last name, first name, and department name: 

SELECT de.emp_no, emp.last_name, emp.first_name, d.dept_name
FROM dept_emp de
INNER JOIN 
	employees as emp ON de.emp_no = emp.emp_no
INNER JOIN
	departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name: 

SELECT de.emp_no, emp.last_name, emp.first_name, d.dept_name
FROM dept_emp de
INNER JOIN 
	employees as emp ON de.emp_no = emp.emp_no
INNER JOIN
	departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development'

--8. In decending order, list the frequency count of employee last names: 
SELECT last_name, COUNT(last_name) AS "last_name_frequency"
FROM employees
GROUP BY last_name
ORDER BY  last_name_frequency DESC

--doh!
SELECT * FROM employees 
WHERE emp_no = 499942



	
	
	
	

