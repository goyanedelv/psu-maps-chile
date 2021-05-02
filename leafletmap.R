
# Map with leadlet

library(leaflet)
library(htmlwidgets)

geosonmap="Comunas Chile.json"
library(rgdal)
map = readOGR(geosonmap, "OGRGeoJSON")

map$NOM_COM <- as.character(map$NOM_COM) 
Encoding(map$NOM_COM) <- "latin1" 

datos=read.csv("plantilla_static_maps1756.csv")
map@data=data.frame(map@data,datos[match(map@data[,"COD_COMUNA"],datos[,"COD_COMUNA"]),])
map@data$ï..comunas=NULL

pal2 <- colorNumeric("Spectral",NULL)

m<-leaflet(map) %>%
	addTiles() %>%
	addProviderTiles(providers$OpenStreetMap) %>%
	addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
    	fillColor = ~pal2(map$psupond),
    	label = ~paste0(map$NOM_COM, ": ", formatC(map$psupond, big.mark = ","))) %>%
    addLegend(pal = pal2, values = map$psupond, opacity = 1.0)
saveWidget(m, file="index.html") # save as html
