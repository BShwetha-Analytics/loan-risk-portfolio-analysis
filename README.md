# loan-risk-portfolio-analysis
Loan Risk & Portfolio Analysis using MySQL, Power BI, and Excel.
# Loan Risk & Portfolio Analysis

## Project Overview

This project analyzes a banking loan portfolio using **MySQL, Power BI, and Excel** to evaluate borrower risk, repayment behavior, portfolio exposure, and default trends.

The objective is to identify high-risk customer segments, uncover key drivers of default risk, monitor portfolio performance, and derive actionable business insights that support credit risk management and lending decisions.

The analysis was conducted on a synthetic dataset containing customer demographics, loan information, credit profiles, payment history, and risk indicators.

---

## Business Objectives

The project aims to answer the following business questions:

* Which customer segments exhibit the highest risk of default?
* How do credit score, debt-to-income ratio (DTI), and existing loan burden impact repayment behavior?
* Which loan products contribute the most to portfolio risk?
* Which geographic regions require additional portfolio monitoring?
* Which borrowers represent the largest concentration of credit exposure?
* Can borrowers be segmented into risk categories using a portfolio risk score?

---

## Dataset Overview

The dataset contains information related to:

### Customer Data

* Customer ID
* Customer Name
* Age
* Employment Type
* State
* Monthly Income
* Credit Score
* Existing Loan Count

### Loan Data

* Loan ID
* Loan Type
* Loan Amount
* Interest Rate
* Tenure
* EMI
* Debt-to-Income Ratio (DTI)
* Application Date
* Default Status

### Payment Data

* Payment ID
* Payment Status
* Payment Amount
* Payment Date

---

## Tools & Technologies

| Tool     | Purpose                                 |
| -------- | --------------------------------------- |
| MySQL    | Data Analysis & Querying                |
| Power BI | Dashboard Development                   |
| Excel    | Data Validation & Exploration           |
| GitHub   | Project Documentation & Version Control |

---

## SQL Concepts Demonstrated

This project showcases intermediate-level SQL skills, including:

* Joins
* Aggregations
* CASE Statements
* Common Table Expressions (CTEs)
* Window Functions
* ROW_NUMBER()
* RANK()
* DENSE_RANK()
* LAG()
* Risk Segmentation
* Business KPI Development
* Time-Series Analysis

---

## Analysis Performed

### Customer Analysis

* Customer distribution by state
* Customer distribution by employment type
* Average credit score by age group
* Existing loan burden analysis

### Loan Portfolio Analysis

* Loan portfolio composition
* Loan type distribution
* Average loan amount by category
* Exposure analysis

### Default Risk Analysis

* Default rate by credit score category
* Default rate by DTI category
* Impact of multiple loans on default behavior
* State-level default risk assessment

### Payment Behaviour Analysis

* Payment status distribution
* Late payment analysis
* Payment punctuality by employment type
* DTI impact on repayment behavior
* Geographic payment performance analysis

### Advanced SQL Analysis

* High-Risk Customer Identification
* Top Borrowers by Total Exposure
* Highest Borrower in Every State
* State Ranking by Default Rate
* EMI-to-Income Burden Analysis
* Above-State-Average Exposure Analysis
* Above-Average Credit Score Defaulters
* Loan Products Performing Worse Than Portfolio Average
* Month-over-Month Loan Application Trends
* Portfolio Risk Score Development

---

## Portfolio Risk Scoring Framework

A custom risk scoring model was developed using multiple borrower risk indicators.

| Risk Factor             | Condition          | Points |
| ----------------------- | ------------------ | ------ |
| Poor Credit Score       | Credit Score < 600 | 2      |
| High DTI Ratio          | DTI > 0.5          | 2      |
| Multiple Existing Loans | Existing Loans > 2 | 1      |
| Frequent Late Payments  | 3+ Late Payments   | 2      |
| Previous Default        | Defaulted Loan     | 3      |

Customers were segmented into:

* Low Risk
* Medium Risk
* High Risk

This framework provides a simplified credit-risk assessment approach for portfolio monitoring.

---

## Key Business Insights

### Credit Risk

* Borrowers with low credit scores and elevated DTI ratios demonstrate significantly higher risk profiles.
* Customers maintaining multiple loans exhibit increased default tendencies.

### Payment Behaviour

* Approximately 12.3% of borrowers have EMI obligations exceeding reported monthly income, indicating potential affordability concerns.
* Repeated late-payment patterns serve as strong early warning indicators of future repayment stress.

### Geographic Risk

* Certain states combine high default rates with large portfolio exposure, representing key areas requiring enhanced monitoring.

### Portfolio Exposure

* A small group of borrowers account for a disproportionately large share of total loan exposure.
* Concentrated exposure increases potential portfolio vulnerability if large borrowers experience repayment difficulties.

### Anomaly Detection

* Several customers default despite maintaining above-average credit scores, highlighting that credit score alone may not fully capture borrower risk.

---

## Power BI Dashboard

The Power BI dashboard provides interactive visualizations for:

* Portfolio Overview
* Default Risk Monitoring
* Payment Behaviour Analysis
* Geographic Risk Assessment
* Customer Risk Segmentation
* Portfolio Risk Score Distribution

Dashboard screenshots are available in the Images folder.

---

## Project Outcome

This project demonstrates the practical application of SQL and business analytics techniques in a banking and lending environment.

The analysis provides insights into borrower behaviour, portfolio concentration risk, payment performance, and default patterns while showcasing the use of advanced SQL concepts and risk-based decision-making frameworks.

---

## Author

**Shwetha B**

Aspiring Business Analyst | MIS Analyst | Data Analyst

Skills: SQL • Power BI • Excel • Business Analysis • Risk Analytics
