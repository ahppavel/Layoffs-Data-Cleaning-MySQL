SELECT * FROM layoffs;

-- REMOVE DUPLICATE VALUES
-- STANDARDIZE DATA
-- NULL VALUES AND BLANK VALUES
-- REMOVE ANY COLUMN OR ROW

-- (1ST- REMOVE DUPLICATE)

-- create a staging table the same structure as the orginal
CREATE TABLE Layoffs_staging
LIKE layoffs;

-- check now
SELECT * FROM Layoffs_staging;
-- copy all data
INSERT INTO Layoffs_staging
SELECT * FROM layoffs;

-- check again
SELECT * FROM Layoffs_staging;

-- find duplicate data
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) 
AS row_num
FROM Layoffs_staging;

-- using CTE to find duplicates
WITH CTE AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) 
AS row_num
FROM Layoffs_staging
)
-- now find duplicates where row_num greater than 1
SELECT * FROM CTE
WHERE row_num > 1;  

-- we can't directly delete from this CTE using  original. so...
-- create a second staging table

CREATE TABLE `Layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT -- new 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- or we can use 
CREATE TABLE Layoffs_staging2
LIKE Layoffs_staging;
ALTER TABLE Layoffs_staging2
ADD COLUMN row_num INT ;

-- now check 
SELECT * FROM Layoffs_staging2;

-- insert row numbers
 INSERT INTO Layoffs_staging2
 SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) 
AS row_num
FROM Layoffs_staging;
-- now check again
SELECT * FROM Layoffs_staging2;

-- delete duplicate values
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;
-- check againa]
SELECT * FROM layoffs_staging2;


-- DATA STANDARDIZATION
-- remove unnecessary spaces 
-- Remove unnecessary spaces from all text columns

UPDATE layoffs_staging2
SET
    company = TRIM(company),
    industry = TRIM(industry),
    location = TRIM(location),
    country = TRIM(country);
-- check company name
SELECT company, COUNT(*)
FROM layoffs_staging2
GROUP BY company
ORDER BY company;

SELECT * FROM layoffs_staging2;
-- location check 
SELECT DISTINCT location,COUNT(*)
FROM layoffs_staging2
GROUP BY location
ORDER BY location;
-- industry check 
SELECT DISTINCT industry,COUNT(*)
FROM layoffs_staging2
GROUP BY industry
ORDER BY industry;

UPDATE layoffs_staging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';

-- date + (text to date format)
SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');
SELECT * FROM layoffs_staging2;
ALTER TABLE layoffs_staging2
MODIFY `date` DATE;

-- stage
SELECT DISTINCT stage,COUNT(*)
FROM layoffs_staging2
GROUP BY stage
ORDER BY stage;

-- country
SELECT DISTINCT country,COUNT(*)
FROM layoffs_staging2
GROUP BY country
ORDER BY country;

UPDATE layoffs_staging2
SET country ='United States'
WHERE country ='United States.';

-- NULL AND BLANK VALUES

-- industry
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';
-- mising industry values using matching company records
UPDATE layoffs_staging2 T1
JOIN layoffs_staging2 T2
	ON T1.company=T2.company	
SET T1.industry = T2.industry
WHERE (T1.industry IS NULL OR T1.industry ='')
AND T2.industry IS NOT NULL;

-- no useful records
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- delete
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- REMOVE COLUMN
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- clean file
SELECT *
FROM layoffs_staging2;

-- EXPLORATORY DATA
-- total laid offs
 
SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 ASC  ;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT company,SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT stage,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS `month`,SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month` 
ORDER BY 1 ASC;

WITH Rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `month`,SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month` 
ORDER BY 1 ASC
)
SELECT `month`,total_off,SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM  Rolling_total;

SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year(company,years,total_laid_off) AS
(
SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
),Company_year_rank AS
(
SELECT *,DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
ORDER BY Ranking ASC
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5;

SELECT *
FROM layoffs_staging2;

































































































































