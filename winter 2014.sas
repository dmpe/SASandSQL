libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';
libname amum '/folders/myshortcuts/SASUniversityEdition/SAS_SQL_Procedure/';

/*
http://support.sas.com/documentation/cdl/en/proc/65145/HTML/default/viewer.htm#n1qnc9bddfvhzqn105kqitnf29cp.htm

The proc means procedure makes available data summarization tools to 
calculate descriptive statistics. 

sum is statistical keywords that specify which statistics to compute 
and the order to display them in the output.  
 Noprint actually tells us no to print these statistics. 
 
 class ptid tgid specifies variables are used to group the data.  
  
The var statement identifies the analysis variables and specifies
their order in the results - here we only use "amountpaid".

Nwat specifies that the output data set contain only statistics 
for the observations with the highest _TYPE_ and _WAY_ values.

output - var freq will be renamed to no and drop names that begin with underscore and t
final output will also contain totamount variable that has sum statistics
http://support.sas.com/documentation/cdl/en/proc/61895/HTML/default/viewer.htm#a000146734.htm
*/


proc means data mstr01 sum noprint nway;
class ptid tgid;
var amountpaid;
output out=mstr02(rename=(_freq_=no) drop=_t:) sum=totamount;
run;

proc print data=mstr02;
title "total amount paid";
run;


/*
http://www2.sas.com/proceedings/sugi27/p071-27.pdf

Syntax extracts values from all rows of the query result
and puts them into a (single) macro variable, separated by
the specified delimiter.
this result will not be printed but with put statement it will print
that macro variable to which we stored the values
*/
proc sql noprint;
select distinct tgid 
into: tlist separated by ' ' from mstr01;
quit;
%put &tlist;


proc sql;
create table pull as 
select a.ptnt, a.date format=date7. as date01, a.pls, b.md, b.dss, b.mt format=4.1
from vlts a full join dsng b on /*
includes all rows from all contributing tables. 
Where the join criteria are satisfied
on all contributing tables, the result set will 
contain the values from all tables
*/
a.ptnt= b.ptnt and a.date01=b.date02
order by ptnt , date01;
quit;


proc sort data=vlts;
by ptnt date01;
run;
proc sort data=dsng;
by ptnt date02;
run;

data x;
merge vlts(in=r keep = ptnt date pls rename=(date = date01)) 
dsng(in=w keep= md dss mt rename = (date02 = date01));
by ptnt date01;
format date01 date7. mt 4.1;
run;

proc sort data=x;
by ptnt date01;
run;


