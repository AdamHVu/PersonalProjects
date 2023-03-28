# The Most Generic Query, Grabs All Info From Table

SELECT * 
FROM Table 

# The * can be replaced if you want specific columns only. 

SELECT Column_Name 
FROM Table
LIMIT 15;

# You can use a limit to well limit results so that you do not have 
# to waste time grabbing all the data should you not need all of it.

# Next is ORDER BY. This does exactly what you think. Orders from lowest to 
# highest, A to Z, earliest to latest AKA Ascending Order. DESC at the end
# if you want the opposite results.  
# The important note is that it must come after the FROM keyword and 
# before the LIMIT. 

# This example query gives the 10 earliest orders sorted by time.

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

# This example query gives the top 5 orders in terms of how much
# money was spent.

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

# We can use multiple columns when using ORDER BY. The order in which
# you write the columns is the order the table will be outputted. 

# This example query gives the order_id, account_id, and total amount spent in usd
# sorting it by the account ID in ascending order and then the amount spent in descending order.

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

# The order in which you use ORDER BY when writing column names is important.
# There are cases in where should you write a specific column over another that the output
# may be different than expected. In the example above, should we flip total_amt_usd
# and account_id, we get two totally different results. If we sort it by money
# first, that column is correctly sorted. However the account_id's are not 
# sorted. This is because there are no similiar amounts of money being spent
# by order and so it prioritizes sorting by money and outputs accordingly.
# If we sort it by account_id first, it gives us a sorted list of the ids 
# followed by the sorted amount of money spent per account_id. 

# The next statement is WHERE. This is your filtering keyword.
# This will output results if certain conditions are met. WHERE also
# has a specific order, it comes after FROM and before ORDER BY.

# In this example query, this would return all columns from orders
# where gloss_amt_usd was greater or equal to 1000.

SELECT * 
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

# In WHERE, when using non-numerical values, you need to use single quotes.
# Most of the time with these sorts of values, you use the = or != symbols.

# In this example query, this would output the company specified and show
# the name, website, and POC columns.

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

# You can use operators (+-*/) when selecting columns, you may want to use 
# to combine. This will generate a derived column, AKA a column who outputs
# whatever operator you wanted to the selected columns. To name this new 
# column, simply add AS to end followed by the name (make sure it does
# include captials or spaces.)

# In this example query, we output a new column that takes the amount of 
# product sold and divides it by the quantity and gives us a new column.

SELECT id, 
	   account_id,
       standard_amt_usd / standard_qty AS price_per_unit
FROM orders
LIMIT 10;

# In this example query, we output the percentage of posters sold from 
# each order.

