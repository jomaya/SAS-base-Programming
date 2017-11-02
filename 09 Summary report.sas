/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01 Counting Levels of a Variable with PROC FREQ*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
title 'Unique Customers and Salespersons for Retail Sales';
proc freq data=orion.orders nlevels;
   tables Customer_ID Employee_ID/noprint;
   where Order_Type=1;
run;
title 'Unique Customers for Catalog and Internet';
proc freq data=orion.orders nlevels;
   tables Customer_ID/noprint;
   where Order_Type ne 1;  
run;
title;


/*02_02 Producing Frequency Reports with PROC FREQ*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
title 'Order Summary by Year and Type';
proc format;
   value ordertypes
      1='Retail'
      2='Catalog'
      3='Internet';
run;

proc freq data=orion.orders;
tables Order_Date;
tables Order_Type / nocum;
tables Order_Date*Order_Type/nopercent nocol norow;
format Order_Date Year4. Order_Type ordertypes.;
run;
title;


/*03_03 Displaying PROC FREQ Output in Descending Frequency Order*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
proc freq data=orion.customer_dim order=freq;
   tables Customer_Country Customer_Type Customer_Age_Group;
   title1 'Customer Demographics';
   title3 '(Top two levels for each variable?)';
run;



/*04_03 Creating an Output Data Set with PROC FREQ*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
proc freq data=orion.order_fact noprint;
    tables Product_ID/out=work.freq1;
run;
data work.freq2;
 merge work.freq1 orion.product_list;
 by Product_ID;
run;
proc sort data=work.freq2 out=work.freq3;
by descending count;
run;

proc print data=work.freq3(obs=10 keep=COUNT Product_ID Product_Name) label;
label count='Orders' Product_ID='Product Number' Product_Name='Product';
title 'Top Ten Products by Number of Orders';
run;


/*05_01 Creating a Summary Report with PROC MEANS*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
proc format;
   value ordertypes
      1='Retail'
      2='Catalog'
      3='Internet';
run;
proc means data=orion.order_fact sum;
var Total_Retail_Price;
class Order_Date Order_Type;
format Order_Date Year4. Order_Type ordertypes.;
   title 'Revenue (in U.S. Dollars) Earned from All Orders';
run;



/*06_02 Analyzing Missing Numeric Values with PROC MEANS*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
proc means data=orion.staff nmiss n maxdec=0 nonobs;
var Birth_Date Emp_Hire_Date Emp_Term_Date;
class Gender;

   title 'Number of Missing and Non-Missing Date Values';
run;


/*07_03 Analyzing All Possible Classification Levels with PROC MEANS*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
data work.countries(keep=Customer_Country);
   set orion.supplier;
   Customer_Country=Country;
run;

proc means data=orion.customer_dim lclm mean uclm ALPHA=0.10 classdata=work.countries;
   class Customer_Country;
   var Customer_Age;
   title 'Average Age of Customers in Each Country';
run;



/*08_03 Creating an Output Data Set with PROC MEANS*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
proc means data=orion.order_fact sum noprint;
   class Product_ID;
   var Total_Retail_Price;
   output out=work.means1
   sum=Revenue;
run;
data work.all1;
merge work.means1 orion.product_list;
by Product_ID;
run;
proc sort data=work.all1 out=work.all2;
where Product_ID ne .;
by descending Revenue;
run;
proc print data=work.all2(obs=10 keep=Revenue Product_ID Product_Name) label;
format Revenue EUROX12.2;
label Revenue='Revenue' Product_ID='Product Number' Product_Name='Product';
title 'Top Ten Products by Revenue';
run;


/*09_02One and two-way tables, proc freq, nhanes 3 adult file*/
libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;
data work.AnalysisTmp;
set Nhanes3.Analysis;
run;
proc freq data=work.AnalysisTmp;
tables dmaracer dmarethn hssex;
run;
proc freq data=work.AnalysisTmp;
tables dmaracer dmarethn hssex/nopercent nocum;
run;
proc freq data=work.AnalysisTmp;
tables dmaracer dmarethn/nopercent nocum;
where hssex=2 and hsageir <50;
run;
proc format;
value agefmt 1-44 = '<45' 
             45-59 ='46-59' 
			 60-high ='60+';
run;
proc freq data=work.AnalysisTmp;
tables hsageir*dmaracer hsageir*dmarethn hsageir*hssex;
format hsageir agefmt.;
run;


/*10_02Average values for Nhanes 3 lab data*/
libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;
data work.AnalysisTmp;
set Nhanes3.Analysis;
run;
proc means data=work.AnalysisTmp n nmiss mean std min max;
var hgp htp tcp tgp lcp hdp crp;
run;
proc means data=work.AnalysisTmp n nmiss mean std min max;
var hgp tcp;
class hssex dmaracer;
run;
proc format;
value agefmt 1-<60 ='<60' 
			 60-high ='60+';
run;
proc means data=work.AnalysisTmp n mean std min max;
var tcp;
class hssex hsageir ;
format hsageir agefmt.;
run;





