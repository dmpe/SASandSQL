libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';
libname amum '/folders/myshortcuts/SASUniversityEdition/SAS_SQL_Procedure/';
filename trans 	'/folders/myshortcuts/SASUniversityEdition/SAS_SQL_Procedure/SQLDatasetsV9';

proc cimport library=amum infile=trans;
run;

/*
proc contents data=exam._all_ ;
run;
*/

/* Winter Exam 2015b */
Data exam;
	input epd $3. ag $6. mmd 9.;
	cards;
M11 49071 248766
M12 88214 32133338
M13 88201 321396
M14 44344 496411
M15 44383 494463336
;
Run;

/*
http://www2.sas.com/proceedings/sugi27/p071-27.pdf

Syntax 3 extracts values from all rows of the query result
and puts them into a (single) macro variable, separated by
the specified delimiter

Generated unique values list, selected by 5 vars.

the “INTO:” host-variable simply stored the first row of values

The  “ INTO:”   host-variable  can  also  be  used  to
generate lists of values.  These  lists  can  be
modified with modifiers.  For example, the  ‘SEPERATED  BY’  qualifier
indicates  how  this list  of  values  should  be  concatenated;

Another  modifier  is ‘QUOTE’,  which  flanks  each  value  with  double
quotes

*/
Proc sql ;
	select distinct epd, quote(epd), "'" !! (epd) !! "'", mmd, mmd format 9. 
		into :t1 separated by ", " , :t2 separated by ", " , :t3 separated by ", " , 
		:m1 separated by " " , :m2 separated by ", " from exam;
Quit;

%put &t1;
%put &t2;
%put &t3;
%put &m1;
%put &m2;

/* lists coordinates (i.e. everything from anum.wcoords)  of countries in europa.

The innermost query is evaluated first. It returns name of countries that are located on the
continent of Europe.

The outer subquery is evaluated next. It returns a subset of European countries from anum.rsrvs by checking if countries from anum.rsrvs are in the list
returned by the inner subquery. I.e. returns only those countries where countries form anum.rsrvs match those returned from the inner most query.

The WHERE clause in the outer query lists the coordinates of the cities that
exist in the anum.wcoords whose countries match the results of the outer subquery.

*/
Proc sql ;
	title 'Coordinates';
	select * from anum.wcoords where cntry in 
	(select cntry from anum.rsrvs a where a.cntry in 
	(select name from anum.cntries b where b.cntnnt='Europe'));
Quit;

proc sql ;
	title 'Donations Exceeding $90.00 in 2007';
	select Employee_ID, Recipients, sum(Qtr1, Qtr2, Qtr3, Qtr4) as Total from 
		orion.Employee_Donations where calculated Total > 90;
quit;

/*
Suppose that you want to find
the city nearest to each city in the amum.coords table. The query must first select a
city A, compute the distance from a city A to every other city, and finally select the city
with the minimum distance from city A.

The outer query joins the table to itself and determines the distance between the first city
A1 in table A and city B2 (the first city that is not equal to city A1) in Table B.

PROC SQL then runs the subquery. The subquery does another self-join and calculates the
minimum distance between city A1 and all other cities in the table other than city A1.

The outer query tests to see whether the distance between cities A1 and B2 is equal to
the minimum distance that was calculated by the subquery. If they are equal, then a row
that contains cities A1 and B2 with their coordinates and distance is written

http://support.sas.com/documentation/cdl/en/sqlproc/69049/HTML/default/viewer.htm#p1st65qbmqdks3n1mch4yfcctexi.htm
*/
Proc sql;* outobs=200;
	/* limit return to the first 200 rows*/
	select a.city format=$10., a.state, a.Latitude 'lat', a.Longitude 'long', 
		b.city format=$10., b.state, b.Latitude 'lat', b.Longitude 'long', 
		sqrt(((b.Latitude -a.Latitude )**2) + ((b.Longitude -a.Longitude )**2)) as dist format=6.1 
		from amum.uscitycoords a, amum.uscitycoords b 
		where a.city ne b.city and calculated dist=(
		select min(sqrt(((d.Latitude -c.Latitude )**2) + ((d.Longitude -c.Longitude )**2))) 
		from amum.uscitycoords c, amum.uscitycoords d 
		where c.city=a.city and c.state=a.state and d.city ne c.city) 
		
		order by a.city;
