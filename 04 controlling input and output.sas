/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01Outputting Multiple Observations*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;

data work.price_increase;
   set orion.prices;
   Year=1;
   Unit_Price=Unit_Price*Factor;
   output;
   Year=2;
   Unit_Price=Unit_Price*Factor;
   output;
   Year=3;
   Unit_Price=Unit_Price*Factor;
   output;
   keep Product_ID Unit_Price Year; 
run;
proc print data=work.price_increase;
title 'Forecast unit prices for the next three years';
run;


/*02_02Outputting Multiple Observations*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;

data work.extended;
   set orion.discount;
   where Start_Date='01Dec2007'd;
   Promotion='Happy Holidays';
   Season='Winter';
   output;
   Promotion='Happy Holidays';
   Start_Date='01Jul2008'd;
   End_Date='31Jul2008'd;
   Season='Summer';
   output;
   drop Unit_Sales_Price ;
 run;

proc print data=work.extended;
title 'Discounts from the Happy Holidays promotion';
run;

/*03_03Using Conditional Logic to Output Multiple Observations*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;
data work.lookup;
 set orion.country;
  Outdated='N';
  output;
  if Country_FormerName ^= null then do Outdated='Y';
  Country_Name=Country_FormerName;
  output;
  end;
  drop Country_FormerName Population null;
run;

proc print data=work.lookup;
 title 'Country Names and Lookup Codes';
run;
 

/*04_01Creating Multiple SAS Data Sets*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;

data work.admin work.stock work.purchasing other;
 set orion.employee_organization;
 if Department='Administration' then output work.admin;
 else if Department='Stock & Shipping' then output work.stock;
 else if Department='Purchasing' then output work.purchasing;
 else output other;
run;

proc print data=work.admin;
title 'Employees from administrative department';
run;
proc print data=work.stock;
title 'Employees from stock & shipping department';
run;
proc print data=work.purchasing;
title 'Employees from purchasing department';
run;


/*05_02Creating Multiple SAS Data Sets with Derived Values*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;
data work.fast work.slow work.veryslow other;
  set orion.orders;
  where Order_Type=2 or Order_Type=3 ;
  ShipDays= Delivery_Date-Order_Date;
   if (ShipDays <3) then output work.fast;
   else if (ShipDays>=5 and ShipDays<=7) then output work.slow;
   else if (ShipDays >7) then output work.veryslow;
   else output other;
  drop Employee_ID;
run;

proc print data=work.veryslow;
title 'Orders that deliver very slow';
run;


/*06_03Using a SELECT Group*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;
data work.fast work.slow work.veryslow other;
  set orion.orders;
  where Order_Type=2 or Order_Type=3;
  ShipDays= Delivery_Date-Order_Date;
  select;
  when (ShipDays <3) output work.fast;
  when (ShipDays>=5 and ShipDays<=7) output work.slow;
  when (ShipDays >7) output work.veryslow;
  otherwise output other;
  end;
  drop Employee_ID;
run;

proc print data=work.veryslow;
title 'Orders that deliver very slow';
run;


/*07_01Specifying Variables and Observations*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;

data work.sales(keep=Employee_ID Job_Title Manager_ID) 
     work.exec(keep=Employee_ID Job_Title)
     other;
 set orion.employee_organization;
 if Department='Sales' then output work.sales;
 else if Department='Executives' then output work.exec;
 else output other;
run;

proc print data=work.sales(obs=6);
title 'Employees from sales department';
run;
proc print data=work.exec(firstobs=2 obs=3);
title 'Employees from executives department';
run;


/*08_02Specifying Variables and Observations*/
libname orion "/courses/d0f434e5ba27fe300/s5066/prg2" ;

data work.instore(keep=Order_ID Customer_ID Order_Date)
     work.delivery(keep=Order_ID Customer_ID Order_Date ShipDays);
 set orion.orders;
 where Order_Type=1; 
 ShipDays= Delivery_Date-Order_Date;
 if ShipDays=0 then output work.instore;
 else output work.delivery;
run;

proc print data=orion.orders;
title 'Information of all orders';
run;
proc print data=work.instore;
title 'In-store oder information';
run;
proc print data=work.delivery;
title 'Information of orders that on delivery';
run;

title 'In-stock Store Purchases, By Year';
proc freq data=instore;
  tables Order_Date;
  format Order_Date year.;
run;
title;


