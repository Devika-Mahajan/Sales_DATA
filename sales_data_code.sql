USE CRM_Sales

SELECT * FROM accounts
SELECT * FROM sales_pipeline
SELECT * FROM sales_teams
SELECT * FROM products

/* 1. Retrieve the names of all accounts that were established after the year
 2010 and have opportunities listed in the sales_pipeline table. */

Select 
a.account (select a.account, a.year_established from accounts where a.year_established > 2010),
sp.opportunity_id
From accounts a
join sales_pipeline sp
on a.account = sp.account

SELECT account 
FROM accounts 
WHERE year_established > 2010 
AND account IN (SELECT DISTINCT account FROM sales_pipeline);


/* Display the product names 
that have a sales_price greater than the average price of their series */

SELECT 
product,
sales_price,
avg(sales_price)
FROM products
Where sales_price < avg(sales_price) 
Group by product, sales_price;


SELECT product,
sales_price,
AVG(sales_price)
FROM products 
WHERE sales_price > (SELECT AVG(sales_price) 
                     FROM products AS sub 
                     WHERE sub.series = products.series)
Group by product, sales_price;

/* List the names of sales_agent who have successfully closed deals with a 
close_value greater than 50,000.*/

SELECT * FROM sales_pipeline
SELECT * FROM sales_teams


SELECT
sales_agent,
Sum(close_value) as total_sales
From sales_pipeline
group by sales_agent
having total_sales > 20000

/*Retrieve the names of regional_office that have sales_agent managing
 opportunities in the 'Negotiation' stage.*/
 
SELECT * FROM accounts
SELECT * FROM sales_pipeline
SELECT * FROM sales_teams
SELECT * FROM products

Select 
st.regional_office,
st.sales_agent,
Count(sp.deal_stage) as total_deals_lost
From sales_teams st
Join sales_pipeline sp on sp.sales_agent = st.sales_agent
Where sp.deal_stage = 'Lost'
Group by st.sales_agent, st.regional_office


/* Find the sector with the highest total revenue among all accounts */

SELECT * FROM accounts
SELECT * FROM sales_pipeline

Select 
ac.sector,
ac.account, 
Sum(sp.close_value) as total_sales
From accounts ac
Join sales_pipeline sp on ac.account = sp.account
Group by ac.sector, ac.account
order by total_sales desc

SELECT 
sector,
MAX(revenue) as highest_revenue
From accounts
Group by sector


SELECT sector 
FROM accounts 
WHERE revenue = (SELECT MAX(revenue) FROM accounts);


/*Count the number of opportunities managed by each manager from the sales_team table*/

Select
st.manager,
count(sp.opportunity_id) as total_opportunities
From sales_teams st
join sales_pipeline sp on st.sales_agent = sp.sales_agent
group by st.manager

/*Get the product names that were sold by sales_agent 
under a manager named 'Dustin Brinkmann'.
*/

Select distinct
p.Product,
st.Manager
From products p
join sales_pipeline sp on p.product = sp.product
join sales_teams st on st.sales_agent = sp.sales_agent
Where manager = 'Dustin Brinkmann'

/* Retrieve the sector name that has the highest cumulative 
revenue among all accounts. */

select 
sector
from accounts
Where revenue = (select Max(revenue) from accounts)

SELECT sector
FROM accounts 
GROUP BY sector 
HAVING SUM(revenue) = (SELECT MAX(total_revenue) 
                       FROM (SELECT sector, SUM(revenue) AS total_revenue 
                             FROM accounts 
                             GROUP BY sector) AS subquery)


/* Display the product names that have a sales_price greater than the average 
sales price of products in their respective series.*/

SELECT product
FROM products p
WHERE sales_price > (
  SELECT AVG(sales_price)
  FROM products sub
  WHERE sub.series = p.series
);

 /* List the names of sales_agent who are managing more than 3 opportunities
 in the sales_pipeline table. */

