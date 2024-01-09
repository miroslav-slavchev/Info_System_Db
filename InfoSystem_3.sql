
--3.1.1. Join Tables
SELECT Customers.CustomerID, Customers.FirstName, Customers.LastName, Orders.OrderID, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

--3.1.2. Join Tables
SELECT * FROM Products
INNER JOIN OrderDetail ON Products.ProductID = OrderDetail.ProductID;

--3.1.3. LEF RIGHT FULL JOIN
SELECT * FROM Orders
LEFT OUTER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

SELECT * FROM Orders
RIGHT OUTER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

SELECT * FROM Orders
FULL OUTER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

--3.1.4. JOIN WITH FILTER
SELECT * FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate = '2021/01/12';

--3.1.5. 
SELECT Customers.CustomerID, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderDate > '2021/01/21';

--3.2.1 ADD ROW
INSERT INTO Customers(CustomerID, FIRSTNAME, LASTNAME)
VALUES((SELECT MAX(CustomerID) + 1 FROM Customers), N'Георги', N'Георгиев');

SELECT * FROM Customers;
DELETE FROM Customers WHERE CustomerID = (SELECT MAX(CustomerID) + 1 FROM Customers);

--3.2.2. ADD COL
ALTER TABLE Customers
ADD AddressLine NVARCHAR(100);

ALTER TABLE Customers
DROP COLUMN AddressLine;
