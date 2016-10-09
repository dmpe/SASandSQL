libname loaddata '/folders/myshortcuts/SASUniversityEdition/loaddata/';
libname orion '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data';
libname prog1 '/folders/myshortcuts/SASUniversityEdition/lecture1/';
libname savedata '/folders/myshortcuts/SASUniversityEdition/savedata/';

/* inencoding=asciiany */

/* The CONTENTS procedure displays the descriptor portion of a Data set i.e. */
/*  information about the SAS Data set (name, number, etc.) and about the  */
/*  variables (name, type, length, etc.). */
/* _all_ means all the Data sets. */

Proc contents data=orion._all_ nods;
Run;
/* What does the "NODS" mean? */
/* option suppresses the descriptor portions of the data sets.*/
 
Proc contents data=orion.employee;
Run;

Proc contents data=orion.employee_payroll;
Run;

/* Check the log - any errors? */


/* In order to be able to use Data in SAS the Data has to be in a SAS format. */
/* If the Data is not in SAS format you need to "import" or "read" the data  */
/* into SAS - PDF (CHT 6-7) and LittleSASBook (CHT 2). */

Proc import datafile="/folders/myshortcuts/SASUniversityEdition/lecture1_Thursday/Transactions2012January.xlsx"
 out=WORK.tests
  dbms=XLSX
   replace;
Run;

/* When we use "", or "Work." our data is only temporarily stored - i.e. only until  */
/* the end of your sas session. */

Data test01;
 set orion.budget;
Run;

Data work.test01;
 set orion.budget;
Run;

/* If on the other hand another extension is used like "savedata." or "orion." etc */
/* then the Data set test01 is saved permanently in the "savedata" library */

Data savedata.test01;
 set orion.budget;
Run;



/* A SAS program starts with either a "Data statement" or a "Proc statement". */
/*  */
/* The sort procedure orders SAS Data set oberservations by the values of one */
/* or more character or numeric variables. This procedure replaces */
/* the input Data set or makes a new Data set. */


Proc sort data=tests out=savedata.tests_refined_01; 
 by product;
Run;

****TRY to sort other variables from the "tests" dataset just made;


Proc sort data=tests out=savedata.tests_refined_02; 
 by initials date;
Run;

/* Use the "where=" Data set option with an input Data set to select observations  */
/* that meet the condition specified in the WHERE expression before SAS brings  */
/* them into the Data or Proc step for processing. Selecting observations  */
/* that meet the conditions of the WHERE expression is the first operation  */
/* SAS performs in each iteration of the Data step */


/* Check the "log" */

Data test02a; /* 1 +3 should be equal, pick one and go home */
 set savedata.tests_refined_01;
  where weekday= "mandag";
Run;

Data test02b(where=(weekday="mandag")); /* bring all books and then pick one later, same with if here */
 set savedata.tests_refined_01;
Run;
Data test02c;
 set savedata.tests_refined_01(where=(weekday="mandag")); /* for big data better before */
Run;

*See EXTRA for where vs if;

Data test03; 
 set savedata.tests_refined_01;
  if wekday= "mandag";
  *or if weekday= "mandag" then output;
Run;

/* Check for errors */


/*Check the "results"*/
*The number of observation = firstobs-obs+1;

Proc print data=test02a (firstobs=100 obs=150); 
Run;

/* Try different valeus of firstobs and obs  */


/* Where statements - CHT 5 Progesse */

Data week37_01;
 set ORION.CUSTOMER_DIM;
  where  Customer_Gender = 'M';
Run;

* = means "equal to" (eq);
* ^= or ~= means "not equal to" (ne);
* > means "greather than" (gt);
* < means "less than" (lt);
* >= means "greather than or equal" (ge);
* <= means "less than or equal" (le);
* equal to one from a list (in);

Data week37_02;
 set ORION.CUSTOMER_DIM;
  where Customer_Age ge 30 ;
Run;

*Combining several where clauses;
* copy of data;
Data week37_03;
 set ORION.CUSTOMER_DIM;
  where Customer_Age ge 30 or Customer_Gender = 'M';
  * Try with "or" as well;
Run;

*or;

Data week37_04;
 set ORION.CUSTOMER_DIM;
  where Customer_Age ge 30;
   where also Customer_Gender = 'M';
Run;

* difference - basically overwrites !;

