

SELECT * 
FROM dbo. customer


SELECT * 
FROM dbo.dept



SELECT * 
FROM dbo.cogs
--What store has the most revenue

Select c.city, SUM(d.unit_price*d.quantity) as total_revenue
from
customer c
JOIN
dept  d
ON
c.invoice_id = d.invoice_id
Group by c.city

--What store is the most profitable?

Select c.city, SUM(cg.gross_income) as Gross_Income
from
customer c
JOIN
cogs  cg
ON
c.invoice_id = cg.invoice_id
Group by c.city

SELECT product_line, SUM(unit_price*Quantity) total
from 
dept
Group by product_line
Order by product_line 

--What is each dept cogs?

SELECT d.product_line, SUM(cg.cogs) total_cogs
from 
dept d
JOIN
cogs cg
ON
d.Invoice_ID = cg.Invoice_ID
GROUP by d.Product_line
Order by Product_line

--WHat is the number #1 payment method?

SELECT payment, Count(payment) as rank
from orders
Group by Payment


--How many members does the market have?

SELECT COUNT(customer_type) as NumberofMembers
from 
Customer
Where customer_type = 'Member'

---Average spend of member
SELECT c.Customer_type, AVG(d.unit_price*d.quantity) as avg_spend
FROM customer c
JOIN
dept d
ON
c.invoice_id = d.Invoice_ID
WHERE c.Customer_type IN ('member','normal')
Group by c.customer_type


--what does the stores gender demographics look like? 

SELECT Gender, COUNT(gender) as total
FROM
customer
Group by Gender

--what gender demographic spends the most?
SELECT c.gender, SUM(d.quantity*d.unit_price) as revenue
FROM
customer c
JOIN
dept d
ON
c.invoice_id = d.invoice_id
Group by c.Gender

--what is the average rating of each store?

SELECT city, AVG(rating) as rating
FROM 
customer
GROUP by City

--What are the the busiest days?


SELECT c.city, o.Date, COUNT(*) AS invoice_count
FROM customer c
JOIN orders o
ON c.Invoice_ID = o.Invoice_ID
GROUP BY c.city, o.Date
HAVING count(*) >=3
ORDER BY c.city, invoice_count DESC

--realized I wanted the top 3 busiest days, internet to the rescue
SELECT city, Date, invoice_count
FROM (
  SELECT city, Date, invoice_count,
         ROW_NUMBER() OVER (PARTITION BY city ORDER BY invoice_count DESC) AS rn
  FROM (
    SELECT c.city, o.Date, COUNT(*) AS invoice_count
    FROM customer c
    JOIN orders o ON c.Invoice_ID = o.Invoice_ID
    GROUP BY c.city, o.Date
  ) AS sub
) AS sub2
WHERE rn <= 3
ORDER BY city, invoice_count DESC


SELECT city, time_bucket, COUNT(*) AS invoice_count
FROM (
    SELECT c.city,
        CASE
            WHEN DATEPART(HOUR, o.Time) < 12 THEN '9am-12pm'
            WHEN DATEPART(HOUR, o.Time) >= 12 AND DATEPART(HOUR, o.Time) < 16 THEN '12pm-4pm'
            WHEN DATEPART(HOUR, o.Time) >= 16 AND DATEPART(HOUR, o.Time) < 21 THEN '4pm-9pm'
            ELSE 'Other'
        END AS time_bucket,
        o.Time
    FROM customer c
    JOIN orders o ON c.Invoice_ID = o.Invoice_ID
) AS subquery
GROUP BY city, time_bucket
ORDER BY city, time_bucket




SELECT * 
FROM dbo. customer


SELECT * 
FROM dbo.dept

SELECT * 
FROM dbo.orders

SELECT * 
FROM dbo.cogs