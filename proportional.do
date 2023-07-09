clear all
set more off, perma
gl user "Dell"
gl root "C:\Users\\$user\Desktop\Bases\PRODUCE"
gl map "C:\Users\\$user\Desktop\Bases\Mapas"
cd "$root"


* Maps that shows the number of firms by points proportional to a variable


import delimited "$root\Empresas.csv", clear  

gen id=_n
egen tamaño=group(rango_venta), label
recode tamaño (1=75)   (2=925)   (3=2000)  (4=3200), g(burbuja)
label def burbuja 75 "Micro" 925 "Small" 2000 "Medium" 3200 "Large"
label val burbuja burbuja 

gen prov=substr(string(ubigeo, "%06.0f"),1,4)

 spmap using "$map\PER_adm1_xy", id(id) fcolor(white)   ///
 title("Perú", ///
 span margin(medsmall) fcolor(eggshell )) subtitle(" ")  ///  
 point( xcoord(x1) ycoord(y1)  select(keep if  ciiu==2423) fcolor(navy cyan%80 green%60 red%40) proportional(burbuja) by(burbuja) legenda(on) ) name(all, replace)  


 preserve
 use "$map\PER_adm2_xy", clear
keep if _ID==135
save "$mapa\limaprov2", replace
 restore

 spmap using  "$map\limaprov2", id(id) fcolor(white)   ///
 title("Lima", ///
 span margin(medsmall) fcolor(eggshell )) subtitle(" ")  ///  
 point( xcoord(x1) ycoord(y1)  select(keep if  ciiu==2423 & prov=="1501") fcolor(navy cyan%80 green%60 red%40) proportional(burbuja) by(burbuja) legenda(on) )  name(lima, replace)
 
 
 graph combine all lima,  title("Pharmaceutical firm concentration by size, 2015") graphregion(color(white))
