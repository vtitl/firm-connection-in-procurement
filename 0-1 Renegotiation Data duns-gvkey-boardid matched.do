cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"
clear all

***matching FPDS duns with gvkey and boardid through ISIN
import excel "duns-isin-2025.xlsx", sheet("sheet1") firstrow case(lower) allstring
drop check f colorlegendbluedoublechec h i
duplicates drop

save "duns_isin.dta", replace

use "XX Compustat BoardEx id matching final.dta", clear


joinby isin using "duns_isin.dta", unmatched(both)

keep if _m==3
drop _m

drop if duns == "INMARSAT" | duns == "" | duns == "nan"


save "XX duns-gvkey-boardid.dta",replace


***Regegotiation Data parent firm duns ID matching
use "fpds_20082018.dta", clear

merge 1:m award_id_piid using"FPDS.dta", keepusing(recipient_duns recipient_parent_duns)
keep if _m==3
drop _m

duplicates drop

replace recipient_duns = recipient_parent_duns if recipient_duns == "" & recipient_parent_duns != ""
* replace recipient duns = duns if former missing and latter not
replace recipient_parent_duns = recipient_duns if recipient_parent_duns == "" & recipient_duns != ""
* replace duns = parent duns if former missing and latter not

drop if recipient_duns == "" & recipient_parent_duns == ""

*replace dunsnumber = subinstr(dunsnumber, " ", "", .)
replace recipient_parent_duns = subinstr(recipient_parent_duns, " ", "", .)

save "Renegotiation_only_parent_duns", replace

*matching duns with gvkey and boardid
use "Renegotiation_only_parent_duns", clear

gen duns = recipient_parent_duns

drop recipient_duns

duplicates drop

joinby duns using "XX duns-gvkey-boardid.dta"

rename fiscalyear year

save "Renegotiation_only_parent_duns_matched gvkey boarid", replace