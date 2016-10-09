options linesize=95 pagesize=52;

libname orion '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data';

*p102d01;

options linesize=95 pagesize=52;

data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18 Job_Title $ 25;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/newemps.csv' dlm=',';
   input First_Name $ Last_Name $ Job_Title $ Salary;
run;

proc print data=work.NewSalesEmps;
run;

proc means data=work.NewSalesEmps;
   class Job_Title;
   var Salary;
run;

*p102e01;

options linesize=95 pagesize=52;

data work.country;
   length Country_Code $ 2 Country_Name $ 48; /* only dsd has impact not missover but BP */
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/country.dat' dlm='!' dsd missover; 
   input Country_Code $ Country_Name $;
run;
proc print data=work.country;
run;


*p102e02;

data work.SalesEmps;
   length Job_Title $ 25;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/sales.csv' dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $;
run;

goptions reset=all;
proc gchart data=work.SalesEmps;
   vbar3d Job_Title / sumvar=Salary type=mean;
   hbar Job_Title / group=Gender sumvar=Salary 
                    patternid=midpoint;
   pie3d Job_Title / noheading;
   where Job_Title contains 'Sales Rep';
   label Job_Title='Job Title';
   format Salary dollar12.;
   title 'Orion Star Sales Employees';
run;
quit;

*p102s02;

proc setinit;
run;

data work.SalesEmps;
   length Job_Title $ 25;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/sales.csv' dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $;
run;

goptions reset=all;
proc gchart data=work.SalesEmps;
   vbar3d Job_Title / sumvar=Salary type=mean;
   hbar Job_Title / group=Gender sumvar=Salary patternid=midpoint;
   pie3d Job_Title / noheading;
   where Job_Title contains 'Sales Rep';
   label Job_Title='Job Title';
   format Salary dollar12.;
   title 'Orion Star Sales Employees';
run;
quit;

*p103a01;

***********************************************
* This DATA step uses the DATALINES statement * 
* with an INPUT statement to read data that   *
* is directly entered in the program, rather  *
* than data stored in an external file.       *
***********************************************;

data work.NewEmps;
   input First_Name $ Last_Name $  
         Job_Title $ Salary;
   datalines;
Steven Worton Auditor 40450
Merle Hieds Trainee 24025
;
run;
/*
proc contents data=work.NewEmps;
run;
*/
proc print data=work.NewEmps;
run;

*p103d01;

data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile 'newemps.csv' dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary;
run;

proc print data=work.NewSalesEmps;
run;

proc means data=work.NewSalesEmps;
   class Job_Title;
   var Salary;
run;


*p103d02;

*----------------------------------------*
|   This program creates and uses the    |
|   data set called work.NewSalesEmps.   |
*----------------------------------------*; 

data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/newemps.csv' dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary;  /*numeric*/
run;

/*
proc print data=work.NewSalesEmps;
run;
*/

proc means data=work.NewSalesEmps;
   class Job_Title;
   var Salary;
run;


*p103d03;

data work.NewSalesEmps;
   length First_Name $ 12 
          Last_Name $ 18 Job_Title $ 25;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/newemps.csv' dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary;
run;

proc print data=work.NewSalesEmps;
run;

proc means data=work.NewSalesEmps mean max;
   class Job_Title;
   var Salary;
run;


*p103d04;

data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/newemps.csv' dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary;
run;

proc print data=work.NewSalesEmps;
run;

proc means data=work.NewSalesEmps;
   class Job_Title;
   var Salary;
run;


*p103e01;
data work.country;
   length Country_Code $ 2 Country_Name $ 48;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/country.dat' dlm='!';
   input Country_Code $ Country_Name $;
run;

proc prnt data=work.country;
run;


*p103e02;
data work.donations;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/donation.dat';
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc print data=work.donations;

*p103s01;
data work.country;
   length Country_Code $ 2 Country_Name $ 48;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/country.dat' dlm='!';
   input Country_Code $ Country_Name $;
run;

proc print data=work.country;
run;


*p103s02;
data work.donations;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/donation.dat';
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc print data=work.donations;
run;

*p104a01;
/*********************************************************
*  1. After the DATA step, add a PROC CONTENTS step to   *
*     view the descriptor portion of work.donations.     *                         
*  2. Submit the program and review the results.         *
*  3. How many observations are in the data set?         *
*********************************************************/

data work.donations;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/donation.dat';
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc contents data = work.donations;
run;

*p104a01s;
/*********************************************************
*  1. After the DATA step, add a PROC CONTENTS step to   *
*     view the descriptor portion of work.donations.     *                 
*  2. Submit the program and review the results.         *
*  3. How many observations are in the data set?         *
*********************************************************/

data work.donations;
   infile 'donation.dat';
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc contents data=work.donations;
run;

*p104a02;
/*********************************************************
*  1. Submit the program.                                *
*  2. View the output to retrieve the current data as a  *
*     numeric value referencing January 1, 1960.         * 
*********************************************************/

data work.date;
   CurrentDate=today();
run;

proc print data=work.date;
run;

*p104d01;
data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile 'newemps.csv' dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary;
run;

proc contents data=work.NewSalesEmps;
run;

*p104d02;
data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile 'newemps.csv' dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary;
run;

proc print data=work.NewSalesEmps;
run;

*p104d03;
data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/newemps.csv' dlm=',';
   input First_Name $ Last_Name $  
         Job_Title $ Salary;
run;

proc print data=work.NewSalesEmps noobs;
   var Last_Name First_Name Salary;
run;

*p104d04;
*libname orion 's:\workshop';

proc contents data=orion._all_ nobs;
run;


*p104d05;
libname oralib oracle user=edu001 pw=edu001 
                      path=dbmssrv schema=educ;

proc print data=oralib.supervisors;
run;

data work.staffpay;
   merge oralib.staffmaster 
         oralib.payrollmaster;
   by empid;
run;

libname oralib clear;

*p104e01;
data work.donations;
   infile 'donation.dat';
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc contents data=work.donations;
run;

*p104e02;
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

*p104e03;
data work.date;
   CurrentDate=today();
   CurrentTime=time();
   CurrentDateTime=datetime();
run;

proc print data=work.date;
run;

*p104s01;
data work.donations;
   infile 'donation.dat';
   input Employee_ID Qtr1 Qtr2 Qtr3 Qtr4;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
run;

proc contents data=work.donations;
run;

proc print data=work.donations noobs;
   var Employee_ID Total;
run;

*p104s02;
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

*p104s03;
data work.date;
   CurrentDate=today();
   CurrentTime=time();
   CurrentDateTime=datetime();
run;

proc print data=work.date;
run;

*p104s04;
libname orion 's:\workshop';

proc contents data=orion._all_ nods;
run;

proc contents data=orion.sales;
run;

*p104s04;
libname _all_ list;

*p105a01;
/*********************************************************
*  1. Submit the program and confirm that a new SAS      *
*     data set was created with 77 observation and       * 
*     12 variables.                                      *
*  2. True or False: The DATA step reads a temporary     *
*     SAS data set to create a permanent SAS data set.   *
*********************************************************/

libname orion '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/';

data work.mycustomers;
   set orion.customer;
run;

proc print data=work.mycustomers; 
   var Customer_ID Customer_Name 
       Customer_Address;
run;
 
*p105d01;
libname orion '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/';

data work.subset1;
   set orion.sales;
run;

proc print data=work.subset1;
run;

*p105d02;
data work.subset1;
   set orion.sales;
   where Country='AU' and 
         Job_Title contains 'Rep';
run;

proc print data=work.subset1;
run;

*p105d03;
data work.subset1;
   set orion.sales;
   where Country='AU' and 
         Job_Title contains 'Rep';
   keep First_Name Last_Name Salary 
        Job_Title Hire_Date;
run;

proc print data=work.subset1;
run;


*p105d04;
data work.subset1;
   set orion.sales;
   where Country='AU' and 
         Job_Title contains 'Rep';
   keep First_Name Last_Name Salary 
        Job_Title Hire_Date;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
run;

proc contents data=work.subset1;
run;

proc print data=work.subset1 label;
run;


*p105d05;
data work.nlsformats;
   nldate=0; nldatemn=0;
   nldatew=0; nldatewn=0; output;
   nldate=17245; nldatemn=17245;
   nldatew=17245; nldatewn=17245; output;
run;

options locale=German_Germany;
proc print data=work.nlsformats;
   format nldate nldate. nldatemn nldatemn.
          nldatew nldatew. nldatewn nldatewn.;
run;

options locale=English_UnitedStates;
proc print data=work.nlsformats;
   format nldate nldate. nldatemn nldatemn.
          nldatew nldatew. nldatewn nldatewn.;
run;


*p105d06;
data work.subset1;
   set orion.sales;
   where Country='AU' and 
         Job_Title contains 'Rep';
   keep First_Name Last_Name Salary 
        Job_Title Hire_Date;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   format Salary commax8. Hire_Date ddmmyy10.;
run;

proc contents data=work.subset1;
run;

proc print data=work.subset1 label;
run;

*p105e01;
data work.youngadult;
set orion.customer_dim;
where Customer_Gender eq 'F' and Customer_Age between 18 and 36 and Customer_Group contains 'Gold';
keep Customer_Name Customer_Age Customer_BirthDate Customer_Gender Customer_Group;
run;

proc print data=work.youngadult;
run;

*p105e04;
data work.youngadult;
   set orion.customer_dim;
   where Customer_Gender='F' and 
         Customer_Age between 18 and 35 and
         Customer_Group contains 'Gold';
   keep Customer_Name Customer_Age Customer_BirthDate 
        Customer_Gender Customer_Group;
run;

proc contents data=work.youngadult;
run;

proc print data=work.youngadult;
run; 


*p105e05;
data work.sports;
   set orion.product_dim;
   where Supplier_Country in ('GB','ES','NL') and 
         Product_Category like '%Sports';
   drop Product_ID Product_Line Product_Group Supplier_ID;
run;

proc print data=work.sports;
run;


*p105e06;
data work.tony;
   set orion.customer_dim(keep=Customer_FirstName Customer_LastName); 
   where Customer_FirstName =* 'Tony';
run;

proc print data=work.tony label;
run;



*p105s01;
data work.youngadult;
   set orion.customer_dim;
   where Customer_Gender='F' and 
         Customer_Age between 18 and 36 and
         Customer_Group contains 'Gold';
   keep Customer_Name Customer_Age Customer_BirthDate 
        Customer_Gender Customer_Group;
run;

proc print data=work.youngadult;
run;


*p105s02;
data work.sports;
   set orion.product_dim;
   where Supplier_Country in ('GB','ES','NL') and 
         Product_Category like '%Sports';
   drop Product_ID Product_Line Product_Group 
        Supplier_Name Supplier_ID;
run;

proc print data=work.sports;
run;


*p105s03;
data work.tony;
   set orion.customer_dim(keep=Customer_FirstName Customer_LastName); 
   where Customer_FirstName =* 'Tony';
run;

proc print data=work.tony;
run;


*p105s04;
data work.youngadult;
   set orion.customer_dim;
   where Customer_Gender='F' and 
         Customer_Age between 18 and 35 and
         Customer_Group contains 'Gold';
   keep Customer_Name Customer_Age Customer_BirthDate 
        Customer_Gender Customer_Group;
   label Customer_Gender='Gender'
         Customer_BirthDate='Date of Birth'
         Customer_Group='Member Level';
   format Customer_BirthDate worddate.;
run;

proc contents data=work.youngadult;
run;

proc print data=work.youngadult label;
run; 


*p105s05;
data work.sports;
   set orion.product_dim;
   where Supplier_Country in ('GB','ES','NL') and 
         Product_Category like '%Sports';
   drop Product_ID Product_Line Product_Group Supplier_ID;
   label Product_Category='Sports Category'
         Product_Name='Product Name (Abbrev)'
		 Supplier_Name='Supplier Name (Abbrev)';
   format Product_Name Supplier_Name $15.;
run;

proc print data=work.sports label;
run;

proc contents data=work.sports;
run;


*p105s06;
data work.tony;
   set orion.customer_dim(keep=Customer_FirstName Customer_LastName); 
   where Customer_FirstName =* 'Tony';
   format Customer_FirstName Customer_LastName $upcase.;
   label Customer_FirstName='CUSTOMER*FIRST NAME'
         Customer_LastName='CUSTOMER*LAST NAME';
run;

proc print data=work.tony split='*';
run;

proc setinit;
run;

