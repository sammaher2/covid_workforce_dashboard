#Build dataset

#############################
#Extract zipped data extract from ipums
if(!file.exists("inputs/nhis_00001.dat")){
  gunzip("inputs/nhis_00001.dat.gz",remove=F)
}

#################################
#Read in data
data_in2 <- read_ipums_micro(ddi="inputs/nhis_00001.xml",
                            data_file = "inputs/nhis_00001.dat") %>%
    rename_all(str_to_lower)

#write.csv(data_in2, "scratch/data_in2.csv")
#sunique_data2 <- lapply(data_in2, unique)

nhis_data <- data_in2 %>%
  mutate_at(vars(occ,ind),~na_if(.,"0000")) %>%  #makes all 0000 codes NA
   mutate(indstrn104 = as.character(indstrn104),
          occupn104 = as.character(occupn104)) %>%
   mutate(indstrn104=str_pad(indstrn104,4,"left","0"), 
          occupn104=str_pad(occupn104,4,"left","0")) %>%
   left_join(.,ind_refs_nhis, by=c("indstrn104"="ind_code")) # %>%
   #left_join(.,occ_refs_nhis, by=c("occupn104"="occ_code"))

save(nhis_data,file = "cache/nhis_data.Rdata")
