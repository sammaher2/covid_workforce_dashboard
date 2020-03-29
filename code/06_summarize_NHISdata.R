#Pull and process only data from 2018


nhis_2018 <- nhis_recorded %>% 
     filter(year == 2018) %>% 
     select(-c(description, essential, critical_sub, hospital, hospitals_plus, nursing_facilities) )

colnames(nhis_2018)[10:length(colnames(nhis_2018))]<-paste0("risk.",colnames(nhis_2018)[10:length(colnames(nhis_2018))])

write.csv(nhis_2018, "outputs/nhis_2018_raw.csv")   #this gets things in the right formart and I don't know why, need to fix
nhis_2018 <- read.csv("outputs/nhis_2018_raw.csv")    #same here

nhis_2018_final <- nhis_2018 %>%
  #mutate(risk.bmi = ifelse(risk.bmi == is.na(risk.bmi), 0, risk.bmi)) %>%
  #mutate_at(vars(starts_with("risk")), as.integer(.)) %>%
  select(-risk.coronary_dis)  %>% #variable not available for 2018
  mutate_at(vars(starts_with("risk")), ~ifelse(.!=0, .* perweight, 0)) %>%
  pivot_longer(cols = starts_with("risk"), names_to = "risk.factor") %>%
  filter(value != 0) %>%  #
  #select(-value) %>%
  group_by(region, ind, occ, risk.factor) %>%
  summarize(people = sum(perweight))

write.csv(nhis_2018_final, "outputs/nhis_2018_final.csv")


















#fills in empty data matrix with values

# dummy_2018 <- dummy_nhis %>%
#               filter(year == "2018") %>%
#               mutate(num_reg = 0,
#                      num_reg_ind = 0,
#                      num_reg_ind_occ = 0,
#                      num_reg_ind_occ_risk = 0)
# 
# save(dummy_2018, file ="outputs/industry_risk_dummy.Rdata")



# 
# nhis_subset <- read.csv("outputs/nhis_subset.csv")
# 
# data.x <- nhis_subset
# 
# data.x <- data.x %>%
#   select(-c(description, essential, critical_sub, hospital, hospitals_plus, nursing_facilities) )
# 
# colnames(data.x)[9:length(colnames(data.x))-1]<-paste0("risk.",colnames(data.x)[9:length(colnames(data.x))-1])
# 
# 
# data.x <- data.x %>%
#   pivot_longer(cols = starts_with("risk"), names_to = "risk.factor") %>%
#   filter(value == 1) %>%
#   select(-value) %>%
#   group_by(region, ind, occ, risk.factor) %>%
#   summarize(people = sum(num_sampled))
# 
# 
# 

#Population of each region according to https://www.census.gov/popclock/data_tables.php?component=growth
# pop_NE <- 56046620 #shouldn't need these anymore with the sampling weights
# pop_MW <- 68236628	#
# pop_S <- 77834820	#
# pop_w <- 124569433 # 	
# samp_NE <- nrow((unique(nhis_recorded %>% filter(region == "1") %>% select(nhispid))))
# samp_MW <- nrow((unique(nhis_recorded %>% filter(region == "2") %>% select(nhispid))))
# samp_S <- nrow((unique(nhis_recorded %>% filter(region == "3") %>% select(nhispid))))
# samp_W <- nrow((unique(nhis_recorded %>% filter(region == "4") %>% select(nhispid))))

# nhis_math <- nhis_recorded %>%
#             filter(year == "2018") %>%  
#                      mutate(num_sampled = ifelse(region==1, samp_NE, NA),
#                    num_sampled = ifelse(region==2, samp_MW,num_sampled),
#                    num_sampled = ifelse(region==3, samp_S,num_sampled),
#                    num_sampled = ifelse(region==4, samp_W ,num_sampled) 
#                    ) %>%
#             mutate(total_pop = ifelse(region == 1, pop_NE, 
#                                       ifelse(region ==2, pop_MW,
#                                       ifelse(region ==3, pop_S,
#                                       ifelse(region==4,pop_w, NA))))  
#                                     )
# nhis_math <- nhis_math %>%
#            mutate(percent_sampled = 100*num_sampled/total_pop) %>%
#            mutate(factor = total_pop/num_sampled)   %>% #factor to multiple final # of people 
#            mutate(region = ifelse(region==1, "Northeast",region),
#                   region = ifelse(region==2, "North Central/Midwest",region),
#                   region = ifelse(region==3, "South",region),
#                   region = ifelse(region==4, "West",region)    #%>%
#            )
#       
# 
# data_2018 <- dummy_2018 %>%
#           mutate(total_pop_reg = ifelse(region == 1, pop_NE, 
#                          ifelse(region ==2, pop_MW,
#                          ifelse(region ==3, pop_S,
#                          ifelse(region==4,pop_w, NA))))  
#           )  %>%
# mutate(region = ifelse(region==1, "Northeast",region),
#        region = ifelse(region==2, "North Central/Midwest",region),
#        region = ifelse(region==3, "South",region),
#        region = ifelse(region==4, "West",region)    #%>%
# )
# 
#            
#            
# 
#            
