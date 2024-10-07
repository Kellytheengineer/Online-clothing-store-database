USE Clothing_Store2;

-- Diffrent join views 
CREATE VIEW LessDetailOrderIDCustomer AS
SELECT 
    oi.OrderItemID, 
    o.OrderID, 
    oi.ProductID, 
    oi.Quantity, 
    o.CustomerID,
    o.OrderDate,
    o.TotalAmount
FROM OrderItems oi
LEFT JOIN Orders o
ON oi.OrderID = o.OrderID;

SELECT * FROM LessDetailOrderIDCustomer;

CREATE VIEW OrderIDandCustomerView AS
SELECT 
    oi.OrderItemID, 
    o.OrderID, 
    oi.ProductID, 
    oi.Quantity, 
    o.CustomerID,
    o.OrderDate,
    o.TotalAmount, 
    c.Name,
    c.Email,
    c.Phone,
    c.Address
FROM OrderItems oi 
RIGHT JOIN Orders o ON oi.OrderID = o.OrderID 
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;

SELECT * FROM OrderIDandCustomerView;

CREATE VIEW OrderDetailsView AS
SELECT 
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.Name AS CustomerName,
    c.Email AS CustomerEmail,
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    oi.Quantity,
    p.Price AS UnitPrice,
    (oi.Quantity * p.Price) AS ItemTotal
FROM 
    Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID;

SELECT * FROM OrderDetailsView;

SELECT * FROM OrderDetailsView LIMIT 10;

 -- stored function 
-- Creating the function
DELIMITER //
CREATE FUNCTION CalculateDiscount(total DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discounted_total DECIMAL(10,2);
    IF total >= 150 THEN
        SET discounted_total = total * 0.9;
    ELSE
        SET discounted_total = total;
    END IF;
    RETURN discounted_total;
END //
DELIMITER ;

SELECT CalculateDiscount(200.00) AS DiscountedTotal;

-- How would i select all the items and give them all a discount ?
-- Using the function in a query
SELECT 
    o.OrderID,
    c.CustomerID,
    c.Name AS CustomerName,
    GROUP_CONCAT(p.ProductName SEPARATOR ', ') AS Products, -- take items and put them in a list 
    OrderTotals.ItemTotal AS OriginalTotal,
    CASE
        WHEN OrderTotals.ItemTotal >= 150 THEN OrderTotals.ItemTotal * 0.9  -- 10% discount
        ELSE OrderTotals.ItemTotal  -- No change
    END AS DiscountedTotal,
    CASE
        WHEN OrderTotals.ItemTotal >= 150 THEN OrderTotals.ItemTotal * 0.1  -- Amount saved
        ELSE 0  -- No savings
    END AS AmountSaved,
    CASE
        WHEN OrderTotals.ItemTotal >= 150 THEN '10% Applied' -- Discount applied message 
        ELSE 'No Discount' -- no discount message 
    END AS DiscountStatus
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    OrderItems oi ON o.OrderID = oi.OrderID
JOIN 
    Products p ON oi.ProductID = p.ProductID
JOIN 
    (SELECT 
        OrderID,
        SUM(Quantity * Price) AS ItemTotal
    FROM 
        OrderItems
    JOIN 
        Products ON OrderItems.ProductID = Products.ProductID
    GROUP BY 
        OrderID
    ) AS OrderTotals ON o.OrderID = OrderTotals.OrderID
GROUP BY 
    o.OrderID, c.CustomerID, c.Name, OrderTotals.ItemTotal
ORDER BY 
    o.OrderID;