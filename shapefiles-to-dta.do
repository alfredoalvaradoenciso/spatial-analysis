clear all
set more off, perma
gl map "C:\Users\Dell\Documents\GitHub\spatial-analysis\shapefiles"
cd "$base"

shp2dta using "$map/INEI\Distrital/BAS_LIM_DISTRITOS.shp", database("$map\perushp_distrital.dta") /// 
coordinates("$map\perxy_distrital.dta") genid(idmap_distrito) replace //Shapefile con el mapa distrital
shp2dta using "$map/INEI\Provincial/BAS_LIM_PROVINCIA.shp", database("$map\perushp_provincial.dta") /// 
coordinates("$map\perxy_provincial.dta") genid(idmap_provincia) gencentroids(centroid) replace //Shapefile con el mapa provincial
shp2dta using "$map/INEI\Departamental/BAS_LIM_DEPARTAMENTO.shp", database("$map\perushp_departamental.dta") /// 
coordinates("$map\perxy_departamental.dta") genid(idmap_departamento) gencentroids(centroid)  replace //Shapefile con el mapa departamental


shp2dta using "$map/GADM/PER_adm0.shp", database("$map/PER_adm0_db.dta") /// 
coordinates("$map\PER_adm0_xy.dta") genid(id) gencentroids(centroid)  replace //Shapefile con el mapa nacional

shp2dta using "$map/GADM/PER_adm1.shp", database("$map/PER_adm1_db.dta") /// 
coordinates("$map\PER_adm1_xy.dta") genid(id) gencentroids(centroid)  replace //Shapefile con el mapa regional

shp2dta using "$map/GADM/PER_adm2.shp", database("$map/PER_adm2_db.dta") /// 
coordinates("$map\PER_adm2_xy.dta") genid(id) gencentroids(centroid)  replace //Shapefile con el mapa provincial

shp2dta using "$map/GADM/PER_adm3.shp", database("$map/PER_adm3_db.dta") /// 
coordinates("$map\PER_adm3_xy.dta") genid(id) gencentroids(centroid)  replace //Shapefile con el mapa distrital