Data week37_04;
 set ORION.CUSTOMER_DIM;
  where Customer_Age ge 30;
   where Customer_Gender = 'M';
Run;


/*  */
/* Data week37_04x; */
/*  set ORION.CUSTOMER_DIM; */
/*   where Customer_Age ge 30; */
/*    where Customer_Gender = 'M'; */
/* Run; */
/*  */


*If the variable is a date remember the 'd' after the value;

Data week37_05;
 set ORION.CUSTOMER_DIM;
  where Customer_BirthDate gt '01APR67'd;
Run;

* Use the 'in' option;

Data week37_06;
 set ORION.CUSTOMER_DIM;
  where Customer_FirstName in ('Karen', 'Carsten');
Run; 

Data week37_07;
 set ORION.CUSTOMER_DIM;
  where Customer_ID in (20, 23, 24);
Run; 

* Using Between-and, is null, is missing, contains, like ;

Data week37_08;
 set ORION.EMPLOYEE_DONATIONS;
  where  Qtr1 between 1 and 10;
Run; 

Data week37_09;
 set ORION.EMPLOYEE_DONATIONS;
  where Qtr1 is missing;
   *same as: where Qtr1 is null;
Run; 

Data week37_10;
 set ORION.EMPLOYEE_DONATIONS;
  where  Recipients like '%International%';
Run;
 
Data week37_11;
 set ORION.EMPLOYEE_DONATIONS;
  where  Recipients like '_qua%';
Run;
 
Data week37_12;
 set ORION.EMPLOYEE_DONATIONS;
  where  Recipients like'%Interna_ional%';
Run;
 
/* Try with contains */

Data week37_12;
 set ORION.EMPLOYEE_DONATIONS;
  where Recipients contains 'International';
Run;

*Try the escape clause e.g. use 'like' '%' - in connection with escape '/';

Data week37_13;
 set ORION.EMPLOYEE_DONATIONS;
  where  Recipients like '%/%%' escape '/';
Run;

*Drop or keep indicate which variables to drop or keep;

Data week37_14;
   set orion.sales;
    where Country='AU' and Job_Title contains 'Rep';
     keep First_Name Last_Name Salary Job_Title Hire_Date;
Run;

Data week37_15;
   set orion.sales;
    where Country='AU' and Job_Title contains 'Rep';
     drop First_Name Last_Name;
Run;
 
Data week37_16;
   set orion.sales(drop=First_Name Last_Name);
    where Country='AU' and Job_Title contains 'Rep';
Run;

Data week37_17(keep=First_Name Last_Name Salary Job_Title Hire_Date);
   set orion.sales;
    where Country='AU' and Job_Title contains 'Rep';
Run;
 
*Adding permanent attributes;
*a label changes the appearance of a variable name
whereas a format changes the appearance of a variable value;

Data week37_18;
   set orion.sales;
    where Country='AU' and Job_Title contains 'Rep';
     keep First_Name Last_Name Salary Job_Title Hire_Date;
      label Job_Title='Sales Title' Hire_Date='Date Hired';
Run;
Proc contents data=orion.sales;
Run;
Proc contents data=week37_18;
Run;
Proc print data=week37_18 label;
Run;


Data week37_19;
   nldate=0; nldatemn=0;
   nldatew=0; nldatewn=0; output; /* first observation */
   nldate=17245; nldatemn=17245;
   nldatew=17245; nldatewn=17245; output;
Run;

options locale=German_Germany;
Proc print data=week37_19;
   format nldate nldate. nldatemn nldatemn.
          nldatew nldatew. nldatewn nldatewn.;
Run;

options locale=English_UnitedStates;
Proc print data=week37_19;
   format nldate nldate. nldatemn nldatemn.
          nldatew nldatew. nldatewn nldatewn.;
Run;

options locale=Danish_Denmark;
Proc print data=week37_19;
   format nldate nldate. nldatemn nldatemn.
          nldatew nldatew. nldatewn nldatewn.;
Run;


Data week37_20;
  set orion.sales;
   where Country='AU' and Job_Title contains 'Rep';
    label Job_Title='Sales Title' Hire_Date='Date Hired';
     format Salary commax8. Hire_Date ddmmyy10.;
Run;

*Try other formats - CHT 5 in the Progresse pdf-file and CHT 2 and 3;

Proc contents data=week37_20;
Run;

Proc print data=week37_20 label;
Run;

Data week37_21;
 x=today();
  y=234567.123;
