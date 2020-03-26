#fills in empty data matrix with values

dummy_2018 <- dummy_nhis %>%
              filter(year == "2018") %>%
              mutate(num_people = 0)

dummy_2018 <- dummy_2018 

save(dummy_2018, file ="outputs/industry_risk_dummy.Rdata")

nhis_math <- nhis_recorded %>%
            filter(year == "2018") %>%
            mutate(num_sampled = length(unique(nhispid)))  %>%
            mutate(total_pop = ifelse(region == 1, 1, 
                                      ifelse(region ==2, 2,
                                      ifelse(region ==3,3,
                                      ifelse(region==4,4,NA))))  
                                    )
           mutate(percent_sampled = num_sampled/total_pop) %>%
           mutate(factor = total_pop/num_sampled)    #factor to multiple final # of people 
           
