/*Write a SQL query to remove the details of an employee whose first name ends in ‘even’*/

SELECT * FROM EMPLOYEES;

SELECT * FROM EMPLOYEES WHERE FIRST_NAME LIKE '%even';

DELETE FROM EMPLOYEES WHERE FIRST_NAME LIKE '%even';




/*Write a query in SQL to show the three minimum values of the salary from the table.*/


SELECT TOP 3 *  FROM EMPLOYEE
    ORDER BY SALARY DESC;



/*Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table*/

DESC TABLE EMPLOYEES;

CREATE TABLE EMPLOYEE 
    AS SELECT * FROM EMPLOYEES;

SELECT * FROM EMPLOYEE;

TRUNCATE TABLE EMPLOYEES;



/*Write a SQL query to remove the column Age from the table*/


/*Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000*/


SELECT concat(FIRST_NAME,' ',LAST_NAME) as FUL_NAME , EMAIL , HIRE_DATE  FROM EMPLOYEE WHERE year(HIRE_DATE) < 2000;



/* Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999*/

SELECT EMPLOYEE_ID , JOB_ID , HIRE_DATE from EMPLOYEE WHERE year(HIRE_DATE) between 1990 and 1999
ORDER BY HIRE_DATE DESC;



/*Find the first occurrence of the letter 'A' in each employees Email ID

Return the employee_id, email id and the letter position*/


-- SELECT EMPLOYEE_ID , EMAIL , charindex('A'  , EMAIL , charindex('A' , EMAIL)+1) as POSITION_OF_A FROM EMPLOYEE;
SELECT EMPLOYEE_ID , EMAIL , charindex('A'  , EMAIL , position('A' in EMAIL ) as POSITION_OF_A FROM EMPLOYEE;

/*Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12*/

SELECT EMPLOYEE_ID ,  concat(FIRST_NAME , ' ' ,LAST_NAME) as FULL_NAME , EMAIL FROM EMPLOYEE WHERE length( FULL_NAME) <12;



/*  Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID

Return the employee_id, and their corresponding UNQ_ID;*/

SELECT CONCAT_WS( '/', FIRST_NAME ,LAST_NAME , EMAIL) as UNQ_ID,  EMPLOYEE_ID FROM EMPLOYEE
ORDER BY UNQ_ID;


/*Write a SQL query to update the size of email column to 30*/

ALTER TABLE EMPLOYEE MODIFY EMAIL varchar(30);

DESC TABLE EMPLOYEE;


/*  Write a SQL query to change the location of Diana to London*/



-- SELECT LOCATION_ID FROM LOCATIONS WHERE CITY = 'London'
-- UPDATE EMPLOYEE set DEPARTMENT_ID = LOCATION_ID HAVING FIRST_NAME like 'Diana';



/*Write a SQL query to change the location of Diana to London*/



/*Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)

Info : this mean you need to separate phone into 2 parts

eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column*/


-- SELECT FIRST_NAME  , LAST_NAME , EMAIL  , split_part(PHONE_NUMBER ,'.'  , -1) as  without_extension ,rtrim (phone_number , concat('.' , without_extension)) as extension FROM EMPLOYEE;

SELECT PHONE_NUMBER ,  FIRST_NAME  , LAST_NAME , EMAIL  , split_part(PHONE_NUMBER ,'.'  , -1) as  without_extension , replace(PHONE_NUMBER , concat('.' ,without_extension )) FROM EMPLOYEE;

/*. Write a SQL query to find the employee with second and third maximum salary with and without using top/limit keyword*/


SELECT * FROM EMPLOYEE WHERE salary in (
SELECT DISTINCT SALARY FROM EMPLOYEE
    ORDER BY SALARY DESC
    LIMIT 2 offset 1
);


/*Fetch all details of top 3 highly paid employees who are in department Shipping and IT*/


(SELECT * FROM EMPLOYEE WHERE DEPARTMENT_ID LIKE (
SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME LIKE 'Shipping' 
) ORDER BY SALARY DESC LIMIT 3)
UNION
(SELECT * FROM EMPLOYEE WHERE DEPARTMENT_ID LIKE (
SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME LIKE 'IT' 
) ORDER BY SALARY DESC LIMIT 3);





/* Display employee id and the positions(jobs) held by that employee (including the current position) */
(SELECT EMPLOYEE.EMPLOYEE_ID , JOBS.JOB_TITLE FROM EMPLOYEE , JOBS WHERE EMPLOYEE.JOB_ID = JOBS.JOB_ID)
UNION
SELECT JOB_HISTORY.EMPLOYEE_ID , JOBS.JOB_TITLE FROM JOB_HISTORY , JOBS WHERE JOB_HISTORY.JOB_ID = JOBS.JOB_ID
ORDER BY EMPLOYEE_ID; 



-- SELECT EMPLOYEE_ID , DEPARTMENT_ID FROM EMPLOYEE WHERE JOB_ID IN (SELECT JOB_ID FROM JOB_HISTORY WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE));




/*Display Employee first name and date joined as WeekDay, Month Day, Year

Eg :

Emp ID Date Joined

1 Monday, June 21st, 1999*/



SELECT FIRST_NAME , concat_ws(',' , dayname(hire_date) ,concat( monthname(hire_date) , ' ' , split_part(hire_date,'-' , 2)) , year(hire_date))  as date FROM EMPLOYEE;



/*The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 . The job position might be removed based on market trends (so, save the changes) . - Later, update the maximum salary to 40,000 . - Save the entries as well.

- Now, revert back the changes to the initial state, where the salary was 30,000*/


INSERT INTO JOBS VALUES (
'DT_ENGG',
'Data Engineer',
12000,
30000
);



-- SELECT CURRENT_TRANSACTION();
-- SELECT * FROM JOBS;
UPDATE JOBS SET MAX_SALARY = 40000 WHERE JOB_ID = 'DT_ENGG';
-- SELECT * FROM JOBS;
-- ROLLBACK;


SELECT * FROM JOBS;

UPDATE JOBS SET MAX_SALARY = 30000 WHERE JOB_ID = 'DT_ENGG';



/*Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals*/




SELECT round(avg(SALARY) , 3)  FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '1996-01-08' and '2000-01-01';




/*
Display Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)

A. Display all the regions

B. Display all the unique regions
*/
SELECT 'Australia'
union
SELECT 'Asia'
union
SELECT 'Antarctica'
union
SELECT 'Europe'
union
SELECT REGION_NAME FROM REGIONS  ;







/*Write a SQL query to remove the employees table from the database*/

drop table EMPLOYEE;




