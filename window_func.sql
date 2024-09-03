create database windows;
use windows;

-- TABLE 1

create table test(
test_num int ,
color varchar(5));

insert into test value(100, "red");
insert into test value(200, "red");
insert into test value(200, "green");
insert into test value(600, "green");
insert into test value(500, "green");
insert into test value(700, "green");
insert into test value(500, "blue");
insert into test value(600, "blue");
insert into test value(400, "blue");

select* from test;

-- aggregate function example 1

select test_num , color, 
SUM(test_num) OVER(Partition by color order by test_num) as "Total", 
count(test_num) OVER(Partition by color order by test_num) as "count", 
avg(test_num) OVER(Partition by color order by test_num) as "average", 
min(test_num) OVER(Partition by color order by test_num) as "minimum", 
max(test_num) OVER(Partition by color order by test_num) as "maximum"
from test;

-- aggregate function example 2

select test_num , color, 
SUM(test_num) OVER(order by test_num ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as "Total", 
count(test_num) OVER(order by test_num ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as "count", 
avg(test_num) OVER(order by test_num ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as "average", 
min(test_num) OVER(order by test_num ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as "minimum", 
max(test_num) OVER(order by test_num ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as "maximum"
from test; 

-- ranking function example 
select test_num, 
row_number() over(order by test_num) as "Row_number",
rank() over(order by test_num) as "rank",
dense_rank() over(order by test_num) as "Dense_rank",
percent_rank() over(order by test_num) as "Percent"
from test;

-- analytic function examples
select test_num, 
first_value(test_num) over(order by test_num) as "FIRST_VALUE", 
last_value(test_num) over (order by test_num) as "Last_VALUE", 
lead(test_num) over (order by test_num) as "LEAD",
lag(test_num) over (order by test_num) as "LAG"
from test;

select test_num, 
first_value(test_num) over(order by test_num) as "FIRST_VALUE", 
last_value(test_num) over (order by test_num ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "Last_VALUE", 
lead(test_num) over (order by test_num) as "LEAD",
lag(test_num) over (order by test_num) as "LAG"
from test;

-- offset the lead and lag values by 2 in the output columns
-- (How can you retrieve the test_num values that are two rows ahead and two rows behind each test_num in an ordered list?)

select test_num, 
lead(test_num,2) over (order by test_num) as "LEAD",
lag(test_num, 2) over (order by test_num) as "LAG"
from test;

-- TABLE 2
create table emp(
emp_id int, 
department varchar(5), 
salary int);

insert into emp(emp_id, department, salary) values
(1, 'HR', 50000),
(2, 'IT', 60000),
(3, 'HR', 55000),
(4, 'IT', 70000),
(5, 'Sales', 65000),
(6, 'Sales', 58000),
(7, 'IT', 80000),
(8, 'HR', 52000);

select* from emp;

-- aggregate functions question

select emp_id, department, salary, 
sum(salary) over(partition by department) as "Total Salary", 
avg(salary) over(partition by department) as "Average Salary", 
count(salary) over(partition by department) as "Count Salary", 
min(salary) over(partition by department) as "Minimum Salary", 
max(salary) over(partition by department) as "Maximum Salary"
from emp;

-- ranking function question 
select emp_id , department, salary, 
row_number() over (partition by department order by salary ) as "Row_number", 
rank() over (partition by department order by salary ) as "Rank", 
dense_rank() over (partition by department order by salary ) as "Dense_rank", 
percent_rank() over (partition by department order by salary ) as "Percent_rank"
from emp;

-- analytic fucntions example

select emp_id , department, salary, 
first_value(salary) over (partition by department order by salary) as "Fisrt_value",
last_value(salary) over (partition by department order by salary rows between unbounded preceding and unbounded following) as "Last_value",
lead(salary) over (partition by department order by salary) as "Next_value",
lag(salary) over (partition by department order by salary) as "Fisrt_value"
from emp;



