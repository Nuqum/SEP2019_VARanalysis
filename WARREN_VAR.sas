LIBNAME _ALL_ CLEAR;

LIBNAME data 'C:/data/';
LIBNAME programs 'C:/programs/';

PROC IMPORT OUT= data.WARREN_VAR 
            DATAFILE= "C:\data\WARREN_IMPORT.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


DATA WORK_WARREN;
SET data.WARREN_VAR;
RUN;

PROC CONTENTS;
run;


/**** VECTOR AUTOGREGRESSION *****/

proc varmax data=WORK_WARREN;
id Date interval=daily;
model BIDEN_CHANGE Biden_TV / p=7 lagmax=8 print=(estimates diagnose roots) /*dify=(1)*/;
run;

proc varmax data=WORK_WARREN;
model WARREN_CHANGE Warren_TV /*Warren_Google_MA7*// p=7 lagmax=8 print=(estimates diagnose roots) /*dify=(1)*/;
run;

proc varmax data=WORK_WARREN;
model SANDERS_CHANGE Sanders_TV /*Sanders_Google_MA7*// p=7 lagmax=8 print=(estimates diagnose roots) /*dify=(1)*/;
run;

proc varmax data=WORK_WARREN;
model HARRIS_CHANGE Harris_TV /*Harris_Google_MA7*// p=7 lagmax=8 print=(estimates diagnose roots) /*dify=(1)*/;
run;


proc varmax data=WORK_WARREN;
model BUTTIGIEG_CHANGE Buttigieg_TV /*Buttigieg_Google*// p=7 lagmax=8 print=(estimates diagnose roots) /*dify=(1)*/;
run;


/**** STATIONARITY TEST *****/

PROC ARIMA data=WORK_WARREN;
 identify var=Biden stationarity=(adf=(7));
identify var=Sanders stationarity=(adf=(7));
identify var=Warren stationarity=(adf=(7));
identify var=Harris stationarity=(adf=(7));
identify var=Buttigieg stationarity=(adf=(7));
run;

PROC ARIMA data=WORK_WARREN;
 identify var=Biden stationarity=(adf=(2));
identify var=Sanders stationarity=(adf=(2));
identify var=Warren stationarity=(adf=(2));
identify var=Harris stationarity=(adf=(2));
identify var=Buttigieg stationarity=(adf=(2));
run;


proc corr data=WORK_WARREN;
var Biden Biden_TV BIDEN_CHANGE Warren Warren_TV WARREN_CHANGE Sanders Sanders_TV SANDERS_CHANGE Harris Harris_TV HARRIS_CHANGE;
run;


/***** BOX JENKINS ******/

proc arima data=WORK_WARREN;

   /*--- Look at the input process ----------------------------*/
   identify var=Biden_TV(1);
   run;

   /*--- Fit a model for the input ----------------------------*/
   estimate q=7 plot;
   run;

   /*--- Cross-correlation of prewhitened series ---------------*/
   identify var=BIDEN_CHANGE(1) crosscorr=(Biden_TV) nlag=14;
   run;

   /*--- Fit a simple transfer function - look at residuals ---
   estimate input=( 3 $ (1,2)/(1) x );
   run;

   /*--- Final Model - look at residuals ----------------------
   estimate p=2 input=( 3 $ (1,2)/(1) x );
   run; ----*/

quit;

/**** IMPULSE RESPONSE FUNCTIONS ******/

proc varmax data=WORK_WARREN plot=impulse;
id Date interval=daily;
model BIDEN_CHANGE Biden_TV /*Biden_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) /*dify=(1)*/;
run;


proc varmax data=WORK_WARREN plot=impulse;
model WARREN_CHANGE Warren_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) /*dify=(1)*/;
run;

proc varmax data=WORK_WARREN plot=impulse;
model Warren Warren_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) /*dify=(1)*/;
run;

proc varmax data=WORK_WARREN plot=impulse;
model Warren Warren_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;






proc varmax data=WORK_WARREN plot=impulse;
model SANDERS_CHANGE Sanders_TV /*Sanders_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) /*dify=(1)*/;
run;

proc varmax data=WORK_WARREN plot=impulse;
model HARRIS_CHANGE Harris_TV /*Harris_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) /*dify=(1)*/;
run;


proc varmax data=WORK_WARREN plot=impulse;
model BUTTIIEG_CHANGE Buttigieg_TV /*Buttigieg_Google*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) /*dify=(1)*/;
run;



/******* BEST MODELS *******/

proc varmax data=WORK_WARREN plot=impulse;
model Biden Biden_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;


proc varmax data=WORK_WARREN plot=impulse;
model Warren Warren_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_WARREN plot=impulse;
model Sanders Sanders_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_WARREN plot=impulse;
model Harris Harris_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;

proc varmax data=WORK_WARREN plot=impulse;
model Buttigieg Buttigieg_TV /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;




proc varmax data=WORK_WARREN plot=impulse;
model Warren Warren_TV Sanders /*Warren_Google_MA7*// p=7 lagmax=8 printform=univariate print=(impulsex=(all) estimates diagnose roots) dify=(1);
run;



