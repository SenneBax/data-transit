-- oefening 1
--a
SELECT COUNT(DISTINCT student_id)
FROM enrollments;
--b
SELECT COUNT(DISTINCT section_id)
FROM enrollments;
--c
SELECT SUM(capacity) as total_capacity,
       ROUND(AVG(capacity)) as average_capacity,
       MIN(capacity) as minimum_capacity,
       MAX(capacity) as max_capacity
FROM sections;

-- oefening 2
SELECT MAX(cost) as expensive_course
FROM courses;

--oefening 3
SELECT MIN(enroll_date) as First,
       MAX(enroll_date) as "Most recent"
FROM enrollments;
--NOTE: in dit geval klopt de datumrepresentatie het kan ook zijn dat je TO_CHAR moet gebruiken.

--oef 4
SElECT COUNT(DISTINCT course_no) as "Courses with prerequisites"
FROM courses
WHERE prerequisite IS null;

--oef 5
SELECT COUNT(DISTINCT student_id) "Number enlisted students"
FROM enrollments;

-- oefening 6
SELECT MIN(description) as "first in order",
       MAX(description) as "last in order"
FROM courses;

--oefening 7
SELECT MAX(enroll_date) "most recent subscription"
FROM enrollments;

--oefening 8
SELECT location,
       COUNT(section_no) as "number of sections",
       SUM(capacity) as "to capacity",
       MIN(capacity) as "Minimum capacity",
       MAX(capacity) as "Maximum capacity"

FROM sections
group by location;

--oefening 9
--a
SELECT location,
       instructor_id,
       COUNT(section_no) as "number of sections",
       SUM(capacity) as "to capacity",
       MIN(capacity) as "Minimum capacity",
       MAX(capacity) as "Maximum capacity"
from sections
group by location, instructor_id
ORDER BY 1;

--b
--Geef per locatie en instructor_id het aantal secties, de totale capaciteit, de minimum en de
-- maximum capaciteit. In de resultatentabel moeten enkel rijen getoond worden met een totale
-- capaciteit die groter is dan 50. Geef de output gesorteerd op de totale capaciteit.
SELECT location,
       instructor_id,
       COUNT(section_no) as "number of sections",
       SUM(capacity) as "tot_cap",
       MIN(capacity) as "min_cap",
       MAX(capacity) as "max_cap"
from sections
group by location, instructor_id
HAVING (SUM(capacity) > 50)
ORDER BY TOT_CAP DESC;

--c
-- Geef per locatie en instructor_id het aantal secties, de totale capaciteit, de minimum en de
-- maximum capaciteit. In de resultatentabel moeten enkel rijen getoond worden betreffende
-- een totale capaciteit die groter is dan 50.We zijn ook enkel in de cursussen met COURSE_NO
-- groter dan 99 geïnteresseerd. Geef de output gesorteerd op de totale capaciteit.

SELECT location,
       instructor_id,
       COUNT(section_no) as "number of sections",
       SUM(capacity) as "tot_cap",
       MIN(capacity) as "min_cap",
       MAX(capacity) as "max_cap"
from sections
WHERE (COURSE_NO > 99)
group by location,
         instructor_id
HAVING (SUM(capacity) > 50)
ORDER BY TOT_CAP DESC;


--d
-- Geef per locatie de totale capaciteit. De locatienaam moet beginnen met ‘L5’ en de locatie
-- moet minstens 3 keer gebruikt zijn.

SELECT
    location as "Location",
    SUM(capacity) as "Total Capacity"
FROM sections
WHERE SUBSTR(location, 1, 2) IN ('L5')
Group by location
HAVING (COUNT(section_no) > 3)
ORDER BY "Total Capacity" DESc;

--10
--Geef een overzicht van de punten die studenten gemiddeld per
--section behaalden op hun homeworks.  In de resultatentabel moeten enkel
--studenten komen die gemiddeld minder dan 80 punten behaalden.
--Sorteer op student en section.
SELECT student_id,section_id,ROUND(AVG(numeric_grade)) "average_grade_homeworks"
FROM grades
WHERE grade_type_code='HM'
GROUP BY student_id,section_id
HAVING AVG(numeric_grade)<80
ORDER BY student_Id,section_id;

