/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*01_01 Appending Like Structured Datasets*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";

data current;
  set orion.price_current;
run;  

proc contents data=current;
run;

data new;
set orion.price_new;
run;

proc contents data=new;
run;                   
/*1b. There are 6 variables in current and 5 variables in new*/
/*1b. There is no variable contained in new that is not in current*/

proc append base=current data=new;
run;
proc print data=current;
run;
/*Because there is no variable contained in the DATA file that is not in the BASE file and no extrta vairiable need to be dropped*/


/*02_02 Appending Unlike Structured Data Sets*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc contents data=orion.qtr1_2007 ;
run;
proc contents data=orion.qtr2_2007 ;
run;
/*2a. There are 5 variables in orion.qtr1_2007 and 6 variables in orion.qtr2_2007*/
/*2a. Employee_ID is not in both data sets*/
proc append base=work.ytd data=orion.qtr1_2007;
run;
proc append base=work.ytd data=orion.qtr2_2007 force;
run;
/*2d. Because there is an extra vatiable Employee_ID included in the data file which needs to be dropped by the force statement*/


/*03_03 Using the Append Statement*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc contents data=orion.shoes_eclipse;
run;
proc contents data=orion.shoes_tracker;
run;
proc contents data=orion.shoes;
run;
data work.shoes_eclipse;
  set orion.shoes_eclipse;
run;
data work.shoes_tracker;
  set orion.shoes_tracker;
run;
data work.shoes;
  set orion.shoes;
run;
proc datasets;
  append base=work.shoes data=work.shoes_eclipse;
  append base=work.shoes data=work.shoes_tracker force;
run;



/*04_01 Concatenating Like Structured Data Sets*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
data work.thirdqtr;
  set orion.mnth7_2007 orion.mnth8_2007 orion.mnth9_2007;
run;
/*4a. There are 10 observations in work.thirdqtr from orion.mnth7_2007, 12 from orion.mnth8_2007 and 10 from orion.mnth9_2007*/
proc print data=work.thirdqtr(obs=10);
run;


/*05_02 Concatenating Unlike Structured Data*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc contents data=orion.sales;
run;
proc contents data=orion.nonsales;
run;
/*First_Name and Last_Name are different in the two data sets*/
data work.allemployees;
 set orion.sales orion.nonsales(rename=(First=First_Name Last=Last_Name));
 keep Employee_ID First_Name Last_Name Job_Title Salary;
run;
proc print data=work.allemployees(obs=10);
run;


/*06_03 Interleaving Data Sets*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc sort data=orion.shoes_eclipse
          out=work.eclipsesort;
   by Product_Name;
run;
proc sort data=orion.shoes_tracker
          out=work.trackersort;
   by Product_Name;
run;
data work.e_t_shoes;
 set work.eclipsesort work.trackersort;
 by Product_Name;
 keep Product_Group Product_Name Supplier_ID;
run;
proc print data=work.e_t_shoes(obs=10);
run;


/*07_01 Merging Two Data Sets One to one */
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc sort data=orion.employee_payroll
          out=work.payroll; 
   by Employee_ID;
run;
proc sort data=orion.employee_addresses 
          out=work.addresses; 
   by Employee_ID;
run;
data work.payadd;
 merge work.payroll work.addresses;
 by Employee_ID;

proc print data=work.payadd;
   var Employee_ID Employee_Name Birth_Date Salary;
   format Birth_Date weekdate.;
run;


/*08_02 Merging Three Data Sets One to one*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc sort data=orion.employee_addresses 
          out=work.addresses; 
   by Employee_ID;
run;
data work.payaddorg;
 merge work.addresses orion.employee_payroll orion.employee_organization;
 by Employee_ID;
run;
proc print data= work.payaddorg(obs=10);
var Employee_ID Employee_Name Birth_Date Department Salary;
   format Birth_Date ddmmyy10.;
run;



/*09_03 Merging orion orders and orion order item One to Many*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc contents data=orion.orders;
run;
proc contents data=orion.order_item;
run;
data work.allorders;
  merge orion.orders orion.order_item;
  by Order_ID;
run;

proc print data=work.allorders;
   var Order_ID Order_Item_Num Order_Type 
       Order_Date Quantity Total_Retail_Price;
run;


/*10_01 Merging orion product level and orion product list One to Many*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc sort data=orion.product_list
          out=work.product_list;
    by Product_Level;
run;
proc contents data=work.product_list;
run;
proc contents data=orion.product_level;
run;
data work.listlevel;
  merge work.product_list orion.product_level ;
  by Product_Level;
run;
proc print data=work.listlevel(obs=10);
 var Product_ID Product_Name Product_Level Product_Level_Name;
run;


/*11_02 Merging Using the IN equals Option*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc sort data=orion.product_list
          out=work.product;
   by Supplier_ID;
run;
data work.prodsup;
 merge work.product(in=pro) orion.supplier(in=sup);
 by Supplier_ID;
 if pro=1 and sup=0;
run;
proc print data=work.prodsup;
   var Product_ID Product_Name Supplier_ID Supplier_Name;
run;



/*12_03 Merging Using the IN and rename options*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc sort data=orion.customer
          out=work.customer;
    by Country;
run;
data work.allcustomer;
  merge work.customer 
        orion.lookup_country(rename=(Start=Country Label=Country_Name));
  by Country;
keep Customer_ID Country Customer_Name Country_Name;
run;

proc print data=work.allcustomer(obs=15);
run;

data work.allcustomer;
  merge work.customer(in=cus) 
        orion.lookup_country(rename=(Start=Country Label=Country_Name) in=lookup);
  by Country;
  if cus=1 and lookup=1;
keep Customer_ID Country Customer_Name Country_Name;
run;

proc print data=work.allcustomer(obs=7);
run;


/*13_02 Merge the nhanes3 adult and exam datasets*/
libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;
data work.OnAdult;
 set nhanes3.adult;
 keep seqn;
run;
data work.OnExam;
 set nhanes3.exam;
 keep seqn;
run;
proc sort data=work.OnAdult;
 by seqn;
run;
proc sort data=work.OnExam;
 by seqn;
run;
data Work.OnAdultOnly;
 merge work.OnAdult(in=adu) work.OnExam(in=exam);
 by seqn;
 if adu=1 and exam=0;
run;
data Work.OnExamOnly;
 merge work.OnAdult(in=adu) work.OnExam(in=exam);
 by seqn;
 if adu=0 and exam=1;
run;
data Work.OnBoth;
 merge work.OnAdult(in=adu) work.OnExam(in=exam);
 by seqn;
 if adu=1 and exam=1;
run;
proc contents data=Work.OnAdultOnly;
run;
proc contents data=Work.OnExamOnly;
run;
proc contents data=Work.OnBoth;
run;


/*14_02 Merge the Nhanes 3 exam and lab files*/
libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;
proc sort data=nhanes3.exam 
          out=work.exam;
 by seqn;
run;
proc sort data=nhanes3.lab
          out=work.lab;
 by seqn;
run;
data work.ExamOnly;
 merge work.exam(in=exam) work.lab(in=lab);
 by seqn;
 if exam=1 and lab=0;
run;
data work.LabOnly;
 merge work.exam(in=exam) work.lab(in=lab);
 by seqn;
 if exam=0 and lab=1;
run;
data work.LabAndExam;
 merge work.exam(in=exam) work.lab(in=lab);
 by seqn;
 if exam=1 and lab=1;
run;
proc contents data=work.ExamOnly;
run;
proc contents data=work.LabOnly;
run;
proc contents data=work.LabAndExam;
run;

