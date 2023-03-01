/*

Data Cleaning using SQL Queries

*/

SELECT * FROM SQLPortfolio.dbo.Housing

----------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate
FROM SQLPortfolio.dbo.Housing


SELECT SaleDate, CONVERT(Date, SaleDate)
FROM SQLPortfolio.dbo.Housing


ALTER TABLE Housing
ADD SaleDateConv Date;

UPDATE Housing
SET SaleDateConv = CONVERT(date, SaleDate)

SELECT SaleDateConv
FROM SQLPortfolio.dbo.Housing

ALTER TABLE Housing
DROP COLUMN SaleDate;

SELECT SaleDateConv
FROM SQLPortfolio.dbo.Housing

SELECT *
FROM SQLPortfolio.dbo.Housing


------------------------------------------------------------------------------------------

-- Populate Property Address Data

SELECT PropertyAddress
FROM SQLPortfolio.dbo.Housing
WHERE PropertyAddress is NULL
ORDER BY ParcelID

-- Doing self join so that the address missed fileds can be populated with already existing parcelID's address

-- checking the null fields first for the PropertyAddress after the join funtion

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLPortfolio.dbo.Housing a
JOIN SQLPortfolio.dbo.Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Updating the Table after Join

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLPortfolio.dbo.Housing a
JOIN SQLPortfolio.dbo.Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


SELECT PropertyAddress
FROM SQLPortfolio.dbo.Housing
WHERE PropertyAddress IS NULL

------------------------------------------------------------------------------------------------------

-- Splitting address into individual columns such as House no., City, State etc.,


SELECT PropertyAddress
FROM SQLPortfolio.dbo.Housing
--WHERE PropertyAddress is NULL
--ORDER BY ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM SQLPortfolio.dbo.Housing

------------------------
-- checking the data using select statement with dateparse

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM SQLPortfolio.dbo.Housing


ALTER TABLE Housing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE Housing
ADD OwnerSplitCity Nvarchar(255);

UPDATE Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE Housing
ADD OwnerSplitState Nvarchar(255);

UPDATE Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT *
FROM SQLPortfolio.dbo.Housing


-----------------------------------------------------------------------------------------------------------

-- Change 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant field

Select Distinct(SoldAsVacant)
FROM SQLPortfolio.dbo.Housing


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM SQLPortfolio.dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2


Select Distinct(SoldAsVacant)
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM SQLPortfolio.dbo.Housing


UPDATE Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


--------------------------------------------------------------------------------------------------

-- Remove duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDateConv,
					LegalReference
					ORDER BY 
						UniqueID
						) row_num

FROM SQLPortfolio.dbo.Housing
--ORDER BY ParcelID
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDateConv,
					LegalReference
					ORDER BY 
						UniqueID
						) row_num

FROM SQLPortfolio.dbo.Housing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


SELECT *
FROM SQLPortfolio.dbo.Housing

------------------------------------------------------------------------------------------------------

-- Deleting unused columns

SELECT *
FROM SQLPortfolio.dbo.Housing


ALTER SQLPortfolio.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

--DateSale column which was converted with correct format has already been dropped.












