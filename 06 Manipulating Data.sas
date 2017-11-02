/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01 Creating Two New Variables*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1"  access=readonly;
data work.increase;
   set orion.staff;
   Increase=Salary*0.10;
   NewSalary=Salary+Increase;
   format Salary comma8. Increase comma8. NewSalary comma8.;
   keep Employee_ID Salary Increase NewSalary;
run;

proc print data=work.increase(obs=11) label;
run;


/*02_02 Creating Three New Variables*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.birthday;
 set orion.customer;
 Bday2009=mdy(month(Birth_Date),day(Birth_Date),2009);
 BdayDOW2009=weekday(Bday2009);
 Age2009=(Bday2009-Birth_Date)/365.25;
 keep Customer_Name Birth_Date Bday2009 BdayDOW2009 Age2009;
 format Bday2009 Date9. Age2009 3.;
run;

proc print data=work.birthday(obs=10);
run;

 
/*03_03 Using the CATX and INTCK Functions to Create Variables*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1"  access=readonly;

data work.employees;
 set orion.sales;
 FullName=catx(' ',First_Name, Last_Name);
 Yrs2012=intck('year',Hire_Date, mdy(1,1,2012));
 format Hire_Date ddmmyy10.;
 label Yrs2012='Years of Employment in 2012';
run;

proc print data=work.employees(obs=10) label;
var FullName Hire_Date Yrs2012;
run;
 


/*04_01 Creating Variables Conditionally*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
 data work.region;
   set orion.supplier;
   if Country in('CA','US') then do;
      Discount=0.1;
      DiscountType='Required';
      Region='North America';
   end;
   else do;
   Discount=0.05;
   DiscountType='Optional';
   Region='Not North America';
   end;
run;

proc print data=work.region(obs=10);
var Supplier_Name Country Region Discount DiscountType;
run;


/*05_01 Creating Variables Unconditionally and Conditionally*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.ordertype;
  set orion.orders;
  DayOfWeek=weekday(Order_Date);
  if Order_Type=1 then do;
  Type='Catalog Sale';
  SaleAds='Mail';
  end;
  else if Order_Type=2 then do;
  Type ='Internet Sale';
  SaleAds='Email';
  end;
  else if Order_Type=3 then Type ='Retail Sale';
 run;
 
proc print data=work.ordertype(obs=20);
var Order_ID Order_Date Delivery_Date Type SaleAds DayOfWeek;
run;
  

/*06_03 Using WHEN Statements in a SELECT Group to Create Variables Conditionally*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.gifts;
 set orion.nonsales;
 length Gift2 $ 14;
 select (Gender);
 when ('F') do;
 Gift1='Perfume';
 Gift2='Cookware';
 end;
 when ('M') do;
 Gift1='Cologne';
 Gift2='Lawn Equipment';
 end;
 otherwise do;
 Gift1='Coffee';
 Gift2='Lawn Calender';
 end;
end;
run;

proc print data=work.gifts(obs=15);
var Employee_ID First Last Gift1 Gift2;
run;


/*07_01 Subsetting Observations Based on Two Conditions*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

 data work.increase;
   set orion.staff;
   where Emp_Hire_Date GE mdy(7,1,2006);
   Increase=Salary*0.10;
   if Increase > 3000;
   NewSalary=sum(Salary,Increase);
   keep Employee_ID Emp_Hire_Date Salary Increase NewSalary;
   format Salary Increase NewSalary comma10.;
run;

proc print data=work.increase label;
run;


/*08_02 Subsetting Observations Based on Three Conditions*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.delays;
 set orion.orders;
 where Employee_ID=99999999;
 Order_Month=month(Order_Date);
 if Delivery_Date-Order_Date >4 and Order_Month=8;
run;

proc print data=work.delays;
run;


/*09_03 Using an IF-THEN DELETE Statement to Subset Observations*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.bigdonations;
  set orion.employee_donations;
  Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
  NoDonation=nmiss(Qtr1,Qtr2,Qtr3,Qtr4);
  if Total <50 or NoDonation >0 then delete;
run;

proc print data=work.bigdonations(obs=7);
var Employee_ID Qtr1 Qtr2 Qtr3 Qtr4 Total NoDonation;
run;


/*10_02 CreateNh3SmokingFile*/
libname nhanes3 "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.smoking;
 set nhanes3.adult;
 if (har1=8) or (har1=1 and har3=8) then delete;
 if har1=2 then neversmoker=1;
 else neversmoker=0;
 if har1=1 and har3=2 then exsmoker=1;
 else exsmoker=0;
 if har1=1 and har3=1 then currentsmoker=1;
 else currentsmoker=0;
 if neversmoker=1 then smokingcat=1;
 else if exsmoker=1 then smokingcat=2;
 else if currentsmoker=1 then smokingcat=3;
run;

proc freq data=smoking;
tables neversmoker exsmoker currentsmoker smokingcat/norow nocol nopercent;
run;
 

/*11_02 Create New Version Of MortSub*/
libname nhanes3 "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.mortsub2;
 set nhanes3.mortsub1;
 if mortstat=1 then Dead=1;
 else Dead=0;
 if mortstat=1 and ucod_113 in (056,059,060,061,062,063) then Dead_chd=1;
 else Dead_chd=0;
run;

proc freq data=mortsub2;
tables Dead Dead_chd;
run;

/*12_02 Create New Version AdultDemographics File*/
libname nhanes3 "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.AdultDemographics2;
 set Nhanes3.Adult;
 if dmaracer=8 then dmaracer='unknown';
run;

proc freq data=work.adultdemographics2;
tables dmaracer;
run;
 

/*13_02 Create Nhanes 3Diabetics File*/
libname nhanes3 "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.diabetics;
 set nhanes3.adult;
 if HAD1=1 then diabetic=1;
 else if HAD1=2 then diabetic=0;
 else delete;
 if HSSEX=2 and diabetic=1 and HAD3=1 and HAD4=2 then diabetic=0;
run;

proc freq data=diabetics;
tables diabetic;
run;
