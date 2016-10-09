/* Week 40 */

libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';

/* A short digression */

Data data01(drop=i);
 do i = 1 to 10000000;
  x=normal(12);
   output;
 end;
Run;

Proc univariate data=data01;
 histogram x;
Run;

Data ds1;
 beta0=-1;
 beta1=1.5;
 beta2=0.5;
 mse=3;
  do x1 = 1 to 2;
   do x2 = 1 to 2;
    do obs = 1 to 50;
	 y=beta0 + beta1*x1 + beta2*x2 + normal(42)*mse;
      output;
    end;
   end;
  end;
Run;

Proc reg data=ds1;
 model y=x1 x2;
Run;

Proc univariate data=ds1;
 histogram y;
Run;

*SQL;

Proc sql;
 create table newtest as
   select date, time, prodcat, n, totprice
      from exam.january2013new

       where upcase(weekday) = 'MANDAG'
        order by n, totprice;
Quit;

Proc sql;
  create table newtest01 as 
   select prodcat, n, totprice, totprice*0.80 as exvat, date, time
    from newtest;
Quit;

 Proc sql;
  create table newtest02 as 
   select weekday, n, totprice, 
          case upcase(weekday)
             when 'MANDAG' then totprice*.95 
             when 'TIRSDAG' then totprice*.90
			 when 'ONSDAG' then totprice*.85
			 when 'TORSDAG' then totprice*.80
			 when 'FREDAG' then totprice*.75
			 when 'LØRDAG' then totprice*.70
			  else totprice*.50
          end as subsidyprice
      from exam.january2013new
;
Quit;

proc sort data=exam.january2013new out=newtest(keep=data time prodcat n);
by n totprice;
where upcase(weekday) = "MANDAG";
run;

Proc sql; 
 create table newtest03 as 
   select n, totprice,
          int((today()-Date)) /* truncates decimal */
          as No_days_ago
     from exam.january2013new
;
Quit;

Proc sql;
 create table newtest04 as 
  select n, totprice, date, month(date) as salesmonth, product
     from exam.january2013new
;
Quit;

Proc sql; 
 create table newtest05 as 
   select distinct initials
     from exam.january2013new
;
Quit;


Proc sql; 
 create table newtest06 as 
   select distinct initials
     from exam.january2013new

	  order by initials desc;
Quit;

Proc sql;
 create table newtest07 as 
  select n, totprice, date, month(date) as salesmonth, product
     from exam.january2013new

	  where totprice gt 0;
Quit;

Proc sql;
 create table newtest08 as 
  select n, totprice, date, totprice*0.10 as extra, product
   from exam.january2013new

    where totprice gt 0 and calculated extra le 2;
Quit;

Proc sql;
 create table newtest09 as 
   select n, totprice, date, totprice*0.10 as extra, product,
          calculated extra/2 as Halfextra
      from exam.january2013new

      where calculated Halfextra < 2.5;
Quit;

Proc sql;
 create table newtest10 as 
   select initials, totprice, department,
          (scan(department,-1,' ')) as twolevel
      from exam.january2013new

      where calculated twolevel='A/S';
Quit;

Proc sql;
 create table newtest11 as 
   select initials, totprice, department   
     from exam.january2013new

      where scan(department,-1,' ')='A/S';
Quit;

Proc sql;
*title "High spenders";
 create table newtest12 as 
   select department, initials,
          case (scan(department,-1,' '))
             when "A/S" then "Very important" /* replace */
             when "Landbrug" then "Important"
             else "N/A"
			 	end as threelevel, totprice,
          case (calculated threelevel)
             when "Very important" then 
                case 
                   when  (totprice>35) then "High"
                   when  (totprice>20) then "Medium"
                   else "Low"
                end
             when "Important" then
                case 
                   when  (totprice>30) then "High"
                   when  (totprice>20) then "Medium"
                   else "Low"
                end
             else "N/A"
		    end as spendingrange
	    from exam.january2013new

       where calculated threelevel ne "N/A" 
	  order by threelevel, totprice desc
;
Quit;
*title;

Proc sql;
 create table newtest13 as 
  select initials label='The initials of the employees',
          'VAT is:' /*Character Constant */,
          totprice*.20 format=comma12.2 as VAT
      from exam.january2013new

      where subsidy is missing
      order by totprice desc
;
Quit;