Run;

Data week37_22;
  x=today();
  y=234567.123;
  format x ddmmyy8. y commax10.2;
Run;
 
Proc contents data=week37_22;
Run;
/*
Proc import datafile="/folders/myfolders/loaddata/Transactions2012January.xlsx"
 out=WORK.tests
  dbms=XLSX replace;
Run;
*/
*Here we export a SAS-file to Excel;

Proc export 
 data= ORION.QTR1_2007 
  outfile= "/folders/myshortcuts/SASUniversityEdition/loaddata/qtr2007c.xlsx" 
   dbms=XLSX replace; 
Run;

Proc export 
 data= ORION.QTR1_2007 
  outfile= "/folders/myshortcuts/SASUniversityEdition/loaddata/qtr2007c.csv" 
   dbms=csv replace; 
Run;

Data week37_23;
   length Name $ 20 Phone Mobile $ 14;
   infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/phone.csv' dsd missover;
   input Name $ Phone $ Mobile $;
Run;

*The infile identifies the physical name of the raw Data file;
*to read with an input statement;
*dsd: sets the default delimiter to a comma. When you specify dsd, SAS;
*treats two consecutive delimiters as a missing value and removes quotation;
*marks form character values. The dsd option specifies that when data;
*values are enclosed in quotation marks, delimiters within the value are;
*are treated as character data;
*missover: If SAS reaches the end of the row without finding values;
*for all fields, variables without values are set to missing;

Data week37_24;
   length First_Name $ 12 Last_Name $ 18 
          Gender $ 1 Job_Title $ 25 
          Country $ 2;
    infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/sales.csv' dlm=',';
     input Employee_ID First_Name $ Last_Name $ 
           Gender $ Salary Job_Title $ Country $ 
           Birth_Date :date. 
           Hire_Date :mmddyy.;
      drop First_Name Last_Name Salary Job_Title Hire_Date;
       label Job_Title='Sales Title'
             Hire_Date='Date Hired';
        format Salary dollar12. Hire_Date monyy7.;
Run;


*From the LOG: "NOTE: Invalid Data for Hire_Date in line 9 63-71.";

Data week37b_01 week37b_01a;
   length Employee_ID 8 First $ 12 Last $ 18 
          Gender $ 1 Salary 8 Job_Title $ 25 Country $ 2
          Birth_Date Hire_Date 8;
    infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/nonsales.csv' dlm=',';
     input Employee_ID First $ Last $ 
         Gender $ Salary Job_Title $ Country $ 
         Birth_Date :date9. 
         Hire_Date :date9.;
      format Birth_Date Hire_Date ddmmyy10.;
     
   if _error_=1 then output week37b_01a;
    else output week37b_01; 
      
Run;

Proc print data=week37b_01;
Run;

*Showing missing values or "wrong" dates;
Proc print data=orion.nonsales;
   var Employee_ID Job_Title Birth_Date Hire_Date;
    where Job_Title = ' ' or Birth_Date > Hire_Date;
Run;

*Showing categories - are they the right ones;
Proc freq data=orion.nonsales;
  * tables Gender Country;
    tables gender*country;
     tables gender*country /chisq nopercent;
   
Run;

Proc means data=orion.nonsales n nmiss min max; * probt t;
   var Salary;
Run;


Proc univariate data=orion.nonsales ;
   var Salary;
Run;

/*  */
/* Proc means and Proc univariate  */
/*  */
/* Proc means: */
/* provides Data summarization tools to compute  */
/* descriptive statistics for variables  */
/* across all observations or within groups of observations */
/*  */
/* Proc univariate: */
/* Used to explore the Data distributions of variables */
/* Ã¢â‚¬â€œ summarize, visualize, analyze, and model the statistical  */
/* distributions of numeric variables */
/* The univariate procedure can produce among other things */
/* moments, basic statistical measures, tests for location,  */
/* quantiles, extreme and outlier observations, and missing values */


Proc freq data=orion.nonsales;
   tables Gender Country;
Run;

Proc freq data=orion.nonsales nlevels;
   tables Gender Country Employee_ID;
Run;

Proc freq data=orion.nonsales nlevels;
   tables Gender Country Employee_ID / noprint;
Run;

Proc freq data=orion.nonsales nlevels;
   tables _all_ / noprint;
Run;


Data week37b_02;
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
Run;

