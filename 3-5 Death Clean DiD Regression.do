cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "DiD Death Retirement Treat and non-Death SIC 1 Controls Sample.dta", clear
*only death
*use "DiD Death Treat and non-Death SIC 1 Controls Sample.dta", clear

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



log using "Clean Death and Retirement not complete events DiD SIC1.smcl", replace
*only death
*log using "Clean Death not complete events DiD SIC1.smcl", replace

log on

/*
replace totnumties = totnumties - totnumties_DR if timing == 0 //excluding the connections that the died or retired member had in the event year.
replace totnumties_ln = ln(totnumties + 1)
*/


reghdfe totnumties_ln ib4.timing_pos##i.Treat , absorb(EventFirmFE) vce(cluster gvkey)

coefplot, keep(*timing_pos#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
    xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on the Total Number of Ties") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)

matrix list e(b)
honestdid, pre(13 15 17 19) post( 23 25 27 29) mvec(0(0.5)2) coefplot `plotopts'	
		
	
foreach var in numcontract modification_ln renegotiation expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay {	

reghdfe `var' ib4.timing_pos##i.Treat , absorb(EventFirmFE) vce(cluster gvkey)

coefplot, keep(*timing_pos#*Treat) vertical baselevels recast(connected) ciopts(recast(rcap)) ///
    xlabel(1 "Year -4" 2 "Year -3" 3 "Year -2" 4 "Year -1"  ///
           5 "Year 0" 6 "Year +1" 7 "Year +2" 8 "Year +3"  ///
           9 "Year +4", ///
           angle(45)) ///
    yline(0, lpattern(dash)) ///
    title("Parallel Trends") xtitle("Event Time") ytitle("Effect on `var'") ///
    graphregion(color(white)) bgcolor(white) scheme(s1mono)

	
}



foreach var in numcontract modification_ln renegotiation expected_cost_ln total_cost_all_ln expected_duration_ln final_duration_ln cost_overrun_ln delay_ln extra_cost extra_delay {
	
	reghdfe `var' i.Treat##i.Post4 , absorb(EventFirmFE) vce(cluster gvkey)
	
		
	reghdfe `var' i.Treat##i.Post3 , absorb(EventFirmFE) vce(cluster gvkey)
	
		
	reghdfe `var' i.Treat##i.Post2 , absorb(EventFirmFE) vce(cluster gvkey)
	

	reghdfe `var' i.Treat##i.Post1 , absorb(EventFirmFE) vce(cluster gvkey)

	
}


log close





