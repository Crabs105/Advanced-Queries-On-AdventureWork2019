
--Rate record and their average for all employeee in the HumanResources.EmployeePayHistory
--Practice on the window function in SQL Server


Select FirstName, LastName , JobTitle ,Rate, AverageRate= AVG(Rate) over() 
from HumanResources.EmployeePayHistory AS HREPH
inner join Person.Person as PP on PP.BusinessEntityID=HREPH.BusinessEntityID
INNER join HumanResources.Employee AS HRE on HRE.BusinessEntityID=HREPH.BusinessEntityID

--Same Query but with the maximun

Select FirstName, LastName , JobTitle ,Rate, AverageRate= AVG(Rate) over(), MaximunRate=MAX(Rate) over()
from HumanResources.EmployeePayHistory AS HREPH
inner join Person.Person as PP on PP.BusinessEntityID=HREPH.BusinessEntityID
INNER join HumanResources.Employee AS HRE on HRE.BusinessEntityID=HREPH.BusinessEntityID

-- Show the different between the employee pay rate and the average rate

Select FirstName, LastName , JobTitle ,Rate,
AverageRate= AVG(Rate) over(), 
MaximunRate=MAX(Rate) over(),
RateDifference=Rate-AVG(Rate) over()
from HumanResources.EmployeePayHistory AS HREPH
inner join Person.Person as PP on PP.BusinessEntityID=HREPH.BusinessEntityID
INNER join HumanResources.Employee AS HRE on HRE.BusinessEntityID=HREPH.BusinessEntityID

--ADD a performance rate 

Select FirstName, LastName , JobTitle ,Rate,
AverageRate= AVG(Rate) over(), 
MaximunRate=MAX(Rate) over(),
RateDifference=Rate-AVG(Rate) over(),
PerformanceEvaluation= (Rate/MAX(Rate) over ())*100
from HumanResources.EmployeePayHistory AS HREPH
inner join Person.Person as PP on PP.BusinessEntityID=HREPH.BusinessEntityID
INNER join HumanResources.Employee AS HRE on HRE.BusinessEntityID=HREPH.BusinessEntityID

-- Let Us Understand How partition Work

Select PP.Name as ProductName,ListPrice, PS.Name as ProductSubcategory, PC.Name as ProductCategory 

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

-- Determine the Average Price

Select PP.Name as ProductName,ListPrice, PS.Name as ProductSubcategory, PC.Name as ProductCategory,
AveragePrice= AVG(ListPrice) over (Partition by PC.Name)

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

--Determine The average Price by Category and SubCategory 

Select PP.Name as ProductName,ListPrice, PS.Name as ProductSubcategory, PC.Name as ProductCategory,
AveragePrice= AVG(ListPrice) over (Partition by PC.Name),
AvgPriceByCategoryAndSubcategory=AVG(ListPrice) over(Partition by PC.Name , PS.Name)

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

-- Determine the difference between the price and the average

Select PP.Name as ProductName,ListPrice, PS.Name as ProductSubcategory, PC.Name as ProductCategory,
AveragePrice= AVG(ListPrice) over (Partition by PC.Name),
AvgPriceByCategoryAndSubcategory=AVG(ListPrice) over(Partition by PC.Name , PS.Name),
DiffBetweenAvgAndPrice=ListPrice-AVG(ListPrice) over(Partition by PC.Name)

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

--Let explore the ROW_NUMBER ()

Select PP.Name as ProductName,ListPrice, 
PS.Name as ProductSubcategory, 
PC.Name as ProductCategory,
PriceRank=ROW_NUMBER() over ( order by ListPrice DESC )

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

-- Find the Ranking based on Category

Select PP.Name as ProductName,ListPrice, 
PS.Name as ProductSubcategory, 
PC.Name as ProductCategory,
PriceRank=ROW_NUMBER() over ( order by ListPrice DESC ),
PriceRankCategory= ROW_NUMBER() over (Partition by PC.Name order by ListPrice DESC)

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

-- Enhance the previous query with a Case Statement 

Select PP.Name as ProductName,ListPrice, 
PS.Name as ProductSubcategory, 
PC.Name as ProductCategory,
PriceRank=ROW_NUMBER() over ( order by ListPrice DESC ),
PriceRankCategory= ROW_NUMBER() over (Partition by PC.Name order by ListPrice DESC),
Top5Price = CASE WHEN  ROW_NUMBER() over (Partition by PC.Name order by ListPrice DESC) <= 5 THEN 'YES'
ELSE 'NO' END 

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID


-- Let be specific in the ranking  by Using Rank and Dense_Rank
--With Rank

Select PP.Name as ProductName,ListPrice, 
PS.Name as ProductSubcategory, 
PC.Name as ProductCategory,
PriceRank=ROW_NUMBER() over ( order by ListPrice DESC ),
PriceRankCategory= ROW_NUMBER() over (Partition by PC.Name order by ListPrice DESC),
CategoryPriceRankWithRank=Rank () over (Partition by PC.Name order by ListPrice DESC),
Top5Price = CASE WHEN  ROW_NUMBER() over (Partition by PC.Name order by ListPrice DESC) <= 5 THEN 'YES'
ELSE 'NO' END 

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

-- With Dense_Rank

Select PP.Name as ProductName,ListPrice, 
PS.Name as ProductSubcategory, 
PC.Name as ProductCategory,
PriceRank=ROW_NUMBER() over ( order by ListPrice DESC ),
PriceRankCategory= ROW_NUMBER() over (Partition by PC.Name order by ListPrice DESC),
CategoryPriceRankWithRank=Rank () over (Partition by PC.Name order by ListPrice DESC),
CategoryPriceRankWithDense_Rank=Dense_Rank () over (Partition by PC.Name order by ListPrice DESC),
Top5Price = CASE WHEN  ROW_NUMBER() over (Partition by PC.Name order by ListPrice DESC) <= 5 THEN 'YES'
ELSE 'NO' END 

from AdventureWorks2019.Production.Product as pp
inner join Production.ProductSubcategory AS PS on ps.ProductSubcategoryID=pp.ProductSubcategoryID
inner join Production.ProductCategory AS PC on pc.ProductCategoryID=PS.ProductCategoryID

-- Pratice on Lead  Function And Lag Function

Select PPOH.PurchaseOrderID as PurchaseOrderID  ,
PPOH.OrderDate as OrderDate,
PPOH.TotalDue as TotalDue , PV.Name as VendorName
from AdventureWorks2019.Purchasing.PurchaseOrderHeader as PPOH
inner join Purchasing.Vendor as PV on PV.BusinessEntityID =PPOH.VendorID

Where Year(PPOH.OrderDate) >= 2013 and PPOH.TotalDue >500


-- Determine the Previous Order

Select PPOH.PurchaseOrderID as PurchaseOrderID  ,
PPOH.OrderDate as OrderDate,
PPOH.TotalDue as TotalDue , 
--PreOrderFromVendorAmt = LEAD(PPOH.TotalDue) over(Partition by PPOH.VendorID order by OrderDate),
PreOrderFromVendorAmt = LAG(PPOH.TotalDue) over(Partition by PPOH.VendorID order by OrderDate),
PV.Name as VendorName
from AdventureWorks2019.Purchasing.PurchaseOrderHeader as PPOH
inner join Purchasing.Vendor as PV on PV.BusinessEntityID =PPOH.VendorID

Where Year(PPOH.OrderDate) >= 2013 and PPOH.TotalDue >500

-- Find the Next Order Made


Select PPOH.PurchaseOrderID as PurchaseOrderID  ,
PPOH.OrderDate as OrderDate,
PPOH.TotalDue as TotalDue , 
PreOrderFromVendorAmt = LAG(PPOH.TotalDue) over(Partition by PPOH.VendorID order by OrderDate),
PV.Name as VendorName,
NextOrderByEmployeeVendor = LEAD (PV.Name) over(Partition by PPOH.EmployeeID order by OrderDate)
from AdventureWorks2019.Purchasing.PurchaseOrderHeader as PPOH
inner join Purchasing.Vendor as PV on PV.BusinessEntityID =PPOH.VendorID

Where Year(PPOH.OrderDate) >= 2013 and PPOH.TotalDue >500

Order By PPOH.EmployeeID,PPOH.OrderDate

-- Find the Next Order Made if you skip 2 rows

Select PPOH.PurchaseOrderID as PurchaseOrderID  ,
PPOH.OrderDate as OrderDate,
PPOH.TotalDue as TotalDue , 
PreOrderFromVendorAmt = LAG(PPOH.TotalDue) over(Partition by PPOH.VendorID order by OrderDate),
PV.Name as VendorName,
NextOrderByEmployeeVendor = LEAD (PV.Name,2) over(Partition by PPOH.EmployeeID order by OrderDate)
from AdventureWorks2019.Purchasing.PurchaseOrderHeader as PPOH
inner join Purchasing.Vendor as PV on PV.BusinessEntityID =PPOH.VendorID