/*p106d01;
libname orionxls '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/sales.xls';

proc contents data=orionxls._all_;
run;

proc print data=orionxls.'Australia$'n;
run;

libname orionxls clear;


*p106d02;

data work.subset2;
   set orionxls.'Australia$'n;
   where Job_Title contains 'Rep';
   keep First_Name Last_Name Salary 
        Job_Title Hire_Date;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   format Salary comma10. Hire_Date weekdate.;
run;

proc contents data=work.subset2;
run;

proc print data=work.subset2 label;
run;

libname orionxls clear;

*p106d03;

********** Creating Excel Worksheets with DATA Step **********;
libname orionxls 'qtr2007a.xls';

data orionxls.qtr1_2007;
   set orion.qtr1_2007;
run;

data orionxls.qtr2_2007;
   set orion.qtr2_2007;
run;

proc contents data=orionxls._all_;
run;

libname orionxls clear;

********** Creating Excel Worksheets with PROC COPY Step **********;
libname orionxls 'qtr2007b.xls';

proc copy  in=orion out=orionxls;
   select qtr1_2007 qtr2_2007;
run;

proc contents data=orionxls._all_;
run;

libname orionxls clear;
*/
*p106d04;
PROC IMPORT OUT= WORK.subset2a 
            DATAFILE= "/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/sales.xls" 
            DBMS=XLS REPLACE;
     sheet="Australia"; 
     GETNAMES=YES;
     MIXED=NO;
RUN;

proc print data=work.subset2a;
run;

proc contents data=work.subset2a;
run;

*p106d04a;
PROC IMPORT OUT= WORK.subset2a 
            DATAFILE= "/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/sales.xls" 
            DBMS=XLs REPLACE;
     sheet="Australia"; 
     GETNAMES=YES;
     MIXED=NO;

RUN;

*p106d04b;
PROC EXPORT DATA= ORION.QTR1_2007 
            OUTFILE= "S:\Workshop\qtr2007c.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="qtr1"; 
RUN;

*p106e01;
proc contents data=custfm._all_;
run;

data work.males;

run;

proc print data=work.males label;
run;

libname custfm clear;

*p106s01;
libname custfm 'custfm.xls';

proc contents data=custfm._all_;
run;

data work.males;
   set custfm.'Males$'n;
   keep First_Name Last_Name Birth_Date;
   format Birth_Date year4.;
   label Birth_Date='Birth Year';
run;

proc print data=work.males label;
run;

libname custfm clear;

*p106e02;
libname prod 'products.xls';

proc contents data=prod._all_;
run;

data work.golf;
   set prod.'Sports$'n;
   where Category='Golf';
   drop Category;
   label Name='Golf Products';
run;

libname prod clear;

proc print data=work.golf label;
run;

*p106e03;
libname xlsdata 'custcaus.xls' header=no;

proc contents data=xlsdata._all_;
run;

data work.germany;
   set xlsdata.DE;
   label F1='Customer ID'
         F2='Country'
		 F3='Gender'
		 F4='First Name'
		 F5='Last Name'
		 F6='Birth Date';
   format F6 ddmmyy8.;
run;

libname xlsdata clear;

proc print data=work.germany label;
run;

*p106e04;
libname mnth 'mnth2007.xls';

proc copy  in=orion out=mnth;
   select mnth7_2007 mnth8_2007 mnth9_2007;
run;

proc contents data=mnth._all_;
run;

libname mnth clear;

*p106e05;
proc print data=work.children;
run;

PROC IMPORT OUT= WORK.children 
            DATAFILE= "S:\Workshop\products.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="Children$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


*p106e06;

proc export data=orion.mnth7_2007 
            outfile='mnth7.xls' 
            dbms=excel replace;
run;

*p107a01;
data contacts;
   length Name $ 20 Phone Mobile $ 14;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/phone2.csv' dlm=',';
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts noobs;
run;

*p107a02;
data contacts;
   length Name $ 20 Phone Mobile $ 14;
   infile 'phone.csv' dsd;
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts noobs;
run;

*p107a03;
data contacts;
   length Name $ 20 Phone Mobile $ 14;
   infile 'phone.csv' dsd;
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts noobs;
run;

*p107a03s;
data contacts;
   length Name $ 20 Phone Mobile $ 14;
   infile 'phone.csv' dsd missover;
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts noobs;
run;


*p107d01;
data work.subset3;
   infile 'sales.csv' dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $;
run;

proc print data=work.subset3;
run;

*p107d02;
data work.subset3;
   length First_Name $ 12 Last_Name $ 18 
          Gender $ 1 Job_Title $ 25 
          Country $ 2;
   infile 'sales.csv' dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $;
run;

proc print data=work.subset3;
run;

*p107d03;
data work.subset3;
   length First_Name $ 12 Last_Name $ 18 
          Gender $ 1 Job_Title $ 25 
          Country $ 2;
   infile 'sales.csv' dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date. 
         Hire_Date :mmddyy.;
run;

proc print data=work.subset3;
run;

*p107d04;
data work.subset3;
   length First_Name $ 12 Last_Name $ 18 
          Gender $ 1 Job_Title $ 25 
          Country $ 2;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/sales.csv' dlm=',';
   input Employee_ID First_Name $ Last_Name $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date. 
         Hire_Date :mmddyy.;
   keep First_Name Last_Name Salary 
        Job_Title Hire_Date;
   label Job_Title='Sales Title'
         Hire_Date='Date Hired';
   format Salary dollar12. Hire_Date monyy7.;
run;

proc print data=work.subset3 label;
run;

*p107d05;
data contacts;
   length Name $ 20 Phone Mobile $ 14;
   infile 'phone2.csv' dsd;
   input Name $ Phone $ Mobile $;
run;

proc print data=contacts noobs;
run;

*p107e01;
data work.NewEmployees;

run;

proc print data=work.NewEmployees;
run;

*p107e04;
data work.canada_customers;
infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/custca.csv' dsd;
input n1 $ n2 $ num Gend $ date $ ddmmyy10. Age Agebet $;
drop num;
format date monyy7.;
run;

proc print data=work.canada_customers;
run;


*p107s01;
data work.NewEmployees;
   length First $ 12 Last $ 18 Title $ 25 Salary 8;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/newemps.csv' dlm=',';
   input First $ Last $ Title $ Salary;
run;

proc print data=work.NewEmployees;
run;

*p107s02;
data work.QtrDonation;
   length IDNum $ 6 Qtr1 8 Qtr2 8 Qtr3 8 Qtr4 8;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/donation.dat';
   input IDNum $ Qtr1 Qtr2 Qtr3 Qtr4;
run;

proc print data=work.QtrDonation;
run;

*p107s03;
data work.supplier_info;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/supplier.dat';
   input ID 1-5 Name $ 8-37 Country $ 40-41;
run;

proc print data=work.supplier_info;
run;


*p107s04;
data work.canada_customers;
   length First Last $ 20 Gender $ 1 AgeGroup $ 12;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/custca.csv' dlm=',';
   input First $ Last $ ID Gender $ 
         BirthDate :ddmmyy. Age AgeGroup $;
   format BirthDate monyy7.;
   drop ID Age;
run;

proc print data=work.canada_customers;
run;

*p107s05;
data work.us_customers;
   length Name $ 20 Gender $ 1 AgeGroup $ 12;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/custus.dat' dlm=' ' dsd;
   input Name $ ID Gender $ BirthDate :date.
         Age AgeGroup $;
   format BirthDate monyy7.;
run;

proc print data=work.us_customers;
   var Name Gender BirthDate AgeGroup Age;
run;


*p107s06;
data work.prices;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/prices.dat' dlm='*' missover;
   input ProductID StartDate $ :date. EndDate $ :date. UnitCostPrice :dollar.  UnitSalesPrice :dollar. ;

run;

proc print data=work.prices;
run;

*p108a01;
/*********************************************************
*  1. Submit the program.                                *
*  2. Determine the reason for the invalid data that     *
*     appears in the SAS log.                            * 
*  3. Which statement best describes the invalid data?   *   
*     The data in the raw data file is bad.	             *
*     The programmer incorrectly read the data.	         *
*********************************************************/

data work.nonsales;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/nonsales.csv' dlm=',' dsd;
   input Employee_ID First $ Last $ Gender $ Num Position $ CC $ date $ ddmmyy10. d2 $  ddmmyy10.;
run;

proc print data=work.nonsales;
run;



*p108a01s;

/*********************************************************
*  1. Submit the program.                                *
*  2. Determine the reason for the invalid data that     *
*     appears in the SAS log.                            * 
*  3. Which statement best describes the invalid data?   *   
*     The data in the raw data file is bad.	             *
*     The programmer incorrectly read the data.	         *
*********************************************************/

data work.nonsales;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/nonsales.csv' dlm=',' dsd;
   input Employee_ID First $ Last $;
run;

proc print data=work.nonsales;
run;

*p108d01;
data work.nonsales;
   length Employee_ID 8 First $ 12 Last $ 18 
          Gender $ 1 Salary 8 Job_Title $ 25 Country $ 2
          Birth_Date Hire_Date 8;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/nonsales.csv' dlm=',';
   input Employee_ID First $ Last $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date9. 
         Hire_Date :date9.;
   format Birth_Date Hire_Date ddmmyy10.;
run;

proc print data=work.nonsales;
run;

proc print data=work.nonsales;
   var Employee_ID Job_Title Birth_Date Hire_Date;
   where Job_Title = ' ' or 
         Birth_Date > Hire_Date;
run;

proc freq data=work.nonsales;
   tables Gender Country;
run;

proc means data=work.nonsales n nmiss min max;
   var Salary;
run;

proc univariate data=work.nonsales;
   var Salary;
run;

*p108d02;
data work.nonsales;
   length Employee_ID 8 First $ 12 Last $ 18 
          Gender $ 1 Salary 8 Job_Title $ 25 Country $ 2
          Birth_Date Hire_Date 8;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/nonsales.csv' dlm=',';
   input Employee_ID First $ Last $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date9. 
         Hire_Date :date9.;
   format Birth_Date Hire_Date ddmmyy10.;
run;

proc print data=work.nonsales;
run;

*p108d03;
data work.baddata work.gooddata;
   length Employee_ID 8 First $ 12 Last $ 18 
          Gender $ 1 Salary 8 Job_Title $ 25 Country $ 2
          Birth_Date Hire_Date 8;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/nonsales.csv' dlm=',';
   input Employee_ID First $ Last $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date9. 
         Hire_Date :date9.;
   format Birth_Date Hire_Date ddmmyy10.;
   if _error_=1 then output work.baddata;
   else output work.gooddata;
run;

proc print data=work.baddata;
run;

proc print data=work.gooddata;
run;

*p108d04;
proc print data=orion.nonsales;
   var Employee_ID Last Job_Title;
   where Job_Title = ' ';
run;

proc print data=orion.nonsales;
   var Employee_ID Birth_Date Hire_Date;
   where Hire_Date < '01JAN1974'd;
run;

proc print data=orion.nonsales;
   var Employee_ID Gender Salary Job_Title
       Country Birth_Date Hire_Date;
   where Employee_ID = . or
         Gender not in ('F','M') or
         Salary not between 24000 and 500000 or
         Job_Title = ' ' or
         Country not in ('AU','US') or
         Birth_Date > Hire_Date or
         Hire_Date < '01JAN1974'd;
run;

*p108d05;
proc freq data=orion.nonsales;
   tables Gender Country;
run;

proc freq data=orion.nonsales;
   tables Employee_ID;
run;

proc freq data=orion.nonsales nlevels;
   tables Gender Country Employee_ID;
run;

proc freq data=orion.nonsales nlevels;
   tables Gender Country Employee_ID / noprint;
run;

proc freq data=orion.nonsales nlevels;
   tables _all_ / noprint;
run;

*p108d06;
proc means data=orion.nonsales;
   var Salary;
run;

proc means data=orion.nonsales n nmiss min max;
   var Salary;
run;

proc univariate data=orion.nonsales;
   var Salary;
run;

*p108d07;
********** Cleaning Country **********;
data work.clean;
   set orion.nonsales; 
   Country=upcase(Country);
run;

proc print data=work.clean;
   var Employee_ID Job_Title Country;
run;

********** Add Cleaning Salary **********;
data work.clean;
   set orion.nonsales; 
   Country=upcase(Country);
   if Employee_ID=120106 then Salary=26960;
   if Employee_ID=120115 then Salary=26500;
   if Employee_ID=120191 then Salary=24015;
run;

proc print data=work.clean;
   var Employee_ID Salary Job_Title Country;
run;

data work.clean;
   set orion.nonsales; 
   Country=upcase(Country);
   if Employee_ID=120106 then Salary=26960;
   else if Employee_ID=120115 then Salary=26500;
   else if Employee_ID=120191 then Salary=24015;
run;

proc print data=work.clean;
   var Employee_ID Salary Job_Title Country;
run;

