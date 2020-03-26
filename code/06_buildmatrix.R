#create dummy data set
conflict_prefer("filter", "dplyr")

dummy_ind <- nhis_recorded %>%
             select(year,region,ind,occ)

risk_factors <- as.data.frame(t(colnames(nhis_recorded)))
colnames(risk_factors) <- colnames(nhis_recorded)
risk_cat <- risk_factors %>%
                        select(-c(year, region,nhispid,age,
                                description,essential,critical_sub,hospital,
                                hospitals_plus, nursing_facilities,over50,over40))
                       


length_dum <- length(risk_cat)*length(unique(dummy_ind$year))*length(unique(dummy_ind$region))*length(unique(dummy_ind$occ))*length(unique(dummy_ind$ind))

year <- rep(sort(unique(dummy_ind$year)), length_dum/length(unique(dummy_ind$year))) 
region <- rep(sort(unique(dummy_ind$region)), length_dum/length(unique(dummy_ind$region)))
ind <- rep(sort(unique(dummy_ind$ind)), length_dum/length(unique(dummy_ind$ind)))
occ <- rep(sort(unique(dummy_ind$occ)), length_dum/length(unique(dummy_ind$occ)))

risk <- rep(sort(colnames(risk_cat)), length_dum/length(risk_cat))

dummy_nhis <- matrix(0, nrow = length_dum, ncol = 5) 
colnames(dummy_nhis) <- c("year", "region", "ind", "occ", "risk_factors") 

#can i just colbind here?  make mini charts with all the variables i need 
for(j in 1:length_dum){
  dummy_nhis[j,1]<- year[j]
  dummy_nhis[j,2]<- region[j]
  dummy_nhis[j,3]<- ind[j]
  dummy_nhis[j,4]<- occ[j]
  dummy_nhis[j,5]<- risk[j]
}

dummy_nhis <- as.data.frame(dummy_nhis)
dummy_nhis <- dummy_nhis %>% 
    arrange(risk_factors) %>% 
    arrange(occ) %>% 
    arrange(ind) %>% 
    arrange(region) %>% 
    arrange(year)
  
    

