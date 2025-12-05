global OneDrivePath "D:\OneDrive - Universitat de Barcelona\Project-Board Networks and Procurement\Raw Datasets"

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"


******************************Board Ties*********************************

use "Renegotiation_only_parent_duns_matched gvkey boarid", clear

keep gvkey boardid duns

duplicates drop

expand 11

bysort _all: gen year = 2007 + _n

merge 1:1 gvkey boardid year using "$OneDrivePath\3 overall number of connections data with no connection firms.dta"

keep if _m == 3

drop _m


merge 1:1 gvkey year using "$OneDrivePath\firm_yearly_data.dta"

keep if _m == 3

drop _m


*merge 1:m gvkey boardid year using "$OneDrivePath\5-All Board Member Deaths and Retirements Connections Information.dta"
*only death
merge 1:m gvkey boardid year using "$OneDrivePath\5-All Board Member Deaths Connections Information.dta"

drop if _m == 2

drop _m boardid boardname directorid directorname date_DR
bysort gvkey duns year: ereplace death_dum = max(death_dum)
duplicates drop

*here death_dum is not only for death, it's for both death and retirement, skip the first replacement if we only use death
*replace death_dum = 1 if death_dum == 0
replace death_dum = 0 if death_dum == .
replace death_dum = 0 if totnumties == 0

quietly sum totnumties if death_dum == 1, d

replace death_dum = 0 if death_dum == 1 & totnumties < r(p50)


xtset gvkey year
gen death_shock = death_dum
replace death_shock = 0 if death_dum==1 & L.death_dum==1
replace death_shock = 0 if death_dum==1 & L.death_dum==.

bys gvkey duns (year): gen numobs_firmyear = _n 

replace death_shock = 0 if death_dum==1 & numobs ==1 

save "firm financials with Death YEARLY data 2000-2020 with overall connections", replace

use "firm financials with Death YEARLY data 2000-2020 with overall connections", clear
gsort gvkey duns year
keep gvkey duns year death_dum death_shock

gen Treat = 1 if death_shock == 1
xtset gvkey year

gen timing = 0 if death_shock == 1

replace Treat = 1 if F.death_shock == 1 | F2.death_shock == 1 | F3.death_shock == 1 | F4.death_shock == 1 | L.death_shock == 1 | L2.death_shock == 1 | L3.death_shock == 1 | L4.death_shock == 1

egen Event = group(gvkey year) if timing == 0

replace timing = -1 if F.timing == 0 & timing != 0
replace timing = -2 if F.timing == -1 & timing != 0
replace timing = -3 if F.timing == -2 & timing!=0
replace timing = -4 if F.timing == -3 & timing!=0
replace timing = 1 if L.timing == 0 
replace timing = 2 if L.timing == 1 
replace timing = 3 if L.timing == 2 
replace timing = 4 if L.timing == 3 


replace Event = F.Event if F.Event !=. & timing == -1
replace Event = F.Event if F.Event !=. & timing == -2
replace Event = F.Event if F.Event !=. & timing == -3
replace Event = F.Event if F.Event !=. & timing == -4

replace Event = L.Event if L.Event !=. & timing == 1
replace Event = L.Event if L.Event !=. & timing == 2
replace Event = L.Event if L.Event !=. & timing == 3
replace Event = L.Event if L.Event !=. & timing == 4



save "firms board full sample with Treatment death events and non-death controls", replace 



use "firms board full sample with Treatment death events and non-death controls", clear

keep if Event != .

bys gvkey duns Event (year): gen completeEvent = 1  if _N==9

replace completeEvent = 0 if completeEvent == .

*if we want to have all complete event
*keep if completeEvent == 1
gsort Event gvkey year
egen numEvent = group(Event)
save "Stacked board Panels TREATED death events", replace 

use "firms board full sample with Treatment death events and non-death controls", clear

gen Treat_ext = Treat 
bys gvkey duns (year): replace Treat_ext = 1 if Treat[_n+1] ==1 & Treat_ext==.
bys gvkey duns (year): replace Treat_ext = 1 if Treat[_n-1] ==1 & Treat_ext==.

drop if Treat_ext == 1
drop if death_dum == 1

save "Potential board Control Observations", replace


clear all
set obs 0 
gen gvkey =.
gen year =.
gen Treat =.
gen timing =.
gen numEvent=.
save "Stacked Data", replace

use "Stacked board Panels TREATED death events", clear
quietly sum numEvent



