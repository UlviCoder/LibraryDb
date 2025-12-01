USE Library
--1)Tableler qur
CREATE TABLE Authors
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(25) NOT NULL,
	Surname NVARCHAR(25) NOT NULL
);
CREATE TABLE Books
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	AuthorId INT NOT NULL,
	Name NVARCHAR(25) NOT NULL,
	PageCount INT NOT NULL,
	CONSTRAINT Fk_Books_Authors FOREIGN KEY (AuthorId) REFERENCES Authors(Id),
	CONSTRAINT CHK_Books_Name_Length CHECK (LEN(Name) >= 2 AND LEN(Name) <= 100),
    CONSTRAINT CHK_Books_PageCount CHECK (PageCount >= 10)
);
--2) Id,Name,PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir VIEW yaradin
--CREATE VIEW vw_BooksWithAuthor AS
--SELECT 
--    b.Id,
--    b.Name,
--    b.PageCount,
--    a.Name + ' ' + a.Surname AS AuthorFullName
--FROM Books b
--INNER JOIN Authors a
--    ON b.AuthorId = a.Id;

--SELECT * FROM vw_BooksWithAuthor;

--3)Gonderilmis axtaris deyirene gore hemin axtaris deyeri Boook.name ve ya Author.Name olan Book-lari Id,Name,PageCount,AuthorFullName columnlari seklinde gosteren procedure yazin.
--USE Library;
--GO

--CREATE PROCEDURE SearchBooks
--    @SearchTerm NVARCHAR(100)
--AS
--BEGIN
--    SELECT 
--        b.Id,
--        b.Name,
--        b.PageCount,
--        a.Name + ' ' + a.Surname AS AuthorFullName
--    FROM Books b
--    INNER JOIN Authors a ON b.AuthorId = a.Id
--    WHERE b.Name LIKE '%' + @SearchTerm + '%'
--       OR a.Name LIKE '%' + @SearchTerm + '%';
--END
--GO

--EXEC SearchBooks @SearchTerm = 'Ülvi';

--4)Bir Function yaradin.MinPageCount parametri qebul etsin.Default deyeri 10 olsun; PageCount gonderilmis deyerden boyuk olan kitablarin sayini qaytarsin.

--USE Library;
--GO

--CREATE FUNCTION dbo.GetBooksCountByMinPageCount
--(
--    @MinPageCount INT = 10
--)
--RETURNS INT
--AS
--BEGIN
--    DECLARE @Count INT;

--    SELECT @Count = COUNT(*)
--    FROM Books
--    WHERE PageCount > @MinPageCount;

--    RETURN @Count;
--END
--GO

---- 10
--SELECT dbo.GetBooksCountByMinPageCount(10);

---- Istenilen
--SELECT dbo.GetBooksCountByMinPageCount(50);

--5)DeletedBooks table yaradin
--- Id 
--- AuthorId
--- Name
--- PageCount
--trigger yaradirsiz.
--Books tablesindən kitab silinən zaman silinmiş kitab deleted books tablesinə düşsün
--Birinci dbdesigner-de sturukturu qurub onun seklini atirsiniz sonra queryler

--CREATE TABLE DeletedBooks
--(
--    Id INT PRIMARY KEY,
--    AuthorId INT NOT NULL,
--    Name NVARCHAR(100) NOT NULL,
--    PageCount INT NOT NULL
--);

--CREATE TRIGGER trg_Books_Delete
--ON Books
--AFTER DELETE
--AS
--BEGIN
--    INSERT INTO DeletedBooks (Id, AuthorId, Name, PageCount)
--    SELECT Id, AuthorId, Name, PageCount
--    FROM deleted;
--END;