Quit;




/*
Please make a new similar program without using SQL.
http://support.sas.com/kb/24/652.html
*/
Proc sort data=amum.uscitycoords out=sample04a ;
	by city;
Run;

Proc sort data=amum.uscitycoords out=sample03b;
	by city;
Run;

Data sample04a;
	set sample04a(rename=(City = a_city
						 State= a_state
						 Latitude = a_lat
						 Longitude = a_long));
						 n=_n_;

Run;


data sample03b;
	set sample03b(rename=(City = b_city
						 State= b_state
						 Latitude = b_lat
						 Longitude = b_long));
						 n=_n_;
run;

/* cross join*/
data every_combination;
  set sample04a;
  do i=1 to k;
    set sample03b point=i nobs=k;
    	if a_city ne b_city;
    	distance = sqrt(((b_lat-a_lat)**2) + ((b_long-a_long)**2));
   		format distance best6.1;
    output;
  end;
run;

Proc sort data=every_combination;
	by b_city;
Run;






 
Proc sort data=amum.uscitycoords out=sample05c ;
	by city;
Run;

Proc sort data=amum.uscitycoords out=sample06d;
	by city;
Run;

Data sample05c;
	set sample05c(rename=(City = c_city
						 State= c_state
						 Latitude = c_lat
						 Longitude = c_long));
						 n=_n_;

Run;

data sample06d;
	set sample06d(rename=(City = d_city
						 State= d_state
						 Latitude = d_lat
						 Longitude = d_long));
						 n=_n_;
run;

/* cross join*/
data every_combination_2;* (keep=distance_min);
  set sample05c;
  do i=1 to k;
    set sample06d point=i nobs=k;
    	if d_city ne c_city;
    	distance_min = min(sqrt(((d_lat-c_lat)**2) + ((d_long-c_long)**2)));
   		format distance_min best6.1;
    output;
  end;
run;

Proc sort data=every_combination_2(drop=n);
	by d_city;
Run;


data eion2;
  set sample04a;
  do i=1 to k;
    set sample03b point=i nobs=k;
     
      distance = sqrt(((b_lat-a_lat)**2) + ((b_long-a_long)**2));
      format distance best6.1;
     	 *do p=1 to u;
    		set sample05c;* point=p nobs=u;
				do m=1 to w;
				   set sample06d point=m nobs=w;
	     			 if d_city ^= c_city AND c_city = a_city and c_state = a_state;
			    	 distance_min = min(sqrt(((d_lat-c_lat)**2) + ((d_long-c_long)**2)));
			   		 format distance_min best6.1;
						*if distance eq distance_min;

				   		output;
				*end;
end;
  end;
run;

data t3;
set every_combination;
  do i=1 to k;
    set every_combination_2 point=i nobs=k;
    	if b_city = c_city and b_state = c_state and distance = distance_min;
    	
    output;
  end;
run;

/*
c_city = a_city and c_state=a_state and distance = distance_min

	and calculated dist=(select min(sqrt(((d.Latitude -c.Latitude )**2) + ((d.Longitude -c.Longitude )**2))) 
		from amum.uscitycoords c, amum.uscitycoords d 
		where c.city=a.city and c.state=a.state and d.city ne c.city) 
	
*/



 
Data one;
input a $ b;
datalines;
a 1
b 2
c .
d 4
;
Run;

Data two;
input a $ b;
datalines;
a 1
b 2
c .
d 4
e .
;
Run;

Proc sql; 
select one.a 'One', one.b, two.a 'Two', two.b 
from one, two 
where one.b=two.b and one.b is not missing; 
Quit;

proc sort data=one;
by b a;
run;

proc sort data=two;
by b a;
run; 

/*
http://www.sascommunity.org/wiki/SQL_Allows_Multiple_Columns_with_Same_Name
In a DATA step, the program data vector does not allow two variables to have the same name. SQL is different. 
The namespace for a query can have multiple instances of the same column name. 
*/

