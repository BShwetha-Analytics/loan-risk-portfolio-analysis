/*Loan Risk & Payment Behavior Analysis*/

create database loan_risk;
use loan_risk;
CREATE TABLE customers(
customer_id varchar (10),
customer_name varchar(20),
age int,
gender varchar(10),
city varchar(20),
state varchar(20),
education varchar(30),
employment_type varchar(30),
marital_status varchar(30),
dependents int,
home_ownership varchar(20),
monthly_income int,
credit_score int,
existing_loans_count int);
drop table customers;
create table loans(
loan_id varchar (10),
customer_id varchar(10),
loan_type varchar(30),
loan_amount float,
tenure_months int,
interest_rate float,
emi float,
application_date date,
purpose varchar(30),
dti_ratio float,
loan_status varchar(10),
is_default boolean);
drop table loans;
create table payments(
payment_id varchar(10),
loan_id varchar(10),
payment_date date,
amount_paid decimal(10,2),
payment_status varchar(10),
month_number int);
LOAD DATA LOCAL INFILE 'C:/Users/ShweShri/OneDrive/Desktop/SHWETHA/SQL/payment.csv'
INTO TABLE payments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
drop table payments;
# PORTFOLIO OVERVIEW #
/* Section 1: Overall loan portfolio */
# 1.How many customers are there? #
select count(customer_id) as total_no_of_custoemrs
from customers;

# there are 60,000 customers #

/*How many loans have been issued?*/
select count(loan_id) as total_no_of_loans
from loans;

/* 60,000 loans have been issued */

/*What is the total loan amount disbursed? */
select sum(loan_amount) as total_loan_amount 
from loans;

/* A total of Rs.6282,85,33,100 has been issued as loans */

/*What is the average loan amount?*/
select avg(loan_amount) as avg_loan_amount
from loans;

/*Rs.1047142.2183333334 is the average loan amount*/

/*What is the overall default rate?*/

with loan_factors as (select count(loan_id) as total_loans,count( case when is_default=1 then 1 end) as total_defaulters
from loans)
select (total_loans/total_defaulters) as default_rate
from loan_factors;

/* the default ratio is 3.23 which ius slightly above the usual range of 1-3% indicating that it might become difficult for some consumers to pay off their debt*/

/*What is the average credit score?*/
select avg(credit_score) as average_credit_score
from customers;

/*the average credit score is about 601 which is below an acccpetable range of 670-740 incdicating that the most of the consumers show a higher risk to default and their debts should be monitored rigorously*/



/*Section 2: Customer Segmentation */



/*Customer distribution by state.*/
select state,count(customer_id) as no_of_customers
from customers
group by state;

/* Maharashtra is the state with the most number of customers for this bank where around 11277 customers have loans */

/*Customer distribution by employment type.*/
select employment_type,count(customer_id) as no_of_customers
from customers
group by employment_type;

/* Around 30092 customers are salaried people, followed by 14805 customers who are self_employed who have got a loan from this bank*/

/*Average income by employment type.*/
select employment_type,avg(monthly_income) as average_income
from customers
group by employment_type;

/* The averge income of a business owner is the highest of about Rs 80016 followed by the self-employed customers who have an average income of about Rs 67695 */

/*Average credit score by education level.*/
select education,avg(credit_score) as average_credit_score
from customers
group by education;

/* customers having a graduate and a high school level of education have the lowest credit score showing a high risk */
/*Which age group borrows the most?*/
select count( case when age between 18 and 30 then 1 end) as "Young",
count(case when age between 30 and 60 then 1 end) as "Middle_Aged",
count(case when age>60 then 1 end) as "Senior_citizen"
from customers;
 
 /* The People with age group of 30-60 are the highest number customers of about 37240 of them who have borrowed a loan from the bank for personal and other financial commitments*/
 
/*Which age group has the highest average credit score?*/
select 
case when age between 18 and 30 then 'Young'
when age between 30 and 60 then 'Middle_Aged'
else 'Senior_Citizen'
end as age_group,
round(avg(credit_score),2) as average_credit_score
from customers
group by age_group
order by average_credit_score desc;

/* the customers falling in the younger age group section have the least creditscore 
indicating that their risk is higher and requires close monitoring and other age groups are higher but 
still fall under the accpetable credit score categories thus the overall rosk profile for this set of customers is higher.*/


/*Section 3: Loan Portfolio Analysis

What kinds of loans are customers taking?*/


/*Loan distribution by loan type.*/

select loan_type,count(loan_id) as no_of_loans
from loans
group by loan_type;

