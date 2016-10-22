libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';




/*  inencoding=asciiany;
OK :) */
proc sql ;
	create table te as select initials, time, weekday, date, salesunit, prodcat, 
		subsidy, price, pricenew, totprice, department from exam.january2013new;
quit;

Proc sql ;
	create table X2012_1_6cleaned09 as select a.*, b.* 
	from X2012_1_6cleaned08 as a left join 
	X2012_1_6cleaned_summary_a as b on a.day=b.day;
Quit;

Data bbb.X2012_1_6cleaned10(drop=i);
	set X2012_1_6cleaned09;
	array x(*) _numeric_; /* dont explain array, star = variable lenght, counting number of numeric vars */

	do i=1 to dim(x);
		/* changes all missing variables (cells) to 0 */
		if x(i)=. then x(i)=0;
	end;
Run;

/*
http://www2.sas.com/proceedings/sugi30/037-30.pdf
The NODUPKEY option eliminates observations that are exactly the same across the
BY variables.
*/
Data exam.sample5;
	set exam.sample1 exam.sample2 exam.sample3 exam.sample4;
Run;

Proc sort data=exam.sample5 out=test1 noduprecs;
	/*Checks for and eliminates duplicate observations.
	The NODUP option in the SORT  procedure  eliminates observations that are exactly the  same across  all  variables. */
	by initials;
Run;

Proc sort data=test1 out=test2 nodupkey;
	/* Checks for and eliminates observations with duplicate BY values. */
	by initials;
Run;

/*
Merge (not sql) the test2 data set by initials with the four data sets, exam.sample1-4.
I only want output if at least two of the five data sets have contributed to the construction
of this new data set. 

Make contingency tables of the four sample data sets.
Use proc freq statements
*/
proc sort data=exam.sample1 out=exam.sample1;
	by initials;
Run;

proc sort data=exam.sample2 out=exam.sample2;
	by initials;
Run;

proc sort data=exam.sample3 out=exam.sample3;
	by initials;
Run;

proc sort data=exam.sample4 out=exam.sample4 nodupkey;
	by initials;
Run;

data testme;
	merge test2(in=a) exam.sample1(in=b) exam.sample2(in=c) exam.sample3(in=d) 
		exam.sample4(in=e);
	by initials;
	test2 = 0;
	sample1 = 0; sample2=0; sample3=0;
	sample4 = 0; match = 0;
	if a then test = 1;
	if b then sample1 = 1;
	if c then sample2 = 1;
	if d then sample3 = 1;
	if e then sample4 = 1;
	match = sum(test2, sample1, sample2, sample3, sample4, sample5);
	if match gt 2 then output;
run;

proc freq data=testme;
	tables exam.sample3 exam.sample4 /nocum;
	tables exam.sample1 * exam.sample3 /nocum;
run;

proc freq data=exam.sample3;
run;



/* NOT in sql */
Proc sql ;
	create table ax.t as select kkk.custno, kkk.deal, qq.step 
	from (select kk.*, q.id from	
		(select k.k_no, k.custno, b.mother_k, b.deal 
		from ax.kiskunde k, ax.bonuskis b where k.k_no=b.k_no) kk, ax.comp q where kk.mother_k=q.k_no) kkk ,
		 ax.bdeal qq where kkk.id=qq.primcomp and 
		kkk.deal=qq.deal and kkk.deal in ('ERBO', 'ERB2', 'SKFR', 'SKBO');
	;
Quit;

/*select k.k_no, k.custno, b.mother_k, b.deal from ax.kiskunde k, ax.bonuskis b where k.k_no=b.k_no*/
/* select kk.*, q.id from inner_most kk, ax.comp q where kk.mother_k=q.k_no*/

/* Must be sorted */
proc sort data=ax.kiskunde(keep=k_no custno) out=ax.kiskunde;
by k_no;
run;

proc sort data=ax.bonuskis(keep=k_no mother deal) out=ax.bonuskis;
by k_no;
run;

data inner_most;
merge ax.kiskunde(in=a) ax.bonuskis(in=b);
by k_no;
if a and b then output;
run;

/* must be sorted again, cannot be assumed */

proc sort data=xxx out=xxx;
by k_no;
run;

proc sort data=xxx out=xx;
by k_no;
run;

