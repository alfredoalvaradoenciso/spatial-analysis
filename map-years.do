clear all
set more off, perma
gl map "C:\Users\Dell\Documents\GitHub\spatial-analysis\shapefiles"
gl img "C:\Users\Dell\Documents\GitHub\spatial-analysis\img"
cd "$map"


***************** Maps that shows the number of firms by colors

**Department level
use "$map\perushp_departamental", clear
tempfile a
save `a'
use "$map\antenainternet", replace
gen FIRST_IDDP=substr(ubigeo,1,2)
collapse (sum) antenainternet, by(FIRST_IDDP year)
preserve
keep if year==2007
merge m:1 FIRST_IDDP using `a'
spmap antenainternet using "$map\perxy_departamental" , id(idmap_departamento)  /// 
clmethod(custom) clbreaks(0 25 50 100 150 323) fcolor(Blues) title("2007") name(m2007, replace) nodraw 
restore
keep if year==2012
merge m:1 FIRST_IDDP using `a'
spmap antenainternet using "$map\perxy_departamental" , id(idmap_departamento)  ///
 clmethod(custom) clbreaks(0 25 50 100 150 323) fcolor(Blues) title("2012") name(m2012, replace) nodraw 
graph combine m2007 m2012, title("Number of satellites antennas in Peruvian regions")  graphregion(color(white))  note(Source: RENAMU)
graph export "$img\antena_reg.emf",replace

**Province level
use "$map\perushp_provincial", clear
drop if strmatch(NOMBPROV, "*FAFARDO*") | strmatch(NOMBPROV, "*PUIR*") //Estas dos provincias vienen mal hechas en el shapefile de INEI.
tempfile a
save `a'
use "$map\antenainternet", replace
gen FIRST_IDPR=substr(ubigeo,1,4)
collapse (sum) antenainternet, by(FIRST_IDPR year)
preserve
keep if year==2007
merge m:1 FIRST_IDPR using `a'
spmap antenainternet using "$map\perxy_provincial" , id(id) clmethod(custom) clbreaks(0 1 3 7 15 216) fcolor(Blues) ///
title("2007") name(m2007, replace) nodraw 
restore
keep if year==2012
merge m:1 FIRST_IDPR using `a'
spmap antenainternet using "$map\perxy_provincial" , id(id) clmethod(custom) clbreaks(0 1 3 7 15 216) fcolor(Blues) ///
title("2012") name(m2012, replace) nodraw 
graph combine m2007 m2012, title("Number of satellites antennas in Peruvian provinces")  graphregion(color(white)) note(Source: RENAMU)
graph export "$img\antena_prov.emf",replace