Proc sql;
 create table newtest14 as 
  select subsidy, initials label='The initials of the employees',
          price,pricenew,
          sum(price,pricenew) label='Total price' format=comma9.2 /* as gives name*/
      from exam.january2013new

     where (scan(department,-2,' '))="Scandinavia"
    order by Initials
;
Quit;


Proc sql;
 create table newtest15 as 
   select department, price, sum(price) 
          'Total Spending'
      from exam.january2013new

	   group by department
;
Quit;

Proc sql;
 create table newtest16 as 
   select count(*) as Count
      from exam.january2013new

	   where subsidy is missing
;
Quit;


Proc sql;
 create table newtest17 as 
   select department, count(*) as Count
      from exam.january2013new

	   where subsidy is missing
	    group by department
;
Quit;


Proc sql;
 create table newtest18 as 
   select department, weekday, avg(price) as avgprice
      from exam.january2013new

	   where subsidy is missing
	    group by department, weekday
;
Quit;


Proc sql;
 create table newtest19 as 
   select initials, department, 
          price / sum(price) format=percent6.2 as pricepct /* sum with 1 var -> columnswise total sum */
      from exam.january2013new /* sum with 2 vars -> rowswise */

	  ;
Quit;

Proc sql;
 create table newtest20 as 
   select department, count(*) as dep_count
      from exam.january2013new

	   group by department
		having dep_count lt 20
	     order by dep_count desc
;
/* where selects rows before grouping, while having after*/
Quit;


Proc sql;
 create table newtest21 as 
   select department, initials,
          (find(upcase(department),"LAND","i") >0) as m, /* find is finding position */
           find(upcase(department),"LAND","i") as mm
      from exam.january2013new

;
Quit;

Proc sql;
 create table newtest22 as 
  select distinct(initials), department, 
       sum((find(upcase(department),"LAND","i") >0))  /* counting number of cases where it is greater than 0 */
          as LAND,
       sum((find(upcase(department),"LAND","i") =0)) /* opposite*/
          as NOTLAND,
       calculated LAND/calculated NOTLAND
         "LAND/NOTLAND Ratio" format=percent8.1
   from exam.january2013new

  
;
Quit;

/* Create a new table that only has one observation,  */
/* i.e. we only have the information about land, notland,  */
/* ratio and perhaps a name for the ratio */
 
Proc sql;
 create table newtest23 as 
   select distinct(initials), department
     from exam.january2013new

      where initials in /* subquryr*/
         (select initials 
            from exam.sample1
             where id_02 in (7540518254, 7359438950, 7416719138)
			 )
      order by 1
;
Quit;


*Inner Join;

Proc sql;
 create table newtest24 as  
   select distinct(january2013new.initials) as employee format=$25.,  department format=$45.,
           month(date) 'Month' format=3. from exam.january2013new,exam.sample4
      /* Join criteria*/
      where january2013new.initials=  sample4.initials 
             and upcase(prodcat)='DRIKKEVARER'
      order by 3, january2013new.initials, department;
Quit;

Proc sql;
 create table newtest25 as 
   select distinct(january2013new
.initials) as employee format=$25.,
                department format=$45.,month(date) 'Month' format=3.
     from exam.january2013new

       inner join
         exam.sample4
          on january2013new
.initials=
              sample4.initials 
   where upcase(prodcat)='DRIKKEVARER'
    order by 3, january2013new
.initials, department;
Quit;


*Outer join;

/* Try also right and full join */

Proc sql;
 create table newtest26 as 
   select distinct(t.initials), department, id_02 
          from exam.january2013new
 as t
           left join    exam.sample4 as s
      on t.initials=s.initials
   where upcase(prodcat)='DRIKKEVARER'
;
Quit;

Proc sql;
 create table newtest27 as 
   select distinct(t.initials), department, id_02 
          from exam.january2013new
 as t
           left join 
           exam.sample4 as s
      on t.initials=s.initials
   where t.initials in (select distinct(x.initials) from exam.sample1 as x)
    or t.initials in (select distinct(y.initials) from exam.sample2 as y)
;
Quit;


/* remember: when you merge to data sets the by  */
/* variables should be of the same format! */

Data newtest28;
 set exam.january2013new;
  char_id = put(n, $12.); 
   drop n ; 
    rename char_id=n ; 
	* to convert to character;
  Run;

Data newtest29;
 set newtest28;
  num_id=input(n, 12.);
  drop n;
   rename num_id=n;
    * to convert to numeric;
Run;



