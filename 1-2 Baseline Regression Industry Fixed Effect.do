cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

***Baseline OLS Regressions

use "First Test OLS Sample data no winning years.dta", replace



log using "First Baseline Reg.smcl", replace

log on 

egen tie_p50 = pctile(totnumties), p(50)
gen tie_median = 1 if totnumties >= tie_p50
replace tie_median = 0 if tie_median==.

ttest expected_cost, by(tie_median)

ttest total_cost_all, by(tie_median)

ttest cost_overrun, by(tie_median)

ttest renegotiation, by(tie_median)

ttest expected_duration, by(tie_median)

ttest final_duration, by(tie_median)

ttest delay, by(tie_median)



foreach var in totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2  {
	
	
reghdfe numcontract_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)


reghdfe expected_cost_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe total_cost_all_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe cost_overrun_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe renegotiation_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe expected_duration_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe final_duration_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe delay_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe extra_cost_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe extra_delay_ln `var'_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)	
	

}


log close






