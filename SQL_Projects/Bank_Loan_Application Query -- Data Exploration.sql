select * from Bank_loan_data

----------------------FOR DASHBOARD 1------------------------------------------
-- finding the Key Performance Indicator (KPI)

-- 1 -- Calculatin the Total Loan Application

SELECT COUNT(*) TOTAL_LOAN_APPLICATONS FROM [Bank Loan DB]..Bank_loan_data

-- Finding also for the month to date i.e the latest month
SELECT COUNT(*) MTD_TOTAL_LOAN_APPLICATIONS FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 12 AND YEAR(ISSUE_DATE) = 2021

-- Finding the month OVER month, i.e the previous month before the last month
SELECT COUNT(*) PMTD_TOTAL_LOAN_APPLICATIONS FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 11 AND YEAR(ISSUE_DATE) = 2021


-- 2 -- Calculating the Total Funded Ammount
SELECT SUM(loan_amount) TOTAL_FUNDED_AMOUNT FROM [Bank Loan DB]..Bank_loan_data

-- Finding also for the month to date i.e the latest month
SELECT SUM(loan_amount) MTD_TOTAL_FUNDED_AMOUNT FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 12 AND YEAR(ISSUE_DATE) = 2021

-- Finding the month OVER month, i.e the previous month before the last month
SELECT SUM(loan_amount) PMTD_TOTAL_FUNDED_AMOUNT FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 11 AND YEAR(ISSUE_DATE) = 2021


-- 3 -- Calculating the Total Ammount Recieved
SELECT SUM(total_payment) TOTAL_AMOUNT_RECEIVED FROM [Bank Loan DB]..Bank_loan_data

-- Finding also for the month to date i.e the latest month
SELECT SUM(total_payment) MTD_TOTAL_AMOUNT_RECEIVED FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 12 AND YEAR(ISSUE_DATE) = 2021

-- Finding the month OVER month, i.e the previous month before the last month
SELECT SUM(total_payment) PMTD_TOTAL_AMOUNT_RECEIVED FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 11 AND YEAR(ISSUE_DATE) = 2021

-- 4 -- Calculating the Average interest rate in percentage, both for MTD and Month over Month(PMTD)
SELECT ROUND(AVG(int_rate), 4)*100 AVERAGE_INTEREST_RATE FROM [Bank Loan DB]..Bank_loan_data

SELECT ROUND(AVG(int_rate), 4)*100 MTD_AVERAGE_INTEREST_RATE FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 12 AND YEAR(ISSUE_DATE) = 2021


SELECT ROUND(AVG(int_rate), 4)*100 PMTD_AVERAGE_INTEREST_RATE FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 11 AND YEAR(ISSUE_DATE) = 2021

-- 5 -- Calculating the Debt-to-income(DTI) ratio in percentage, both for MTD and Month over Month(PMTD)
SELECT ROUND(AVG(dti), 4)*100 AVERAGE_DTI FROM [Bank Loan DB]..Bank_loan_data 

SELECT ROUND(AVG(dti), 4)*100 MTD_AVERAGE_DTI FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 12 AND YEAR(ISSUE_DATE) = 2021


SELECT ROUND(AVG(dti), 4)*100 PMTD_AVERAGE_DTI FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(ISSUE_DATE) = 11 AND YEAR(ISSUE_DATE) = 2021

/*
----------- GOOD LOAN VS BAD LOAN KPI -----------------------
-- Good Loan are those loans with loan status 'Fully Paid' and 'Current.'
-- Bad Loan are those loans with loan status 'Charged Off.'
Note we shall be looking at the following
1. Good Loan Application Percentage: 
2. Good Loan Applications: 
3. Good Loan Funded Amount: 
4. Good Loan Total Received Amount: 

then
1. Bad Loan Application Percentage: 
2. Bad Loan Applications: 
3. Bad Loan Funded Amount: 
4. Bad Loan Total Received Amount: 
*/

--------------------------GOOD LOAN ----------------------------------------------------------------------
--1.... GOOd LOAN APPLICATION PERCENTAGE
SELECT 
	(COUNT(CASE WHEN loan_status = 'Fully Paid' or Loan_status = 'Current' THEN id END) * 100/
	COUNT(id)) GOOD_LOAN_PERCENTAGE
FROM [Bank Loan DB]..Bank_loan_data

--2.... GOOD LOAN APPLICATION 
SELECT 
	COUNT(CASE WHEN loan_status = 'Fully Paid' or Loan_status = 'Current'THEN ID END) GOOD_LOAN
FROM [Bank Loan DB]..Bank_loan_data

--3... GOOD LOAN FUNDED AMOUNT
SELECT SUM(LOAN_AMOUNT) GOOD_LOAN_FUNDED_AMOUNT FROM [Bank Loan DB]..Bank_loan_data
WHERE loan_status = 'Fully Paid' or Loan_status = 'Current'

--4... GOOD LOAN RECEIVED AMOUNT
SELECT SUM(total_payment) GOOD_LOAN_RECEIVED_AMOUNT FROM [Bank Loan DB]..Bank_loan_data
WHERE loan_status = 'Fully Paid' or Loan_status = 'Current'



--------------------------BAD LOAN ----------------------------------------------------------------------

--1.... BAD LOAN APPLICATION PERCENTAGE
SELECT 
	(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100/
	COUNT(id)) BAD_LOAN_PERCENTAGE
FROM [Bank Loan DB]..Bank_loan_data