Where Year(PPOH.OrderDate) >= 2013 and PPOH.TotalDue >500

Order By PPOH.EmployeeID,PPOH.OrderDate

--## Practice on the SubQueries
-- Determine the most expencive Orders

Select * from
( Select PurchaseOrderID,VendorID,
OrderDate,TaxAmt,
Freight,TotalDue,
--PurchaseRanking= Rank() over( Partition by VendorID ORDER BY TotalDue desc),
PurchaseRanking=Row_Number () over (Partition by VendorID Order by TotalDue desc)
from  Purchasing.PurchaseOrderHeader)   D

where PurchaseRanking <=3

--Using Dense function

Select * from
( Select PurchaseOrderID,VendorID,
OrderDate,TaxAmt,
Freight,TotalDue,
--PurchaseRanking= Rank() over( Partition by VendorID ORDER BY TotalDue desc),
PurchaseRanking=Dense_Rank () over (Partition by VendorID Order by TotalDue desc)
from  Purchasing.PurchaseOrderHeader)   D

where PurchaseRanking <=3

Select BusinessEntityID,
JobTitle, VacationHours ,
MaxHours=(Select MaxVacationHours=Max(VacationHours) from HumanResources.Employee)
from HumanResources.Employee


Select BusinessEntityID,
JobTitle, VacationHours ,
MaxHours=(Select MaxVacationHours=Max(VacationHours) from HumanResources.Employee),
Percen= ((VacationHours*1.0)/(Select MaxVacationHours=Max(VacationHours) from HumanResources.Employee))* 100
from HumanResources.Employee

Select BusinessEntityID,
JobTitle, VacationHours ,
MaxHours=(Select MaxVacationHours=Max(VacationHours) from HumanResources.Employee),
Percen= ((VacationHours*1.0)/(Select MaxVacationHours=Max(VacationHours) from HumanResources.Employee))
from HumanResources.Employee
Where ((VacationHours*1.0)/(Select MaxVacationHours=Max(VacationHours) from HumanResources.Employee)) > =0.8

--##  More Practice on Subqueries

Select PurchaseOrderID,
VendorID,
OrderDate,
TotalDue,
NonRejectedItems= (
Select Count(*)
from Purchasing.PurchaseOrderDetail As D
WHERE RejectedQty =0
AND PurchaseOrderHeader.PurchaseOrderID=D.PurchaseOrderID
) from Purchasing.PurchaseOrderHeader



Select RejectedQty
from Purchasing.PurchaseOrderDetail
WHERE RejectedQty =0

Select * from Purchasing.PurchaseOrderDetail

Select * from Purchasing.ProductVendor

Select * from Purchasing.PurchaseOrderHeader

Select PurchaseOrderID, MAX(UnitPrice) as Highest_Price from Purchasing.PurchaseOrderDetail
group by PurchaseOrderID

Select PurchaseOrderID,
VendorID,
OrderDate,
TotalDue,
NonRejectedItems= (
Select Count(*)
from Purchasing.PurchaseOrderDetail As D
WHERE RejectedQty =0
AND PurchaseOrderHeader.PurchaseOrderID=D.PurchaseOrderID),
MostExpensiveItem= (
Select MAX(UnitPrice) as Highest_Price from Purchasing.PurchaseOrderDetail
where Purchasing.PurchaseOrderHeader.PurchaseOrderID=PurchaseOrderDetail.PurchaseOrderID
group by PurchaseOrderID
) from Purchasing.PurchaseOrderHeader 

--Using The Exist clause

Select PurchaseOrderID,
       OrderDate,
	   SubTotal,
	   TaxAmt
	   from Purchasing.PurchaseOrderHeader
	   where EXISTS (
	   Select 1 from Purchasing.PurchaseOrderDetail
where OrderQty>500 AND PurchaseOrderDetail.PurchaseOrderID=PurchaseOrderHeader.PurchaseOrderID
	   )

	   ORDER BY 1


	   Select PurchaseOrderID,
       OrderDate,
	   SubTotal,
	   TaxAmt
	   from Purchasing.PurchaseOrderHeader
	   where EXISTS (
	   Select 1 from Purchasing.PurchaseOrderDetail
where OrderQty>500 AND PurchaseOrderDetail.PurchaseOrderID=PurchaseOrderHeader.PurchaseOrderID and UnitPrice >50
	   )

	   ORDER BY 1



