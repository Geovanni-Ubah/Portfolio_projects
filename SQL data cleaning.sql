-- standardize date format

ALTER TABLE nashvillehousing
ADD Saledateconverted Date;

UPDATE NashvilleHousing
SET Saledateconverted = CONVERT(date,saledate)

-- populate property address data

SELECT h.ParcelID,h.PropertyAddress,c.ParcelID,c.PropertyAddress,ISNULL(h.propertyaddress,c.PropertyAddress)
FROM NashvilleHousing h
JOIN NashvilleHousing c
	ON h.ParcelID = c.ParcelID AND
		h.[UniqueID ] <> c.[UniqueID ]
WHERE h.PropertyAddress IS NULL

UPDATE h
SET propertyaddress = ISNULL(h.propertyaddress,c.PropertyAddress)
FROM NashvilleHousing h
JOIN NashvilleHousing c
	ON h.ParcelID = c.ParcelID AND
		h.[UniqueID ] <> c.[UniqueID ]
WHERE h.PropertyAddress IS NULL


-- Breaking out Address into Individual columns (Address,City,State)

SELECT SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) AS updatedd,
        SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as new
FROM NashvilleHousing

ALTER TABLE nashvillehousing
ADD StreetAddress Nvarchar(255);

UPDATE NashvilleHousing
SET StreetAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE nashvillehousing
ADD CityName Nvarchar(255);

UPDATE NashvilleHousing
SET CityName = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

 SELECT owneraddress,
		PARSENAME(REPLACE(owneraddress,',','.'),3) AS Street,
		PARSENAME(REPLACE(owneraddress,',','.'),2) AS city,
		PARSENAME(REPLACE(owneraddress,',','.'),1) AS acronym
 FROM NashvilleHousing;

 ALTER TABLE nashvillehousing
ADD OwnerStreetAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerStreetAddress = PARSENAME(REPLACE(owneraddress,',','.'),3) 

ALTER TABLE nashvillehousing
ADD OwnerCityName Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerCityName = PARSENAME(REPLACE(owneraddress,',','.'),2)

ALTER TABLE nashvillehousing
ADD OwnerState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(owneraddress,',','.'),1)

SELECT *
FROM NashvilleHousing


-- Change Y and N to Yes and N
SELECT DISTINCT(SoldAsVacant)
FROM NashvilleHousing

SELECT SoldAsVacant,
CASE  
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE soldasvacant
	END 
FROM NashvilleHousing

UPDATE NashvilleHousing
SET  SoldAsVacant = CASE  
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE soldasvacant
	END 



-- Remove duplicates

