libname loaddata '/folders/myshortcuts/SASUniversityEdition/loaddata/';
libname orion '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data';
libname prog1 '/folders/myshortcuts/SASUniversityEdition/lecture1/';
libname savedata '/folders/myshortcuts/SASUniversityEdition/savedata/';
libname exam '/folders/myshortcuts/SASUniversityEdition/EXAM/';
libname orion2 '/folders/myshortcuts/SASUniversityEdition/lecture2/Programming_2_Data';
/* inencoding=asciiany */

/* Week39 */

/* What is the difference? */

Data usa australia other;
   set orion2.employee_addresses;
    if Country='US' then output usa;
     else if Country='AU' then output australia;
      else output other;
Run;

Data usa australia other;
   set orion2.employee_addresses;
    if upcase(Country)='US' then output usa;
     else if upcase(Country)='AU' then output australia;
      else output other;
Run;

Data usa australia other;
   set orion2.employee_addresses;
    Country=upcase(country);
     if Country='US' then output usa;
      else if Country='AU' then output australia;
       else output other;
Run;


/* What is the difference? */

Data usa australia other;
   set orion2.employee_addresses;
    select (country);
	  when ('US','us') output usa;
	  when ('AU','au') output australia;
	  otherwise output other;
    end;
Run;

Data usa australia other;
   set orion2.employee_addresses;
    select (upcase (country));
	  when ('US') output usa;
	  when ('AU') output australia;
	  otherwise output other;
    end;
Run;



Data australia;
	set orion2.employee_addresses 
            (firstobs=50 obs=100);
   if Country='AU' then output;
Run;


Data work.lookupII;
 set orion2.country;
  Outdated='N';
Run;

Data work.lookup;
  set orion2.country;
  Outdated='N';
  output;
  if Country_FormerName ne ' ' then do;
    Country_Name=Country_FormerName;
	Outdated='Y';
	output;
  end;
  *drop Country_FormerName Population;
Run;


/* otherwise?? */

Data test; 
 set orion2.orders;
Run;

Data work.fast work.slow work.veryslow;
  set orion2.orders;
   where Order_Type in (2,3);
    ShipDays=Delivery_Date-Order_Date; /* new var*/
     select; /* select it*/
	when (ShipDays=<3) output work.fast;
        when (5<=ShipDays<=7) output work.slow;
         when (ShipDays>7) output work.veryslow;
	   otherwise;
     end;
  drop Employee_ID;
Run;


/* fist. last. */
Proc sort data=orion2.specialsals out=salsort;
   by Dept;
Run;
/*Summarize Salaries by Division*/
Data deptsals;
   set SalSort;
    by Dept; /* whenever by statement i must have sorted data before*/
     if First.Dept then DeptSal=0;
      DeptSal+Salary;
    *   if Last.Dept;
Run;

Data deptsals(keep=Dept DeptSal);
   set SalSort;
    by Dept; /* whenever by statement i must have sorted data before*/
     if First.Dept then DeptSal=0;
      DeptSal+Salary;
       if Last.Dept; /* same as = 1*/
Run; 

/*Summarize Salaries by Project and Department*/ 
Proc sort data=orion2.projsals out=projsort;
	by Proj Dept;
Run;  
  
Data pdsals(keep= Proj Dept DeptSal NumEmps);
   set projsort;
    by Proj Dept;
     if First.Dept then do;
      DeptSal=0;
       NumEmps=0;
     end;
      DeptSal+Salary;
       NumEmps+1;
        if Last.Dept;
Run;


Proc sort data=orion2.order_qtrsum out=work.custsort;
  by Customer_ID Order_Qtr;
Run;

Data work.qtrcustomers;
  set work.custsort;
   by Customer_ID Order_Qtr;
    if first.Order_Qtr=1 then do;
     Total_Sales=0;
	  Num_Months=0;
    end;
     Total_Sales+Sale_Amt;
      Num_Months+1;
       if last.Order_Qtr=1;
        keep Customer_ID Order_Qtr Total_Sales Num_Months;
Run;



Proc sort data=orion2.usorders04 out=work.usorders04;
  by Customer_ID Order_Type;
Run;

