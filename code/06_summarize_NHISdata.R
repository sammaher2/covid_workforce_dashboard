#Pull and process only data from 2018


nhis_2018 <- nhis_recorded %>% 
     filter(year == 2018) %>%    #make sure to remove variables they didn't have for this year
     select(-c(description, essential, critical_sub, hospital, hospitals_plus, nursing_facilities, coronary_dis,immunodef)) %>%
       mutate(risk_sum = heart_cond + hypertension + diabetes +
            cancer + hepatic_dis+ hepatitus+ asthma+
            high_cholesterol + ever_smoked + bmi) %>%
      mutate(risk_sum_noBMI = heart_cond + hypertension + diabetes +
           cancer + hepatic_dis+ hepatitus+ asthma+
           high_cholesterol + ever_smoked) %>%
   mutate(over60_plus_risk = ifelse(risk_sum >= 1 & over60 ==1 , 1, 0)) %>%
   mutate(over60_plus_risk_n0BMI = ifelse(risk_sum_noBMI >= 1 & over60 ==1 , 1, 0)) %>%
   mutate(any_risk = ifelse(risk_sum >= 1, 1, 0))  %>%
   mutate(any_risk_noBMI = ifelse(risk_sum_noBMI >= 1, 1, 0))  %>%
   select(-c(risk_sum, risk_sum_noBMI))


colnames(nhis_2018)[9:length(colnames(nhis_2018))]<-paste0("risk.",colnames(nhis_2018)[9:length(colnames(nhis_2018))])

write.csv(nhis_2018, "outputs/nhis_2018_raw.csv")   #this gets things in the right formart and I don't know why, need to fix
nhis_2018 <- read.csv("outputs/nhis_2018_raw.csv")    #same here

nhis_2018_occ <- nhis_2018 %>%
  select(region, ind, occ, perweight) %>%
  pivot_longer(cols = "occ", names_to = "occ") %>%
  mutate(occ = value) %>%
  select(-value) %>%
  group_by(region, ind, occ) %>%
  count(people_ind = sum(perweight)) %>%
  mutate(num_samp_ind = n)  %>%
  select(-n) %>%
  mutate(reg.ind.occ = paste(region, ind, occ, sep = "."))


nhis_2018_final <- nhis_2018 %>%
   mutate_at(vars(starts_with("risk")), ~ifelse(.!=0, .* perweight, 0)) %>%
  select(-sampweight) %>%
  pivot_longer(cols = starts_with("risk"), names_to = "risk.factor") %>%
  filter(value != 0) %>%  
  group_by(region, ind, occ, risk.factor) %>% 
  count(people_ind_risk = sum(perweight)) %>%
  mutate(num_samp_ind_risk = n)  %>%
  select(-n) %>%
  mutate(reg.ind.occ = paste(region, ind, occ, sep = "."))
  

write.csv(nhis_2018_occ, "outputs/nhis_2018_temp.csv")
nhis_2018_occ <- read.csv("outputs/nhis_2018_temp.csv")
write.csv(nhis_2018_final, "outputs/nhis_2018_final.csv")
nhis_2018_final <- read.csv("outputs/nhis_2018_final.csv")
  
  

nhis_2018_final <- nhis_2018_final %>%
             left_join(.,nhis_2018_occ %>% select(reg.ind.occ, num_samp_ind, people_ind), by=c("reg.ind.occ"="reg.ind.occ")) %>%
            select(-X)


write.csv(nhis_2018_final, "outputs/nhis_2018_final.csv")

write.csv(nhis_2018_final, "outputs/nhis_2018_final_noBMI.csv")

######### TEST ###############





# #Make Keys
# key_reg <- nhis_recorded  %>%
#             select(region) %>%
#             unique() %>%
#             mutate(region_name = ifelse(region==1, "Northeast", region),
#                    region_name = ifelse(region==2, "North Central/Midwest",region_name),
#                    region_name = ifelse(region==3, "South",region_name),
#                    region_name = ifelse(region==4, "West",region_name) 
#             ) %>%
#             arrange(region)
# 
# write.csv(key_reg, "inputs/key_reg.csv")
# write.csv(occ_codes_nhis, "inputs/key_occ.csv")
# write.csv(ind_codes_nhis, "inputs/key_ind.csv")
# 
# 
# write.csv(c(occ_codes_nhis, ind_codes_nhis, key_reg), c("inputs/key_occ.csv", "inputs/key_ind.csv", "inputs/key_reg.csv"))














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
