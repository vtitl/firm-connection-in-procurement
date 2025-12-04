cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

***2SLS using nubmer of board member with MBA, IVY-League uni degree, and aggregate different Fama-French 48 industries working Experiences for all board members.***

use "First Test OLS Sample data no winning years.dta", clear

*Isolate IVY-MBA from IVY League, to avoid double counting.
replace MBA_dum_sum =  MBA_dum_sum - IvyMBA_dum_sum

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


gen totnumties_lnXhigh_complex = totnumties_ln * high_complex
gen MBA_dum_sumXhigh_complex = MBA_dum_sum * high_complex
gen IVY_dum_sumXhigh_complex = IVY_dum_sum * high_complex
gen numIndustries_sumXhigh_complex = numIndustries_sum * high_complex


reghdfe totnumties_lnXhigh_complex (c.MBA_dum_sum c.IVY_dum_sum c.numIndustries_sum)##i.high_complex gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp , absorb(sic2 year) cluster(gvkey)



ivreghdfe numcontract_ln high_complex totnumties_ln gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp (totnumties_lnXhigh_complex = MBA_dum_sum IVY_dum_sum  numIndustries_sum MBA_dum_sumXhigh_complex IVY_dum_sumXhigh_complex numIndustries_sumXhigh_complex) , absorb(sic2 year) cluster(gvkey) gmm2s