Data work.discount1 work.discount2 work.discount3;
  set work.usorders04;
   by Customer_ID Order_Type;
    if first.Order_Type=1 then TotSales=0;
     TotSales+Total_Retail_Price;
      if last.Order_Type=1 and TotSales >= 100 then do;
       if Order_Type=1 then output discount1;
        else if Order_Type=2 then output discount2;
	  else if Order_Type=3 then output discount3;
      end;
       keep Customer_ID Customer_Name TotSales;
Run;


/* What is the difference between total and totalII -> missings - total2 will be missing  */
Data contrib; 
   set orion2.employee_donations;
    Total=sum(Qtr1,Qtr2,Qtr3,Qtr4);
     TotalII=Qtr1+Qtr2+Qtr3+Qtr4;
      if Total ge 50;
Run;

 /* Using a variable list */
Data contrib;
   set orion2.employee_donations;
    Total=sum(of Qtr1-Qtr4, qtr1);
    *Tot=sum(of Qtr1-Total);
    * if Total ge 50;
Run;


*What is happening here? Check the orion.biz_list;
Data charities;
  length ID $ 5;
   set orion2.biz_list;
    if substr(Acct_Code,length(Acct_Code),1)='2';
     ID=substr(Acct_Code,1,length(Acct_Code)-1);
      Name = propcase(Name);
Run;

/* CHAR(string, position) */
Data charities;
  length ID $ 5;
	set orion2.biz_list;
	 if char(right(Acct_Code),6) = '2';
	  ID = left(substr(right(Acct_Code),1,5));
Run;


Data Scan_Quiz;
  Text = "New Year's Day, January 1st, 2007"; 
  Year1 = scan(Text,-1);
  Year2 = scan(Text,6);
  Year3 = scan(Text,6,', '); *try different values and delimiters;
Run;

Data labels;
   set orion2.contacts;
    length FullName $ 30 FMName LName $ 15;
     FMName = scan(Name,2,',');            
      LName = scan(Name,1,',');
       FullName = catx(' ',Title,FMName,LName);
Run;


*Check the internet:);
Data find;
   Text='AUSTRALIA, DENMARK, US';
    Pos1=find(Text,'US');
     Pos2=find(Text,' US');
      Pos3=find(Text,'us');
       Pos4=find(Text,'us','I');
        Pos5=find(Text,'us','I',10);
Run;


Data correct;
	set orion2.clean_up;
	 if find(Product,'Mittens','I') > 0 then do;
		substr(Product_ID,9,1) = '5';
		 Product = tranwrd(Product,'Luci ','Lucky ');
	 end;
	  Product_ID = compress(Product_ID);
	   Product = propcase(Product);
Run;


Data descript;
   Var1=12;
    Var2=.;
     Var3=7;
      Var4=5;
              SumVars=sum(Var1,Var2,Var3,Var4);
               SumvarsII=var1+var2+var3+var4;
                AvgVars=mean(of Var1-Var4);
                 MissVars=cmiss(of Var1-Var4);
                  MissVarsN=Nmiss(of Var1-Var4);

/* The CMISS() function is similar to the NMISS() function that it counts the number */
/* arguments that are missing, but for both character and numeric variables without  */
/* requiring character values to be converted to numeric.  */
                 
Run;


Data donation_stats;
   set orion2.employee_donations;
   * keep Employee_ID Total AvgQT NumQT;
     Total = sum(of Qtr1-Qtr4);
     AvgQT = round(Mean(of Qtr1-Qtr4));
     NumQt = n(of Qtr1-Qtr4);
Run;
 /*
 read all up to here, exam questions 
 convert to numeric vars
 */

Data conversions;
   CVar1='32000';
   CVar2='32.000';
   CVar3='03may2008';
   CVar4='030508';
   NVar1=input(CVar1,5.);
   NVar2=input(CVar2,commax6.);
   NVar3=input(CVar3,date9.);
   NVar4=input(CVar4,ddmmyy6.);
Run;

Data hrdata;
   *keep EmpID GrossPay Bonus HireDate;
   set orion2.convert;
   EmpID = input(ID,5.)+11000;
   Bonus = input(GrossPay,comma6.)*.10;
   HireDate = input(Hired,mmddyy10.);
Run;