--2.... BAD LOAN APPLICATION 
SELECT 
	COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) BAD_LOAN
FROM [Bank Loan DB]..Bank_loan_data

--3... BAD LOAN FUNDED AMOUNT
SELECT SUM(LOAN_AMOUNT) BAD_LOAN_FUNDED_AMOUNT FROM [Bank Loan DB]..Bank_loan_data
WHERE loan_status = 'Charged Off'

--4... BAD LOAN RECEIVED AMOUNT
SELECT SUM(total_payment) BAD_LOAN_RECEIVED_AMOUNT FROM [Bank Loan DB]..Bank_loan_data
WHERE loan_status = 'Charged Off'

--- NOW WE NEED TO FIND THE LOAN STATUS VIEW OF ALL THE KPI ---- A

SELECT LOAN_STATUS
	,COUNT(ID) TOTAL_LOAN_APPLICATION
	,SUM(loan_amount) TOTAL_FUNDED_AMOUNT
	,SUM(total_payment) TOTAL_AMOUNT_RECEIVED
	,AVG(int_rate)*100 AVERAGE_INTEREST_RATE
	,AVG(dti)*100 AVERAGE_DTI
FROM [Bank Loan DB]..Bank_loan_data
GROUP BY loan_status


--- NOW LETS PREPARE FOR THE MONTH TO MONTH BOTH FOR THE FUNDED AND RECEIVED ---- B

SELECT LOAN_STATUS
	,SUM(total_payment) MTD_TOTAL_RECEIVED_AMOUNT
	,SUM(loan_amount) MTD_TOTAL_FUNDED_AMOUNT
FROM [Bank Loan DB]..Bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
GROUP BY LOAN_STATUS




----------------------FOR DASHBOARD 2------------------------------------------
Select * from Bank_loan_data

---- 1 LOAN CHART SEASONAL ANALYSIS BY DATE
SELECT 
	MONTH(issue_date) MONTH_NUMBER
	,DATENAME(MONTH, ISSUE_DATE) MONTH_NAME
	,COUNT(ID) AS TOTAL_LOAN_APPLICATION
	,SUM(LOAN_AMOUNT) TOTAL_AMOUNT_FUNDED
	,SUM(total_payment) TOTAL_AMOUNT_RECEIVED
FROM [Bank Loan DB]..Bank_loan_data
GROUP BY MONTH(ISSUE_DATE),DATENAME(MONTH, ISSUE_DATE)
ORDER BY MONTH(ISSUE_DATE)

---- 2 LOAN MAP SEASONAL ANALYSIS BY STATE
SELECT 
	ADDRESS_STATE
	,COUNT(ID) AS TOTAL_LOAN_APPLICATION
	,SUM(LOAN_AMOUNT) TOTAL_AMOUNT_FUNDED
	,SUM(total_payment) TOTAL_AMOUNT_RECEIVED
FROM [Bank Loan DB]..Bank_loan_data
GROUP BY ADDRESS_STATE
ORDER BY SUM(LOAN_AMOUNT) DESC

---- 3 LOAN DONUT SEASONAL ANALYSIS BASED ON THE LOAN TERM, 36 AND 60 MONTHS
SELECT 
	TERM
	,COUNT(ID) AS TOTAL_LOAN_APPLICATION
	,SUM(LOAN_AMOUNT) TOTAL_AMOUNT_FUNDED
	,SUM(total_payment) TOTAL_AMOUNT_RECEIVED
FROM [Bank Loan DB]..Bank_loan_data
GROUP BY TERM
ORDER BY TERM

---- 4 LOAN BAR CHART ANALYSIS BASED ON THE EMPLOYEE LENGTH emp_length
SELECT 
	EMP_LENGTH
	,COUNT(ID) AS TOTAL_LOAN_APPLICATION
	,SUM(LOAN_AMOUNT) TOTAL_AMOUNT_FUNDED
	,SUM(total_payment) TOTAL_AMOUNT_RECEIVED
FROM [Bank Loan DB]..Bank_loan_data
GROUP BY EMP_LENGTH
ORDER BY COUNT(ID) DESC

---- 5 LOAN BAR CHART ANALYSIS BASED ON THE LOAN PURPOSE BREAKDOWN 
SELECT 
	PURPOSE
	,COUNT(ID) AS TOTAL_LOAN_APPLICATION
	,SUM(LOAN_AMOUNT) TOTAL_AMOUNT_FUNDED
	,SUM(total_payment) TOTAL_AMOUNT_RECEIVED
FROM [Bank Loan DB]..Bank_loan_data
GROUP BY PURPOSE
ORDER BY COUNT(ID) DESC

---- 6 LOAN TREE MAP ANALYSIS BASED ON THE HOME OWNERSHIP ANALYSIS
SELECT 
	HOME_OWNERSHIP
	,COUNT(ID) AS TOTAL_LOAN_APPLICATION
	,SUM(LOAN_AMOUNT) TOTAL_AMOUNT_FUNDED
	,SUM(total_payment) TOTAL_AMOUNT_RECEIVED
FROM [Bank Loan DB]..Bank_loan_data
WHERE GRADE = 'A' AND ADDRESS_STATE = 'CA'
GROUP BY HOME_OWNERSHIP
ORDER BY COUNT(ID) DESC



----------------------FOR DASHBOARD 3------------------------------------------
-- DISPLAY A GRID VIEW THAT SHOWS ALL THE DATA POINT IN THE DATASET
Select * from Bank_loan_data










