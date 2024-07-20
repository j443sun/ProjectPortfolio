/*

Cleaning Data in SQL Queries
*/

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM ProjectPortfolio.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

-- spliting up property address to different parts


SELECT *
FROM ProjectPortfolio.dbo.NashvilleHousing
order by ParcelID

select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from ProjectPortfolio.dbo.NashvilleHousing a
join projectportfolio.dbo.nashvillehousing b
	on a.parcelID = b.parcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

UPDATE a
set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from ProjectPortfolio.dbo.NashvilleHousing a
join projectportfolio.dbo.nashvillehousing b
	on a.parcelID = b.parcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.propertyaddress is null

--individual columns
SELECT PropertyADdress
FROM ProjectPortfolio.dbo.NashvilleHousing

select
substring (propertyaddress, 1, charindex(',', PropertyAddress)-1) as address
, substring (propertyaddress, charindex(',', PropertyAddress)+1, len(propertyaddress)) as city
from ProjectPortfolio.dbo.NashvilleHousing

alter table nashvillehousing
add PropertySplitAddress nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitAddress = substring (propertyaddress, 1, charindex(',', PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = substring (propertyaddress, charindex(',', PropertyAddress)+1, len(propertyaddress))

select * 
from projectportfolio.dbo.NashvilleHousing

select OwnerAddress
from ProjectPortfolio.dbo.NashvilleHousing


select
parsename (replace(owneraddress, ',', '.'), 3) as Location_Address,
parsename (replace(owneraddress, ',', '.'), 2) as Location_City,
parsename (replace(owneraddress, ',', '.'), 1) as Location_State
from ProjectPortfolio.dbo.NashvilleHousing

alter table nashvillehousing
add OwnerSplitAddress nvarchar(255);
Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


alter table nashvillehousing
add PropertySplitAddress nvarchar(255);
Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


alter table nashvillehousing
add PropertySplitAddress nvarchar(255);
Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

--edit data values (boolean)

select distinct(SoldAsVacant), Count(SoldAsVacant)
From ProjectPortfolio.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	End
from ProjectPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = 
	CASE 
	   When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--RemoveDuplicates
With RowNumCTE As(
select *,
	Row_Number() OVER
	(Partition by parcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	order by UniqueID) row_num
from ProjectPortfolio.dbo.NashvilleHousing
)

--where row_num >1
Select * 
from RowNumCTE
where row_num > 1 
order by PropertyAddress

Select *
From ProjectPortfolio.dbo.NashvilleHousing


Alter Table ProjectPortfolio.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




