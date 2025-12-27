USE mavenmovies;

--- MID LEVEL PROJECT ---

/* 1. We will need a list of all staff members, including their first and last names, email addresses, and the store
identification number where they work. */
SELECT first_name,
last_name,
email,
store_id
FROM staff;

/* Staff details
This query shows a list of all staff members working in the company.
It includes their names, email IDs, and which store they are assigned to.
Helpful for understanding who works where */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 2. We will need separate counts of inventory items held at each of your two stores.*/
SELECT store_id,
count(inventory_id) AS inventory_item
FROM inventory
group by store_id;

/* Inventory count per store

This query counts how many inventory items are available in each store.
It groups the data by store ID to give a clear store-wise breakdown.
Useful for comparing stock levels between stores.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 3. We will need a count of active customers for each of your stores. Separately, please.*/
SELECT 
store_id,
count(customer_id) AS active_customer
from customer
WHERE active = 1 
group by store_id;

/* Active customers per store

This query finds how many customers are currently active in each store.
It only counts customers marked as active.
This helps understand customer engagement per store.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 4. In order to assess the liability of a data breach, we will need you to provide a count of all customer email
addresses stored in the database.*/
SELECT 
count(email) AS emails
FROM customer ;

/* Total customer email addresses

This query counts all email addresses stored in the customer table.
It helps assess how much customer contact data the company holds.
Important for data privacy and security evaluation.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 5. We are interested in how diverse your film offering is as a means of understanding how likely you are to keep customers engaged in the future. 
Please provide a count of unique film titles you have in inventory at each store and then provide a count of the unique categories of films you provide.*/
SELECT store_id,
count(distinct film_id) AS count_of_unique_films
FROM inventory
group by store_id;


SELECT 
 count(distinct name) AS unique_name
 FROM category;
 
 /* Film diversity

The first query counts how many unique film titles are available in each store.
The second query counts how many different film categories exist overall.
Together, they show how diverse the film collection is.*/
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 6. We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, the most expensive to replace, and the average of all films you carry.*/
SELECT 
min(replacement_cost) AS least_expensive,
max(replacement_cost) AS most_expensive,
avg(replacement_cost) AS avg_replacement_cost
FROM film;
/* Film replacement cost analysis

This query finds the cheapest, most expensive, and average replacement cost of films.
It gives a quick financial overview of potential loss or replacement expenses.
Useful for risk and cost planning.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 7. We are interested in having you put payment monitoring systems and maximum payment processing restrictions in place 
in order to minimize the future risk of fraud by your staff. Please provide the average payment you process, as well as the maximum payment you have processed.*/
SELECT 
avg(amount ) AS avg_payment,
max(amount ) AS max_payment
FROM payment;

/* Payment monitoring

This query calculates the average and maximum payment processed.
It helps understand typical customer spending and detect unusually high payments.
Useful for fraud prevention and monitoring.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 8. We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals they have made all-time, with your highest volume customers at the top of the list.*/
SELECT customer_id,
count(rental_id) AS total_no_of_rental
FROM rental
group by customer_id
order by count(rental_id) DESC;

/* Customer rental activity

This query shows how many rentals each customer has made.
Customers with the highest number of rentals appear at the top.
It helps identify loyal and high-value customers.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- FINAL COURSE PROJECT ---

/* 9. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address of each property (street address, district, city, and country please).*/
SELECT
staff.first_name AS manager_first_name,
staff.last_name AS manager_last_name,
address.address,
address.district,
city.city,
country.country

FROM store
LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
LEFT JOIN address ON store.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id;

/* Store managers and addresses

This query lists the manager of each store along with the full store address.
It combines data from staff, store, address, city, and country tables.
Useful for meetings and business visits.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 10. I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, the inventory_id, the name of the film, 
the film’s rating, its rental rate, and replacement cost.*/
SELECT
    inventory.store_id,
    inventory.inventory_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
FROM inventory
LEFT JOIN film
    ON inventory.film_id = film.film_id;
    
/* Detailed inventory list

This query shows every inventory item along with film details.
It includes store ID, film name, rating, rental rate, and replacement cost.
Helps understand exactly what inventory comes with the business.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
    
/* 11. From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory. 
We would like to know how many inventory items you have with each rating at each store.*/
SELECT
    inventory.store_id,
    film.rating,
    COUNT(inventory.inventory_id) AS inventory_items
