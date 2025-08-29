# Online Retail Dashboard (2011) Analysis

## Introduction
The goal of this project was to analyze online retail sales data for the year 2011, uncovering patterns in customer behavior, product demand, and revenue trends. Using Power BI, an interactive dashboard was developed to support decision-making by visualizing sales by country, time of day, month, and quarter.

## Data Acquisition and Preparation
The dataset was sourced from a retail transaction file containing details such as:

 - Invoice Date

 - Customer ID

 - Country

 - Quantity

 - Total Sales

The data was loaded into Power BI Desktop for cleaning, modeling, and visualization

## Data Cleaning

The raw dataset required preprocessing to ensure accuracy:

 - Removed missing or blank CustomerID entries.

 - Excluded cancelled transactions (negative or zero quantities).

 - Standardized column names (e.g., InvoiceDate - Date, Total_sales).

 - Filtered out the United Kingdom, as requested, to focus on international sales.

 - All necessary data cleaning and preparation were performed in MySQL before importing into Power BI for visualization.

## Data Processing

New calculated columns and measures were created in DAX for analysis:

 - Revenue = SUM(Total_Sales)

 - Revenue_2011 = CALCULATE(SUM(Total_Sales), YEAR(InvoiceDate) = 2011, Country <> "United Kingdom")

 - Quarter_Name (derived from InvoiceDate)

 - Time of Day bucketed into: Morning, Afternoon, and Evening.

## Data Analysis 

The following insights were visualized in the dashboard:

 - **Quantity & Revenue by Country:** Netherlands (£235K) and EIRE (£212K) lead sales, followed by France and Germany.

 - **Revenue by Time of Day:** Afternoon (£638K) and Morning (£535K) dominate sales, with negligible evening activity.

 - **Revenue by Month:** October (£170K) and November (£147K) peak due to holiday demand, while April (£41K) and December (£39K) are the lowest.

 - **Revenue by Quarter:** Q4 (£356K) and Q3 (£336K) outperform Q1 (£257K) and Q2 (£230K), showing strong second-half seasonality.

 - **Revenue by Customer ID:** A small group of customers drive disproportionately high sales.

## Visualization

The figure below shows the dashboard, which was built based on the analysis of the data.

|--------------|