data work.onTw;
merge one(in = l rename = (a=One)) two(in = p rename = (a=Two));
by b;
label a = "One" b= "Two";
sameB = b;
if b ne .;
keep One b Two sameB;
run;
/*
proc sort data=work.onTw nodupkey;
by a b;
run;
proc print data=work.ontw noobs;
run;
*/


/*
make a new similar program without using arrays
*/

Data newX(keep=id x:); 
set score;
array x{5} a1-a5; 
do u = 1 to 5;
x{u}=input(substr(string,u,1),1.); 
end;
Run;

Data newX(keep=id x:); 
set score;
x1=input(substr(string,1,1),1.); 
x2=input(substr(string,2,1),1.); 
x3=input(substr(string,3,1),1.); 
x4=input(substr(string,4,1),1.); 
x5=input(substr(string,5,1),1.); 
end;
Run;


/* into SQL
http://www2.sas.com/proceedings/sugi31/242-31.pdf
http://www2.sas.com/proceedings/sugi29/269-29.pdf
*/


Data all_of_them;
set one (drop=sex)
two (keep=idnum dob salary rename=(idnum=id)) 
three (keep=id dob salary);
where dob le '01JAN60'd and dob is not missing and salary ge 250000);
format dob MMDDYY8.;
Run;

proc sql;
create table all_of_them as
select *,
from one(drop=sex),
Outer union corresponding
SELECT idnum, dob as MMDDYY8., salary rename=(idnum=id)
from two
OUTER UNION corresponding
SELECT id, dob, salary
FROM three 
where dob le '01JAN60'd and dob is not missing and salary ge 250000;
quit;

/*


SLOVNI ULOHY 


The data sets New01 and New02 need some cleaning up. First, remove all duplicate observations 
(if any), and sort the data by Idnumber01. Next remove an observation if one or more of the 
variables have a missing value. Merge the two data sets (without SQL) by Idnumber01. Finally, 
remove the variable Keytype. Call the new data set Exam1.

*/


/*
Merge Key02 with Key03 by Idnumber01. Make sure that the data sets do not contain duplicate 
observations. Call this new data set Exam2. Merge Exam2 with Employee and Expenditures. Once more,
make sure that the data sets do not contain duplicate observations. Call this new data set Exam2_1.
Again, remember to make comments at each step (i.e. at each program line).

https://communities.sas.com/t5/General-SAS-Programming/6-ways-of-removing-duplicate/td-p/124984
*/

proc sort data=exam.key02 NODUPLICATES;
by Idnumber01;
run;
proc sort data=exam.key03 NODUPLICATES;
by Idnumber01;
run;

proc sql;
create table Exam2 as
select distinct *
from exam.key02 as d, exam.key03 as t
where d.Idnumber01 = t.Idnumber01;
quit;

proc sql;
create table Exam2_1 as
select distinct *
from Exam2 as d, exam.employee as t, exam.expenditures as k
where d.Idnumber01 = t.Idnumber01 and d.Idnumber01 = k.Idnumber01;
quit;

proc sort data=exam2_1 noduprecs;
      by _all_ ; Run;


/* 
Please make a new similar program using SQL. Again remember to make comments.
Right join pres xsales(inxsales), kdyby na xparts tak left join
*/

Proc sort data=xparts; by p_no;
Run;
Proc sort data=xsales; by p_no;
Run;
Data nxsales;
merge xparts xsales(in=inxsales); 
by p_no;
if inxsales; total=quantity*price;
keep id total;

Run;

proc sql;
create table nxsales as 
select id, quanitty*price as total 
from xparts right join xsales
where xparts.p_no = xsales.p_no
order by p_no;


Proc sort data=newsales; by id;
Run;

Data three;
merge empl(drop=dob) nxsales(in=new); by id;
if new;
Run;

proc sql;
create table three as
select *
from empl(drop=dob) as t right join nxsales as y
where t.id=y.id
order by id;
quit;


Proc means sum data=three maxdec=0; title 'Sales totals.';
class id; var total;
Run;

