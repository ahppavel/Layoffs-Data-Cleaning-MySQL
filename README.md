# Layoffs-Data-Cleaning-MySQL
Data Cleaning Project using MySQL
# Layoffs Data Cleaning & Exploratory Data Analysis with MySQL

## Project Overview
This is a beginner SQL project where I worked with a company layoffs dataset. The goal was to clean the raw data, prepare it for analysis, and explore it to identify trends and patterns in company layoffs.

## Tools Used
- MySQL
- MySQL Workbench
- SQL

## Data Cleaning
- Created staging tables to preserve the original data.
- Identified and removed duplicate records using `ROW_NUMBER()`.
- Standardized company, industry, and country values.
- Corrected date formats using `STR_TO_DATE()`.
- Handled NULL and blank values.
- Used SELF JOIN to fill missing industry information where possible.
- Removed records with no layoff information.

## Exploratory Data Analysis (EDA)
- Identified maximum layoffs and layoff percentages.
- Analyzed layoffs by company, industry, country, and company stage.
- Explored yearly and monthly layoff trends.
- Identified companies with 100% workforce layoffs.
- Calculated monthly rolling totals using CTEs and Window Functions.
- Found the top 5 companies with the highest layoffs each year using `DENSE_RANK()`.

## SQL Concepts Practiced
- SELECT, INSERT, UPDATE, and DELETE
- CREATE TABLE and ALTER TABLE
- WHERE, GROUP BY, ORDER BY, and LIKE
- Aggregate Functions (`SUM()`, `MAX()`, `MIN()`)
- String and Date Functions
- ROW_NUMBER() and DENSE_RANK()
- CTEs and SELF JOIN
- Window Functions and Rolling Totals
- NULL Handling

## What I Learned
Through this project, I learned how to clean raw data, handle data quality issues, and use SQL to explore datasets, identify trends, and generate meaningful insights.

## Project Status
Completed – Data Cleaning and Exploratory Data Analysis using MySQL.

## Acknowledgment
This project was inspired by a SQL tutorial. I used it as a learning guide while practising the concepts through my own queries and experiments.