Select 
sales_agent
From sales_pipeline
Where opportunity_id = (select sales_agent,
count(opportunity_id) as total_opportunity From sales_pipeline Group by sales_agent
having total_opportunity > 150) 


SELECT sales_agent
FROM sales_pipeline
GROUP BY sales_agent
HAVING COUNT(opportunity_id) > 150


/* Identify the account that has the highest number of employees 
from the accounts table */

select * from accounts


SELECT account 
FROM accounts 
WHERE employees = (SELECT MAX(employees) FROM accounts);


/* List manager names from the sales_team table who are managing 
sales_agent with opportunities in the 'Closed Won' stage in the sales_pipeline.*/

        
        SELECT DISTINCT manager 
FROM sales_teams 
WHERE sales_agent IN (SELECT sales_agent 
                      FROM sales_pipeline 
                      WHERE deal_stage = 'Won')


/* Find the product names that were sold by agents who work under a 
regional office called 'West Zone' */

SELECT * FROM accounts
SELECT * FROM sales_pipeline
SELECT * FROM sales_teams
SELECT * FROM products

select distinct 
p.product
from products p
join sales_pipeline sp on p.product = sp.product
join sales_teams st on sp.sales_agent = st.sales_agent
Where st.regional_office = 'West'

/* Retrieve the names of sales_agent who have closed deals in the
 first quarter (January to March) of 2023..*/

select distinct
sales_agent
from sales_pipeline
where close_date between '2017-03-31' and '2017-06-30'


/* Retrieve the names of products that have been sold by sales agents 
in the East regional office,
 and whose sales price is higher than the average sales price of products in 
 the West regional office*/
 
Select 
p.product
from products p
join sales_pipeline sp on p.product = sp.product
join sales_teams st on sp.sales_agent = st.sales_agent
Where st.sales_agent IN (
        SELECT sales_agent 
        FROM sales_teams 
        WHERE regional_office = 'East'
    )
  AND 
    p.sales_price > (
        SELECT AVG(sales_price) 
        FROM products 
        WHERE product IN (
            SELECT p2.product
            FROM products p2
            JOIN sales_pipeline sp2 ON p2.product = sp2.product
            JOIN sales_teams st2 ON sp2.sales_agent = st2.sales_agent
            WHERE st2.regional_office = 'West'
        )
    );
        
        
/* List the sectors of accounts that have total revenue greater than the average revenue 
of all sectors in the accounts table. */

SELECT DISTINCT sector
FROM accounts
WHERE revenue > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT SUM(revenue) AS total_revenue
        FROM accounts
        GROUP BY sector
    ) AS sector_revenues
);

/* Identify sales agents who have closed deals in the sales_pipeline with a 
value greater than the maximum deal value for agents in the West regional office. */


SELECT 
    sp.sales_agent
FROM 
    sales_pipeline sp
GROUP BY 
    sp.sales_agent
HAVING 
    SUM(sp.close_value) > (
        SELECT 
            SUM(sp2.close_value)
        FROM 
            sales_pipeline sp2
        JOIN 
            sales_teams st ON st.sales_agent = sp2.sales_agent 
        WHERE 
            st.regional_office = 'WEST'
    );


/*  Retrieve the accounts that have the highest number of opportunities in the sales_pipeline, 
along with their sector and revenue. */

Select 
a.account,
a.sector,
a.revenue,
count(sp.opportunity_id) as total_opportunities
from sales_pipeline sp
join accounts a on a.account = sp.account
group by a.account, a.sector, a.revenue
having count(sp.opportunity_id) = (select MAX(sp.opportunity_id) From (Select 
count(sp.opportunity_id) as total_opportunities
from sales_pipeline sp group by account ) as count)


Select 
    a.account,
    a.sector,
    a.revenue,
    COUNT(sp.opportunity_id) as total_opportunities
from 
    sales_pipeline sp