forval e = 1/`r(max)' { 

use "Stacked board Panels TREATED death events", clear 
keep if numEvent ==  `e'
egen year_min = min(year)
egen year_max = max(year)
append using "Potential board Control Observations"
keep if death_dum==0 | Treat==1
carryforward year_min, replace  
carryforward year_max, replace 		
keep if year >= year_min & year <= year_max	
*If we want to keep complete events only
*bys gvkey (year): gen n = _N
*keep if n==9	
*drop n
merge 1:1 gvkey year using "firm financials with Death YEARLY data 2000-2020 with overall connections", keepusing(totnumties firm_size firm_age cash ppe_assets sic leverage_val profitability )  
drop if _m==2
drop _m 

/*
gen sic4treated = sic if Treat ==1 
ereplace sic4treated=max(sic4treated)
keep if sic == sic4treated
*/
/*
gen sic3 = int(sic/10)
gen sic3treated = sic3 if Treat ==1 
ereplace sic3treated=max(sic3treated)
keep if sic3 == sic3treated
*/
/*
gen sic2 = int(sic/100)
gen sic2treated = sic2 if Treat ==1 
ereplace sic2treated=max(sic2treated)
keep if sic2 == sic2treated
*/

gen sic1 = int(sic/1000)
gen sic1treated = sic1 if Treat ==1 
ereplace sic1treated=max(sic1treated)
keep if sic1 == sic1treated

bys year: ereplace timing = max(timing)
gsort Treat gvkey timing

save "temp1", replace
*keep if timing == -1 
keep if timing == 0
gsort Treat
if _N>4  {
	
mahascore  firm_size leverage_val ppe_assets profitability , gen(maha) refobs(1) compute_invcovarmat unsquared

}

else {
	
	generate maha =  (firm_size - firm_size[1])^2 + (leverage_val - leverage_val[1])^2 + (ppe_assets - ppe_assets[1])^2 +  (profitability - profitability[1])^2 

}

gsort maha
keep if _n == 2
 

replace Treat = 0 
keep gvkey Treat
save "temp2", replace

use "temp1", clear
merge m:1 gvkey using "temp2", update
keep if Treat!=.
drop Event
gsort -Treat
carryforward numEvent, replace
keep gvkey year Treat timing numEvent
append using "Stacked Data" 
gsort numEvent gvkey timing
save "Stacked Data", replace

}

use "Stacked Data", clear 
*bysort numEvent: gen n=_N
*drop if n==9
*drop n
bysort numEvent gvkey: gen temp = _n == 1
bysort numEvent: egen num_unique_firms = total(temp) 
drop if num_unique_firms == 1
drop num_unique_firms temp
save, replace 

use "Stacked Data", clear



merge m:1 gvkey year using "firm financials with Death YEARLY data 2000-2020 with overall connections", keepusing(sic emp altmanZ altmanZ_f firm_tag RandD firm_size years_active years_active_cum firm_age leverage_val cash profitability ppe_assets capex_at market_capitalistion tobins_q lagged_ppent KZ_index sales_sic s s2 HHI HH2 totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2) 

drop if _m==2
drop _m



gsort numEvent -Treat timing

*save "Board Death and Retirement SIC1 Control Stacked Data", replace
*only death
save "Board Death SIC1 Control Stacked Data", replace

covbal Treat firm_size firm_age cash ppe_assets altmanZ RandD leverage_val profitability capex_at market_capitalistion tobins_q KZ_index totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2


covbal Treat firm_size firm_age cash ppe_assets altmanZ RandD leverage_val profitability capex_at market_capitalistion tobins_q KZ_index totnumties totnumtiesSIC4 totnumtiesDSIC4 totnumtiesSIC3 totnumtiesDSIC3 totnumtiesSIC2 totnumtiesDSIC2 totnumtiesTNIC3 totnumtiesDTNIC3 totnumtiesTNIC2 totnumtiesDTNIC2 priornumties priornumtiesSIC4 priornumtiesDSIC4 priornumtiesSIC3 priornumtiesDSIC3 priornumtiesSIC2 priornumtiesDSIC2 priornumtiesTNIC3 priornumtiesDTNIC3 priornumtiesTNIC2 priornumtiesDTNIC2 intlnumties intlnumtiesSIC4 intlnumtiesDSIC4 intlnumtiesSIC3 intlnumtiesDSIC3 intlnumtiesSIC2 intlnumtiesDSIC2 intlnumtiesTNIC3 intlnumtiesDTNIC3 intlnumtiesTNIC2 intlnumtiesDTNIC2 if timing<0

























