libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';


data news;
merge mster(in=mst) updt(in=intrn); /*merge two data with temp in vars */
by name date; /* by name and date, aka a.name=b.name and a.date=b.date */
/* in principle this is wrong logic and should be just simple if's which will 
decide on how to merge data. */
if (mst and intrn) or (mst and not intrn) then output news;
/*it helps to recognize temporary variables (tags) - (mst and intrn) OR 
(mst and not intrn) - which of the original data sets contributed to each
observation in the new data set.  If they did, then data output is in news
Currently it basically says if inner join OR left join then out news

But actually it is full join because we dont specify what kind it is. 
Both cancel each other.
*/
if intrn and not mst then output news;
run;



proc sort data = exam.key01;
by initials idnumber01;
run;

proc sort data = exam.key03;
by initials idnumber01;
run;
data news;
merge exam.key01(in=mst) exam.key03(in=intrn); 
by initials idnumber01;
if (mst and intrn) or (mst and not intrn) then output news;
if intrn and not mst then output news;
run;


/* 1.2 */
data account (keep accnt dpl-dpl6);
array dp(6);
/*
The second ARRAY statement defines an array called EXP. 
A variable list is not provided for this array, so SAS
uses the array name and adds a numeric suffix (from 1–6) 
to associate the existing variables (dp1– dp6) with
the array.
*/
do j = 1 by 1 until (last.accnt); /* loop from 1 to last observation in the dataset, by 1 */
set depo;
/* i think set depo with grouping by statement should be placed outside of loop*/
by accnt;
/*assign dp1 variable depo (aka dataset ?) */
dp(j) = depo;
end;
run;

/* 1.3 */

%Macro vaca(x=expenses,v=_all_); /* define macro with 2 arguments */
Proc sql noprint; /* do not print results of query */
select mean(level), put(today(),mmddyy10.), month(today()) 
/* avarage of level, convert today to monthdayyear format and extract month 
from today's date*/
into :av,:dateX,:mon 
/* put those 3 vars into macro variables av, datex, mon */
from &x; /* from dataset express that will be resolved if nothing else has 
been passed in vaca call of macro */
Quit; 
%if &mon=1 or &mon=2 %then %do; /* if month macro variable resolves to 1 or 2 then */
	Proc print data=&x;  /* print dataset from above */
	title "Lowest Prices in the %upcase(&x) data"; 
	/* title resolved to Lowest Prices in the EXPENSES data*/
	footnote "On &dateX"; /*same*/
	var &v; /* all variables from dataset will appear in print output/report */
	where level<=&av; /* but where level is smaller equal to the avarage */
	Run; 
%end; 
%else %do; /* if month > 2, otherwise just without where */
	Proc print data=&x; 
	title "All Information in the %upcase(&x) Data"; 
	footnote "On &dateX"; 
	var &v; 
	Run; 
%end; /* end do statement */
%Mend; /* end macro*/

Options mprint symbolgen mlogic; 
/* 
http://www.ats.ucla.edu/stat/sas/faq/macro_debug.htm
set specific options, mlogic tells us the parameter values and 
option mprint translates the macro language to regular SAS language.
symbolgen displays the results of the resolving macro variable references.
*/
%Vaca( ) /* call macro*/

/* 1.4 
http://www2.sas.com/proceedings/sugi31/234-31.pdf
*/
Proc transpose data=work.file01 out=work.file01 name=transposedcolumns;
/* specifies the name for the variable in the output data set that contains 
the name of the variable that is being transposed to create the current observation.*/ 
var consumer product; /* vars to transpose */
id consumer; 
/* specifies  a  variable  in  the  input  dataset  
whose value is used to name a variable in the 
output dataset*/
Run;



/* 2.1 without sql */
proc sql;
title "x";
select product, sum(apr) label = "apr", sum(may) label = "may", sum(jun) label = "jun"
from (select prod,
case when substr(invdate,3,2)='04' then invAmount end as apr,
case when substr(invdate,3,2)='05' then invAmount end as may,
case when substr(invdate,3,2)='06' then invAmount end as jun from work.sales)
group by prod;
quit;

/*
select prod,
case when substr(invdate,3,2)='04' then invAmount end as apr,
case when substr(invdate,3,2)='05' then invAmount end as may,
case when substr(invdate,3,2)='06' then invAmount end as jun from work.sales
*/

data term1 (keep= prod apr may jun);
set work.sales;
/* 
begin reading invdate at position 3 of that character varaible, and read next 2 of them
and if that is equal to 04/05/06 then assign apr/may/jun invaamount variable
*/
if substr(invdate,3,2)='04' then apr= invAmount;
if substr(invdate,3,2)='05' then may= invAmount;
if substr(invdate,3,2)='06' then jun= invAmount;
run;
 /*
 http://www.ats.ucla.edu/stat/sas/modules/labels.htm*/
data asdf;
title "x";
set term1;
label apr = "apr" may="may" jun = "jun";
apr = sum(apr);
may= sum(may);
jun= sum(jun);
by prod;
run;

