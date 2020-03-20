# calculate prewar (Tinley) occupancy across the grid cells

library(tidyverse)
library(magrittr)

# bring in count of species in each hex grid
hex_summary <- read.csv("data/hex-summary.csv")
head(hex_summary)

# calculate occupancy for each species in each count
hex_occupancy <- hex_summary %>% 
  select(Species, Count, StudySite) %>% 
  filter(Count < 1973) %>%  # take only Tinley prewar counts
  mutate(Occupancy = 1) 

# create dataframe with all possible combinations, and replace NA with 0 (species absence)
all <- hex_occupancy %>% 
  expand(Species, Count, StudySite) %>% # expand into all possible combos of these three variables
  left_join(hex_occupancy) %>%  # join back in with the Occupancy data
  replace_na(list(Occupancy = 0)) # replace NA with 0

head(all)

# calculate average occupancy for each species in each year
occupancy_mean <- all %>% 
  group_by(Species, Count) %>% 
  summarise(Occupancy_Mean = mean(Occupancy))




# Plot and explore --------------------------------------------------------

# bring in raw data and subset to Tinley (filter to counts before 1980)
aerial_data_tinley <- read_csv(here::here("data", "aerial-count", "stalmans-plosone-data.csv")) %>%
  filter(Count < 1980)

# create sf object
tinley_sf <- st_as_sf(aerial_data_tinley, 
                      coords = c("Longitude", "Latitude"),
                      crs = 4326) 

# bring in camera hexes
hexes <- st_read(here::here('data', 'camera-trap'), 'CameraGridHexes') %>% 
  st_transform(crs = 4326)

# map the points onto the hexagonal grid cells
tinley_data_hexes <- st_join(tinley_sf, hexes,
                             left = FALSE) # will make an inner join rather than a left join (drop points outside of hexes)

mapview(tinley_data_hexes, zcol = "Species")

# next steps to visualize occupancy across grid cells.... maybe I'm getting way ahead of myself