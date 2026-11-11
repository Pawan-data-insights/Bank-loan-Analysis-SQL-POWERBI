select * from bank_loan_data
-- key perfformance indiacators 

 -- total loan aplication
 
 select count(id) as total_applications 
 from bank_loan_data
  --MTD
 select count(id) as MTDtotal_applications 
 from bank_loan_data
 where month (issue_date) = 12 and year(issue_date) = 2021; 

 --MOM
 select count(id) as MOMtotal_applications 
 from bank_loan_data
 where month (issue_date) = 11 and year(issue_date) = 2021;

 --total funded amount 

 select sum(loan_amount) as total_funded_amount from bank_loan_data ;
 --mtd
 select sum(loan_amount) as mtd_total_funded_amount from bank_loan_data
 where month(issue_date) = 12 and year (issue_date) = 2021;
 --pmtd
 select sum(loan_amount) as pmtd_total_funded_amount from bank_loan_data
 where month(issue_date) = 11 and year (issue_date) = 2021;

 --total amount recieved 

 select sum(total_payment) as total_amount_recieved from bank_loan_data ;
 select sum(total_payment) as mtd_total_amount_recieved from bank_loan_data
 where month(issue_date) = 12 and year (issue_date) = 2021;
 select sum(total_payment) as pmtd_total_amount_recieved from bank_loan_data
 where month(issue_date) = 11 and year (issue_date) = 2021;

 --average interest rate 

 select round(avg(int_rate)*100 , 2)  as average_interest_rate from bank_loan_data ;
 select round(avg(int_rate)*100 , 2)  as mtd_average_interest_rate from bank_loan_data
 where month(issue_date) = 12 and year( issue_date) = 2021 ;
 select round(avg(int_rate)*100 , 2)  as pmtd_average_interest_rate from bank_loan_data
 where month(issue_date) = 11 and year( issue_date) = 2021 ;

 --average debt to income ratio

 select round(avg( dti)*100 ,2 ) as avg_debt_to_income_ratio from bank_loan_data ;
  select round(avg( dti)*100 ,2 ) as mtd_avg_debt_to_income_ratio from bank_loan_data 
  where month(issue_date) = 12 and year(issue_date) = 2021;
  select round(avg( dti)*100 ,2 ) as pmtd_avg_debt_to_income_ratio from bank_loan_data 
  where month(issue_date) = 11 and year(issue_date) = 2021;

  --good loan status
  --good loan percentage 

select (count( case when loan_status = 'fully paid' or loan_status = 'current' then id end)*100) / count(id) 
as good_loan_percentage 
from bank_loan_data ;

---good loan application

select count(id) as good_loan_application
from bank_loan_data
where loan_status = 'fully paid' or loan_status = 'current'

---good_loan_funded_ammount 

select sum(loan_amount)  as good_loan_funded_amount
from bank_loan_data
where loan_status = 'fully paid' or loan_status = 'current';

--good loan total recieved amount 

select sum(total_payment)  as good_loan_recieved_amount
from bank_loan_data
where loan_status = 'fully paid' or loan_status = 'current';

--bad loan status
--bad loan percentage 

select (count(case when loan_status = 'charged off' then id end)*100)/count(id) as bad_loan_percentage
from bank_loan_data ;

--bad loan application

select count(id) as bad_loan_application from bank_loan_data
where loan_status = 'charged off' 

--bad loan funded amount 
select sum(loan_amount) as bad_loan_funded_amount 
from bank_loan_data
where loan_status = 'charged off';

select sum(total_payment) as bad_loan_recieved_amount 
from bank_loan_data
where loan_status = 'charged off';

--for loan status grid view
select loan_status,
       count(id) as loan_count,
       sum(total_payment) as total_loan_application,
       sum(loan_amount) as total_funded_amount,
       round(avg(int_rate *100),2) as interest_rate,
       round(avg(dti*100),2)as dti
from bank_loan_data
group by loan_status ;

--month to date 

select loan_status,
sum (total_payment) as mtd_total_amount_recieved,
sum (loan_amount) as mtd_total_funded_amount
from bank_loan_data
where month (issue_date) = 12
group by loan_status ;

--month to month 

select loan_status,
sum (total_payment) as pmtd_total_amount_recieved,
sum (loan_amount) as pmtd_total_funded_amount
from bank_loan_data
where month (issue_date) = 11
group by loan_status ;


--for dashboard 2
--monthly trend by issue date 

select
      month(issue_date) as month_number,
      DATENAME(month , issue_date ) as month_name,
      count(id) as total_loan_application,
      sum(loan_amount) as total_funded_amount,
      sum(total_payment) as total_amount_received
from bank_loan_data
group by month(issue_date) ,DATENAME(month , issue_date ) 
order by month(issue_date) ,DATENAME(month , issue_date ) ;

 --regional analysis by state 

select
     address_state,
      count(id) as total_loan_application,
      sum(loan_amount) as total_funded_amount,
      sum(total_payment) as total_amount_received
from bank_loan_data
group by address_state
order by address_state ;

--loan term analysis 
select
     term,
      count(id) as total_loan_application,
      sum(loan_amount) as total_funded_amount,
      sum(total_payment) as total_amount_received
from bank_loan_data
group by term
order by term ;

--employee length anlaysis
select
     emp_length,
      count(id) as total_loan_application,
      sum(loan_amount) as total_funded_amount,
      sum(total_payment) as total_amount_received
from bank_loan_data
group by emp_length
order by emp_length ;

--purpose
select
     purpose,
      count(id) as total_loan_application,
      sum(loan_amount) as total_funded_amount,
      sum(total_payment) as total_amount_received
from bank_loan_data
group by  purpose
order by count(id) desc ;

--home ownership
select
     home_ownership,
      count(id) as total_loan_application,
      sum(loan_amount) as total_funded_amount,
      sum(total_payment) as total_amount_received
from bank_loan_data
group by  home_ownership
order by count(id) desc ;






