join 
    accounts a on a.account = sp.account
group by 
    a.account
having 
    COUNT(sp.opportunity_id) = (
        SELECT MAX(total_opportunities) 
        FROM (
            SELECT 
                COUNT(sp.opportunity_id) as total_opportunities
            FROM 
                sales_pipeline sp 
            GROUP BY 
                account 
        ) as count
    );


/* List the managers who oversee sales agents with a total sales value exceeding the average sales 
value of all sales agents. */


SELECT DISTINCT st.manager
FROM sales_teams st
WHERE st.sales_agent IN (
    SELECT sp.sales_agent
    FROM sales_pipeline sp
    GROUP BY sp.sales_agent
    HAVING SUM(sp.close_value) > (
        SELECT AVG(total_sales)
        FROM (
            SELECT SUM(close_value) AS total_sales
            FROM sales_pipeline
            GROUP BY sales_agent
        ) AS agent_totals
    )
);


/* Retrieve the sector name that has the highest total revenue among accounts 
that also have at least one associated opportunity in the sales pipeline.
*/

SELECT 
    sector, SUM(revenue) AS total_revenue
FROM
    accounts
GROUP BY sector
HAVING SUM(revenue) = (SELECT 
        MAX(total_revenue)
    FROM
        (SELECT 
            SUM(revenue) AS total_revenue
        FROM
            accounts
        GROUP BY sector)  AS sector_revenue)


/* List the names of sales agents whose total close value from the sales 
pipeline is greater than the average close value of all sales agents.
*/
 ## DID NOT UNDERSTAND ## 
 
SELECT
sales_agent,
SUM(close_value) as Total_close_value
From sales_pipeline
group by sales_agent
having SUM(close_value) IN ((Select AVG(close_value) from sales_pipeline) > (Select SUM(close_value) from sales_pipeline) )


/* Identify the products sold by sales agents located in the 'East' regional office 
that have a sales price above the average sales price of all products.*/

SELECT
sp.sales_agent,
p.product
From products p
Join sales_pipeline sp on sp.product = p.product
Join sales_team st on sp.sales_agent = st.sales_agent
Where sales_agents IN (select sales_agents 
					from sales_team 
                    where regional_office = 'East' (Select Sum(sales_price) 
													from products 
                                                    (select avg(sales_price from product) as regional_sales Group by sales_agent )Group by sales_agent)  )
                                                    
                                                    
SELECT
    sp.sales_agent,
    p.product
FROM 
    products p
JOIN 
    sales_pipeline sp ON sp.product = p.product
JOIN 
    sales_teams st ON sp.sales_agent = st.sales_agent
WHERE 
    st.sales_agent IN (
        SELECT 
            sales_agent 
        FROM 
            sales_teams 
        WHERE 
            regional_office = 'East'
    )
AND 
    p.sales_price > (
        SELECT 
            AVG(sales_price) 
        FROM 
            products
    );
                                                 
    
    
WITH east_agents AS (
    SELECT sales_agent FROM sales_teams WHERE regional_office = 'East'
)
SELECT * FROM east_agents;


-- I AM WORKING ON MY PAIN POINTS

/* 1. You want to find the total revenue for each sector, 
but only for those sectors where the total revenue is greater than 10,000. */

SELECT
sector,
SUM(revenue) as Total_Revenue
From accounts
Group by sector
having Total_Revenue > 10000


/* 2. Retrieve the products sold by sales agents working in the 'East' regional office. */

SELECT Distinct
p.product
FROM 
    products p
JOIN 
    sales_pipeline sp ON sp.product = p.product
Where sp.sales_agent IN (SELECT sales_agent
						FROM sales_teams 
                        Where regional_office = 'EAST')

/* 3.Get the name of sectors whose total revenue is above the average revenue of all sectors. */
## WRONG
select
sector
from accounts
Where revenue IN ((Select SUM(Revenue) from accounts) > (Select AVG(Revenue) from accounts) );


