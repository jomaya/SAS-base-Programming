/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01 Using Formatted Input*/
filename sales1 '/courses/d0f434e5ba27fe300/s5066/RawData/sales1.dat';
data work.sales_staff;
  infile sales1;
  input  @1 Employee_ID 6. 
         @21 Last_Name $18.
         @43 Job_Title $20.
         @64 Salary comma8.
         @87 Hire_Date MMDDYY10.;
run;
proc print data=sales_staff noobs;
title 'Australian and US Sales Staff';
run;


/*02_02 Using Formatted Input and Subsetting IF*/
filename sales1 '/courses/d0f434e5ba27fe300/s5066/RawData/sales1.dat';
data work.AU_trainees work.US_trainees;
 infile sales1;
 input @1 Employee_ID 6. 
       @21 Last_Name $18.
       @43 Job_Title $20.
       @64 Salary comma8.
       @73 Country $2.
       @87 Hire_Date MMDDYY10.;
if Country='AU' and Job_Title='Sales Rep. I' then
output AU_trainees;
else if Country='US' and Job_Title='Sales Rep. I' then
output US_trainees;
run;

proc print data=AU_trainees(drop=Country) noobs;
title 'Austrtalian trainees';
run; 
proc print data=US_trainees(drop=Country) noobs;
title 'U.S. trainees';
run;


/*03_03 Using a Text String with Column Pointer Controls*/
filename seminar '/courses/d0f434e5ba27fe300/s5066/RawData/seminar.dat';

data work.seminar_ratings;
 infile seminar;
 input @1 Name $15.
       @'Rating:' Rating 1. ;
run;

proc print data=seminar_ratings;
title 'Names and Ratings';
run;  

/*04_01 Reading Multiple Input Records per Observation*/
filename sales2 '/courses/d0f434e5ba27fe300/s5066/RawData/sales2.dat';
data work.sales_staff2;
 infile sales2;
 input @1 Employee_ID 6.
       @21 Last_Name $18.;
 input @1 Job_Title $20.
       @22 Hire_Date mmddyy10.
       @33 Salary comma8.;
 input;
run;

proc print data= sales_staff2 noobs;
title 'Australian and US Sales Staff';
run;

/*05_02 Working with Mixed Record Types*/
filename sales3 '/courses/d0f434e5ba27fe300/s5066/RawData/sales3.dat';
data work.AU_sales;
 infile sales3;
 input  @1 Employee_ID 6. 
         @21 Last_Name $18.
         @43 Job_Title $20. /
         @1 Salary comma8. 
         @10 Country $2. @;
 if Country='AU';
 input @24 Hire_Date DDMMYY10.;
run;

proc print data=AU_sales(drop=Country) noobs;
title 'Australian Sales Staff';
run;

data work.US_sales;
 infile sales3;
 input  @1 Employee_ID 6. 
         @21 Last_Name $18.
         @43 Job_Title $20. /
         @1 Salary comma8. 
         @10 Country $2. @;
 if Country='US';
 input @24 Hire_Date MMDDYY10.;
run;

proc print data=US_sales(drop=Country) noobs;
title 'US Sales Staff';
run;