/* convert char variable to numeric one*/
Data hrdata(drop=CharGross);
   set orion2.convert(rename=(GrossPay=CharGross));            
    GrossPay=input(CharGross,comma6.); /* new var with old name, then through away */
Run;

/* from numberic to chars*/
Data conversion;
  NVar1=614;
   NVar2=55000;
    NVar3=366;
     CVar1=put(NVar1,3.);
      CVar2=put(NVar2,dollar7.);
       CVar3=put(NVar3,date9.);
Run;


*Concatenating: two consecutive exclamation marks !!;

Data hrdata;
 *  keep Phone Code Mobile;
    set orion2.convert;
     Phone='(' !! put(Code,3.) !! ') ' !! Mobile;
Run;

Data hrdata;
    keep EmpID GrossPay Bonus Phone HireDate;
     set orion2.convert(rename=(GrossPay=CharGross));
       EmpID = input(ID,5.)+11000;
        GrossPay=input(CharGross,comma6.);
         Bonus = GrossPay*.10;
          HireDate = input(Hired,mmddyy10.);
           Phone = cat('(',Code,') ',Mobile);
Run;


Data work.codes;
  set orion2.au_salesforce;
   length FCode1 FCode2 $ 1 LCode $ 4;
    FCode1=lowcase(substr(First_Name,1,1));
     FCode2=substr(First_Name,length(First_Name),1);
      LCode=lowcase(substr(Last_Name,1,4));
Run;


Data work.small;
  set orion2.newcompetitors;
   Country = substr(ID,1,2);
    Store_Code=left(substr(ID,3)); /* pos 3 and then the rest*/
     if substr(Store_Code,1,1) = '1';
      City=propcase(City);
Run;


Data names;
   length New_Name $50 
          FMnames $30
          Last $30;
   set orion2.customers_ex5;
   FMnames = scan(Name,2,',');
    Last = propcase(scan(Name,1,','));
	if Gender="F" then New_Name=CATX(' ','Ms.',FMNames,Last);
        else if Gender="M" then New_Name=CATX(' ','Mr.',FMNames,Last);
	*keep New_Name Name Gender;
Run;

/* basically splits string into 2 podsebeou - > 2 rows*/
/* from 1 observantion to 2 obs */
Data work.split;
   set orion2.employee_donations;
    PctLoc=find(Recipients,'%');
   /* Position in which the first '%' occurs */
     if PctLoc > 0 then do;
      Charity=substr(Recipients,1,PctLoc);
      output; /* print the first line */
	Charity=substr(Recipients,PctLoc+3, -1);
      output; /* dalsi line*/
     end;
   /* If '%' was found, then there's more than one recipient */
   /* Use PctLoc+3 for the '%, ' before the second charity */
   else do;
      Charity=trim(Recipients)!!' 100%';
	   output;
   end;
  * drop PctLoc Recipients;
Run;



Data US_converted;*(drop=cID nTelephone cBirthday);
  set orion2.US_newhire
      (rename=(ID=cID Telephone=nTelephone
               Birthday=cBirthday));
   ID = input(compress(cID,'-'),15.);
    length Telephone $ 8;
     Telephone = cat(substr(put(nTelephone,7.),1,3),
              '-',substr(put(nTelephone,7.),4));
      Birthday = input(cBirthday,date9.);
Run;

Data us_mailing;
   set orion2.mailing_list;
    drop Address3;
     length City $ 25 State $ 2 Zip $ 5;
      if find(Address3,'US');
       Name=catx(' ',scan(Name,2,','),scan(Name,1,','));
       City=scan(Address3,1,',');
       State=scan(address3,2,',');
       Zip=scan(Address3,3,',');
Run;





Data invest;
/* default is 1, not*/
   do Year=2008 to 2010;
    Capital+5000;
    output;
     Capital+(Capital*.045);
      output;
   end;
Run;
Proc print data=invest noobs;
Run;

Data invest;
   do until(Capital>1000000);
    Year+1;
     Capital+5000;
      Capital+(Capital*.045);
     * output;
   end;
Run;
Proc print data=invest noobs;
Run;

Data invest;
   do while(Capital<=1000000);
     Year+1;
      Capital+5000;
       Capital+(Capital*.045);
     * output;
   end;
