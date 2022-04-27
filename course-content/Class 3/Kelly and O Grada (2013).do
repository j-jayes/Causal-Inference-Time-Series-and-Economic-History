*** Data Management ***

clear

cd "" /* set the directory where the data is saved */

import excel "Kelly and O Grada (2013).xlsx", firstrow /* import a spreadsheet */

tsset Year, yearly /* declare that the data is a yearly time series */

drop G H I J /* drop erroneous variables */

gen RealGDPpc = RealGDP / Population
gen RealAgriculturalOutputpc = RealAgriculturalOutput / Population

foreach var in CrudeDeathRate RealWage RealGDPpc RealAgriculturalOutputpc {

gen Ln`var' = log(`var')

}

*** (Approximately) Reproduce Table 6 ***

reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealWage if tin(1546,1599)
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealWage if tin(1600,1649) 
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealWage if tin(1650,1699) 
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealWage if tin(1700,1749)
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealWage if tin(1750,1799)

reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealAgriculturalOutputpc if tin(1546,1599)
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealAgriculturalOutputpc if tin(1600,1649) 
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealAgriculturalOutputpc if tin(1650,1699) 
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealAgriculturalOutputpc if tin(1700,1749)
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealAgriculturalOutputpc if tin(1750,1799)  

reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealGDPpc if tin(1546,1599)
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealGDPpc if tin(1600,1649) 
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealGDPpc if tin(1650,1699) 
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealGDPpc if tin(1700,1749)
reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealGDPpc if tin(1750,1799)  

*** Evaluate the Residuals ***

reg d.LnCrudeDeathRate L(1/4)d.LnCrudeDeathRate L(0/4)d.LnRealGDPpc if tin(1546,1599)
predict Residuals if tin(1546,1599), res /* generate the residuals as a new variable */ 

tsline Residuals if tin(1546,1599) /* plot the residuals */

dfuller Residuals, trend regress /* determine that the residuals are stationary */
dfuller Residuals, regress
dfuller Residuals, noconstant regress

estat hettest /* test for heteroscedasticity in the residuals */

ac Residuals /* plot the autocorrelation of the residuals */

estat bgodfrey /* test for serial correlation in the residuals */

*** Finite distributed lag model *** 

reg d.LnCrudeDeathRate L(0/4)d.LnRealGDPpc if tin(1546,1599)

*** Local projections model ***

* Set parameters *

local impulse LnRealGDPpc
local response LnCrudeDeathRate
local lags 1

gen b_`response' = .
gen lo95_`response' = .
gen up95_`response' = .
gen se_`response' = .
gen h = _n - 1

forvalues i = 0/10 {
	  
      reg F`i'.`response' L(0/`lags').`impulse' L(1/`lags').`response' if tin(1546,1599)
	 
	  gen b_`response'_h`i' = _b[`impulse']
      gen se_`response'_h`i' = _se[`impulse']
 
      quietly replace b_`response' = b_`response'_h`i' if h==`i'
	  quietly replace lo95_`response' = b_`response'_h`i' - 1.96*se_`response'_h`i' if h==`i'
      quietly replace up95_`response' = b_`response'_h`i' + 1.96*se_`response'_h`i' if h==`i'
	  quietly replace se_`response' = se_`response'_h`i' if h==`i'
	  
}

br h b_`response' lo95_`response' up95_`response' se_`response' if h<=10

line b_`response' lo95_`response' up95_`response' h if h<=10
