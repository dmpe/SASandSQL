libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';
libname amum '/folders/myshortcuts/SASUniversityEdition/SAS_SQL_Procedure/';

Data Investing;
	do while(cap>=50000);
		cap+3000;
		cap+cap*0.10;
		year01+1;
	end;
	format cap dollar10.2;
Run;


/*
Explain what happens and make a new similar program using an array.
*/
Data newreport;
	set bbb.new;
	monday=5*(monday-32)/9;
	tuesday=5*(tuesday-32)/9;
	wednesday=5*(wednesday-32)/9;
	thursday=5*(thursday-32)/9;
	friday=5*(friday-32)/9;
	saturday=5*(saturday-32)/9;
	sunday=5*(sunday-32)/9;
Run;

data new_ar;
	set bbb.new;
	array day{7} monday tuesday wednesday thursday friday saturday sunday;

	do i=1 until 7;
		day{i}=5*(day{i}-32)/9;
	end;
run;


/*
comments
*/
Data d1;
	b0=-1;
	b1=1.5;
	b2=0.5;
	mse=8;
	do x1=1 to 2;
		/* -> 2*/
		do x2=1 to 2;
			do obs=1 to 500;
				y=b0 + b1*x1 + b2*x2 + normal(4452)*mse;
				output;
			end;
		end;
	end;
Run;

/*

*/

%Macro ex_01;
	Data temp&I;
		set SAS.DataSET;
		where ccode="&&mcvr&I";
	Run;

%Mend ex_01;

Data _null_;
	set bts.data;
	call symput('mcvr' || left(trim(_N_)) , ccode);
	call symput('totobs' , _N_);
Run;

%Macro ch_lo;
	%do I=1 %to &totobs;
		%ex_01;
	%end;
%Mend ch_lo;

%ch_lo;

/*
comments
*/

Proc sql noprint; create table AAA as
select 1 as var1, pt, sev, aa, alat, srq, act, case sev when 'mi' then 3
when 'mo' then 4
when 'se' then 5
else . end as var2, case alat when 'no' then 8
when 'po' then 9
when 'pr' then 10
when 'de' then 11
else . end as var3,
case when act ='not' then 12 else . end as var4, case when srq='yes' then 13 else . end as var5
from cod.aa_c
where aa ne ' ' and pt in (select distinct pt from s.aa where aaouq='Y' and pt in
(select pt from d.pop where slg=1));

Quit;




/*
Explain what happens and make a new similar program using SQL.
*/


Proc sort data=hall.rd; 
by workshop gender;
Run;

Proc sort data=hall.mg; 
by workshop gender;
Run;

Data hall.rdata2;
merge hall.rd(in=a) hall.mg(in=b); 
by workshop gender;
if b;
totsale = sum (sal89,sal95);
format sal89 sal95 totsale dollar12.; 
drop year;
Run;


proc sql;
create table hall.rdata2(drop=year) as
select sal89 dollar12., sal95 dollar12., totsale dollar12., sum(sal89,sal95) as totsale
from hall.rd r right join hall.mg m on r.workshop =m.workshop  and r.gender = m.gender
order by workshop gender;
quit;
/* works too
proc sql;
create table hall.rdata2 as
select *
from hall.rdata2(drop=year);
quit;
*/

/* Explain what happens and make a 
new similar program using SQL. Left outer join*/

Data bts.transportation;
merge bts.transportation(where=(year(date)=-1 and month(date)=1) in=j) stb.yid(in=jj);
by gasoline;
if j and not jj;
Run;


/*
Please make a new similar program using SQL
NOT POSSIBLE TO TEST

*/
Proc sort data=order; 
by cstime;
where today() - d_day lt 365; 
Run;

proc sql;
create table order as
select *
from order 
where today()- d_day lt 365
order by cstime;
quit;

Proc sort data=cust; 
by cstime;
Run;

data merg(keep=cstime tot_ord); 
merge order(in=o) cust(in=c);
by cstime; 
if o and c;
/* here is issue - dont know */
if first.cstime then tot_ord=0; 
tot_ord+ordert;
put _all_;
if last.cstime;

Run;

Proc print Data=merg; title 'Merg';
Run;


proc sql;
title 'Merg';
create table merg as
select cstime, sum(tot_ord+ordert) as t
from order o inner join cust c on o.cstime = c.cstime
group by cstime;
quit;
 
 
 /* SLOVNI ULOHY 
 The data set X2012_1_6cleaned10 needs some cleaning up. 
 First, remove all duplicate observations (if any), and sort the data by day. 
 Next remove an observation if Daytype is not equal to “Normal day” or “Semi holiday”.
  Keep only observations where Sumprice is greater than the average Sumprice. 
  Call the new data set Exam001. 
  Again, remember to make comments at each step (i.e. 
  at each program line).
 
 */
 
