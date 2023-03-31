--Calclulate number of students who participated

--Repeat for each course
SELECT COUNT(Did_Student_Test) AS number_participated
FROM student_ap_assessments.ap_lang
WHERE Did_Student_Test = 'Yes'

| number_participated |
| ------------------- |
|          21         |

--Calculate number of students who passed
SELECT COUNT(AP_Lang_Actual_AP_Level) AS number_passed
FROM student_ap_assessments.ap_lang
WHERE AP_Lang_Actual_AP_Level = 'AP3 or Above'

| number_passed |
| ------------- |
|       10      |

--Calculate Pass Rates

--Option 1: Use number of students who tesetd in previous SQL Query to calculate pass rate 

SELECT COUNT (AP_Lang_Actual_AP_Level) / 21 AS pass_rate
FROM student_ap_assessments.ap_lang 
WHERE AP_Lang_Actual_AP_Level = 'AP3 or Above'

|  pass_rate |
| ---------- |
| 0.47619047 |

-- Option 2: Use one SQL Query to Calculate Pass rate 
SELECT 
  (SUM (
   CASE 
     WHEN ap_lang.AP_Lang_Actual_AP_Level = "AP3 or Above" THEN 1
     Else 0
  END ))
  /
  (SUM (
   CASE 
     WHEN ap_lang.Did_Student_Test = "Yes" THEN 1
     Else 0
  END )) AS pass_rate
FROM student_ap_assessments.ap_lang 

|  pass_rate |
| ---------- |
| 0.47619047 |

-- Add this years pass rate to this_yr_goals table
INSERT INTO student_ap_assessments.this_yr_goals (This_Years_Pass_Rate)
VALUES 
 (0.05), --AP Chem 
 (0.48), --AP Lang 
 (0.35), --AP US History 
 (0.32), --AP World History 
 (0.09), --AP Bio 
 (0), --AP Calc 
 (0.13), --AP Lit 
 (0.12), --AP Gov 

-- Compare last years pass rate with this years pass rate
SELECT 
last_yr_data.Courses,
Last_Year_Pass_Rate,
This_Years_Pass_Rate
FROM student_ap_assessments.last_yr_data
INNER JOIN student_ap_assessments.this_yr_goals ON last_yr_data.Courses = this_yr_goals.Courses;

| Courses          | Last_Year_Pass_Rate | This_Year_Pass_Rate |
|------------------|---------------------|:-------------------:|
| AP Bio           | null                | 0.09                |
| AP Calc          | 0.5                 | 0.0                 |
| AP Chem          | 0.05                | 0.05                |
| AP Lang          | 0.48                | 0.48                |
| AP Lit           | 0.73                | 0.13                |
| AP Gov           | 0.39                | 0.12                |
| AP US History    | 0.63                | 0.35                |
| AP World History | 0.69                | 0.32                |

-- Calculate the participation rate
-- Repeat for each course
-- Option 1: Caluclate the total number of students first (per grade) then use that in a query

SELECT COUNT (Student_Identifier) AS total_students_tenth_grade
FROM student_ap_assessments.ap_world 

|  total_students_tenth_grade |
| --------------------------- |
|              100            |

-- Use that total number (100) to calcualte the participation rate for AP World
SELECT COUNT(Did_Student_Test) / 100 AS  particpation_rate
FROM student_ap_assessments.ap_world
WHERE Did_Student_Test = 'Yes'

|  participation_rate |
| ------------------- |
|         0.19        |

-- Option 2: Using one query 

SELECT 
  (SUM (
   CASE 
     WHEN ap_world.Did_Student_Test = "Yes" THEN 1
     Else 0
  END ))
  /
  (COUNT(ap_world.Student_Identifier))
  AS participation_rate
FROM student_ap_assessments.ap_world 

|  participation_rate |
| ------------------- |
|         0.19        |

-- Add this years participation rate to the this_yr_goals table
INSERT INTO student_ap_assessments.this_yr_goals (This_Years_Participation)
VALUES 
 (0.23), --AP Chem, 11th 
 (0.24), --AP Lang, 10th
 (0.20), --AP US History, 11th 
 (0.19), --AP World History, 10th 
 (0.25), --AP Bio, 12th 
 (0.14), --AP Calc, 12th 
 (0.26), --AP Lit, 12th 
 (0.29) --AP Gov, 12th 

-- Compare this years participation goals with this years participation rate

SELECT Courses, This_Years_Participation_Goals, This_Years_Participation
FROM student_ap_assessments.this_yr_goals
ORDER BY Courses 

| Courses          | This_Years_Participation_Goals | This_Years_Participation |
|------------------|--------------------------------|:------------------------:|
| AP Bio           | 0.65                           | 0.25                     |
| AP Calc          | 0.65                           | 0.14                     |
| AP Chem          | 0.65                           | 0.23                     |
| AP Gov           | 0.65                           | 0.29                     |
| AP Lang          | 0.65                           | 0.24                     |
| AP Lit           | 0.65                           | 0.26                     |
| AP US History    | 0.65                           | 0.2                      |
| AP World History | 0.65                           | 0.19                     |

-- Calculate AP Index Rate
SELECT 
  Courses, 
  ROUND(This_Years_Participation * This_Years_Pass_Rate, 2) AS This_Years_AP_Index
FROM student_ap_assessments.this_yr_goals
ORDER BY Courses

| Courses          | This_Years_AP_Index |
|------------------|:-------------------:|
| AP Bio           |                0.02 |
| AP Calc          |                 0.0 |
| AP Chem          |                0.01 |
| AP Gov           |                0.03 |
| AP Lang          |                0.12 |
| AP Lit           |                0.04 |
| AP US History    |                0.07 |
| AP World History |                0.06 |

-- Add this ap index rate to the this_yr_goals table
INSERT INTO student_ap_assessments.this_yr_goals (This_Years_AP_Index)
VALUES 
 (0.01), --AP Chem 
 (0.12), --AP Lang 
 (0.07), --AP US History 
 (0.06), --AP World History 
 (0.02), --AP Bio 
 (0), --AP Calc 
 (0.03), --AP Lit 
 (0.03), --AP Gov 

-- Compare this years index goals with this years actual index rate 
SELECT Courses, This_Years_AP_Index_Goals, This_Years_AP_Index
FROM student_ap_assessments.this_yr_goals
ORDER BY Courses

| Courses          | This_Years_AP_Index_Goals | This_Years_AP_Index |
|------------------|---------------------------|:-------------------:|
| AP Bio           | 0.16                      | 0.02                |
| AP Calc          | 0.57                      | 0.0                 |
| AP Chem          | 0.15                      | 0.01                |
| AP Gov           | 0.19                      | 0.03                |
| AP Lang          | 0.16                      | 0.12                |
| AP Lit           | 0.18                      | 0.04                |
| AP US History    | 0.13                      | 0.07                |
| AP World History | 0.12                      | 0.06                |
