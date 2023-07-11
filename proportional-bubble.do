clear all
set more off, perma
gl base "C:\Users\Dell\Desktop\Bases\PRODUCE"
gl map "C:\Users\Dell\Documents\GitHub\spatial-analysis\shapefiles"
gl img "C:\Users\Dell\Documents\GitHub\spatial-analysis\img"
cd "$base"


* Maps that shows the number of firms by points proportional to a variable
/*
import delimited "$base\Empresas.csv", clear 
save "$base\Empresas.dta", replace
*/
use if _ID>=1350 & _ID<=1392 using "$map\PER_adm3_xy", clear
saveold "$base\Lima_xy", replace

use "$base\Empresas.dta", clear 

gen id=_n
egen tamaño=group(rango_venta), label
recode tamaño (3=4)  (4=8), g(burbuja)
label def burbuja 1 "Micro firm" 2 "Small firm" 4 "Medium firm" 8 "Large firm"
label val burbuja burbuja 

gen prov=substr(string(ubigeo, "%06.0f"),1,4)

spmap using "$map\PER_adm1_xy", id(id) fcolor(white) title("Peru", span margin(medsmall) /// 
fcolor(eggshell )) nodraw point( xcoord(x1) ycoord(y1)  select(keep if  ciiu==2423) /// 
fcolor(navy cyan%80 green%60 red%40) proportional(burbuja) by(burbuja) legenda(on)) legend(size(*2))  name(all, replace)  


spmap using  "$base\Lima_xy", id(id) fcolor(white) title("Lima", span margin(medsmall) /// 
 fcolor(eggshell )) nodraw point( xcoord(x1) ycoord(y1)  select(keep if  ciiu==2423 & /// 
 prov=="1501") fcolor(navy cyan%80 green%60 red%40) proportional(burbuja) by(burbuja) legenda(off) )  name(lima, replace)
 
 
 graph combine all lima,  title("Pharmaceutical firm concentration by size, 2015") graphregion(color(white)) note(Source: Produce (2015). Note: Only formal firms.)
graph export "$img\pharma.emf",replace