Run;

Proc print data=invest noobs;
Run;


Data invest (drop=Quarter);
   do Year=1 to 5;
    Capital+5000;
     do Quarter=1 to 4;
      Capital+(Capital*(.045/4));
            output;
     end;
      output;
   end;
Run;
Proc print data=invest noobs;
Run;

Data invest;
   do Year=1 to 5;
    Capital+5000;
     do Quarter=1 to 4;
      Capital+(Capital*(.045/4));
       output;
     end;
   end;
Run;
Proc print data=invest noobs;
Run;


Data invest;
   do Year=2008 to 2010;
    Capital+5000;
     Capital+(Capital*.045);
   end;
Run;
Proc print data=invest noobs;
Run;


Data forecast;
 set orion2.growth;
  do Year=1 to 6;*BY 0.25;
    Total_Employees=Total_Employees*(1+Increase);
     output;
  end;
Run;
Proc print data=forecast noobs;
Run;

Data invest;
   do Year=1 to 30 until(Capital>250000);
      Capital+5000;
      Capital+(Capital*.045);
   * output;
   end;
Run;
Proc print data=invest noobs;
Run;



Data invest;
   do Year=1 to 30 while(Capital<=250000);
      Capital+5000;
      Capital+(Capital*.045);
   * output;
   end;
Run;
Proc print data=invest noobs;
Run;


*move around with "output";
Data invest(drop=Quarter);
   do Year=1 to 5;
      Capital+5000;
      do Quarter=1 to 4;
         Capital+(Capital*(.045/4));
      end;
      output;
   end;
Run;

Proc print data=invest noobs;
Run;


Proc print data=orion2.banks;
Run;

Data invest(drop=Quarter Year);
   set orion2.banks;
   Capital=0;
   do Year=1 to 5;
      Capital+5000;
      do Quarter=1 to 4;
         Capital+(Capital*(Rate/4));
      end;
      *output;
   end;
Run;

Proc print data=invest noobs;
Run;


Data invest;*(drop=Quarter Year);
   set orion2.banks;
   Capital=0;
   do Year=1 to 5;
      Capital+5000;
      do Quarter=1 to 4;
         Capital+(Capital*(Rate/4));
      end;
      output;
   end;
Run;

Proc print data=invest noobs;
Run;


Data charity;   
  set orion2.employee_donations;
   keep employee_id qtr1-qtr4; 
    Qtr1=Qtr1*1.25;  
     Qtr2=Qtr2*1.25;
      Qtr3=Qtr3*1.25;         
       Qtr4=Qtr4*1.25;
Run;
Proc print data=charity noobs;
Run;

/*simplyfe processing*/

Data charity;
  set orion2.employee_donations;
   keep employee_id qtr1-qtr4; 
    array Contrib{4} qtr1-qtr4; /* dimensions q1-q4 */
     do i=1 to 4;        
      Contrib{i}=Contrib{i}*1.25;
     end; 
Run; 

Proc print data=charity noobs;
Run;


Data charity;
   set orion2.employee_donations;
*   keep employee_id qtr1-qtr4; 
   array Contrib{4} qtr:;
   array cont{4} a s d f; /* header names */
    do i=1 to dim(contrib);        
      cont{i}=Contrib{i}*1.25;
    end; 
Run; 

Proc print data=charity noobs;
Run;


Data percent(drop=i);              
   set orion2.employee_donations;
    array Contrib{4} qtr1-qtr4;        
     array Percent{4};
      Total=sum(of contrib{*});           
    do i=1 to 4;     
      percent{i}=contrib{i}/total;
    end;                               
Run; 
Proc print data=percent noobs;
   var Employee_ID percent1-percent4;
    format percent1-percent4 percent6.;
Run;


Data change;                 
   set orion2.employee_donations;
    drop i; 
     array Contrib{4} qtr1-qtr4;        
      array Diff{3};                  
     do i=1 to 3;                       
      diff{i}=contrib{i+1}-contrib{i};
     end;                               
Run; 
Proc print data=change noobs;  
Run;


Data compare(drop=i Goal1-Goal4);
   set orion2.employee_donations;
    array Contrib{4} Qtr1-Qtr4;
     array Diff{4};
      array Goal{4} (10,20,20,15);
    do i=1 to 4;
      Diff{i}=Contrib{i}-Goal{i};
    end;
