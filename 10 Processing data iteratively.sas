/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01 Performing Computations with DO Loops*/
libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data future_expenses (drop=start stop);
   Wages=12874000;
   Retire=1765000;
   Medical=649000;
   start=year(today())+1;
   stop=start+9;
  /* insert a DO loop here */
  do year=start to stop;
  Wages=Wages*1.06;
  Retire=Retire*1.014;
  Medical=Medical*1.095;
  Total_Cost=Wages+Retire+Medical;
  output;
  end;
run;
proc print data=future_expenses;
   format wages retire medical total_cost comma14.2;
   var year wages retire medical total_cost;
run;

data future_expenses (drop=start stop);
   Wages=12874000;
   Retire=1765000;
   Medical=649000;
   Income=50000000;
   start=year(today())+1;
   stop=start+9;
  /* insert a DO loop here */
  do year=start to 2115 until (Income < Total_Cost);
  Wages=Wages*1.06;
  Retire=Retire*1.014;
  Medical=Medical*1.095;
  Income=Income*1.01;
  Total_Cost=Wages+Retire+Medical;
  output;
  end;
run;
proc print data=future_expenses;
   format wages retire medical total_cost comma14.2;
   var year Income total_cost;
run;



/*02_02 Using an Iterative DO Statement with a Conditional Clause*/
libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data work.expenses;
  Income=50000000;
  Expenses=38750000;
  do Year=1 to 100 until (Expenses gt Income or year=30);
  Income=Income*1.01;
  Expenses=Expenses*1.02;
  end;
  output;
run;
proc print data=work.expenses;
format Income Expenses dollar15.2;
run;


/*03_03 Using Other Loop Control Statements*/

libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data work.expenses;
  Income=50000000;
  Expenses=38750000;
  do Year=1 to 75;
  Income=Income*1.01;
  Expenses=Expenses*1.02;
  if Expenses gt Income then leave;
  end;
  output;
run;
proc print data=work.expenses;
format Income Expenses dollar15.2;
run;

/*04_01 Using Arrays for Repetitive Computations*/
libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data discount_sales;
  set prg2.orders_midyear;
  keep Customer_ID Month1-Month6;
  array Mon{6} Month1-Month6;
  do i=1 to 6;
  Mon{i}=Mon{i}*0.95;
  end;
run;
proc print data=discount_sales noobs;
title 'Monthly Sales with 5% Discount';
format month1-month6 dollar10.2;
run;
title;

/*05_02 Using Arrays for Repetitive Computations*/
libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data special_offer;
   set prg2.orders_midyear;
   array Mon{3} Month1-Month3;
   Total_Sales=sum(Month1,Month2,Month3,Month4,Month5,Month6);
   do i=1 to 3;
   Mon{i}=Mon{i}*0.90;
   Projected_Sales=sum(Month1,Month2,Month3,Month4,Month5,Month6);
   end;
   Difference=Total_Sales-Projected_Sales;
   keep Total_Sales Projected_Sales Difference;
run;

proc print data=special_offer noobs;
sum Difference;
title 'Total Sales with 10% Discount in First Three Months';
format Total_Sales Projected_Sales Difference dollar10.2;
run;


/*06_03 Terminating a DATA step*/
libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data fsp;
   set prg2.orders_midyear;
   array Nvar{*} _numeric_;
   nmon=dim(Nvar);
   if nmon<4 then do;
    putlog 'Orders fewer than 3 months';
	stop;
	end;
	array Mon{*} mon:;
   Total_Order_Ammount=sum(of Mon(*));
   Months_Ordered=0;
   do i=1 to nmon-1;
   if Mon(i) ne . then Months_Ordered=Months_Ordered+1;
   end;
   if Months_Ordered*2 >=nmon-1 and Total_Order_Ammount>1000 then output;
   keep Customer_ID Total_Order_Ammount Months_Ordered;
   format Total_Order_Ammount dollar10.2;
run;

proc print data=fsp;
title 'orion.orders_midyear:Frequent Shopper';
run;

data fsp;
   set prg2.orders_qtr1;
   array Nvar{*} _numeric_;
   nmon=dim(Nvar);
   if nmon<4 then do;
    putlog 'Orders fewer than 3 months';
	stop;
	end;
	array Mon{*} mon:;
   Total_Order_Ammount=sum(of Mon(*));
   Months_Ordered=0;
   do i=1 to nmon-1;
   if Mon(i) ne . then Months_Ordered=Months_Ordered+1;
   end;
   if Months_Ordered*2 >=nmon-1 and Total_Order_Ammount>1000 then output;
   keep Customer_ID Total_Order_Ammount Months_Ordered;
   format Total_Order_Ammount dollar10.2;
run;

proc print data=fsp;
title 'orion.orders_qtr1:Frequent Shopper';
run;

data fsp;
   set prg2.orders_two_months;
   array Nvar{*} _numeric_;
   nmon=dim(Nvar);
   if nmon<4 then do;
    putlog 'Orders fewer than 3 months';
	stop;
	end;
	array Mon{*} mon:;
   Total_Order_Ammount=sum(of Mon(*));
   Months_Ordered=0;
   do i=1 to nmon-1;
   if Mon(i) ne . then Months_Ordered=Months_Ordered+1;
   end;
   if Months_Ordered*2 >=nmon-1 and Total_Order_Ammount>1000 then output;
   keep Customer_ID Total_Order_Ammount Months_Ordered;
   format Total_Order_Ammount dollar10.2;
run;

proc print data=fsp;
title 'orion.orders_two_months:Frequent Shopper';
run; 
title;



/*07_01 Using an Array for Table Lookup*/
libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data preferred_cust;
   set prg2.orders_midyear;
   array Mon{6} Month1-Month6;
   keep Customer_ID Over1-Over6 Total_Over;
   array Target{6} (200, 400, 300, 100, 100, 200) ;
   array Over{6} Over1-Over6;
   do i=1 to 6;
   if Mon(i)>Target{i} then Over(i)=Mon(i)-Target{i};
   Total_Over=sum(of Over{*});
   end;
   if Total_Over>500 then output;
run;
proc print data=preferred_cust noobs;
run;


/*08_02 Using a Character Array for Table Lookup*/
libname prg2 "/courses/d0f434e5ba27fe300/s5066/prg2" access=readonly;
data passed failed;
   set prg2.test_answers;
   score=0;
   array Q{10} Q1-Q10;
   array Ans{10} $ ('A','C','C','B','E','E','D','B','B','A');
   array Sco{10} Sco1-Sco10;
   Score=0;
   do i=1 to 10;
   if Q(i)=Ans(i) then Score=Score+1;
   end;
   if Score>=7 then output passed;
   else output failed;
   keep Employee_ID Q1-Q10 Score;
run;
proc print data=passed;
title 'Passed';
run;
proc print data=failed;
title 'Failed';
run;
title;




/*09_02 Create Nhanes3 Labsub1 by replacing fill values*/
libname Nhanes3 "/courses/d0f434e5ba27fe300/s5066/Nhanes3";
proc means data=Nhanes3.Labsubset;
run;
data work.labsub1(drop=i);
 set Nhanes3.Labsubset;
 array Nhs{11} seqn hgp htp tcp tgp lcp hdp fbpsi crp sgp urp;
 array unk{11} _temporary_(3*88888,888,8888,2*888,8888,88888,888,88888);
 do i=1 to 11;
 if Nhs{i} eq unk{i} then Nhs{i}=.;
 end;
run;

 
proc means data=work.labsub1;
run;

 

