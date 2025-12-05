--CREATE DATABASE LibraryDb
--USE LibraryDB


CREATE TABLE Countries (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Code NVARCHAR(10)  
);

CREATE TABLE Cities (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);
ALTER TABLE Cities
ADD CountryId INT;

ALTER TABLE Cities
ADD CONSTRAINT FK_Cities_Countries
FOREIGN KEY (CountryId) REFERENCES Countries(Id);

ALTER TABLE Cities
ADD CONSTRAINT UQ_Cities_Country_Name UNIQUE (CountryId, Name);

CREATE TABLE Townships (
    Id INT IDENTITY PRIMARY KEY,
    CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id),
    Name NVARCHAR(100) NOT NULL,
    UNIQUE (CityId, Name)
);

CREATE TABLE Addresses (
    Id INT IDENTITY PRIMARY KEY,
    TownshipId INT NOT NULL FOREIGN KEY REFERENCES Townships(Id),
    Street NVARCHAR(150),
    Building NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Note NVARCHAR(200) 
);

CREATE TABLE Libraries (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id),
    Phone NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Books (
    Id INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    ISBN NVARCHAR(50) UNIQUE,
    PublishYear INT,
    PageCount INT,
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Genres (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,          
    Description NVARCHAR(300),           
    ParentGenreId INT NULL,                 
    CONSTRAINT FK_Genres_ParentGenre FOREIGN KEY (ParentGenreId)
        REFERENCES Genres(Id),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Genres_Name UNIQUE (Name) 
);

CREATE TABLE BookGenres (
    BookId INT NOT NULL FOREIGN KEY REFERENCES Books(Id),
    GenreId INT NOT NULL FOREIGN KEY REFERENCES Genres(Id),
    PRIMARY KEY (BookId, GenreId)
);

CREATE TABLE BookCopies (
    Id INT IDENTITY PRIMARY KEY,
    BookId INT NOT NULL FOREIGN KEY REFERENCES Books(Id),
    LibraryId INT NOT NULL FOREIGN KEY REFERENCES Libraries(Id),
    InventoryCode NVARCHAR(50) UNIQUE NOT NULL,  
    Status VARCHAR(20) DEFAULT 'Available',     
    AddedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Authors (
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    DeathDate DATE,
    BirthPlaceAddressId INT NULL,
    CONSTRAINT FK_Authors_BirthPlaceAddress FOREIGN KEY (BirthPlaceAddressId)
        REFERENCES Addresses(Id),
    NationalityCountryId INT NULL,
    CONSTRAINT FK_Authors_NationalityCountry FOREIGN KEY (NationalityCountryId)
        REFERENCES Countries(Id),
    Biography NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
-- Uzvluk xidmetleri ayliq illik 
CREATE TABLE MembershipTypes (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(50),
    MaxBooks INT DEFAULT 5,
    DurationDays INT DEFAULT 365,  
    CreatedAt DATETIME DEFAULT GETDATE()
);
-- Uzvn ozu
CREATE TABLE Members (
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    MembershipTypeId INT FOREIGN KEY REFERENCES MembershipTypes(Id),
    Status NVARCHAR(20) DEFAULT 'Active', 
    CreatedAt DATETIME DEFAULT GETDATE()
);
--Kitab goturme
CREATE TABLE Loans (
    Id INT IDENTITY PRIMARY KEY,
    MemberId INT NOT NULL FOREIGN KEY REFERENCES Members(Id),
    BookCopyId INT NOT NULL FOREIGN KEY REFERENCES BookCopies(Id),
    LoanDate DATETIME DEFAULT GETDATE(),
    DueDate DATETIME,
    ReturnDate DATETIME NULL,
    Status NVARCHAR(20) DEFAULT 'Borrowed'  
);
