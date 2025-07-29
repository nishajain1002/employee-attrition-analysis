create database employee_attrition;
use employee_attrition;

#BASIC ANALYSIS

#1.How many total employees are there?
select count(*) from employee_attrition;

#2.How many employees have left the company?
SELECT COUNT(*) AS LeftEmployees
FROM employee_attrition
WHERE Attrition = 'Yes';

#3.What is the attrition rate (percentage)?
SELECT 
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM employee_attrition;

#4.How many employees are older than 40
SELECT COUNT(*)
FROM employee_attrition
WHERE Age > 40;

#5.Show the list of employees who have worked for more than 10 years.
SELECT *
FROM employee_attrition
WHERE TotalWorkingYears > 10;

#6.Show attrition count by department.
SELECT Department
FROM employee_attrition
WHERE Attrition = 'Yes'
GROUP BY Department;

#7.Show attrition count by job role.
SELECT JobRole
FROM employee_attrition
WHERE Attrition = 'Yes'
GROUP BY JobRole;

#8.Show average monthly income by department.
SELECT Department,
ROUND(AVG(MonthlyIncome),2)
FROM employee_attrition
GROUP BY Department;

#9.Show average total working years by education field.
SELECT EducationField,
ROUND(AVG(TotalworkingYears),2)
FROM employee_attrition
GROUP BY EducationField;

#10.Show number of employees by marital status.
select MaritalStatus, count(*) 
from employee_attrition
group by Maritalstatus;

#ATTRITION-SPECIFIC


#11.Count how many employees with overtime left the company.
SELECT COUNT(Attrition) as left_with_overtime
from employee_attrition
where Overtime= 'Yes';

#12.Find the average income of employees who left vs. who stayed.
SELECT Attrition, ROUND(AVG(MonthlyIncome), 2)
FROM employee_attrition
GROUP BY Attrition;

#13.Classify employees into salary bands (low, medium, high) based on MonthlyIncome.
SELECT EmployeeNumber, MonthlyIncome,
  CASE 
    WHEN MonthlyIncome < 3000 THEN 'Low'
    WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
    ELSE 'High'
  END AS SalaryBand
FROM employee_attrition;

SELECT
  CASE 
    WHEN MonthlyIncome < 3000 THEN 'Low'
    WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
    ELSE 'High'
  END AS SalaryBand,
  COUNT(*) AS EmployeeCount
FROM employee_attrition
GROUP BY
  CASE 
    WHEN MonthlyIncome < 3000 THEN 'Low'
    WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
    ELSE 'High'
  END;
  
  #14.Create a flag for "high risk" employees (low satisfaction + overtime + short tenure).
  SELECT 
  CASE 
    WHEN JobSatisfaction <= 2 AND YearsAtCompany < 2 THEN 'High Risk'
    ELSE 'Normal'
  END AS RiskLevel,
  count(*) as EmployeeCount
FROM employee_attrition
group by
case
WHEN JobSatisfaction <= 2 AND YearsAtCompany < 2 THEN 'High Risk'
    ELSE 'Normal'
    end;
    
    #15. Classify work-life balance as 'Poor', 'Average', 'Good', 'Excellent' using CASE
    SELECT 
  CASE 
    WHEN WorkLifeBalance = 1 THEN 'Poor'
    WHEN WorkLifeBalance = 2 THEN 'Average'
    WHEN WorkLifeBalance = 3 THEN 'Good'
    WHEN WorkLifeBalance = 4 THEN 'Excellent'
    ELSE 'Unknown'
  END AS WorkLifeCategory,
  count(*) as EmployeeCount
FROM employee_attrition
group by 
case
WHEN WorkLifeBalance = 1 THEN 'Poor'
    WHEN WorkLifeBalance = 2 THEN 'Average'
    WHEN WorkLifeBalance = 3 THEN 'Good'
    WHEN WorkLifeBalance = 4 THEN 'Excellent'
    ELSE 'Unknown'
    end;
    
    #16.Is attrition higher for employees with no stock options?
    SELECT StockOptionLevel,
       COUNT(*) AS total_employees, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END),
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as attrition_count
FROM employee_attrition
GROUP BY StockOptionLevel;