--11
--Welke studentennrs zijn voor meer dan 2 cursussecties ingeschreven?
SELECT student_id, count(*)"Number of sections" FROM enrollments
GROUP BY student_id
HAVING COUNT(*) > 2;

--12
--Toon voor elke cursus die door instructor Fernand Hanks (instructor_id=101)
--gegeven wordt, de gemiddelde capaciteit en de afgeronde gemiddelde capaciteit.
SELECT course_no "course #",
       AVG(capacity) "Avg. Capacity",
       ROUND(AVG(capacity)) "Avg. capacity without decimals" FROM sections
WHERE instructor_id=101
GROUP BY course_no;

--13
--Toon per cursuskost hoeveel cursussen deze kostprijs hebben.
SELECT cost, count(*) number_of_courses FROM courses
GROUP BY cost
ORDER BY 1;

--14
--Op welke datums werd er ingeschreven voor cursussectie 90 en hoeveel
--inschrijvingen waren er op elk van die datums?
SELECT enroll_date,COUNT(*) "aantal inschrijvingen"
FROM enrollments
WHERE section_id = 90
GROUP BY enroll_date;

--15
--Geef voor elk bedrijf waarin meer dan 4 studenten tewerkgesteld zijn
--weer hoeveel studenten ze tewerkstellen.
SELECT employer, COUNT(*) "Number of students"
FROM students
GROUP BY employer
HAVING COUNT(*) > 4;

--16
--Bepaal per instructor hoeveel verschillende cursussen hij/zij doceert.
SELECT instructor_id, COUNT(DISTINCT COURSE_NO) "Number of courses"
FROM sections
GROUP BY instructor_id;

--17
--Bepaal voor de sections betreffende de cursus ‘Intro to Programming’
--(section_id tussen 85 en 93) het hoogst behaalde cijfer voor het
--Midterm examen (grade_type_code =’MT’).
SELECT section_id,
       MAX(numeric_grade) "highest grade"
FROM grades
WHERE grade_type_code = 'MT'
  AND section_id BETWEEN 85 AND 93
GROUP BY section_id;

--18
--Bepaal voor studenten die zich inschreven voor meer dan 2 secties,
--het gemiddelde cijfer dat ze op al hun evaluaties behaalden.
SELECT student_id,
       ROUND(AVG(numeric_grade))"average evaluation"
FROM grades
GROUP BY student_id
HAVING COUNT(distinct section_id)>2;

--19
--Geef weer uit welke streken (zip bekijken) er meer dan 5 studenten komen
SELECT zip,
       COUNT(*) "Number of students"
FROM students
GROUP BY zip
HAVING COUNT(*)>5;


--Toepassingen op Outer join


--20
--Toon alle cursussen die geen secties hebben.
SELECT c.course_no, c.description
FROM  sections s
          RIGHT OUTER JOIN courses c ON (c.course_no = s.course_no)
WHERE s.course_no IS NULL
ORDER BY c.course_no;

--21
--Toon de beschrijving van alle cursussen met als prerequisite-cursus 350.
--Toon in het resultaat ook de secties en hun locatie. Ook cursussen die
--geen sectie hebben moeten getoond worden.
SELECT description, c.prerequisite prereq, s.section_id, s.location
FROM  sections S
          RIGHT OUTER JOIN courses c ON (C.course_no = S.course_no)
WHERE c.prerequisite= 350;

--22
--Welke  docenten doceerden nog geen cursussecties.  Geef ook weer uit welke
--state ze komen.
SELECT CONCAT_ws(' ' ,i.last_name, i.first_name) "name lecturer",
       z.state
FROM instructors i
         LEFT OUTER JOIN sections s  ON (i.instructor_id=s.instructor_id)
         LEFT OUTER JOIN zipcodes z ON (z.zip=i.zip)
WHERE section_id IS NULL;

--23
--Toon de niet populaire cursussen (= cursussen waarvoor nog geen inschrijvingen voorkomen).
SELECT s.section_id,
       description unpopular_courses
FROM enrollments e
         RIGHT OUTER JOIN sections s ON (s.section_id=e. section_id)
         JOIN courses c ON (s.course_no=c.course_no)
WHERE  e.section_id IS  NULL;
