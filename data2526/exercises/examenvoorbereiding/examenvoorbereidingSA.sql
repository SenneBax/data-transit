SELECT COUNT(*) "number of enrollments"
FROM enrollments;

SELECT COUNT(DISTINCT section_id) "number of different sections"
FROM enrollments;

SELECT MIN(description) "first in order", MAX(description) "last in order"
FROM courses;

SELECT
    student_id,
    section_id,
    ROUND(AVG(numeric_grade)) AS "average grade homeworks"
FROM grades
WHERE grade_type_code = 'HM'
GROUP BY student_id, section_id
HAVING AVG(numeric_grade) < 80
ORDER BY student_id, section_id;

SELECT course_no "course #", AVG(capacity) "Avg. Capacity", ROUND(AVG(capacity)) "Avg. Capacity without decimals"
FROM sections
WHERE (instructor_id=101)
GROUP BY course_no;


SELECT employer, COUNT(DISTINCT student_id) as "Number of students"
FROM students
GROUP BY employer
HAVING COUNT(DISTINCT student_id) > 4
ORDER BY "Number of students" DESC;

SELECT instructor_id, COUNT(DISTINCT course_no) as "Number of courses"
FROM sections
GROUP BY instructor_id
ORDER BY instructor_id;

SELECT section_id, MAX(numeric_grade)
FROM grades
WHERE section_id BETWEEN 85 AND 93
  AND grade_type_code IN ('MT')
GROUP BY section_id
ORDER BY section_id;

SELECT student_id,ROUND(AVG(numeric_grade))"average evaluation"
FROM grades
GROUP BY student_id
HAVING COUNT(distinct section_id)>2;

SELECT c.course_no, c.description
FROM sections s
RIGHT OUTER JOIN courses c ON (s.course_no = c.course_no)
WHERE section_id IS null
ORDER BY c.course_no;

-- Welke docenten doceerden nog geen cursussecties. Geef ook weer uit welke state ze komen.
SELECT CONCAT_ws(' ', i.first_name, i.last_name) "name lecturer", state
FROM instructors i
LEFT OUTER JOIN sections s on i.instructor_id = s.instructor_id
LEFT OUTER JOIN zipcodes z ON (z.zip=i.zip)
WHERE s.section_id IS null;


-- Toon de niet populaire cursussen (= cursussen waarvoor nog geen inschrijvingen voorkomen).
SELECT s.section_id, c.description unpopular_courses
FROM sections s
JOIN courses c ON s.course_no = c.course_no
LEFT OUTER JOIN enrollments e ON s.section_id = e.section_id
WHERE student_id IS null
ORDER BY section_id;

--23
--Toon de niet populaire cursussen (= cursussen waarvoor nog geen inschrijvingen voorkomen).
SELECT s.section_id,description unpopular_courses
FROM enrollments e
         RIGHT OUTER JOIN sections s ON (s.section_id=e. section_id)
         JOIN courses c ON (s.course_no=c.course_no)
WHERE  e.section_id IS  NULL;



-- Oefening 19
-- Geef voor cursussen met voorvereisten, de beschrijving van de cursus en de beschrijving van
-- de cursus(sen) die voorvereist is (zijn).
SELECT c.course_no "course", c.description "description", c.prerequisite "prerequisite", cpre.description "description prerequisite"
FROM courses c
JOIN courses cpre ON c.prerequisite = cpre.course_no
ORDER BY COURSE;

-- Toon het studentennummer, achternaam en adres van studenten die hetzelfde adres en
-- zipcode hebben. Sorteer op adres.
SELECT e.student_id, e.last_name, e.street_address
FROM students e
JOIN students e2 ON e.street_address=e2.street_address AND  e.zip=e2.zip

WHERE e.student_id <> e2.student_id
ORDER BY e.street_address;

-- Oefening 21
-- Geef een lijst van instructors die in dezelfde gemeente wonen (die dezelfde zipcode hebben)
SELECT DISTINCT i.first_name, i.last_name, i.zip
FROM instructors i
JOIN instructors i2 ON i.zip=i2.zip
WHERE i.instructor_id <> i2.instructor_id
ORDER BY i.zip;

-- Oefening 8
-- Geef een lijst van ingeschreven studenten (studentnr) die in Connecticut (state = ‘CT’)
-- wonen.
SELECT DISTINCT s.student_id, first_name, last_name
FROM students s
JOIN zipcodes z ON s.zip=z.zip
JOIN enrollments e ON (s.student_id = e.student_id)
WHERE UPPER(z.state) = 'CT';