SELECT id, 
	   account_id,
       poster_amt_usd / (standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS poster_sales
FROM orders
LIMIT 10;

# Next up is Logical Operators. These are sort of like the math operators and WHERE. 
# Some of these are used in place of =. 

# First up is LIKE. This is kinda like WHERE and = but when you're unsure of exactly what 
# you are looking for. You usually use the % operator with LIKE.

# In this example query, this would return all companies whose name starts with a C.

SELECT name
FROM accounts
WHERE name LIKE 'C%';

# As a sidenote sometimes when looking for single quotes, you may need to use 
# double quotes to do so.

# Next is IN. In is agaion like WHERE and =, but for more than one condition. IN also
# requires single quotes around non-numericals.

# In this example query, this would output the name, primary_poc, and sales_rep_id
# for the names within the conditions listed.

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom')

# Another one is NOT. This is used with IN and LIKE to produce rows that are NOT LIKE
# and NOT IN certain conditions.

# In this example query, this would give me the inverse results of the one listed above.

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom')

# Following up is AND & BETWEEN. These are mostly used if you have combined conditions
# that must be true. 

# In this practice query, this would return all orders where it fulfills the condtions
# using the AND keyword. 

SELECT *
FROM orders
WHERE standard_qty >= 1000 AND poster_qty = 0 AND gloss_qty = 0;

# In this practice query, this would output all companies whose names don't start
# with the letter C or end in the letter S. 

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

# In this practice query, I use BETWEEN to grab specifically when the condition is between two
# values in a cleaner fashion as compared to using AND twice.

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

# In this practice query, it combines a few of the logical operators and gives us
# whenever the channels are met and the time is past a certain date ordered by newest to oldest.

SELECT * 
FROM web_events 
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

# Finally we have OR. This is mostly used if you have at least one combined condition 
# that is required to be true. 

# In this practice query, it wants the list of IDs that fit a specific condition that can be 
# one of two in this case.

SELECT id 
FROM orders 
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT * 
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

# In this final query, it wants the list of company names that start with C or W
# and whose primary_poc contains ana or Ana but not eana. 

SELECT name
FROM accounts
WHERE name LIKE 'C%' OR name LIKE 'W%' AND primary_poc LIKE '%ana%' OR 
primary_poc LIKE '%Ana%' AND primary_poc NOT LIKE '%eana';  

_____________________________________________________________________________

# SQL Joins

# Joins allow for the use of gathering data from multiple tables using the ON keyword.
# Tables who are joined will have a matching column.

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

# JOIN - an INNER JOIN that only pulls data that exists in both tables.
# LEFT JOIN - pulls all the data that exists in both tables, as well as all of the rows from 
# the table in the FROM even if they do not exist in the JOIN statement.
# RIGHT JOIN - pulls all the data that exists in both tables, as well as all of the rows from 
# the table in the JOIN even if they do not exist in the FROM statement.

# Here is what a query with a join might look like. You SELECT the info you want 
# from the first table FROM where it is located then JOIN on the second table ON
# the similiar columns from both tables. 

# You can also pull specific info from columns with a query like this.

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders 
JOIN accounts
ON orders.account_id = accounts.id

# When joining, we will always take from the original table's Primary Key and JOIN
# it with the second table's foriegn key. A foriegn key is just a subset of a primary key.
# The ordering doesn't super matter but the PK and FK must always be linked.

# In this example query, this joins more than just one table. Always keep in mind
# the primary key but overall the formatting is the same. If an ERD is avaiable,
# refer to the crow's feet notation. ( ERD is entity relationship diagram)

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id

# Aliases are a way to shorten table names to make coding more efficient. Usually they are 
# lowercase single letters as to keep it clean and they go after the specific table.  
# The AS Keyword is optional for these statements. If I didnt include it, it would give
# the same result. The query below shows my results.

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

# In this example query, we gather 4 specific columns and use a join looking for a condition.

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE name = 'Walmart';

# In this example queries, we output a table that uses multiple joins. For examples like these,
# it may be easier to insert aliases later if it gets confusing.

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

SELECT r.name region, a.name account, o.total_amt_usd/(o.total +0.01) unit_price
FROM sales_reps s
JOIN region r 
ON s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id;

# INNER joins only return rows that appear in both tables like the previous
# examples. An easier way to think of JOINs is to consider it like a venn
# diagram. For an INNER JOIN, it only outputs rows that have a match across both tables.
# The table that comes after FROM is the left table and the table you're 
# joining is considered the RIGHT table. A JOIN by default is considered an INNER
# JOIN; there are other types of joins like LEFT, RIGHT, and OUTER. A LEFT JOIN
# takes all the values from the left table including values that matched from
# the right table and excludes any non-matching. A RIGHT JOIN is the opposite.  

# The queries above have all been inner joins. There are also OUTER joins.
# These will return the inner join results as well as any unmatched rows
# that would result from either table being joined. A LEFT and RIGHT JOIN 
# could be considered OUTER JOINS but we rarely will ever do a FULL OUTER.

# To mention again for clarity, INNER JOINs only include matching rows.
# A LEFT JOIN contains the same info as a INNER JOIN but includes rows that
# don't have a match from the LEFT table. If we have 

# This example query is the stated INNER JOIN. COUNTRY is the left table
# so we want to match the RIGHT table on ID.

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
JOIN State s
ON c.countryid = s.countryid;

# This example query is the stated LEFT JOIN. While it is similar, I cannot
# provide the tables but on the right table in our example here, there are duplicates
# while on the left table there are two unused IDs. We would match and fulfill
# the demands of the inner join but include the two unused IDs because 
# it is a LEFT JOIN. The two extras would be left with NULL values.

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s
ON c.countryid = s.countryid;

# Below are some practice queries. 

# This query returns the region with the sales rep and their account in the Midwest region
# whose name begins with a S.

SELECT r.name region, s.name sale_rep, a.name accounts
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name

# This query returns the region with the sales rep and their account in the Midwest region
# whose last name begins with a K. Notice the space in the LIKE statement quotes.

SELECT r.name region, s.name sale_rep, a.name accounts
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name


SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;

________________________________________________________________________________________

# Aggregation

# Some keywords used with this are COUNT, SUM, MIN & MAX, and AVG. Count gives the number
# of rows in a column. Sum adds up all values in a column. Min and Max are the lowest and 
# greatest value of a column respectively. And finally AVG gets the mean of all values in a column.

# Something that could show up in your data are NULLs. These are not zeroes but rather just 
# empty cells AKA no data at all. One way to find these nulls is to use it in the WHERE clause.
# We could say that we want all the companies without a phone number in the table by
# saying something like "WHERE PhoneNum IS NULL". You write IS NULL and not = NULL.

# The first keyword I mentioned was COUNT. It will return the number of rows in a column.
# This is nice because instead of getting all the info of every column by outputting all
# the results that way, we can simply just get a single row one number solution that is much easier.

# This is a very basic example but we can use something like this or 
# specify which column we want. The * indicating all info.

SELECT COUNT(*)
FROM accounts; 

SELECT COUNT(accounts.id)
FROM accounts;

# COUNT is one of the few that can be used with non-numerical data. Unlike something like 
# SUM, we cannot add strings and get a sensible result. SUM can only be used on numeric columns
# and will ignore NULLs. 

# As seen with COUNT, we can use the *. SUM cannot because we are adding columns hence in the
# set () we will need to include the column name. 

SELECT SUM(poster_qty) AS total_posters
FROM orders;

SELECT standard_amt_usd+gloss_amt_usd AS total_standard_gloss
FROM orders;

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

# Next up is MIN, MAX, and AVG. Those do what they say. Find the lowest, highest, and the mean.

# In this example query, this returns the earliest order.

SELECT MIN(occurred_at)
FROM orders;

# In this example query, this returns the latest order.

SELECT MAX(occurred_at)
FROM web_events;

# In this example query, this returns the latest order without aggregation.

SELECT w.occurred_at
FROM web_events w
ORDER BY occurred_at DESC
LIMIT 1;

# In this example query, this will give us the median. So because the number of entries 
# cannot be evenly split (6912 so we split it 3457 and 3456, we must split the results 
# into two separate entries. This is basically a nested SELECT statement, the inner query
# is one entry that pulls the total amt at the halfway point 3457 and order it accordingly.
# The second one does the same thing. We end up with 2482.55 being the median out of 3456 entries.
# Finally, we limit it to two to grab the actual median.

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

# GROUP BY can be used to aggregate data within subsets of the data. 
# For example, grouping for different accounts, different regions, or different sales 
# representatives.

# In this example query, we want to find the total sales in USD for each account. The 
# in each account is important basically meaning we need to use a GROUP BY. We return
# two columns, one for total sales and one for the company name.

SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

# In this example query, we return the channel with the latest event with the account associated.

SELECT w.occurred_at date_time, w.channel channel_used, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY occurred_at DESC
LIMIT 1;

# In this example query, we return the number of times each channel is used.
# We use GROUP BY here because after we get the counts, we need to associate those counts with
# their respective values so we GROUP BY the channel name, basically saying "Hey we got the counts,
# just assign those counts to what they counted."

SELECT w.channel channel_name, COUNT(*)
FROM web_events w
GROUP BY w.channel;

# You can sort of look at GROUP BY as a bucket of sorts. We need something to hold our entries in.
# As for other aggregations I have discussed, easy ways to tell when they need to be used 
# deal with the wording of the request in mind. If they say, "Give me the smallest/largest amount"
# you probably gotta use MIN or MAX. 

# In this practice query, we return the primary contact with the earliest date.

SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

# In this example query, this would give us the smallest order from each account.

SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

# In this example query, I found the number of sales reps per region.

SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

# In this practice query, I outputted each account and the average paper of each type
# they bought.

SELECT a.name, AVG(standard_qty) AS avg_standard,
AVG(poster_qty) AS avg_poster, AVG(gloss_qty) AS avg_glossy
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

SELECT s.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;

# In this practice query, we are checking if any account is associated with more than one region.