/* 2.2 without sql*/
proc sql ;
create table r_join as 
select *
from film(keep=title rating lenght) right join actors(keep=title actr_ldng)
on film.titl = actrs.titl;
select * from r_join;
quit;


data r_join;
merge film(in = o keep=titl rating lenght) actors(in = l keep=title actr_ldng);
by title;
if l;
run;

proc print data=r_join;
run;

/* 2.3 without sql*/
%Macro dit(lst); 
Proc sql noprint;
%let n=%sysfunc(countw(&lst));
%do i=1 %to &n;
%let vl = %scan(&lst,&i); create table bts._&vl as
select * from bts.week01 where itm=&val;
%end; Quit;
%Mend;
%dit(11 12 13);

/*
http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a002977495.htm
http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a000214639.htm
*/
%Macro dit(lst); 
%let n=%sysfunc(countw(&lst));
/*
 execute a function that Counts the number of words in a character string, here it is 
 a list -> store that number of words into n .
*/
%do i=1 %to &n; /* loop over all words in a list */
%let vl = %scan(&lst,&i); /* store in v1 nth word in character string*/
	data bts._&vl; /* data bts._11 */
	set bts.week01;
	where itm=&val; /* where program will error and not finish , because val is undefined*/
	run;
%end; /* end loop*/
%Mend; /* end macro */
%dit(11 12 13);

/* 2.4 -> use sql*/

Proc sort data=film;
by ttl;
Run;
Proc sort data=act; 
by ttl;
Run;

Data ro_merge;
merge film(in=Z keep=rtng ttl lngth) act(in=A keep=act_l ttl);
by ttl; 
if A;
Run;

proc sql ;
create table ro_merge as 
select *
from film(keep=rtng ttl lngth) right join act( keep=act_l ttl)
on film.ttl = act.ttl;
order by ttl;
quit;
/*
2.5 without arrays */
options mprint;

Data rcd_array; 
set xminc;
array axminc(12) xminc1-xminc12; 
do i = 1 to 12;
if axminc[i] < 3000 then axminc[i] = .
end; 
drop i;
Run;

Data rcd_array; 
set xminc;
if xminc1 < 3000 then xminc1 = .;
else if xminc2 < 3000 then xminc2 = .;
else if xminc3 < 3000 then xminc3 = .;
else if xminc4 < 3000 then xminc4 = .;
else if xminc5 < 3000 then xminc5 = .;
else if xminc6 < 3000 then xminc6 = .;
else if xminc7 < 3000 then xminc7 = .;
else if xminc8 < 3000 then xminc8 = .;
else if xminc9 < 3000 then xminc9 = .;
drop i;
Run;

/* 3.1 
The data sets Key01 and Key02 need some cleaning up. 
First, remove all duplicate observations (if any),
 and sort the data by Idnumber01. Next remove an 
 observation if one or more of the variables have
  a missing value. Merge the two data sets (without 
  SQL) by Idnumber01. Finally, remove the variable 
  Keytype. Call the new data set Exam01.
*/
proc sort data = exam.key02 nodup out=k2t;
by idnumber01;
run;
proc sort data = exam.key01 nodup out=k1t;
by idnumber01;
run;

data exam01;
merge k1t(in=a) k2t(in=b);
by idnumber01;
run;

data exam001;
set exam01(drop=keytype);
if cmiss(of _all_) then delete;
run;

/* 3.2 
Merge Key01 with Key03 by Idnumber01. 
Make sure that the data sets do not 
contain duplicate observations. Call 
this new data set Exam02. Merge Exam02 
with Employee and Expenditures. Once more,
 make sure that the data sets do not contain 
 duplicate observations. Call this new data set Exam02_1.
*/
proc sort data = exam.key03 nodup out=k3t;
by idnumber01;
run;
proc sort data = exam.key01 nodup out=k1t;
by idnumber01;
run;

data exam02;
merge k1t(in=a) k3t(in=b);
by idnumber01;
run;


proc sort data =exam.employee out=emp nodup;
by idnumber01;
run;

proc sort data =exam.expenditures out=expnd nodup;
by idnumber01;
run;

data exam02_01;
merge exam02 emp expnd;
by idnumber01;
if cmiss(of _all_) then delete;
run;

/* 3.3
Remove duplicate observations in the
 Exam data set before deleting the
  variable Deposit. Delete observations
   if the variable Position includes an 
   'II' at the last position. Call this 
   new data set Exam03. 
   
   Make three new 
   data sets in one “data statement” 
   where you use this result. If Expenditures is
    less than equal 100 then the name of the 
    output file should be Exam03_small. If 
    Expenditures is higher than 100 and less
     than equal 900 then the name of the output 
     file should be Exam03_big. Otherwise, the 
     name should be Exam03_missing.
 */
proc sort data =exam.exam out=exm nodup;
by idnumber01;
run;

data exam03;
set exm;
LAST_NAME = SCAN(position,-1,' ');
if (find(LAST_NAME,'II', "i")>0) then delete;
*if _n_ = 1 or _n_ = 2 then delete;
drop deposit;
run;

