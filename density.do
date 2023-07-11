clear all
set more off, perma
gl base "C:\Users\Dell\Desktop\Bases\ENHAT"
gl map "C:\Users\Dell\Documents\GitHub\spatial-analysis\shapefiles"
gl img "C:\Users\Dell\Documents\GitHub\spatial-analysis\img"
cd "$base"


use if _ID>=1350 & _ID<=1392 using "$map\PER_adm3_xy", clear
saveold "$base\Lima_xy", replace


use if _ID==135 using "$map\PER_adm2_xy", clear
saveold "$base\Lima_xy2", replace


use "$base\baselimpia_12jun", clear
gen any=c8_p1_1_1==1 if c8_p1_1_1!=.
lab def any 1 "Usa inteligencia artificial" 0 "No usa inteligencia artificial"
lab val any any
rename (gpslatitud	gpslongitud) (_Y _X)
geoinpoly _Y _X using "$map\PER_adm2_xy.dta" // to merge geographic id (provinces) to the geolocation of units
keep if _ID==135
drop _ID
gen _ID=_n

***Point map graphs
spmap using "$base\Lima_xy", cln(3) id(_ID)  legs(2) ///
title("Cluster de empresas que usan" "inteligencia artificial en Lima")  note("Fuente: ENHAT (2016)") point(xcoord(_X) ycoord(_Y) ///
by(any) fcolor(navy red) legenda(on)) legend(size(*2) rowgap(1.5))
graph export "$img\mapa_lima.emf",replace

***Density kernel map graphs
preserve
keep if any==1 
spgrid using "$base\Lima_xy2", shape(square) xdim(100) verbose compress  /// 
cells("$base\ctemp.dta") points("$base\ptemp.dta") replace 
spkde using "$base\ptemp.dta", x(_X) y(_Y) kernel(normal) bandwidth(fbw) fbw(ad10) /// 
saving("$base\kde.dta", replace)
use "$base\kde.dta", clear
spmap p using "$base\ctemp.dta", id(spgrid_id) clmethod(quantile) clnumber(20) /// 
fcolor(Rainbow) ocolor(none ..) legend(off) title("Usan inteligencia artificial") name(g1, replace) nodraw
restore
keep if any==0
spgrid using "$base\Lima_xy2", shape(square) xdim(100) verbose compress  /// 
cells("$base\ctemp.dta") points("$base\ptemp.dta") replace 
spkde using "$base\ptemp.dta", x(_X) y(_Y) kernel(normal) bandwidth(fbw) fbw(ad10) /// 
saving("$base\kde.dta", replace)
use "$base\kde.dta", clear
spmap p using "$base\ctemp.dta", id(spgrid_id) clmethod(quantile) clnumber(20) /// 
fcolor(Rainbow) ocolor(none ..) legend(off) title("No usan inteligencia artificial") name(g2, replace) nodraw
graph combine g1 g2, title("Concentración de empresas en Lima, 2016") subtitle("Densidad kernel de empresas georeferenciadas", size(*0.8)) note("Fuente: ENHAT 2016")  ycommon name(combined, replace) graphregion(color(white))
graph export "$img\mapa_densidad_lima.emf",replace
