-- QUES 1
/*Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy */

SELECT SUM(SALARY) as TOTAL_SUM_IN_SEATTLE From EMPLOYEES
INNER JOIN DEPARTMENTS 
ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID 
INNER JOIN LOCATIONS
ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID WHERE CITY = 'Seattle' AND  FIRST_NAME!= 'Nancy';


-- QUES 2
/*Fetch all details of employees who has salary more than the avg salary by each department. */

SELECT E.* , TEMP1.* FROM EMPLOYEES E
INNER JOIN (SELECT AVG(SALARY) AS AVG_SALARY , DEPARTMENT_ID FROM EMPLOYEES PARTITION BY  OVER(DEPARTMENT_ID) )AS TEMP1
ON E.DEPARTMENT_ID = TEMP1.DEPARTMENT_ID WHERE E.SALARY > TEMP1.AVG_SALARY;


-- QUES 3
/*Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000 */

SELECT EMPLOYEES.SALARY , EMPLOYEE_ID ,  CITY FROM EMPLOYEES
INNER JOIN  DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
INNER JOIN LOCATIONS
ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID WHERE SALARY BETWEEN 7000 AND 10000 ;

-- QUES 4
-- Fetch max salary, min salary and avg salary by job and department. 
--  Info:  grouped by department id and job id ordered by department id and max salary


SELECT JOB_ID  , DEPARTMENT_ID , max(SALARY) , min(SALARY) , avg(SALARY) FROM EMPLOYEES
GROUP BY DEPARTMENT_ID , JOB_ID;

-- Ques 5
-- Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy   

SELECT sum(salary)   FROM EMPLOYEES E
    INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
    INNER JOIN LOCATIONS L
    ON L.LOCATION_ID = D.LOCATION_ID
    INNER JOIN COUNTRIES C
    ON L.COUNTRY_ID = C.COUNTRY_ID WHERE C.COUNTRY_ID  LIKE 'US' and E.FIRST_NAME not like 'Nancy';
    

-- QUES 6
/*Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
*/

with TEMP1 as (SELECT JOB_ID , EMPLOYEE_ID  FROM EMPLOYEES
UNION 
SELECT   JOB_ID , EMPLOYEE_ID  FROM JOB_HISTORY)

SELECT E.JOB_ID, E.DEPARTMENT_ID,  MIN(SALARY) , MAX(SALARY) , AVG(SALARY) FROM EMPLOYEES E
INNER JOIN (SELECT   JOB_ID, count(JOB_ID) c1 from TEMP1 GROUP BY JOB_ID  having c1>1 ) TEMP
ON E.JOB_ID = TEMP.JOB_ID
GROUP BY E.DEPARTMENT_ID,E.JOB_ID;




    -- Ques 7
/*Display the employee count in each department and also in the same result.  
Info: * the total employee count categorized as "Total"
the null department count categorized as "-" * */

WITH TEMP AS (SELECT coalesce(nullif(CAST(DEPARTMENT_ID AS varchar ),'null'),'-')   department  ,COUNT(EMPLOYEE_ID)  as TOTAL    FROM EMPLOYEES GROUP BY DEPARTMENT_ID
UNION
SELECT 'TOTAL' , count(EMPLOYEE_ID) FROM EMPLOYEES)

SELECT * FROM TEMP ORDER BY department DESC;




-- Ques 8
/*Display the jobs held and the employee count. */
-- SELECT EMPLOYEE_ID FROM    EMPLOYEES ;
-- UNION
with TEMP as (SELECT EMPLOYEE_ID , count(EMPLOYEE_ID) E_COUNT  from (SELECT EMPLOYEE_ID from JOB_HISTORY
union all
SELECT EMPLOYEE_ID    FROM EMPLOYEES) group by EMPLOYEE_ID)
SELECT E_COUNT,  count(EMPLOYEE_ID) count from TEMP group by E_COUNT ORDER by E_COUNT ;



-- Ques 9
-- Display average salary by department and country. 

