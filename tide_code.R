library(tidyverse)
library(splitstackshape)
library(readxl)

tides_raw = read.csv('data/Untitled spreadsheet - Feb.csv')

tides_cleaned = tides_raw %>%
  pivot_longer(cols = names(tides_raw)[2:length(names(tides_raw))],
               names_to = 'date',
               values_to = 'time_height') %>%
  mutate(time_height = str_replace_all(time_height, 'M', 'M_')) %>%
  pivot_wider(names_from = 'Tide', values_from = 'time_height') %>%
  cSplit(splitCols = 'high', sep = '\n', direction = 'wide') %>%
  cSplit(splitCols = 'low', sep = '\n', direction = 'wide') %>%
  cSplit(splitCols = c('high_1', 'high_2', 'low_1', 'low_2'), sep = '_') %>%
  rename(high_1_time = high_1_1,
         high_1_height = high_1_2,
         high_2_time = high_2_1,
         high_2_height = high_2_2,
         low_1_time = low_1_1,
         low_1_height = low_1_2,
         low_2_time = low_2_1,
         low_2_height = low_2_2
         )

write.csv(tides_cleaned, file = 'data/tides_cleaned.csv')
  
  


  
