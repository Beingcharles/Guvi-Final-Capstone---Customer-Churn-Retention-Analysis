SELECT * FROM churn.customer;

/*Check for duplicates*/
SELECT customer_id, COUNT( customer_id ) as count
FROM customer
GROUP BY customer_id
HAVING count(customer_id) > 1;

/*Find total number of customers*/
SELECT
COUNT(DISTINCT customer_id) AS customer_count
FROM
customer;

-- Calculate total revenue
SELECT SUM(total_charges) AS total_revenue
FROM customer;


-- Calculate total lost revenue due to churned customers
SELECT SUM(total_charges) AS total_lost_revenue
FROM customer
WHERE churn_status = 'yes';



-- Calculate revenue percentage lost due to churned customers
SELECT 
    (total_lost_revenue / total_revenue) * 100 AS revenue_percentage_lost
FROM
    (SELECT 
        (SELECT SUM(total_charges) FROM customer) AS total_revenue,
        (SELECT SUM(total_charges) FROM customer WHERE churn_status = 'yes') AS total_lost_revenue
    ) AS revenue_summary;
    
--  the average age of churned customers
SELECT AVG(age) AS average_age_of_churned_customers
FROM customer
WHERE churn_status = 'yes';

-- the most common contract types among churned customers
SELECT contract_type, COUNT(*) AS count_of_churned_customers
FROM customer
WHERE churn_status = 'yes'
GROUP BY contract_type
ORDER BY count_of_churned_customers DESC;

-- Analyze the distribution of monthly charges among churned customers --
SELECT monthly_charges
FROM customer
WHERE churn_status = 'yes';


SELECT AVG(monthly_charges) AS average_monthly_charge
FROM customer
WHERE churn_status = 'yes';

-- Create a query to identify the contract types that are most prone to churn
SELECT contract_type, COUNT(*) AS churned_customers_count
FROM customer
WHERE churn_status = 'yes'
GROUP BY contract_type
ORDER BY churned_customers_count DESC;

-- Identify customers with high total charges who have churned
SELECT *
FROM customer
WHERE churn_status = 'yes' AND total_charges > 500;

-- Calculate the total charges distribution for churned and non-churned customers

-- Total charges distribution for churned customers
SELECT 
    COUNT(*) AS churned_customers_count,
    MIN(total_charges) AS min_total_charges_churned,
    MAX(total_charges) AS max_total_charges_churned,
    AVG(total_charges) AS avg_total_charges_churned
FROM customer
WHERE churn_status = 'yes';

-- Total charges distribution for non-churned customers
SELECT 
    COUNT(*) AS non_churned_customers_count,
    MIN(total_charges) AS min_total_charges_non_churned,
    MAX(total_charges) AS max_total_charges_non_churned,
    AVG(total_charges) AS avg_total_charges_non_churned
FROM customer
WHERE churn_status = 'no';

-- Calculate the average monthly charges for different contract types among churned customers
SELECT 
    contract_type,
    AVG(monthly_charges) AS avg_monthly_charges
FROM customer
WHERE churn_status = 'yes'
GROUP BY contract_type;

-- Identify customers who have both online security and online backup services and have not churned
SELECT *
FROM customer
WHERE online_security = 'Yes'
AND online_backup = 'Yes'
AND churn_status = 'no';

-- Determine the most common combinations of services among churned customers
SELECT 
    CONCAT(online_security, '_', online_backup) AS service_combo,
    COUNT(*) AS combo_count
FROM customer
WHERE churn_status = 'yes'
GROUP BY service_combo
ORDER BY combo_count DESC;

-- Identify the average total charges for customers grouped by gender and marital status
SELECT 
    gender,
    marital_status,
    AVG(total_charges) AS avg_total_charges
FROM customer
GROUP BY gender, marital_status;

-- Calculate the average monthly charges for different age groups among churned customers
SELECT 
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        WHEN age >= 60 THEN '60 and above'
    END AS age_group,
    AVG(monthly_charges) AS avg_monthly_charges
FROM customer
WHERE churn_status = 'yes'
GROUP BY age_group;

-- Determine the average age and total charges for customers with multiple lines and online backup

SELECT 
    AVG(age) AS average_age,
    AVG(total_charges) AS average_total_charges
FROM customer
WHERE multiple_lines = 'Yes'
AND online_backup = 'Yes';

