
#Mapas con leaftet

setwd("C:/Users/Gonzalo/Desktop/goyanedelv.github.io")
#install.packages("leaflet")
library(leaflet)
library(htmlwidgets)

geosonmap="Comunas Chile.json"
library(rgdal)
map = readOGR(geosonmap, "OGRGeoJSON")

map$NOM_COM <- as.character(map$NOM_COM) 
Encoding(map$NOM_COM) <- "latin1" 

datos=read.csv("C:/Users/Gonzalo/Dropbox/Super Data Projects/Chilean Data Project/Map Function R/plantilla_static_maps1756.csv")
datos$Cook[datos$Cook>12]=12 #Limitar Cook Index a máximo 12
map@data=data.frame(map@data,datos[match(map@data[,"COD_COMUNA"],datos[,"COD_COMUNA"]),])
map@data$ï..comunas=NULL

pal <- colorNumeric("RdBu", NULL)
pal2 <- colorNumeric("Spectral",NULL)

m<-leaflet(map) %>%
	addTiles() %>%
	addProviderTiles(providers$OpenStreetMap) %>%
	#addMarkers(lng=-70.64827, lat=-33.45694, popup="Aki le pedi pololeo a la oli <3")%>%
	addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
    	fillColor = ~pal(map$Cook),
    	label = ~paste0(map$NOM_COM, ": ", formatC(map$Cook, big.mark = ","))) %>%
    addLegend(pal = pal, values = map$Cook, opacity = 1.0)#,
saveWidget(m, file="index.html") #guarda como html

m<-leaflet(map) %>%
	addTiles() %>%
	addProviderTiles(providers$OpenStreetMap) %>%
	addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
    	fillColor = ~pal2(map$psupond),
    	label = ~paste0(map$NOM_COM, ": ", formatC(map$psupond, big.mark = ","))) %>%
    addLegend(pal = pal2, values = map$psupond, opacity = 1.0)#,
saveWidget(m, file="index.html") #guarda como html

#Multiple layers: https://statnmap.com/en/2016/12/multiple-layers-leaflet-widget-with-rstat/