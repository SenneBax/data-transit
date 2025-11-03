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