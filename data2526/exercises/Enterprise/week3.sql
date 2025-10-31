--oef1.

SELECT DISTINCT employee_id
FROM family_members
WHERE cast(date_part('year', age(birth_date) < 18)
AND UPPER(relationship) IN ('SON', 'DAUGHTER'));

--oef2. moet afgemaakt worden

SELECT  employee_id, last_name,location,AGE(birth_date)
from employees
WHERE date_part('year',AGE(birth_date) > 30)
AND INITCAP(location) in ('EINDHOVEN','MAARSSEN');

--oef3.

SELECT employee_id, DATE_PART('year', AGE(birth_date)) as "age partner"
from family_members
WHERE date_part('year',AGE(birth_date)) BETWEEN 35 and 45
AND upper(relationship) = 'PARTNER';

--oef4.
SELECT first_name,
       last_name,
       TO_CHAR(birth_date, 'DD month yyyy') "Date of birth"
       , TO_CHAR((birth_date + interval '65 years'), 'FMday DD FMmonth YYYY') as pension_date

from employees
ORDER BY pension_date;


--oef5a.
SET lc_time ='en_US';
SELECT name
     , TO_CHAR(birth_date, 'day dd month yyyy') as "born on"

from family_members
ORDER BY birth_date DESC;

--oef5b.
SET lc_time ='en_US';
SELECT name
     , TO_CHAR(birth_date, 'FMday dd FMmonth yyyy') as "born on"

from family_members
ORDER BY birth_date DESC;

--oef5c.
SET lc_time ='fr_FR';
SELECT name
     ,TO_CHAR(birth_date, 'TMday dd TMmonth yyyy') as "born on"

from family_members
ORDER BY birth_date DESC;

--oef6a.
SELECT first_name || ' ' ||last_name
FROM employees;

--oef6b.
SELECT CONCAT(first_name, ' ' , last_name)
from employees;

--oef6c.
SELECT concat(first_name,lpad(last_name, length(last_name)+1), ' ') as naam
from employees
ORDER BY last_name;

--oef7
SELECT RPAD(LOWER(SUBSTR(street, 1 + (LOWER(SUBSTR(street, 1, 1)) = 'z')::int)),30,'*') AS aangepast_adres
FROM employees;

--of

SELECT RPAD(TRIM(LEADING 'z' FROM LOWER(street)),30,'*')
from employees; /* Dit is de klas oplossing en is intuïtiever */

--oef8
SELECT first_name, last_name
from employees
WHERE
    POSITION('o' in LOWER(last_name)) != 0
AND
    POSITION('o' in LOWER(first_name)) != 0;

--Ook dit kan
SELECT  POSITION('o' in LOWER(first_name)) > 0,  POSITION('o' in LOWER(last_name)) > 0
from employees;


--oef9
SELECT last_name
FROM employees
WHERE
    POSITION('oo' IN LOWER(last_name)) > 0
AND POSITION('o' IN SUBSTRING(LOWER(last_name), POSITION('o' IN UPPER(last_name))+2)) = 0; -- +2 is om de oo over te slaan en daarna te gaan zoeken.


--oef10
SELECT
    CONCAT(SUBSTRING(street FROM 1 FOR POSITION('e' IN lower(street))),REPLACE(SUBSTRING(street FROM POSITION('e' IN lower(street)) + 1), 'e', 'o')) AS aangepast_adres
FROM employees;