proc sql;
create table Exam001 as
select distinct *
from exam.x2012_1_6cleaned10 t
where t.daytype in("Normal day", "Semi holiday")
order by day;
quit;


proc sql;
create table Exam002 as
select *
from Exam001  t
having t.sumprice gt avg(sumprice);
quit; 


/*
Merge Key01 with Key02 and Expenditures by Idnumber01. 
Make sure that the data sets do not contain duplicate 
observations. Make sure that the data sets do not contain 
missing values. Call this new data set Exam002. Merge 
Exam002 with Employee where Employee is not equal to 
“Manger”. Once more, make sure that the data sets do 
not contain duplicate observations. Call this new data
 set Exam002_1.
*/

proc sql;
create table ar as
select distinct *
from exam.key01 f inner join exam.key02 d on
f.Idnumber01 = d.Idnumber01; 
quit;

proc sql;
create table ar2 as
select distinct  *
from ar t inner join exam.expenditures x on t.Idnumber01 = x.Idnumber01;
quit;

data Exam002;
set ar2;
 if cmiss(of _all_) then delete;
run;


proc sql;
create table Exam002_1 as
select distinct *
from exam002 c inner join exam.employee g on c.Idnumber01 = g.Idnumber01
where position NOT LIKE "%Manger%";
quit;


/*
Remove observations in the X2012_1_6cleaned10 data set where SumCecil is
 positive after having deleted the variable Weekday. Call this new data 
 set Exam003. Make three new data sets in one “data” statement. If Daytype
  is equal to “Holiday/weekend” then the name of the output file should be
   Exam003_weekend. If Daytype is equal to “Normal day” then the name of 
   the output file should be Exam003_normal. Otherwise, the name should be
    Exam003_semi. Hint: Use “When”.
*/
proc sql;
create table exam003(drop=Weekday) as
select *
from exam.X2012_1_6cleaned10
where sumCecil le 0;
quit;

data Exam003_weekend Exam003_normal Exam003_semi;
set exam003;
if daytype = "Holiday/weekend" then output Exam003_weekend;
else if daytype = "Normal day" then output Exam003_normal;
else output Exam003_normal;
run;


data Exam003_weekend Exam003_normal Exam003_semi;
set exam003;
	
    select (daytype);
	  when ("Holiday/weekend") output Exam003_weekend;
	  when ("Normal day") output Exam003_normal;
	  otherwise output Exam003_normal;
    end;
run;


/*
Use the data set X2012_1_6cleaned10. Make a Proc Format where you assign 
a label to the day of the week (using the variable Day) depending on the 
size of the variable SumRABAT. Use seven labels. The one with the lowest 
value (highest absolute value) could get the label “Very high subsidy” etc.
*/

proc format;
   value tsadsadest -20000 -< -10000  = 'Very high subsidy'
                   -10000 -< -9000 = 'a lot high subsidy' 
                  -9000 -< -8000= 'high subsidy'
                  -8000 -< -5000= 'moderate high subsidy'
                  -5000 -< -3000= 'a bit higher subsidy'
                  -3000 -< 0= 'low subsidy';
run;

data t1;
set exam.X2012_1_6cleaned10;
format SumRABAT tsadsadest.;
run;

/*
Use the data set X2012_1_6cleaned10 in a “Proc Summary” statement where you
 have to make a summary of all the numerical variables for each day of the week.
  Order the data by day of the week, SumRABAT, and SumMaelk. Make titles and 
  subtitles. Output data set should be called Exam005.
*/
Proc Summary data=exam.x2012_1_6cleaned10 print;
  class day;
 var _numeric_;
 OUTPUT OUT = Exam005;
run;

/*
Make a random sample of 200 distinct employees (Initialer) from X201201, 
X201202, X201203, X201204, X201205, and X201206. Call the new data set
Exam006. 
Finally for each of the 200 employees (“Initialer”) and each 
product (“Vare”) calculate the total sum of “Price_total” for all six files.
*/

proc sql;
create table E8 as
select distinct c.Initialer,
from exam.X201201 c inner join exam.X201202 g on c.Initialer= g.Initialer;
quit;
proc sql;
create table e9 as
select distinct g.Initialer
from e8 g inner join exam.X201203 a on g.Initialer = a.Initialer;
quit;
proc sql;
create table e10 as
select distinct g.Initialer
from e9 g inner join exam.X201204 a on g.Initialer = a.Initialer;
quit;
proc sql;
create table e11 as
select distinct g.Initialer
from e10 g inner join exam.X201205 a on g.Initialer = a.Initialer;
quit;
proc sql;
create table exam006 as
select distinct g.Initialer
from e11 g inner join exam.X201206 a on g.Initialer = a.Initialer;
quit;

proc surveyselect data=exam006 method=srs n=200 out=SampleSRS;
run;





