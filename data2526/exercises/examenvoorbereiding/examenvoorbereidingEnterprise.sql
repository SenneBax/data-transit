SELECT project_id, project_name, location, department_id
FROM projects;

SELECT project_name, department_id
FROM projects;

SELECT 'project' as "?column?" , project_id, 'is handled by' as "?column?",department_id
FROM projects;

SELECT department_id,first_name
FROM employees
WHERE UPPER(first_name) IN ('DOUGLAS', 'HENK', 'MARTINA', 'SUZAN')
ORDER BY department_id DESC;

SELECT last_name, location, salary
FROM employees
WHERE salary > 30000 AND LOWER(SUBSTR(location , 1, 1)) IN ('m', 'o');

SELECT employee_id, project_id, hours
FROM tasks
WHERE hours IS NOT null
ORDER BY hours DESC
OFFSET 3
FETCH NEXT 3 ROWS ONLY;

SELECT employee_id, last_name, location, AGE(birth_date) "age"
FROM employees
WHERE date_part('years',AGE(birth_date)) > 30 AND UPPER(location) IN ('EINDHOVEN', 'MAARSSEN');

SELECT first_name,
       last_name,
       TO_CHAR(birth_date, 'DD-MM-YYYY') as "Date of birth",
       TO_CHAR((birth_date + interval '65 years'), 'FMday-DD-FMmonth-YYYY' ) as Pension
from employees
ORDER BY Pension;

--**************************************
--Combo exercises week 4 - test in class
--**************************************

/*
------------
--Oefening 3
------------

Toon een overzicht van medewerkers die aan het project 'Ordermanagement' werken,
maar die niet in dezelfde stad wonen als de projectlocatie.
Toon ook het maandelijks salaris zoals in de output.
Sorteer op maandelijks salaris van hoog naar laag.

  project_name   | project_address | Monthly Salary | first_name | last_name | emp_address
-----------------+-----------------+----------------+------------+-----------+-------------
 Ordermanagement | Oegstgeest      | Ç 02083.33     | Shanya     | Pregers   | Eindhoven
(1 row)
*/


--ANTWOORD oefening 3
SELECT p.project_name, p.location as project_adress, ROUND(e.salary/12, 2), e.first_name, e.last_name, e.location as emp_address
FROM employees e
JOIN tasks t
    ON (e.employee_id = t.employee_id)
JOIN projects p
    ON (t.project_id = p.project_id)
WHERE LOWER(p.project_name) IN ('ordermanagement')
  AND LOWER(e.location) NOT IN (LOWER(p.location))
ORDER BY e.salary DESC;

--************************************
--Combo oefeningen week 5 - Self Study
--************************************


------------
--Oef 2
------------
--Lijst de projecten op waarvoor het totaal aantal gewerkte uren meer dan 30 bedraagt, en toon
-- hoeveel medewerkers aan dit project hebben gewerkt (d.w.z. taken hebben uitgevoerd)
-- en de naam van het project
-- en de naam van de afdeling die dit project ondersteunt.
--Sorteer op projectnaam.
-- Zorg ervoor dat je precies de output krijgt zoals hieronder.
-- (bijv. 3 kolommen, aliassen, constanten en aaneenschakelingen)


/*
+-----------+-------------------------------------+------------------------------------------+
|#employees |project                              |department                                |
+-----------+-------------------------------------+------------------------------------------+
|3 employees|perform tasks on Debtors             |which is supported by dept. Administration|
|3 employees|perform tasks on Inventory           |which is supported by dept. Administration|
|3 employees|perform tasks on Ordermanagement     |which is supported by dept. Production    |
|3 employees|perform tasks on Salaryadministration|which is supported by dept. Production    |
|2 employees|perform tasks on Warehouse           |which is supported by dept. Production    |
+-----------+-------------------------------------+------------------------------------------+
*/



SELECT
    COUNT(DISTINCT e.employee_id) || ' employees' AS "#employees",
    'perform tasks on ' || INITCAP(p.project_name) AS "project",
    'which is supported by dept. ' || d.department_name AS "department"
FROM employees e
         JOIN tasks t ON e.employee_id = t.employee_id
         JOIN projects p ON t.project_id = p.project_id
         JOIN departments d ON e.department_id = d.department_id
GROUP BY p.project_name, d.department_name
HAVING SUM(t.hours) > 30
ORDER BY p.project_name;
