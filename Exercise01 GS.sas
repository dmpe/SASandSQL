/* Problem 1) */
/* Make a libname to the folder where you have you SAS datasets. (Or libnames if you use more than  
/* one folder). Show the contents of the SAS data sets in the library that you have just defined. */
libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';

Proc contents data=exam._all_ nods;
Run;
Proc contents data=exam.jan2012;
Run;

data test;
set exam.key01;
set exam.x201201;
run;

/* Problem 2) */
/* Make a temporary data set from the “jan2012”-data (EXAM). Drop the variables "segment" and "units" in */
/* the set-statement. Make an id-variable – call it n. */

Data test1;
 set exam.Jan2012(drop=segment units);
  n=_n_;
Run;

/* Problem 3) */
/* Make a new temporary data set from the temporary data set that you just made. */
/* It is annoying that the variable "product" contains values that start with lower case letters (hint:  */
/* propcase). */

Data test2;
 set test1;
  product = upcase(product);
Run; 

/* Problem 4) */
/* Make new temporary data sets from the temporary data set you just made. */
/* First delete observations with missing "date". */
/* If the initials are missing or contains "-" then add those observations to a separate data set.  */
/* All other observations are saved in another data set. This data set is used in 5). */

data test4 test5;
set test2;
where date is not missing ;
if initials = . or (find(initials ,'-')>0) then output test5;
else output test4;
run;

Data test3 testa; 
 set test2;
  where date is not missing;
   if initials = " " or (find(initials,"-","i") >0) then output testa; 
*i (or I) is a modifier and ignores character case during the search;
     else output test3;
Run;


/* Problem 5) */
/* Some of the observations belong together - if there is an employer subsidy ("RABAT") an extra  */
/* observation (line) is added to the data set. I would like this extra line removed and the discount  */
/* added to the first of the two observations (lines). */
/* Make a variable called totprice that shows the actual price the employee has to pay for the product,  */
/* i.e. price minus discount. */

Proc freq data=work.test3;
 tables product salesunit;
 tables product*salesunit;
Run;

/* merge by id number */

Data jan_rabat jan_norabat;
 set test3(drop=n);
    n=_n_; /* id*/
     if upcase(product) = '*** RABAT ***' then do;
 	  n=n-1; /* get back to previous line */
	   output jan_rabat;
	 end;
      else if upcase(product) ne '*** RABAT ***' then do;
	   output jan_norabat;
	  end;
Run;

Data jan_rabat(drop=product); 
 set jan_rabat(keep=date time initials n product subsidy price);
  Rename date=datenew time=timenew price=pricenew;
Run;
 
Data januar2013;
 merge jan_norabat(in=j) jan_rabat(in=jj);
  by n initials; /* dont have to sort by innitials */
/* Remember the variables "n" and "initials" should be sorted - are they?  */
/* Why do I have "initials" in the BY statement? */
   if j;
    totprice=sum(price, pricenew);
Run;


/* Problem 6) */
/* Make a summary of the purchases for each employee for each day (hint: proc summary). */


Proc sort data=januar2013(keep=date initials totprice) out=januar2013a;
  by date initials;
Run;

Proc summary data=januar2013a;
 by date initials;
  var totprice;
   output out=januar2013b(drop=_T:) sum=; /* drop everything that starts with T */
Run;


/* Problem 7) */
/* Redo what you just did in 6, this time remove observations having "product" = "Pant retur". (Pant =  */
/* deposit). */
/* Save those observations having "product" = "Pant retur" in a separate data set. Make a summary  */
/* (proc summary) per week - i.e. how many observations and how much money is paid back to the  */
/* employees in total per week (week number). */


Proc sort data=januar2013 out=januar2013a_7(keep=date initials totprice);
  by date initials;
   where upcase(product) ne 'PANT RETUR';
Run;

Proc summary data=januar2013a_7;
 by date initials;
  var totprice;
   output out=januar2013b_7(drop=_T:) sum=;
Run;

Data januar2013c;
 set januar2013;
  where upcase(product) ne 'PANT RETUR';
   week = week(date);
Run;

Proc sort data=januar2013c out=januar2013c;
 by week initials;
Run;  

Proc summary data=januar2013c;
 by week initials;
  var totprice;
   output out=januar2013c_7(drop=_T:) sum=;
Run;




/* Problem 8) */
/* Redo "Problem 3)". This time you are not supposed to use propcase. */

/* See next problem */

/* Problem 9) */
/* Make comments to the following sas code in : */


/*libname exam '/folders/myfolders/exam/';
Comments: The libname associates the SAS library with a libref 
which is a nickname (exam) for the storage location where my SAS 
files are stored: 'C/folders/myfolders/exam/'*/
/*Inencoding=asciiany; */


Data test1; /* We are creating a new Data set called test1 which is a temporary one*/
 set exam.jan2012(drop=segment units); /* The set statement indicates 
    where we get the Data from. In this case we get it from the permanet 
    SAS dateset called loaddata.Jan2012. The drop statement in dicates that 
    we dont import the segment and units variables.*/ 
  n=_n_; /* n is a new variable created in this Data step. It is equal 
    to the automatically created variable _n_ which is initially set to 1. 
    Each time the Data step loops past the Data statement the variable _n_ increases by 1.*/
Run; /*The run statement marks a step boundary and executes the Data step*/