Proc sql;
 create table newtest30 as 
  select department, avg(price) as avgprice62 format=6.2
   from exam.january2013new

    group by department
     having avgprice62 > (select avg(price)
                           from exam.january2013new
)
;
Quit;


Proc sql;
 create table newtest31 as 
   select distinct(a.initials) 'The initials of the employee', 
          (('31OCT2013'd-date)/365.25)
          as YA 'Years Ago' format=6.2
      from exam.january2013new
 as a,
           exam.sample4 as b
	  where a.initials=b.initials
	        and calculated YA gt 1.8
	   order by initials
;
Quit;


Proc sql;
 create table newtest32 as 
   select department, 
          max(value) 'Max Value Sold' format=comma9.2, 
          max(orders) 'Max Orders' format=comma7.2, 
          max(avgorder) 'Max Average' format=comma7.2, 
          min(avgorder) 'Min Average' format=comma7.2
           /* Begin in-line view */      
      from (select department, s.initials, 
                   sum(totprice) as value, 
                   count(*) as orders,
                   calculated value / calculated orders
                      as avgorder
               from exam.january2013new as of,
                    exam.sample4 as s
              where of.initials=s.initials
                and week(date)=2
              group by department, s.initials
              having value ge 2) /* End in-line view */
     group by department
     order by department
;
Quit;



Proc sql; 
 create table xx_sample as 
  select distinct(initials), totprice 
   from exam.january2013new

;
Quit;

Proc surveyselect data=xx_sample out=xx_subsample 
   seed=12345 method=srs sampsize=25;
Run;


/* select... */
/* except|intersect|union|outer union <corr><all> */
/* select... */
/*  */
/* Set operators vertically combine rows from two result sets.  */
/* There are four set operators: */
/*  */
/* 	1) Except	 */
/* 	2) Intersect */
/* 	3) Union */
/* 	4) Outer Union */
/*  */
/* 1-3) columns are matched by position and must be the same data type.  */
/* Column names in the final result set are determined by the first  */
/* result set. */
/* 4) All columns from both result sets are selected. */
/*  */
/* Modifiers: can be used to modify the behaviour of the set operators. */
/*  */
/* 	a) All */
/* 	b) Corr */
/*  */
/* a) Does not remove dublicate rows.  */
/* Is not allowed with an outer union operator. It is implicit. */
/* b) Overlays columns by name, instead of by position. Removes */
/* any columns not found in both tables when used in except, intersect, */
/* and union operations. Causes common colums to be overlaid when */
/* used in outer union operations. */


Proc sql;
 create table dataxx as
  select*
   from exam.sample1
     union corresponding /* all */
     select *
      from exam.sample5;
Quit;


/* Try "except", "intersect", "union", and "outer union" */
/* with the modifiers "all" and "corr" */


/*  */
/* Proc SQL view - selfstudy */
/*  	Is a stored query. */
/* 	Contains no actual data. */
/* 	Extracts underlying data each time that it is used, and accesses  */
/*  	the most current data. */
/* 	Can be referenced in SAS programs in the same way as a data table. */
/* 	Cannot have the same name as a table stored in the same SAS library. */
/* 	Hide complex joins or queries from users. */
/* 	Often save space, because a view is frequently quite small compared  */
/* 	with the data that it accesses. */
/*  */
/* Create view <view-name> as  */
/* 	<query-expressions>; */
/*  */
/*  */

Proc sql;
 create view exam.testview as
  select * 
  	from exam.sample3
	 where substr(upcase(initials),1,1)="A"
;
Quit;


Proc sql inobs=10; 
 *now try without the where statement;
 create table newtest40 as 
  select * 
   from exam.x2012_1_6cleaned10 
    where sumtotprice gt 100
;
Quit;

Proc sql outobs=15; 
 *now try without the where statement;
 create table newtest40 as 
  select * 
   from exam.x2012_1_6cleaned10 
    where sumtotprice gt 100
;
Quit;


Proc sql noprint;
   select distinct price into :price separated by ', '
      from exam.jan2012
       where price between 10 and 20;
Quit;

%put &price;

Data xx;
 set exam.x201202;
  where pris_total in (&price);
Run;


%let PC=Slik;
options symbolgen;

/* options symbolgen displays the results of  */
/* resolving macro variable references. This  */
/* option is useful for debugging. */

Proc sql noprint;
   select avg(price) 
      into :Meanprice
      from exam.january2013new

        where prodcat="&PC"
;
Quit;


