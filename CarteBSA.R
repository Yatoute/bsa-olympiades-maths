# requierments
library(sf)
library(leaflet)
library(htmltools)
library(htmlwidgets)

# Chargement des lycées gagnés
win_map = read_sf("jaune.geojson")
win_map$statut = "lycée gagné"
win_map = win_map[c("geometry", "name", "description", "statut")]
# Ajouter les markers des lycées gagnéq
map = leaflet(options = leafletOptions(minZoom = 7)) %>%
  addProviderTiles(providers$Esri.WorldStreetMap) %>%
  addAwesomeMarkers(data = win_map,
                    icon = makeAwesomeIcon(icon = "graduation-cap", library = "fa",
                        iconColor = "#000000"  , markerColor = "beige"
                    ), label = ~name
  )
map

# Chargement des lycées perdus
loss_map = read_sf("rouge.geojson")
loss_map$statut = "lycée perdu"
loss_map = loss_map[c("geometry", "name", "description", "statut")]
# Ajouter les markers des lycées perdus
map = map %>% addAwesomeMarkers(data = loss_map,
                          icon = makeAwesomeIcon(icon = "graduation-cap", library = "fa",
                              iconColor = "#FFFFFF" , markerColor = "red"
                          ), label = ~name
)

map

# Chargement des lycées constant
constant_map = read_sf("vert.geojson")
constant_map$statut = "lycée constant"
constant_map = constant_map[c("geometry", "name", "description", "statut")]
# Ajouter les markers des lycées constants
map = map %>% addAwesomeMarkers(data = constant_map,
                                icon = makeAwesomeIcon(icon = "graduation-cap", library = "fa",
                                                       iconColor = "#FFFFFF" , markerColor = "purple"
                                ), label = ~name
)


# 
map <- map %>% setView(lng = -17.27219, lat = 14.71364, zoom = 12)

# Titre de la carte
tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
    transform: translate(-50%, -130%);
    position: fixed !important;
    left: 50%;
    text-align: center;
    padding-left: 10px; 
    padding-right: 10px; 
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 28px;
    font-family: algerian;
    color: green;
  }
"))

title <- tags$div(
  tag.map.title, HTML("Sénégal : lycées participants au concours des olympiades mathématiques")
) 

map <- map %>% addControl(title, position = "bottomleft", className = "map-title")

# Ajoutez la légende personnalisée à la carte

legend_html <- tags$div( 
  HTML("
  <!-- Titre -->
  <div><h2 style='font-family: algerian; text-align: center;'>Légende</h2></div>
  
  <div style='display: flex;'>
  
  <!-- Première colonne -->
  <div style='flex: 1; padding: 1px;'>
  <div><img src='win.jpeg'/></div>
  <div><img src='loss.jpeg'/></div>
  <div><img src='constant.jpeg'/></div></div>
  
  <!-- deuxième colonne -->
  <div style='flex: 3; padding: 1px;'>
  <h3>Lycée gagné</br></br></h3>
  <h3>Lycée perdu</h3>
  <h3></br>Lycée constant</h3></div>
 </div>")
)  

map = map %>% addControl(
  html = legend_html ,
  position = "bottomright"
)
saveWidget(map, file="BSASenegal.html")

map
