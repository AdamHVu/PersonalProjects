# The Most Generic Query, Grabs All Info from Table

SELECT * 
FROM Table 

# The * can be replaced should you want specific columns only. 

SELECT Column_Name 
FROM Table
LIMIT 15;

# You can use a limit to well limit results so that you do not have 
# to waste time grabbing all the data should you not need all of it.

# Next is ORDER BY. This does exactly what you think. Orders from lowest to 
# highest, A to Z, earliest to latest AKA Ascending Order. DESC at the end
# should you want the opposite results.  
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

# You can use operators (+-*/) when selecting columns you may want to use 
# to combine. This will generate a derived column, AKA a column who outputs
# whatever operator you wanted to the selected columns. To name this new 
# column, simply add AS to the end followed by the name (make sure it does
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
