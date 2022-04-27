*** Data Management ***

cd "" /* set the directory where the data is saved */
import excel "Okun's Law.xlsx", sheet("Sheet1") firstrow /* import a spreadsheet */
drop F G H I /* drop redundant variables */
tsset Year, yearly /* declare that the data is an annual time series*/

*** Regression ***

reg RealGDPGrowth ChangeinUnemploymentRate
