#Pull and process only data from 2016 through 2018


nhis_2016 <- nhis_recorded %>% 
  filter(year >= 2016) %>%
  filter(employed ==1) %>%
  filter(ind != "0000") %>% 
   #make sure to remove variables they didn't have for this year
  select(-c(description, essential, critical_sub, hospital, hospitals_plus, 
            nursing_facilities, coronary_dis,immunodef, employed)) %>%
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


colnames(nhis_2016)[9:length(colnames(nhis_2016))]<-paste0("risk.",colnames(nhis_2016)[9:length(colnames(nhis_2016))])

write.csv(nhis_2016, "outputs/nhis_2016_raw.csv")   #this gets things in the right formart and I don't know why, need to fix
nhis_2016 <- read.csv("outputs/nhis_2016_raw.csv")    #same here

nhis_2016_occ <- nhis_2016 %>%
  select(year, region, ind, occ, sampweight) %>%
  pivot_longer(cols = "occ", names_to = "occ") %>%
  mutate(occ = value) %>%  select(-value) %>%
  group_by(year, region, ind, occ) %>%
  count(people_ind = sum(sampweight)) %>%
  mutate(num_samp_ind = n)  %>%
  select(-n) %>%
  group_by(region,ind,occ) %>%
  summarize(n_average_ind = mean(num_samp_ind), ppl_average_ind = mean(people_ind)) %>%
  mutate(reg.ind.occ = paste(region, ind, occ, sep = "."))

nhis_2016_risk <- nhis_2016 %>%
  mutate_at(vars(starts_with("risk")), ~ifelse(.!=0, .* sampweight, 0)) %>%
  select(-perweight) %>%
  pivot_longer(cols = starts_with("risk"), names_to = "risk.factor") %>%
  filter(value != 0) %>%  
  group_by(year, region, ind, occ, risk.factor) %>% 
  count(people_ind_risk = sum(sampweight)) %>%
  mutate(num_samp_ind_risk = n)  %>%
  select(-n) %>%
  group_by(region,ind,occ,risk.factor) %>%
  summarize(n_average_risk = mean(num_samp_ind_risk), ppl_average_risk = mean(people_ind_risk)) %>%
  mutate(reg.ind.occ = paste(region, ind, occ, sep = "."))


write.csv(nhis_2016_occ, "outputs/nhis_2016_occ.csv")
nhis_2016_occ <- read.csv("outputs/nhis_2016_occ.csv")
write.csv(nhis_2016_risk, "outputs/nhis_2016_risk.csv")
nhis_2016_risk <- read.csv("outputs/nhis_2016_risk.csv")


nhis_2016_final <- nhis_2016_risk %>%
  left_join(.,nhis_2016_occ %>% select(reg.ind.occ, n_average_ind, ppl_average_ind), by=c("reg.ind.occ"="reg.ind.occ")) %>%
  select(-X)

write.csv(nhis_2016_final, "outputs/nhis_2016_final.csv")


#write.csv(nhis_2018_final, "outputs/nhis_2018_final.csv")
#write.csv(nhis_2018_final, "outputs/nhis_2018_final_noBMI.csv")


# 
#            
#            
# 
#            