%let LargeBuff=100;
options symbolgen;

Proc sql noprint;
      select avg(price),min(price),max(price)
       into :Meanprice, :Minprice, :Maxprice
        from exam.january2013new
;
%put Mean: &meanprice Min: &minprice 
     Max: &maxprice Price of large buffet: &LargeBuff;
Quit;

options symbolgen;
Data testmacro; 
 set exam.january2013new
;
  where price > &meanprice;
Run;




* Week 41;


/* The macro facility is a text processing facility  */
/* for automating and customizing SAS code */

/* The macro facility helps minimizing the amount of SAS */
/* code you must type to perform common tasks */


libname exam '/folders/myfolders/exam/';

/* Macro statements begins with a sign(%)  */
/* followed by a name token. */
/* The %LET statement creates a macro variable  */
/* and assigns it a value. */
/* Macro variables are global in scope. */
/* Store numeric tokens as text. */


%let dayy=Normal day;
%let date1=12may2012;
%let date2=25jun2012;

Proc print data=exam.X2012_1_6cleaned10;
/* Macro variable references begin with an ampersand(&)  */
/* followed by a macro variable name */
   where day between "&date1"d and "&date2"d;
    where also daytype="&dayy";
     var _numeric_;
      title "Transactions between &date1 and &date2 - Normal days";
Run;
/* The %Put statement writes text to the SAS log. */
/* Quotation marks are not required around text. */
/* Are valid anywhere in a SAS program */

%put &dayy &date1 &date2;


%let month=MAR;
%let year=2012;
proc print data=exam.X2012_1_6cleaned10;
	where day="01&month&year"d;
   	 var _numeric_;
	  title "Information for &month &year";
	   %put &month &year;
run;
title;

/* Some selected character string manipulation functions. */
/* %SUBSTR extracts a substring from a character string. */
/* %EVAL performs arithmetic and logical operations */

%let thisyear=%substr(&sysdate9,6);
%let threeyearsago=%eval(&thisyear-3);

proc means data=exam.X2012_1_6cleaned10 maxdec=2 min max mean;
   class daytype;
    var sumStorBuffet;
     where year(day) = &threeyearsago;
       title1 "Sales for &threeyearsago";
       title2 "(as of &sysdate9)";
   %put &thisyear &threeyearsago;
run;
title;
footnote; 

proc sort data=exam.X2012_1_6cleaned10 
                        out=X2012_1_6cleaned10_TEST;
   by daytype day;
run;


%let ddd=First; 
/* %let ddd=Last; 

/*A period (.) is a special delimiter that ends a macro variable 
reference. The period does not appear as text when the macro 
variable is resolved.*/

data &ddd.xxx;   
   set X2012_1_6cleaned10_TEST;
   by daytype;
   if &ddd..daytype;  
run;
proc print data=&ddd.xxx;
   var daytype day;
   title "&ddd Daytype";  
run;

/* A macro or macro definition  */
/* enables you to write macro programs. */
/* The MCOMPILENOTE=ALL option issues a note to the  */
/* SAS log after a macro definition has been compiled */

options mcompilenote=all;

%macro time;
   %put The current time is %sysfunc(time(),timeAMPM.).;
/*    %SYSFUNCï¿½ executes SAS functions */
%mend time;
/* A macro call causes the macro to execute. */
/* A macro call is specified by placing  */
/* a percent sign before the name of the macro. */
/* No semicolon required. */

%time


%macro calc;
   proc means data=exam.X2012_1_6cleaned10 &stats;
      var &vars;
   run;
%mend calc;

%let stats=min max;
%let vars=sumStorBuffet;
%calc

%let stats=n mean;
%let vars=sumLilleBuffet;
%calc



%macro calc(stats,vars);
   proc means data=exam.X2012_1_6cleaned10 &stats;
      var &vars;
   run;
%mend calc;

%calc(min max,sumLilleBuffet)
title;


*Positional parameters;
%macro count(opts=,start=01jan12,stop=31mar12);
   proc freq data=exam.X2012_1_6cleaned10;
      where day between "&start"d and "&stop"d;
      table daytype / &opts;
      title1 "BLA BLA from &start to &stop";
   run;
%mend count;

options mprint;

%count(opts=nocum)
title;
%count(stop=01jul12,opts=nocum nopercent)
title;
%count()
title;

libname macData '/folders/myfolders/macData/';

options mstored sasmstore=macData;

