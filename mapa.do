set more off, perma
global user "Dell"
gl dropbox "C:\Users\Dell\Dropbox"
gl root "$dropbox\Alfredo Peru BID\ENHAT\Bases de datos\Base completa al 12.06.18"
gl map "C:\Users\\$user\Desktop\Bases\Mapas"
gl result "C:\Users\\$user\Downloads"

cd "$root"

import excel "$result\pbi_peru_4.xlsx", firstrow clear cellrange(A8:K35)
keep A K
replace K=K[14]-K[15] in 14
drop in 16/17
sort A
replace K=round(K/1000000)
gen ID_1=_n
tempfile pbi
save `pbi'

use "$root\Base limpia\baselimpia_12jun", clear
gen uno=c8_p1_1_1==1 | c8_p1_1_2==1 | c8_p1_1_3==1 | c8_p1_1_4==1 | c8_p1_1_5==1 | c8_p1_1_6==1
lab def uno 1 "Usa nuevas tecnologías" 0 "No usa nuevas tecnologías"
lab val uno uno
keep ruc  razon_social ccdd gpsaltitud	gpslatitud	gpslongitud  uno
cap destring gpsaltitud	gpslatitud	gpslongitud, replace
rename (gpslatitud	gpslongitud) (_Y _X)
geoinpoly _Y _X using "$map\PER_adm1_xy.dta"
drop if _ID==. 
drop _ID
destring ccdd	, gen(ID_1)
gen ID=_n
merge m:1 ID_1 using "$map\PER_adm1_db", gen(_mmm)
merge m:1 ID_1 using `pbi', nogen
bys ID_1: gen K2=K[_n] if _n==1
save "$result\puntos.dta", replace

collapse (first) ID_1, by(id)
merge 1:1 ID_1 using "$map\PER_adm1_db", gen(_mmm)
merge 1:1 ID_1 using `pbi', nogen
	spmap K using "$map\PER_adm1_xy" , cln(4) fcolor(Blues)  id(ID_1) /// 
	title("Empresas según uso de nuevas tecnologías") ///
	subtitle("Perú, 2016", size(*0.8)) note("Fuente: ENHAT 2016") point(data("$result\puntos.dta") xcoord(_X) ycoord(_Y) ///
	by(uno) fcolor(red*0.75 red*1.6) legenda(on)) legend(size(*2) rowgap(1.5) position(8) title("PBI en" "mills. de S/" , size(5) justification(left) bexpand)) 
graph export "$result\mapa_empresas_usotech.emf",replace


use ITEM LONGITUD LATITUD using "$result\shp\data.dta", clear
*rename (LONGITUD LATITUD) (gpslongitud gpslatitud)
tempfile geo
save `geo'
use "$root\Base limpia\baselimpia_12jun", clear
geonear identi gpslatitud gpslongitud using `geo', n(ITEM LATITUD  LONGITUD )
keep if dep==15 | dep==7
keep ruc km_to_nid
label data "Ubicación de los nodos de fibra óptica existentes en Lima y Callao"
saveold "$result/fiberoptica", replace

