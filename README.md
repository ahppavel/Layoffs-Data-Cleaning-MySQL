# Layoffs-Data-Cleaning-MySQL
Data Cleaning Project using MySQL
# Layoffs Data Cleaning with MySQL

## Project Overview

This is a beginner SQL project where I worked with a company layoffs dataset to practise data cleaning using MySQL.

The goal was to clean the raw data and prepare it for further analysis.

## Tools Used
- MySQL
- MySQL Workbench
- SQL

## Data Cleaning Process

- Created staging tables to preserve the original data.
- Identified and removed duplicate records using `ROW_NUMBER()`.
- Standardized company, industry and country values.
- Corrected date formats using `STR_TO_DATE()`.
- Handled NULL and blank values.
- Used SELF JOIN to fill missing industry information where possible.
- Removed records with no layoff information.

## SQL Concepts Practiced

- SELECT, INSERT, UPDATE and DELETE
- CREATE TABLE and ALTER TABLE
- DISTINCT, WHERE and LIKE
- TRIM() and STR_TO_DATE()
- ROW_NUMBER() and PARTITION BY
- CTEs and SELF JOIN
- NULL handling

## What I Learned

I learned how to identify data quality issues, remove duplicates, handle missing values and prepare raw data for analysis using SQL.

## Project Status

Completed – Beginner Project.

## Acknowledgment

This project was inspired by a SQL data cleaning tutorial. I used it as a learning guide and practised the concepts through my own queries and experiments. 
