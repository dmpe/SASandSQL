/*  test */
libname perTab '/folders/myshortcuts/SASUniversityEdition/lecture1';

data perTab .testtable;
 a=1;
 b=117;
run; 

options linesize=95 pagesize=52;

libname orion '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/';

*p102d01;

proc setinit;
run;

data work.NewSalesEmps;
   length First_Name $ 12 Last_Name $ 18
          Job_Title $ 25;
   infile 'newemps.csv' dlm=',';
   input First_Name $ Last_Name $
         Job_Title $ Salary;
run;

data perTab.page55;
 /*length Name 8 N1 3 N2 3 N3 3 N4 3;*/
 input Name $ N1 N2 N3 N4;
 datalines;
	Lucky 2.3 1.9 . 3.0
	Spot 4.6 2.5 3.1 .5
	Tubs 7.1 . . 3.8
	Hop 4.5 3.2 1.9 2.6
	Noisy 3.8 1.3 1.8 1.5
	Winner 5.7 . . .
	;
	run;
proc print data = perTab.page55;
	Title "By me";
run;
	
	
data perTab.informants;
	input Name $16. Age 3. +1 Type $1. +1 Date MMDDYY10. (A B C D E) (4.1);
datalines;
Alicia Grossman  13 c 10-28-2012 7.8 6.5 7.2 8.0 7.9
Matthew Lee       9 D 10-30-2012 6.5 5.9 6.8 6.0 8.1
Elizabeth Garcia 10 C 10-29-2012 8.9 7.9 8.5 9.0 8.8
Lori Newcombe     6 D 10-30-2012 6.7 5.6 4.9 5.2 6.1
Jose Martinez     7 d 10-31-2012 8.9 9.510.0 9.7 9.0
Brian Williams   11 C 10-29-2012 7.8 8.4 8.5 7.9 8.0
;
run;

proc print data=perTab.informants;
run;	


data perTab.time;
input Time STIMER11. Num COMMA10.;
datalines;
10:25:36.52 4,065,493
;
run;
proc print data=perTab.time;
run;	


data perTab.mix; /* Name is read with column style input, State and Year are read with
list style input, and Acreage is read with formatted style input.*/
INPUT ParkName $ 1-22 State $ Year @38 Acreage COMMA10.;
datalines;
Yellowstone           ID/MT/WY 1872   4,065,493
Everglades            FL 1934         1,398,800
Yosemite              CA 1864           760,917
Great Smoky Mountains NC/TN 1926        520,269
Wolf Trap Farm        VA 1966               130
;
run;
proc print data=perTab.mix;
run;	


data perTab.messy;
input @'School:' School $ @'Time:' Time STIMER11.;
datalines;
Bellatorum  School: CSULA Time: 1:40.5
The Kraken  School: ASU Time: 1:45.35
Black Widow School: UoA Time: 1:33.7
Koicrete  School: CSUF Time: 1:40.25
Khaos School: UNLV Time: 2:03.45
Max School: UCSD Time: 1:26.47
Hakuna Matata School: UCLA Time: 1:20.64
Prospector  School: CPSLO Time: 1:12.08
Andromeda School: CPP Time: 1:25.1
Kekoapohaku School: UHM Time: 1:24.49
;
run;
proc print data=perTab.messy;
run;	

data perTab.multipleLines;
input Name $ State $ / A B / C D;
datalines;
Nome AK
55 44
88 29
Miami FL 
90 75
97 65
Raleigh NC 
88 68
105 50
;
run;
proc print data=perTab.multipleLines;
run;	

data perTab.multipleLines2;
input Name $ State $ Num1 Num2 @@;
datalines;
Nome AK 2.5 15 Miami FL 6.75
18 Raleigh NC . 12
;
run;
proc print data=perTab.multipleLines2;
run;	

data perTab.readPart;
input Name $ @;
*If Name = 'surface ' THEN delete;
if name = 'freeway' Then input NameStreet $ 9-37 Avg1 Avg2;
Else delete;
datalines;
freeway 408                          3684 3459
surface Martin Luther King Jr. Blvd. 1590 1234
surface Broadway                     1259 1290
surface Rodeo Dr.                    1890 2067
freeway 608                          4583 3860
freeway 808                          2386 2518
surface Lake Shore Dr.               1590 1234
surface Pennsylvania Ave.            1259 1290
;
run;
proc print data=perTab.readPart;
run;	

