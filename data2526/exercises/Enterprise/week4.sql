--oef1
SELECT d.department_id
     ,department_name
     ,project_id
     ,project_name
     ,location
FROM DEPARTMENTS d, PROJECTS ;


--oef 2

SELECT d.department_id, d.manager_id, e.last_name, e.salary, e.parking_spot
FROM departments d
    JOIN employees e
     ON (d.manager_id= e.employee_id)
ORDER BY d.department_id;


--oef 3

SELECT
    j.project_name,
    j.location,
    CONCAT_ws(' ',e.first_name, e.infix,e.last_name) AS full_name,
    e.department_id
FROM employees e
         JOIN tasks t
              ON e.employee_id = t.employee_id
         JOIN projects j
              ON t.project_id = j.project_id
ORDER BY e.department_id;

--oef 4

SELECT
    j.project_name,
    j.location,
    CONCAT_ws(' ',e.first_name, e.infix,e.last_name) AS full_name,
    e.department_id
FROM employees e
         JOIN tasks t
              ON e.employee_id = t.employee_id
         JOIN projects j
              ON t.project_id = j.project_id
         JOIN departments d
              ON j.department_id = d.department_id
WHERE UPPER(j.location) = 'EINDHOVEN'
   OR LOWER(d.department_name) = 'administration'
ORDER BY e.last_name;

--oef 5

SELECT
    CONCAT_ws(' ',e.first_name, e.infix,e.last_name) AS full_name,
    fm.name,
    fm.gender,
    TO_CHAR(fm.birth_date, 'DD-MM-YYYY' ) as "Date Of birth"
FROM employees e
    JOIN FAMILY_MEMBERS fm
        ON e.employee_id = fm.employee_id
WHERE LOWER(relationship) in ('SON','DAUGHTER')
ORDER BY 1,fm.birth_date;


--oef 6

SELECT
    e2.last_name AS last_name_jochems,
    e2.location AS city_jochems,
    e1.last_name AS last_name,
    e1.location AS city
FROM employees e1
         JOIN employees e2
              ON e2.last_name = 'Jochems'
WHERE UPPER(e1.gender) = 'M'
  AND LOWER(e1.location) != LOWER(e2.location);

SELECT
    e2.last_name AS last_name_jochems,
    e2.location AS city_jochems,
    e1.last_name AS last_name,
    e1.location AS city
FROM employees e1
         JOIN employees e2
             ON LOWER(e1.location) != LOWER(e2.location)
WHERE UPPER(e1.gender) = 'M'
  AND e2.last_name = 'Jochems';
--oef 7

SELECT
    employee_id,
    last_name,
    birth_date
FROM employees e1
JOIN employees e2
ON TO_CHAR(e1.birth_date, 'month')=TO_CHAR(e2.birth_date, 'month')
AND e1.employee_id != e2.employee_id
ORDER BY EXTRACT(MONTH FROM birth_date), last_name, first_name;


--Oef 8
SELECT project_id, project_name, location, department_id
FROM projects
WHERE department_id = (
    SELECT department_id
    FROM projects
    WHERE project_id = 3
)
  AND project_id <> 3;

--oef 9
SELECT e1.first_name,
       e2.last_name AS "boss",
       e3.last_name AS "uberboss"
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.employee_id
JOIN employees e3 ON e2.manager_id = e3.employee_id
WHERE UPPER(e3.last_name) = 'BORDOLOI';