/*around 21022 customers take loans for persoanl life commitments and around 12049 people for buying a home */

/*Total loan amount by loan type.*/
select loan_type,sum(loan_amount) as total_loan_amount
from loans
group by loan_type;

/*Home loans are the highest loans with around Rs 36114048100 being lent to the customers */


/*Average interest rate by loan type.*/

select loan_type, round(avg(interest_rate),2) as average_interest
from loans
group by loan_type;

/* average interest rates for personal loans is about 16.48% and for business loans it is about 15.47%, Home loans are being given at a lower interest rate of about 10.97%*/


/*Average EMI by loan type.*/
select avg(emi) as average_emi 
from loans;

/*On an average the bank recieves a loan EMI of Rs 25202.33 */
 
 
/*Which loan purpose accounts for the largest share?*/
select loan_type,count(loan_id) as no_of_loans
from loans
group by loan_type;

/* personal loans are the highest number of loans availed by customers totalling upto 21022 loans followed by home loans which are 12049*/

/*Which loan type has the largest average loan amount?*/

select loan_type, avg(loan_amount) as average_loan_amount
from loans
group by loan_type;

/* Home loans share the highest average loan amount of about Rs 29,97,265 */

/*Section 4: Risk Analysis */


/*Which customer segments exhibit higher default risk?

Q1. Default rate by loan type*/
with default_rate as (select loan_type, count(loan_id) as total_loans,count(case when is_default = 1 then 1 end) as defaulter
from loans
group by loan_type)
select loan_type,((defaulter/total_loan)*100) as default_rate
from default_rate
group by loan_type;


/*Personal loans show higher default rates compared with mortgage loans.*/

/*Q2. Default rate by employment type*/
with default_rate as (
select c.employment_type,count(l.loan_id) as total_loan,count( case when l.is_default =1 then 1 end) as defaulter
from loans l
join customers c
on c.customer_id=l.customer_id
group by c.employment_type)
select d.employment_type,((defaulter/total_loan)*100) as default_rate
from default_rate d
group by d.employment_type;

/*Insight:

Self-employed borrowers display elevated default rates.*/

/*Q3. Credit score category analysis*/

/*Which category defaults the most?*/

select case when c.credit_score > 700 then 'Good:>700'
			when c.credit_score between 600 and 700 then 'Average:600-700'
            else 'Poor:<600' end as credit_category,
count(*) as total_loans,sum(l.is_default) as defaulter,
round(100*(sum(l.is_default)/count(*)),2) as default_rate
from loans l
join customers c
on c.customer_id=l.customer_id
group by credit_category
order by default_rate desc;

/*Insight:
Borrowers with credit scores below 600 contribute disproportionately to defaults.*/

/*Q4. DTI Risk Analysis
Create:
Low Risk <0.3
Moderate 0.3-0.5
High 0.5-0.7
Very High >0.7*/

/*Does default rate increase with DTI?*/

select case when dti_ratio <0.3 then 'Low_Risk'
	when dti_ratio between 0.3 and 0.5 then 'Moderate'
    when dti_ratio between 0.5 and 0.7 then 'High'
    else 'Very High'
    end as DTI_Category,
    count(*) as total_loan,sum(is_default) as defaulter,
    round(100*(sum(is_default)/count(*)),2) as default_rate
    from loans
    group by DTI_Category
    order by default_rate;
/*Insight:

Default rates increase significantly among borrowers whose DTI exceeds 50%.*/

/*Q5. Existing Loans vs Default

Question:

Do customers with multiple existing loans exhibit higher risk?*/

select case when c.existing_loans_count = 0 then 'No loans'
  when c.existing_loans_count =1 then '1 loan'
  when c.existing_loans_count between 2 and 3 then '2-3 loans'
  else '4+ loans'
  end as loan_category,
  count(*) as total_loans,
  sum(l.is_default) as defaulter,
  round(100*(sum(l.is_default)/count(*)),2) as default_rate
  from loans l
  join customers c
  on c.customer_id=l.customer_id
  group by loan_category
  order by default_rate desc;
  
  
SELECT
    c.existing_loans_count,
    COUNT(*) AS total_loans,
    SUM(l.is_default) AS defaulters,
    ROUND(100 * SUM(l.is_default) / COUNT(*),2) AS default_rate
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY c.existing_loans_count
ORDER BY c.existing_loans_count;
  
/*Section 5: Payment Behaviour Analysis
Can repayment behaviour indicate future default risk?*/

/*Distribution of payment statuses.*/
select payment_status,count(*) as payment_made,round(100*count(*)/(select count(*) from payments),2) as percentage
from payments
group by payment_status;