********** Add Cleaning Hire_Date **********;
data work.clean;
   set orion.nonsales; 
   Country=upcase(Country);
   if Employee_ID=120106 then Salary=26960;
   else if Employee_ID=120115 then Salary=26500;
   else if Employee_ID=120191 then Salary=24015;
   else if Employee_ID=120107 then 
           Hire_Date='21JAN1995'd;
   else if Employee_ID=120111 then 
           Hire_Date='01NOV1978'd;
   else if Employee_ID=121011 then 
           Hire_Date='01JAN1998'd;
run;

proc print data=work.clean;
   var Employee_ID Salary Job_Title Country Hire_Date;
run;

*p108d08;
data work.clean;
   set orion.nonsales; 
   Country=upcase(Country);
   if Employee_ID=120106 then Salary=26960;
   else if Employee_ID=120115 then Salary=26500;
   else if Employee_ID=120191 then Salary=24015;
   else if Employee_ID=120112 then
           Job_Title='Security Guard I';
   else if Employee_ID=120107 then 
           Hire_Date='21JAN1995'd;
   else if Employee_ID=120111 then 
           Hire_Date='01NOV1978'd;
   else if Employee_ID=121011 then 
           Hire_Date='01JAN1998'd;
   if Gender not in ('F','M') then Gender='F';
   if _N_=7 then Employee_ID=120109;
   else if _N_=14 then Employee_ID=120116;
run;

proc print data=work.clean;
   var Employee_ID Gender Salary Job_Title Country Hire_Date;
run;

********** Validating the Data **********;
proc print data=work.clean;
   var Employee_ID Gender Salary Job_Title
       Country Birth_Date Hire_Date;
   where Employee_ID = . or
         Gender not in ('F','M') or
         Salary not between 24000 and 500000 or
         Job_Title = ' ' or
         Country not in ('AU','US') or
         Birth_Date > Hire_Date or
         Hire_Date < '01JAN1974'd;
run;

proc freq data=work.clean nlevels;
   tables Gender Country Employee_ID;
run;

proc means data=work.clean n nmiss min max;
   var Salary;
run;

proc univariate data=work.clean;
   var Salary;
run;


*p108e01;
proc print data=orion.shoes_tracker;
	where Product_category is missing or Supplier_Country not in ("GB" "US");
run;

proc freq data = orion.shoes_tracker Nlevels;
	tables Supplier_Name*Supplier_ID;
run;


*p108e04;
proc means data=orion.price_current;

run;

*p108e07;
data work.qtr2_2007;
   set orion.qtr2_2007;

run;

proc print data=work.qtr2_2007;
   where Order_Date>Delivery_Date or
         Order_Date<'01APR2007'd or
         Order_Date>'30JUN2007'd;
run;

*p108e08;
proc means data=work.price_current n min max;
   var Unit_Sales_Price;
run;

proc univariate data=work.price_current;
   var Unit_Sales_Price;
run;



*p108e09;
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


*p108s01;
proc print data=orion.shoes_tracker;
   where Product_Category=' ' or
         Supplier_Country not in ('GB','US');
   var Product_Category Supplier_Name Supplier_Country Supplier_ID;
run;

proc freq data=orion.shoes_tracker nlevels;
   tables Supplier_Name Supplier_ID; 
run;


*p108s02;
proc print data=orion.qtr2_2007;
   where Order_Date>Delivery_Date or
         Order_Date<'01APR2007'd or
         Order_Date>'30JUN2007'd;
run;

proc freq data=orion.qtr2_2007 nlevels;
   tables Order_ID Order_Type; 
run;

*p108s03;
proc print data=orion.shoes_tracker;
   where propcase(Product_Name) ne Product_Name;
   var Product_ID Product_Name;
run;

proc freq data=orion.shoes_tracker;
   tables Supplier_Name*Supplier_ID / missing;
run;

*p108s04;
proc means data=orion.price_current n min max;
   var Unit_Cost_Price Unit_Sales_Price Factor;
run;

proc univariate data=orion.price_current;
   var Unit_Sales_Price Factor;
run;

*p108s05;
proc means data=orion.shoes_tracker min max range fw=15;
   var Product_ID;
   class Supplier_Name;
run;

proc univariate data=orion.shoes_tracker;
   var Product_ID;
run;

*p108s06;
ods trace on;

ods select ExtremeObs;
proc univariate data=orion.shoes_tracker;
   var Product_ID;
run;

ods trace off;


*p108s07;
data work.qtr2_2007;
   set orion.qtr2_2007;
   if Order_ID=1242012259 then Delivery_Date='12MAY2007'd;
   else if Order_ID=1242449327 then Order_Date='26JUN2007'd;
run;

proc print data=work.qtr2_2007;
   where Order_Date>Delivery_Date or
         Order_Date<'01APR2007'd or
         Order_Date>'30JUN2007'd;
run;


*p108s08;
data work.price_current;
   set orion.price_current;
   if Product_ID=220200200022 then Unit_Sales_Price=57.30;
   else if Product_ID=240200100056 then Unit_Sales_Price=41.20;
run;

proc means data=work.price_current n min max;
   var Unit_Sales_Price;
run;

proc univariate data=work.price_current;
   var Unit_Sales_Price;
run;



*p108s09;
data work.shoes_tracker;
   set orion.shoes_tracker;
   Supplier_Country=upcase(Supplier_Country);
   if Supplier_Country='UT' then Supplier_Country='US';
   if Product_Category=' ' then Product_Category='Shoes';
   if Supplier_ID=. then Supplier_ID=2963;
   if Supplier_Name='3op Sports' then Supplier_Name='3Top Sports';
   if _n_=4 then Product_ID=220200300079;  
   else if _n_=8 then Product_ID=220200300129;  
   Product_Name=propcase(Product_Name);
   if Supplier_ID=14682 and Supplier_Name='3Top Sports'
      then Supplier_Name='Greenline Sports Ltd';
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


*p109a01;
/*********************************************************
*  1. Submit the program.                                *
*  2. Verify the results.                                *
*  3. Are the correct results produced when the DROP     *
*     statement is placed after the SET statement?       * 
*********************************************************/
 
data work.comp;
   set orion.sales;
   drop Gender Salary Job_Title 
        Country Birth_Date Hire_Date;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
run;

proc print data=work.comp;
run;

*p109a02;
/*********************************************************
*  1. Submit the program.                                *
*  2. Review the results.                                *
*  3. Why are some of the Bonus values missing in the    *
*     PROC PRINT output?                                 *
*********************************************************/

data work.bonus;
   set orion.nonsales;
   if Country='US' 
      then Bonus=500;
   else if Country='AU' 
        then Bonus=300;
run;

proc print data=work.bonus;
   var First Last Country Bonus;
run;



*p109a02s;
/*********************************************************
*  1. Submit the program.                                *
*  2. Review the results.                                *
*  3. Why are some of the Bonus values missing in the    *
*     PROC PRINT output?                                 *
*********************************************************/

data work.bonus;
   set orion.nonsales;
   if upcase(Country)='US' 
      then Bonus=500;
   else if upcase(Country)='AU' 
        then Bonus=300;
run;

proc print data=work.bonus;
   var First Last Country Bonus;
run;


*p109d01;
********** Creating Variables **********;
data work.comp;
   set orion.sales;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
run;

********** Dropping Variables **********;
data work.comp;
   set orion.sales;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
   drop Gender Salary Job_Title 
        Country Birth_Date Hire_Date;
run;

proc print data=work.comp;
run;

*p109d02;
********** DROP= and KEEP= Options **********;
data work.comp(drop=Salary Hire_Date);
   set orion.sales(keep=Employee_ID First_Name 
                        Last_Name Salary Hire_Date);
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   BonusMonth=month(Hire_Date);
run;

proc print data=work.comp;
run;


*p109d03;
********** IF-THEN / ELSE Statements **********;
data work.bonus;
   set orion.sales;
   if Country='US' then Bonus=500;
   else if Country='AU' then Bonus=300;
run;

proc print data=work.bonus;
   var First_Name Last_Name Country Bonus;
run;

********** ELSE Statement **********;
data work.bonus;
   set orion.sales;
   if Country='US' then Bonus=500;
   else Bonus=300;
run;

proc print data=work.bonus;
   var First_Name Last_Name Country Bonus;
run;

*p109d04;
********** IF-THEN DO / ELSE DO Statements **********;
data work.bonus;
   set orion.sales;
   if Country='US' then do;
      Bonus=500;
	  Freq='Once a Year';
   end;
   else if Country='AU' then do;
      Bonus=300;
	  Freq='Twice a Year';
   end;
run;

proc print data=work.bonus;
   var First_Name Last_Name Country 
       Bonus Freq;
run;

********** LENGTH Statement **********;
data work.bonus;
   set orion.sales;
   length Freq $ 12;
   if Country='US' then do;
      Bonus=500;
	  Freq='Once a Year';
   end;
   else if Country='AU' then do;
      Bonus=300;
	  Freq='Twice a Year';
   end;
run;

proc print data=work.bonus;
   var First_Name Last_Name Country 
       Bonus Freq;
run;

********** ELSE DO Statement **********;
data work.bonus;
   set orion.sales;
   length Freq $ 12;
   if Country='US' then do;
      Bonus=500;
	  Freq='Once a Year';
   end;
   else do;
      Bonus=300;
	  Freq='Twice a Year';
   end;
run;

proc print data=work.bonus;
   var First_Name Last_Name Country 
       Bonus Freq;
run;


*p109d05;
********** Incorrect WHERE Statement **********;
data work.december;
   set orion.sales;
   BonusMonth=month(Hire_Date);
   Bonus=500;
   Compensation=sum(Salary,Bonus);
   where Country='AU' and BonusMonth=12;
run;

proc print data=work.december;
   var Employee_ID Bonus BonusMonth Compensation;
run;

********** WHERE and Subsetting IF Statements **********;
data work.december;
   set orion.sales;
   where Country='AU';
   BonusMonth=month(Hire_Date);
   if BonusMonth=12;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
run;

proc print data=work.december;
   var Employee_ID Bonus BonusMonth Compensation;
run;

********** Subsetting IF Statement **********;
data work.december;
   set orion.sales;
   BonusMonth=month(Hire_Date);
   if Country='AU' and BonusMonth=12;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
run;

proc print data=work.december;
   var Employee_ID Bonus BonusMonth Compensation;
run;


*p109d06;

********** IF-THEN DELETE Statement **********;
data work.december;
   set orion.sales;
   where Country='AU';
   BonusMonth=month(Hire_Date);
   if BonusMonth ne 12 then delete;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
run;

proc print data=work.december;
   var Employee_ID Bonus BonusMonth Compensation;
run;

********** Subsetting IF Statement **********;
data work.december;
   set orion.sales;
   where Country='AU';
   BonusMonth=month(Hire_Date);
   if BonusMonth=12;
   Bonus=500;
   Compensation=sum(Salary,Bonus);
run;

proc print data=work.december;
   var Employee_ID Bonus BonusMonth Compensation;
run;

*p109e01;
data work.increase;
   set orion.staff;

run;

proc print data=work.increase label;
run;

*p109e04;
data work.region;
   set orion.supplier;

run;

proc print data=work.region;
run;


*p109e07;

data work.increase;
   set orion.staff;
   Increase=Salary*0.10;
   NewSalary=sum(Salary,Increase);
   keep Employee_ID Emp_Hire_Date Salary Increase NewSalary;
   format Salary Increase NewSalary comma10.;
run;

proc print data=work.increase label;
run;


*p109s01;
data work.increase;
   set orion.staff;
   Increase=Salary*0.10;
   NewSalary=sum(Salary,Increase);
   keep Employee_ID Salary Increase NewSalary;
   format Salary Increase NewSalary comma10.;
run;

proc print data=work.increase label;
run;

*p109s02;
data work.birthday;
   set orion.customer;
   Bday2009=mdy(month(Birth_Date),day(Birth_Date),2009);
   BdayDOW2009=weekday(Bday2009);
   Age2009=(Bday2009-Birth_Date)/365.25;
   keep Customer_Name Birth_Date Bday2009 BdayDOW2009 Age2009;
   format Bday2009 date9. Age2009 3.;
run;

proc print data=work.birthday;
run;


*p109s03;
data work.employees;
   set orion.sales;
   FullName=catx(' ',First_Name,Last_Name);
   Yrs2012=intck('year',Hire_Date,'01JAN2012'd);
   format Hire_Date ddmmyy10.;
   label Yrs2012='Years of Employment in 2012';
run;

proc print data=work.employees label;
   var FullName Hire_Date Yrs2012;
run;


*p109s04;
data work.region;
   set orion.supplier;
   length Region $ 17;
   if Country in ('CA','US') then do;
      Discount=0.10;
      DiscountType='Required';
      Region='North America';
   end;
   else do;
      Discount=0.05;
	  DiscountType='Optional';
      Region='Not North America';
   end;
   keep Supplier_Name Country 
        Discount DiscountType Region ;
run;

proc print data=work.region;
run;


