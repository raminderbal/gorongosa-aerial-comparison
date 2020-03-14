# calculate postwar richness in each of the grid cells

library(tidyverse)
library(magrittr)

# bring in count of species in each hex grid
hex_summary <- read.csv("data/hex-summary.csv")
head(hex_summary)

# calculate richness for each count
hex_richness <- hex_summary %>% 
  select(Species, Count, StudySite) %>% 
  group_by(StudySite, Count) %>% 
  summarise(Richness = n())

head(hex_richness)

# stalmans considered 1994, 1997, 2000, 2001, 2002 as "post-war" counts
# calculate richness for all post-war counts combined
hex_richness_postwar <- hex_summary %>% 
  select(Species, Count, StudySite) %>% 
  filter(Count %in% (1994:2002)) %>% 
  group_by(StudySite) %>% 
  summarise(Richness = n())

hex_richness_postwar$Count <- "Postwar"
hex_richness$Count %<>% as.character()
hex_richness <- bind_rows(hex_richness, hex_richness_postwar)

write.csv(hex_richness, "data/hex-richness.csv", row.names=F)

  
# bring in all records (not just in camera grid)
aerial_summary <- read_csv("data/species-counts-by-year.csv")
aerial_summary

# 1994 only has 7 species, so probably not good to use

# bring in raw data for plotting
aerial_data_2001 <- read_csv(here::here("data", "aerial-count", "stalmans-plosone-data.csv")) %>% 
  filter(Count == "2001")
aerial_data_2001 <- st_as_sf(aerial_data, coords = c("Longitude", "Latitude"), crs = 4326)
mapview(aerial_data_2001)
