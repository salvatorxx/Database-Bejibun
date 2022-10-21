create database bejibun
go
use bejibun
go
create table CustomerDetail(
	CustomerId char(5),
	CustomerName varchar(255) not null,
	CustomerGender varchar(6) not null,
	CustomerPhone varchar(15) not null,
	CustomerDOB date not null,

	constraint PK_CustomerDetail
		primary key(CustomerId),

	constraint CheckId_CustomerDetail
		check(CustomerId like 'CU[0-9][0-9][0-9]'),
	constraint CheckGender_CustomerDetail
		check(CustomerGender = 'male' or CustomerGender = 'female'),
	constraint CheckDOB_CustomerDOB 
		check (CustomerDOB >= '1990-01-01' and CustomerDOB <= cast(getdate() as date))
)

select *
from CustomerDetail

create table StaffDetail(
	StaffId char(5),
	StaffName varchar(255) not null,
	StaffGender varchar(6) not null,
	StaffPhone varchar(15) not null,
	StaffSalary int not null,

	constraint PK_StaffDetail
		primary key(StaffId),
		
	constraint CheckId_StaffDetail
		check(StaffId like 'ST[0-9][0-9][0-9]'),
	constraint CheckGender_StaffDetail
		check(StaffGender = 'male' or StaffGender = 'female'),
	constraint CheckSalary_StaffDetail
		check(StaffSalary > 0)
)

create table SalesTransaction(
	SalesTransactionId char(5),
	CustomerId char(5),
	StaffId char(5),
	SalesDate date not null,

	constraint PK_SalesTransaction
		primary key(SalesTransactionId),
	constraint FK1_SalesTransaction
		foreign key(CustomerId)
		references CustomerDetail(CustomerId)
		on update cascade on delete cascade,
	constraint FK2_SalesTransaction
		foreign key(StaffId)
		references StaffDetail(StaffId)
		on update cascade on delete cascade,

	constraint CheckId_SalesTransaction
		check(SalesTransactionId like 'SA[0-9][0-9][0-9]')
)

create table VendorDetail(
	VendorId char(5),
	VendorName varchar(255) not null,
	VendorPhone varchar(15),
	VendorAddress varchar(255),
	VendorEmail varchar(255) not null,

	constraint PK_VendorDetail
		primary key(VendorId),

	constraint CheckId_VendorDetail
		check(VendorId like 'VE[0-9][0-9][0-9]'),
	constraint CheckAddress_VendorDetail
		check(VendorAddress like '% Street'),
	constraint CheckEmail_VendorDetail
		check(VendorEmail like '_%@%_.com')
)

create table PurchaseTransaction(
	PurchaseTransactionId char(5),
	StaffId char(5),
	VendorId char(5),
	PurchaseDate date not null,
	ArrivalDate date,

	constraint PK_PurchaseTransaction
		primary key(PurchaseTransactionId),
	constraint FK1_PurchaseTransaction
		foreign key(VendorId)
		references VendorDetail(VendorId)
		on update cascade on delete cascade,
	constraint FK2_PurchaseTransaction
		foreign key(StaffId)
		references StaffDetail(StaffId)
		on update cascade on delete cascade,

	constraint CheckId_PurchaseTransaction
		check(PurchaseTransactionId like 'PH[0-9][0-9][0-9]')
)

create table ItemTypeDetail(
	ItemTypeId char(5),
	ItemTypeName varchar(255) not null,

	constraint PK_ItemTypeDetail
		primary key(ItemTypeId),

	constraint CheckId_ItemTypeDetail
		check(ItemTypeId like 'IP[0-9][0-9][0-9]'),
	constraint CheckName_ItemTypeDetail
		check(len(ItemTypeName) >= 4)
)

create table ItemDetail(
	ItemId char(5),
	ItemTypeId char(5),
	ItemName varchar(255) not null,
	ItemPrice int not null,
	ItemMinimum int not null,

	constraint PK_ItemDetail
		primary key(ItemId),
	constraint FK_ItemDetail
		foreign key(ItemTypeId)
		references ItemTypeDetail(ItemTypeId)
		on update cascade on delete cascade,

	constraint CheckId_ItemDetail
		check(ItemId like 'IT[0-9][0-9][0-9]'),
	constraint CheckPrice_ItemDetail
		check(ItemPrice > 0)
)


create table SalesTransactionDetail(
	SalesTransactionId char(5),
	ItemId char(5),
	SalesQty int not null,

	constraint CK_SalesTransactionDetail
		primary key(SalesTransactionId,ItemId),
	constraint FK1_SalesTransactionDetail
		foreign key(SalesTransactionId)
		references SalesTransaction(SalesTransactionId)
		on update cascade on delete cascade,
	constraint FK2_SalesTransactionDetail
		foreign key(ItemId)
		references ItemDetail(ItemId)
		on update cascade on delete cascade,

	constraint CheckId_SalesTransactionDetail
		check(ItemId like 'IT[0-9][0-9][0-9]')

)

create table PurchaseTransactionDetail(
	PurchaseTransactionId char(5),
	ItemId char(5),
	PurchaseQty int not null,

	constraint CK_PurchaseTransactionDetail
		primary key(PurchaseTransactionId,ItemId),
	constraint FK1_PurchaseTransactionDetail
		foreign key(PurchaseTransactionId)
		references PurchaseTransaction(PurchaseTransactionId)
		on update cascade on delete cascade,
	constraint FK2_PurchaseTransactionDetail
		foreign key(ItemId)
		references ItemDetail(ItemId)
		on update cascade on delete cascade,

	constraint CheckId_PurchaseTransactionDetail
		check(ItemId like 'IT[0-9][0-9][0-9]')
)

drop database bejibun