Select * from Purchasing.PurchaseOrderDetail

Select * from Purchasing.ProductVendor

Select * from Purchasing.PurchaseOrderHeader

Select * from Purchasing.PurchaseOrderHeader
where Not Exists (
Select 1  from Purchasing.PurchaseOrderDetail 
where RejectedQty> 0 and PurchaseOrderHeader.PurchaseOrderID=PurchaseOrderDetail.PurchaseOrderID

)
Select * from Production.ProductSubcategory

Select * from Production.Product

Select ProductSubcategoryID,Name as SubcategoryName from Production.ProductSubcategory

-- Create a list of product by using the concept of XML Path		 

  SELECT ProductSubcategoryID,ProductCategoryID,rowguid,ModifiedDate,Name=
	STUFF(
		  (
		    	  	  SELECT
		  ',' + CAST(Name  AS VARCHAR)
		  FROM Production.Product
		  WHERE Production.ProductSubcategory.ProductSubcategoryID =Production.Product.ProductSubcategoryID
		  FOR XML PATH('')
			
		  ),
		  1,1,'')
		  FROM Production.ProductSubcategory

-- This is an alternative from the previous queries


		  SELECT Production.ProductSubcategory.Name AS SubcategoryName,Product=
	STUFF(
		  (
		    	  	  SELECT
		  ',' + CAST(Name  AS VARCHAR)
		  FROM Production.Product
		  WHERE Production.ProductSubcategory.ProductSubcategoryID =Production.Product.ProductSubcategoryID
		  FOR XML PATH('')
			
		  ),
		  1,1,'')
		  FROM Production.ProductSubcategory

-- In the next list, the only product  greater that $ 50 will be included.

		  		  SELECT Production.ProductSubcategory.Name AS SubcategoryName,Product=
	STUFF(
		  (
		    	  	  SELECT
		  ',' + CAST(Name  AS VARCHAR)
		  FROM Production.Product
		  WHERE Production.ProductSubcategory.ProductSubcategoryID =Production.Product.ProductSubcategoryID and ListPrice >=50
		  FOR XML PATH('')
			
		  ),
		  1,1,'')
		  FROM Production.ProductSubcategory

-- Use Pivot function to find average amount of vacation time for Sale representatives, Janitors, and Buyers

Select *

from

(
Select JobTitle, VacationHours from HumanResources.Employee
Where JobTitle in ('Sales Representative','Janitor','Buyer')
) A
PIVOT(
AVG(VacationHours)
FOR JobTitle IN([Sales Representative],[Janitor],[Buyer])
) B 


Select [Employee gender]=Gender, [Sales Representative],Janitor,Buyer

from

(
Select JobTitle, VacationHours, Gender from HumanResources.Employee
Where JobTitle in ('Sales Representative','Janitor','Buyer')
) A
PIVOT(
AVG(VacationHours)
FOR JobTitle IN([Sales Representative],[Janitor],[Buyer])
) B 

-- Find the top 10 sales of each month and compare that top 10 purchase of the same month

With  sales  as 
(
SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) S
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) 

, Purchase_CTE  (OrderMonth,TotalPurchases) As
 (SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) P
	WHERE OrderRank > 10
	GROUP BY OrderMonth)

	Select Purchase_CTE.OrderMonth,
	TotalSales,
	TotalPurchases 

	from Purchase_CTE
	join sales on Purchase_CTE.OrderMonth=sales.OrderMonth
	
	Order by 1

-- Use a recursive CTE to generate a date series of all FIRST days of the month (1/1/2021, 2/1/2021, etc.)
-- from 1/1/2020 to 12/1/2029.



	WITH Dates AS
(
SELECT
 CAST('01-01-2020' AS DATE) AS MyDate

UNION ALL

SELECT
DATEADD(MONTH, 1, MyDate)
FROM Dates
WHERE MyDate < CAST('12-01-2029' AS DATE)
)

SELECT
MyDate

FROM Dates
OPTION (MAXRECURSION 120)

-- Temp Table


	
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		Into #sales
		FROM AdventureWorks2019.Sales.SalesOrderHeader

		Select * from #sales
		

		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		Into #Purchase
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader

		Select *from #Purchase

Select * from AdventureWorks2019.Sales.SalesOrderHeader