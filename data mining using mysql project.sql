-- Beginner Queries.
-- Define meta data in mysql workbench or any other SQL tool
SELECT * FROM online_retail.onlineretail;
              -- 1. What is the distribution of order values across all customers in the dataset?
SELECT count(c.Quantity),c.CustomerID
FROM online_retail.onlineretail as c
group by CustomerID
order by count(Quantity) ;
			-- 2.   How many unique products has each customer purchased?
SELECT CustomerID, COUNT(DISTINCT Description) AS UniqueProductsCount
FROM online_retail.onlineretail as c
GROUP BY CustomerID;
			-- 3.    Which customers have only made a single purchase from the company?
SELECT CustomerID
FROM online_retail.onlineretail as c
GROUP BY CustomerID
HAVING COUNT(DISTINCT ï»¿InvoiceNo) = 1;
			-- 4. Which products are most commonly purchased together by customers in the dataset?
SELECT GROUP_CONCAT(DISTINCT Description ORDER BY Description ASC) AS ProductCombination,
       COUNT(*) AS Frequency
FROM online_retail.onlineretail as c
GROUP BY ï»¿InvoiceNo
HAVING COUNT(*) > 1
ORDER BY Frequency DESC
LIMIT 10;
                                   --  Advance
                    -- 1.      Customer Segmentation by Purchase Frequency
-- Group customers into segments based on their purchase frequency, such as high, medium, and low frequency customers. This can help you identify your most loyal customers and those who need more attention.
SELECT CustomerID,
       CASE
           WHEN TotalPurchases <= 3 THEN 'Low Frequency'
           WHEN TotalPurchases <= 6 THEN 'Medium Frequency'
           ELSE 'High Frequency'
       END AS PurchaseSegment
FROM (
    SELECT CustomerID, COUNT(DISTINCT ï»¿InvoiceNo) AS TotalPurchases
    FROM online_retail.onlineretail as c 
    GROUP BY CustomerID
) AS PurchaseCounts;
                        -- 2. Average Order Value by Country

-- Calculate the average order value for each country to identify where your most valuable customers are located.
SELECT Country,

       AVG(TotalOrderValue) AS AverageOrderValue
FROM (
    SELECT Country, ï»¿InvoiceNo, SUM(Quantity * UnitPrice) AS TotalOrderValue
    FROM online_retail.onlineretail as c 
    GROUP BY Country, ï»¿InvoiceNo
) AS OrderTotals
GROUP BY Country
ORDER BY AverageOrderValue DESC;
                        -- 3. Customer Churn Analysis
-- Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn
SELECT CustomerID
FROM online_retail.onlineretail as c 
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING MAX(ï»¿InvoiceNo) < DATE_SUB(NOW(), INTERVAL 6 MONTH);
                        -- 4. Product Affinity Analysis
-- Determine which products are often purchased together by calculating the correlation between product purchases.
SELECT p1.Description AS Product1,
       p2.Description AS Product2,
       COUNT(DISTINCT o1.ï»¿InvoiceNo) AS CoOccurrenceCount
FROM online_retail.onlineretail as o1
JOIN online_retail.onlineretail as o2 ON o1.ï»¿InvoiceNo = o2.ï»¿InvoiceNo AND o1.Description < o2.Description
JOIN online_retail.onlineretail as p1 ON o1.ï»¿InvoiceNo = p1.ï»¿InvoiceNo AND p1.Description = 'Product1Description'
JOIN online_retail.onlineretail as p2 ON o2.ï»¿InvoiceNo = p2.ï»¿InvoiceNo AND p2.Description = 'Product2Description'
GROUP BY p1.Description, p2.Description
ORDER BY CoOccurrenceCount DESC;

                          -- 5. Time-based Analysis
          -- Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.
SELECT YEAR(InvoiceDate) AS SalesYear,
       MONTH(InvoiceDate) AS SalesMonth,
       SUM(TotalPrice) AS TotalSales
FROM (
    SELECT InvoiceDate, SUM(Quantity * UnitPrice) AS TotalPrice
    FROM online_retail.onlineretail as c 
    GROUP BY InvoiceDate
) AS InvoiceTotals
GROUP BY SalesYear, SalesMonth
ORDER BY SalesYear, SalesMonth;





