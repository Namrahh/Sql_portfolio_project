select * from ibm_customer_data;

-- Query 1: Considering the top 5 groups with the highest average monthly charges among churned customers,
-- how can personalized offers be tailored based on age, gender, and contract type to potentially improve customer retention rates?

-- What this query reveals --> The query provides insights into the highest-spending churned customers, detailing their demographics (age, gender), 
-- service characteristics (contract type, internet type), and usage patterns (streaming subscriptions, monthly charges). 
-- This information can help the company identify high-value customers who have left and potentially inform targeted retention strategies.

WITH ChurnedCustomers AS (
    SELECT 
        `Customer ID`,
        Contract,
        `Monthly Charge`,
        `Customer Status`,
        `Churn Label`,
        Gender,
        Age,
        `Tenure in Months`,
        `Internet Type`,
        `Avg Monthly GB Download`,
        `Streaming TV`,
        `Streaming Movies`,
        `Streaming Music`
    FROM 
        ibm_customer_data
    WHERE 
        `Churn Label` = 'Yes'
)
SELECT 
    `Customer ID`,
    Contract AS `Contract Type`,
    `Monthly Charge` AS `Avg Monthly Charges`,
    `Customer Status`,
    Age,
    Gender,
    `Tenure in Months`,
    `Internet Type`,
    `Avg Monthly GB Download`,
    `Streaming TV`,
    `Streaming Movies`,
    `Streaming Music`
FROM 
    ChurnedCustomers
ORDER BY 
    `Monthly Charge` DESC
LIMIT 5;

-- Query 2: What are the feedback or complaints from  those churned customers

-- What this query says --> The query provides insights into the various reasons customers have churned, 
-- showing both the count of customers for each reason and the percentage of the total churn that each reason represents. 
-- This information is valuable for understanding customer dissatisfaction and identifying specific areas that the company could address to improve retention.

SELECT 
    `Churn Reason`,
    COUNT(*) AS ChurnCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ibm_customer_data WHERE `Churn Label` = 'Yes'), 2) AS PercentageOfChurn
FROM 
    ibm_customer_data
WHERE 
    `Churn Label` = 'Yes'
GROUP BY 
    `Churn Reason`
ORDER BY 
    ChurnCount DESC;
    
-- Query 3: How does the payment method influence churn behavior? 
  
-- The query provides insights into how different payment methods are associated with customer churn. 
-- By showing the total number of customers for each payment method, the number who have churned, and the corresponding churn rate, 
-- the results can help the company identify which payment methods may be linked to higher churn rates. 
-- This information can be valuable for developing targeted retention strategies or improving payment-related services.

SELECT 
    `Payment Method`, 
    COUNT(*) AS Total_Customers, 
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND((SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Churn_Rate_Percent
FROM 
    ibm_customer_data
GROUP BY 
    `Payment Method`
ORDER BY 
    Churn_Rate_Percent DESC;
    
