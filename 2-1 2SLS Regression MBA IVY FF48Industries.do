cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

***2SLS using nubmer of board member with MBA, IVY-League uni degree, and aggregate different Fama-French 48 industries working Experiences for all board members.***

use "First Test OLS Sample data no winning years.dta", clear

*Isolate IVY-MBA from IVY League, to avoid double counting.
replace MBA_dum_sum =  MBA_dum_sum - IvyMBA_dum_sum

log using "2SLS Reg.smcl", replace

*without IV numIndustries_sum, significant at 5-10% level

***First stage
reghdfe totnumties_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)


reghdfe numcontract_ln  MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe renegotiation_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)


reghdfe expected_cost_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe total_cost_all_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe cost_overrun_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe expected_duration_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe final_duration_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe delay_ln MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe extra_cost MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)

reghdfe extra_delay MBA_dum_sum IVY_dum_sum numIndustries_sum gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)


***2SLS with GMM option
ivreghdfe numcontract_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe renegotiation_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe expected_cost_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe total_cost_all_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe cost_overrun_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe extra_cost gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe expected_duration_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe final_duration_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe delay_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s

ivreghdfe extra_delay gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_ln = MBA_dum_sum IVY_dum_sum  numIndustries_sum) , absorb(sic2 year) cluster(gvkey) gmm2s


log close

