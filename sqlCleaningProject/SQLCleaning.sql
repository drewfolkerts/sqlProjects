/*

Cleaning Data in SQL Queries

*/

Select * from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SalesDataConverted,CONVERT(Date,SaleDate) from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing Set SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing add SalesDataConverted Date;

Update NashvilleHousing Set SalesDataConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null





--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) as City

from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing 
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing 
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing 
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing 
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))

Select * 
from PortfolioProject.dbo.NashvilleHousing

-- Owner Address

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing 
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing 
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)

ALTER TABLE NashvilleHousing 
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing 
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)

ALTER TABLE NashvilleHousing 
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing 
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)

Select * 
from PortfolioProject.dbo.NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' Then 'Yes'
	   when SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing 
SET SoldAsVacant = 
CASE when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
/*WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
				UniqueID
				) row_num

From PortfolioProject.dbo.NashvilleHousing
)
DELETE
from RowNumCTE
where row_num > 1
*/
--Select to confirm duplicates were deleted
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
				UniqueID
				) row_num

From PortfolioProject.dbo.NashvilleHousing
)
SELECT *
from RowNumCTE
where row_num > 1
Order by PropertyAddress
-----------------------------
SELECT *
From PortfolioProject.dbo.NashvilleHousing
-------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
SELECT *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


















