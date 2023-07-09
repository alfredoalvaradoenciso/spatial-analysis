clear all
set more off, perma
clear

gl sunat "C:\Users\Dell\Desktop\Bases"
cd "C:\Users\Dell\Desktop\Dofile"


import delimited C:\Users\Dell\Downloads\Empresas.csv, clear 
gen firms=1
gen FIRST_IDDP=substr(string(ubigeo, "%06.0f"),1,2)
collapse (sum) firms, by(FIRST_IDDP)
gen id=_n
spmap firms using "$mapa\PER_adm1_xy" , cln(5) id(id) fcolor(Blues) legs(2) ///
title("Number of formal firms in Peru, 2015", size(*0.8)) ///
subtitle(" ", size(*0.8))

