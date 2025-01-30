library(tidyverse)
library(splitstackshape)

d = read.csv("C:/Users/spenshi/Downloads/Annual_Predictions_Comox_2025.csv")

d_reshaped = d %>%
  cSplit(splitCols = 'Date.and.time..PST.', sep = 'T')
names(d_reshaped) = c('Metres', 'Date', 'Time')

tide_types = c('Low-low', 'High-high', 'High-low', 'Low-high') #different types of tides and the order in which they occur

#determine what type of tide the first one is
first_type = ifelse(d_reshaped$Metres[1] < d_reshaped$Metres[2], 'Low', 'High')

if(first_type == 'Low'){
  d_reshaped$Tide_type = rep(c('Low', 'High'), length.out = nrow(d_reshaped))
} else {
  d_reshaped$Tide_type = rep(c('High', 'Low'), length.out = nrow(d_reshaped))
}

d_reshaped$id = rep(c(1,1,2,2), length.out = nrow(d_reshaped))

d_reshaped_wide = d_reshaped %>%
  mutate(Tide_id = paste0(Tide_type,'_',id)) %>%
  select(Date, Metres, Time, Tide_id) %>%
  pivot_wider(names_from = Tide_id, values_from = c(Metres,Time)) %>%
  mutate(Daily_low_height = min(Metres_Low_1, Metres_Low_2, na.rm=T)) %>%
  mutate(Daily_low_time = ifelse(Metres_Low_1 == Daily_low_height, Time_Low_1, Time_Low_2))

#final dataframe
print(d_reshaped_wide)