FROM inventory
LEFT JOIN film
    ON inventory.film_id = film.film_id
GROUP BY
    inventory.store_id,
    film.rating;
    
/* Inventory summary by rating

This query groups inventory items by store and film rating.
It counts how many films of each rating exist in each store.
Useful for understanding content distribution.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 12. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. 
We want to see how big of a hit it would be if a certain category of film became unpopular at a certain store. We would like to see the number of films, 
as well as the average replacement cost, and total replacement cost, sliced by store and film category.*/
SELECT
    inventory.store_id,
    category.name AS category,
    COUNT(inventory.inventory_id) AS films,
    AVG(film.replacement_cost) AS avg_replacement_cost,
    SUM(film.replacement_cost) AS total_replacement_cost
FROM inventory
LEFT JOIN film
    ON inventory.film_id = film.film_id
LEFT JOIN film_category
    ON film.film_id = film_category.film_id
LEFT JOIN category
    ON category.category_id = film_category.category_id
GROUP BY
    inventory.store_id,
    category.name
ORDER BY
    SUM(film.replacement_cost) DESC;
    
/* Replacement cost by category

This query analyzes inventory by store and film category.
It shows how many films exist, their average cost, and total replacement cost.
Helpful for understanding financial risk by category.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 13. We want to make sure you folks have a good handle on who your customers are. 
Please provide a list of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country.*/
SELECT
    customer.first_name,
    customer.last_name,
    customer.store_id,
    customer.active,
    address.address,
    city.city,
    country.country
FROM customer
LEFT JOIN address
    ON customer.address_id = address.address_id
LEFT JOIN city
    ON address.city_id = city.city_id
LEFT JOIN country
    ON city.country_id = country.country_id;
    
/* Customer profiles

This query lists all customers with their store, active status, and full address.
It joins customer and location details into one clean view.
Useful for customer analysis and outreach planning.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 14. We would like to understand how much your customers are spending with you, and also to know who your most valuable customers are. 
Please pull together a list of customer names, their total lifetime rentals, and the sum of all payments you have collected from them. 
It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list.*/
SELECT
    customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS total_rentals,
    SUM(payment.amount) AS total_payment_amount
FROM customer
LEFT JOIN rental
    ON customer.customer_id = rental.customer_id
LEFT JOIN payment
    ON rental.rental_id = payment.rental_id
GROUP BY
    customer.first_name,
    customer.last_name
ORDER BY
    SUM(payment.amount) DESC;
    
/* Customer lifetime value

This query calculates total rentals and total payments for each customer.
Customers are sorted by how much money they have spent.
It clearly highlights the most valuable customers.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 15. My partner and I would like to get to know your board of advisors and any current investors. 
Could you please provide a list of advisor and investor names in one table? Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with.*/
SELECT
    'investor' AS type,
    first_name,
    last_name,
    company_name
FROM investor

UNION

SELECT
    'advisor' AS type,
    first_name,
    last_name,
    'N/A' AS company_name
FROM advisor;

/* Advisors and investors

This query combines investors and advisors into one list.
It labels each person clearly and shows company names for investors.
Useful for understanding business stakeholders.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 16. We’re interested in how well you have covered the most-awarded actors. Of all the actors with three types of awards, for what % of them do we carry a film? 
And how about for actors with two types of awards? Same questions. Finally, how about actors with just one award?*/
SELECT
    CASE
        WHEN actor_award.awards = 'Emmy, Oscar, Tony' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
        ELSE '1 award'
    END AS number_of_awards,
    AVG(
        CASE
            WHEN actor_award.actor_id IS NULL THEN 0
            ELSE 1
        END
    ) AS pct_w_one_film
FROM actor_award
GROUP BY
    CASE
        WHEN actor_award.awards = 'Emmy, Oscar, Tony' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
        ELSE '1 award'
    END;
    
/* Award-winning actor coverage

This query checks what percentage of award-winning actors have at least one film in inventory.
It compares actors with 1, 2, or 3 types of awards.
This helps measure how strong the film catalog is in terms of top talent.*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
