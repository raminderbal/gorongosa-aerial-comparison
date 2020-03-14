# Not all species were counted in all counts; here we summarize the species present in each count

# read in aerial count data from Stalmans et al Plos One paper
aerial_data <- read_csv(here::here("data", "aerial-count", "stalmans-plosone-data.csv")) 

unique(aerial_data$Species)

# change the names to match mine
aerial_data <- aerial_data %>%
  mutate(Species = fct_recode(Species, "Wildebeest" = "Blue wildebeest")) %>%
  mutate(Species = fct_recode(Species, "Wildebeest" = "Blue Wildebeest")) %>%
  mutate(Species = fct_recode(Species, "Reedbuck" = "Common reedbuck")) %>%
  mutate(Species = fct_recode(Species, "Duiker_common" = "Duiker grey")) %>%
  mutate(Species = fct_recode(Species, "Duiker_red" = "Duiker red")) %>%
  mutate(Species = fct_recode(Species, "Sable_antelope" = "Sable")) %>% 
  mutate(Species = fct_recode(Species, "Oribi" = "oribi"))

unique(aerial_data$Species)

# count records per year
aerial_summary <- aerial_data %>% 
  group_by(Count, Species) %>% 
  arrange() %>% 
  summarise(Number = n()) %>% 
  pivot_wider(names_from = Count, values_from = Number)

aerial_summary

write.csv(aerial_summary, "data/species-counts-by-year.csv")

