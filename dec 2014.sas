/*
comments*/
Proc sql; create table pa12 as 
(select a.*, b.type2 as ecsi_type, type as ecsitext 
from p11 a left join ecsi b on a.kinr=b.ki_no );
 Quit;
 
 
 Proc sql; 
 create table P1 as 
 (select a.*, b.* 
 from P a left join ddata.omsfo b on
(a.kinr=b.kinr and b.sasdato<="&omsdat"d and b.sasdato > intnx('month',"&omsdat"d,-12)) /* date minus 12 months*/
);

/*
The
&&DSN&N combination first resolves to a
macro variable (&DSN5) which then resolves to
a value (FRED) in a second pass
http://www2.sas.com/proceedings/sugi22/CODERS/PAPER77.PDF

http://www2.sas.com/proceedings/forum2008/105-2008.pdf
*/

%LET d1=diabetes;
%LET d2=hbp;
%LET d3=cvd;
%LET d4=asthma;
%Macro cmac1;
%do i = 1 %to 4; /* do 4 times */
Proc freq data=mdata;
tables s1*&&d&i; /* s1 - 4 times  d with escape and number i */
Run;
%end;
%Mend cmac1;

/*
print place where N is to be found after ;
see Exercises 02 GS
*/

Data test;
set dw_data.kont2;
i=1;
kuk=scan(mailcode, i, ';');
do while (kuk>'');
if kuk='N' then do;
kuk='';
output;
end;
else do;
i=i+1;
kuk=scan(mailcode, i, ';');
end;
end;
Run;


/*
Explain what happens and make a new similar program without using SQL.
Again remember to make comments.
https://stackoverflow.com/questions/16890102/sas-datastep-sql-select-latest-record-from-multiple-records-with-same-id
*/
Proc sql;
create table PA as
(select a.*, b.text as county
from PA a left join abnom.countyn b on a.countycode=b.amt
);
Quit;

data merged;
merge pa(in=o) abnom.countyn(in=u keep=text rename=(amt=countycode));
by countycode;
if o;
run;

data test;
input id date date7. sales;
format date date7.;
datalines;
1 01Jan11 12
1 02Jan11 20
2 12Jan11 34
2 23Feb11 21
3 15Jan10 12
5 15Mar11 12
;

Proc sql;* noprint;
(select max(date) format date7. into :salesd from test);
Quit;

proc sort data=work.test out= work.test; 
by date;
run;

data _null_;
set test;
   if last.id;
		call SYMPUTX("salesd", last.id);
run;
%put &salesd;

/*
Explain what happens and make a new similar program using SQL.
Again remember to make comments.
Left join ?
*/
Proc sort data=medcvr(drop=cvr_no);
by cvrnr;
Run;
Proc sort data=wdata.kdemo out=kdemo(keep=cvrno segment k_no);
by cvrno;
Run;

Data medcvr01(rename=(k_no=k_no_medcvr));
merge medcvr(in=f) kdemo(in=ff);
by cvrno;
if not ff then y_cvrno=1;
else y_cvrno=0;
if f then output;
Run;


/*
Explain what happens and make a new similar program using SQL.
Again remember to make comments.
no hierarchy - 3 times deletes what is there

http://www.lexjansen.com/nesug/nesug06/cc/cc05.pdf
http://www2.sas.com/proceedings/sugi26/p061-26.pdf
*/

Data HI FO telecom;
set kdemo(keep=k_no kisname hmob segm: mailstop employee);
if upcase(segment1)='TELECOM' and employee lt 100 then delete;
if k_no = '0202.105482' then delete;
if mailstop = 'T' then delete;
select;
when (upcase(segment1)='FO') output FO;
when (upcase(segment1)='HI') output HI;
otherwise output telecom;
end;
Run;

proc sql;
create table te as
select *
from kdemo(keep=k_no kisname hmob segm: mailstop employee);
 /* ?*/
delete from te
where (upcase(segment1) ^= 'TELECOM' and employee ge 100) and (k_no ^= '0202.105482') and (mailstop <> 'T');

create table fo as
select *
from te
where segment eq 'FO';

create table hi as
select *
from te
where segment eq 'HI';

create table telecom as
select *
from te
where segment ne 'FO' and segment ne 'HI';
quit;

/* possible maybe as well*/
proc sql;
create table final as 
select *
from dictionary.columns
where name like 'segm%' and name in ('k_no', 'kisname', 'hmob', 'mailstop', 'employee');
quit;


/*Explain what happens and make a new similar program without using SQL.
Again remember to make comments.
*/

Proc sql;
create table PA as
(select c.seg1, a.*, k.alias, b.firmtype, b.kom as kom
from ddata.seg c 
inner join ddata.nogle1 a on c.seg=a.seg 
inner join ddata.kisdemo k on a.kinr=k.kinr 
left join basedata b on a.ksmother=b.kinr 
where c.seg1 = 'PA' ); 
Quit;

data pa;
merge ddata.seg(in=c keep=seg1 where= (seg1 = 'PA')) ddata.nogle1(in= a);
by seg;
if c and a;
run;

data pa2;
merge  pa (in=pa) ddata.kisdemo(in=k keep=alias);
by kinr;
if pa and k;
run;

data pa3;
merge pa2(in=pa2) basedata(in=b keep = firmtype kom rename=(kinr=ksmother);
by ksmother;
if pa2;
run;

/*
The data set Exam needs some cleaning up. 
First, remove observations if idnumber02 is 
missing unless the employee is a woman, i.e.
 Male=2. Next, remove an observation if the 
 employee is older than 68 (Age), or the initials 
 contain a number. Call this new data set for EXAM_a*/










