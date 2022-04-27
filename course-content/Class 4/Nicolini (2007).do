*** Data Management ***

clear

cd "" /* set the directory where the data is saved */

import excel "Nicolini (2007).xlsx", sheet("Sheet1") firstrow /* import a spreadsheet */

tsset Year, yearly /* declare that the data is yearly */

rename CrudeBirthRate CBR
rename CrudeDeathRate CDR
rename CrudeMarriageRate CMR

gen W = log(RealWage)

gen D1557 = 0
replace D1557 = 1 if Year == 1557

gen D1558 = 0
replace D1558 = 1 if Year == 1558

gen D1559 = 0
replace D1559 = 1 if Year == 1559

gen D1563 = 0
replace D1563 = 1 if Year == 1563

gen D1603 = 0
replace D1603 = 1 if Year == 1603

gen D1625 = 0
replace D1625 = 1 if Year == 1625

gen D1658 = 0
replace D1658 = 1 if Year == 1658

gen D1659 = 0
replace D1659 = 1 if Year == 1659

gen D1665 = 0
replace D1665 = 1 if Year == 1665

gen D1681 = 0
replace D1681 = 1 if Year == 1681

gen D1728 = 0
replace D1728 = 1 if Year == 1728

gen D1729 = 0
replace D1729 = 1 if Year == 1729

* Determine the lag length using information criteria

varsoc CBR CDR W CMR, maxlag(10) exog(D1557 D1558 D1559 D1563 D1603 D1625 D1658 D1659 D1665 D1681 D1728 D1729)

* Estimate VAR

var CBR CDR W CMR, exog(D1557 D1558 D1559 D1563 D1603 D1625 D1658 D1659 D1665 D1681 D1728 D1729) lags(1/4)

* Compare results to OLS estimation of individual equations

reg CBR L(1/4).CBR L(1/4).CDR L(1/4).W L(1/4).CMR D1557 D1558 D1559 D1563 D1603 D1625 D1658 D1659 D1665 D1681 D1728 D1729

* Check for autocorrealtion

var CBR CDR W CMR, exog(D1557 D1558 D1559 D1563 D1603 D1625 D1658 D1659 D1665 D1681 D1728 D1729) lags(1/4)

irf create irf, step(10) set(irf, replace)

predict u_CBR, res equation(CBR)
predict u_CDR, res equation(CDR)
predict u_W, res equation(W)
predict u_CMR, res equation(CMR)

tsline u_CBR u_CDR u_W u_CMR

varlmar /* There is autocorrelation between u(t) and u(t-1) and u(t-2) */

* Reproduce figure 3

irf graph oirf, response(CDR) impulse(W) /* note that the shock is 1 standard deviation */
irf graph irf, response(CDR) impulse(W) /* note that the shock is 1 unit */

/* The irfs are very similar. The condifence intervals are slightly different. Nicolini's are bootstrapped */

* Reproduce table 2

irf table cirf, response(CBR CDR W) impulse(CBR CDR W) /* Nicolini normalises his cirfs as the series are in levels */
 
* Reproduce table 3

irf table fevd, response(CBR) impulse(CBR CDR W)
