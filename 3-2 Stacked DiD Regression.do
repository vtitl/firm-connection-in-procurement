clear all

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "First Test DiD Board connections only parent duns REG SAMPLE", clear

*Keep those events contain at least one observation before and one observation after the event.
bysort numEvent: gen pre = 1 if year < year_DR
bysort numEvent: ereplace pre = max(pre)
bysort numEvent: gen postdum = 1 if year >= year_DR
bysort numEvent: ereplace postdum = max(postdum)
keep if pre == 1 & postdum == 1

***different post dummy
gen post3 = post
replace post3 = . if timing == 8 | timing == 0
gen post2 = post
replace post2 = . if timing == 8 | timing == 0 | timing == 7 | timing == 1
gen post1 = post
replace post1 = . if timing == 8 | timing == 0 | timing == 7 | timing == 1 | timing == 6 | timing == 2

*Parallel Trends
reghdfe totnumties_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
    xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Total Number of Ties") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)

	
reghdfe numcontract_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Number of Contracts") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)	
	
reghdfe renegotiation_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Times of Renegotiations") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)	
	
	
reghdfe expected_cost_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Expected Cost") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)
	
reghdfe total_cost_all_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Total Cost") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)
	
reghdfe expected_duration_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Expected Duration") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)
	
reghdfe final_duration_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Total Duration") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)

	
reghdfe cost_overrun_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)
	
coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Cost Overrun") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)
	
reghdfe delay_ln ib4.timing##i.Treat gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

coefplot, keep(*timing#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
	xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Delay") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)
	


*Final Regressions

log using "Stacked Deaths and Retirements binary and continous Treatment DiD.smcl", replace

log on

**Binary Treat, no control variables
foreach var in numcontract renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay extra_cost extra_delay{
	
reghdfe `var'_ln i.Treat##i.post, abs(gvkey directorid year) vce(cluster gvkey)

}

*Binary Treat with control variables
foreach var in numcontract renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay extra_cost extra_delay{
	
reghdfe `var'_ln i.Treat##i.post gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

}

*Continuous Treat (the number of connection that the died or retired board member had), no control variables
gen totnumties_DR_ln = ln(totnumties_DR+1)

foreach var in numcontract renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay extra_cost extra_delay{
	
reghdfe `var'_ln c.totnumties_DR_ln##i.post, abs(gvkey directorid year) vce(cluster gvkey)

}

*Continuous Treat (the number of connection that the died or retired board member had) with control variables
foreach var in numcontract renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay extra_cost extra_delay{
	
reghdfe `var'_ln  c.totnumties_DR_ln##i.post gov_dum boardsize_ln independent_board firm_size firm_age cash ppe_assets profitability HHI capex_at emp, abs(gvkey directorid year) vce(cluster gvkey)

}

log close







