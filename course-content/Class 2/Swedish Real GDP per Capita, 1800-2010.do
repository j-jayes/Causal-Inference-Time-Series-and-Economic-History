*** Data Management ***

clear

cd "" /* set the directory where the data is saved */

import excel "Swedish Real GDP per Capita, 1800-2010.xlsx", sheet("Sheet1") firstrow /* import a spreadsheet */

tsset Year, yearly /* declare that the data is an annual time series */

gen ln_RealGDPperCapita = log(RealGDPperCapita)*100

*** Reproduce Figure 5 ***

tsfilter hp HP_Cycle_100 = ln_RealGDPperCapita, smooth(100) trend(HP_Trend_100)

tsline d.HP_Trend_100, ylabel(-0.5(0.5)4.5) xlabel(1800(20)2000)

*** Reproduce Figure 6 ***

tsfilter hp HP_Cycle_10000 = ln_RealGDPperCapita, smooth(10000) trend(HP_Trend_10000)

tsline d.HP_Trend_10000, ylabel(0(0.5)3.5) xlabel(1800(20)2000)

*** Comparison ***

* HP (lambda = 6.25)

tsfilter hp HP_Cycle_6 = ln_RealGDPperCapita, smooth(6.25) trend(HP_Trend_6)

* OLS 

reg ln_RealGDPperCapita Year
predict OLS_Lin_Trend, xb
predict OLS_Lin_Cycle, res

gen Year2 = Year^2
reg ln_RealGDPperCapita Year Year2
predict OLS_Nonlin_Trend, xb
predict OLS_Nonlin_Cycle, res

* Hamilton

reg ln_RealGDPperCapita L2.ln_RealGDPperCapita
predict Ham_Trend, xb
predict Ham_Cycle, res

tsline d.Ham_Cycle, ylabel(0(0.5)3.5) xlabel(1800(20)2000)


* Comparison (Trends)

label variable HP_Trend_6 "HP_Trend_6.25"
label variable HP_Trend_100 "HP_Trend_100"
label variable OLS_Lin_Trend "OLS_Lin_Trend"
label variable OLS_Nonlin_Trend "OLS_Nonlin_Trend"
label variable Ham_Trend "Ham_Trend"

tsline HP_Trend_6 HP_Trend_100 OLS_Lin_Trend OLS_Nonlin_Trend Ham_Trend

* Comparison (Cycles)

label variable HP_Cycle_6 "HP_Cycle_6.25"
label variable HP_Cycle_100 "HP_Cycle_100"
label variable OLS_Lin_Cycle "OLS_Lin_Cycle"
label variable OLS_Nonlin_Cycle "OLS_Nonlin_Cycle"
label variable Ham_Cycle "Ham_Cycle"

tsline HP_Cycle_6 HP_Cycle_100 OLS_Lin_Cycle OLS_Nonlin_Cycle Ham_Cycle

corr HP_Cycle_6 HP_Cycle_100 OLS_Lin_Cycle OLS_Nonlin_Cycle Ham_Cycle, means