-- Correct
SELECT 
    sector, 
    SUM(revenue) AS total_revenue
FROM accounts
GROUP BY sector
HAVING total_revenue > (SELECT AVG(revenue) FROM accounts);


/* 4.Get a list of sectors and their average revenue. */

SELECT 
sector,
AVG(revenue) as AVG_revenue
from accounts
Group by sector


/* 5.Retrieve the accounts that have more than 5 opportunities in the sales_pipeline. */

SELECT
account,
Count(opportunity_id) as total_opportunity
from sales_pipeline
group by account
having total_opportunity > 15

/* 6.Find managers of sales agents whose total sales are above the overall average sales. */

SELECT DISTINCT st.manager
FROM sales_teams st
WHERE st.sales_agent IN (
    SELECT sp.sales_agent
    FROM sales_pipeline sp
    GROUP BY sp.sales_agent
    HAVING SUM(sp.close_value) > (
        SELECT AVG(total_sales)
        FROM (
            SELECT SUM(close_value) AS total_sales
            FROM sales_pipeline
            GROUP BY sales_agent
        ) AS agent_totals
    )
);

/* Retrieve the accounts that have the highest cumulative revenue, based on multiple sectors. */

SELECT 
    account, 
    sector, 
    revenue
FROM accounts
WHERE sector IN (
    SELECT sector
    FROM accounts
    GROUP BY sector
    HAVING SUM(revenue) = (
        SELECT MAX(total_revenue)
        FROM (
            SELECT 
                sector, 
                SUM(revenue) AS total_revenue
            FROM accounts
            GROUP BY sector
        ) AS subquery
    )
);

/* Find the managers of sales agents whose total sales are above the overall average sales */

SELECT 
    st.manager, st.sales_agent
FROM
    sales_teams st
        JOIN
    sales_pipeline sp ON st.sales_agent = sp.sales_agent
GROUP BY st.manager, st.sales_agent
HAVING SUM(sp.close_value) > (SELECT 
        AVG(close_value)
    FROM
        sales_pipeline)
        
        
/*2. Question: List the products that have a sales price above the average sales price.*/

SELECT 
product
from products
group by product
having SUM(sales_price) > (SELECT AVG(sales_price) from products)

-- 3. Question: Retrieve accounts that have more than the average revenue for all accounts.

SELECT
account
from accounts
Where revenue > (SELECT AVG(revenue) from accounts)

/* 4. Find the sales agents who have closed more opportunities
 than the average number of opportunities per agent. */

With avg_opportunity_agent as (SELECT avg(Total_opportunity) as Avg_Total_Opp from (SELECT count(opportunity_id) as Total_opportunity from sales_pipeline group by sales_agent)AS agent_opportunities)

Select
sales_agent 
from sales_pipeline
group by sales_agent
having Count(opportunity_id) > (Select Avg_Total_Opp from avg_opportunity_agent);


/* 5. Identify sectors that contribute to more than the average revenue across all sectors */
 # wrong 
select 
sector
from accounts
group by sector
having Sum(revenue)  > (SELECT avg(revenue) from accounts)


/* 6. Get the names of the products sold by sales agents from the 'West' 
regional office that are priced above the average sales price.*/

SELECT
p.product
from products p
Join sales_pipeline sp on sp.product = p.product 
Join sales_teams st on sp.sales_agent = st.sales_agent
Where st.regional_office = 'East' and p.sales_price > (SELECT avg(sales_price) from products)



/* 7. Find all sales agents whose total closed value exceeds the overall average closed value */
-- sol 1

WITH avg_closed_value AS (
    SELECT AVG(close_value) AS avg_value
    FROM sales_pipeline
)

SELECT DISTINCT 
sp.sales_agent
FROM sales_pipeline sp
WHERE sp.close_value > (SELECT avg_value FROM avg_closed_value);

