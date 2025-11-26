cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "First Test OLS Sample data no winning years.dta", clear

merge 1:1 boardid year using "CEO Chairman Dual role 2000 to 2019.dta"

drop if _m == 2

drop _m

replace CEO_Chairman = 0 if CEO_Chairman == .

merge 1:1 boardid year using "CEO Age 2000 to 2019.dta"

drop if _m == 2
drop _m

sum CEO_age, d
gen old_CEO = 1 if CEO_age >= r(p50) & CEO_age != .
replace old_CEO = 0 if CEO_age < r(p50) & CEO_age != .

log using "Mechanism-Monitoring-Agency-Conflict.smcl", replace

log on

*****************************
*split sample analysis by agency conflict 

**CEO Chairman Dual Roles, Need more monitoring from the network of the other board members.
*Thus, when the CEO is also the Chairman, board networks have a stronger effect.
foreach var in numcontract_ln renegotiation_ln expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay{
	
display "CEO_Chairman Dual Role (need monitoring)"	
reghdfe `var' totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp if CEO_Chairman == 1, abs(sic2 year) vce(cluster gvkey)
reghdfe `var' totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp if CEO_Chairman == 0, abs(sic2 year) vce(cluster gvkey)

}

foreach var in numcontract_ln renegotiation_ln expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay{
	
display "CEO_Chairman Dual Role (need monitoring)"	
reghdfe `var' c.totnumties_ln##i.CEO_Chairman gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(sic2 year) vce(cluster gvkey)

}



*Suest Test
tabulate sic2, generate(ind_)
tabulate year, generate(year_)

foreach var in numcontract_ln renegotiation_ln expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay{
	
display "`var'"	

bdiff, group(CEO_Chairman) model(reg `var' totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp ind_1 ind_2 ind_3 ind_4 ind_5 ind_6 ind_7 ind_8 ind_9 ind_10 ind_11 ind_12 ind_13 ind_14 ind_15 ind_16 ind_17 ind_18 ind_19 ind_20 ind_21 ind_22 ind_23 ind_24 ind_25 ind_26 ind_27 ind_28 ind_29 ind_30 ind_31 ind_32 ind_33 ind_34 ind_35 ind_36 ind_37 ind_38 ind_39 ind_40 ind_41 ind_42 ind_43 ind_44 ind_45 ind_46 ind_47 ind_48 ind_49 ind_50 ind_51 ind_52 ind_53 ind_54 ind_55 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11) surtest

}


log close