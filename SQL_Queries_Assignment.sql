--1)List of all customers--
SELECT * FROM Sales.Customer;


--2)list of all customers where company name ending with N 
SELECT c.CustomerID, s.Name AS CompanyName
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';


--3)List of all customers who live in berlin and london
SELECT * FROM Sales.Customer c
JOIN Person.Address a ON c.CustomerID = a.AddressID
WHERE City IN ('Berlin', 'London');


--4)List of all customers who live in UK and US
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName, cr.Name AS Country
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United States');


--5)List of all Products sorted by product name
SELECT * FROM Production.Product
ORDER BY Name;


--6)List of all Products where Products starting with 'A'
SELECT * FROM Production.Product
WHERE Name LIKE 'A%';


--7)list of customers who ever placed an order
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader o ON c.CustomerID = o.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID;


--8)list of Customers who live in London and have brought chai
SELECT DISTINCT p.FirstName, p.LastName
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product pr ON d.ProductID = pr.ProductID
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
JOIN Person.Address a ON c.CustomerID = a.AddressID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE pr.Name = 'Chai' AND a.City = 'London';


--9)List of customers who never place an order
SELECT * FROM Sales.Customer c
WHERE NOT EXISTS (
    SELECT 1 FROM Sales.SalesOrderHeader o WHERE o.CustomerID = c.CustomerID
);


--10)list of customers who ordered tofu
SELECT DISTINCT p.FirstName, p.LastName
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product pr ON d.ProductID = pr.ProductID
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE pr.Name = 'Tofu';


--11)Details of first order of the system 
SELECT TOP 1 * FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;


--12)find the details of most expensive order date
SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;


--13)for each order get the orderID and Average quantity of items in that order 
SELECT SalesOrderID, AVG(OrderQty) AS AvgQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;


--14)for each order get the orderID,minimum quantity and maximun quantity for that order
SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;


--15)get a list of all managers and total number of employees who report to them
SELECT 
    mgr.BusinessEntityID AS ManagerID,
    p.FirstName + ' ' + p.LastName AS ManagerName,
    COUNT(emp.BusinessEntityID) AS NumberOfEmployees
FROM HumanResources.Employee emp
JOIN HumanResources.Employee mgr
    ON emp.OrganizationNode.GetAncestor(1) = mgr.OrganizationNode
JOIN Person.Person p
    ON mgr.BusinessEntityID = p.BusinessEntityID
GROUP BY 
    mgr.BusinessEntityID,
    p.FirstName,
    p.LastName
ORDER BY NumberOfEmployees DESC;


--16)Orders with total quantity > 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;


--17)List of all Orders placed on or after 1996-12-31
SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';


--18)List of all orders shipped to canada
SELECT * FROM Sales.SalesOrderHeader h
JOIN Sales.SalesTerritory t ON h.TerritoryID = t.TerritoryID
WHERE t.CountryRegionCode = 'CA';


--19)List of all orders with order total >200
SELECT SalesOrderID, SUM(OrderQty) AS TotalQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 200;


--20)List of Countries and sales made in each country
SELECT CountryRegionCode, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesTerritory t ON h.TerritoryID = t.TerritoryID
GROUP BY CountryRegionCode;


--21)List of customer ContactName and numbers of orders they placed 
SELECT p.FirstName, p.LastName, COUNT(*) AS OrdersCount
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName;


--22)List of customer ContactName who have placed more than 3 orders
SELECT p.FirstName, p.LastName, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(*) > 3;


--23)List of discontinued products which were ordered between 1/1/1997 to 1/1/1998
SELECT * FROM Production.Product
WHERE DiscontinuedDate BETWEEN '1997-01-01' AND '1998-01-01';


--24)List of employee firstname,lastName,supervisor FirstName,LastName
SELECT 
    e.BusinessEntityID AS EmployeeID,
    pe.FirstName AS EmployeeFirstName,
    pe.LastName AS EmployeeLastName,
    ps.FirstName AS SupervisorFirstName,
    ps.LastName AS SupervisorLastName
FROM HumanResources.Employee e
JOIN Person.Person pe ON e.BusinessEntityID = pe.BusinessEntityID
JOIN HumanResources.Employee s 
    ON e.OrganizationNode.GetAncestor(1) = s.OrganizationNode
JOIN Person.Person ps ON s.BusinessEntityID = ps.BusinessEntityID
ORDER BY SupervisorLastName, EmployeeLastName;
 

--25)List of employees id and total sale conducted by employee
SELECT SalesPersonID, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;


--26)List of employees whose FirstName contains character a
SELECT * FROM Person.Person
WHERE FirstName LIKE '%a%';


--27)List of managers who have more than four people reporting to them
SELECT e2.BusinessEntityID AS ManagerID, COUNT(e1.BusinessEntityID) AS ReportCount
FROM HumanResources.Employee e1
JOIN HumanResources.Employee e2 ON e1.OrganizationNode.GetAncestor(1) = e2.OrganizationNode
GROUP BY e2.BusinessEntityID
HAVING COUNT(e1.BusinessEntityID) > 4;


--28)List of Orders and ProductNames
SELECT h.SalesOrderID, p.Name
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID;


--29)List of orders place by the best customer
SELECT TOP 1 c.CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;


--30)List of orders placed by customers who do not have a fax number
SELECT DISTINCT soh.SalesOrderID, soh.OrderDate, p.FirstName, p.LastName
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
     AND pp.PhoneNumberTypeID = (
         SELECT PhoneNumberTypeID FROM Person.PhoneNumberType WHERE Name = 'Fax'
     )
WHERE pp.BusinessEntityID IS NULL;


--31)List of postal codes where the product tofu was shipped
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
JOIN Person.Address a ON h.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';


--32)List of product names that were shipped to france
SELECT DISTINCT p.Name
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
JOIN Sales.SalesTerritory t ON h.TerritoryID = t.TerritoryID
WHERE t.CountryRegionCode = 'FR';


--33)List of ProductNames and Categories for the supplier 'Specialty Biscuits,Ltd'
SELECT p.Name AS ProductName, pc.Name AS Category
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';


--34)List of products that were never Ordered
SELECT p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
WHERE d.ProductID IS NULL;


--35)Products with units in stock < 10 and units on order = 0
SELECT p.Name
FROM Production.Product p
JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
WHERE pi.Quantity < 10;


--36)List of top 10 countries by sales
SELECT TOP 10 t.CountryRegionCode, SUM(h.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesTerritory t ON h.TerritoryID = t.TerritoryID
GROUP BY t.CountryRegionCode
ORDER BY TotalSales DESC;


--37)Number of orders each employee took for customers with IDs between A and AO
SELECT e.BusinessEntityID AS EmployeeID, COUNT(h.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesPerson sp ON h.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE p.LastName BETWEEN 'A' AND 'AO'
GROUP BY e.BusinessEntityID;


--38)Order date of the most expensive order
SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;


--39)Product name and total revenue from that product
SELECT p.Name, SUM(d.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail d
JOIN Production.Product p ON d.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;


--40)Supplier ID and number of products offered
SELECT v.BusinessEntityID AS SupplierID, COUNT(pv.ProductID) AS ProductCount
FROM Purchasing.ProductVendor pv
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
GROUP BY v.BusinessEntityID;


--41) Top 10 customers by business (total purchase amount)
SELECT TOP 10 c.CustomerID, SUM(h.TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;


--42)What is the total revenue of the company
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;

