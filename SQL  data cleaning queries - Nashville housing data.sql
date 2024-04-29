/*

Cleaning data using SQL queries

*/

--DELETE FROM nashville_housing;

SELECT PropAddress, PropCity FROM nashville_housing;


--Populate property adress data

SELECT * FROM nashville_housing
ORDER BY parcelid;

SELECT t1.parcelid, t1.propertyaddress, t2.parcelid, t2.propertyaddress
FROM nashville_housing AS t1
INNER JOIN nashville_housing AS t2
ON t1.parcelid = t2.parcelid AND t1.uniqueid <> t2.uniqueid
WHERE t1.propertyaddress IS null;

UPDATE nashville_housing AS t1
SET propertyaddress = t2.propertyaddress
FROM nashville_housing AS t2
WHERE t1.parcelid = t2.parcelid
AND t1.uniqueid <> t2.uniqueid
AND t1.propertyaddress IS NULL;

--Breaking out property address into individual columns (address, city)

SELECT SUBSTRING(propertyaddress, 1, strpos(propertyaddress, ',')-1) AS Address,
SUBSTRING(propertyaddress, strpos(propertyaddress, ',')+1, LENGTH(propertyaddress)) AS City
FROM nashville_housing;


ALTER TABLE nashville_housing
ADD PropAddress VARCHAR(70);

ALTER TABLE nashville_housing
ADD PropCity VARCHAR(70);

UPDATE nashville_housing 
SET PropAddress = SUBSTRING(propertyaddress, 1, strpos(propertyaddress, ',')-1),
PropCity = SUBSTRING(propertyaddress, strpos(propertyaddress, ',')+1, LENGTH(propertyaddress));

--Breaking out owner address into individual columns (address, city, state)

SELECT split_part(owneraddress, ',', 1) AS splitowneraddress,
       split_part(owneraddress, ',', 2) AS ownercity,
       split_part(owneraddress, ',', 3) AS ownerstate
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD splitowneraddress VARCHAR(70);

ALTER TABLE nashville_housing
ADD ownercity VARCHAR(70);

ALTER TABLE nashville_housing
ADD ownerstate VARCHAR(70);

UPDATE nashville_housing 
SET splitowneraddress = split_part(owneraddress, ',', 1),
ownercity = split_part(owneraddress, ',', 2),
ownerstate = split_part(owneraddress, ',', 3);

-- Change Y and N to Yes and No in "Sold as vacant" column
SELECT DISTINCT soldasvacant
FROM nashville_housing;

SELECT soldasvacant, COUNT(soldasvacant)
FROM nashville_housing
GROUP BY soldasvacant;


UPDATE nashville_housing
SET soldasvacant =
	CASE 
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN'No' 
		ELSE soldasvacant 	
	END;

--Remove duplicates

SELECT ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerName,  COUNT(*)
FROM nashville_housing
GROUP BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerName
HAVING COUNT(*)>1;

DELETE FROM nashville_housing
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM nashville_housing
    GROUP BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerName
);


 