data Exam03_small Exam03_big Exam03_missing;
set  exam03;
if expenditures le 100 and expenditures not eq . then output Exam03_small;
else if expenditures gt 100 and expenditures le 900 then output Exam03_big;
else output Exam03_missing;
run;

/*
3.4
Make a Proc Format where you assign a label to the values 
of the variable Expenditures (from the Exam data set). E.g. use nine labels: 
Small01, Small02 Small03, Small04, Small05, Big06, Big07, Big08, and Big09.
*/
proc format;
   value tsadsadest -5 -< -3  = 'Small01'
                   -2 -< -0 = 'Small02' 
                  -0-< 2= 'Small03'
                  2 -< 6= 'Small04'
                  6 -< 8= 'Small05'
                  8 -< 10= 'Big06'
                  10 -< 12= 'Big07'
                  12 -< 14= 'Big08'
                  14 -< 20= 'Big09';
run;

data exam03_1;
set exam03;
format expenditures tsadsadest.;
run;

/*
3.5 
Use the data set Expenditures. 
Modify the values of the variable Idnumber01: 
Concatenate the two variables Idnumber01 and 
Deposit in such a way that the new values of 
Idnumber01 have the same length – use zeros 
to make the values have the same length. Delete missing values.
*/
data tyu;
set exam.expenditures;
idnumber02 = put(Idnumber01,z7.); 
deposit_01= put(deposit,z7.); 

di_dep = put(idnumber01, z7.)||"_"||put(deposit, z7.);
Idnumber02 = put(di_dep,z7.); 
if cmiss(of _all_) then delete;
run;

/* 3.6 
http://www.lexjansen.com/nesug/nesug00/ps/ps7012.pdf

Draw 1000 random samples from X2012_1_6cleaned10. 
The size of each sample should be equal to 100. 

Calculate the mean of Sumtotprice in each sample. 

Calculate the mean and standard deviation of the 
10000 means. 

Do not use Proc SurveySelect. 
Use Proc Append and use Macros. 
Graph the distribution of the 10000 means.
*/

/********************************/
/*Positional Parameters:
* EMDS is the input data set of eligible member population (EM), from
* which the sample will be draw.
* SAMPLE is the output sample.
* RAND is the randomization number for
* determining START.
*
* Keyword Parameters:
* MRSS is the minimum required sample size.
* OVERSAM is the oversampling rate, and 
the default is 5%.

********************************/
%MACRO SAMPLE(EMDS ,SAMPLE,RAND,MRSS=,OVERSAM=0.00);
DATA _NULL_;
  FSS= CEIL(&MRSS*(1+&OVERSAM));
  CALL SYMPUT('FSS',LEFT(PUT(FSS,8.)));
RUN;
 /* get the number of FSS and store it in &FSS */
DATA _NULL_;
  IF 0 THEN SET &EMDS NOBS=EM;
  CALL SYMPUT('EM', LEFT(PUT(EM,8.)));
  STOP;
RUN ;
  /*  get the number of EM and store it in &EM at compile time */
DATA &EMDS; 
	SET &EMDS;
    OBSNUM=_N_;
/* use OBSNUM to track chosen members */
RUN;
DATA _NULL_;
  N=FLOOR(&EM/&FSS);
  START=MAX(ROUND(&RAND*N),1);
  /* round START using .5 rule */
  CALL SYMPUT('N', LEFT(PUT(N,8.)));
  CALL SYMPUT('START',LEFT(PUT(START,8.)));
RUN ;
DATA &SAMPLE(DROP=I);
 LENGTH LIST $7;
  DO I=1 TO &FSS;
	  OBSIN=&START+FLOOR((I-1)*(&EM/&FSS));
	  SET &EMDS POINT=OBSIN;
	/*draw members by their observation #*/
	  IF I <= &MRSS THEN LIST='PRIMARY';
	  ELSE LIST='AUXILIA';
	  OUTPUT;
	  END;
 STOP;
RUN;
%PUT EM=&EM MRSS=&MRSS FSS=&FSS N=&N START=&START;
 /* output the values of these macro
variables to SAS LOG */
%MEND SAMPLE;


/*
Draw 1000 random samples from X2012_1_6cleaned10. 
The size of each sample should be equal to 100. 

Calculate the mean of Sumtotprice in each sample. 
Calculate the mean and standard deviation of the 
10000 means. 
Graph the distribution of the 10000 means.
*/


%macro trre;
    %let iter=1;
    %do %while (&iter.<= 10);
		%SAMPLE(exam.X2012_1_6cleaned10, B&iter. ,0.08,MRSS=100,OVERSAM=0.00);
		 
		 /* in each sample*/
		 proc means data= B&iter. mean;
		 var sumtotprice;
		 output out=B&iter._means;
		 run;
		 /* musim transose first */
		 
		 proc sgpanel data=B&iter._means;
			 panelby mean;
			 histogram std;
			 density std;
			run;

	%let iter=%eval(&iter.+1);
	%end;
%mend;
%trre;








