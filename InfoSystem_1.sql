-- 1.1.1. Create the database
USE master;
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'Info_System')
BEGIN
    DROP DATABASE Info_System;
END
CREATE DATABASE Info_System;

USE Info_System;

-- Creating the 'Customers' table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FIRSTNAME NVARCHAR(50),
    LASTNAME NVARCHAR(50)
);

-- Creating the 'Products' table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    NAME NVARCHAR(50),
    UNITPRICE MONEY
);

-- Creating the 'Orders' table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetail (
    OrderID INT,
    ProductID INT,
    QTY INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

--1.1.2. Insert Data

GO
DROP PROCEDURE IF EXISTS dbo.InsertOrRestoreCustomers;
GO
CREATE PROCEDURE  InsertOrRestoreCustomers
AS
BEGIN
	--Insert Customers
	INSERT INTO Customers(CustomerID, FIRSTNAME, LASTNAME)
	VALUES(111, N'Алекс', N'Стоянов');

	INSERT INTO Customers(CustomerID, FIRSTNAME, LASTNAME)
	VALUES(112, N'Иван', N'Иванов');
END;
GO

DROP PROCEDURE IF EXISTS dbo.InsertOrRestoreProducts;
GO
CREATE PROCEDURE  InsertOrRestoreProducts
AS
BEGIN
	--Insert Products
	INSERT INTO Products(ProductID, NAME, UNITPRICE)
	VALUES(11, N'Хартия', 8);

	INSERT INTO Products(ProductID, NAME, UNITPRICE)
	VALUES(12, N'Моливи', 5);

	INSERT INTO Products(ProductID, NAME, UNITPRICE)
	VALUES(13, N'Мастило', 9);

	INSERT INTO Products(ProductID, NAME, UNITPRICE)
	VALUES(14, N'Дискети', 6);

	INSERT INTO Products(ProductID, NAME, UNITPRICE)
	VALUES(15, N'CD ROM', 7);

	INSERT INTO Products(ProductID, NAME, UNITPRICE)
VALUES(23, N'Батерии', 10);
END;
GO

DROP PROCEDURE IF EXISTS dbo.InsertOrRestoreOrders;
GO
CREATE PROCEDURE  InsertOrRestoreOrders
AS
BEGIN
	-- Insert Orders
	INSERT INTO Orders(OrderID, OrderDate, CustomerID)
	VALUES(23, '2021/01/12', 111);

	INSERT INTO Orders(OrderID, OrderDate, CustomerID)
	VALUES(28, '2021/01/12', 112);

	INSERT INTO Orders(OrderID, OrderDate, CustomerID)
	VALUES(29, '2021/01/13', 111);
END;

GO
DROP PROCEDURE IF EXISTS dbo.InsertOrRestoreOrderDetails;
GO
CREATE PROCEDURE  InsertOrRestoreOrderDetails
AS
BEGIN
	--Insert OrderDetails
	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(23, 12, 10);

	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(23, 14, 5);

	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(23, 15, 7);

	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(23, 23, 3);

	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(28, 11, 2);

	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(28, 14, 8);

	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(29, 13, 2);

	INSERT INTO OrderDetail(OrderID, ProductID, QTY)
	VALUES(29, 14, 2);
END;
GO
DROP PROCEDURE IF EXISTS dbo.InsertOrRestoreDatabase;
GO
CREATE PROCEDURE  InsertOrRestoreDatabase
AS
BEGIN
	DELETE FROM OrderDetail;
	DELETE FROM Orders;
	DELETE FROM Products;
	DELETE FROM Customers;
	EXEC InsertOrRestoreCustomers;
	EXEC InsertOrRestoreProducts;
	EXEC InsertOrRestoreOrders;
	EXEC InsertOrRestoreOrderDetails;
END;
GO
EXEC InsertOrRestoreDatabase;

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetail;

GO
-- 1.1.3. Add Column to Table
ALTER TABLE Customers
ADD Company NVARCHAR(50);

-- 1.1.3. UPDATE Customers Company
UPDATE Customers
SET Company ='Vivacom' 
WHERE CustomerID = 111;

UPDATE Customers
SET Company ='Yettel' 
WHERE CustomerID = 112;

-- 1.1.4. Change Price
UPDATE Products
SET UNITPRICE = 2
WHERE ProductID = 14;

-- 1.1.5. Customers VIEW
GO
CREATE VIEW CustomersView AS
SELECT FIRSTNAME, LASTNAME
FROM Customers;
GO

SELECT * FROM CustomersView;

--DROP VIEW CustomersView;
GO

-- 1.1.6. Customers INDEX
CREATE INDEX idx_firstname_lastname ON Customers (FIRSTNAME, LASTNAME);

SELECT * FROM Customers WHERE FIRSTNAME = N'Алекс' AND LASTNAME = N'Стоянов';

--DROP INDEX idx_firstname_lastname ON Customers;

-- 1.1.7. DELETE Customer 112 (NOT POSSIBLE IF THE RELATED RECORDS ARE NOT DELETED FIRST)
DECLARE @CustomeIdToDelete INT = 112;
DELETE FROM OrderDetail WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID = @CustomeIdToDelete);
DELETE FROM Orders WHERE CustomerID = @CustomeIdToDelete;
DELETE FROM Customers WHERE CustomerID = @CustomeIdToDelete;

-- 1.1.8. Remove Table Column
ALTER TABLE Customers
DROP COLUMN Company;

-- 1.2.1. SELECT Ivan Ordered Items
SELECT * FROM Products WHERE ProductID IN (SELECT ProductID FROM OrderDetail WHERE OrderID = 23);
SELECT SUM (UNITPRICE) AS ALL_ITEMS_SUM FROM Products WHERE ProductID IN (SELECT ProductID FROM OrderDetail WHERE OrderID = 23);

-- 1.2.2. SELECT DISTINCT
SELECT DISTINCT OrderDate FROM Orders;

-- 1.2.3. HAVING
SELECT COUNT(ProductID), UNITPRICE, NAME
FROM Products
GROUP BY UNITPRICE, NAME
HAVING UNITPRICE > 5
ORDER BY UNITPRICE DESC;
