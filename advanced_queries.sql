use windows;

select * from payment;
select* from customer;

-- case statement example
select customer_id, amount, 
case 
when amount>50 then "More price"
when amount<= 50 then "Less price"
else "Normal price"
end as "Status"
from payment;

-- CTE(Common Table Expression)
WITH my_cte AS (
select p.customer_id, c.first_name, c.last_name, p.amount,
avg(p.amount) over (order by p.customer_id) as "Average Price",
COUNT(c.address_id) over (order by c.customer_id) as "Count"
from payment as p 
inner join customer as c 
on p.customer_id = c.customer_id
)
select concat(first_name, last_name) as"Customer_Name" , amount
from my_cte;

-- recursive cte for generating sequence 
with recursive cte as (
select 1 as "number"
union all
select number + 1 
from cte
where number < 10) 
select * from cte;

-- factorial upto 5
with recursive demo as(
select 1 as n, 1 as factorial 
union all
select n+1, (n+1) * factorial 
from demo 
where n <5)
select* from demo;













