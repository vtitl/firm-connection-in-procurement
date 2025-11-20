clear all
global savepath "D:\dataset\board networks and procurement\data\6-death"
global boardpath "D:\dataset\board networks and procurement\data\2-compustat-boardex 00-19 board infor"


use "$boardpath\1 compustat boardex id 00-19 20 years board members infor.dta", clear

keep if year == year_end

keep gvkey year boardid boardname directorid directorname dateendrole

duplicates drop

joinby directorid directorname using "D:\dataset\BoardEx dta\Individual profile\xcchccbbbnewb97n.dta"
drop if year(dob) == 1900
keep gvkey year boardid boardname directorid directorname dateendrole dob
duplicates drop

gen age = year - year(dob)

keep if age >= 65

*this may include deaths
save "$savepath\3-All Board Member Retirements.dta", replace


/*
use "D:\dataset\BoardEx dta\Individual profile\xcchccbbbnewb97n.dta", clear
drop if year(dob) == 1900
keep directorid dob 
duplicates drop

merge 1:m directorid using "$savepath\2-End role years Board Members.dta"

keep if _m == 3

drop _m

gen age = year - year(dob)

*retirement age >= 65
keep if age >= 65

*this may include deaths
*/

rename dateendrole date_DR

bysort gvkey boardid directorid (date_DR): keep if _n == _N
save "$savepath\3-All Board Member Retirements.dta", replace


