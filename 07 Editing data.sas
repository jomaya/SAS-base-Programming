/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01 Validating orion shoes tracker with the PRINT and FREQ Procedures*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
 
proc print data=orion.shoes_tracker;
var Product_Category Supplier_Name Supplier_Country Supplier_ID;
where Product_Category ='' or Supplier_Country not in ('GB','US');
run;

proc freq data=orion.shoes_tracker nlevels;
tables Supplier_Name Supplier_ID;
run;
/*1c. 1 observation has missing Product_Category*/
/*1c. 3 observations have invalid values of Supplier_Country*/
/*1d. Invalid data for Supplier_Name is '3op Sports'and invalid data for Supplier_ID is MISSING value*/

/*02_02 Validating orion qtr2 2007 with the PRINT and FREQ Procedures*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";

proc print data=orion.qtr2_2007;
where Delivery_Date < Order_Date or Order_Date not between '01Apr2007'd and '30jun2007'd;
run;

proc freq data=orion.qtr2_2007 nlevels;
tables Order_ID Order_Type;
run;
/*2b. 1 observation has Delivery_Date values occurring before Order_Date values and 1 observation has Order_Date values out of the range of April 1, 2007 – June 30, 2007*/
/*2d. Invalid data for Order_ID is MISSING and invalid data for Order_Type is 0*/



/*03_03 Using the PROPCASE Function  Two Way Frequency Table  and MISSING Option*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc print data=orion.shoes_tracker;
var Product_ID Product_Name;
where Product_Name ne propcase(Product_Name);
run;

proc freq data=orion.shoes_tracker;
tables Supplier_Name*Supplier_ID/missing;
run;
/*3c. Invalid data for Supplier_Name is '3op Sports' and invalid data for Supplier_ID is one observation has MISSING value and another one has the wrong Supplier_ID of 14682 for 3Top Sports products*/

/*04_01 Validating orion price current with the MEANS and UNIVARIATE Procedures*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc means data=orion.price_current n min max;
var Unit_Cost_Price Unit_Sales_Price Factor;
run;

proc univariate data=orion.price_current;
var Unit_Sales_Price Factor;
run;
/*4c. Unit_Sales_Price and Factor have invalid data*/
/*4e. 1 value of Unit_Sales_Price is over the maximum of 800*/
/*4e. 1 value of Factor is under the minimum of 1*/
/*4e. 2 values of Factor are over the maximum of 1.05*/




/*05_02 Validating orion shoes tracker with the MEANS and UNIVARIATE Procedures*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
proc means data=orion.shoes_tracker fw=15 min max range;
var Product_ID;
class Supplier_Name;
run;

proc univariate data=orion.shoes_tracker;
var Product_ID;
run;
/*5e. '3Top Sports'has invalid Product_ID values assuming Product_ID must only have twelve digits*/
/*5g. 4 values of Product_ID are too small*/
/*5g. 8 values of Product_ID are too large*/

/*06_03 Selecting Only the Extreme Observations Output from the UNIVARIATE Procedure*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
ods trace on;
proc univariate data=orion.shoes_tracker;
var Product_ID;
run;
ods trace off;

ods select extremeobs;
proc univariate data=orion.shoes_tracker;
var Product_ID;
run;
/*6d. ExtremeObs is the last Output Added in the SAS log*/


/*07_01 Cleaning Data from orion qtr2*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
 data work.qtr2_2007;
   set orion.qtr2_2007;
   if Order_ID=1242012259 then Delivery_Date='12MAY2007'd;
   if Order_ID=1242449327 then Order_Date='26JUN2007'd;
run;

proc print data=work.qtr2_2007;
   where Order_Date>Delivery_Date or
         Order_Date<'01APR2007'd or
         Order_Date>'30JUN2007'd;
run;



/*08_02 Cleaning Data from orion price current*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";
data work.price_current;
 set orion.price_current;
 if Product_ID=220200200022 then Unit_Sales_Price=57.30;
 if Product_ID=240200100056 then Unit_Sales_Price=41.20;
run;

proc means data=work.price_current n min max;
var Unit_Sales_Price;
run;

proc univariate data=work.price_current;
var Unit_Sales_Price;
run;



/*09_03 Cleaning Data from orion shoes tracker*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1";

data work.shoes_tracker;
 set orion.shoes_tracker;
 if Supplier_Country ne upcase(Supplier_Country) then Supplier_Country=upcase(Supplier_Country);
 if Supplier_Country='UT' then Supplier_Country='US';
 if Product_Category='' then Product_Category='shoes';
 if Supplier_ID=. then Supplier_ID=2963;
 if Supplier_Name ='3op Sports' then Supplier_Name ='3Top Sports';
 if _N_=4 then Product_ID=220200300079;
 if _N_=8 then Product_ID=220200300129;
 if propcase(Product_Name) ne Product_Name then Product_Name=propcase(Product_Name);
 if Supplier_ID=14682 and Supplier_Name='3Top Sports' then Supplier_Name='Greenline Sports Ltd';
run;

proc print data=work.shoes_tracker;
   where Product_Category=' ' or
         Supplier_Country not in ('GB','US') or
         propcase(Product_Name) ne Product_Name;
run;

proc freq data=work.shoes_tracker;
   tables Supplier_Name*Supplier_ID / missing; 
run;

proc means data=work.shoes_tracker min max range fw=15;
   var Product_ID;
   class Supplier_Name;
run;  

proc univariate data=work.shoes_tracker;
   var Product_ID;
run;


/*10_02 Create Nhanes3 Labsub1 by replacing fill values*/
libname Nhanes3 "/courses/d0f434e5ba27fe300/s5066/Nhanes3";

proc means data=Nhanes3.Labsubset;
run;

data work.labsub1;
 set Nhanes3.Labsubset;
 if hgp=88888 then hgp='.';
 if htp=88888 then htp='.';
 if tcp=888 then tcp='.';
 if tgp=8888 then tgp='.';
 if lcp=888 then lcp='.';
 if hdp=888 then hdp='.';
 if fbpsi=8888 then fbpsi='.';
 if crp=88888 then crp='.';
 if sgp=888 then sgp='.';
 if urp=88888 then urp='.';
run;
 
proc means data=work.labsub1;
run;



/*11_02 CreateNewVersionofExamsub*/
libname Nhanes3 "/courses/d0f434e5ba27fe300/s5066/Nhanes3";

proc means data=Nhanes3.examsubset;
run;

data work.examsub2;
 set Nhanes3.examsubset;
 if pep6g1=888 then pep6g1='.';
 if pep6g3=888 then pep6g3='.';
 if pep6h1=888 then pep6h1='.';
 if pep6h3=888 then pep6h3='.';
 if pep6i1=888 then pep6i1='.';
 if pep6i3=888 then pep6i3='.';
 if bmpwt=888888 then bmpwt='.';
 if bmpht=88888 then bmpht='.';
 if sppfev1=8888 then sppfev1='.';
 if sppfvc=88888 then sppfvc='.';
 sbpmn=mean(pep6g1,pep6h1,pep6i1);
 dbpmn=mean(pep6g3,pep6h3,pep6i3);
 bmi=bmpwt/(bmpht/100)**2;
 fvc=sppfvc/1000;
 fev1=sppfev1/1000;
 fev1pc=(fev1/fvc)*100;
 keep seqn hsageir hssex dmaracer bmi bmpwt bmpht sbpmn dbpmn fvc fev1 fev1pc; 
run;
 
proc means data=work.examsub2;
run;

