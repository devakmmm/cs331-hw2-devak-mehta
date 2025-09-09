-- Proposition 1: List the full and preferred names with emails of all employees in the company.
SELECT FullName, PreferredName, EmailAddress
FROM Application.People
WHERE IsEmployee=1;

-- Proposition 2: Find all people who have an email address that does not end with .com.
SELECT PersonID, FullName, EmailAddress 
FROM Application.People
WHERE EmailAddress IS NOT NULL
AND EmailAddress NOT LIKE '%.com';

-- Proposition 3: Show the names of all countries located in Asia.
SELECT CountryName
FROM Application.Countries 
WHERE Region='Asia';

-- Proposition 4: Retrieve the next 10 cities (after skipping the first 20) from a specific state/province.
SELECT CityID, CityName
From Application.Cities 
WHERE StateProvinceID =33
ORDER BY CityID 
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;

-- Proposition 5: Get the details of the purchase order with ID 100.
SELECT 
	PurchaseOrderID,
	SupplierID,OrderDate,
	ExpectedDeliveryDate
FROM Purchasing.PurchaseOrders
WHERE PurchaseOrderID=100;


-- Proposition 6: Find all sales orders that have already been picked by someone.
SELECT OrderID, CustomerID, OrderDate, DeliveryInstructions, ExpectedDeliveryDate
FROM Sales.Orders
WHERE PickedByPersonID is NOT NULL
ORDER BY OrderID
OFFSET 20 ROWS FETCH NEXT 20 ROWS ONLY;


-- Proposition 7: Show the top 10 invoices packed by person with ID 14.
SELECT Top(10) InvoiceID, CustomerID, CustomerPurchaseOrderNumber
FROM Sales.Invoices
WHERE PackedByPersonID =14;

-- Proposition 8: List all orders handled by salesperson 15, ordered from newest to oldest.
SELECT OrderID, CustomerID, OrderDate, DeliveryInstructions, ExpectedDeliveryDate
FROM Sales.Orders
WHERE SalespersonPersonID=15 AND CustomerID=10
ORDER BY OrderDate DESC;

-- Proposition 9: Retrieve stock item transactions linked to invoice 1336.
SELECT StockItemTransactionID, StockItemID, CustomerID
FROM Warehouse.StockItemTransactions
WHERE InvoiceID=1336
ORDER BY StockItemTransactionID ASC;

-- Proposition 10: List distinct customers whose delivery city is either 2111 or 8987.
SELECT DISTINCT CustomerID, CustomerName
FROM Sales.Customers 
WHERE DeliveryCityID in (2111,8987);

-- Proposition 11: Display stock items with their unit price and calculate price including 8% tax.
SELECT 
    StockItemID,
    StockItemName,
    UnitPrice,
    CAST(UnitPrice * 1.08 AS DECIMAL(10,2)) AS PriceWithTax_8pct
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC;


-- Proposition 12: Find suppliers who require payment in less than 8 days.
SELECT 
	SupplierID, 
	SupplierName,
	PhoneNumber
FROM Purchasing.Suppliers 
WHERE PaymentDays <8;

-- Proposition 13: Search for stock items that contain the phrase “Furry animal socks.”
SELECT StockItemID, StockItemName
FROM Warehouse.StockItems
WHERE StockItemName LIKE '%Furry animal socks%';


-- Proposition 14: Categorize customers into high, medium, or low credit limit groups.
SELECT CustomerID, CustomerName, CreditLimit,
       CASE 
           WHEN CreditLimit >= 50000 THEN 'High Credit'
           WHEN CreditLimit >= 10000 THEN 'Medium Credit'
           ELSE 'Low Credit'
       END AS CreditCategory
FROM Sales.Customers;


-- Proposition 15: Show stock items and their suppliers where the size includes grams (g).
SELECT StockItemID, SupplierID
FROM Warehouse.StockItems 
WHERE [Size] LIKE '%g';

-- Proposition 16: Check stock item pricing to make sure it covers costs and meets tax requirements.
--If the recommended retail price is less than the unit price, the item is flagged as RECHECK (retail price is below cost).
--If the difference between retail and unit price is less than 15 and the tax rate is 15%, it’s also flagged as RECHECK (not enough margin to cover the tax).
--Otherwise, the item is considered OK.
SELECT 
    StockItemID, 
    SupplierID,
    RecommendedRetailPrice,
    UnitPrice,
    TAXRATE,
    CASE 
        WHEN RecommendedRetailPrice < UnitPrice THEN 'RECHECK'
        WHEN RecommendedRetailPrice - UnitPrice <15 AND TAXRATE=15 THEN 'RECHECK'
        ELSE 'OK'
    END AS PriceCheck
FROM Warehouse.StockItems;


-- Proposition 17: Identify customers as “NEW” or “TRUSTED” based on their purchase order number.

SELECT Top(20) CustomerID, CustomerPurchaseOrderNumber,
	CASE
		WHEN CustomerPurchaseOrderNumber<5 THEN 'NEW CUSTOMER'
		WHEN CustomerPurchaseOrderNumber>18000 THEN 'TRUSTED CUSTOMER'
	END AS CustomerType
FROM Sales.Orders
WHERE CustomerPurchaseOrderNumber<5
OR CustomerPurchaseOrderNumber>18000
ORDER BY CustomerPurchaseOrderNumber DESC;

-- Proposition 18: Detect Employees who are missing a valid logon name.
SELECT PersonID, FullName, LogonName, IsEmployee,
	CASE
		WHEN LogonName='NO LOGON' THEN 'LOGON NAME REQUIRED'
	END AS [MISSING LOGON]
FROM Application.People
WHERE IsEmployee=1;


-- Proposition 19: Find the single invoice line with the highest profit greater than 1.
SELECT TOP(1)
	InvoiceLineID,
	StockItemID,
	UnitPrice,
	ExtendedPrice,
	LineProfit
FROM Sales.InvoiceLines 
WHERE LineProfit>1
ORDER BY LineProfit DESC;


-- Proposition 20: List customer transactions that are type 3 (payments) AND have a payment method (non-NULL) and Transaction date is 2013-01-05..
SELECT CustomerTransactionID, CustomerID, TransactionTypeID, PaymentMethodID, TransactionAmount, InvoiceID, TransactionDate
FROM Sales.CustomerTransactions 
WHERE PaymentMethodID IS NOT NULL AND TransactionTypeID=3 AND TransactionDate='2013-01-05';

-- Proposition 21: List Top 20 customer transactions with negative amounts.
SELECT TOP(20) CustomerTransactionID, CustomerID, TransactionTypeID, PaymentMethodID,TransactionAmount, InvoiceID, TransactionDate, 
    CASE 
        WHEN TransactionAmount<0 THEN 'NEGATIVE AMOUNT'
    END AS [ALERT]
FROM Sales.CustomerTransactions 
WHERE TransactionAmount<0;