*p109s05;
data work.ordertype;
   set orion.orders;
   length Type $ 13 SaleAds $ 5;
   DayOfWeek=weekday(Order_Date);
   if Order_Type=1 then do;
      Type='Catalog Sale';
      SaleAds='Mail';
   end;
   else if Order_Type=2 then do;
      Type='Internet Sale';
	  SaleAds='Email';
   end;
   else if Order_Type=3 then do;
      Type='Retail Sale';
   end;
   drop Order_Type Employee_ID Customer_ID;
run;

proc print data=work.ordertype;
run;


*p109s06;
data work.gifts;
   set orion.nonsales;
   length Gift1 Gift2 $ 15;
   select(Gender);
     when('F') do;
       Gift1='Perfume';
	   Gift2='Cookware';
     end;
     when('M') do;
	   Gift1='Cologne';
	   Gift2='Lawn Equipment';
     end;
	 otherwise do;
	   Gift1='Coffee';
	   Gift2='Calendar';
     end;
   end;
   keep Employee_ID First Last Gift1 Gift2;
run;  

proc print data=gifts;
run;


*p109s07;
data work.increase;
   set orion.staff;
   where Emp_Hire_Date>='01JUL2006'd;
   Increase=Salary*0.10;
   if Increase>3000;
   NewSalary=sum(Salary,Increase);
   keep Employee_ID Emp_Hire_Date Salary Increase NewSalary;
   format Salary Increase NewSalary comma10.;
run;

proc print data=work.increase label;
run;


*p109s08;
data work.delays;
   set orion.orders;
   where Order_Date+4<Delivery_Date 
         and Employee_ID=99999999;
   Order_Month=month(Order_Date);
   if Order_Month=8;
run;

proc print data=work.delays;
run;


*p109s09;

data work.bigdonations;
   set orion.employee_donations;
   Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
   NoDonation=nmiss(Qtr1,Qtr2,Qtr3,Qtr4);
   if Total < 50 or NoDonation > 0 then delete;
run;

proc print data=work.bigdonations;
   var Employee_ID Qtr1 Qtr2 Qtr3 Qtr4 Total NoDonation;
run;


*p110a01;
/*********************************************************
*  1. Add a BY statement to the PROC SORT step to sort   *
*     the observations first by ascending Gender and     * 
*     then by descending Employee_ID within the values   *
*     of Gender.                                         *
*  2. Complete the PROC PRINT statement to reference     *
*     the sorted data set.                               * 
*  3. Submit the program and confirm the sort order      *
*     in the PROC PRINT output.                          * 
*  4. What is the Employee_ID value for the first        *
*     observation in the sorted data set?                *
*********************************************************/

proc sort data=orion.sales
          out=work.sortsales;

run;

proc print data= ; 
   var Gender Employee_ID First_Name 
       Last_Name Salary;
run;
 
*p110a01s;
/*********************************************************
*  1. Add a BY statement to the PROC SORT step to sort   *
*     the observations first by ascending Gender and     * 
*     then by descending Employee_ID within the values   *
*     of Gender.                                         *
*  2. Complete the PROC PRINT statement to reference     *
*     the sorted data set.                               * 
*  3. Submit the program and confirm the sort order      *
*     in the PROC PRINT output.                          * 
*  4. What is the Employee_ID value for the first        *
*     observation in the sorted data set?                *
*********************************************************/

proc sort data=orion.sales
          out=work.sortsales;
   by Gender descending Employee_ID;
run;

proc print data=work.sortsales; 
   var Gender Employee_ID First_Name 
       Last_Name Salary;
run;
 

*p110a02;
/*********************************************************
*  1. Complete the program to match-merge the sorted     *
*     SAS data sets referenced in the PROC SORT steps.   *                                  *
*  2. Submit the program. Correct and resubmit,          *
*     if necessary.                                      * 
*  4. What are the modified, completed statement?        *
*********************************************************/

proc sort data=orion.employee_payroll
          out=work.payroll; 
   by Employee_ID;
run;

proc sort data=orion.employee_addresses
          out=work.addresses;
   by Employee_ID;
run;

data work.payadd;
   merge         ;
   by            ;
run;

proc print data=work.payadd;
   var Employee_ID Employee_Name Birth_Date Salary;
   format Birth_Date weekdate.;
run;


*p110a02s;

/*********************************************************
*  1. Complete the program to match-merge the sorted     *
*     SAS data sets referenced in the PROC SORT steps.   *                                  *
*  2. Submit the program. Correct and resubmit,          *
*     if necessary.                                      * 
*  4. What are the modified, completed statement?        *
*********************************************************/

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
run;

proc print data=work.payadd;
   var Employee_ID Employee_Name Birth_Date Salary;
   format Birth_Date weekdate.;
run;

*p110d01;
********** Create Data **********;
data Emps;
   input First $ Gender $ HireYear;
   datalines;
Stacey	F	2006
Gloria	F	2007
James	M	2007
;
run;

data Emps2008;
   input First $ Gender $ HireYear;
   datalines;
Brett	M	2008
Renee	F	2008
;
run;

data Emps2009;
   input First $ HireYear;
   datalines;
Sara	2009
Dennis	2009
;
run;

data Emps2010;
   input First $ HireYear Country $;
   datalines;
Rose	2010	Spain
Eric	2009	Spain
;
run;

********** Like-Structured Data Sets **********;
proc append base=Emps
            data=Emps2008;
run;

proc print data=Emps;
run;

********** Unlike-Structured Data Sets **********;
proc append base=Emps
            data=Emps2009;
run;

proc print data=Emps;
run;

proc append base=Emps
            data=Emps2010;
run;

********** FORCE Option **********;
proc append base=Emps
            data=Emps2010 force;
run;

proc print data=Emps;
run;


*p110d02;
********** Create Data **********;
data EmpsDK;
   input First $ Gender $ Country $;
   datalines;
Lars	M	Denmark
Kari	F	Denmark
Jonas	M	Denmark
;
run;

data EmpsFR;
   input First $ Gender $ Country $;
   datalines;
Pierre	M	France
Sophie	F	France
;
run;

********** Like-Structured Data Sets **********;
data EmpsAll1;
   set EmpsDK EmpsFR;
run;

proc print data=EmpsAll1;
run;


*p110d03;
********** Create Data **********;
data EmpsCN;
   input First $ Gender $ Country $;
   datalines;
Chang	M	China
Li		M	China
Ming	F	China
;
run;

data EmpsJP;
   input First $ Gender $ Region $;
   datalines;
Cho		F	Japan
Tomi	M	Japan
;
run;

********** Unlike-Structured Data Sets **********;
data EmpsAll2;
   set EmpsCN EmpsJP;
run;

proc print data=EmpsAll2;
run;

********** RENAME= Option **********;
data EmpsAll2;
   set EmpsCN EmpsJP(rename=(Region=Country));
run;

proc print data=EmpsAll2;
run;

********** Interleaving (Self-Study) **********;
data EmpsAll2;
   set EmpsCN EmpsJP(rename=(Region=Country));
   by First;
run;

proc print data=EmpsAll2;
run;

*p110d04;
********** Create Data **********;
data EmpsDUP;
   input First $ Gender $ EmpID;
   datalines;
Matt	M	121160
Julie	F	121161
Brett	M	121162
Julie	F	121161
Chris	F	121161
Julie   F   121163
;
run;

********** Eliminating Duplicates Based on By Variable **********;
proc sort data=EmpsDUP 
          out=EmpsDUP1 nodupkey equals;
  by EmpID;
run;

proc print data=EmpsDUP1;
run;

********** Eliminating Duplicates Based on Observation **********;
proc sort data=EmpsDUP 
               out=EmpsDUP2 noduprecs;
  by EmpID;
run;

proc print data=EmpsDUP2;
run;

*p110d05;
********** Create Data **********;
data EmpsAU;
   input First $ Gender $ EmpID;
   datalines;
Togar	M	121150
Kylie	F	121151
Birin	M	121152
;
run;

data PhoneH;
   input EmpID Phone $15.;
   datalines;
121150 +61(2)5555-1793
121151 +61(2)5555-1849
121152 +61(2)5555-1665
;
run;

********** One-to-One Merge **********;
data EmpsAUH;
   merge EmpsAU PhoneH;
   by EmpID;
run;

proc print data=EmpsAUH;
run;


*p110d06;
********** Create Data **********;
data EmpsAU;
   input First $ Gender $ EmpID;
   datalines;
Togar	M	121150
Kylie	F	121151
Birin	M	121152
;
run;

data PhoneHW;
   input EmpID Type $ Phone $15.;
   datalines;
121150 Home +61(2)5555-1793
121150 Work +61(2)5555-1794
121151 Home +61(2)5555-1849
121151 Work +61(2)5555-1850
121152 Home +61(2)5555-1665
121152 Work +61(2)5555-1666
;
run;

********** One-to-Many Merge **********;
data EmpsAUHW;
   merge EmpsAU PhoneHW;
   by EmpID;
run;

proc print data=EmpsAUHW;
run;


*p110d07;
********** Create Data **********;
data EmpsAU;
   input First $ Gender $ EmpID;
   datalines;
Togar	M	121150
Kylie	F	121151
Birin	M	121152
;
run;

data PhoneC;
   input EmpID Phone $15.;
   datalines;
121150 +61(2)5555-1795
121152 +61(2)5555-1667
121153 +61(2)5555-1348
;
run;

********** Non-matches **********;
data EmpsAUC;
   merge EmpsAU PhoneC;
   by EmpID;
run;

proc print data=EmpsAUC;
run;

********** IN= Option **********;
data EmpsAUC;
   merge EmpsAU(in=Emps) 
         PhoneC(in=Cell);
   by EmpID;
run;

proc print data=EmpsAUC;
run;

********** Matches Only **********;
data EmpsAUC;
   merge EmpsAU(in=Emps) 
         PhoneC(in=Cell);
   by EmpID;
   if Emps=1 and Cell=1;
run;

proc print data=EmpsAUC;
run;

********** Non-Matches from EmpsAU Only **********;
data EmpsAUC;
   merge EmpsAU(in=Emps) 
         PhoneC(in=Cell);
   by EmpID;
   if Emps=1 and Cell=0;
run;

proc print data=EmpsAUC;
run;

********** Non-Matches from PhoneC Only **********;
data EmpsAUC;
   merge EmpsAU(in=Emps) 
         PhoneC(in=Cell);
   by EmpID;
   if Emps=0 and Cell=1;
run;

proc print data=EmpsAUC;
run;

********** All Non-Matches **********;
data EmpsAUC;
   merge EmpsAU(in=Emps) 
         PhoneC(in=Cell);
   by EmpID;
   if Emps=0 or Cell=0;
run;

proc print data=EmpsAUC;
run;

********** Outputting to Multiple Data Sets (Self-Study) **********;
data EmpsAUC EmpsOnly PhoneOnly;
   merge EmpsAU(in=Emps) PhoneC(in=Cell);
   by EmpID;
   if Emps=1 and Cell=1 then output EmpsAUC;
   else if Emps=1 and Cell=0 then output EmpsOnly;
   else if Emps=0 and Cell=1 then output PhoneOnly;
run;

proc print data=EmpsAUC;
run;

proc print data=EmpsOnly;
run;

proc print data=PhoneOnly;
run;


*p110d08;
********** Create Data **********;
data EmpsAUUS;
   input First $ Gender $ Country $;
   datalines;
Togar	M	AU
Kylie	F	AU
Stacey	F	US
Gloria	F	US
James	M	US
;
run;

data PhoneO;
   input Country $ Phone $15.;
   datalines;
AU +61(2)5555-1500
AU +61(2)5555-1600
AU +61(2)5555-1700
US +1(305)555-1500
US +1(305)555-1600
;
run;

********** Many-to-Many (Self-Study) **********;
data EmpsOfc;
   merge EmpsAUUS PhoneO;
   by Country;
run;

proc print data=EmpsOfc;
run;

proc sql;
   create table EmpsOfc as
   select First, Gender, PhoneO.Country, Phone
   from EmpsAUUS, PhoneO
   where EmpsAUUS.Country=PhoneO.Country;
quit;

proc print data=EmpsOfc;
run;


*p110e01;
proc contents data=orion.price_current;
run;

proc contents data=orion.price_new;
run;              

*p110e05;
proc contents data=orion.sales;
run;

proc contents data=orion.nonsales;
run;

*p110e06;
proc sort data=orion.shoes_eclipse
          out=work.eclipsesort;
   by Product_Name;
run;


*p110e07;
proc contents data=orion.orders;
run;

proc contents data=orion.order_item;
run;

proc print data=work.allorders;
   var Order_ID Order_Item_Num Order_Type 
       Order_Date Quantity Total_Retail_Price;
run;


*p110e10

