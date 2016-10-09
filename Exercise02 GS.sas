
/*Problem 1*/

libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';
/*  inencoding=asciiany; */

Data jan_test(keep=price var:);
 set exam.january2013new;
    array z(3) var1-var3;
     array y(3) _temporary_ (2, 6, 16);
      array x(3) var1-var3;
      
       do i=1 to 3;
        z(i)=price;
         if z(i)=y(i) then z(i)=.;
       end;   
      
        do j=1 to dim(x);
         if x(j)=. then x(j)=-99999999;
        end;
        ;
Run;

/*Problem 2*/


Data xxX;
 mailcode="X;Stop;W;N;I"; A=1; output;
  mailcode="Y;Stop;W;I"; A=2; output;
   mailcode="X;Stop;N;W;I"; A=3; output;
    mailcode="X;Stop;W;NO;I"; A=4; output;
     mailcode="X;Stop;W;n;I"; A=5; output;
    mailcode="X;Stop;W;CnC;I"; A=6; output;
   mailcode="X;Stop;W;cNc;I"; A=7; output;
  mailcode="N;Stop;W;N;I"; A=8; output;
Run;

Data test;
 set xxx;
  i=1;
   strsearch=scan(mailcode, i, ';'); /* first time see ; */
    do while (strsearch >''); /* as long as there is something*/
      if strsearch ='N' then do; /* just interested in this letter */
       strsearch ='';
       output;
      end;
     else do;
      i=i+1;
      strsearch =scan(mailcode, i, ';'); /* jump to the next one*/
     end;
    end;
Run; /*scanning word after ; for N */


/*Problem 3*/


Proc format;
value WeekdayFM
 1 = 'SUNDAY'
  2 = 'MONDAY'
   3 = 'TUESDAY'
    4 = 'WEDNESDAY'
     5 = 'THURSDAY'
      6 = 'FRIDAY'
       7 = 'SATURDAY';
Run;

Data jan_test02(keep=x weekday date);
 set exam.january2013new;
  x=weekday(date);
   format x weekdayFM.;
Run;


/* Problem 4) */
/* Are employees that return the bottles and get  */
/* deposits back higher spenders in the canteen */
/* compared to the rest of the employees? USE SQL. */
/* exam question */

Proc sql;
 create table january2013new01 as 
  select 
    case 
     when initials in 
                   (select distinct(initials) 
                     from exam.january2013new
					  where upcase(product) = 'PANT RETUR') then 1
					  else 0
    end as deposit,
     initials, sum(totprice) as sumtot    
      from exam.january2013new
       group by initials
    ;
Quit;

Proc sql; 
 create table january2013new01a as 
  select avg(sumtot) as ssumtot, deposit 
   from january2013new01 
    group by deposit
    ;
Quit;

/* Spend 5 minutes: 	
   Explain to the person next to you how you  */
/* would make comments to problem 4.... */


/* Problem 5) */
/* Which weekday on average is the sale highest in  */
/* the canteen? USE SQL. */

Proc sql;
 create table january2013new02 as 
  select distinct(weekday), avg(totprice) as avgtot, 
   case 
    when weekday(date)=1 then 7
	 when weekday(date) ne 1 then weekday(date)-1
   end as newweekday
    from exam.january2013new
     group by newweekday
      order by newweekday	
;
Quit;

/* Problem 6) */
/* Calculate the average sales per day but  */
/* only for employees that are also in the sample04  */
/* dataset, and not in the sample03 dataset. USE SQL. */
 
Proc sql;
 create table january2013new03 as 
  select avg(totprice) as avgtot, date
   from exam.january2013new
    where initials in (select initials from exam.sample4)
	       and initials not in (select initials from exam.sample3)
     group by date	
;
Quit;

/* Problem 7) */
/* Make a right join of the permanent januar2013  */
/* dataset and the sample04 dataset. */
/* Do the data sets sample01, sample02, sample03,  */
/* and sample04 have anything in common? USE  */
/* SQL. */


Proc sql; 
 create table january2013new04 as 
  select s.*, t.id_02
   from exam.january2013new as s right join exam.sample4 as t
    on s.initials = t.initials;
Quit;

Proc sql; 
 create table january2013new05 as 
  select *
   from exam.sample1
    where initials in (select initials from exam.sample2)
	   and initials in (select initials from exam.sample3)
	    and initials in (select initials from exam.sample4)
 ;
Quit;



/* Problem 8) */
/* Make new code : this time without sql */
/* Proc sql; */
/* create table test as */
/*  select initials, department,  */
/*  price / sum(price) format=percent6.2 as */
/* pricepct */
/*  from januar2013 */
/*  ; */
/* Quit; */ 



Proc means data=exam.january2013new sum noprint;
    output out=summary sum=totprice;
   var price;
Run;


Data newtest19_notsql;*(keep=initials department pricepct);
   merge exam.january2013new summary(keep=totprice);
    retain total;
     if _n_ = 1 then total=totprice;
      pricepct=price/total ;
   format pricepct percent6.2;
Run;

/* Run the code above with and without the retain statement  */

/* The RETAIN statement allows values to be  */
/* kept across observations  */


/* Problem 9)*/
/* Explain what is going on - nothing */

Proc sort data=exam.rdata out=rdata;
 by id workshop gender;
Run;
Proc print data=rdata;
Proc transpose data=rdata 
 out=mylong;
  var q1-q4;
   by id workshop gender;
Run;
Proc print data=mylong;
Data mylong;
 set mylong(rename=(col1=value));
  time=input(substr( _name_, 2) , 1.);
   drop _name_;
Run;
Proc print data=mylong;
Proc transpose data=mylong
 out=mywide prefix=q;
  by id workshop gender;
   id time;
    var value;
Run;
Proc print data=mywide;

/* The by statement species the variables that  */
/* proc transpose uses to form by groups */

/* ID Specifies a variable whose values name the transposed */
/* variables */

/* The VAR statement specifies the variables to transpose. */

