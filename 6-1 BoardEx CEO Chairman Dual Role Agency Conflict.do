global OneDrivePath "D:\OneDrive - Universitat de Barcelona\Project-Board Networks and Procurement\Raw Datasets"

cd "D:\dataset\board networks and procurement\firm-connection-in-procurement"

/*
We need more agency conflict measures. To be done.
Corporate Governance E-Index: from Bebchuk et al (2009) will need Institutional Shareholder Services (ISS)
Delta: Sensitivity of the dollar value of CEO equity portfolio to a dollar change in stock price (Delta) following Core and Guay (2002)
Institutional block holdings
Analyst coverage.
*/

use "$OneDrivePath\Company Composition", clear

gen CEO_Chairman = 1 if strpos(lower(rolename), "ceo") > 0 & strpos(lower(rolename), "chairman") > 0

replace CEO_Chairman = 0 if CEO_Chairman == .

keep if CEO_Chairman == 1

keep boardid datestartrole dateendrole CEO_Chairman

duplicates drop

gen year_start = year(datestartrole)

gen year_end = year(dateendrole)

drop if year_start == 1900

drop if year_end == 9999

gen year = 2000

expand 20 

bysort boardid datestartrole dateendrole: replace year = year + _n - 1

keep if year >= year_start & year <= year_end

keep boardid CEO_Chairman year

duplicates drop

save "CEO Chairman Dual role 2000 to 2019.dta", replace

**CEO and age
use "$OneDrivePath\Company Composition", clear

gen CEO = 1 if strpos(lower(rolename), "ceo") 

keep if CEO == 1

keep boardid directorid datestartrole dateendrole CEO

duplicates drop

gen year_start = year(datestartrole)

gen year_end = year(dateendrole)

drop if year_start == 1900

drop if year_end == 9999

gen year = 2000

expand 20 

bysort boardid datestartrole dateendrole: replace year = year + _n - 1

keep if year >= year_start & year <= year_end

*two CEOs in a year, keep the one with later date start role
bysort boardid year (datestartrole): keep if _n==_N

keep boardid CEO year directorid

duplicates drop

merge m:1 directorid using "$OneDrivePath\BoardEx Age Gender.dta"

drop if _m == 2
drop _m

gen CEO_age = year - year(dob) if year(dob) != 1900

keep boardid year directorid CEO_age
drop if CEO_age == .

save "CEO Age 2000 to 2019.dta", replace