%macro v(a=xpnss, varlist=_all_);
proc sql noprint; /* does not print results of the query, supressed them */
select (mean(rmry), put(today(), mmddyy10.), month(today()) 
/* select 3 variables and put them into 3 macro variables
first is means of rmry, 
then we take todays day and convert it to the specified format here date of monthdayyear
and lastly calculate month of today's date.
*/
into :meanx, :dt, :mn 
from &ddd; /* unintialized macro variable , which will not be resolved unless it
is defined semewhere */
quit;
proc print data=&ddd;
footnote "on &dt";
var &varlist;
%if &mn=10 or &mn=11 or &mon=12 %then %do;
title "princes in the %upcase(&ddd) data set";
where rmrt<= &meanx;
%end;
%else %do; title "all info in the %upcase(&DDD) data set";
%end;
run;
%mend;

/*
http://www.cpc.unc.edu/research/tools/data_analysis/sastopics/arrays
cannot be done without arrays becuse lenght of nvr is variable
*/

options mprint;
data xxx.data001(drop =i);
set xxx.data001;
array nvr{*} _numeric_; /*star = variable lenght, counting number of numeric vars*/
do i = 1 to dim(nvr); /*
start from one and go over all numeric variables in the dataset
all numeric variables on the observation */
if nvr{i} in (98 99 0) then nvr{i} = .;
/* if nvr found numbers 98, 99 or 0 then replace themn with missing value*/
end;
run;

data xxx.data001(drop =i);
set xxx.data001;

do i = 1 to dim(nvr); 
if nvr1 in (98 99 0) then nvr1 = .;
end;
run;

 /* without sql
 http://support.sas.com/documentation/cdl/en/sqlproc/69049/HTML/default/viewer.htm#n0a85s0ijz65irn1h3jtariooea5.htm
  */
 proc sql;
 create table tst as
 select ptnt, case ((ptnt/2=int(ptnt/2))+(ptnt=.) 
 when 1 then 'xxx' 
 when 0 then 'yyy' else 'problems' end as ds lenth 8
 from vtls
 order by ptnt; 
quit;

/* equvalent to */
 proc sql;
 create table tst as
 select ptnt, case 
 when ((ptnt/2=int(ptnt/2))+(ptnt=.) eq 1 then 'xxx' 
 when ((ptnt/2=int(ptnt/2))+(ptnt=.) eq 0 then 'yyy' 
 else 'problems' end as ds lenth 8
 from vtls
 order by ptnt; 
quit;



data tst;
set vtls;
length ds 8; /* set lenght of ds variable to 8*/
if ((ptnt/2=int(ptnt/2))+(ptnt=.) eq 1 then ds = 'xxx'; /* makes no sense*/
else if ((ptnt/2=int(ptnt/2))+(ptnt=.) eq 0 then ds = 'yyy';
else ds = 'problems';
run;

proc sort data=tst;
by ptnt; 
run;

/* without arrays */
data l_n(keep= subject vst sdm);
set l_non(keep=subject vst:); 
by subject; /* group by subject */
array vsts{16} vst1-vst16;
do i = 1 to 16;
sdm = vsts{i};
output l_n;
end;
run;

data l_n(keep= subject vst sdm);
set l_non(keep=subject vst:); 
by subject; /* group by subject */
sdm = vsts1;
output l_n;
sdm = vsts2;
output l_n;
sdm = vsts3;
output l_n;
sdm = vsts4;
output l_n;
.....
run;


/* 3.1 */
data t2;
set exam.x2012_1_6cleaned10;
if daytype not in ("Normal day", "Semi holiday");
run;

proc sort data=t2 out=t1 nodup;
by day;
run;

data r1;
set t2;
	if sumtotprice eq sumprice then output;
run;

data exam31;
set r1;
	if sumtotprice gt mean(sumtotprice) then output;
run;

/* 3.2*/ 
data exam32;
set exam.exam;
 if cmiss(of _numeric_) then delete;
 if (find(position ,'Level II', "i")>0) and age le 58 then delete;
run;

/* 3.3*/
proc sql;
create table exam33 as
select distinct *
from exam.employee ee inner join exam.expenditures ex on
ee.idnumber01 = ex.idnumber01
where position is not missing;
quit;


/* 3.4*/ 
proc sql;
create table exam34 as 
select distinct weekday, sum(sumLillebuffet) as sum_LB
from exam.x2012_1_6cleaned10
group by weekday
having sum(sumLillebuffet) gt 2*sumstorbuffet;
quit;

/*3.5
http://stackoverflow.com/questions/28864703/how-to-find-the-length-of-a-numerical-variable-using-proc-sql*/

data exp;
set exam.expenditures;
length idnumber01_newvar $ 10.;
if length(put(idnumber01,32. -l)) = 6 then idnumber01_newvar = "C0"||put(idnumber01, 6.) ;
else if length(put(idnumber01,32. -l)) = 7 then idnumber01_newvar = "C"||put(idnumber01,7.) ;
else idnumber01_newvar = "do nothing";
*idnumber01_newvar = put(idnumber01_newvar,z7.);
if missing(cats(of _all_)) then delete;
run;


/* 3.6 
http://www.lexjansen.com/nesug/nesug07/cc/cc27.pdf
*/
options mprint;
%let datasets = sample1 sample2 sample3 sample4 sample5 sample6;

%macro nasme(n_of_emp = 5, num_datasets = 6);
%local i;

%do i= 1 %to &num_datasets;
	proc surveyselect data=exam.%SCAN(&datasets ,&I)
	out=exam36_exam_%SCAN(&datasets ,&I)
	   seed=12345 method=srs sampsize=&n_of_emp;
	   id initials;
	Run;
%end;

%mend;


%nasme;