proc sort data=orion.product_list
          out=work.product;
   by Supplier_ID;
run;

proc print data=work.prodsup;
   var Product_ID Product_Name Supplier_ID Supplier_Name;
run;

*p110s01;
proc contents data=orion.price_current;
run;

proc contents data=orion.price_new;
run;              

proc append base=orion.price_current
            data=orion.price_new;
run;

*p110s02;
proc contents data=orion.qtr1_2007;
run;

proc contents data=orion.qtr2_2007;
run;

proc append base=work.ytd 
            data=orion.qtr1_2007;
run;

proc append base=work.ytd 
            data=orion.qtr2_2007 force;
run;


*p110s03;
proc contents data=orion.shoes_eclipse;
run;

proc contents data=orion.shoes_tracker;
run;

proc contents data=orion.shoes;
run;

proc datasets library=orion nolist;
   append base=shoes data=shoes_eclipse;
   append base=shoes data=shoes_tracker force;
quit;


*p110s04;
data work.thirdqtr;
   set orion.mnth7_2007 orion.mnth8_2007 orion.mnth9_2007;
run;

proc print data=work.thirdqtr;
run; 


*p110s05;
proc contents data=orion.sales;
run;

proc contents data=orion.nonsales;
run;

data work.allemployees;
   set orion.sales 
       orion.nonsales(rename=(First=First_Name Last=Last_Name));
   keep Employee_ID First_Name Last_Name Job_Title Salary;
run;

proc print data=work.allemployees;
run;


*p110s06;
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

proc print data=work.e_t_shoes;
run;


*p110s07;
proc contents data=orion.orders;
run;

proc contents data=orion.order_item;
run;

data work.allorders;
   merge orion.orders 
         orion.order_item;
   by Order_ID;
run;

proc print data=work.allorders;
   var Order_ID Order_Item_Num Order_Type 
       Order_Date Quantity Total_Retail_Price;
run;


*p110s08;
proc sort data=orion.product_list 
          out=work.product_list;
   by Product_Level;
run;

data work.listlevel;
   merge orion.product_level work.product_list ;
   by Product_Level;
run;

proc print data=work.listlevel;
   var Product_ID Product_Name Product_Level Product_Level_Name;
run;

*p110s09;
proc sql;
   create table work.listlevelsql as
   select Product_ID, Product_Name, 
          product_level.Product_Level, Product_Level_Name
   from orion.product_level, orion.product_list
   where product_level.Product_Level = product_list.Product_Level;
quit;

proc print data=work.listlevelsql;
run;


*p110s10;
proc sort data=orion.product_list
          out=work.product;
   by Supplier_ID;
run;

data work.prodsup;
   merge work.product(in=P) 
         orion.supplier(in=S);
   by Supplier_ID;
   if P=1 and S=0;
run;

proc print data=work.prodsup;
   var Product_ID Product_Name Supplier_ID Supplier_Name;
run;


*p110s11;
proc sort data=orion.customer
          out=work.customer;
   by Country;
run;

data work.allcustomer;
   merge work.customer(in=Cust) 
         orion.lookup_country(rename=(Start=Country 
                                      Label=Country_Name) 
                              in=Ctry);
   by Country;
   keep Customer_ID Country Customer_Name Country_Name;
   if Cust=1 and Ctry=1;
run;

proc print data=work.allcustomer;
run;


*p110s12;
proc sort data=orion.orders
          out=work.orders;
   by Employee_ID;
run;

data work.allorders work.noorders;
   merge orion.staff(in=Staff) work.orders(in=Ord);
   by Employee_ID;
   if Ord=1 then output work.allorders;
   else if Staff=1 and Ord=0 then output work.noorders;
   keep Employee_ID Job_Title Gender Order_ID Order_Type Order_Date;
run;

proc print data=work.allorders;
run;

proc print data=work.noorders;
run;


*p111a01;
/*********************************************************
*  1. Submit the program.                                *
*  2. Review the results including the date, time, and   *
*     page number in the top right hand corner of each   * 
*     page of output.                                    *
*  3. Add the DTRESET system option to the OPTIONS       *
*     statement.                                         *
*  4. Submit the program and review the results.         *
*  5. Did your date and time change?                     * 
*********************************************************/

options date number pageno=1 ls=100;

proc print data=orion.mnth7_2007;
run;

proc print data=orion.mnth8_2007;
run;

proc print data=orion.mnth9_2007;
run;


*p111a01s;
/*********************************************************
*  1. Submit the program.                                *
*  2. Review the results including the date, time, and   *
*     page number in the top right hand corner of each   * 
*     page of output.                                    *
*  3. Add the DTRESET system option to the OPTIONS       *
*     statement.                                         *
*  4. Submit the program and review the results.         *
*  5. Did your date and time change?                     * 
*********************************************************/

options date number pageno=1 ls=100 dtreset;

proc print data=orion.mnth7_2007;
run;

proc print data=orion.mnth8_2007;
run;

proc print data=orion.mnth9_2007;
run;

*p111a02;
/*********************************************************
*  1. Submit the program.                                *
*  2. View the log to determine how SAS handles          *
*     multiple WHERE statements.                         * 
*  3. Which statement is true concerning the multiple    *
*     WHERE statements?                                  *
*     a. All the WHERE statements are used.              *
*     b. None of the WHERE statements are used.          *
*     c. The first WHERE statement is used.              *
*     d. The last WHERE statement is used.               *
*********************************************************/

proc freq data=orion.sales;
   tables Gender; 
   where Salary > 75000; 
   where Country = 'US';
run;


*p111a03;
/*********************************************************
*  1. Add a STYLE= option to the first ODS statement     *
*     selecting one of the following style definitions:  *
*     HighContrast, Minimal, Listing, or Journal3.       * 
*  2. Submit the program and review the results.         *
*  3. Modify the STYLE= option to use one of the         *
*     following style definitions:                       *
*     Education, Harvest, Rsvp, or Solutions.            *
*  4. Submit the program and review the results.         *
*  5. Do you notice a difference in the results?         *
*********************************************************/

ods html file='myreport.html';

proc means data=orion.sales;
   var Salary;
   title 'Report One';
run;

proc print data=orion.sales;
   title 'Report Two';
run;

ods html close;

title;


*p111a03s;

/*********************************************************
*  1. Add a STYLE= option to the first ODS statement     *
*     selecting one of the following style definitions:  *
*     HighContrast, Minimal, Listing, or Journal3.       * 
*  2. Submit the program and review the results.         *
*  3. Modify the STYLE= option to use one of the         *
*     following style definitions:                       *
*     Education, Harvest, Rsvp, or Solutions.            *
*  4. Submit the program and review the results.         *
*  5. Do you notice a difference in the results?         *
*********************************************************/

ods html file='myreport.html' style=Minimal;

proc means data=orion.sales;
   var Salary;
   title 'Report One';
run;

proc print data=orion.sales;
   title 'Report Two';
run;

ods html close;

title;



*p111d01;
********** Basic Report **********;
proc print data=orion.sales label;
   var Employee_ID First_Name Last_Name Salary;
run;

********** Enhanced Report **********;
options nocenter;
ods html file='enhanced.html' style=sasweb;
proc print data=orion.sales label;
   var Employee_ID First_Name Last_Name Salary;
   title1 'Orion Sales Employees';
   title2 'Males Only';
   footnote 'Confidential';
   label Employee_ID='Sales ID' First_Name='First Name'
         Last_Name='Last Name' Salary='Annual Salary';
   format Salary dollar8.;
   where Gender='M';   
   by Country;
run;
ods html close;

********** Reset Global Statements **********;
options center;
title;
footnote;

*p111d02;
options ls=80 date number;

proc means data=orion.sales;
   var Salary;
run;

options nodate pageno=1;

proc freq data=orion.sales;
   tables Country;
run;

options ls=95;



*p111d03;
footnote1 'By Human Resource Department';
footnote3 'Confidential';
options ps=20;
proc means data=orion.sales;
   var Salary; 
   title 'Orion Star Sales Employees';
run;

********** Changing and Canceling Titles **********;
proc print data=orion.sales;
   title1 'The First Line';
   title2 'The Second Line';
run;
proc print data=orion.sales;
   title2 'The Next Line';
run;
proc print data=orion.sales;
   title 'The Top Line';
run;
proc print data=orion.sales;
   title3 'The Third Line';
run;
proc print data=orion.sales;
   title;
run;

********** Changing and Canceling Footnotes **********;
footnote1 'Orion Star';
proc print data=orion.sales;
   footnote2 'Sales Employees';
   footnote3 'Confidential';
run;
proc print data=orion.nonsales;
   footnote2 'Non Sales Employees';
run;

title;
footnote;


*p111d04;
********** &SYSDATE and &SYSTIME **********;
proc freq data=orion.sales;
   tables Gender Country;
   title1 'Orion Star Sales Employee Listing';
   title2 "Created on &sysdate9 at &systime";
run;

********** %LET with %SYSFUNC **********;
%let currentdate=%sysfunc(today(),worddate.);
%let currenttime=%sysfunc(time(),timeampm.);

proc freq data=orion.sales;
   tables Gender Country;
   title1 'Orion Star Employee Listing';
   title2 "Created &currentdate";
   title3 "at &currenttime";
run;

title;


*p111d05;
********** LABEL Statement with PROC FREQ **********;
proc freq data=orion.sales;
   tables Gender Country;
   label Gender='Sales Employee Gender';
run;

********** LABEL Statement with PROC PRINT **********;
proc print data=orion.sales;
   var Employee_ID Job_Title Salary;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary';
run;

********** LABEL Option with PROC PRINT **********;
proc print data=orion.sales label;
   var Employee_ID Job_Title Salary;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary';
run;

********** SPLIT= Option with PROC PRINT **********;
proc print data=orion.sales split='*';
   var Employee_ID Job_Title Salary;
   label Employee_ID='Sales ID'
         Job_Title='Job*Title'
         Salary='Annual*Salary';
run;

********** Permanent Labels **********;
data orion.bonus;
   set orion.sales;
   Bonus=Salary*0.10;
   label Salary='Annual*Salary'
         Bonus='Annual*Bonus';
   keep Employee_ID First_Name 
        Last_Name Salary Bonus;
run;

proc print data=orion.bonus split='*';
run;

********** Temporary versus Permanent Labels **********;
data orion.bonus;
   set orion.sales;
   Bonus=Salary*0.10;
   label Bonus='Annual Bonus';
run;

proc print data=orion.bonus label;
   label Bonus='Mid-Year Bonus';
run;


*p111d06;
********** FORMAT Statement with PROC PRINT **********;
proc print data=orion.sales label;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Salary dollar10.0
          Birth_Date Hire_Date monyy7.;
run;

********** FORMAT Statement with PROC FREQ **********;
proc freq data=orion.sales;
   tables Hire_Date;
   format Hire_Date year4.;
run;

********** Permanent and Temporary Formats **********;
data orion.bonus;
   set orion.sales;
   Bonus=Salary*0.10;
   format Salary Bonus comma8.;
   keep Employee_ID First_Name 
        Last_Name Salary Bonus;
run;

proc print data=orion.bonus;
   format Bonus dollar8.;
run;



*p111d07;
********** Character User-defined Format **********;
proc format;
   value $ctryfmt  'AU' = 'Australia'
                   'US' = 'United States' 
                  other = 'Miscoded';
run;

proc print data=orion.sales label;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Salary dollar10.0 
          Birth_Date Hire_Date monyy7.
          Country $ctryfmt.;
run;

********** Numeric User-defined Format **********;
proc format;
   value tiers  20000-49999  = 'Tier 1'                  
                50000-99999  = 'Tier 2'
               100000-250000 = 'Tier 3';
run;

proc print data=orion.sales label;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Salary tiers.;
run;

********** Numeric User-defined Format with < **********;
proc format;
   value tiers  20000-<50000  = 'Tier 1'                  
                50000- 100000 = 'Tier 2'
               100000<-250000 = 'Tier 3';
run;

proc print data=orion.sales label;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Salary tiers.;
run;

********** Numeric User-defined Format with LOW and HIGH **********;
proc format;
   value tiers    low-<50000  = 'Tier 1'                  
                50000- 100000 = 'Tier 2'
               100000<-high   = 'Tier 3';
run;

proc print data=orion.sales label;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Salary tiers.;
run;

********** Multiple User-defined Formats **********;
proc format;
   value $ctryfmt  'AU' = 'Australia'
                   'US' = 'United States' 
                  other = 'Miscoded';
   value tiers    low-<50000  = 'Tier 1'                  
                50000- 100000 = 'Tier 2'
               100000<-high   = 'Tier 3';
run;

