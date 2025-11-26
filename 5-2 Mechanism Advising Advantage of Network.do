
cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "First Test OLS Sample data no winning years.dta", clear

merge 1:1 gvkey year using  "1-number of segments.dta"

drop if _m == 2
drop _m 

merge 1:1 gvkey year using  "1-cash volatility and sale growth.dta"

drop if _m == 2
drop _m 

*Amin et al. 2020 JCF complexity
pca nsegments_4d firm_size firm_age leverage_val
predict pc1 pc2 pc3 pc4
drop pc2 pc3 pc4
rename pc1 complexity

*Change and Wu 2020 MS complexity (RandD is not a good measure)
pca nsegments_4d cf_vol RandD
predict pc1 pc2 pc3
drop pc2 pc3
rename pc1 complexity_alt1


*Coles et al. JFE 2008 complexity
pca nsegments_4d firm_size leverage_val
predict pc1 pc2 pc3
drop pc2 pc3
rename pc1 complexity_alt2

*Faleye JFE 2007 complexity (he use RandD and then check with the following alternative)
pca sale_growth firm_size ppe_assets
predict pc1 pc2 pc3
drop pc2 pc3
rename pc1 complexity_alt3


*our final complexity measure: number of segment, cash volatility, ppe_assets
pca nsegments_4d cf_vol ppe_assets 
predict pc1 pc2 pc3  
drop pc2 pc3  
rename pc1 complexity_final



*dummy for the final PCA
sum complexity_final, d
gen high_complex = 1 if complexity_final >= r(p50)
replace high_complex = 0 if high_complex == .


log using "Mechanism-Advising-Complexity.smcl", replace

log on

*****************************
*split sample analysis by Complexity. The more complex the firm the stronger the advicing effect from the networks 
foreach var in numcontract_ln renegotiation_ln expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay{
	

display "High Complexity PCA"	
reghdfe `var' c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp if high_complex == 1, abs(sic2 year) vce(cluster gvkey)
reghdfe `var' c.totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp if high_complex == 0, abs(sic2 year) vce(cluster gvkey)




}

****************
*Interaction with dummy and continuous complexity variable

foreach var in numcontract_ln renegotiation_ln expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay{

reghdfe `var' c.totnumties_ln##i.high_complex gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

reghdfe `var' c.totnumties_ln##c.complexity_final gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , abs(sic2 year) vce(cluster gvkey)

	
}	

*****************************************
*Suest test or Fisher permutation test
tabulate sic2, generate(ind_)
tabulate year, generate(year_)



foreach var in numcontract_ln renegotiation_ln expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay{
	
display "`var'"	

bdiff, group(high_complex) model(reg `var' totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp ind_1 ind_2 ind_3 ind_4 ind_5 ind_6 ind_7 ind_8 ind_9 ind_10 ind_11 ind_12 ind_13 ind_14 ind_15 ind_16 ind_17 ind_18 ind_19 ind_20 ind_21 ind_22 ind_23 ind_24 ind_25 ind_26 ind_27 ind_28 ind_29 ind_30 ind_31 ind_32 ind_33 ind_34 ind_35 ind_36 ind_37 ind_38 ind_39 ind_40 ind_41 ind_42 ind_43 ind_44 ind_45 ind_46 ind_47 ind_48 ind_49 ind_50 ind_51 ind_52 ind_53 ind_54 ind_55 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11) surtest


}

log close