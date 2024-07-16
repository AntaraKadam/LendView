SELECT * FROM bank_loan

--total applications
SELECT COUNT(id) AS total_loan_appli FROM bank_loan

--applications at recent last month
SELECT COUNT(id) AS mtd_appli FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--applications month by month
SELECT COUNT(id) AS pmtd_appli FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--to get the diff like the rate of inc/dec = (mtd-pmtd)/pmtd



--total funded amount
SELECT SUM(loan_amount) AS total_fund_amt FROM bank_loan

--funded at recent month
SELECT SUM(loan_amount) AS total_fund_amt FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--funded month by month
SELECT SUM(loan_amount) AS ptotal_fund_amt FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021



--total amount received
SELECT SUM(total_payment) AS total_amt_received FROM bank_loan

--total amt last month
SELECT SUM(total_payment) AS mtd_total_amt_received FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--total amt month by month
SELECT SUM(total_payment) AS pmtd_total_amt_received FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


--avg interest rate
SELECT ROUND(AVG(int_rate), 4) * 100 AS avg_interest_rate FROM bank_loan

--avg last month
SELECT ROUND(AVG(int_rate), 4) * 100 AS mtd_avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--avg month by month
SELECT ROUND(AVG(int_rate), 4) * 100 AS pmtd_avg_interest_rate FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


--avg dti ratio
SELECT ROUND(AVG(dti), 4)*100 AS avg_dti FROM bank_loan

--avg dti last month
SELECT ROUND(AVG(dti), 4)*100 AS mtd_avg_dti FROM bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--avg dti month by month
SELECT ROUND(AVG(dti), 4)*100 AS mtd_avg_dti FROM bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021



--GOOD LOAN
--GD appli percentage i.e those with fully paid and current
SELECT (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)*100) /
       COUNT(id) AS good_loan_percent
FROM bank_loan

--GD applications 
SELECT (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END)) AS good_loan_appli
FROM bank_loan

--GD funded amount
SELECT SUM(loan_amount) AS gl_fund_amt FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--GD loan amt received
SELECT SUM(total_payment) AS gl_fund_amt FROM bank_loan
WHERE loan_status IN('Fully Paid', 'Current')



--BAD LOAN
--BD appli percentage i.e those with fully paid and current
SELECT (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)*100.0) /
       COUNT(id) AS bad_loan_percent
FROM bank_loan

--BD applications 
SELECT (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)) AS bad_loan_appli
FROM bank_loan

--BD funded amount
SELECT SUM(loan_amount) AS bl_fund_amt FROM bank_loan
WHERE loan_status = 'Charged Off'

--BD loan amt received
SELECT SUM(total_payment) AS bl_fund_amt FROM bank_loan
WHERE loan_status = 'Charged Off'



--LOAN STATUS GRID
SELECT
    loan_status,
	COUNT(id) AS LoanCount,
	SUM(total_payment) AS Total_amt_received,
	SUM(loan_amount) AS Total_funded_amt,
	AVG(int_rate*100) AS Interest_rate,
	AVG(dti*100) AS DTI
FROM bank_loan
GROUP BY loan_status



--OVERVIEW
SELECT
   loan_status,
   SUM(total_payment) AS Total_Amount_Reeived,
   SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan
WHERE MONTH(issue_date) = 12
GROUP BY loan_status

--monthly trends
SELECT
   MONTH(issue_date) AS Month_number,
   DATENAME(MONTH, issue_date) AS Issue_month,
   COUNT(id) AS Total_loan_applications,
   SUM(loan_amount) AS Total_funded_amount,
   SUM(total_payment) AS Total_received_amount
FROM bank_loan
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)

--regional analysis
SELECT
   address_state,
   DATENAME(MONTH, issue_date) AS Issue_month,
   COUNT(id) AS Total_loan_applications,
   SUM(loan_amount) AS Total_funded_amount,
   SUM(total_payment) AS Total_received_amount
FROM bank_loan
GROUP BY address_state, DATENAME(MONTH, issue_date)
ORDER BY COUNT(id) DESC

--longterm analysis
SELECT
   address_state,
   DATENAME(MONTH, issue_date) AS Issue_month,
   COUNT(id) AS Total_loan_applications,
   SUM(loan_amount) AS Total_funded_amount,
   SUM(total_payment) AS Total_received_amount
FROM bank_loan
GROUP BY address_state, DATENAME(MONTH, issue_date)
ORDER BY COUNT(id) DESC