proc print data=orion.sales label;
   var Employee_ID Job_Title Salary 
       Country Birth_Date Hire_Date;
   label Employee_ID='Sales ID'
         Job_Title='Job Title'
         Salary='Annual Salary'
         Birth_Date='Date of Birth'
         Hire_Date='Date of Hire';
   format Birth_Date Hire_Date monyy7.
          Country $ctryfmt. 
          Salary tiers.;
run;

proc freq data=orion.sales;
   tables Country Salary;
   format Country $ctryfmt. Salary tiers.;
run;



*p111d08;
********** WHERE Statement with PROC PRINT **********;
proc print data=orion.sales;
   var First_Name Last_Name 
       Job_Title Country Salary;
   where Salary > 75000;
run;

********** WHERE Statement with PROC MEANS **********;
proc means data=orion.sales;
   var Salary;
   where Country = 'AU';
run;



*p111d09;
proc sort data=orion.sales out=work.sort;
   by Country descending Gender Last_Name;
run;

********** BY Statement with PROC PRINT **********;
proc print data=work.sort;
   var Employee_ID First_Name Last_Name Salary;
   by Country descending Gender;
run;

********** BY Statement with PROC MEANS **********;
proc means data=work.sort;
   var Salary;
   by Country descending Gender;
run;

********** BY Statement with PROC FREQ **********;
proc freq data=work.sort;
   tables Gender;
   by Country;
run;




*p111d10;
********** ODS LISTING **********;
ods listing;

proc freq data=orion.sales;
   tables Country;
run;

proc gchart data=orion.sales;
   hbar Country / nostats;
run;
quit;

********** ODS LISTING CLOSE **********;
ods listing close;

proc freq data=orion.sales;
   tables Country;
run;

proc gchart data=orion.sales;
   hbar Country / nostats;
run;
quit;

ods listing;


*p111d11;
********** ODS HTML **********;
ods html file='myreport.html';
proc freq data=orion.sales;
   tables Country;
run;
ods html close;

********** ODS PDF **********;
ods pdf file='myreport.pdf';
proc freq data=orion.sales;
   tables Country;
run;
ods pdf close;

********** ODS RTF **********;
ods rtf file='myreport.rtf';
proc freq data=orion.sales;
   tables Country;
run;
ods rtf close;

********** Single Destination **********;
ods listing close;

ods html file='example.html';

proc freq data=orion.sales;
   tables Country;
run;

ods html close;

ods listing;

********** Multiple Destinations **********;
ods listing;
ods pdf file='example.pdf';
ods rtf file='example.rtf';

proc freq data=orion.sales;
   tables Country;
run;

ods pdf close;
ods rtf close;

********** Multiple Destinations with _ALL_ **********;
ods listing;
ods pdf file='example.pdf';
ods rtf file='example.rtf';

proc freq data=orion.sales;
   tables Country;
run;

ods _all_ close;
ods listing;

********** Multiple Procedures **********;
ods listing;
ods pdf file='example.pdf';
ods rtf file='example.rtf';

proc freq data=orion.sales;
   tables Country;
run;

proc means data=orion.sales;
   var Salary;
run;

ods _all_ close;
ods listing;

********** File Location **********;
ods html file='s:\workshop\example.html';

proc freq data=orion.sales;
   tables Country;
run;

proc means data=orion.sales;
   var Salary;
run;

ods html close;

********** z/OS (OS/390) Example **********;
ods html file='.workshop.report(example)' rs=none;

proc freq data=orion.sales;
   tables Country;
run;

ods html close;




*p111d12;
ods listing close;
ods html file='myreport.html';
ods pdf file='myreport.pdf';
ods rtf file='myreport.rtf';

proc freq data=orion.sales;
   tables Country;
   title 'Report 1';
run;

proc means data=orion.sales;
   var Salary;
   title 'Report 2';
run;

proc print data=orion.sales;
   var First_Name Last_Name 
       Job_Title Country Salary;
   where Salary > 75000;
   title 'Report 3';
run;

ods _all_ close;
ods listing;

title;

*p111d13;
********** Style= with HTML **********;
ods html file='myreport.html' style=default; /*Default*/
proc freq data=orion.sales;
   tables Country;
run;
ods html close;

ods html file='myreport.html' style=sasweb;
proc freq data=orion.sales;
   tables Country;
run;
ods html close;

********** Style= with PDF **********;
ods pdf file='myreport.pdf' style=printer; /*Default*/
proc freq data=orion.sales;
   tables Country;
run;
ods pdf close;

ods pdf file='myreport.pdf' style=journal;
proc freq data=orion.sales;
   tables Country;
run;
ods pdf close;

********** Style= with RTF **********;
ods rtf file='myreport.rtf' style=rtf; /*Default*/
proc freq data=orion.sales;
   tables Country;
run;
ods rtf close;

ods rtf file='myreport.rtf' style=ocean;
proc freq data=orion.sales;
   tables Country;
run;
ods rtf close;


*p111d14;
********** ODS CSVALL **********;
ods csvall file='myexcel.csv';

proc freq data=orion.sales;
   tables Country;
run;

proc means data=orion.sales;
   var Salary;
run;

ods csvall close;

********** ODS MSOFFICE2K **********;
ods msoffice2k file='myexcel.html';

proc freq data=orion.sales;
   tables Country;
run;

proc means data=orion.sales;
   var Salary;
run;

ods msoffice2k close;

********** ODS EXCELXP **********;
ods tagsets.excelxp file='myexcel.xml';

proc freq data=orion.sales;
   tables Country;
run;

proc means data=orion.sales;
   var Salary;
run;

ods tagsets.excelxp close;

*p111d15;
ods listing close;
ods csvall file='myexcel.csv';
ods msoffice2k file='myexcel.html';
ods tagsets.excelxp file='myexcel.xml';

proc freq data=orion.sales;
   tables Country;
   title 'Report 1';
run;

proc means data=orion.sales;
   var Salary;
   title 'Report 2';
run;

proc print data=orion.sales;
   var First_Name Last_Name 
       Job_Title Country Salary;
   where Salary > 75000;
   title 'Report 3';
run;

ods _all_ close;
ods listing;

title;



*p111d16;
********** Documentation Option **********;
ods listing close;
ods tagsets.excelxp file='myexcel1.xml'
                    style=sasweb
                    options(doc='help');

proc freq data=orion.sales;
   tables Country;
   title 'Report 1';
run;

proc means data=orion.sales;
   var Salary;
   title 'Report 2';
run;

ods tagsets.excelxp close;
ods listing;

title;

********** Other Options **********;
ods listing close;
ods tagsets.excelxp file='myexcel2.xml'
                    style=sasweb
                    options(embedded_titles='yes'
                            sheet_Name='First Report');

proc freq data=orion.sales;
   tables Country;
   title 'Report 1';
run;

ods tagsets.excelxp options(sheet_Name='Second Report');
proc means data=orion.sales;
   var Salary;
   title 'Report 2';
run;

ods tagsets.excelxp close;
ods listing;

title;


*p111e01;
proc means data=orion.order_fact;
   var Total_Retail_Price;
run;

*p111e02;
proc means data=orion.order_fact;
   where Order_Type=2;
   var Total_Retail_Price;
run;

proc means data=orion.order_fact;
   where Order_Type=3;
   var Total_Retail_Price;
run;


*p111e03;
proc means data=orion.order_fact;
   var Total_Retail_Price;
run;


*p111e04;
proc print data=orion.employee_payroll;
   where Dependents=3;
   title 'Employees with 3 Dependents';
   var Employee_ID Salary
       Birth_Date Employee_Hire_Date Employee_Term_Date;
run;



*p111e05;
proc print data=orion.customer;
   where Country='TR';
   title 'Customers from Turkey';
   var Customer_ID Customer_FirstName Customer_LastName
       Birth_Date;
run;



*p111e06;
data otherstatus;
   set orion.employee_payroll;
   keep Employee_ID Employee_Hire_Date;
   if Marital_Status='O';
run;

title 'Employees who are listed with Marital Status=O';
proc print data=otherstatus label;
run;

proc contents data=otherstatus;
run;

proc freq data=otherstatus;
   tables Employee_Hire_Date;
run;


*p111e07;
data Q1Birthdays;
   set orion.employee_payroll;
   BirthMonth=month(Birth_Date);
   if BirthMonth le 3;
run;

proc freq data=Q1Birthdays;
   tables BirthMonth Employee_Gender;
   title 'Employees with Birthdays in Q1';
run;



*p111e08;
proc print data=orion.nonsales;
   var Employee_ID Job_Title Salary Gender;
   title1 'Distribution of Salary and Gender Values';
   title2 'for Non-Sales Employees';
run;



*p111e09;
proc freq data=orion.employee_payroll;
   tables Employee_Term_Date;
   title 'Employee Status Report';
run;



*p111e10;
proc means data=orion.order_fact;
   var Total_Retail_Price;
   title 'Orion Star Sales Summary';
run;



*p111e11;
proc print data=orion.order_fact;
   var Order_Type Order_ID Order_Date Delivery_Date ;
   title1 'Orion Star Sales Details';
run;


*p111e12;
proc format;
   value $country
      "CA"="Canada"
      "DK"="Denmark"
      "ES"="Spain"
      "GB"="Great Britain"
      "NL"="Netherlands"
      "SE"="Sweden"
      "US"="United States";
run;

proc sort data=orion.shoe_vendors out=vendors_by_country;
   by Supplier_Country Supplier_Name;
run;

proc print data=vendors_by_country;
   where Product_Line=21;
   by Supplier_Country Supplier_Name Supplier_ID;
   var Product_ID Product_Name;
   title1 'Orion Star Products: Children Sports';
run;


*p111e13;
proc print data=orion.customer;
   title 'Customer Information';
run;


*p111e14;
proc print data=orion.customer_type;
   title 'Customer Type Definitions';
run;

proc print data=orion.country;
   title 'Country Definitions';
run;


*p111e15;
proc print data=orion.customer;
   title 'Customer Information';
run;


*p111e16;

ods html file='p111s16.html';
proc print data=orion.customer_type;
   title 'Customer Type Definitions';
run;
ods html close;




*p111s01;
options nonumber nodate pagesize=18;
title 'Orion Star Sales Report';
footnote 'Report by SAS Programming Student';
proc means data=orion.order_fact;
   var Total_Retail_Price;
run;
options pagesize=52;
footnote;

*p111s02;
options pagesize=18 number pageno=1 date dtreset;
title1 'Orion Star Sales Analysis';
proc means data=orion.order_fact;
   where Order_Type=2;
   var Total_Retail_Price;
   title3 'Catalog Sales Only';
   footnote "Based on the previous day's posted data";
run;

options pageno=1;
proc means data=orion.order_fact;
   where Order_Type=3;
   var Total_Retail_Price;
   title3 'Internet Sales Only';
   footnote;
run;
options pagesize=52;


*p111s03;
proc options option=date;
run;
options nodate;
%let currentdate=%sysfunc(today(),weekdate.);
%let currenttime=%sysfunc(time(),timeampm8.);
proc means data=orion.order_fact;
   title "Sales Report as of &currenttime on &currentdate";
   var Total_Retail_Price;
run;



*p111s04;
proc print data=orion.employee_payroll label;
   where Dependents=3;
   title 'Employees with 3 Dependents';
   var Employee_ID Salary
       Birth_Date Employee_Hire_Date Employee_Term_Date;
   label Employee_ID='Employee Number'
         Salary='Annual Salary'
         Birth_Date='Birth Date'
         Employee_Hire_Date='Hire Date'
         Employee_Term_Date='Termination Date';
   format Birth_Date Employee_Hire_Date Employee_Term_Date date11.
          Salary dollar11.2;
run;



*p111s05;
proc print data=orion.customer split='/';
   where Country='TR';
   title 'Customers from Turkey';
   var Customer_ID Customer_FirstName Customer_LastName
       Birth_Date;
   label Customer_ID='Customer ID'
         Customer_FirstName='First Initial'
         Customer_LastName='Last/Name'
         Birth_Date='Birth Year';
   format Birth_Date year4.
          Customer_FirstName $1.
          Customer_ID z6.;
run;



*p111s06;
data otherstatus;
   set orion.employee_payroll;
   keep Employee_ID Employee_Hire_Date;
   if Marital_Status='O';
   label Employee_ID='Employee Number'
         Employee_Hire_Date='Hired';
   format Employee_Hire_Date yymmddp10.;
run;

title 'Employees who are listed with Marital Status=O';
proc print data=otherstatus label;
run;

proc contents data=otherstatus;
run;

proc freq data=otherstatus;
   tables Employee_Hire_Date;
   label Employee_Hire_Date='Quarter Hired';
   format Employee_Hire_Date yyq6.;
run;


*p111s07;
data Q1Birthdays;
   set orion.employee_payroll;
   BirthMonth=month(Birth_Date);
   if BirthMonth le 3;
run;