#17.Is attrition more common in employees with fewer training sessions?
SELECT TrainingTimesLastYear,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear;

#18.Which job role has the highest attrition rate?
SELECT JobRole,
       COUNT(*) AS total_employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY JobRole
ORDER BY attrition_rate DESC
LIMIT 1;

#19.Which age group has the most attrition?
SELECT 
  CASE 
    WHEN Age < 25 THEN 'Under 25'
    WHEN Age BETWEEN 25 AND 35 THEN '25-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age > 45 THEN '45+'
  END AS Age_Group,
  COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM employee_attrition
GROUP BY Age_Group
ORDER BY attrition_count DESC;

#20.Is attrition rate different by gender?


#ADVANCED QUERIES & RANKING


#21.Rank employees by monthly income within each department.
SELECT EmployeeNumber,
       Department,
       MonthlyIncome,
       RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS Income_Rank
FROM employee_attrition;

#22.Calculate cumulative attritions by years at company.
SELECT YearsAtCompany,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
       SUM(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) OVER (ORDER BY YearsAtCompany) AS cumulative_attritions
FROM employee_attrition
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;

#23.Show the top 3 job roles with highest attrition per department.
SELECT Department, 
JobRole, 
COUNT(*) AS Attrition_Count
FROM employee_attrition
WHERE Attrition = 'Yes'
GROUP BY Department, JobRole
ORDER BY Department,Attrition_Count DESC;

# 24.List employees who haven’t had a promotion in the last 5 years.
SELECT * 
FROM employee_attrition
WHERE YearsSinceLastPromotion >= 5;

#25.Show average MonthlyIncome per Education level.
SELECT Education, ROUND(AVG(MonthlyIncome), 2) AS AvgSalary
FROM employee_attrition
GROUP BY Education;

#26.List employees who have worked in more than 3 companies.
SELECT * 
FROM employee_attrition
WHERE NumCompaniesWorked > 3;

#27.Find job roles where the average working years is greater than 10.
SELECT JobRole, ROUND(AVG(TotalWorkingYears), 2) AS AvgWorkingYears
FROM employee_attrition
GROUP BY JobRole
HAVING AVG(TotalWorkingYears) > 10;

#28.Which Department has the highest number of senior employees (Age > 50)?
SELECT Department, COUNT(*) AS SeniorCount
FROM employee_attrition
WHERE Age > 50
GROUP BY Department
ORDER BY SeniorCount DESC;

#29.Compare average attrition rate of single vs married employees.
SELECT MaritalStatus,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM employee_attrition
GROUP BY MaritalStatus;

#30.Show the top 5 highest paid employees in each department.
SELECT *
FROM (
  SELECT *, 
         DENSE_RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS rnk
  FROM employee_attrition
) AS ranked
WHERE rnk <= 5;

#31.Find employees who earn more than the department average.
SELECT e.EmployeeNumber, e.Department, e.MonthlyIncome
FROM employee_attrition e
JOIN (
  SELECT Department, AVG(MonthlyIncome) AS DeptAvg
  FROM employee_attrition
  GROUP BY Department
) AS dept_avg
ON e.Department = dept_avg.Department
WHERE e.MonthlyIncome > dept_avg.DeptAvg;

#32.Show monthly income quartiles (1st, 2nd, 3rd)
SELECT EmployeeNumber, MonthlyIncome,
       NTILE(4) OVER (ORDER BY MonthlyIncome) AS Income_Quartile
FROM employee_attrition;

#33.What percentage of employees have job satisfaction of 4?
SELECT 
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employee_attrition), 2) AS Satisfaction_4_Percent
FROM employee_attrition
WHERE JobSatisfaction = 4;

#34.Find departments with employees having more than 5 years in current role but no promotion.
SELECT Department, COUNT(*) AS Count
FROM employee_attrition
WHERE YearsInCurrentRole > 5 AND YearsSinceLastPromotion = 0
GROUP BY Department;
























    