Run;
Proc print data=compare noobs;
Run;


Data compare(drop=i);
   set orion2.employee_donations;
    array Contrib{4} Qtr1-Qtr4;
     array Diff{4};
      array Goal{4} _temporary_ (10,20,20,15); /* create temps -> dont delete anything later */
    do i=1 to 4;
      Diff{i}=Contrib{i}-Goal{i};
    end;
Run;
Proc print data=compare noobs;
Run;


Data fsp(drop = i);
   set orion2.orders_midyear;
   *keep Customer_ID Months_Ordered Total_Order_Amount;
    array amt{*} month:; /*  star figure out the dimension */
     Total_Order_Amount=0;
      Months_Ordered=0;
    do i=1 to dim(amt);
     if amt{i} ne . then Months_Ordered+1;
      Total_Order_Amount+amt{i};
     end;
    *if Total_Order_Amount>1000 and Months_Ordered >= (dim(amt))/2;
Run;


Data preferred_cust;
   set orion2.orders_midyear;
    array Mon{6} Month1-Month6;
     *keep Customer_ID Over1-Over6 Total_Over;
      array Over{6};
       array Target{6} _temporary_ (200,400,300,100,100,200);
        do i=1 to 6;
         if Mon{i} > Target{i} then
          Over{i} = Mon{i} - Target{i};
        end;
       Total_Over=sum(of Over{*});
   if Total_Over > 500;
Run;
Proc print data=preferred_cust noobs;
Run;


Proc print data=orion2.employee_donations noobs;
Run;

Proc transpose 
     data=orion2.employee_donations out=rotate2;
Run;
Proc print data=rotate2 noobs;
Run;


Proc transpose 
     data=orion2.employee_donations out=rotate2;
   by Employee_ID; /* not going to be transposed */
Run;
Proc print data=rotate2 noobs;
Run;

  /* The VAR statement specifies the variables to transpose. */
  /* It has no effect here because there are no other numeric variables. */
Proc transpose 
     data=orion2.employee_donations
     out=rotate2;
      by Employee_ID;
   *var Qtr1-Qtr4;
   var Qtr1-Qtr3;
Run;

Proc print data=rotate2 noobs;
Run;

  /* Add the PROC TRANSPOSE NAME= option */

Proc transpose data=orion2.employee_donations 
     out=rotate2
    name=Period;
   by employee_id;
Run;

Proc print data=rotate2 noobs;
Run;


Proc transpose 
     data=orion2.employee_donations 
     out=rotate2 
     name=Period;
   by employee_id;
Run;
Proc print data=rotate2 noobs;
Run;


Proc print data=orion2.order_summary noobs;
Run;


Proc transpose data=orion2.order_summary
               out=annual_orders;

Run;

Proc print data=annual_orders noobs;
Run;

Proc transpose data=orion2.order_summary
               out=annual_orders;
   by Customer_ID;
Run;

Proc print data=annual_orders noobs;
Run;

  /* Add an ID statement */
Proc transpose data=orion2.order_summary
               out=annual_orders;
   by Customer_ID;
   id Order_Month;
Run;

Proc print data=annual_orders noobs;
Run;


*SQL;

Proc sql; /* always quit + sql */
 create table newtest as /* new data as */
   select date, time, prodcat, n, totprice
      from exam.january2013new
       where upcase(weekday) = 'MANDAG'
        order by n, totprice;
Quit;

Proc sql;
  create table newtest01 as 
   select date, time, prodcat, n, totprice, totprice*0.80 as exvat
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
      from exam.january2013new;
Quit;

Data january2013;
 set exam.january2013new;
Run;


Proc sql; 
 create table newtest03 as 
   select n, totprice,
          today()-Date
          as No_days_ago
     from exam.january2013new;
Quit;

Proc sql;
 create table newtest04 as 
  select n, totprice, date, month(date) as salesmonth, product
     from exam.january2013new;
Quit;

Proc sql; 
 create table newtest05 as 
   select distinct initials
     from exam.january2013new;
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
          calculated extra/2 as Halfextra /* calculated because not in dataset */
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



