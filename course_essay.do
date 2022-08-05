* Course essay 

clear
import delimited "data\df_sweden_changes.csv"

tsset year

* Should we use logs or levels?

corrgram cbr

* Q is the box ljung test statistic associated with lag 1, lag 1 and 2, lag 1 2 and 3. 
* Chi squared with 1 degree of freedom. small p-value means that 
* so we should use an AR model with 1 lag?

* can draw it differently 

ac cbr

* first one is different from zero. all others are within 95% ci

pac cbr

* cuts off after 1 lag.



* df tests

local varlist cbr cdr real_wage 

foreach var in `varlist'{
eststo dfuller `var'

}

esttab
