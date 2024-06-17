--Create Listings entity
CREATE TABLE Listings (
    Listing_ID TEXT PRIMARY KEY,
    Price REAL,
    Neighbourhood_ID INTEGER,
    Host_ID TEXT,
    FOREIGN KEY (Neighbourhood_ID) REFERENCES Neighbourhood(Neighbourhood_ID),
    FOREIGN KEY (Host_ID) REFERENCES Host(Host_ID)
);

--Create Neighbourhood entity
CREATE TABLE Neighbourhood (
    Neighbourhood_ID INTEGER PRIMARY KEY,
    Neighbourhood_Name TEXT
);

--Create Host entity
CREATE TABLE Host (
    Host_ID TEXT PRIMARY KEY,
    Host_Registration_Year INTEGER
);

-- Populate Listings table
INSERT INTO Listings (Listing_ID, Price, Neighbourhood_ID, Host_ID)
SELECT DISTINCT
    Listing_ID,
    Price,
    Neighbourhood_ID,
    Host_ID
FROM Listings_Cleaned;

-- Populate Neighbourhood table
INSERT INTO Neighbourhood (Neighbourhood_ID, Neighbourhood_Name)
SELECT DISTINCT Neighbourhood_ID, Neighbourhood_Name
FROM Listings_Cleaned;

-- Populate Host table
INSERT INTO Host (Host_ID, Host_Registration_Year)
SELECT DISTINCT Host_ID, Host_Registration_Year
FROM Listings_Cleaned;