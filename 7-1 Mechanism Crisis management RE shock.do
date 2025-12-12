clear all

global OneDrivePath "D:\OneDrive - Universitat de Barcelona\Project-Board Networks and Procurement\Raw Datasets"

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "$OneDrivePath\compustat.dta", clear
drop if fyear<2000
keep gvkey fyear addzip
destring gvkey, replace
rename fyear year
rename addzip zip
duplicates drop

merge 1:1 gvkey year using "First Test OLS Sample data no winning years.dta"

keep if _m ==3
drop _m

drop county

rename zip fivedigitzipcode
merge m:1 year fivedigitzipcode using "$OneDrivePath\hpi_at_zip5.dta"

keep if _m == 3
drop _m

gen RE_shock = 1 if annualchange < 0
replace RE_shock = 0 if annualchange >= 0

bysort gvkey year: egen RE_shock_max = max(RE_shock)

bysort gvkey year: keep if RE_shock_max == RE_shock

*drop countyname fipscode classfp annualchange hpi hpiwith1990base hpiwith2000base RE_shock_max
drop hpi hpiwith1990base hpiwith2000base

*egen county_num = group(county)
egen zip_num = group(fivedigitzipcode)
*egen county_num = group(abbreviation)

duplicates drop gvkey year, force

save "RE shock no winning years.dta", replace

use "RE shock no winning years.dta", clear

quietly sum ppe_assets, d

gen High_RE = 1 if ppe_assets >= r(p75)
replace High_RE = 0 if ppe_assets < r(p75)


quietly sum leverage_val, d

gen High_Lev = 1 if leverage_val >= r(p50)
replace High_Lev = 0 if leverage_val < r(p50)

quietly sum annualchange, d

gen RE25shock = 1 if annualchange < r(p25)
replace RE25shock = 0 if annualchange >= r(p25)

log using "Mechanism-Crisis-Control.smcl", replace

log on
**********
*Mechanism: crisis management
**********
*RE shock procurement

	
reghdfe numcontract_ln RE_shock totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)


reghdfe expected_cost_ln i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe total_cost_all_ln i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe cost_overrun_ln i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe renegotiation_ln i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe expected_duration_ln i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe final_duration_ln i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe delay_ln i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe extra_cost i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe extra_delay i.RE_shock c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

***RE shock##connection	
reghdfe numcontract_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)


reghdfe expected_cost_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe total_cost_all_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe cost_overrun_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe renegotiation_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe expected_duration_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe final_duration_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe delay_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe extra_cost i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe extra_delay i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)	


*firm year fixed effect
reghdfe numcontract_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)


reghdfe expected_cost_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe total_cost_all_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe cost_overrun_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe renegotiation_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe expected_duration_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe final_duration_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe delay_ln i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe extra_cost i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe extra_delay i.RE_shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)	


*lower than 25%, that is -2.77

reghdfe numcontract_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)


reghdfe expected_cost_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe total_cost_all_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe cost_overrun_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe renegotiation_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe expected_duration_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe final_duration_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe delay_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe extra_cost i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)

reghdfe extra_delay i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(zip_num sic2 year) vce(cluster gvkey)	


*firm year fixed effect
reghdfe numcontract_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)


reghdfe expected_cost_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe total_cost_all_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe cost_overrun_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe renegotiation_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe expected_duration_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe final_duration_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe delay_ln i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe extra_cost i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)

reghdfe extra_delay i.RE25shock##c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(gvkey year) vce(cluster gvkey)	


log close










