--Cleaning data in SQL query

select * from PortfolioProject.dbo.NashvilleHousing






-----------------------------------------------------------------------


--Standardize date format


select SalesDateconverted, convert(date,SaleDate)  from PortfolioProject.dbo.NashvilleHousing 
 
update NashvilleHousing
set SaleDate = convert(date,SaleDate) 

alter table NashvilleHousing
 add salesdateconverted Date ,

 update NashvilleHousing
set salesdateconverted = convert(date,SaleDate) 






------------------------------------------------------------------------------------



--Populate porperty address data

select  * from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID


select  a.ParcelID,a.PropertyAddress, b.parcelid,b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing a
join  PortfolioProject.dbo.NashvilleHousing b
 on a.parcelid = b.parcelid
 and a.uniqueid <> b.uniqueid 
 where a.PropertyAddress is null


 update a
 set propertyaddress =ISNULL(a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing a
join  PortfolioProject.dbo.NashvilleHousing b
 on a.parcelid = b.parcelid
 and a.uniqueid <> b.uniqueid 
 where a.PropertyAddress is null


-----------------------------------------------
--BRreaking out address into individual columns (Adress,City,States)


select PropertyAddress  from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',propertyaddress) -1) as address,
SUBSTRING (PropertyAddress,CHARINDEX(',',propertyaddress)  +1,len(PropertyAddress)) as address
from PortfolioProject.dbo.NashvilleHousing



alter table PortfolioProject.dbo.NashvilleHousing
 add Propertysplitaddress nvarchar(255) ;

update  PortfolioProject.dbo.NashvilleHousing
set Propertysplitaddress= SUBSTRING (PropertyAddress,1,CHARINDEX(',',propertyaddress) -1) 

alter table  PortfolioProject.dbo.NashvilleHousing
 add Propertysplitcity nvarchar(255);

 update   PortfolioProject.dbo.NashvilleHousing
set Propertysplitcity = SUBSTRING (PropertyAddress,CHARINDEX(',',propertyaddress)  +1,len(PropertyAddress)) 


select OwnerAddress from  PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(replace( OwnerAddress,',','.'),3),
PARSENAME(replace( OwnerAddress,',','.'),2),
PARSENAME(replace( OwnerAddress,',','.'),1)
from  PortfolioProject.dbo.NashvilleHousing




alter table  PortfolioProject.dbo.NashvilleHousing
 add ownersplitaddress nvarchar(255);
 
update  PortfolioProject.dbo.NashvilleHousing
set ownersplitaddress = PARSENAME(replace( OwnerAddress,',','.'),3) 


alter table  PortfolioProject.dbo.NashvilleHousing
 add ownersplitcity nvarchar(255);

 update   PortfolioProject.dbo.NashvilleHousing
set ownersplitcity =PARSENAME(replace( OwnerAddress,',','.'),2)


alter table  PortfolioProject.dbo.NashvilleHousing
 add ownersplitstate nvarchar(255);

 update   PortfolioProject.dbo.NashvilleHousing
set ownersplitstate = PARSENAME(replace( OwnerAddress,',','.'),1)

alter table  PortfolioProject.dbo.NashvilleHousing
drop column  ownerssplitsplitaddress;


----------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in sold as vacant field


select distinct(SoldAsVacant), count(SoldAsVacant) 
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select  SoldAsVacant
,case when  SoldAsVacant = 'Y' then 'Yes'
      when  SoldAsVacant = 'N' then 'No'
	  else  SoldAsVacant
	  end
from PortfolioProject.dbo.NashvilleHousing

update PortfolioProject.dbo.NashvilleHousing
set  SoldAsVacant =case when  SoldAsVacant = 'Y' then 'Yes'
      when  SoldAsVacant = 'N' then 'No'
	  else  SoldAsVacant
	  end


-----------------------------------------------------------------------------------------------
--Remove Duplicates



WITH RowNumCTE AS(
Select *,
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
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-----------------------------------------------------------------------------------------------------

--Remove unused columns


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OWNERADDRESS,TAXDISTRICT,PROPERTYADDRESS


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SALEDATE






 