data second_innerMost;
	merge innermost(in=w rename=(mother_k=k_no) ax.comp(in=q keep = id);
by k_no;
if w and q then output;
run;

/* sort again */

data ax.t;
merge second_innerMost(in=m keep=custno deal) 
	  ax.bdeal(id=i keep=step rename=(primcomp =id));
by id deal;
if i and m and deal in ('ERBO', 'ERB2', 'SKFR', 'SKBO') then output;

 
 /*
 Explain
 */
 
 
Data until;
rate=0.0357;
total=100; /* loop 100 */
do year=1 to 100 until (total gt 200);
total=total+rate*total; /* start at 100 and add 3.7% and cont. unless stop when reached 200 */
output; 
end;
format total dollar10.2;
Run;

 /* make in sql */
Data HI FO telecom;
set kdemo(keep=k_no kisname hmob segm: mailstop employee);
if upcase(segment1)='TELECOM' and employee lt 100
then delete;
if k_no = '0202.105482' then delete;
if mailstop = 'T' then delete;
select;
	when (upcase(segment1)='FO') output FO;
	when (upcase(segment1)='HI') output HI;
	otherwise output telecom;
end;
Run;

/*
New exercise: Make your own contribution, especially in terms of “options”. Make comments!

Write Macros with conditional logic:
E.g. make different regressions depending on some condition(s).
Apply different statistical methods in one macro.
 
When faced with a new dataset, the Macro should among other things make descriptive 
analyses of the numerical variables of this data set.
*/

%macro regression (yvar=sumtotprice,xvar=sumCacaomaelk sumCecil,fil_eII=exam.X2012_1_6cleaned10);
Proc reg data=&fil_eII;
title1 'BLABLA';
model &yvar=&xvar/ r;
output out=stats p=predict r=resid;
Run;

Proc reg data=&fil_eII;
title1 'BLABLA';
model &yvar=&xvar/ all;
output out=stats p=predict r=resid;
Run;

%mend regression;
%regression(xvar=sumCacaomaelk sumbolle)
title


/* comments, everything goes into log */
options mcompilenote=all;
%macro time; /* resolves time function to x plus adds format */
%put The current time is %sysfunc(time(),timeAMPM.).;
%mend time;
%time

/*
Make comments to the following code. Redo newtest19_notsql without sql and without merging.
with set ?
*/
 
%let sumtotalvar;

Proc means data=exam.january2013new sum noprint;
output out=summary sum=totprice;
var price; 
Run;

data _null_;
set summary end=final; /* final to 1 when add the bottom of file */
totp+totprice;
if final then call symput('sumtotalvar', totp);
run; 

Data newtest19_notsql(keep=initials department pricepct); 
merge exam.january2013new summary(keep=totprice);
retain total;
if _n_ = 1 then total=totprice;
pricepct=price/total;
format pricepct percent8.4;
Run;

/* very amateristic*/

data ssss;
	set exam.january2013new ;
pricepct=price/&sumtotalvar;
format pricepct percent8.4;
Run;



/*
Let’s say we have a series of data sets: data1-data200. 
Make 200 Proc means – one for each of the 200 data sets. 

The data sets contains the variable sc. We would like to find 
the average of this variable in each of the data sets. Make relevant labels as well.

http://stackoverflow.com/questions/17984153/is-it-possible-to-loop-over-sas-datasets
*/

 proc contents data= exam._all_ noprint out= a_data_set; 
 run;
 
 data a_data_set_a(keep=memname) ;
 set a_data_set(firstobs=1 obs=25); 
 run;
 
 proc sort data=a_data_set_a nodupkey out= a_data_set_b ;
  by memname;
run ;

proc sql; 
select cats('%call_proc_means_macro(dataset=exam.',memname,')') into :stufflist separated by ' '
from a_data_set_b;
quit; 
 

%macro call_proc_means_macro(dataset=&a_data_set_b );
Proc means data=&dataset;
Run;
%mend call_proc_means_macro;

&stufflist;

%macro asd;
%do i = 1 %to 200;
proc means data= data&i;
run;
%mend;




/*

*/

Proc format;
value rfmt 1000-2000 = “NXE”
2001-3000 = “NXW”
3001-4000 = “SXE”
4001-5000 = “SXW”;
Run;
Data nw;
set indata;
region = put(cty, rfmt.); /* put in regions cty formated as rfmt */
Run;
Data sw;
set indata;
if put(cty, rfmt.) = “SXW”; /* create a new var based on of cty;
prints only those which are SXW*/
Run;


/*
48 rows, fill data from 13 to 2 in column c_tot
*/
 
Data test;
do centr = 1 to 8; /*-> 8*/
	do treat = 1 to 0 by -1; /* 2*/
		do respn = 3 to 1 by -1; /*3*/
			input c_tot @@;
			output;
		end;
	end;
end;

datalines;
13 7 6 1 1 10 2 5 10 2 2 1
11 23 7 2 8 2 7 11 8 0 3 2
15 3 5 1 1 5 13 5 5 4 0 1
7 4 13 1 1 11 15 9 2 3 2 2
Run;
/*
http://www2.sas.com/proceedings/sugi28/066-28.pdf
The  following  DATA  step  converts  numeric
values with a yymmdd format to SAS date values. 

The YYMMDD6. informat cannot accept values with fewer
than 5 characters, so for values of date1 in the year 2000,
such as the following, sasdate1 is a missing value

To  fix  the  problem,  use  the  Z6.  format  instead  of  the  6.
format,  because Z6. generates leading zeros.  For example,
for 101 (January 1, 2000), 
*/


Data _null_;
x=120231 ;
xch = put(x,z6.) ; /* convert numeric date to chars date -6z is unnecessary here*/
xd = input (xch, mmddyy6.) ; /* take char and convert to data format*/
format xd date7. ; /* otherwise to numberic of -10257 */
put _all_ ;
Run; 


/*Explain what happens here. Make comments. Make a non-sql version of this code.*/
 
Proc sql noprint;
insert into vit values(11 '21SEP2011'd 22 2 1);
insert into vit set pt=11, date='21SEP2011'd, pls=21, pl=2, p=1;
Quit;


data vit;
input pt date date11. pls pl p;
format date date11.;
datalines;
11 21SEP2011 22 2 1
11 21SEP2011 22 2 1
;
run;





















