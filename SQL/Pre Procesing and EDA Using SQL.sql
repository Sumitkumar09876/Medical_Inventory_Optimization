/* Creating Table */
Create table MIO(
	Typeofsales varchar,
	Patient_ID Bigint,
	Specialisation varchar,
	Dept varchar,
	Dateofbill varchar,
	Quantity int,
	ReturnQuantity int,
	Final_Cost DOUBLE PRECISION,
	Final_Sales DOUBLE PRECISION,
	RtnMRP DOUBLE PRECISION,
	Formulation varchar,
	DrugName varchar,
	SubCat varchar,
	SubCat1 varchar
)
select * from mio
--Create view from MIO table
create view MioView as 
select * from MIO
-- Viewing data from MioView
select * from MioView
/* Data Preprocessing */
/*Describing Dataset */
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable
FROM
    information_schema.columns
WHERE
    table_name = 'mio' AND 	table_schema = 'public'	
-- checking duplicate values: 
select Dateofbill,patient_id, final_sales from MioView order by patient_id;
-- checking null values in a column
select * from MioView where patient_id is NULL
select * from MioView where specialisation is NULL
select * from MioView where dept is NULL
select * from MioView where dateofbill is NULL
select * from MioView where quantity is NULL
select * from MioView where returnquantity is NULL
select * from MioView where final_cost is NULL
select * from MioView where final_sales is NULL
select * from MioView where rtnmrp is NULL
select * from MioView where formulation is NULL -- contains null value
select * from MioView where drugname is NULL -- contains null values
select * from MioView where subcat is NULL -- contains null values
select * from MioView where subcat1 is NULL -- contains null values
-- Replacing Null Values with NA
-- replace NUll values in Formulation column
Update MioView set formulation = COALESCE(formulation, 'NA');
-- replace NUll values in drugname,subcat,subcat1 column
Update MioView 
set drugname = COALESCE(drugname, 'NA'),
	subcat = COALESCE(subcat,'NA'),
	subcat1 = COALESCE(subcat1,'NA');
--selecting Patient_id columns where durgname is NA
select patient_id,drugname from MioView where drugname = 'NA'
--Counting NA values
select 
count(CASE WHEN formulation = 'NA' then 1 END) as Formulation_NA_Count,
count(CASE WHEN drugname = 'NA' then 1 END) as Durgname_NA_Count,
count(CASE WHEN subcat = 'NA' then 1 END) as Subcat_NA_count,
count(case when subcat1 = 'NA' then 1 END) as Subcat1_NA_count
from MioView 
-- Formating date format
Update MioView
Set dateofbill = TO_CHAR(TO_DATE(dateofbill, 'MM/DD/YY'), 'DD/MM/YY')
WHERE dateofbill IS NOT NULL AND dateofbill != '';

select * from MioView;
-- selecting only patient id and date of bill, maximun quantity purchased and maximum final sales
select dateofbill,Patient_id,
max(quantity) as "Quantity" ,
max(final_sales) as "Final sales" 
from MioView group by patient_id,dateofbill order by dateofbill
/*feature Engineering */
-- adding a new column in other view
create view MioView1 as
select *,To_CHAR(to_date(dateofbill,'dd/mm/yy'),'Mon') as month from MioView
--selecting dateofbill and month values from MioView1
select dateofbill,month from MioView1
/* EDA analysis */
select * from MioView1
-- Descriptive statistics: 
-- Maximum quantity, minimum quantity, maximum return quantity, minimum return quantity, avg of quantity and return quantity and total quantity sales and return quantity
select Max(quantity) as "max quantity",
MIN(quantity) as "min quantity",
AVG(quantity) as "avg quantity",
count(quantity) as "no of countity",
MAX(returnquantity) as "max returnquantity",
MIN(returnquantity) as "min returnquantity",
AVG(returnquantity) as "avg returnquantity",
count(returnquantity) as " total returns"
from MioView1
--frequency of sales
SELECT typeofsales, COUNT(*) as frequency
FROM MioView1
GROUP BY typeofsales
ORDER BY frequency DESC;
-- First Moment Bussiness Desicions - Mean , Median, Mode
--Mean
select round(avg(quantity)) as "average quantity",
round(avg(returnquantity)) as "average returnquantity", 
round(avg(final_cost)) as "average final_cost",
round(avg(final_sales)) as "average final_sales",
round(avg(rtnmrp)) as "average of rtnmrp"
from MioView1
--Median
SELECT QUANTITY_MEDIAN AS QUANTITY_MEDIAN_VALUE,
RETURNQUANTITY_MEDIAN AS RETURNQUANTITY_MEDIAN_VALUE,
FINAL_COST_MEDIAN AS FINAL_COST_MEDIAN_VALUE,
FINAL_SALES_MEDIAN AS FINAL_SALES_MEDIAN_VALUE,
RTNMRP_MEDIAN AS RTNMRP_MEDIAN_VALUE
FROM
(
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY quantity) AS median
FROM
  MioView1) AS QUANTITY_MEDIAN,
(SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY RETURNQUANTITY) AS MEDIAN
FROM
	MioView1) AS RETURNQUANTITY_MEDIAN,
(SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_cost) AS MEDIAN
FROM
	MioView1) AS FINAL_COST_MEDIAN,
(SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_sales) AS MEDIAN
FROM
	MioView1) AS FINAL_SALES_MEDIAN,
(SELECT 
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rtnmrp) AS MEDIAN
FROM
	MioView1) AS RTNMRP_MEDIAN

--mode
select quantity_mode as quantity_mode_value,
return_mode as returnquantity_mode_value,
finalcost_mode as final_cost_mode_value,
finalsales_mode as final_sales_mode_value,
rtnmrp_mode as rtnmrp_mode_valuw
from
(SELECT quantity AS mode_value, COUNT(*) AS frequency
FROM MioView1
GROUP BY quantity
ORDER BY COUNT(*) DESC
LIMIT 1) as quantity_mode,
(SELECT returnquantity AS mode_value, COUNT(*) AS frequency
FROM MioView1
GROUP BY returnquantity
ORDER BY COUNT(*) DESC
LIMIT 1) as return_mode,
(SELECT final_cost AS mode_value, COUNT(*) AS frequency
FROM MioView1
GROUP BY final_cost
ORDER BY COUNT(*) DESC
LIMIT 1) as finalcost_mode,
(SELECT final_sales AS mode_value, COUNT(*) AS frequency
FROM MioView1
GROUP BY final_sales
ORDER BY COUNT(*) DESC
LIMIT 1) as finalsales_mode,
(SELECT rtnmrp AS mode_value, COUNT(*) AS frequency
FROM MioView1
GROUP BY rtnmrp
ORDER BY COUNT(*) DESC
LIMIT 1) as rtnmrp_mode
--Second Moment Business Decision: 
-- Variance: 
select variance(quantity::numeric) as variance_quantity,
variance(returnquantity::numeric) as variance_returnquantity,
variance(final_cost) as variance_final_cost,
variance(final_sales) as variance_final_sales,
variance(rtnmrp) as variance_rtnmrp
from MioView1
-- standard Deviation: 
select stddev(quantity::numeric) as stdev_quantity,
stddev(returnquantity::numeric) as stdev_returnquantity,
stddev(final_cost) as stdev_final_cost,
stddev(final_sales) as stdev_final_sales,
stddev(rtnmrp) as stdev_rtnmrp
from MioView1
-- Range
select 
max(quantity) - min(quantity) as range_of_quantity,
max(returnquantity) - min(returnquantity) as range_of_returnquantity,
max(final_cost) - min(final_cost) as range_of_final_cost,
max(final_sales) - min(final_sales) as range_of_final_sales,
max(rtnmrp) - min(rtnmrp) as range_of_rtnmrp
from MioView1;

-- Thrid Movement Business Decision
-- Skewness
-- Calculate skewness for a numerical column 
WITH moments1 AS (
    SELECT
        AVG(quantity) AS mean_quantity,
        STDDEV(quantity) AS stddev_quantity,
		AVG(returnquantity) as mean_returnquantity,
		STDDEV(returnquantity) as stddev_returnquantity,
		AVG(final_cost) as mean_final_cost,
		STDDEV(final_cost) as stddev_final_cost,
		AVG(final_sales) as mean_final_sales,
		STDDEV(final_cost) as stddev_final_sales,
		AVG(rtnmrp) as mean_rtnmrp,
		STDDEV(rtnmrp) as stddev_rtnmrp	
    FROM MioView1
)
SELECT
	--quantity as quantity,
    SUM(POWER(quantity - mean_quantity, 3)) / (COUNT(*) * POWER(stddev_quantity, 3)) AS skewness_for_quantity,
    SUM(POWER(returnquantity - mean_returnquantity, 3)) / (COUNT(*) * POWER(stddev_returnquantity, 3)) AS skewness_for_returnquantity,
    SUM(POWER(final_cost - mean_final_cost, 3)) / (COUNT(*) * POWER(stddev_final_cost, 3)) AS skewness_for_final_cost,
    SUM(POWER(final_sales - mean_final_sales, 3)) / (COUNT(*) * POWER(stddev_final_sales, 3)) AS skewness_for_final_sales,
    SUM(POWER(rtnmrp - mean_rtnmrp, 3)) / (COUNT(*) * POWER(stddev_rtnmrp, 3)) AS skewness_for_rtnmrp

FROM
    MioView1, moments1
