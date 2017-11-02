/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01 Extracting Characters Based on Position*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data work.codes;
 set orion.au_salesforce;
 FCode1=lowcase(substr(First_Name,1,1));
 FCode2=lowcase(substr(First_Name,length(First_Name),1));
 LCode=lowcase(substr(Last_Name,1,4));
run;

proc print data=work.codes(keep=First_Name FCode1 FCode2  Last_Name LCode);
 title 'Extracted Letters for User IDs';
run;
title;
 

/*02_02 Extracting Characters Based on Position 2*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data work.small;
 set orion.newcompetitors;
 if substr(strip(substr(ID,3,length(ID)-2)),1,1)='1';
 City=propcase(City);
run;

proc print data=work.small noobs;
title 'New Small-Store Competitors';
run;
title;


/*03_03 Converting US Postal Codes to State Names*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data states;
 set orion.contacts;
 zipcode=scan(scan(Address2,2,','),2,' ');
 Location=zipnamel(zipcode);
 keep ID Name Location;
run;

proc print data=states noobs;
run;


/*04_01 Cleaning Up Text Data*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data names;
 set orion.customers_ex5;
 if Gender='F' then tit='Ms.';
 else if Gender='M' then tit='Mr.';
 fname=scan(Name,2,',');
 lname=propcase(scan(Name,1,','));
 New_Name=catx(' ',tit,fname,lname);
run;

proc print data=names(keep=New_Name Name Gender);
run;
 

/*05_03 Searching for and Replacing Character Values*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data work.silver work.gold work.platinum;
 set orion.customers_ex5 ;
 Customer_ID=Tranwrd(Customer_ID,'-00-','-15-');
 if find(Customer_ID,'gold','I')=1 then output work.gold;
 else if find(Customer_ID,'silver','I')=1 then output work.silver;
 else if find(Customer_ID,'platinum','I')=1 then output work.platinum;
run;

proc print data=work.silver(keep=Customer_ID Name Country) noobs;
title 'Silver-Level Customers';
run;

proc print data=work.gold(keep=Customer_ID Name Country) noobs;
title 'Gold-Level Customers';
run;

proc print data=work.platinum(keep=Customer_ID Name Country) noobs;
title 'Platinum-Level Customers';
run;
title;
 


/*06_02 Searching Character Values and Explicit Output*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data work.split;
  set orion.employee_donations;
  a=find(Recipients,'%');
  b=find(Recipients,'%',find(Recipients,'%')+1);
  if a=0 then do;
  Charity=Recipients;
  output;
  end;
  else do;
  charity=substr(Recipients,1,a);
  output;
  charity=substr(Recipients,a+2,b-a-1);
  output;
  end;  
run;

proc print data=work.split noobs;
var Employee_ID Charity;
title 'Charity Contributions for each Employee';
run;
title;

/*07_03 Using Character Functions with the Input Buffer*/
filename supply  "/courses/d0f434e5ba27fe300/s5066/RawData/supply.dat" ;
data work.supplier;
 infile supply;
 input  @1 Suppler_ID $5.; 
     Country=scan(_infile_, -1,' ');
	 sn1=find(_infile_,' ',1);
	 sn2=length(_infile_)-2;
	 sn3=length(_infile_)-sn1-2;
	 Suppler_Name=substr(_infile_,sn1,sn3);
	 Suppler_ID=substr(_infile_,1,sn1-1);
run;

proc print data=work.supplier noobs;
var Suppler_ID Suppler_Name Country;
title 'Suppler Information';
run;
title;

/*08_01 Calculating Statistics and Rounding*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data work.sale_stats;
 set orion.orders_midyear;
 MonthAvg=mean(of Month1-Month6);
 MonthMax=max(of Month1-Month6);
 MonthSum=sum(of Month1-Month6);
 MonthAvg=round(MonthAvg,1);
run;

proc print data=work.sale_stats noobs;
 var Customer_ID MonthAvg MonthMax MonthSum;
title 'Statis on Months in which the Custome Placed on Order';
run;
title;


/*09_03 Calculating Statistics for Missing Median and Highest Values*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data work.freqcustomers(drop=freq i);
 set orion.orders_midyear;
 array mon{6} Month1-Month6;
 freq=0;
 do i=1 to 6;
 if mon{i} ne . then freq=freq+1;
 end;
 if freq>=5 then do;
 Month_Median=median(of Month1-Month6);
 Month_Highest=Max(of Month1-Month6);
 Month_2ndHighest=largest(2,of Month1-Month6);
 output;
 end;
run;

proc print data=work.freqcustomers noobs;
title  'Month Statistics Freqent Customers';
run;
title;

/*10_01 Using the PUT and INPUT Functions*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data shipping_notes;
  set orion.shipped;
  length Comment $ 21.;
  Comment = cat('Shipped on ',put(Ship_Date,mmddyy10.));
  Total = Quantity * input(Price,dollar7.2);
run;

proc print data=shipping_notes noobs;
  format Total dollar7.2;
run;



/*11_02 Changing a Variable Data Type*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2"  access=readonly;
data US_converted;
  set orion.US_newhire(rename=(ID=IDchar  Telephone=Tel Birthday=Birth));
  length Telephone $8.;
  IDchar=compress(IDchar,'-');
  ID=input(IDchar,15.);
  Tele=put(Tel,8.);
  a1=substr(left(Tele),1,3);
  a2=substr(left(Tele),4,7);
  Telephone=catx('-',a1,a2);
  Birthday=input(Birth,date9.);  
  keep ID Telephone Birthday;
 run;
 
 proc print data=US_converted noobs;
 var ID Telephone Birthday;
 run;
 proc contents data=US_converted position;
 run;


