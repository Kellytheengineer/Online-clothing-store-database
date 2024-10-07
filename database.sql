CREATE DATABASE Clothing_Store2;
USE Clothing_Store2;
DROP DATABASE Clothing_Store2;

DROP TABLE Customers;
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
 Name VARCHAR(100), 
 Email VARCHAR(50)UNIQUE,
 Phone VARCHAR(20),
 Address VARCHAR(100)
 );

INSERT INTO Customers (CustomerID, Name, Email, Phone, Address) VALUES
(1001, 'John Doe', 'john.doe@email.com', '555-1234', '123 Main St, London, UK'),
(1002, 'Jane Smith', 'jane.smith@email.com', '555-5678', '456 Oak Ave, Bath, UK'),
(1003, 'Bob Johnson', 'bob.johnson@email.com', '555-9876', '789 Pine Rd, Bristol, UK'),
(1004, 'Alice Brown', 'alice.brown@email.com', '555-4321', '321 Elm St, Birmingham, UK'),
(1005, 'Charlie Wilson', 'charlie.wilson@email.com', '555-8765', '654 Maple Dr, Liverpool, UK');

SELECT * FROM Customers;


CREATE TABLE Categories (
   CategoryID INT PRIMARY KEY, 
   CategoryName VARCHAR(100)
);

INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'T-Shirts'),
(2, 'Jeans'),
(3, 'Dresses'),
(4, 'Jackets'),
(5, 'Shoes');

SELECT * FROM Categories;

DROP TABLE Products;
CREATE TABLE Products (
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
CategoryID INT,
Price DECIMAL(10, 2),
StockQuantity INT,
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
 
#Price: Using DECIMAL(10, 2) allows for two decimal places for currency values.
#StockQuantity: An integer to represent how many items are in stock.
INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity) VALUES
(101, 'Classic White Tee', 1, 19.99, 100),
(102, 'Slim Fit Jeans', 2, 49.99, 75),
(103, 'Floral Summer Dress', 3, 39.99, 50),
(104, 'Leather Biker Jacket', 4, 99.99, 25),
(105, 'Running Sneakers', 5, 79.99, 60),
(106, 'Graphic Print Tee', 1, 24.99, 80),
(107, 'High-Waisted Jeans', 2, 54.99, 70),
(108, 'Cocktail Dress', 3, 69.99, 40),
(109, 'Denim Jacket', 4, 59.99, 45),
(110, 'Casual Loafers', 5, 64.99, 55);

SELECT * FROM Products;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,                               
    CustomerID INT,              
    OrderDate DATE, 
    TotalAmount DECIMAL(10, 2),           
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(10001, 1001, '2023-01-15', 89.97),
(10002, 1002, '2023-02-01', 149.98),
(10003, 1003, '2023-02-15', 119.98),
(10004, 1004, '2023-03-01', 189.97),
(10005, 1005, '2023-03-15', 144.98),
(10006, 1001, '2023-04-01', 129.98),
(10007, 1003, '2023-04-15', 159.97),
(10008, 1002, '2023-05-01', 204.97),
(10009, 1005, '2023-05-15', 139.98),
(10010, 1004, '2023-06-01', 174.98);

SELECT * FROM Orders;

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY, 
    OrderID INT, -- FK
	ProductID  INT,  #FK            
    Quantity INT, 
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity) VALUES
(1, 10001, 101, 2),
(2, 10001, 105, 1),
(3, 10002, 102, 1),
(4, 10002, 104, 1),
(5, 10003, 103, 2),
(6, 10003, 106, 1),
(7, 10004, 107, 1),
(8, 10004, 108, 1),
(9, 10004, 110, 1),
(10, 10005, 109, 1),
(11, 10005, 101, 1),
(12, 10005, 105, 1),
(13, 10006, 102, 2),
(14, 10006, 106, 1),
(15, 10007, 103, 1),
(16, 10007, 104, 1),
(17, 10007, 101, 1),
(18, 10008, 108, 2),
(19, 10008, 110, 1),
(20, 10009, 107, 1),
(21, 10009, 109, 1),
(22, 10009, 105, 1),
(23, 10010, 102, 1),
(24, 10010, 103, 1),
(25, 10010, 106, 2);

SELECT * FROM OrderItems;