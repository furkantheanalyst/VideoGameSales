--Describe Columns
EXEC sp_columns 'vgsales';

--Select Table
Select * From msplayground..vgsales;

--Distinct Values For All Columns
--Checking if is anything wrong
Select Distinct(Publisher) From msplayground..vgsales Order By 1;

--We have some null values in year, lest try to fix them with different platform records for the games
--That will cause no problem if the game is not Playstation Exclusive or GTA V
Select a.Name as aName, b.Name as bName, a.Platform as aPlatfrom, b.Platform as bPlatform, a.Year as aYear, ISNULL(a.Year,b.Year)
From msplayground..vgsales a
JOIN msplayground..vgsales b
	ON a.Name = b.Name
	AND a.Rank <> b.Rank
Where a.Year is null and b.Year is not null;

Update a
SET Year = ISNULL(a.Year, b.Year)
From msplayground..vgsales a
JOIN msplayground..vgsales b
	ON a.Name = b.Name
	AND a.Rank <> b.Rank
Where a.Year is null and b.Year is not null;

--Checking the game has a year in it has name, if it has we will use it 
--If a games name has a year on it then game was probably (%99) released on the year before it
Select * From msplayground..vgsales Where Year is null;

Update msplayground..vgsales
SET Year = CAST (Right(Name, 4) as INT) -1
Where Year is null and ISNUMERIC(Right(Name, 4))=1 and Rank != 6285;

Select * From vgsales WHERE RANK = 6285;

--There are some games with unknown publishers
Select * From msplayground..vgsales Where Publisher = 'Unknown';

--Will fix publishers with the same way we fix years
Select a.Name as aName, b.Name as bName, a.Platform as aPlatfrom, b.Platform as bPlatform, a.Publisher as aPub, b.Publisher as bPub
From msplayground..vgsales a
JOIN msplayground..vgsales b
	ON a.Name = b.Name
	AND a.Rank <> b.Rank
Where a.Publisher = 'Unknown' and b.Publisher != 'Unknown';

Update a
SET Publisher = b.Publisher
From msplayground..vgsales a
JOIN msplayground..vgsales b
	ON a.Name = b.Name
	AND a.Rank <> b.Rank
Where a.Publisher = 'Unknown' and b.Publisher != 'Unknown';

Select * From msplayground..vgsales Where Year is null or Publisher ='Unknown';

--Top 10 games by global_sales
Select TOP 10 * From msplayground..vgsales Order By Global_Sales DESC;

--Count Games By Year
Select Year, Count(*) From msplayground..vgsales Group By Year Order By Year DESC;

--Publisher Total Sales
Select Publisher, Sum(Na_Sales) as NASales, Sum(EU_Sales) as EUSales, Sum(JP_Sales) as JPSales, Sum(Global_Sales) as PublisherTotalSales From msplayground..vgsales Group By Publisher Order By PublisherTotalSales DESC;

--Total Sales By Genre, Japans are really in love with Final Fantasy
Select Genre, Sum(Na_Sales) as NASales, Sum(EU_Sales) as EUSales, Sum(JP_Sales) as JPSales, Sum(Global_Sales) as TotalSales From msplayground..vgsales Group By Genre Order By TotalSales DESC;

--Sales By Platform
Select Platform, Sum(Na_Sales) as NASales, Sum(EU_Sales) as EUSales, Sum(JP_Sales) as JPSales, Sum(Global_Sales) as TotalSales From msplayground..vgsales Group By Platform Order By TotalSales DESC;

--and Genre
Select Platform, Genre, Sum(Na_Sales) as NASales, Sum(EU_Sales) as EUSales, Sum(JP_Sales) as JPSales, Sum(Global_Sales) as TotalSales From msplayground..vgsales Group By Platform, Genre Order By TotalSales DESC;

	