Proc freq data=week37b_02 nlevels;
   tables Gender Country Employee_ID /noprint;
Run;

*compare with week37b_01;

Proc print data=week37b_02;
   var Employee_ID Gender Salary Job_Title
       Country Birth_Date Hire_Date;
   where Employee_ID = . or
         Gender not in ('F','M') or
         Salary not between 24000 and 500000 or
         Job_Title = ' ' or
         Country not in ('AU','US') or
         Birth_Date > Hire_Date or
         Hire_Date < '01JAN1974'd;
Run;


********** IF-THEN DO / ELSE DO Statements **********;

Data week37b_03;
   set orion.sales;
    if Country='US' then do;
    	Bonus=500;
		Freq='Once a Year';*should have lenght of 11, -> have to specify it before
    end;
     else if Country='AU' then do;
     	Bonus=300;
	 	Freq='Twice a Year';
     end;
Run;

Data week37b_04;
   set orion.sales;
    length Freq $ 12; *must be otherwise it cuts "r"
     if Country='US' then do;
     	Bonus=500;
	 	Freq='Once a Year';
     end;
      else if Country='AU' then do;
      	Bonus=300;
	  	Freq='Twice a Year';
   	  end;
Run;



	********** ELSE DO Statement **********;

Data week37b_05;
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
Run;

/*
if BM;
=is not missing

a+b => if one missing, then missing
not with sum
*/

Data week37b_06;
   set orion.sales; *where first, second if
    where Country='AU' and BonusMonth=12;
     BonusMonth=month(Hire_Date); *week() would be different
     * if BonusMonth=12;
       Bonus=500;
   		Compensation=sum(Salary,Bonus);
Run;

Proc print data=week37b_06;
   var Employee_ID Bonus BonusMonth Compensation;
Run;


Data week37b_07_not;
   set orion.sales;
    BonusMonth=month(Hire_Date);
     where Country='AU' and BonusMonth=12; /* BonusMonth should exists already in original dataset */
      Bonus=500;
       Compensation=sum(Salary,Bonus);
Run;


Data week37b_07;
   set orion.sales; /* works */
    BonusMonth=month(Hire_Date);
     where Country='AU' and month(Hire_Date)=12; 
      Bonus=500;
       Compensation=sum(Salary,Bonus);
Run;


Proc print data=week37b_07;
   var Employee_ID Bonus BonusMonth Compensation;
Run;


Data week37b_08;
   set orion.sales;
    where Country='AU';
     BonusMonth=month(Hire_Date);
      if BonusMonth ne 12 then delete;
       Bonus=500;
        Compensation=sum(Salary,Bonus);
Run;


Data week37b_09;
   set orion.staff;
    Increase=Salary*0.10;
     NewSalary=sum(Salary,Increase);
      keep Employee_ID Salary Increase NewSalary;
       format Salary Increase NewSalary comma10.2;
Run;


Data week37b_10;
   set orion.customer;
    Bday2009=mdy(month(Birth_Date),day(Birth_Date),2009);
     BdayDOW2009=weekday(Bday2009);
      Age2009=(Bday2009-Birth_Date)/365.25;
       keep Customer_Name Birth_Date Bday2009 BdayDOW2009 Age2009;
        format Bday2009 date9. Age2009 3.;
Run;

Proc print data=week37b_10;
Run;

*what does catx mean and what does intck means?;

Data week37b_11;
   set orion.sales;
    FullName=catx(' ',First_Name,Last_Name);
     Yrs2012=intck('year',Hire_Date,'01JAN2012'd);
      format Hire_Date ddmmyy10. Birth_Date ddmmyy10.;
       label Yrs2012='Years of Employment in 2012';
Run;

/*
data not created, just for output/log
*/

data _null_;
   separator='%%$%%';
   x='The Olympic  '; 
   y='   Arts Festival ';
   z='   includes works by ';
   a='Dale Chihuly.';
   result=cat(separator,x,y,z,a);
   put result $char.; 
run;


Data week37b_12;
   set orion.nonsales;
    length Gift1 Gift2 $ 15;
     select(Gender);
       when('F') do;
        Gift1='Perfume';
	    Gift2='Iphone6';
       end;
        when('M') do;
	     Gift1='Cologne';
	     Gift2='Samsung Galaxy';
        end;
	     otherwise do;
	      Gift1='Coffee';
	      Gift2='Calendar';
         end;
     end;
     if _n_ = 14 then Employee_ID=120116;
    keep Employee_ID First Last Gift1 Gift2;
