SELECT employee_id, last_name,first_name, employees.department_id, department_name
FROM employees
         JOIN departments
              ON employees.department_id = departments.department_id;

--aliases voor de join naam.
SELECT employee_id, last_name,first_name, e.department_id, department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;


--om alleen de vrouwelijke medewerkers te vinden
SELECT employee_id, last_name,first_name, e.department_id, department_name
from employees e
join departments d
    ON (e.department_id = d.department_id)
WHERE UPPER(gender) = 'F';
/*met 3 tabellen kan ook*/



SELECT mw.last_name, mw.department_id
from employees bock
join employees mw
    ON mw.department_id=bock.department_id
WHERE UPPER(bock.last_name) = 'BOCK'
AND bock.employee_id != mw.employee_id;

SELECT mw.salary, mw.last_name, mw.first_name
from employees bock
join employees mw
    ON bock.salary < mw.salary
WHERE UPPER(bock.last_name) = 'BOCK';