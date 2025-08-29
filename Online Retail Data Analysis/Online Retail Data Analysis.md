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

 - **Quantity & Revenue by Country:** Netherlands ($235K) and EIRE ($201K) lead sales, followed by France and Germany.

 - **Revenue by Time of Day:** Afternoon ($626K) and Morning ($526K) dominate sales, with negligible evening activity.

 - **Revenue by Month:** October ($169K) and November ($143K) peak due to holiday demand, while April ($41K) and December ($38K) are the lowest.

 - **Revenue by Quarter:** Q4 ($351K) and Q3 ($327K) outperform Q1 ($253K) and Q2 ($225K), showing strong performance on the Q4 and Q3 seasonality.

 - **Revenue by Customer ID:** A small group of customers drive disproportionately high sales.

## Visualization

The figure below shows the dashboard, which was built based on the analysis of the data.

|Figure: Online Retail Dashboard (2011)|
|--------------|

<img width="608" height="340" alt="online sales dashboard" src="https://github.com/user-attachments/assets/1b50c09a-2ad8-47ce-99e0-6cbc3feabd97" />

## Data Insight

**Key findings:**

 - **Top Markets:** Netherlands and EIRE are the largest contributors.

 - **Seasonality:** Q3 and Q4 show strong demand due to seasonal shopping trends.

 - **Time of Day:** Afternoon and Morning are peak transaction times, suggesting optimal engagement windows.

 - **Customer Base:** Revenue is concentrated among a few high-value customers, highlighting potential for loyalty programs.

## Recommendations

Based on the analysis:

**1. Inventory Optimization -** Align stock levels with seasonal demand by ramping up inventory before Q4 holiday sales, ensuring product availability during peak shopping periods.

**2. Global Expansion -** Prioritize international growth in the top 10 high-demand non-UK countries, tailoring logistics and marketing strategies to regional consumer behavior.

**3. Customer Retention Strategy -** Develop loyalty and rewards programs for the highest revenue-generating customers, coupled with personalized offers to strengthen relationships and reduce churn.

**4. Targeted Marketing Campaigns -** Focus promotional efforts on Afternoon and Morning peak hours, when customers are most active, to maximize conversion rates and revenue impact.