Run;  

Data week37b_12;
   set orion.employee_donations;
    Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
     NoDonation=nmiss(Qtr1,Qtr2,Qtr3,Qtr4);
     if Total < 50 or NoDonation > 0 then delete;
Run;


/* have to sort before, by var that is going to be merged !*/
Proc sort data=orion.employee_payroll out=week37b_13a; 
   by Employee_ID;
Run;

Proc sort data=orion.employee_addresses out=week37b_13b;
   by Employee_ID;
Run;

Data week37b_14;
   merge week37b_13a week37b_13b;
    by Employee_ID;
Run;



Data EmpsAU;
   input First $ Gender $ EmpID;
datalines;
Togar M 121150
Kylie F 121151
Birin M 121152
;
Run;

Data PhoneC;
   input EmpID Phone $15.;
datalines;
121150 +61(2)5555-1795
121152 +61(2)5555-1667
121153 +61(2)5555-1348
;
Run;

/*
in = include, merge as before
*/

Data EmpsAUC;
   merge EmpsAU(in=Emps) PhoneC(in=Cell);
    by EmpID;
     if Emps=1 and Cell=0; /* then output*/
*what if emps=0 and/or cell=0;
Run;


Data EmpsAUC EmpsOnly PhoneOnly;
   merge EmpsAU(in=Emps) PhoneC(in=Cell);
    by EmpID;
     if Emps=1 and Cell=1 then output EmpsAUC;
      else if Emps=1 and Cell=0 then output EmpsOnly;
       else if Emps=0 and Cell=1 then output PhoneOnly;
Run;




Proc sort data=orion.customer out=week37b_15;
   by Country;
Run;



Data work.allcustomer;
   merge week37b_15(in=Cust) 
         orion.lookup_country(rename=(Start=Country Label=Country_Name) in=Ctry);
    by Country;
     keep Customer_ID Country Customer_Name Country_Name;
      if Cust=1 and Ctry=1;
Run;


ods html file='/folders/myfolders/myreport.html' style=Minimal;

Proc means data=orion.sales;
   var Salary;
   title 'Report One';
Run;

Proc print data=orion.sales;
   title 'Report Two';
Run;

ods html close;

title;


Proc print data=orion.sales label;
   var Employee_ID First_Name Last_Name Salary;
Run;


options nocenter;
ods html file='/folders/myshortcuts/SASUniversityEdition/loaddata/enhanced.html' style=sasweb;
Proc print data=orion.sales label;
   var Employee_ID First_Name Last_Name Salary;
    title1 'Orion Sales Employees';
     title2 'Males Only';
      footnote 'Confidential';
       label Employee_ID='Sales ID' First_Name='First Name'
         Last_Name='Last Name' Salary='Annual Salary';
          format Salary dollar8.;
           where Gender='M';   
            by Country;
Run;
ods html close;

********** Reset Global Statements **********;
options center;
title;
footnote;




Proc format;
   value $ctryfmt  'AU' = 'Australia'
                   'US' = 'United States' 
                  other = 'Miscoded';
Run;

Proc print data=orion.sales label;
   var Employee_ID Job_Title Salary Country Birth_Date Hire_Date;
    label Employee_ID='Sales ID'
           Job_Title='Job Title'
            Salary='Annual Salary'
             Birth_Date='Date of Birth'
              Hire_Date='Date of Hire';
     format Salary dollar10.0 
      Birth_Date Hire_Date monyy7.
       Country $ctryfmt.;
Run;

********** Numeric User-defined Format **********;
Proc format;
   value tiers  20000-49999  = 'Tier 1'                  
                50000-99999  = 'Tier 2'
               100000-250000 = 'Tier 3';
Run;

Proc print data=orion.sales label;
   var Employee_ID Job_Title Salary Country Birth_Date Hire_Date;
    label Employee_ID='Sales ID'
           Job_Title='Job Title'
            Salary='Annual Salary'
             Birth_Date='Date of Birth'
              Hire_Date='Date of Hire';
     format Birth_Date Hire_Date monyy7.
             Salary tiers.;
Run;

Proc print data=orion.sales label;
   var Employee_ID Job_Title Salary Country Birth_Date Hire_Date;
    label Employee_ID='Sales ID'
     Job_Title='Job Title'
      Salary='Annual Salary'
       Birth_Date='Date of Birth'
        Hire_Date='Date of Hire';
     format Birth_Date Hire_Date monyy7.
             Salary tiers.;
