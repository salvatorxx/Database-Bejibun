use bejibun
go 

-- 1
select ID.ItemName, ID.ItemPrice, sum(PTD.PurchaseQty) as [Item Total]
from ItemDetail as ID
join PurchaseTransactionDetail as PTD on ID.ItemId = PTD.ItemId
join PurchaseTransaction as PT on PT.PurchaseTransactionId = PTD.PurchaseTransactionId
where PT.ArrivalDate is NULL
group by ID.ItemName, ID.ItemPrice
having sum(PTD.PurchaseQty) > 100
order by [Item Total] desc

-- 2
select VendorName, right(VendorEmail, charindex('@',reverse(VendorEmail))-1) as [Domain Name], 
avg(PTD.PurchaseQty) as [Average Purchased Item]
from VendorDetail as VD
join PurchaseTransaction as PT on PT.VendorId = VD.VendorId
join PurchaseTransactionDetail as PTD on PTD.PurchaseTransactionId = PT.PurchaseTransactionId
where VendorAddress like 'Food Street' 
and right(VendorEmail, charindex('@',reverse(VendorEmail))-1) not like 'gmail.com'
group by PT.VendorId, VendorName, VendorEmail

-- 3
select datename(month, ST.SalesDate) as [Month],
min(SalesQty) as [Minimum Quantity Sold], 
max(SalesQty) as [Maximum Quantity Sold]
from SalesTransaction as ST
join SalesTransactionDetail as STD on STD.SalesTransactionId = ST.SalesTransactionId
join ItemDetail as ID on ID.ItemId = STD.ItemId
join ItemTypeDetail as ITD on ITD.ItemTypeId = ID.ItemTypeId
where year(ST.SalesDate) = 2019
and ITD.ItemTypeName not in('Food','Drink')
group by ST.SalesDate

-- 4
select replace(ST.StaffID, 'ST', 'Staff ') as [Staff Number],
SD.StaffName, concat('Rp. ', SD.StaffSalary) as [Salary],
count(ST.SalesTransactionId) as [Sales Count],
avg(STD.SalesQty) as [Average Sales Quantity]
from StaffDetail as SD 
join SalesTransaction as ST on ST.StaffId = SD.StaffId
join SalesTransactionDetail as STD on STD.SalesTransactionId = ST.SalesTransactionId
join CustomerDetail as CD on CD.CustomerId = ST.CustomerId
where CustomerGender not like StaffGender
and SalesDate like 'February'
group by ST.StaffId, SD.StaffName, SD.StaffSalary 

-- 5
select concat(left(CustomerName,1), right(CustomerName,1)) as [Customer Initial],
format(SalesDate,'MM dd, yyyy') as [Transaction Date],
SalesQty as Quantity
from CustomerDetail CD
join SalesTransaction ST on CD.CustomerId = ST.CustomerId
join SalesTransactionDetail STD on STD.SalesTransactionId = ST.SalesTransactionId,
(   
    select avg(x.TotalQuantity) as AverageQuantity from (
    select concat(left(CustomerName,1), right(CustomerName,1)) as [Customer Initial],
    format(SalesDate,'MM dd, yyyy') as [Transaction Date],
    sum(SalesQty) as TotalQuantity
    from CustomerDetail CD
    join SalesTransaction ST on CD.CustomerId = ST.CustomerId
    join SalesTransactionDetail STD on STD.SalesTransactionId = ST.SalesTransactionId
    group by CustomerName, SalesDate
    ) x
) a
where CustomerGender = 'Female' and a.AverageQuantity < SalesQty 

-- 5
select concat(left(CustomerName,1), right(CustomerName,1)) as [Customer Initial],
format(SalesDate,'MM dd, yyyy') as [Transaction Date],
SalesQty as Quantity
from CustomerDetail CD
join SalesTransaction ST on CD.CustomerId = ST.CustomerId
join SalesTransactionDetail STD on STD.SalesTransactionId = ST.SalesTransactionId,
(   
    select avg(SalesQty) as AverageQuantity
    from SalesTransactionDetail
) a
where CustomerGender = 'Female' and a.AverageQuantity < SalesQty 

-- 6
select lower(VD.VendorId) as [ID],
VD.VendorName, stuff(VendorPhone,1,1,'+62') as [Phone Number]
from VendorDetail VD
join PurchaseTransaction PT on PT.VendorId = VD.VendorId
join PurchaseTransactionDetail PTD on PTD.PurchaseTransactionId = PT.PurchaseTransactionId,
(
    select min(PurchaseQty) as [Minimum Quantity]
    from PurchaseTransactionDetail
) a
where a.[Minimum Quantity] < PurchaseQty and convert(int, right(PTD.ItemId,3))%2 != 0

-- 7 
select StaffName, VendorName, PT.PurchaseTransactionId as [PurchaseID],
sum(PurchaseQty) as [Total Purchased Quantity],
concat(datediff(day,PurchaseDate,getdate()),' Days ago') as [Ordered Day]
from StaffDetail SD
join PurchaseTransaction PT on SD.StaffId = PT.StaffId
join VendorDetail VD on VD.VendorId = PT.VendorId
join PurchaseTransactionDetail PTD on PTD.PurchaseTransactionId = PT.PurchaseTransactionId,
(
    select max(PurchaseQty) as [Max Quantity]
    from PurchaseTransactionDetail
) a
where datediff(day, PurchaseDate, ArrivalDate) < 7
group by StaffName, VendorName, PT.PurchaseTransactionId, datediff(day, PurchaseDate, ArrivalDate), a.[Max Quantity]
having sum(PurchaseQty) > a.[Max Quantity]

-- 8
select top 2 datename(weekday,SalesDate) as [Day],
count(distinct STD.ItemId) as [Item Sales Amount]
from SalesTransaction ST
join SalesTransactionDetail STD on STD.SalesTransactionId = ST.SalesTransactionId
join ItemDetail ID on ID.ItemId = STD.ItemId
join ItemTypeDetail ITD on ITD.ItemTypeId = ID.ItemTypeId,
(
   select avg(ItemPrice) as AverageItem
   from ItemDetail ID
   join ItemTypeDetail ITD on ITD.ItemTypeId = ID.ItemTypeId
   where ItemTypeName in ('Electronic','Gadgets')
) a
where ItemPrice < a.AverageItem
group by SalesDate, a.AverageItem
order by [Item Sales Amount] asc

-- 9
create view [Customer Statistic by Gender] as 
select CD.CustomerGender, max(STD.SalesQty) as [Maximum Sales],min(STD.SalesQty) as [Minimum Sales]
from CustomerDetail as CD 
join SalesTransaction as ST on ST.CustomerId = CD.CustomerId
join SalesTransactionDetail as STD on STD.SalesTransactionId = ST.SalesTransactionId
where STD.SalesQty between 10 and 50 and year(CD.CustomerDOB) between 1998 and 1999
group by CD.CustomerGender

-- 10
create view [Item Type Statistic] as
select upper(ItemTypeName) as [Item Type],
avg(ID.ItemPrice) as [Average Price],
count(ITD.ItemTypeId) as [Item Variety]
from ItemDetail as ID 
join ItemTypeDetail as ITD on ITD.ItemTypeId = ID.ItemTypeId
where ITD.ItemTypeName like 'F%' and ID.ItemMinimum > 5
group by ITD.ItemTypeName, ITD.ItemTypeName