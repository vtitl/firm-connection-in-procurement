clear all
global OneDrivePath "D:\OneDrive - Universitat de Barcelona\Project-Board Networks and Procurement\Raw Datasets"

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

use "$OneDrivePath\5-All Board Member Deaths and Retirements Connections Information.dta", clear
*only death
*use "$OneDrivePath\5-All Board Member Deaths Connections Information.dta", clear


bysort gvkey boardid directorid (date_DR): keep if _n == _N

*our sample period
keep if year >= 2008 & year <= 2018
*Event id numEvent for each retirement and death.
gsort gvkey boardid boardname year_DR directorid directorname date_DR
gen numEvent = _n


*number of connection above the median is the treatment
quietly sum totnumties,d

gen Treat = 1 if totnumties >= r(p50)

replace Treat = 0 if totnumties < r(p50)


global connection_DR totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2

foreach var in $connection_DR{
	
	rename `var' `var'_DR
	
}
duplicates drop

expand 9

bysort gvkey boardid boardname year_DR year directorid directorname date_DR Treat numEvent death_dum: replace year = year - 5 + _n

*drop if year < 2007

*drop if year > 2018

duplicates drop

save "6-Deaths and Retirements Treat and Control Stacked Sample.dta", replace



***Merge procurement data with Death and Retirement DiD stack Sample

use "Renegotiation_only_parent_duns_matched gvkey boarid", clear

keep gvkey boardid duns
duplicates drop
expand 11
bysort _all: gen year = 2007 + _n

merge 1:m gvkey boardid duns year using "Renegotiation_only_parent_duns_matched gvkey boarid"

drop _m recipient_parent_duns cusip conm cik cusip8d boardname orgtype isin cusip6 zip name


foreach var in expected_cost total_cost_all {
	
	replace `var' = 0 if `var' == .
	
	
}


merge m:1 gvkey boardid year using "$OneDrivePath\3 overall number of connections data with no connection firms.dta"

keep if _m==3

drop _m 


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

save "First Test DiD Board connections only parent duns", replace



use "First Test DiD Board connections only parent duns", clear

***aggregate all winning contracts in a given year****
bysort gvkey boardid duns year: egen numcontract = total(award_id_piid != "")


foreach var in expected_cost total_cost_all {

bysort gvkey boardid duns year: ereplace `var' = sum(`var')

}

foreach var in modification renegotiation expected_duration final_duration cost_overrun delay{

bysort gvkey boardid duns year: ereplace `var' = sum(`var') if numcontract != 0

}

drop award_id_piid

duplicates drop

gen extra_cost = cost_overrun/expected_cost

gen extra_delay = delay/expected_duration


foreach var in totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2 {

gen `var'_ave = `var'/boardsize

gen `var'_ln = ln(`var' + 1)

gen `var'_asinh = asinh(`var')

gen `var'_ave_ln = ln(`var'_ave + 1)


}


foreach var in renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay numcontract extra_cost extra_delay{
	
gen `var'_ln = ln(`var' + 1)

gen `var'_asinh = asinh(`var')
	
}


foreach var in renegotiation expected_cost total_cost_all expected_duration final_duration cost_overrun delay extra_cost extra_delay{
	
gen `var'_ave = `var'/numcontract

gen `var'_ave_ln = ln(`var'_ave + 1)
	
}


gen sic2 = int(sic/100)


replace independent_board =  independent_board/boardsize

gen boardsize_ln = ln(boardsize+1)

gen boardsize_asinh = asinh(boardsize)

gen gov_num_ln = ln(gov_num + 1)

gen gov_num_asinh = asinh(gov_num)

gen army_num_ln = ln(army_num + 1)

gen army_num_asinh = asinh(army_num)

save "First Test DiD Board connections only parent duns REG SAMPLE", replace


***Merge DiD sample with procurement data
use "6-Deaths and Retirements Treat and Control Stacked Sample.dta", clear

duplicates drop

gen post = 1 if year >= year_DR
replace post = 0 if post == .

merge m:1 gvkey boardid year using "First Test DiD Board connections only parent duns REG SAMPLE"

keep if _m == 3

drop _m

gen timing = year - year_DR + 4

save "First Test DiD Board connections only parent duns REG SAMPLE", replace


***Human capital
use "$OneDrivePath\XX Director Human Capital firm year director level.dta", clear

foreach var in numFirms numPositions numIndustries numCEOexps numCong4d{
bysort gvkey year boardid: egen `var'_sum = sum(`var')
}

keep gvkey year boardid numFirms_sum numPositions_sum numIndustries_sum numCEOexps_sum numCong4d_sum

bysort _all: keep if _n==1

merge 1:m gvkey year boardid using "First Test DiD Board connections only parent duns REG SAMPLE"
drop if _m == 1

drop _m

foreach var in numFirms numPositions numIndustries numCEOexps numCong4d{
replace `var'_sum = 0 if `var'_sum == .
}

save "First Test DiD Board connections only parent duns REG SAMPLE", replace

use "$OneDrivePath\XX Directors MBA and IVY Hiring firm year director level.dta", clear
foreach var in MBA_dum IVY_dum{
bysort gvkey year boardid: egen `var'_sum = sum(`var')
}

keep gvkey year boardid MBA_dum_sum IVY_dum_sum

bysort _all: keep if _n==1

merge 1:m gvkey year boardid using "First Test DiD Board connections only parent duns REG SAMPLE"
drop if _m == 1

drop _m

foreach var in MBA_dum IVY_dum{
replace `var'_sum = 0 if `var'_sum == .
}


save "First Test DiD Death and Retirement Board connections only parent duns REG SAMPLE", replace

*only death
*save "First Test DiD Death Board connections only parent duns REG SAMPLE", replace