/*Around 81.5% of customers have made loan repayments on time and about 8.5% have missed payments and close to 9.9% customers have made late payments */

/*Average amount paid by payment status.*/
select payment_status,round(avg(amount_paid),2) as avg_amt_paid
from payments
group by payment_status;

/*Which loan type has the most late payments?*/
select l.loan_type,count(*) as payment_made,round(100*count(*)/(select count(*) from payments),2) as percentage
from payments p
join loans l on l.loan_id=p.loan_id
where p.payment_status='Late'
group by l.loan_type;

/*Personal loan holders make the most late payments followed by customers holding a home loan, these categories require additional monitoring and due diligence while disbursing loans*/

/*
Which customers consistently make late payments?*/
select c.customer_id,c.customer_name,count(*) as total_payments,
sum(case when payment_status='Late' then 1 else 0 end) as late_payment,
round(100* sum( case when payment_status='Late' then 1 else 0 end)/count(*),2) as late_payment_rate
from customers c
join loans l on l.customer_id=c.customer_id
join payments p on p.loan_id=l.loan_id
group by c.customer_name,c.customer_id
having late_payment>=3
order by late_payment_rate desc,late_payment desc;

/* Around 9 customers have a late payment rate of about 100% where they have made late payments 3 or more number of times indictaing that they are 
likely to default and hence require close monitoring of their loan status.*/


/*Q3. Does payment behavior differ by employment type?*/

select c.employment_type, round(100* sum(case when p.payment_status='late' then 1 else 0 end)/count(*),2) as late_payment_rate
from payments p
join loans l
on l.loan_id=p.loan_id
join customers c
on c.customer_id=l.customer_id
group by c.employment_type;

/* Retired people and people owning a busniess seems to exhibit the highest late payment rate in this dataset, 
although the difference compared with other employment groups is relatively small.. When it comes to retired people,considering their age, we must ensure that we give out timely reminders 
to make them pay on time */


/*Q4. Do customers with lower credit scores make more late payments?*/
select case when credit_score > 700 then'Good:>700'
            when credit_score between 600 and 700 then 'Average:600-700' 
			else 'Poor:<600'
		end as credit_score_category,
        round(100*sum(case when p.payment_status='late' then 1 else 0 end)/count(*),2) as late_payment_rate
		from customers c
        join loans l on l.customer_id=c.customer_id
        join payments p on p.loan_id=l.loan_id
        group by credit_score_category
        order by late_payment_rate desc;
        
/*Though not much variation has been found in terms of credit score affecting the late payment rates, 
people having poor credit scores seem to be a bit more inclined to make late payments*/


/*Q5. Does DTI influence payment punctuality?*/

select case when dti_ratio <0.3 then 'Low Risk'
when dti_ratio between 0.3 and 0.5 then 'Moderate Risk'
when dti_ratio between 0.5 and 0.7 then 'High Risk'
else 'Very High Risk'
end as dti_ratio_category,round(100* (sum(case when payment_status='Late' then 1 else 0 end)/count(*)),2) as late_payment_rate
from loans l
join payments p on l.loan_id=p.loan_id
group by dti_ratio_category
order by late_payment_rate desc;

/* Borrowers classified in the High and Very High DTI categories demonstrate the highest late payment rates,
suggesting that higher debt burdens negatively impact repayment punctuality.*/


/*Q6. Which states have the highest late payment rates?*/
select c.state,round(100*(sum(case when payment_status='late' then 1 else 0 end)/count(*)),2) as late_payment_rate
from payments p
join loans l on l.loan_id=p.loan_id
join customers c on c.customer_id=l.customer_id
group by c.state
order by late_payment_rate desc;

/*Bihar, Rajasthan, Telangana and Maharashtra exhibit the highest late payment rates among all states in the dataset.*/

/*Which customers always pay on time?*/
select c.customer_name,round(100*(sum(case when p.payment_status='On-time' then 1 else 0 end)/count(*)),2) as on_time_payment_rate
from customers c
join loans l on l.customer_id=c.customer_id
join payments p on p.loan_id=l.loan_id
group by c.customer_name
order by on_time_payment_rate desc;

/*Prasad Bhat
Suresh Mukherjee
Lata Kapoor
Vivek Nair
Sudha Desai
Ravi Chatterjee
Dinesh Verma
Ananya Chatterjee are the top borrowers who are making on_time payments about 90% of the time*/

