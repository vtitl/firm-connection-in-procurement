cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

***Baseline OLS Regressions

use "First Test OLS Sample data no winning years.dta", replace

*using number of connection in t-3

xtset gvkey year

log using "Reverse Causality extra tests.smcl", replace

log on

gen totnumties_ln3lag = L2.totnumties_ln


*board member connection lag 3 years
foreach var in numcontract_ln expected_cost_ln total_cost_all_ln cost_overrun_ln renegotiation_ln expected_duration_ln final_duration_ln delay_ln extra_cost extra_delay {

gen `var'_lag = L.`var'

reghdfe `var' totnumties_ln3lag gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)
}


*using baseline but adding a control for the previous award outcome
foreach var in numcontract_ln expected_cost_ln total_cost_all_ln cost_overrun_ln renegotiation_ln expected_duration_ln final_duration_ln delay_ln extra_cost extra_delay {

reghdfe `var' totnumties_ln `var'_lag gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

}

log off


**constant board
use "Extra test constant board.dta", clear

log on

*constant board regression (fewer observations)
foreach var in numcontract_ln expected_cost_ln total_cost_all_ln cost_overrun_ln renegotiation_ln expected_duration_ln final_duration_ln delay_ln extra_cost extra_delay {


reghdfe `var' totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

}

*constant board regression and adding a control for the previous award outcome
foreach var in numcontract_ln expected_cost_ln total_cost_all_ln cost_overrun_ln renegotiation_ln expected_duration_ln final_duration_ln delay_ln extra_cost extra_delay {
	
reghdfe `var' totnumties_ln `var'_lag gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

}


log close

























