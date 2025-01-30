library(tidyverse)
library(splitstackshape)

d = read.csv("C:/Users/spenshi/Downloads/Annual_Predictions_Comox_2025.csv")

d_reshaped = d %>%
  cSplit(splitCols = 'Date.and.time..PST.', sep = 'T')
names(d_reshaped) = c('Metres', 'Date', 'Time')

tide_types = c('Low-low', 'High-high', 'High-low', 'Low-high') #different types of tides and the order in which they occur

#determine what type of tide the first one is
first_four = d_reshaped$Metres[1:4]
first_four_ranks = rank(first_four)
rank_of_first = first_four_ranks[1]

type_of_first = case_match(rank_of_first,
                           1 ~ 'Low-low',
                           2 ~ 'High-low',
                           3 ~ 'Low-high',
                           4 ~ 'High-high')

#Get type for every tide in dataframe
start_index <- which(tide_types == type_of_first) #index at start of tide type
tide_types_alt <- tide_types[c(start_index:length(tide_types), 1:(start_index - 1))] #reset sequence of tide types based on type of first
tide_types_alt = tide_types_alt[1:4] #drop extra entry from the end


d_reshaped$Tide_type = rep(tide_types_alt, length.out = nrow(d_reshaped))

d_summ = d_reshaped %>%
  group_by(Date) %>%
  summarize(N_tides = n(),
            Low_low = min(Metres),
            Other_low = nth(Metres, 2, order_by = Metres))
