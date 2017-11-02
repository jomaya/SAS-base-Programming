/*Hui Yuan*/
/*I certify that this submission contains only my own work.*/

/*01_01 Subsetting Observations and Variables Using the WHERE and KEEP Statements*/

libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.youngadult;
 set orion.customer_dim;
 where Customer_Gender = 'F'and Customer_Age between 18 and 36 and Customer_Group contains 'Gold';
 keep Customer_Name Customer_Age Customer_BirthDate Customer_Gender Customer_Group;
run;

proc print data=work.youngadult;
run;


/*02_02 Subsetting Observations and Variables Using the WHERE and DROP Statements*/

libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.sports;
 set orion.product_dim;
 where (Supplier_Country in ('GB','ES','NL')) and (Product_Category like '%Sports');
 drop Product_ID Product_Line Product_Group Supplier_Name Supplier_ID;
run;

proc print data=work.sports (obs=10);
run;

/*03_01 Adding Permanent Attributes to work*/

libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;
data work.youngadult;
   set orion.customer_dim;
   where Customer_Gender='F' and 
         Customer_Age between 18 and 35 and
         Customer_Group contains 'Gold';
   keep Customer_Name Customer_Age Customer_BirthDate 
        Customer_Gender Customer_Group;
   label Customer_Gender='Gender'
         Customer_BirthDate='Date of Birth'
         Customer_Group='Member level';
   format Customer_BirthDate WORDDATE.;
run;

proc contents data=work.youngadult;
run;

proc print data=work.youngadult label;
run;

/*04_02 Adding Permanent Attributes to the sports work file*/

libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.sports;
   set orion.product_dim;
   where Supplier_Country in ('GB','ES','NL') and 
         Product_Category like '%Sports';
   drop Product_ID Product_Line Product_Group Supplier_ID;
   label Product_Category='Sports Category'
         Product_Name='Product Name (Abbrev)'
         Supplier_Name='Supplier Name (Abbrev)';
   format Product_Name $15. Supplier_Name $15.;  
run;

proc print data=work.sports (obs=10) label;
run;

proc contents data=work.sports;
run;


/*05_03 Using the upcasew format and the split option*/

libname orion "/courses/d0f434e5ba27fe300/s5066/prg1" access=readonly;

data work.tony;
   set orion.customer_dim(keep=Customer_FirstName Customer_LastName); 
   where Customer_FirstName =* 'Tony';
   label Customer_FirstName='CUSTOMER*FIRST NAME'
         Customer_LastName='CUSTOMER*LAST NAME';
   format Customer_FirstName $upcase12. Customer_LastName $upcase12.;
run;

proc print data=work.tony SPLIT='*';
run;


/*06_01 CreateNhanes3AdultDemographicsFile*/

libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.AdultDemographics1;
   set Nhanes3.Adult;
   keep seqn dmarethn dmaracer dmaethnr hssex hsageir;
 length seqn 7;
 length dmarethn 3;
 length dmaracer 3;
 length dmaethnr 3;
 length hssex 3;
 length hsageir 3;
run;
   
proc contents data=work.AdultDemographics1;
run;


/*07_01 CreateNhanes3ExamSub*/

libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.examsub1;
   set NHANES3.exam;
   keep seqn hsageir hssex dmaracer bmpwt bmpht pep6g1 
        pep6h1 pep6i1 pep6g3 pep6h3 pep6i3 sppfvc sppfev1;
   label seqn='Identification number' hsageir='Age at Interview' hssex='Gender' dmaracer='Race' 
      bmpwt='Weight in kg' bmpht='Height in cm' pep6g1='Systolic Blood Pressure, 1st reading'
      pep6h1='Systolic Blood Pressure, 2nd reading' pep6i1='Systolic Blood Pressure, 3rd reading'
      pep6g3='Diastolic Blood Pressure, 1st reading' pep6h3='Diastolic Blood Pressure, 2nd reading'
      pep6i3='Diastolic Blood Pressure, 3rd reading' sppfvc='Forced Vital Capacity (ml)'
      sppfev1='Forced Vital Capacity, 1st second (ml)';
run;
  
proc contents data=work.examsub1;
run;

 
/*08_01 CreateNhanes3Labsub*/

libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.labsub1;
    set Nhanes3.lab;
	keep seqn hgp htp tcp tgp lcp hdp fbpsi crp sgp urp;
    label seqn='sequence number' hgp='hemoglobin (g/dl)' htp='hematocrit (%)'
      tcp='cholesterol (mg/dl)' tgp='triglycerides (mg/dl)' lcp='low density lipoprotein (mg/dl)'
	  hdp='high density lipoprotein (mg/dl)' fbpsi='fibrinogen (mg/dl)' crp='C reactive protein (mg/dl)&'
      sgp='plasma glucose (mg/dl)' urp='urinary creatinine (mg/dl)';	
run;

proc contents data=work.labsub1;
run;


/*09_01 CreateNhanes3Mortsub*/

libname Nhanes3  "/courses/d0f434e5ba27fe300/s5066/Nhanes3" access=readonly;

data work.mortsub1;
  set NHANES3.mortality;
  where eligstat=1;
run;
 
proc contents data=work.mortsub1;
run;