SELECT
    l.loan_type,

    ROUND(
        100*SUM(CASE WHEN p.payment_status='On-Time' THEN 1 ELSE 0 END)/COUNT(*),2
    ) AS on_time_rate,

    ROUND(
        100*SUM(CASE WHEN p.payment_status='Late' THEN 1 ELSE 0 END)/COUNT(*),2
    ) AS late_rate,

    ROUND(
        100*SUM(CASE WHEN p.payment_status='Missed' THEN 1 ELSE 0 END)/COUNT(*),2
    ) AS missed_rate
FROM loans l
JOIN payments p
ON l.loan_id=p.loan_id
GROUP BY l.loan_type
ORDER BY late_rate DESC;

/*Credit score vs missed payment rate*/


/*Section 6 : ADVANCED SQL ANALYSIS*/

/*1. High Risk Customers - Which customers exhibit multiple risk indicators simultaneously?*/

with high_risk_customers as
(select c.customer_id,c.customer_name,c.credit_score,l.dti_ratio,
sum(case when p.payment_status in('Late','Missed') then 1 else 0 end) as deliquent_payments
from customers c
join loans l on l.customer_id=c.customer_id
join payments p on p.loan_id=l.loan_id
where c.credit_score<600 and
l.dti_ratio>0.5
group by c.customer_id,c.customer_name,l.dti_ratio,c.credit_score
having deliquent_payments >=3)
select * from high_risk_customers
order by deliquent_payments desc;

/*
Business Insight:

The identified customers exhibit a combination of
low credit scores, elevated debt-to-income ratios,
and repeated delinquent payments.

These borrowers represent the highest-risk segment
within the portfolio and should be prioritized for
proactive monitoring and intervention to reduce
future default risk.
*/

/*2. Top Borrowers by Total Loan Exposure- Who are the bank's highest-value borrowers?*/

with total_loan_amount as( select c.customer_id,c.customer_name,sum(l.loan_amount) as total_loan_amount
from loans l
join customers c on c.customer_id=l.customer_id
group by c.customer_id,c.customer_name),
ranked_borrowers as
(select *,row_number() over(order by total_loan_amount desc) as rnk
from total_loan_amount)
select* from ranked_borrowers where rnk<=10;

/*
Business Insight:

The top borrowers account for a significant share of
the bank's total loan exposure.

These customers represent high-value relationships but
also concentrated credit risk, making continuous
monitoring essential.
*/

/*Highest Borrower in Every State - Who is the largest borrower within each state? */

with total_loan_amount as( select c.state,c.customer_id,c.customer_name,sum(l.loan_amount) as total_loan_amount
from loans l
join customers c on c.customer_id=l.customer_id
group by c.customer_id,c.customer_name,c.state),
ranked_borrowers as
(select *,row_number() over(partition by state order by total_loan_amount desc) as rnk
from total_loan_amount)
select state, customer_id,customer_name,total_loan_amount
from ranked_borrowers
where rnk = 1
order by total_loan_amount desc;

/*
Business Insight:

The largest borrower in each state has been identified
based on total loan exposure.

These customers represent a significant share of the
bank's exposure within their respective states and
should be monitored closely as part of concentration
risk management.

A default by any of these borrowers could materially
impact portfolio performance within that region.
*/

/*4. Rank States by Default Rate - Which states require additional portfolio monitoring? */
with default_rate as(select c.state,count(*) as total_loans,sum(l.loan_amount) as total_loan_amount,round(100*sum(l.is_default)/count(*),2) as default_rate
from customers c
join loans l on l.customer_id=c.customer_id
group by c.state),
ranked_state as(
select state,default_rate,total_loans,total_loan_amount,round(100*total_loan_amount/sum(total_loan_amount) over(),2) as portfolio_share,dense_rank() over(order by default_rate desc) as rnk
from default_rate)
select * from ranked_state
order by rnk;

/*/*
Business Insight:

While default rate is an important indicator of credit
risk, states with both high default rates and large
loan portfolios should receive the highest monitoring
priority.

A state with a slightly lower default rate but a much
larger loan exposure may contribute more to overall
portfolio risk than a smaller state with the highest
default rate.
*/

/*5. Customers Paying a High EMI Relative to Income - Which borrowers may struggle to repay because their EMI burden is too high? */
with emi_monthly_ratio as (select c.customer_id,c.customer_name,round(100*l.emi/c.monthly_income,4) as emi_monthly_income_ratio
from customers c
join loans l on l.customer_id=c.customer_id),
ranked_customers as (select customer_id,customer_name,emi_monthly_income_ratio,rank() over(order by emi_monthly_income_ratio desc) as rnk
from emi_monthly_ratio)
select * from ranked_customers
where rnk<=10;