SELECT TEMP.dept , TEMP.country ,avg(SALARY)  FROM EMPLOYEES E
INNER JOIN (SELECT D.DEPARTMENT_ID dept , L.COUNTRY_ID country FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
INNER JOIN LOCATIONS L
ON D.LOCATION_ID =L.LOCATION_ID ) TEMP
ON E.department_id = TEMP.dept GROUP By TEMP.dept ,TEMP.country;



-- QUES 10
 -- Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country) 

-- SELECT FIRST_NAME , LAST_NAME , TEMP1.count_of_employees,   L.COUNTRY_ID FROM EMPLOYEES E
-- INNER JOIN (SELECT  MANAGER_ID ,count(EMPLOYEE_ID) as count_of_employees FROM EMPLOYEES 
-- GROUP BY  MANAGER_ID) TEMP1
-- ON TEMP1.MANAGER_ID = E.EMPLOYEE_ID
-- INNER JOIN DEPARTMENTS D
-- ON D.DEPARTMENT_ID  = E.DEPARTMENT_ID
-- INNER JOIN LOCATIONS L
-- ON L.LOCATION_ID = D.LOCATION_ID;
-- with TEMP as (
-- SELECT   MANAGER_ID ,EMPLOYEE_ID   FROM EMPLOYEES)

-- SELECT count(E.EMPLOYEE_ID),L.COUNTRY_ID  FROM EMPLOYEES E
-- INNER JOIN TEMP 
-- ON E.EMPLOYEE_ID = TEMP.MANAGER_ID
-- INNER JOIN DEPARTMENTS D
-- ON D.DEPARTMENT_ID  = E.DEPARTMENT_ID
-- INNER JOIN LOCATIONS L
-- ON L.LOCATION_ID = D.LOCATION_ID 
-- GROUP BY L.COUNTRY_ID , TEMP.MANAGER_ID ;
with TEMP as (
SELECT  E.MANAGER_ID M_ID,count(L.country_id) count,  country_name FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID  = E.DEPARTMENT_ID
INNER JOIN LOCATIONS L
ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN COUNTRIES C
ON C.COUNTRY_ID = L.COUNTRY_ID
GROUP BY country_name,E.MANAGER_ID)

SELECT E.FIRST_NAME, E.LAST_NAME,count,country_name FROM EMPLOYEES E
INNER JOIN TEMP
ON E.EMPLOYEE_ID = TEMP.M_ID;




-- Ques 11
-- Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg : 
-- DEPT ID 0-10000 10000-20000
-- 50          2               10
-- 60          6                5

SELECT department_id, 
coalesce(nullif(cast(count(case when  salary between 0 and 1000 then salary end) as string),'0'),'-') as "0-1000",
coalesce(nullif(cast(count(case when  salary between 1000 and 2000 then salary end ) as string),'0'),'-') as "1000-2000",
coalesce(nullif(cast(count(case when  salary between 2000 and 3000 then salary end ) as string),'0'),'-') as "2000-3000",
coalesce(nullif(cast(count(case when  salary between 3000 and 4000 then salary end ) as string),'0'),'-') as "3000-4000"
 FROM EMPLOYEES 
 GROUP BY department_id;


 

-- QUES 12
--  Display employee count by country and the avg salary 

SELECT count(EMPLOYEE_ID) ,C.COUNTRY_NAME , avg(salary) FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
INNER JOIN LOCATIONS L
ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN COUNTRIES C
ON L.COUNTRY_ID = C.COUNTRY_ID 
GROUP BY C.COUNTRY_NAME;


--ques 13
-- Display region and the number off employees by department
-- Eg : 
-- Dept ID   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34         -

with TEMP1 as (SELECT EMPLOYEE_ID employee  , D.DEPARTMENT_ID DEPT_ID ,R.REGION_NAME  FROM EMPLOYEES E
INNER JOIN  DEPARTMENTS  D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS L
ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN COUNTRIES C
ON C.COUNTRY_ID = L.COUNTRY_ID
INNER JOIN REGIONS R
ON R.REGION_ID = C.REGION_ID )

SELECT *  FROM TEMP1
PIVOT(count(employee) for  REGION_NAME  in ('Americas','Europe' , 'Asia' , 'Middle East and Africa'))
ORDER BY DEPT_ID;

