cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

*use "DiD Death Retirement Treat and non-Death SIC 1 Controls Sample.dta", clear
*only death
use "DiD Death Treat and non-Death SIC 1 Controls Sample.dta", clear

gen sic2 = int(sic/100)
gen sic1 = int(sic/1000)
gen boardsize_ln = ln(boardsize+1)

*keep those events where both treat and control exist
bysort numEvent gvkey: gen temp = _n == 1
bysort numEvent: egen num_unique_firms = total(temp) 
drop if num_unique_firms == 1
drop num_unique_firms temp

*at least one observation before and after the event
bysort numEvent gvkey: gen preperiod = 1 if timing < 0
bysort numEvent gvkey: ereplace preperiod = max(preperiod)
bysort numEvent gvkey: gen postperiod = 1 if timing >= 0
bysort numEvent gvkey: ereplace postperiod = max(postperiod)
keep if preperiod ==1 & postperiod == 1

/*
Keep all pre period works better
replace Post3 = 0 if timing == -4

replace Post2 = 0 if timing == -4 | timing == -3

replace Post1 = 0 if timing == -4 | timing == -3 | timing == -2
*/



*log using "Clean Death and Retirement not complete events DiD SIC1.smcl", replace
*only death
log using "Clean Death not complete events DiD SIC1.smcl", replace

log on




reghdfe totnumties_ln ib0.timing_pos##i.Treat , absorb(EventFirmFE) vce(cluster gvkey)

coefplot, keep(*timing_pos#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
    xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Total Number of Ties") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)

	
	
foreach var in numcontract modification renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay extra_cost extra_delay {	

reghdfe `var'_ln ib4.timing_pos##i.Treat , absorb(EventFirmFE) vce(cluster gvkey)

coefplot, keep(*timing_pos#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
    xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on `var'") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)

	
}



foreach var in numcontract modification renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay extra_cost extra_delay {
	
	reghdfe `var'_ln i.Treat##i.Post4 , absorb(EventFirmFE) vce(cluster gvkey)
	
		
	reghdfe `var'_ln i.Treat##i.Post3 , absorb(EventFirmFE) vce(cluster gvkey)
	
		
	reghdfe `var'_ln i.Treat##i.Post2 , absorb(EventFirmFE) vce(cluster gvkey)
	

	reghdfe `var'_ln i.Treat##i.Post1 , absorb(EventFirmFE) vce(cluster gvkey)

	
}


log close





