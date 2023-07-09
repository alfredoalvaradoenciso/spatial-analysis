set more off, perma
global user "ALFREDO"

cd "C:\Users\\$user\Dropbox\Alfredo Peru BID\ENHAT\Bases de datos\Base completa al 15.12.17"


use if _ID>=1350 & _ID<=1392 using "C:\Users\\$user\Dropbox\Alfredo Peru BID\PER_adm3_xy", clear
saveold "C:\Users\\$user\Dropbox\Alfredo Peru BID\Lima_xy", replace
use if _ID==135 using "C:\Users\\$user\Dropbox\Alfredo Peru BID\PER_adm2_xy", clear
saveold "C:\Users\\$user\Dropbox\Alfredo Peru BID\Lima_xy2", replace

use "Base limpia\baselimpia_15dic", clear
gen uno=c8_p1_1_1==1 | c8_p1_1_2==1 | c8_p1_1_3==1 | c8_p1_1_4==1 | c8_p1_1_5==1 | c8_p1_1_6==1
lab def uno 1 "Usa nuevas tecnologías" 0 "No usa nuevas tecnologías"
lab val uno uno
keep ruc  razon_social ccdd ccpp gpsaltitud	gpslatitud	gpslongitud  uno
foreach v of varlist gpsaltitud	gpslatitud	gpslongitud {
replace `v'=subinstr(`v',",",".",.)
}
destring gpsaltitud	gpslatitud	gpslongitud, replace
rename (gpslatitud	gpslongitud) (_Y _X)
geoinpoly _Y _X using "C:\Users\\$user\Dropbox\Alfredo Peru BID\PER_adm2_xy.dta"
keep if _ID==135
drop _ID
destring ccdd	, gen(ID_1)
destring ccpp	, gen(ID_2)
gen ID=_n

/*
spmap using "C:\Users\\$user\Dropbox\Alfredo Peru BID\Lima_xy", cln(3) id(ID)  legs(2) ///
title("Empresas" "según uso de Nuevas Tecnologías") ///
subtitle("Lima, 2016", size(*0.8)) note("Fuente: ENHAT 2016") point(xcoord(_X) ycoord(_Y) ///
by(uno) fcolor(navy red) legenda(on)) legend(size(*2) rowgap(1.5))
graph export "..\..\Papers usando la ENHAT\new tech spatial clustering\mapa_lima.emf",replace
*/
preserve
keep if uno==1
spgrid using "C:\Users\\$user\Dropbox\Alfredo Peru BID\Lima_xy2", shape(square) xdim(100) verbose compress  /// 
cells("C:\Users\\$user\Dropbox\Alfredo Peru BID\ctemp.dta") points("C:\Users\\$user\Dropbox\Alfredo Peru BID\ptemp.dta") replace
spkde using "C:\Users\\$user\Dropbox\Alfredo Peru BID\ptemp.dta", x(_X) y(_Y) kernel(normal) bandwidth(fbw) fbw(ad10) saving("C:\Users\\$user\Dropbox\Alfredo Peru BID\kde.dta", replace)
use "C:\Users\\$user\Dropbox\Alfredo Peru BID\kde.dta", clear
spmap p using "C:\Users\\$user\Dropbox\Alfredo Peru BID\ctemp.dta", id(spgrid_id) clmethod(quantile) clnumber(20) fcolor(Rainbow) ocolor(none ..) legend(off) ///
title("Usan Nuevas Tecnologías") name(g1, replace) nodraw
restore

keep if uno==0
spgrid using "C:\Users\\$user\Dropbox\Alfredo Peru BID\Lima_xy2", shape(square) xdim(100) verbose compress  /// 
cells("C:\Users\\$user\Dropbox\Alfredo Peru BID\ctemp.dta") points("C:\Users\\$user\Dropbox\Alfredo Peru BID\ptemp.dta") replace
spkde using "C:\Users\\$user\Dropbox\Alfredo Peru BID\ptemp.dta", x(_X) y(_Y) kernel(normal) bandwidth(fbw) fbw(ad10) saving("C:\Users\\$user\Dropbox\Alfredo Peru BID\kde.dta", replace)
use "C:\Users\\$user\Dropbox\Alfredo Peru BID\kde.dta", clear
spmap p using "C:\Users\\$user\Dropbox\Alfredo Peru BID\ctemp.dta", id(spgrid_id) clmethod(quantile) clnumber(20) fcolor(Rainbow) ocolor(none ..) legend(off) ///
title("No usan Nuevas Tecnologías") name(g2, replace) nodraw
graph combine g1 g2, title("Concentración de empresas en Lima, 2016") subtitle("Densidad kernel de empresas georeferenciadas", size(*0.8)) note("Fuente: ENHAT 2016")  ycommon name(combined, replace)
graph export "..\..\Papers usando la ENHAT\new tech spatial clustering\mapa_densidad_lima.emf",replace
