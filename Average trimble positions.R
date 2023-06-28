source("Libraries.R")

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
  select(-Name) %>%
  rename(Name = V1,
         Measure = V2)

GPS <- trimble %>%
  group_by(Name) %>%
  summarise(Easting = mean(Easting),
            Northing = mean(Northing)) %>%
  st_as_sf(coords = c("Easting", "Northing"), crs="EPSG:31370", remove = F) %>%
  st_transform(crs = "EPSG:4326")

