libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';
FILENAME REFFILE '/folders/myshortcuts/SASUniversityEdition/EXAM/Transactions2012January.xlsx';

/* for macro debugging */
options mprint symbolgen;

/* For that Excel File -> working exercises */

PROC IMPORT DATAFILE=REFFILE DBMS=XLSX OUT=WORK.IMPORTtestfile; 
	GETNAMES=YES;
RUN;

PROC print DATA=WORK.IMPORTtestfile; RUN;


data t1(keep= units price rename = (units = Unts price = prc) );
set WORK.IMPORTtestfile end=fin;
if fin then output;
run;

data mergedWithAbove;
if _N_= 1 then set t1;
set WORK.IMPORTtestfile end=last;
if last then delete;
run;


Data jan_rabat jan_norabat;
 set work.IMPORTtestfile;
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
   if j;
    totprice=sum(price, pricenew);
Run;