proc format;
   value $gender
      'F'='Female'
      'M'='Male';
   value moname
       1='January'
       2='February'
       3='March';
run;

proc freq data=Q1Birthdays;
   tables BirthMonth Employee_Gender;
   format Employee_Gender $gender.
          BirthMonth moname.;
   title 'Employees with Birthdays in Q1';
run;


*p111s08;
proc format;
   value $gender
        'F'='Female'
        'M'='Male'
      other='Invalid code';
   value salrange
                  .='Missing salary'
      20000-<100000='Below $100,000'
      100000-500000='$100,000 or more'
              other='Invalid salary';
run;

proc print data=orion.nonsales;
   var Employee_ID Job_Title Salary Gender;
   format Salary salrange. Gender $gender.;
   title1 'Distribution of Salary and Gender Values';
   title2 'for Non-Sales Employees';
run;

*p111s09;
proc format;
   value dategrp
                      .='None'
       low-'31dec2006'd=[year4.]
      '01jan2007'd-high=[monyy7.]
   ;
run;

proc freq data=orion.employee_payroll;
   tables Employee_Term_Date / missing;
   format Employee_Term_Date dategrp.;
   title 'Employee Status Report';
run;


*p111s10;
proc sort data=orion.order_fact out=order_sorted;
   by order_type;
run;

proc means data=order_sorted;
   by order_type;
   where order_type in (2,3);
   var Total_Retail_Price;
   title 'Orion Star Sales Summary';
run;



*p111s11;
proc sort data=orion.order_fact out=order_sorted;
   by Order_Type descending Order_Date;
run;

proc print data=order_sorted;
   by Order_Type;
   var Order_ID Order_Date Delivery_Date;
   where Delivery_Date - Order_Date = 2
     and Order_Date between '01jan2005'd and '30apr2005'd;
   title1 'Orion Star Sales Details';
   title2 '2-Day Deliveries from January to April 2005';
run;



*p111s12;
proc format;
   value $country
      "CA"="Canada"
      "DK"="Denmark"
      "ES"="Spain"
      "GB"="Great Britain"
      "NL"="Netherlands"
      "SE"="Sweden"
      "US"="United States";
run;

proc sort data=orion.shoe_vendors out=vendors_by_country;
   by Supplier_Country Supplier_Name;
run;

proc print data=vendors_by_country;
   where Product_Line=21;
   where same
     and Product_Name ? 'Street' or Product_Name ? 'Running';
   by Supplier_Name Supplier_ID Supplier_Country notsorted;
   var Product_ID Product_Name;
   title1 'Orion Star Products: Children Sports';
run;



*p111s13;
ods listing close;
ods pdf file='p111s13p.pdf';
ods rtf file='p111s13r.rtf' style=curve;
proc print data=orion.customer;
   title 'Customer Information';
run;
ods pdf close;
ods rtf close;
ods listing;



*p111s14;
ods csvall file='p111s14.csv';
proc print data=orion.customer_type;
   title 'Customer Type Definitions';
run;

proc print data=orion.country;
   title 'Country Definitions';
run;
ods csvall close;

ods msoffice2k file='p111s14.html' style=Listing;
proc print data=orion.customer_type;
   title 'Customer Type Definitions';
run;

proc print data=orion.country;
   title 'Country Definitions';
run;
ods msoffice2k close;

ods tagsets.excelxp file='p111s14.xml' style=Listing;
proc print data=orion.customer_type;
   title 'Customer Type Definitions';
run;

proc print data=orion.country;
   title 'Country Definitions';
run;
ods tagsets.excelxp close;


*p111s15;
ods html file='p111s15.html';
proc print data=orion.customer;
   title link='http://www.sas.com' 'Customer Information';
run;
ods html close;



*p111s16;
ods html file='p111s16.html' stylesheet=(url='p111e16c.css');
proc print data=orion.customer_type;
   title 'Customer Type Definitions';
run;
ods html close;



*p112a01;
/*********************************************************
*  1. Submit the program.                                *
*  2. Review the PROC FREQ output.                       *
*  3. Review the PROC PRINT output from the TABLES       *
*     statement OUT= option.                             *
*  4. Review the PROC PRINT output from the OUTPUT       *
*     statement OUT= option.                             *
*********************************************************/

proc freq data=orion.sales;
   tables Gender / chisq out=freq6 outcum;
   output out=freq7 chisq;
run; 

proc print data=freq6;
run;

proc print data=freq7;
run;

*p112a02;
/*********************************************************
*  1. Submit the program.                                *
*  2. Review the PROC PRINT output.                      *
*  3. Add a WHERE statement to the PROC PRINT step to    *
*     subset _TYPE_ for observations summarized by       *
*     Gender only.                                       *
*  4. Submit the program and verify the results.         *
*********************************************************/

proc means data=orion.sales noprint chartype;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
run;


*p112a02s;
/*********************************************************
*  1. Submit the program.                                *
*  2. Review the PROC PRINT output.                      *
*  3. Add a WHERE statement to the PROC PRINT step to    *
*     subset _TYPE_ for observations summarized by       *
*     Gender only.                                       *
*  4. Submit the program and verify the results.         *
*********************************************************/

proc means data=orion.sales noprint chartype;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
   where _type_= '10';
run;



*p112d01;
proc freq data=orion.sales;
run;

proc freq data=orion.sales;
   tables Gender Country;
run; 

proc freq data=orion.sales;
   tables Gender*Country;
run;

********** Additional Statements **********;
proc format;
   value $ctryfmt 'AU'='Australia'
                  'US'='United States';
run;

options nodate pageno=1;

ods html file='p112d01.html';
proc freq data=orion.sales;
   tables Gender*Country;
   where Job_Title contains 'Rep';
   format Country $ctryfmt.;
   title 'Sales Rep Frequency Report';
run;
ods html close;

********** Options to Suppress Display of Statistics **********;
proc freq data=orion.sales;
   tables Gender Country / nocum nopercent;
run; 

proc freq data=orion.sales;
   tables Gender*Country / nopercent norow nocol;
run;

********** Additional TABLES Statement Options **********;
proc freq data=orion.sales;
   tables Gender*Country / list;
   format Country $ctryfmt.;
run; 

proc freq data=orion.sales;
   tables Gender*Country / crosslist;
   format Country $ctryfmt.;
run;

proc freq data=orion.sales;
   tables Gender*Country / format=12.;
   format Country $ctryfmt.;
run;

********** PROC FREQ Statement Options **********;
options pageno=1;
proc freq data=orion.sales;
   tables Gender Country Employee_ID;
run;

options pageno=1;
proc freq data=orion.sales nlevels;
   tables Gender Country Employee_ID;
run;

options pageno=1;
proc freq data=orion.sales nlevels;
   tables Gender Country Employee_ID / noprint;
run;

options pageno=1;
proc freq data=orion.sales nlevels;
   tables _all_ / noprint;
run;

options pageno=1;
proc freq data=orion.sales page;
   tables Gender Country Employee_ID;
run;

options pageno=1;
proc freq data=orion.sales compress;
   tables Gender Country Employee_ID;
run;

*p112d02;
********** One-Way Frequency Table OUT= **********;
proc freq data=orion.sales noprint;
   tables Gender Country / out=work.freq1;
run; 

proc print data=work.freq1;
run;

********** Two-Way Frequency Table OUT= **********;
proc freq data=orion.sales noprint;
   tables Gender*Country / out=work.freq2;
run; 

proc print data=work.freq2;
run;

********** One-Way Frequency Table OUT= with OUTCUM **********;
proc freq data=orion.sales noprint;
   tables Gender Country / out=work.freq3 outcum;
run; 

proc print data=work.freq3;
run;

********** Two-Way Frequency Table OUT= with OUTPCT **********;
proc freq data=orion.sales noprint;
   tables Gender*Country / out=work.freq4 outpct;
run; 

proc print data=work.freq4;
run;



*p112d03;
********** One-Way Frequency Table OUTPUT OUT= **********;
proc freq data=orion.sales;
   tables Country / chisq;
   output out=work.freq5 chisq;
run; 

proc print data=work.freq5;
run;



*p112d04;
proc freq data=orion.sales;
   tables Gender / chisq out=genderfreq outcum;
   output out=genderchi chisq;
run; 

proc freq data=orion.sales;
   tables Country / chisq out=countryfreq outcum;
   output out=countrychi chisq;
run; 

data allfreq;
   length Value $ 7;
   set genderfreq(in=gf) countryfreq(in=cf)
       genderchi(in=gc) countrychi(in=cc);
   if gf then Value=Gender;    
   else if cf then Value=Country;
   else if gc then Value='Gender';
   else if cc then Value='Country';
   label _PCHI_='Chi-Square'
         P_PCHI='P-Value';
   keep Value COUNT PERCENT _PCHI_ P_PCHI; 
run;

proc print data=allfreq label;
run;



*p112d05;
proc means data=orion.sales;
run; 

********** VAR Statement **********;
proc means data=orion.sales;
   var Salary;
run; 

********** CLASS Statement **********;
proc means data=orion.sales;
   var Salary;
   class Gender Country;
run;

********** Additional Statements **********;
proc format;
   value $ctryfmt 'AU'='Australia'
                  'US'='United States';
run;

options nodate pageno=1;

ods html file='p112d05.html';
proc means data=orion.sales;
   var Salary;
   class Gender Country;
   where Job_Title contains 'Rep';
   format Country $ctryfmt.;
   title 'Sales Rep Summary Report';
run;
ods html close;

********** PROC MEANS Statisctics **********;
proc means data=orion.sales sum mean range;
   var Salary;
   class Country;
run;

********** PROC MEANS Statement Options **********;
proc means data=orion.sales maxdec=0;
   var Salary;
   class Country;
run;

proc means data=orion.sales maxdec=1;
   var Salary;
   class Country;
run;

proc means data=orion.sales;
   var Salary;
   class Country;
run;

proc means data=orion.sales fw=15;
   var Salary;
   class Country;
run;

proc means data=orion.sales nonobs;
   var Salary;
   class Country;
run;

proc means data=orion.sales noprint;
   var Salary;
   class Country;
   output out=work.means;
run;


*p112d06;
********** OUTPUT OUT= Statment **********;
proc means data=orion.sales sum mean range;
   var Salary;
   class Gender Country;
   output out=work.means1;
run;

proc print data=work.means1;
run;

********** OUTPUT OUT= Statement with Statistics **********;
proc means data=orion.sales noprint;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
run;

********** PROC MEANS Statement Options **********;
proc means data=orion.sales noprint nway;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
run;

proc means data=orion.sales noprint descendtypes;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
run;

proc means data=orion.sales noprint chartype;
   var Salary;
   class Gender Country;
   output out=work.means2
          min=minSalary max=maxSalary
          sum=sumSalary mean=aveSalary;
run;

proc print data=work.means2;
run;



*p112d07;
proc means data=orion.sales noprint;
   var Salary;
   class Gender Country;
   output out=work.means mean=aveSalary;
run;

data gender_summary(keep=Gender aveSalary)  
     country_summary(keep=Country aveSalary);
   set work.means;
   if _type_=1 then output country_summary;
   else if _type_=2 then output gender_summary;
run;

proc sort data=orion.sales out=sort_country;
   by Country;
run;

data detail_country;
   merge sort_country 
         country_summary(rename=(aveSalary=CountrySalary));
   by Country;
run;

proc sort data=detail_country out=sort_gender;
   by Gender;
run;

data detail_country_gender;
   merge sort_gender
	     gender_summary(rename=(aveSalary=GenderSalary));
   by Gender;
   if Salary>CountrySalary then CS='Above Average'; else CS='Below Average';
   if Salary>GenderSalary then GS='Above Average'; else GS='Below Average';
   label CS='Comparison*to Country*Salary Average'
         GS='Comparison*to Gender*Salary Average';
run;

proc sort data=detail_country_gender;
   by Employee_ID;
run;

proc print data=detail_country_gender split='*';
   var First_Name Last_Name Salary CS GS;
run;


*p112d08;
********** One-Dimensional Table **********;
proc tabulate data=orion.sales;
   class Country;
   table Country;
run;

********** Two-Dimensional Table **********;
proc tabulate data=orion.sales;
   class Gender Country;
   table Gender, Country;
run;

********** Three-Dimensional Table **********;
proc tabulate data=orion.sales;
   class Job_Title Gender Country;
   table Job_Title, Gender, Country;
run;

********** Dimension Expression **********;
proc tabulate data=orion.sales;
   class Gender Country;
   var Salary;
   table Gender all, Country*Salary;
run;

********** Statistics **********;
proc tabulate data=orion.sales;
   class Gender Country;
   var Salary;
   table Gender all, Country*Salary*(min max);
run;

********** Additional Statements **********;
proc format;
   value $ctryfmt 'AU'='Australia'
                  'US'='United States';
run;

options nodate pageno=1;