/*
data perTab.options;
 infile firstobs=2;
datalines;
Ice-cream sales data for the summer
Flavor Location Boxes sold
Chocolate 213 123
Vanilla 213 512
Chocolate 415 242
;
run;
proc print data=perTab.options;
run;	
*/

data perTab.delimitedData;
infile '/folders/myshortcuts/SASUniversityEdition/lecture1/Programming_1_Data/primitive_CSV.csv'
	dlm=',' dsd MISSOVER;
input Name :$30. Year :mmddyy10. Num1 Num2 Num3 Num4;
run;
proc print data=perTab.delimitedData;
run;	


/*  The example uses an informat to read the date, and a format to write the date.*/
data scores2;
   length Team $ 14;
   infile datalines delimiter=',';
   input Name $ Score1-Score3 Team $ Final_Date $ MMDDYYyy10.;
   format final_date weekdate17.;
   datalines;
Joe,11,32,76,Red Racers,2/3/2007
Mitchell,13,29,82,Blue Bunnies,4/5/2007
Susan,14,27,74,Green Gazelles,11/13/2007
;

proc print data=scores2;
   var Name Team Score1-Score3 Final_Date;
   title 'Soccer Player Scores'; 
run;

data work.HomeImp;
input Name $8. N2 $ 9-33 Prise COMMA9.2 ;
datalines;
Bob     kitchen cabinet face-lift  1253.00
Shirley bathroom addition         11350.70
Silvia  paint exterior                 .
Al      backyard gazebo            3098.63
Norm    paint interior              647.77
Kathy   second floor addition     75362.93
;
run;

data work.Dates;
input Name $11. +1 D1 mmddyy10. +1 D2 ANYDTDTE10. D3 date11. ;
datalines;
A. Jones    1-1-60     9-15-96    18JUN12
R. Grandage 03/18/1988 31 10 2007 5jul2012
K. Kaminaka 052903     2012024    12-MAR-12
;
run;
PROC PRINT DATA = Dates;
FORMAT D2 MMDDYY8. D3 WEEKDATE17.;
TITLE 'SAS Dates without and with Formats';
RUN;

data work.Dates;
input Name $8. Ag N1 N2 N3 N4 N5 ;
ARRAY hy (5) N1 - N5;
do i=1 to 5;
	if hy(i) = 9 then hy(i) = .;
end;
datalines;
Albany   54 3 9 4 4 9
Richmond 33 2 9 3 3 3
Oakland  27 3 9 4 2 3
Richmond 41 3 5 4 5 5
Berkeley 18 4 4 9 3 2
;
run;

data work.Sorting;
input Name $6. Add $ 7-23 N2 $ N3 $ ;
datalines;
Seiki 100 A St.        juneau alaska
Wong  2 A St.          Honolulu Hawaii
Shaw  10 A St. Apt. 10 Juneau Alaska
Smith 10 A St. Apt. 2  honolulu hawaii
;
run;
proc sort data=work.Sorting out=work.sorted 
SORTSEQ = LINGUISTIC (NUMERIC_COLLATION = ON);
BY Add N3;
run;

data work.Print;
input Name $ age date mmddyy10. N2 $ N3;
format date $ mmddyy10.;
Profit = n3 * 1.25;
datalines;
Adriana 21 3/21/2012 MP 7
Nathan 14 3/21/2012 CD 19
Matthew 14 3/21/2012 CD 14
Claire 14 3/22/2012 CD 11
Ian 21 3/24/2012 MP 18
Chris 14 3/25/2012 CD 6
Anthony 21 3/25/2012 MP 13
Erika 21 3/25/2012 MP 17
;
run;

PROC SORT DATA = Print;
BY age ;

PROC PRINT DATA = Print;
BY age ;
SUM PROFIT;
VAR Name date n2 Profit;
TITLE 'Candy Sales for Field Trip by Class';
RUN;









