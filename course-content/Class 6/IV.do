*** Data Management ***

clear

cd "C:\Users\ekh-jsl\Dropbox\Teaching\Lund\Causal Inference, Time Series and Economic History\Causal Inference, Time Series and Economic History\Class 6" /* set the directory where the data is saved */

import excel "IV.xlsx", sheet("Data") firstrow /* import a spreadsheet */

gen Date = m(1945m1) + _n-1

gen LnIndustrialProduction = log(IndustrialProduction)

tsset Date, monthly /* declare that the data is a monthly time series */

local controls l.LnIndustrialProduction l2.LnIndustrialProduction l3.LnIndustrialProduction l.FederalFundsRate  l2.FederalFundsRate l3.FederalFundsRate D1-D11 

*** 2SLS ***

ivreg LnIndustrialProduction (FederalFundsRate = MonetaryShock) `controls' if tin(1955m1,1990m12), first

*** OLS ***

reg FederalFundsRate MonetaryShock `controls' if tin(1955m1,1990m12)

predict Fitted, xb

test MonetaryShock

reg LnIndustrialProduction Fitted `controls' if tin(1955m1,1990m12)