--RQ1
--Count the number of listings in each neighborhood
SELECT Neighbourhood.Neighbourhood_ID, Neighbourhood_Name, COUNT(*) AS Number_of_Listings
FROM Neighbourhood
JOIN Listing ON Neighbourhood.Neighbourhood_ID = Listing.Neighbourhood_ID
GROUP BY Neighbourhood.Neighbourhood_ID, Neighbourhood_Name
ORDER BY Number_of_Listings DESC;

--RQ2
-- Select neighborhood and daily price data
SELECT Neighbourhood_Name, Price
FROM Listing
JOIN Neighbourhood
ON Listing.Neighbourhood_ID = Neighbourhood.Neighbourhood_ID;

--RQ3
--Count the number of hosts that registered in each year
SELECT Host_Registration_Year, COUNT(*) AS Number_of_Hosts
FROM Host
WHERE Host_Registration_Year IS NOT NULL
GROUP BY Host_Registration_Year
ORDER BY Host_Registration_Year;

--RQ4
--Count the number of listings managed by each host 
SELECT Host_ID, COUNT(Listing_ID) AS Number_of_Listings
FROM Listing
GROUP BY Host_ID
ORDER BY Number_of_Listings DESC;

--Categorise the number of listings managed by each host into bins
SELECT
  CASE
    WHEN Number_of_Listings IS NULL THEN 'NULL'
    WHEN Number_of_Listings = 1 THEN '1'
    WHEN Number_of_Listings BETWEEN 2 AND 4 THEN '2-4'
    WHEN Number_of_Listings BETWEEN 5 AND 8 THEN '5-8'
    WHEN Number_of_Listings BETWEEN 9 AND 16 THEN '9-16'
    WHEN Number_of_Listings BETWEEN 17 AND 32 THEN '17-32'
    WHEN Number_of_Listings BETWEEN 33 AND 64 THEN '33-64'
    WHEN Number_of_Listings BETWEEN 65 AND 128 THEN '65-128'
    WHEN Number_of_Listings BETWEEN 129 AND 256 THEN '129-256'
    WHEN Number_of_Listings BETWEEN 257 AND 512 THEN '257-512'
    WHEN Number_of_Listings BETWEEN 513 AND 1024 THEN '513-1024'	
    ELSE 'Over 512'
  END AS Listing_Bin,
  COUNT(*) AS Host_Count
FROM (
  SELECT Host_ID, COUNT(Listing_ID) AS Number_of_Listings
  FROM Listing
  GROUP BY Host_ID
) AS Subquery
GROUP BY Listing_Bin
ORDER BY MIN(Number_of_Listings);