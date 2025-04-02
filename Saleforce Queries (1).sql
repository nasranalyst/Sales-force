Create database Saleforce;
use saleforce;

select * from account;
select * from lead_table;
select * from opportunity_product;
select * from opportunity_table;
select * from user_table;

# Opportunity Dashboard
# Expected Amount
select concat(round(sum(ExpectedAmount)/1000000, 0), 'M') as Total_Expected_Amount 
from opportunity_table;

# Active Opportunities
select count(OpportunityID) as Open_Opportunity
from opportunity_table
where closed = 'False';

# Conversion Rate
# Win Rate
SELECT 
    (COUNT(CASE WHEN stage = 'Closed Won' THEN 1 END) * 100.0) / 
    COUNT(Stage) 
    AS conversion_rate
FROM opportunity_table;

# Loss Rate
SELECT 
    (COUNT(CASE WHEN stage = 'Closed Lost' THEN 1 END) * 100.0) / 
    COUNT(Stage) 
    AS conversion_rate
FROM opportunity_table;

# Trend Analysis
# Expected Vs Forcast
SELECT 
    YEAR(DATE_FORMAT(STR_TO_DATE(closedate, '%d-%m-%Y'), '%Y-%m-%d')) AS year,  
    SUM(expectedamount) AS total_expected_amount,
    SUM(amount) AS total_amount
FROM opportunity_table
GROUP BY YEAR(DATE_FORMAT(STR_TO_DATE(closedate, '%d-%m-%Y'), '%Y-%m-%d'))
ORDER BY year;

# Active Vs Total Opportunity
SELECT 
    YEAR(DATE_FORMAT(STR_TO_DATE(createddate, '%d-%m-%Y'), '%Y-%m-%d')) AS Year, 
    COUNT(DISTINCT OpportunityID) AS Total_Opportunities, 
    COUNT(DISTINCT CASE WHEN HasOpenActivity = 'True' THEN OpportunityID END) AS Active_Opportunities
FROM Opportunity_Table
GROUP BY YEAR(DATE_FORMAT(STR_TO_DATE(createddate, '%d-%m-%Y'), '%Y-%m-%d'))
ORDER BY Year;

# Closed Won Vs Total Opportunities
SELECT 
    YEAR(DATE_FORMAT(STR_TO_DATE(createddate, '%d-%m-%Y'), '%Y-%m-%d')) AS Year, 
    COUNT(DISTINCT OpportunityID) AS Total_Opportunities, 
    COUNT(DISTINCT CASE WHEN Stage = 'Closed Won' THEN OpportunityID END) AS Closed_Won
FROM Opportunity_Table
GROUP BY YEAR(DATE_FORMAT(STR_TO_DATE(createddate, '%d-%m-%Y'), '%Y-%m-%d'))
ORDER BY Year;

# Closed Won Vs Total Closed
SELECT
YEAR(DATE_FORMAT(STR_TO_DATE(createddate, '%d-%m-%Y'), '%Y-%m-%d')) AS Year, 
    COUNT(DISTINCT CASE WHEN Closed = 'True' THEN OpportunityID END) AS Total_Closed, 
    COUNT(DISTINCT CASE WHEN Stage = 'Closed Won' THEN OpportunityID END) AS Closed_Won
FROM Opportunity_Table
GROUP BY YEAR(DATE_FORMAT(STR_TO_DATE(createddate, '%d-%m-%Y'), '%Y-%m-%d'))
ORDER BY Year;

# Expected Amount by Opportunity Type
SELECT
DISTINCT(OpportunityType), SUM(ExpectedAmount) FROM opportunity_table
Group By OpportunityType;

# Opportunities by Industry
SELECT
DISTINCT(Industry), Count(OpportunityID) As Opportunities FROM opportunity_table
Group By Industry
order by COUNT(OpportunityID) DESC;


# Lead Dashboard
# Total Lead
SELECT COUNT(LeadID) from lead_table;

# Expected Amount from Converted Leads 
SELECT distinct CreatedbyLeadConversion, concat(round(sum(ExpectedAmount)/1000000, 0), 'M') As Expected_Amount
from opportunity_table
WHERE CreatedByLeadConversion = 'TRUE'
Group By CreatedbyLeadConversion;

# Converted Account
SELECT Count(ConvertedAccountID) from lead_table
WHERE ConvertedAccountID != 'NA';

# Conversion Rate
SELECT 
    (COUNT(CASE WHEN ConvertedAccountID != 'NA' THEN 1 END) * 100.0) / 
    COUNT(ConvertedAccountID) 
    AS conversion_rate
FROM lead_table;

# Converted Opportunities
SELECT Count(ConvertedOpportunityID) from lead_table
WHERE ConvertedOpportunityID != 'NA';

# Lead By Source
SELECT LeadSource, Count(LeadID) from lead_table
Group By LeadSource
order by Count(LeadID) desc;

# Lead By industry
SELECT Industry, Count(LeadID) from lead_table
Group By Industry;

# Lead by Stage
SELECT 
    l.Status, 
    o.Stage, 
    COUNT(l.LeadId) AS LeadCount
FROM Lead_table l
LEFT JOIN Opportunity_table o ON l.convertedOpportunityid = o.opportunityid
GROUP BY l.Status, o.Stage
ORDER BY l.Status, o.Stage;

