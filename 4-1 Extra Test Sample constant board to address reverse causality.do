use "1 board size.dta", clear 
keep gvkey year boardsize
duplicates drop
xtset gvkey year

gen boardsize_lag = L.boardsize

merge 1:m gvkey year using "1 compustat boardex id 00-19 20 years board members infor.dta"

keep gvkey year boardsize boardsize_lag directorid
duplicates drop

keep if boardsize == boardsize_lag

// (Though xtset handles the L. operator, sorting this way is good practice before generating lagged variables)
sort gvkey directorid year

// Create a variable that holds the director's year *last* seen
// This is more complex to implement directly with L.directorid.
// A simpler, more reliable approach for panel data:
by gvkey directorid: gen last_year_seen = year[_n-1]
by gvkey directorid: replace last_year_seen = . if year - last_year_seen > 1

gen incumbentBoard = 1 if last_year_seen != .

bysort gvkey year: egen numSameBoard = total(incumbentBoard)

keep if numSameBoard == boardsize_lag

keep gvkey year

duplicates drop

merge 1:1 gvkey year using "First Test OLS Sample data no winning years.dta" 

xtset gvkey year

foreach var in numcontract_ln expected_cost_ln total_cost_all_ln cost_overrun_ln renegotiation_ln expected_duration_ln final_duration_ln delay_ln extra_cost extra_delay {

gen `var'_lag = L.`var'

}

keep if _m == 3

drop _m

save "Extra test constant board.dta", replace