ods html file='p112d08.html';
proc tabulate data=orion.sales;
   class Gender Country;
   var Salary;
   table Gender all, Country*Salary*(min max);
   where Job_Title contains 'Rep';
   label Salary='Annual Salary';
   format Country $ctryfmt.;
   title 'Sales Rep Tabular Report';
run;
ods html close;


*p112d09;
proc tabulate data=orion.sales 
              out=work.tabulate;
   where Job_Title contains 'Rep';
   class Job_Title Gender Country;
   table Country;
   table Gender, Country;
   table Job_Title, Gender, Country;
run;

proc print data=work.tabulate;
run;



*p112e01;
proc freq data=orion.orders;
   tables Customer_ID Employee_ID;
run;

*p112e02;
proc format;
   value ordertypes
      1='Retail'
      2='Catalog'
      3='Internet';
run;

proc freq data=orion.orders;
run;


*p112e03;
proc freq data=orion.customer_dim;
   tables Customer_Country Customer_Type Customer_Age_Group;
   title1 'Customer Demographics';
   title3 '(Top two levels for each variable?)';
run;



*p112e04;
proc freq data=orion.order_fact;
    tables Product_ID;
run;



*p112e05;
proc format;
   value ordertypes
      1='Retail'
      2='Catalog'
      3='Internet';
run;

proc means data=orion.order_fact;
   title 'Revenue (in U.S. Dollars) Earned from All Orders';
run;



*p112e06;
 proc means data=orion.staff;
   title 'Number of Missing and Non-Missing Date Values';
run;


*p112e07;

data work.countries(keep=Customer_Country);
   set orion.supplier;
   Customer_Country=Country;
run;

proc means data=orion.customer_dim;
   class Customer_Country;
   var Customer_Age;
   title 'Average Age of Customers in Each Country';
run;

*p112e08;
proc means data=orion.order_fact;
   class Product_ID;
   var Total_Retail_Price;
run;



*p112e09;
proc tabulate data=orion.customer_dim;
   title 'Ages of Customers by Group and Gender';
run;



*p112e10;
proc tabulate data=orion.customer_dim;
   title 'Customers by Group and Gender';
run;



*p112e11;
proc tabulate data=orion.order_fact;
   where CostPrice_Per_Unit > 250;
   class Product_ID Order_Date;
   format Order_Date year4.;
   var Total_Retail_Price;
   table Order_Date, Total_Retail_Price*sum*Product_ID;
   title 'High Cost Products (Unit Cost > $250)';
run;


*p112e12;
proc tabulate data=orion.Organization_Dim format=dollar12.;
   class Employee_Gender Company;
   var Salary;
   table Company, (Employee_Gender all)*Salary*mean;
   title 'Average Employee Salaries';
run;


*p112s01;
proc freq data=orion.orders nlevels;
   where Order_Type=1;
   tables Customer_ID Employee_ID / noprint;
   title1 'Unique Customers and Salespersons for Retail Sales';
run;

proc freq data=orion.orders nlevels;
   where Order_Type ne 1;
   tables Customer_ID / noprint;
   title1 'Unique Customers for Catalog and Internet Sales';
run;

*p112s02;
proc format;
   value ordertypes
      1='Retail'
      2='Catalog'
      3='Internet';
run;

proc freq data=orion.orders ;
   tables Order_Date;
   tables Order_Type / nocum;
   tables Order_Date*Order_Type / nopercent norow nocol;
   format Order_Date year4. Order_Type ordertypes.;
   title 'Order Summary by Year and Type';
run;

*p112s03;
proc freq data=orion.customer_dim order=freq;
   tables Customer_Country Customer_Type Customer_Age_Group;
   title1 'Customer Demographics';
   title3 '(Top two levels for each variable?)';
run;

*p112s04;
proc freq data=orion.order_fact noprint;
   tables Product_ID / out=product_orders;
run;

data product_names;
   merge product_orders orion.product_list;
   by Product_ID;
   keep Product_ID Product_Name Count;
run;

proc sort data=product_names;
   by descending Count;
run;

proc print data=product_names(obs=10) label;
   var Count Product_ID Product_Name;
   label Product_ID='Product Number'
         Product_Name='Product'
         Count='Orders';
   title 'Top Ten Products by Number of Orders';
run;


*p112s05;

proc format;
   value ordertypes
      1='Retail'
      2='Catalog'
      3='Internet';
run;

proc means data=orion.order_fact sum;
   var Total_Retail_Price;
   class Order_Date Order_Type;
   format Order_Date year4. Order_Type ordertypes.;
   title 'Revenue (in U.S. Dollars) Earned from All Orders';
run;

*p112s06;
proc means data=orion.staff nmiss n maxdec=0 nonobs;
   var Birth_Date Emp_Hire_Date Emp_Term_Date;
   class Gender;
   title 'Number of Missing and Non-Missing Date Values';
run;



*p112s07;

data work.countries(keep=Customer_Country);
   set orion.supplier;
   Customer_Country=Country;
run;

proc means data=orion.customer_dim
           classdata=work.countries
           lclm mean uclm alpha=0.10;
   class Customer_Country;
   var Customer_Age;
   title 'Average Age of Customers in Each Country';
run;


*p112s08;

proc means data=orion.order_fact noprint nway;
   class Product_ID;
   var Total_Retail_Price;
   output out=product_orders sum=Product_Revenue;
run;

data product_names;
   merge product_orders orion.product_list;
   by Product_ID;
   keep Product_ID Product_Name Product_Revenue;
run;

proc sort data=product_names;
   by descending Product_Revenue;
run;

proc print data=product_names(obs=10) label;
   var Product_Revenue Product_ID Product_Name;
   label Product_ID='Product Number'
         Product_Name='Product'
         Product_Revenue='Revenue';
   format Product_Revenue eurox12.2;
   title 'Top Ten Products by Revenue';
run;

*p112s09;
proc tabulate data=orion.customer_dim;
   class Customer_Group Customer_Gender;
   var Customer_Age;
   table Customer_Group all,
         Customer_Gender*Customer_Age*(n mean);
   title 'Ages of Customers by Group and Gender';
run;


*p112s10;
proc tabulate data=orion.customer_dim;
   class Customer_Gender Customer_Group;
   table Customer_Gender, Customer_Group, (n colpctn);
   keylabel colpctn='Percentage' N='Number';
   title 'Customers by Group and Gender';
run;


*p112s11;
proc tabulate data=orion.order_fact format=dollar12.;
   where CostPrice_Per_Unit > 250;
   class Product_ID Order_Date;
   format Order_Date year4.;
   var Total_Retail_Price;
   table Order_Date=' ', Total_Retail_Price*sum*Product_ID=' '
         / misstext='$0'
           box='High Cost Products (Unit Cost > $250)';
   label Total_Retail_Price='Revenue for Each Product';
   keylabel Sum=' ';
   title;
run;


*p112s12;

proc tabulate data=orion.Organization_Dim format=dollar12.
              out=work.Salaries;
   class Employee_Gender Company;
   var Salary;
   table Company, (Employee_Gender all)*Salary*mean;
   title 'Average Employee Salaries';
run;

proc sort data=work.Salaries;
   by Salary_Mean;
run;

proc print data=work.Salaries label;
   var Company Employee_Gender Salary_Mean;
   format Salary_Mean dollar12.;
   label Salary_Mean='Average Salary';
   title 'Average Employee Salaries';
run;


*p113d01;
 /* Vertical Bar Chart Representing a Frequency Count  */

goptions reset=all;
proc gchart data=orion.staff;
   vbar Job_Title;
   where Job_Title =:'Sales Rep';
   title 'Number of Employees by Job Title';
run;
quit;

 
  /* Three-dimensional Horizontal Bar Chart  */
  
goptions reset=all;
proc gchart data=orion.staff;
   hbar3d Job_Title;
   title 'Number of Employees by Job Title';
   where Job_Title =:'Sales Rep';
run;
quit;


 /* Suppress the Display of Statistics on Horizontal Bar Charts  */
 
goptions reset=all;
proc gchart data=orion.staff;
   hbar3d Job_Title / nostats;
   title 'Number of Employees by Job Title';
   where Job_Title =:'Sales Rep';
run;
quit;

            
 /* Using a Numeric Chart Variable  */ 

goptions reset=all;
proc gchart data=orion.staff;
   vbar3d salary / autoref;
   where Job_Title =:'Sales Rep';
   format salary dollar9.;
   title 'Salary Distribution Midpoints for Sales Reps';
run;
quit;

 
 /* Specifying Ranges for a Numeric Chart Variable 
    and Adding Reference Lines  */
 
goptions reset=all;
proc gchart data=orion.staff;
   hbar3d salary/levels=5 range autoref;
   where Job_Title =:'Sales Rep';
   format salary dollar9.;
   title 'Salary Distribution Ranges for Sales Reps';
run;
quit;


 /* Creating Bar Charts Based on Statistics  */
 
goptions reset=all;
proc gchart data=orion.staff;
   vbar Job_Title / sumvar=salary type=mean;
   where Job_Title =:'Sales Rep';
   format salary dollar9.;
   label Job_Title='Job Title'
         Salary='Salary';
   title 'Average Salary by Job Title';
run;
quit;

   
 /* Assigning a Different Color to Each Bar */

goptions reset=all;
proc gchart data=orion.staff;
   vbar Job_Title / sumvar=salary type=mean patternid=midpoint mean;
   where Job_Title =:'Sales Rep';
   format salary dollar9.;
   title 'Average Salary by Job Title';
run;
quit; 

    
 /* Dividing Bars into Subgroups  */

goptions reset=all;
proc gchart data=orion.staff;
   vbar Job_Title/subgroup=Gender;
   where Job_Title =:'Sales Rep';
   title 'Frequency of Job Title, Broken Down by Gender';
run;
quit;

     
 /*  Grouping Bars */
 
goptions reset=all;
proc gchart data=orion.staff;
   vbar gender/group=Job_Title patternid=midpoint;
   where Job_Title =:'Sales Rep';
   title 'Frequency of Job Gender, Grouped by Job Title';
run;
quit;

 
 /* Creating Multiple Pie Charts Using RUN-Group Processing  */
 
goptions reset=all;
proc gchart data=orion.staff;
   pie Job_Title;
   where Job_Title =:'Sales Rep';
   title 'Frequency Distribution of Job Titles';
   title2 '2-D Pie Chart';
run;
   pie3d Job_Title / noheading;
   title2 '3-D Pie Chart';
run;
quit;


*p113d02;
 /* Creating a Simple Scatter Plot  */
  
goptions reset=all;
proc gplot data=orion.budget;
   plot Yr2007*Month;
   format Yr2007 dollar12.;
   title 'Plot of Budget by Month';
run;
quit;

  
 /* Specifying Plot Symbols and Interpolation Lines  */
 
goptions reset=all;
proc gplot data=orion.budget;
   plot Yr2007*Month / haxis=1 to 12;
   label Yr2007='Budget';
   format Yr2007 dollar12.;
   title 'Plot of Budget by Month';
   symbol1 v=dot i=join cv=red ci=blue;
run;
quit;

   
 /* Overlaying Multiple Plot Lines on the Same Set of Axes  */
 
goptions reset=all;
proc gplot data=orion.budget;
   plot Yr2006*Month yr2007*Month/ overlay haxis=1 to 12 vref=3000000
                                   cframe="very light gray";
   label Yr2006='Budget';
   format Yr2006 dollar12.;
   title 'Plot of Budget by Month for 2006 and 2007';
   symbol1 i=join v=dot ci=blue cv=blue;
   symbol2 i=join v=triangle ci=red cv=red;
run;
quit;

    

*p113d03;
 /* Using ODS Styles to Control Appearance of Output  */
 
ods listing style=gears;
goptions reset=all;
proc gplot data=orion.budget;
   plot Yr2007*Month;
   format Yr2007 dollar12.;
   label Yr2007='Budget';
   title 'Plot of Budget by Month';
run;
quit;

     
 /* Specifying Options in TITLE and FOOTNOTE Statements 
    to Control Text Appearance  */
 
ods listing style=gears; 
goptions reset=all;
proc gplot data=orion.budget;
   plot Yr2007*Month / vref=3000000;
   label Yr2007='Budget';
   format Yr2007 dollar12.;
   title f=centbi h=5 pct 'Budget by Month';
   footnote c=green j=left 'Data for 2007';
run;
quit;

    
 /* Using a GOPTIONS Statement to Control the Appearance of Output  */
 
ods listing style=gears;
goptions reset=all ftext=centb htext=3 pct ctext=dark_blue;
   proc gplot data=orion.budget;
   plot Yr2007*Month / vref=3000000;
   label Yr2007='Budget';
   format Yr2007 dollar12.;
   title f=centbi 'Budget by Month';
run;
quit;  