-- Oefening 10
-- Geef voor alle studenten die zich inschreven voor course_no 420 de numeric grade en de
-- letter grade die ze behaalden voor hun eindexamen (grade_type_code=FI).

SELECT 		g.student_id
     , s.first_name
     , s.last_name
     , se.course_no
     ,g.numeric_grade
     ,gc.letter_grade
     ,se.section_id
FROM sections se
         JOIN grades g ON g.section_id = se.section_id
         JOIN grade_conversions gc ON numeric_grade BETWEEN min_grade AND max_grade
         JOIN students s ON g.student_id = s.student_id
WHERE se.course_no = 420
  AND g.grade_type_code = 'FI';

SELECT s.first_name, s.last_name, e.student_id, TO_CHAR(e.enroll_date,  'YYYY-DD-MM')
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
WHERE e.enroll_date < TO_DATE('2021-02-03', 'YYYY-MM-DD')
ORDER BY last_name;

SELECT c.course_no, c.description, s.section_no
FROM courses c
JOIN sections s ON c.course_no = s.course_no
WHERE c.prerequisite IS NULL
ORDER BY c.course_no, s.section_no;

SELECT e.student_id, s.course_no, TO_CHAR(e.enroll_date, 'MM/DD/YYYY HH:MI PM') as "enrolled", s.section_id
FROM sections s
JOIN enrollments e ON s.section_id = e.section_id
JOIN courses c ON s.course_no = c.course_no
WHERE UPPER(description)='INTRO TO INFORMATION SYSTEMS'
ORDER BY e.student_id;

-- Oefening 7
-- Maak een mailing-adressenlijst van docenten die secties hebben gegeven met
-- startdatum in april 2021.

SELECT CONCAT_ws(' ',i.first_name, i.last_name) "name", i.street_address, CONCAT(zip.city, ',', zip.state, ' ', zip.zip) "city_state_zip", s.start_date_time "start_date", s.section_id "section"
FROM instructors i
JOIN zipcodes zip ON zip.zip = i.zip
JOIN sections s ON s.instructor_id = i.instructor_id
WHERE TO_CHAR(s.start_date_time,'mm-yyyy') = '04-2021'
ORDER BY name, start_date ;

-- Oefening 9
-- Toon alle punten die student Daniel Wicelinski behaalde voor section_id 87.

SELECT CONCAT_ws(' ',s.first_name, s.last_name) "name", e.section_id, g.grade_type_code ||' '|| g.grade_code_occurrence AS evaluation_type, g.numeric_grade
FROM enrollments e
JOIN grades g ON g.student_id = e.student_id AND g.section_id = e.section_id
JOIN students s ON e.student_id = s.student_id
WHERE UPPER(CONCAT_ws(' ',s.first_name, s.last_name)) = 'DANIEL WICELINSKI'
AND e.section_id = 87;

SELECT LOWER(c.description) "description", s.section_no, s.location, s.capacity
FROM sections s
         JOIN courses c ON c.course_no = s.course_no
WHERE UPPER(s.location) = 'L211'
    ORDER BY c.description;

SELECT s.first_name, s.last_name, numeric_grade
FROM students s
         JOIN enrollments e ON e.student_id = s.student_id
         JOIN grades g ON e.student_id = g.student_id AND e.section_id = g.section_id
WHERE g.grade_type_code='PJ' AND numeric_grade > 98;

SELECT s.section_id, s.start_date_time, s.location
FROM sections s
         JOIN sections s2 ON s.location = s2.location AND s.start_date_time = s2.start_date_time
WHERE s.section_id <> s2.section_id;

SELECT s.student_id as "Student ID", i.instructor_id as "Instructor ID", s.zip as "Student ZIP" , i.zip as "Instructor ZIP"
FROM students s
         JOIN zipcodes zip ON s.zip = zip.zip
         JOIN instructors i ON zip.zip = i.zip
WHERE s.zip = i.zip
ORDER BY s.student_id;

SELECT DISTINCT s.student_id, s.first_name, s.last_name
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
         JOIN zipcodes z ON z.zip = s.zip
WHERE e.enroll_date IS NOT null
  AND z.state = 'CT'
ORDER BY student_id;

SELECT c.description, s.section_no, TO_CHAR(s.start_date_time, 'YYYY-MM-DD') "start_date_time"
FROM sections s
         JOIN courses c ON c.course_no = s.course_no
         JOIN enrollments e ON e.section_id = s.section_id
         JOIN students se ON se.student_id = e.student_id
WHERE TRIM(UPPER(CONCAT_ws(' ', se.first_name, se.last_name)))='JOSEPH GERMAN';