Run;


Proc format;
   value $ctryfmt  'AU' = 'Australia'
                   'US' = 'United States' 
                  other = 'Miscoded';
     value tiers    low-<50000  = 'Tier 1'                  
                  50000- 100000 = 'Tier 2'
                 100000<-high   = 'Tier 3';
Run;

Proc print data=orion.sales label;
   var Employee_ID Job_Title Salary Country Birth_Date Hire_Date;
    label Employee_ID='Sales ID'
         Job_Title='Job Title'
          Salary='Annual Salary'
           Birth_Date='Date of Birth'
            Hire_Date='Date of Hire';
     format Birth_Date Hire_Date monyy7.
             Country $ctryfmt. 
               Salary tiers.;
Run;

Proc freq data=orion.sales;
    tables Country Salary;
     format Country $ctryfmt. Salary tiers.;
Run;

Proc freq data=orion.sales;
    tables Country*Salary /cellchi2 chisq;
     format Country $ctryfmt. Salary tiers.;
Run;



Proc sort data=orion.sales out=work.sort;
   by Country descending Gender Last_Name;
Run;

********** BY Statement with Proc PRINT **********;
Proc print data=work.sort;
   var Employee_ID First_Name Last_Name Salary;
    by Country descending Gender;
Run;

********** BY Statement with Proc MEANS **********;
Proc means data=work.sort;
   var Salary;
    by Country descending Gender;
Run;

********** BY Statement with Proc FREQ **********;
Proc freq data=work.sort;
   tables Gender;
    by Country;
Run;




/*--Histogram--*/


Data _null_;
	x=dcreate("ODSEditorFiles","/folders/myfolders/");
Run;

ods listing gpath="/folders/myfolders/ODSEditorFiles";

Proc freq data=orion.sales;
   tables Country;
Run;

Proc sgplot data=orion.sales;
   hbar Country;
Run;
quit;

ods listing close;

Data week37b_16;
   set orion.employee_payroll;
    BirthMonth=month(Birth_Date);
     if BirthMonth le 3;
Run;

Proc format;
   value $gender
      'F'='Female'
      'M'='Male';
    value moname
       1='January'
       2='February'
       3='March';
Run;


Proc freq data=Q1Birthdays;
   tables BirthMonth Employee_Gender;
    format Employee_Gender $gender.
            BirthMonth moname.;
     title 'Employees with Birthdays in Q1';
Run;



Proc format;
   value $gender
        'F'='Female'
        'M'='Male'
      other='Invalid code';
   value salrange
                  .='Missing salary'
      20000-<100000='Below $100,000'
      100000-500000='$100,000 or more'
              other='Invalid salary';
Run;

Proc print data=orion.nonsales;
    var Employee_ID Job_Title Salary Gender;
     format Salary salrange. Gender $gender.;
      title1 'Distribution of Salary and Gender Values';
       title2 'for Non-Sales Employees';
Run;


proc format library = savedata.cat1;
value $jc 'one' = 'management'
          'two' = 'non-management';
value rate 
           0 = 'terrible'
           1 = 'poor'
           2 = 'fair'
	   3 = 'good'
	   4 = 'excellent';
run;

Proc catalog catalog=savedata.cat1;
 contents;
Run;
Quit;

Proc format library=savedata.cat1 fmtlib;
 select $jc rate;
  title 'Formats'; 
Run;
Quit;



Proc format;
   value dategrp
                      .='None'
       low-'31dec2006'd=[year4.]
      '01jan2007'd-high=[monyy7.]
   ;
Run;

Proc freq data=orion.employee_payroll;
   tables Employee_Term_Date / missing;
    format Employee_Term_Date dategrp.;
     title 'Employee Status Report';
Run;



Proc freq data=orion.sales;
   tables Gender / chisq out=week37b_16 outcum;
    output out=week37b_17 chisq;
Run; 

Proc print data=week37b_16;
Run;

Proc print data=week37b_17;
Run;


Proc means data=orion.sales noprint nway; *chartype;
   var Salary;
    class Gender Country;
     output out=week37b_18(drop=_:)
      min=minSalary max=maxSalary sum=sumSalary mean=aveSalary;
Run;

Proc print data=week37b_18;
Run;


