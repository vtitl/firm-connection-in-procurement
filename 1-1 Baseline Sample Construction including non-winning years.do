global OneDrivePath "D:\OneDrive - Universitat de Barcelona\Project-Board Networks and Procurement\Raw Datasets"

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "Renegotiation_only_parent_duns_matched gvkey boarid", clear

*create an 11-year period from 2008 to 2018
keep gvkey boardid duns
duplicates drop
expand 11
bysort _all: gen year = 2007 + _n

merge 1:m gvkey boardid duns year using "Renegotiation_only_parent_duns_matched gvkey boarid"
drop _m recipient_parent_duns cusip conm cik cusip8d boardname orgtype isin cusip6 zip name

foreach var in expected_cost total_cost_all {
	
	replace `var' = 0 if `var' == .
	
}

*lag connection, financial data, and board information.
replace year = year - 1

merge m:1 gvkey boardid year using "$OneDrivePath\3 overall number of connections data with no connection firms.dta"
keep if _m==3
drop _m

merge m:1 gvkey boardid year using "$OneDrivePath\3 emp firm year level connections data with no connection firms.dta"
keep if _m==3
drop _m

merge m:1 gvkey boardid year using "$OneDrivePath\3 edu firm year level connections data with no connection firms.dta"
keep if _m==3
drop _m

merge m:1 gvkey boardid year using "$OneDrivePath\3 clubs firm year level connections data with no connection firms.dta"
keep if _m==3
drop _m

/*excluding financial and highly regualated firms
merge m:1 gvkey year using "$OneDrivePath\firm financials YEARLY data 2000-2020.dta"
keep if _m==3
drop _m
*/

merge m:1 gvkey year using "$OneDrivePath\firm_yearly_data.dta"
keep if _m==3
drop _m

merge m:1 gvkey year using "$OneDrivePath\1 board size.dta"
keep if _m == 3
drop _m


merge m:1 gvkey boardid year using "$OneDrivePath\Firm Year GOV ARMY Historical Employment.dta"
drop if _m == 2
drop _m

replace gov_dum = 0 if gov_dum == .
replace army_dum = 0 if army_dum == .
replace gov_num = 0 if gov_num == .
replace army_num = 0 if army_num == .

save "First test Board connections only parent duns zero in non winning year", replace


***construct baseline REG sample
use "First test Board connections only parent duns zero in non winning year", clear

***sum total for all winning contracts in a given year****
bysort gvkey boardid duns year: egen numcontract = total(award_id_piid != "")

foreach var in expected_cost total_cost_all {

bysort gvkey boardid duns year: ereplace `var' = total(`var')

}

foreach var in modification renegotiation expected_duration final_duration cost_overrun delay{

bysort gvkey boardid duns year: ereplace `var' = total(`var') if numcontract != 0

}

drop award_id_piid

duplicates drop

gen extra_cost = cost_overrun/expected_cost if cost_overrun != .

gen extra_delay = delay/expected_duration if delay != .

foreach var in totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2{
	
gen `var'_ln = ln(`var' + 1)
gen `var'_asinh = asinh(`var')

gen `var'_emp_ln = ln(`var'_emp + 1)
gen `var'_emp_asinh = asinh(`var'_emp)

gen `var'_edu_ln = ln(`var'_edu + 1)
gen `var'_edu_asinh = asinh(`var'_edu)

gen `var'_clubs_ln = ln(`var'_clubs + 1)
gen `var'_clubs_asinh = asinh(`var'_clubs)

}



foreach var in modification renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay numcontract extra_cost extra_delay{
	
gen `var'_ln = ln(`var' + 1)
gen `var'_asinh = asinh(`var')
	
}


gen sic2 = int(sic/100)

replace independent_board =  independent_board/boardsize

gen boardsize_ln = ln(boardsize+1)

gen boardsize_asinh = asinh(boardsize)

gen gov_num_ln = ln(gov_num + 1)

gen gov_num_asinh = asinh(gov_num)

gen army_num_ln = ln(army_num + 1)

gen army_num_asinh = asinh(army_num)

save "First Test OLS Sample data no winning years.dta", replace


***Board Human capital
use "$OneDrivePath\XX Director Human Capital firm year director level.dta", clear

foreach var in numFirms numPositions numIndustries numSICIndustries numCEOexps numCong4d{
bysort gvkey year boardid: egen `var'_sum = sum(`var')
}

keep gvkey year boardid numFirms_sum numPositions_sum numIndustries_sum numSICIndustries_sum numCEOexps_sum numCong4d_sum

bysort _all: keep if _n==1

merge 1:1 gvkey year boardid using "First Test OLS Sample data no winning years.dta"
drop if _m == 1

drop _m

foreach var in numFirms numPositions numIndustries numSICIndustries numCEOexps numCong4d{
replace `var'_sum = 0 if `var'_sum == .
}

save "First Test OLS Sample data no winning years.dta", replace

use "$OneDrivePath\XX Directors MBA and IVY Hiring firm year director level.dta", clear

gen highDegree_dum = 1 if MBA_dum == 1 | graduate_dum == 1
replace highDegree_dum = 0 if highDegree_dum == .

foreach var in MBA_dum IVY_dum IvyMBA_dum graduate_dum highDegree_dum{
bysort gvkey year boardid: egen `var'_sum = sum(`var')
}

keep gvkey year boardid MBA_dum_sum IVY_dum_sum IvyMBA_dum_sum graduate_dum_sum highDegree_dum_sum

bysort _all: keep if _n==1

merge 1:1 gvkey year boardid using "First Test OLS Sample data no winning years.dta"
drop if _m == 1

drop _m

foreach var in MBA_dum IVY_dum IvyMBA_dum graduate_dum highDegree_dum{
replace `var'_sum = 0 if `var'_sum == .
}

save "First Test OLS Sample data no winning years.dta", replace