Data test1; 
set test1;
 b=1;/*the "variable" b is a constant (Yes I know variables are not constants). 
  It is equal to 1*/
Run;


Data test2(drop=b--allletters); /*we are deleting all the variables 
between b and alletters*/
 set test1; 
  by b; 
   if last.b then delete;
/*the beginning and end of a "by" group creates a temporary variable (actually two)
 for the "by" variable: "last.variable" (and also "first.variable"). 
 The value of these variables is either 0 or 1. 
 SAS sets the value of "last.variable" = 1 when it reads the last observation in a BY group. 
 This temporary variable is not added to the output Data set.*/ 
/* if the variable is existing i.e. = 1 (and not 0) then the observation is deleted.*/

  firstletter=upcase(substr(product,1,1));
/*A new variable, firstletter, is constructed from a portion of the variable product.
  The substr function is used. The substring is constructed from the first (the first 1) 
  position character to next (the second 1 = the number of characters to extract.)
  The upcase function makes all the characters into upper case letters. 
  */ 

/*
do not copy paste
*/

  otherletters=substr(product,2,length(product)-1);
/*A new variable, otherletters, is constructed in a similar fashion. Starting from character
  number two to the rest of the character value, which is the length of product minus 1 since 
  there are only n-1 characters left.*/

  allletters=trim(left(firstletter))||trim(left(otherletters));
/*A new variable, allletters, is constructed. It is a concatenation of the previous two 
  constructed variables - firstletter and otherletters. The trim function is used to remove 
  trailing blanks, and left is aligning left so there should not be any blanks in the 
  new varaible.*/

  product=allletters;
/*Product is set equal to the variable allletters, which is deleted together with the 
  other new constructed variables AND the old constant, b.*/
Run; 


/*  */
/* Data test1test2;  */
/*  set test1 end=last;  *This is a lot more efficient than "Test1 and Test2"; */
/*   if last then delete; */
/*   firstletter=upcase(substr(product,1,1)); */
/*   otherletters=substr(product,2,length(product)-1); */
/*   allletters=trim(left(firstletter))||trim(left(otherletters)); */
/*   product=allletters; */
/* Run; */


/*  */
/* Problem 10) */
/* Make a libname to the folder where you have your SAS datasets. (Or libnames if you use more  */
/* than one folder). Show the contents of the SAS data sets in the library that you have just defined. */
/* Make the "januar2013" data set into a permanent data set. */



Proc contents data=loaddata._all_;
Run;
Data exam.january2013new;
 set work.januar2013;
Run;


/* Problem 11) */
/* Are employees that return the bottles and get deposits back higher spenders in the canteen */
/* compared to the rest of the employees? */
/* sum columnwise, EXAM !!! */

Proc sort data=exam.january2013new out=jan2013_01(keep=initials) nodupkey;
 by initials;
  where upcase(product) = 'PANT RETUR';
Run;

Proc sort data=exam.january2013new out=jan2013_02;
 by initials;
Run;

Data jan2013_03(drop=date--weekday department--totprice);  /* -- for all vars date to weekday that start with it*/
 merge jan2013_02 jan2013_01(in=j); /* 0 if it is in*/
  by initials; 
   if j=1 then pant=1; 
    else if j=0 then pant=0;
        if first.initials then tot=0;     
         tot+totprice;
   		  if last.initials;      /* then output, in these intersted*/ 
Run;

Proc sort data=jan2013_03 out=jan2013_04;
 by pant; 
Run;

Proc summary data=jan2013_04;
 by pant; 
  var tot; 
   output out=jan2013_05(drop=_:) mean=; /* delete everyhting that starts with _; mean = tot if not specifi it */
Run;

/* Problem 12) */
/* On which weekday is the sale highest in the canteen? */
 
 /* situation sunday = 1 -> sunday -> 7 */
Data jan2013_06(keep=newweekday totprice);
 set exam.january2013new;
   dday=weekday(date);
  select (dday);
   when (1) do;
     newweekday=7;
   end;    
    otherwise do; 
     newweekday=weekday(date)-1;
    end;
   end;
Run;
	
Proc sort data=jan2013_06;
 by newweekday;
Run;
	
Data jan2013_07(keep=newweekday tot); 
 set jan2013_06;
  by newweekday; 
   if first.newweekday then tot=0;     
    tot+totprice;
     if last.newweekday;       
Run;
	
Proc summary data=jan2013_07;
 by newweekday; 
  var tot; 
   output out=jan2013_08(drop=_:) mean=;
Run;
	

/* Problem 13) */
/* Calculate the average sales per day but only for employees that are also in the sample04 dataset, and  */
/* not in the sample03 dataset.  */

Proc sort data=exam.sample4(keep=initials) out=sample04 nodupkey;
 by initials;
Run;

Proc sort data=exam.sample3(keep=initials) out=sample03 nodupkey;
 by initials;
Run;

Proc sort data=exam.january2013new out=alldata01;
 by initials;
Run;

Data alldata02;
 merge alldata01(in=j) sample04(in=jj) sample03(in=jjj);
  by initials; 
   if j=1 and jj=1 and jjj=0;
Run;

Proc sort data=alldata02;
 by date;
Run;

Data alldata03;
 set alldata02;
  by date;
   if first.date then tot=0;     
    tot+totprice;
     if last.date;       
Run;

Proc summary data=alldata03; 
  var tot; 
  by date;
   output out=alldata04(drop=_:) mean=;
Run;
	