%macro calcII / store;
   proc means data=exam.X2012_1_6cleaned10 &stats;
      var &vars;
   run;
%mend calcII;



options mstored sasmstore=macData;

%let stats=min max;
%let vars=sumLilleBuffet;

%calcII


/* SYMPUT provides a way to turn DATA step variables  */
/* into macro variables, and SYMGET does the converse, */
/* grabbing macro variable values and assigning them  */
/* to DATA step variables. */


/* Displaying macro variables */
/* Display all user-defined macro variables in  */
/* the SAS log:  %put _user_;  */
/* Display all user-defined and automatic macro  */
/* variables in the SAS log: %put _all_; */
/* The SYMBOLGEN system option writes macro  */
/* variable values to the SAS log as they are  */
/* resolved: options symbolgen; â€“ turn off the  */
/* option again: options nosymbolgen; */
/* %SYMDEL macro variables; delete user  */
/* defined macro variables */


%let month=2;
%let year=2012;
options symbolgen;
data test117;
   keep day daytype sumLilleBuffet sumStorBuffet;
   set exam.X2012_1_6cleaned10 end=final;
   where year(day)=&year and month(day)=&month;
   if daytype="Normal day" then Number+1;
   if final then do;
      if Number=0 then do;
         call symputx('foot', 'No normal days');
      end;
      else do;
         call symputx('foot', 'Some normal days');
      end;
   end;
run;
options nocenter ps=20;

proc print data=test117;
   title "Sales for &month-&year";
   footnote "&foot";
run;

title;
footnote;



%let month=1;
%let year=2012;

data test118;
   keep day daytype sumLilleBuffet sumStorBuffet;
   set exam.X2012_1_6cleaned10 end=final;
   where year(day)=&year and month(day)=&month;
   if daytype="Normal day" then Number+1;
   if final then call symputx('num', Number);
run;

options nocenter ps=20;

proc print data=test118;
   title "Sales for &month-&year";
   footnote "&num normal days";
run;

title;
footnote;



%let month=1;
%let year=2012;

data test119;
   keep day daytype sumStorBuffet;
   set exam.X2012_1_6cleaned10 end=final;
   where year(day)=&year and month(day)=&month;
   if daytype="Normal day" then do;
      Number+1;
      Amount+sumStorBuffet;
      Date=day;
      retain date;
      end;
   if final then do;
      if number=0 then do;
         call symputx('dat', 'N/A');
         call symputx('avg', 'N/A');
      end;
      else do;
         call symputx('dat', put(date,mmddyy10.));
         call symputx('avg', put(amount/number,dollar8.));
      end;
   end;
run;

options nocenter ps=20;

proc print data=test119;
   title "Sales for &month-&year";
   footnote1 "Average Big Buffet: &avg";
   footnote2 "Last Order: &dat";
run;


title;
footnote;



Proc sort data=exam.january2013new (keep=initials n) 
              out=test120 nodupkey;
 by initials;
Run;

data _null_;
   set test120;
   call symputx('name'||left(n), initials);
run;

%put _user_;


%let n=2318;

proc print data=exam.january2013new
;
   where n=&n;
   var totprice;
   title1 "Customer Number: &n";
   title2 "Customer Name: &&name&n";
run;

title;


data test121;
   keep date n initials customer;
   set exam.january2013new;
   length Customer $ 20;
   Customer=symget('name'||left(n));
run;

proc print data=test121;
   var date n customer;
    where customer <> " ";
   title "Customers";
run;

title;




Proc sql noprint;
   select distinct price into :price separated by ', '
      from exam.jan2012
       where price between 10 and 20;
Quit;

%put &price;

Data xx;
 set exam.x201202;
  where pris_total in (&price);
Run;


%let PC=Slik;
options symbolgen;

/* options symbolgen displays the results of  */
/* resolving macro variable references. This  */
/* option is useful for debugging. */
/*  */
Proc sql noprint;
   select avg(price) 
      into :Meanprice
      from exam.january2013new

        where prodcat="&PC"
;
Quit;


%let LargeBuff=100;
options symbolgen;

Proc sql noprint;
      select avg(price),min(price),max(price)
       into :Meanprice, :Minprice, :Maxprice
        from exam.january2013new
;
%put Mean: &meanprice Min: &minprice 
     Max: &maxprice Price of large buffet: &LargeBuff;
Quit;

options symbolgen;
Data testmacro; 
 set exam.january2013new;
  where price > &meanprice;
Run;











