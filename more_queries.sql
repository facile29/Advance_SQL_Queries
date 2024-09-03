use windows;
-- Create Products Table1
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

-- Create Orders Table2
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Smartphone', 'Electronics', 800.00),
(3, 'Coffee Maker', 'Home Appliances', 100.00),
(4, 'Headphones', 'Electronics', 150.00),
(5, 'Blender', 'Home Appliances', 75.00);


INSERT INTO Orders (OrderID, ProductID, OrderDate, Quantity)
VALUES
(1, 1, '2024-01-10', 2),
(2, 2, '2024-01-12', 5),
(3, 3, '2024-01-15', 1),
(4, 4, '2024-01-20', 3),
(5, 1, '2024-02-01', 1),
(6, 5, '2024-02-05', 2);

select* from products;
select* from orders;

-- questions of window functions

-- 1. Write a query to find the total quantity ordered for each product.
select Productid , sum(Quantity) over (partition by productid) as "Total_Quantity"
from orders;

-- 2. Rank the products based on the total quantity ordered.
with total as(
select productID, sum(quantity) over (partition by productid) as "Total_Quantity"
from orders 
)
select productid, Total_Quantity , rank() over (order by Total_Quantity desc) as "Rank"
from total;

-- 3. Find the first and last order date for each product.
select productid, 
first_value(orderdate) over (partition by productid order by orderdate) as "First",
last_value(orderdate) over(partition by productid order by orderdate rows between unbounded preceding and unbounded following) as "Last"
from orders;

-- 4. Get the Previous and Next Order Quantity for Each Product
select orderid, productid, quantity,
lag(quantity) over (partition by productid order by orderdate) as "Previous",
lead(quantity)  over (partition by productid order by orderdate) as "Next"
from orders;

-- 5. Calculate the Running Total of Quantity Ordered for Each Product.
select *, 
sum(quantity) over (partition by productid order by orderdate desc) as "Ordered"
from orders;

-- 6. Find the average quantity ordered for each product and rank them.
with test as 
(select orderid, productid, quantity,
avg(quantity) over (partition by productid order by orderdate) as "Average_quantity"
from orders
)
select productid, Average_quantity, 
rank() over (order by Average_Quantity desc) as "Ranked_avg_quantity"
from test;

-- 7. Determine which product has the highest number of orders.
select productid, 
count(orderid) as "order_count",
rank() over( order by count(orderid) desc) as "Ranked"
from orders
group by productid;

-- 8. Compare the quantity of each order with the average quantity ordered for the same product.
select *, 
avg(quantity) over(partition by productid) as "Avg_quantity", 
quantity- avg(quantity) over(partition by productid) as "difference"
from orders;

-- 9. List the top 3 products based on the total quantity ordered.



-- more examples
-- Calculate the running total of quantities ordered over time.

select o.OrderID, p.ProductName, o.OrderDate, o.Quantity,
sum(o.quantity) over (order by OrderDate) as "Total_Quantity"
from orders as o 
join products as p
on o.ProductID= p.ProductID 
order by o.OrderDate;

-- Rank products based on their total sales (price * quantity) across all orders.

with sales as(
select p.ProductId,  p.ProductName , 
sum(o.quantity*p.price) as "TotalSales"
from orders as o 
join products as p 
on o.ProductId = p.ProductId
group by p.ProductID, p.ProductName)
select ProductId, ProductName, TotalSales, 
rank() over (order by TotalSales desc) as "SalesRank"
from sales;

-- Calculate the total sales for each product per month and apply a moving average over the past 3 months.

with sales as(
select p.ProductId,  p.ProductName , 
sum(o.quantity*p.price) as "TotalSales", 
YEAR(o.OrderDate) as "SalesYear",
MONTH(o.OrderDate) as "SalesMonth"
from orders as o 
join products as p 
on o.ProductId = p.ProductId
group by p.ProductID, p.ProductName, YEAR(o.OrderDate), MONTH(o.OrderDate) 
)

select ProductId, ProductName, SalesYear, SalesMonth, TotalSales, 
avg(TotalSales) over (order by SalesYear, SalesMonth rows between 2 preceding and current row) as "MovingAverage"
from sales;






















