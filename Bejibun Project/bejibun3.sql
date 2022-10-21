use bejibun
go

-- sales transaction (transaksi baru)
-- Customer : Vito Ega
-- Staff    : Jeni Blekping
--  Salmon(2), Pork(1), Light Bulb(6), Beef(3), Crab(2), Cow Milk(5), Chicken(1)

insert into SalesTransaction
values
('SA021','CU002','ST010','2021-11-07')

insert into SalesTransactionDetail
values
('SA021','IT002',2),
('SA021','IT004',1),
('SA021','IT007',6),
('SA021','IT001',3),
('SA021','IT009',2),
('SA021','IT006',5),
('SA021','IT008',1)

select ST.SalesTransactionId, CD.CustomerName, SD.StaffName, ID.ItemName, 
STD.SalesQty, ID.ItemPrice, (ID.ItemPrice*STD.SalesQty) as [Total per Item], [Total Akhir]
from SalesTransaction ST
join CustomerDetail CD on CD.CustomerId = ST.CustomerId
join StaffDetail SD on SD.StaffId = ST.StaffId
join SalesTransactionDetail STD on STD.SalesTransactionId = ST.SalesTransactionId
join ItemDetail ID on ID.ItemId = STD.ItemId
join ItemTypeDetail ITD on ITD.ItemTypeId = ID.ItemTypeId, 
(
    select sum(ID.ItemPrice*STD.SalesQty) as [Total Akhir]
    from SalesTransaction ST
    join SalesTransactionDetail STD on STD.SalesTransactionId = ST.SalesTransactionId
    join ItemDetail ID on ID.ItemId = STD.ItemId
    where ST.SalesTransactionId = 'SA021'
) x 
where ST.SalesTransactionId = 'SA021'

-- purchase transaction (transaksi baru)
-- Vendor   : Jepon
-- Staff    : Arnolt
-- Beef(20), Pork(25), Chicken(10), Salmon(50), Tuna(15)
insert into PurchaseTransaction
values 
('PH021','ST003','VE009','2021-11-07',null)

insert into PurchaseTransactionDetail
values 
('PH021','IT001',20),
('PH021','IT004',25),
('PH021','IT008',10),
('PH021','IT002',50),
('PH021','IT005',15)

select PT.PurchaseTransactionId, VD.VendorName, SD.StaffName, ID.ItemName, 
PTD.PurchaseQty, ID.ItemPrice, (ID.ItemPrice*PTD.PurchaseQty) as [Total per Item], [Total Akhir]
from PurchaseTransaction PT
join VendorDetail VD on VD.VendorId = PT.VendorId
join StaffDetail SD on SD.StaffId = PT.StaffId
join PurchaseTransactionDetail PTD on PTD.PurchaseTransactionId = PT.PurchaseTransactionId
join ItemDetail ID on ID.ItemId = PTD.ItemId
join ItemTypeDetail ITD on ITD.ItemTypeId = ID.ItemTypeId,
(
    select sum(ID.ItemPrice*PTD.PurchaseQty) as [Total Akhir]
    from PurchaseTransaction PT
    join PurchaseTransactionDetail PTD on PTD.PurchaseTransactionId = PT.PurchaseTransactionId
    join ItemDetail ID on ID.ItemId = PTD.ItemId
    where PT.PurchaseTransactionId = 'PH021'
) x
where PT.PurchaseTransactionId = 'PH021'