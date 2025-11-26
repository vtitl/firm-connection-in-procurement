global OneDrivePath "D:\OneDrive - Universitat de Barcelona\Project-Board Networks and Procurement\Raw Datasets"

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

******number of segment (measure diversity)
use "$OneDrivePath\Compustat Segments.dta",clear
rename *,lower
destring gvkey, replace
destring sic, replace
destring sics1, replace
destring sics2, replace
rename *,lower
keep gvkey datadate srcdate sics1 sics2 sic sales ias capxs naicsh naicss1 naicss2 naics ops dps
duplicates drop


*gen 3 digital primary sic
gen sics1_3d = int(sics1/10)

*gen 2 digital primary sic
gen sics1_2d = int(sics1/100)

*Definition of conglomerate: sales, total sector assets>0, 2d, 3d primary sic and 4d sic
*we can relax sales and total sector assets constraints

bysort gvkey datadate sics1: gen segments = _n==1 if sales > 0 & ias > 0 & sics1 != .

bysort gvkey datadate: gen nsegments_4d = sum(segments)

bysort gvkey datadate: ereplace nsegments_4d = max(nsegments_4d)


drop segments


bysort gvkey datadate sics1_3d: gen segments = _n==1 if sales > 0 & ias > 0 & sics1 != .

bysort gvkey datadate: gen nsegments_3d = sum(segments)
bysort gvkey datadate: ereplace nsegments_3d = max(nsegments_3d)

drop segments


bysort gvkey datadate sics1_2d: gen segments = _n==1 if sales > 0 & ias > 0 & sics1 != .

bysort gvkey datadate: gen nsegments_2d = sum(segments)
bysort gvkey datadate: ereplace nsegments_2d = max(nsegments_2d)

drop segments

gen year = year(datadate)


keep gvkey year nsegments_4d nsegments_3d nsegments_2d
duplicates drop

bysort gvkey year: ereplace nsegments_4d = max(nsegments_4d)
bysort gvkey year: ereplace nsegments_3d = max(nsegments_3d)
bysort gvkey year: ereplace nsegments_2d = max(nsegments_2d)
duplicates drop
save "1-number of segments.dta", replace


*******Cash Volatility and Sale growth
use "$OneDrivePath\compustat.dta", clear
* Step 1: compute alternative CF measure
gen cf_ibdp = ib + dp

* Step 2: construct final cash flow variable with fallback
gen cf_raw = oancf
replace cf_raw = cf_ibdp if missing(cf_raw)

* Step 3: scale by total assets
gen cf1 = cf_raw / at

rangestat (sd) cf_vol = cf1, by(gvkey) interval(fyear -9 0)

rangestat (sd) cf_vol_5yr = cf1, by(gvkey) interval(fyear -4 0)

sort gvkey fyear

by gvkey (fyear): gen year_gap = fyear - fyear[_n-1]

* Step 2: Calculate lagged sales for each firm
by gvkey (fyear): gen sale_lag = sale[_n-1] if year_gap == 1

* Step 3: Compute sales growth
gen sale_growth = (sale - sale_lag) / abs(sale_lag)

keep gvkey fyear cf_vol cf_vol_5yr sale_growth

duplicates drop

bysort gvkey fyear: gen n = _N
drop if sale_growth == . & n>1
drop n

destring gvkey, replace
rename fyear year

save "1-cash volatility and sale growth.dta", replace





/*
******Loughran_McDonald_Complexity
clear all
import delimited "$OneDrivePath\Loughran_McDonald_Complexity.csv", varnames(1) 
* Convert numeric YYYYMMDD to Stata date
gen date_var = date(string(filingdate, "%10.0f"), "YMD")
* Format the new variable to display nicely
format date_var %td

gen year = year(date_var)

joinby cik using "$OneDrivePath\XX duns-gvkey-boardid.dta" 

keep gvkey boardid year complexity log_netfilesize

duplicates drop

*108 firms have complexity measure both in the beginning of the year and the end of year, we take the average.
bysort gvkey boardid year: ereplace complexity  = mean(complexity)
bysort gvkey boardid year: ereplace log_netfilesize  = mean(log_netfilesize)
duplicates drop

rename complexity complexity_LM
rename log_netfilesize log_netfilesize_LM

save "Matched Loughran_McDonald_Complexity.dta", replace
*/