-- Identify the contract types with the highest churn rate among senior citizens (age 65 and over)
SELECT 
    contract_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_status = 'yes' THEN 1 ELSE 0 END) AS churned_customers,
    (SUM(CASE WHEN churn_status = 'yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS churn_rate
FROM customer
WHERE age >= 65
GROUP BY contract_type
ORDER BY churn_rate DESC;

-- Calculate the average monthly charges for customers who have multiple lines and streaming TV
SELECT 
    AVG(monthly_charges) AS average_monthly_charges
FROM customer
WHERE multiple_lines = 'Yes'
AND streaming_tv = 'Yes';

-- Identify the customers who have churned and used the most online services
SELECT *
FROM (
    SELECT 
        *,
        CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END AS total_online_services
    FROM customer
    WHERE churn_status = 'yes'
) AS churned_customers
ORDER BY total_online_services DESC;

-- Calculate the average age and total charges for customers with different combinations of streaming services
SELECT 
    streaming_tv,
    streaming_movies,
    AVG(age) AS average_age,
    AVG(total_charges) AS average_total_charges
FROM customer
GROUP BY streaming_tv, streaming_movies;

-- Identify the gender distribution among customers who have churned and are on yearly contracts
SELECT 
    gender,
    COUNT(*) AS gender_count
FROM customer
WHERE churn_status = 'yes'
AND contract_type = 'Yearly'
GROUP BY gender;

-- Calculate the average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type
SELECT 
    contract_type,
    internet_service,
    AVG(monthly_charges) AS avg_monthly_charges,
    AVG(total_charges) AS avg_total_charges
FROM customer
WHERE churn_status = 'yes'
GROUP BY contract_type, internet_service;

-- Find the customers who have churned and are not using online services, and their average total charges
SELECT 
    AVG(total_charges) AS average_total_charges
FROM customer
WHERE churn_status = 'yes'
AND online_security = 'No'
AND online_backup = 'No'
AND device_protection = 'No'
AND tech_support = 'No'
AND streaming_tv = 'No'
AND streaming_movies = 'No';

-- Calculate the average monthly charges and total charges for customers who have churned, grouped by the number of dependents
SELECT 
    dependents,
    AVG(monthly_charges) AS average_monthly_charges,
    SUM(total_charges) AS total_charges
FROM customer
WHERE churn_status = 'yes'
GROUP BY dependents;

-- Determine the average age and total charges for customers who have churned, grouped by internet service and phone service
SELECT 
    internet_service,
    phone_service,
    AVG(age) AS average_age,
    SUM(total_charges) AS total_charges
FROM customer
WHERE churn_status = 'yes'
GROUP BY internet_service, phone_service;


SELECT 
    COUNT(CASE WHEN churn_status = 'yes' THEN 1 END) AS churned_customers_count,
    COUNT(*) AS total_customers,
    (COUNT(CASE WHEN churn_status = 'yes' THEN 1 END) / COUNT(*)) * 100 AS churn_rate_percentage
FROM customer;

-- What contract were churners on?
SELECT 
    contract_type,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
    customer
WHERE
    churn_status = 'yes'
GROUP BY
    contract_type
ORDER BY 
    Churned DESC; 

-- Did churners have tech support?
SELECT 
    Tech_Support,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(),1) AS Churn_Percentage
FROM
    customer
WHERE 
    churn_status = 'yes'
GROUP BY Tech_Support
ORDER BY Churned DESC;

-- What Internet Service did 'Competitor' churners have?
SELECT
    internet_service,
ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    customer
WHERE 
    churn_status = 'yes'
GROUP BY
internet_service
ORDER BY Churn_Percentage DESC;

-- What gender were churners?
SELECT
    gender,
    round(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    customer
WHERE
    churn_status = 'yes'
GROUP BY
    gender
ORDER BY
Churn_Percentage DESC;

-- Did churners have dependents
SELECT
    CASE
        WHEN Dependents > 0 THEN 'Has Dependents'
        ELSE 'No Dependents'
    END AS Dependents,
    round(COUNT(Customer_ID) *100 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage

FROM
  customer
WHERE
    churn_status = 'yes'
GROUP BY 
CASE
        WHEN Dependents > 0 THEN 'Has Dependents'
        ELSE 'No Dependents'
    END
ORDER BY Churn_Percentage DESC;

-- Were churners married
SELECT
    Marital_status,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    customer
WHERE
    Churn_Status = 'yes'
GROUP BY
    Marital_status
ORDER BY
Churn_Percentage DESC;

SELECT  
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END AS Age,
    ROUND(COUNT(Customer_ID) * 100 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
    dbo.churn2
WHERE
    Customer_Status = 'Churned'
GROUP BY
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END
ORDER BY
Churn_Percentage DESC;

-- What gender were churners?
SELECT
    Gender,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    dbo.churn2
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Gender
ORDER BY
Churn_Percentage DESC;

-- HOW old were churners?
SELECT  
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END AS Age,
    round(COUNT(Customer_ID) * 100 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
    customer
WHERE
    churn_status = 'yes'
GROUP BY
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END
ORDER BY
Churn_Percentage DESC;