GROUP BY stddev_quantity,stddev_returnquantity,stddev_final_cost,stddev_final_sales,stddev_rtnmrp;
-- Kurtoris
WITH moments AS (
  SELECT
    AVG((quantity - (select avg(quantity)from MioView1))::NUMERIC ^ 4) AS fourth_moment1,
    AVG((quantity - (select avg(quantity)from MioView1))::NUMERIC ^ 2) AS second_moment1,
    AVG((returnquantity - (select avg(returnquantity)from MioView1))::NUMERIC ^ 4) AS fourth_moment2,
    AVG((returnquantity - (select avg(returnquantity)from MioView1))::NUMERIC ^ 2) AS second_moment2,
    AVG((final_cost - (select avg(final_cost)from MioView1))::NUMERIC ^ 4) AS fourth_moment3,
    AVG((final_cost - (select avg(final_cost)from MioView1))::NUMERIC ^ 2) AS second_moment3,
    AVG((final_sales - (select avg(final_sales)from MioView1))::NUMERIC ^ 4) AS fourth_moment4,
    AVG((final_sales - (select avg(final_sales)from MioView1))::NUMERIC ^ 2) AS second_moment4,
    AVG((rtnmrp - (select avg(rtnmrp)from MioView1))::NUMERIC ^ 4) AS fourth_moment5,
    AVG((rtnmrp - (select avg(rtnmrp)from MioView1))::NUMERIC ^ 2) AS second_moment5
  FROM
    MioView1
)
SELECT
  fourth_moment1 / (second_moment1 ^ 2) AS kurtosis_for_quantity,
  fourth_moment2 / (second_moment2 ^ 2) AS kurtosis_for_returnquantity,
  fourth_moment3 / (second_moment3 ^ 2) AS kurtosis_for_final_cost,
  fourth_moment4 / (second_moment4 ^ 2) AS kurtosis_for_final_sales,
  fourth_moment5 / (second_moment5 ^ 2) AS kurtosis_for_rtmrp

FROM
  moments;
-- Analysis
select * from MioView1 where typeofsales = 'Return'
-- Bounce rate analysis
-- total Distinct patients
select count(Distinct patient_id) from MioView1
-- patient_id count where type of sale is return
select count(Distinct patient_id), typeofsales from MioView1 where typeofsales = 'Return' group by typeofsales
-- patient_id count where type of sale is sale
select count(Distinct patient_id), typeofsales from MioView1 where typeofsales = 'Sale' group by typeofsales
-- Overall Bounce Rate
SELECT
  COUNT(DISTINCT patient_id) AS total_patients,
  COUNT(DISTINCT CASE WHEN returnquantity > 0 THEN patient_id END) AS returning_patients,
  (COUNT(DISTINCT CASE WHEN returnquantity > 0 THEN patient_id END) * 100.0) / COUNT(DISTINCT patient_id) AS bounce_rate
FROM MioView1;

-- bounce rate by specilization
select
specialisation,
count(distinct patient_id) as total_patients,
count(Distinct case when returnquantity > 0 then patient_id end) as returing_patients,
(count(Distinct case when returnquantity > 0 then patient_id end)*100)/count(distinct patient_id) as Bounce_rate
from MioView1
group by specialisation
-- subcat and returned final_cost where type of sales is return
select subcat,round(sum(final_cost)) as total_cost from MioView where typeofsales = 'Return' group by subcat order by total_cost Desc
--Q6) find the number of durgs in each subcat that have been returned without making a sale
select subcat, 
count(distinct drugname) as no_of_returned_drugs
from MioView1
where typeofsales = 'Return' and final_sales = 0
group by subcat
order by no_of_returned_drugs desc
-- return items based on month
select month,count(*) as return_count
from MioView1
where typeofsales = 'Return'
group by month
order by return_count Desc
-- total sales when sales is return
select typeofsales,
sum(final_sales) as total_final_sales
from MioView1
group by typeofsales
-- drugname which are mostly return
select drugname, count(*) as return_count
from MioView1
where returnquantity > 0
group by drugname
order by return_count Desc
limit 10
-- Relation between quantity and total sales
SELECT
  CORR(quantity, final_sales) AS correlation
FROM MioView1;
-- Average Sales based on Sepcialisation
SELECT
  specialisation,
  ROUND(AVG(final_sales)) AS avg_sales
FROM MioView
GROUP BY specialisation
ORDER BY avg_sales DESC;
-- Total sales based on month 
select month,round(avg(final_sales)) as avg_sales from MioView1 group by month order by avg_sales Desc
-- average quantity of durg purchases
select drugname,round(Avg(quantity)) as AVG_quantity from MioView1 group by drugname
-- Frequency of return quantity
select returnquantity,count(*) as frequency
from MioView1
where returnquantity > 0 
group by returnquantity
order by returnquantity