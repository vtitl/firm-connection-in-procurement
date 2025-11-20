clear all
global savepath "D:\dataset\board networks and procurement\data\6-death"
global boardpath "D:\dataset\board networks and procurement\data\2-compustat-boardex 00-19 board infor"

*using BoardEx announcement data to identify deaths
use "D:\dataset\BoardEx dta\Announcement 2001-2019\qybqqkala0tej1ww.dta", clear

gen death_dum = 1 if strpos(lower(description), "passed away") > 0 | strpos(lower(description), "deceased") > 0 | strpos(lower(description), " died ") > 0

keep if death_dum == 1

rename companyid boardid

keep boardid announcementdate directorid death_dum

gen year = year(announcementdate)

duplicates drop

save "$savepath\1-deaths from BoardEx Announcement.dta", replace

*using BoardEx individual profile to identify all death dates

use "D:\dataset\BoardEx dta\Individual profile\xcchccbbbnewb97n.dta", clear

drop if year(dod) == 9999

keep directorid dod

gen year = year(dod)

duplicates drop

save "$savepath\1-deaths from BoardEx Individual Profile.dta", replace

*board member information for the year of the end of the role as board members

use "$boardpath\1 compustat boardex id 00-19 20 years board members infor.dta", clear

keep if year == year_end

keep gvkey year boardid boardname directorid directorname

duplicates drop

save "$savepath\2-End role years Board Members.dta", replace



*merge board member end role with deaths
use "$savepath\2-End role years Board Members.dta", clear

merge m:1 directorid year using "$savepath\1-deaths from BoardEx Individual Profile.dta"

keep if _m == 3

drop _m

save "$savepath\2-deaths from BoardEx Individual Profile served as Board Members.dta", replace


use "$savepath\2-End role years Board Members.dta", clear

merge m:1 boardid directorid year using "$savepath\1-deaths from BoardEx Announcement.dta"

keep if _m == 3

drop _m

gen dod = announcementdate

save "$savepath\1-deaths from BoardEx Announcement served as Board Members.dta", replace


*merge deaths data
use "$savepath\2-deaths from BoardEx Individual Profile served as Board Members.dta", clear

keep gvkey year boardid boardname directorid directorname dod

duplicates drop

append using "$savepath\1-deaths from BoardEx Announcement served as Board Members.dta", keep(gvkey year boardid boardname directorid directorname dod)

duplicates drop

gen death_dum = 1

rename dod date_DR

bysort gvkey boardid directorid (date_DR): keep if _n == 1

save "$savepath\3-All Board Member Deaths 2000-2019.dta", replace




















