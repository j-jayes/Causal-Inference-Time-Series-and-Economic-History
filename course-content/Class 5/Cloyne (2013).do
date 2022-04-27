*** Data Management ***

clear

cd "" /* set the directory where the data is saved */

import excel "Cloyne (2013).xlsx", sheet("Stata") firstrow /* import a spreadsheet */

gen Date = q(1948q1) + _n-1

tsset Date, quarterly /* declare that the data is quarterly */

gen y = 100*log(GDP/Population)
gen c = 100*log(Consumption/Population)
gen i = 100*log(Investment/Population)
gen t = _n
gen d = Exogenous * -1

* Determine the lag length using information criteria

varsoc y c i, maxlag(20) exog(t d l1.d l2.d l3.d l4.d l5.d l6.d l7.d l8.d l9.d l10.d l11.d l12.d)

* Estimate VAR

var y c i if tin(1955q1,2009q4), exog(t d l1.d l2.d l3.d l4.d l5.d l6.d l7.d l8.d l9.d l10.d l11.d l12.d) lags(1/4) 

irf create dm, step(16) set(irf, replace)

* Check for autocorrealtion

predict u_y, res equation(y)
predict u_c, res equation(c)
predict u_i, res equation(i)

tsline u_y u_c u_i

varlmar /* There is no autocorrelation */

* Reproduce figure 3

irf graph dm, response(y) impulse(d) irf(dm)
irf table dm, response(y) impulse(d) irf(dm)

* Reproduce figure 5a

irf graph dm, response(c) impulse(d) irf(dm)

* Reproduce figure 5b

irf graph dm, response(i) impulse(d) irf(dm)
