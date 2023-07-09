clear all
set more off, perma
gl user "Dell"
gl root "C:\Users\\$user\Desktop\Bases\PRODUCE"
gl map "C:\Users\\$user\Desktop\Bases\Mapas"
cd "$root"

* Maps that shows the number of firms by colors

import delimited "$root\Empresas.csv", clear 
gen firms=1
gen FIRST_IDDP=substr(string(ubigeo, "%06.0f"),1,2)
collapse (sum) firms, by(FIRST_IDDP)
gen id=_n
spmap firms using "$map/PER_adm1_xy.dta", cln(5) id(id) fcolor(Blues) legs(2) ///
title("Number of formal firms in Peru, 2015", size(*0.8)) ///
subtitle(" ", size(*0.8))

