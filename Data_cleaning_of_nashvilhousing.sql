/*

Cleaning Data in SQL Queries

*/


Select *
From housedata..Nashvilhousing2

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT Saledateconverted , CONVERT(DATE, SaleDate)
FROM housedata..Nashvilhousing2

UPDATE Nashvilhousing2
SET SaleDate = CONVERT(DATE, SaleDate)

ALTER TABLE Nashvilhousing2
ADD Saledateconverted Date;

UPDATE Nashvilhousing2
SET Saledateconverted = CONVERT(DATE, SaleDate)


-----------------------------------------------------------------

-- POPULATED PROPERTY ADDRESS DATA


SELECT *
FROM housedata..Nashvilhousing2
--WHERE PropertyAddress IS NULL 
--ORDER BY ParcelID

SELECT A.ParcelID,A.PropertyAddress, B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM housedata..Nashvilhousing2 A
JOIN housedata..Nashvilhousing2 B
on A.ParcelID = B.ParcelID
And A.[UniqueID ] <> B.[UniqueID ] 
WHERE A.PropertyAddress IS NULL 


UPDATE A
SET PropertyAddress =  ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM housedata..Nashvilhousing2 A
JOIN housedata..Nashvilhousing2 B
on A.ParcelID = B.ParcelID
And A.[UniqueID ] <> B.[UniqueID ] 
WHERE A.PropertyAddress IS NULL 


-------------------------------------------------------------------------------
--BREAKING ADDRESS INTO INDIVIDUAL COLONM (ADDRESS,CITY )


SELECT PropertyAddress
FROM housedata..Nashvilhousing2
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX (',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX (',',PropertyAddress) +1, LEN(PropertyAddress)) as CityAddress
FROM housedata..Nashvilhousing2
--ORDER BY ParcelID


ALTER TABLE Nashvilhousing2
Add PropertySplitAddress Nvarchar(255);

Update Nashvilhousing2
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX (',',PropertyAddress)-1) 


ALTER TABLE Nashvilhousing2
Add PropertySplitCity Nvarchar(255);

Update Nashvilhousing2
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT*
FROM housedata..Nashvilhousing2


--SPLITING OWNER ADDRESS INTO (ADDRESS,CITY AND STATE)
SELECT OwnerAddress 
FROM housedata..Nashvilhousing2


SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.' ),3)
,PARSENAME(REPLACE(OwnerAddress,',', '.' ),2)
,PARSENAME(REPLACE(OwnerAddress,',', '.' ),1)
FROM housedata..Nashvilhousing2


ALTER TABLE Nashvilhousing2
Add OwnerSplitAddress Nvarchar(255);

Update Nashvilhousing2
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.' ),3)

ALTER TABLE Nashvilhousing2
Add OwnerSplitCity Nvarchar(255);

Update Nashvilhousing2
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.' ),2)


ALTER TABLE Nashvilhousing2
Add OwnerSplitState Nvarchar(255);

Update Nashvilhousing2
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.' ),1) 

ropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



----------------------------------------------------------------------------------------------------------
-- CHANGE THE SoldAsvacant,s 'Y' AND 'N' INTO YES AND NO 


SELECT Distinct SoldAsVacant,Count(SoldAsVacant )
FROM Nashvilhousing2
GROUP BY SoldAsVacant 
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Nashvilhousing2


UPDATE Nashvilhousing2
SET SoldAsVacant =CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


------------------------------------------------------------------------------------------

--DELETE  DUPICATES  COLUMNS

WITH ROWNUMCTE AS(
SELECT *,
     ROW_NUMBER () OVER (
	 PARTITION BY ParcelID,
	                        PropertyAddress,
							SalePrice,
							Saledate,
							LegalReference
							ORDER BY 
							       Uniqueid
								   ) AS row_num

FROM Nashvilhousing2
)
SELECT *
FROM ROWNUMCTE
WHERE row_num >1 
--ORDER BY PropertyAddress

Select *
From housedata..Nashvilhousing2

------------------------------------------------------------------------------------
--DELETE UNUSED COLUNM 

Select* 
From housedata..Nashvilhousing2

ALTER TABLE  housedata..Nashvilhousing2
DROP COLUMN PropertyAddress,SaleDate,OwnerAddress,TaxDistrict
