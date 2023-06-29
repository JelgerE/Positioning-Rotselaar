source("Libraries.R")

recs <- read.csv("./data/Receivers_IDs_locaties_deployment_2023.csv") 

trimble <- read.csv("./data/All_trimble_data_receiver_positions.csv") %>%
  mutate(Name = gsub(pattern="REC-", replacement="", x=Name)) %>%
  filter(!grepl( "GPS-DRIFTER-A-BASISSTATION", Name)) 

trimble <- cbind(trimble, 
                 as.data.frame(
                   str_split_fixed(
                     trimble$Name, "-", 2),
                  )
                 ) 

trimble <- trimble %>% 
  dplyr::select(-Name) %>%
  dplyr::rename(Name = V1,
         Measure = V2) %>%
  group_by(Name) %>%
  summarise(Easting = mean(Easting),
            Northing = mean(Northing)) %>%
  st_as_sf(coords = c("Easting", "Northing"), crs="EPSG:31370", remove = F) %>%
  st_transform(crs = "EPSG:4326")

trimble <- trimble %>%
  dplyr::mutate(deploy_long = st_coordinates(trimble)[,1],
                deploy_lat = st_coordinates(trimble)[,2])

for (rec in unique(recs$Code)) {
  recs[(recs$Code == rec),]$Deploy_long <- trimble[(trimble$Name == rec),]$deploy_long[[1]]
  recs[(recs$Code == rec),]$Deploy_lat <- trimble[(trimble$Name == rec),]$deploy_lat
}

#write.csv(recs, "./data/Receivers_IDs_locaties_deployment_2023.csv",
#          row.names=F)