-- 14.	 Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department

SELECT EMPLOYEE_ID  , department_id FROM EMPLOYEES where department_id is not null
union SELECT EMPLOYEE_ID , department_id from EMPLOYEES where department_id is null order by department_id;

-- QUES 15
-- write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers 


SELECT E.FIRST_NAME , E.LAST_NAME , TEMP.FIRST_NAME M_First_NAME , TEMP.LAST_NAME M_LAST_NAME    FROM EMPLOYEES E
LEFT JOIN (SELECT FIRST_NAME , LAST_NAME , EMPLOYEE_ID FROM EMPLOYEES) TEMP
ON E.MANAGER_ID = TEMP.EMPLOYEE_ID 
ORDER BY FIRST_NAME;



-- QUES 16
/*write a SQL query to display the department name, city, and state province for each department. */



SELECT DEPARTMENT_NAME , DEPARTMENT_ID , CITY , STATE_PROVINCE FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON L.LOCATION_ID = D.LOCATION_ID;


-- QUES 17
-- write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't 


SELECT FIRST_NAME , LAST_NAME, D.DEPARTMENT_NAME  FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;


-- QUES18
-- The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name 

SELECT D.DEPARTMENT_ID ,  AVG(E.SALARY) , COUNT(EMPLOYEE_ID) FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID;


SELECT * FROM EMPLOYEES;
--QUES 19
-- Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.

SELECT * FROM EMPLOYEES
CROSS JOIN JOBS; 



-- QUES 20
/*
Write a query to display first_name, last_name, and email of employees who are from Europe and Asia 
*/

SELECT FIRST_NAME  , LAST_NAME  ,EMAIL , R.REGION_NAME FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
 ON D.DEPARTMENT_ID = E.DEPARTMENT_ID 
 INNER JOIN LOCATIONS L
 ON L.LOCATION_ID = D.LOCATION_ID
 INNER JOIN COUNTRIES C
 ON C.COUNTRY_ID = L.COUNTRY_ID 
 INNER JOIN REGIONS R
 ON C.REGION_ID = R.REGION_ID WHERE R.REGION_NAME IN ('Europe' , 'Asia');



 -- QUES 21
 
 -- Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department. 


 SELECT CONCAT(FIRST_NAME , ' ' , LAST_NAME)FULL_NAME , L.CITY  , d.department_name FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D 
 ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
 ON L.LOCATION_ID = D.LOCATION_ID WHERE CITY = 'Oxford' and substr(last_name , length(last_name)-1 ,1) ='e' and department_name not in ('Finance' , 'Shipping');


-- Ques 22
 -- Display the first name and phone number of employees who have less than 50 months of experience 

 SELECT DISTINCT FIRST_NAME , PHONE_NUMBER  FROM EMPLOYEES E
 INNER JOIN (SELECT EMPLOYEE_ID,start_date, end_date from JOB_HISTORY WHERE DATEDIFF(month, start_date, end_date)<50) TEMP
 ON E.EMPLOYEE_ID = TEMP.EMPLOYEE_ID; 


 

 -- QUES 23
-- Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).


SELECT FIRST_NAME , LAST_NAME , HIRE_DATE , E1.SALARY FROM EMPLOYEES E1
INNER JOIN (SELECT max(SALARY) salary, year FROM EMPLOYEES E
INNER JOIN (SELECT DISTINCT year(HIRE_DATE) year FROM EMPLOYEES) TEMP1
ON TEMP1.year = year(E.HIRE_DATE)
GROUP BY year) TEMP2
ON E1.salary = TEMP2.salary AND year(E1.HIRE_DATE) = TEMP2.year
ORDER BY year(HIRE_DATE);


with TEMP as (SELECT EMPLOYEE_ID,  HIRE_DATE ,SALARY ,RANK() OVER (PARTITION BY year(HIRE_DATE)  ORDER BY EMPLOYEE_ID) as max FROM EMPLOYEES )
SELECT EMPLOYEE_ID , HIRE_DATE ,SALARY  FROM TEMP where max=1 order by HIRE_DATE;



 