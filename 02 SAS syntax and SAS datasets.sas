/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/* 04_01 misspelled "print"*/

filename RAWDATA  "/courses/d0f434e5ba27fe300/s5066/RawData";

data work.country;
   length Country_Code $ 2 Country_Name $ 48;
   infile rawdata(country.dat)  dlm='!' termstr=crlf;
   input Country_Code $ Country_Name $;
run;

proc print data=work.country;
run;

/*04_02 missing semi-colon*/

libname prg1 "/courses/d0f434e5ba27fe300/s5066/prg1";
proc print data=prg1.bonus (obs=10);
var employee_id first_name last_name;
title "First 10 employees on data file";
run;



/*05_01 Examining the Data Portion*/

filename RAWDATA  "/courses/d0f434e5ba27fe300/s5066/RawData";
data work.donations;
   infile rawdata(donation.dat) termstr=crlf;
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc contents data=work.donations;
    run;

proc print data=work.donations;
run;

proc print data=work.donations noobs;
var Employee_ID Total;
run;



/*05_02 Examining the Descriptor and Data Portions*/

data work.newpacks;
   input Supplier_Name $ 1-20 Supplier_Country $ 23-24 
         Product_Name $ 28-70;
   datalines;
Top Sports            DK   Black/Black
Top Sports            DK   X-Large Bottlegreen/Black
Top Sports            DK   Commanche Women's 6000 Q Backpack. Bark
Miller Trading Inc    US   Expedition Camp Duffle Medium Backpack
Toto Outdoor Gear     AU   Feelgood 55-75 Litre Black Women's Backpack
Toto Outdoor Gear     AU   Jaguar 50-75 Liter Blue Women's Backpack
Top Sports            DK   Medium Black/Bark Backpack
Top Sports            DK   Medium Gold Black/Gold Backpack
Top Sports            DK   Medium Olive Olive/Black Backpack
Toto Outdoor Gear     AU   Trekker 65 Royal Men's Backpack
Top Sports            DK   Victor Grey/Olive Women's Backpack
Luna sastreria S.A.   ES   Deer Backpack
Luna sastreria S.A.   ES   Deer Waist Bag
Luna sastreria S.A.   ES   Hammock Sports Bag
Miller Trading Inc    US   Sioux Men's Backpack 26 Litre.
;
run;

proc contents data=work.newpacks;
run;
    
proc print data=work.newpacks noobs;
var Product_Name Supplier_Name;
run;


/*05_03 Examining the nhanes 3 data*/

libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

proc contents data=Nhanes3._all_ nods;
run;