proc sql;
title 'Sales totals.';
select sum(total) format=10.0
from three
group by id;
quit;

/*
Remove duplicate observations in the Exam data set after having deleted the variable Deposit. 
Delete observations if the variable Position has an 'l' at position 8. 
Call this new data set Exam3. 
Make three new data sets in one “data statement” where you use this result. 
If Keytype is less than equal 3 then the name of the output file should be Exam3_small. 
If Keytype is higher than 3 and less than equal 10 then the name of the output file should be Exam3_big. 
Otherwise, the name should be Exam3_missing.
Hint: Use “When”.
Again, remember to make comments at each step (i.e. at each program line)
*/

proc sql;
create table Exam3 as
select distinct *
from exam.exam(drop=Deposit);
quit;

data Exam3(drop = test);
set Exam3;
	test =find(position,"l");
	if test = 8 then delete;	
run;


data Exam3_small Exam3_big Exam3_missing;
set exam3;
 if Keytype le 3 and Keytype not = . then output Exam3_small;
 else if Keytype gt 3 then output Exam3_big;
 else output Exam3_missing;
run;

/*
Use the data set X2012_1_6cleaned10 to calculate the total sales in terms of sumLillebuffet for each weekday. 
Consider only days where total sales of sumLillebuffet is greater than the sales of 1.9*sumStorBuffet.
 Call the new data set: exam4.
Again, remember to make comments at each step (i.e. at each program line).
*/
proc sql;
create table exam4_1 as
select *
from exam.x2012_1_6cleaned10
having sumLillebuffet gt 1.9*sumStorBuffet;
quit;

proc sql;
create table exam4 as
select weekday, sum(sumLillebuffet) as total_sales_sumLillebuffet
from exam4_1 
group by Weekday;
quit;


/*
Make a random sample from X201204 of 500 distinct employees. 
Make sure that these are not from Afdeling=”AgroTech A/S” and not part of the data set Sample1, Sample2, Sample3. 
Moreover, keep all observations from X201204 for these 500 distinct employees. 
Furthermore, exemplify the use of a macro variable in a “Where” statement. 
During execution this macro is supposed to generate a subset of the data set. 
Call the new data set Exam5.
Again, remember to make comments at each step (i.e. at each program line).
*/

data t9;
set exam.sample3 exam.sample2 exam.sample1;
run;

/*
data _null_;
set work.t9;
call symput(maxN,);
run;
*/
 
proc sql;
create table r1 as
select *
from exam.X201204 x2 left join t9 t9 on x2.Initialer = t9.initials
where t9.initials is null and dato is not missing and Afdeling ne "AgroTech A/S" ;
quit;
 

proc surveyselect data=r1
   method=srs n=500 out=SampleSRS;
run;

/*
Make a macro with conditional logic. This macro should create a directory/folder if it doesn’t exist already. 
On the other hand, if it does exist, it should put a message to the log.
http://www.sas.com/offices/europe/uk/support/sas-hints-tips/ht1_mar04.html
XCMD will never work https://marc.info/?l=sas-l&m=129106829117885
https://communities.sas.com/t5/SAS-Procedures/How-to-enable-XCMD-in-SAS-University-Edition/td-p/265868
http://support.sas.com/software/products/university-edition/faq/limitations.htm
*/
proc options option=xcmd; run;
proc options option=xwait; run;

%macro chk_dir(dir=) ;
   %local rc fileref ;
   %let rc = %sysfunc(filename(fileref,&dir)) ;
   %if %sysfunc(fexist(&fileref))  %then
      %put NOTE: The directory "&dir" exists ;
   %else
     %do ;
         %sysexec md &dir ;
         %put %sysfunc(sysmsg()) The directory has been created. ;
   %end ;
   %let rc=%sysfunc(filename(fileref)) ;
%mend chk_dir ;

%chk_dir(dir=/folders/myshortcuts/SASUniversityEdition/EXAM) ;    %*   <==  your directory specification goes here ;
%chk_dir(dir=\folders\myshortcuts\SASUniversityEdition\EXAM\sascode\)  ; 
