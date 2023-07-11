set more off, perma
gl base "C:\Users\wb592130\Downloads"
gl map "C:\Users\wb592130\Downloads\spatial-analysis-main\spatial-analysis-main\Mapas"

cd "$base"

/*
import delimited "$base\Empresas.csv", clear 
save "$base\Empresas.dta", replace
*/
use "$base\baselimpia_12jun", clear
destring ccdd	, gen(ID_1)
collapse (sum) workers=c2_p1 [iw=factor], by(ID_1)
replace workers=workers/1000
save "$base\workers.dta", replace
use "$base\baselimpia_12jun", clear
gen uno=c8_p1_1_1==1 if c8_p1_1_1!=.
lab def uno 1 "Firms using AI" 0 "Firms not using AI"
lab val uno uno
keep ruc  razon_social ccdd gpsaltitud	gpslatitud	gpslongitud  uno
cap destring gpsaltitud	gpslatitud	gpslongitud, replace
rename (gpslatitud	gpslongitud) (_Y _X)
geoinpoly _Y _X using "$map\PER_adm1_xy.dta"
drop if _ID==. 
destring ccdd	, gen(ID_1)
merge m:1 ID_1 using "$map\PER_adm1_db", gen(_mmm)
merge m:1 ID_1 using "$base\workers.dta", nogen
save "$base\puntos.dta", replace
collapse (first) ID_1, by(id)
merge 1:1 ID_1 using "$map\PER_adm1_db", gen(_mmm)
merge 1:1 ID_1 using "$base\workers.dta", nogen
	spmap workers using "$map\PER_adm1_xy" , cln(5) fcolor(Blues)  id(ID_1) /// 
	title("Firms using artificial intelligence in Peru") ///
  note("Source: ENHAT 2016. Note: Only small, medium and large formal firms.") point(data("$base\puntos.dta") xcoord(_X) ycoord(_Y) ///
	by(uno) fcolor(red*0.50 red*1.75) legenda(on)) legend(size(*1.75) rowgap(1.5) position(8) title("# of workers" "in thousands" , size(4) justification(left) bexpand)) 

	/*

use ITEM LONGITUD LATITUD using "$base\shp\data.dta", clear
*rename (LONGITUD LATITUD) (gpslongitud gpslatitud)
tempfile geo
save `geo'
use "$base\baselimpia_12jun", clear
geonear identi gpslatitud gpslongitud using `geo', n(ITEM LATITUD  LONGITUD )
keep if dep==15 | dep==7
keep ruc km_to_nid
label data "Ubicación de los nodos de fibra óptica existentes en Lima y Callao"
saveold "$base/fiberoptica", replace
