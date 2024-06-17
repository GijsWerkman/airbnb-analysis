--Create a copy of the Listings table as Listings_Cleaned
CREATE TABLE Listings_Cleaned AS
SELECT 
FROM Listings;

--Rename the original Listings table to Listings_Original
ALTER TABLE Listings RENAME TO Listings_Original;

--3.1 Checking data formats
--Removing currency from Price
UPDATE Listings_Cleaned SET Price = CAST(REPLACE(Price, '$', '') AS REAL);

--3.2 Renaming & creating variables
--Updating attribute names
ALTER TABLE Listings_Cleaned RENAME COLUMN host_ID TO Host_ID;
ALTER TABLE Listings_Cleaned RENAME COLUMN id TO Listing_ID;
ALTER TABLE Listings_Cleaned RENAME COLUMN neighbourhood_cleansed TO Neighbourhood_Name;
ALTER TABLE Listings_Cleaned RENAME COLUMN price TO Price;

--Adding Neighbourhood_ID
ALTER TABLE Listings_Cleaned ADD COLUMN Neighbourhood_ID INTEGER;

UPDATE Listings_Cleaned
SET Neighbourhood_ID = CASE
    WHEN Neighbourhood_Name = 'Louvre' THEN 1
    WHEN Neighbourhood_Name = 'Bourse' THEN 2
	WHEN Neighbourhood_Name = 'Temple' THEN 3
	WHEN Neighbourhood_Name = 'Hôtel-de-Ville' THEN 4
	WHEN Neighbourhood_Name = 'Panthéon' THEN 5
	WHEN Neighbourhood_Name = 'Luxembourg' THEN 6
	WHEN Neighbourhood_Name = 'Palais-Bourbon' THEN 7
	WHEN Neighbourhood_Name = 'Élysée' THEN 8
	WHEN Neighbourhood_Name = 'Opéra' THEN 9
	WHEN Neighbourhood_Name = 'Entrepôt' THEN 10
	WHEN Neighbourhood_Name = 'Popincourt' THEN 11
	WHEN Neighbourhood_Name = 'Reuilly' THEN 12
	WHEN Neighbourhood_Name = 'Gobelins' THEN 13
	WHEN Neighbourhood_Name = 'Observatoire' THEN 14
	WHEN Neighbourhood_Name = 'Vaugirard' THEN 15
	WHEN Neighbourhood_Name = 'Passy' THEN 16
	WHEN Neighbourhood_Name = 'Batignolles-Monceau' THEN 17
	WHEN Neighbourhood_Name = 'Buttes-Montmartre' THEN 18
	WHEN Neighbourhood_Name = 'Buttes-Chaumont' THEN 19
	WHEN Neighbourhood_Name = 'Ménilmontant' THEN 20
    ELSE NULL
END;

--Adding Host_Registration_Year
ALTER TABLE Listings_Cleaned ADD COLUMN Host_Registration_Year INTEGER;
UPDATE Listings_Cleaned
SET Host_Registration_Year = 
  CASE 
    WHEN host_since IS NOT NULL AND host_since LIKE '____-__-__'
    THEN CAST(SUBSTR(host_since, 1, 4) AS INTEGER)
    ELSE NULL
  END;

--3.3 Data deduplication
--Check for duplicate records
SELECT listing_id, COUNT() AS DuplicateCount
FROM Listings_Cleaned
GROUP BY listing_id
HAVING COUNT()  1;

--3.4 Missing values
SELECT  FROM Listings_Cleaned WHERE Host_ID IS NULL;
SELECT  FROM Listings_Cleaned WHERE Host_Registration_Year IS NULL;
SELECT  FROM Listings_Cleaned WHERE Listing_ID IS NULL;
SELECT  FROM Listings_Cleaned WHERE Neighbourhood_Name IS NULL;
SELECT  FROM Listings_Cleaned WHERE Neighbourhood_ID IS NULL;
SELECT  FROM Listings_Cleaned WHERE Price IS NULL;

--3.5 Outlier detection
--3.5.1 Outlier detection for Price
SELECT
  MAX(Price) AS max_price,
  MIN(Price) AS min_price,
  AVG(Price) AS avg_price
FROM Listings_Cleaned;

--3.5.2 Outlier detection for Host_Registration_Year
SELECT
  MAX(Host_Registration_Year) AS max_year,
  MIN(Host_Registration_Year) AS min_year
FROM Listings_Cleaned;

--3.6 Pseudonymisation
-- Matching table Listing_ID
CREATE TABLE Matching_Table_Listing_ID (
    Original_Listing_ID INT,
    Listing_ID TEXT
);

INSERT INTO Matching_Table_Listing_ID (Original_Listing_ID, Listing_ID)
SELECT DISTINCT
    Listing_ID AS Original_Listing_ID,
    hex(randomblob(16)) AS Listing_ID
FROM Listings_Cleaned;

-- Matching table Host_ID
CREATE TABLE Matching_Table_Host_ID (
    Original_Host_ID INT,
    Host_ID TEXT
);

INSERT INTO Matching_Table_Host_ID (Original_Host_ID, Host_ID)
SELECT DISTINCT
    Host_ID AS Original_Host_ID,
    hex(randomblob(16)) AS Host_ID
FROM Listings_Cleaned;

-- Update Listing_ID in Listings_Cleaned
UPDATE Listings_Cleaned
SET Listing_ID = (SELECT Listing_ID FROM Matching_Table_Listing_ID
WHERE Original_Listing_ID = Listings_Cleaned.Listing_ID);

-- Update Host_ID in Listings_Cleaned
UPDATE Listings_Cleaned
SET Host_ID = (SELECT Host_ID FROM Matching_Table_Host_ID
WHERE Original_Host_ID = Listings_Cleaned.Host_ID);