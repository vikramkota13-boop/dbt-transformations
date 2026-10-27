{{ config (
    materialized='table'
)}}

WITH CTE_Customers AS (
    SELECT 
    ID AS CustomerID,
    First_name,
    Last_name
    FROM 
    raw.jaffle_shop.customers
),

CTE_Orders AS (
    SELECT 
    ID AS OrderID,
    USER_ID AS CustomerID,
    ORDER_DATE,
    STATUS
    FROM raw.jaffle_shop.orders
),

CTE_Customer_Orders AS (
    SELECT 
    CustomerID,
    MIN(Order_date) AS FirstOrderDate,
    MAX(Order_date) AS RecentOrderDate,
    COUNT(1) AS TotalOrders
    FROM CTE_Orders
    GROUP BY 1
),

CTE_Final AS (
    select 
    customers.CustomerID,
    customers.First_name,
    customers.Last_name,
    customer_orders.FirstOrderDate,
    customer_orders.RecentOrderDate,
    coalesce(customer_orders.TotalOrders, 0) as NumberOfOrders
    from CTE_Customers as customers 
    left join CTE_Customer_Orders as customer_orders using (CustomerID)
)

select * from cte_final