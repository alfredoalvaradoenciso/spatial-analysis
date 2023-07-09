gl mapa "C:\Users\Dell\Desktop\Bases\Mapas"

**Download geolocated Peruvian firms at https://www.produce.gob.pe/index.php/datosabiertos/52-portal-de-datos-abiertos

import delimited C:\Users\Dell\Downloads\Empresas.csv, clear 

gen id=_n
egen tamaño=group(rango_venta), label
recode tamaño (1=75)   (2=925)   (3=2000)  (4=3200), g(burbuja)
label def burbuja 75 "Micro" 925 "Small" 2000 "Medium" 3200 "Large"
label val burbuja burbuja 

gen prov=substr(string(ubigeo, "%06.0f"),1,4)

 spmap using "$mapa\PER_adm1_xy", id(id) fcolor(white)   ///
 title("Perú", ///
 span margin(medsmall) fcolor(eggshell )) subtitle(" ")  ///  
 point( xcoord(x1) ycoord(y1)  select(keep if  ciiu==2423) fcolor(navy cyan%80 green%60 red%40) proportional(burbuja) by(burbuja) legenda(on) ) name(all, replace)  


 preserve
 use "$mapa\PER_adm2_xy", clear
keep if _ID==135
save "$mapa\limaprov2", replace
 restore

 spmap using  "$mapa\limaprov2", id(id) fcolor(white)   ///
 title("Lima", ///
 span margin(medsmall) fcolor(eggshell )) subtitle(" ")  ///  
 point( xcoord(x1) ycoord(y1)  select(keep if  ciiu==2423 & prov=="1501") fcolor(navy cyan%80 green%60 red%40) proportional(burbuja) by(burbuja) legenda(on) )  name(lima, replace)
 
 
 graph combine all lima,  title("Pharmaceutical firm concentration by size, 2015") graphregion(color(white))
