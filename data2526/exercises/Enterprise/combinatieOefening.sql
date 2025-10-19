SELECT j.project_name AS "project name",
       e1.employee_id AS "EMP",
       e1.first_name,
       e1.last_name,
       t.hours,
       TO_CHAR(e1.birth_date,'YYYY-MM-DD') AS "to_char",
       TO_CHAR(AGE(e1.birth_date),'YY') AS "age_employee"
    from employees e1
JOIN tasks t ON (e1.employee_id = t.employee_id)
JOIN projects j ON (t.project_id = j.project_id)
WHERE e1.employee_id IN ('999111111','999222222','999555555') AND t.hours > 6

ORDER BY t.hours
FETCH FIRST 3 ROWS ONLY;