/*
Business Insight:

Approximately 12.3% of borrowers have EMI obligations
that exceed their reported monthly income, indicating
potential affordability concerns.

Customers with the highest EMI-to-Income ratios may be
more vulnerable to repayment stress and should be
prioritized for monitoring and early intervention.
*/

/*6. Customers Borrowing Above Their State Average - Which customers have unusually large loans compared to borrowers in their state?*/

with customer_exposure as (
select c.customer_name,c.customer_id,c.state, sum(l.loan_amount) as customer_exposure
from customers c
join loans l on l.customer_id=c.customer_id
group by c.customer_id,c.customer_name,c.state),
average_exposure as(
select state, round(avg(customer_exposure),2) as average_exposure
from customer_exposure
group by state)
select ce.customer_id,ce.customer_name,ae.state,ae.average_exposure,ce.customer_exposure
from average_exposure ae
join customer_exposure ce on ce.state=ae.state
where ce.customer_exposure>1.5 * ae.average_exposure
order by ce.customer_exposure
limit 10;

/*Several borrowers maintain loan exposures substantially above the average customer exposure within their respective states.
These customers represent concentrated credit exposure and should be monitored closely, 
as adverse repayment behavior could have a disproportionate impact on portfolio performance. */

/*7. Above-Average Credit Score but Still Defaulted-
Which customers unexpectedly default despite having strong credit profiles? */

with avg_credit_score as (
select avg(credit_score) as avg_credit_score
from customers)
select c.customer_id,l.loan_id,c.customer_name,c.credit_score,l.is_default
from customers c
join loans l on l.customer_id=c.customer_id
cross join avg_credit_score a
where c.credit_score>a.avg_credit_score
and l.is_default is true;









/*8. Loan Types Performing Worse Than Portfolio Average
Which loan products have default rates above the overall portfolio default rate? */
with loan_type_average as(
select loan_type,round(100*sum(case when is_default is true then 1 else 0 end)/count(*),2) as loan_type_avg
from loans
group by loan_type),
portfolio_average as(
select avg(loan_type_avg) as portfolio_average
from loan_type_average)
select loan_type,loan_type_avg
from loan_type_average
cross join portfolio_average
where loan_type_avg>portfolio_average;




/*9. Month over Month Loan applications*/

with monthly_applications as
(select date_format(application_date,'%Y-%m-01') as month,
count(*) as total_applications
    from loans
    group by month
),
application_trend as
(
    SELECT
        month,
        total_applications,
        LAG(total_applications)
        OVER(ORDER BY month) AS previous_month_applications
    FROM monthly_applications
)

SELECT
    month,
    total_applications,
    previous_month_applications,
    ROUND(
        100 *
        (total_applications - previous_month_applications)
        / NULLIF(previous_month_applications,0),
        2
    ) AS growth_percentage
FROM application_trend
ORDER BY month;

/*
Business Insight:

Loan application volumes showed month-over-month
fluctuations throughout the period. Months with
significant positive growth indicate increased credit
demand, while months with declining applications may
reflect changing economic conditions or seasonal
effects.

Tracking application growth helps forecast future
lending activity and supports resource planning for
credit assessment teams.
*/


/* PORTFOLIO RISK SCORE*/

/*| Risk Factor             | Condition          | Points |
| ----------------------- | ------------------ | ------ |
| Poor Credit Score       | Credit Score < 600 | 2      |
| High DTI                | DTI > 0.5          | 2      |
| Multiple Existing Loans | Existing Loans > 2 | 1      |
| Frequent Late Payments  | 3+ Late Payments   | 2      |
| Previous Default        | is_default = 1     | 3      | */


with payment_summary as(
select c.customer_id,
sum(case when p.payment_status='Late'
then 1 
else 0 end) as late_payments
from customers c
join loans l on l.customer_id=c.customer_id
join payments p on p.loan_id=l.loan_id
group by c.customer_id),
risk_scores as
(
select c.customer_id,c.customer_name,
(
case when c.credit_score<600 then 2 else 0 end+
case when l.dti_ratio>0.5 then 2 else 0 end+
case when c.existing_loans_count>2 then 1 else 0 end+
case when ps.late_payments>=3 then 2 else 0 end+
case when l.is_default=1 then 3 else 0 end ) as risk_score
  from customers c
  join loans l on l.customer_id=c.customer_id
  left join payment_summary ps on ps.customer_id=c.customer_id)
  select customer_id,customer_name,risk_score,
  case when risk_score>= 7 then 'High Risk'
  when risk_score>=4 then 'Medium Risk'
  else 'Low Risk'
  end as risk_category
  from risk_scores
  order by risk_score desc
