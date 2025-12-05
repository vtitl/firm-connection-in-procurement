global OneDrivePath "D:\OneDrive - Universitat de Barcelona\Project-Board Networks and Procurement\Raw Datasets"

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "Renegotiation_only_parent_duns_matched gvkey boarid", clear
*rename fiscalyear year
*save, replace



keep gvkey boardid duns
duplicates drop
expand 11
bysort _all: gen year = 2007 + _n

merge 1:m gvkey boardid duns year using "Renegotiation_only_parent_duns_matched gvkey boarid"

drop _m cusip conm cik cusip8d boardname orgtype isin cusip6 zip name


foreach var in expected_cost total_cost_all {
	
	replace `var' = 0 if `var' == .
	
	
}

keep award_id_piid year modification renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay recipient_parent_duns duns gvkey 

duplicates drop

bysort gvkey duns year: egen numcontract = total(award_id_piid != "")


foreach var in expected_cost total_cost_all {

bysort gvkey duns year: ereplace `var' = sum(`var')

}

foreach var in modification renegotiation expected_duration final_duration cost_overrun delay{

bysort gvkey duns year: ereplace `var' = sum(`var') if numcontract != 0

}

drop award_id_piid

duplicates drop

gen extra_cost = cost_overrun/expected_cost

gen extra_delay = delay/expected_duration

*replace year = year - 1

merge 1:m gvkey year using "Board Death and Retirement SIC1 Control Stacked Data"
*only death
*merge 1:m gvkey year using "Board Death SIC1 Control Stacked Data"
keep if _m == 3
drop _m

gen timing_pos = timing + 4

gen Post4 = 1 if timing>=0
replace Post4 = 0 if Post4 ==.

gen Post3 = 1 if timing>=0 & timing<=3
replace Post3 = 0 if timing <0 & timing>=-3 


gen Post2 = 1 if timing>=0 & timing<=2
replace Post2 = 0 if timing <0 & timing>=-2 


gen Post1 = 1 if timing>=0 & timing<=1
replace Post1 = 0 if timing <0 & timing>=-1


egen EventFirmFE = group(numEvent gvkey)


foreach var in totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2 {


gen `var'_ln = ln(`var' + 1)

gen `var'_asinh = asinh(`var')



}

foreach var in modification renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay numcontract extra_cost extra_delay{
	
gen `var'_ln = ln(`var' + 1)

gen `var'_asinh = asinh(`var')
	
}



merge m:1 gvkey year using "$OneDrivePath\1 board size.dta"
keep if _m == 3
drop _m

joinby gvkey year using "$OneDrivePath\Firm Year GOV ARMY Historical Employment.dta", unmatched(master)

drop boardid
duplicates drop

replace gov_dum = 0 if gov_dum == .
replace army_dum = 0 if army_dum == .
replace gov_num = 0 if gov_num == .
replace army_num = 0 if army_num == .



save "DiD Death Retirement Treat and non-Death SIC 1 Controls Sample.dta", replace

*only death
*save "DiD Death Treat and non-Death SIC 1 Controls Sample.dta", replace