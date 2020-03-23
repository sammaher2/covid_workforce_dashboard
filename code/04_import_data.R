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

write.csv(data_in2, "scratch/data_in2.csv")

cps_data <- data_in %>%
  filter((asecflag!=1 | is.na(asecflag)),year>2017) %>%
  mutate_at(vars(occ,ind),~str_pad(.,4,"left",0)) %>%
  mutate_at(vars(occ,ind),~na_if(.,"0000")) %>%
  mutate(metfips=str_pad(metfips,5,"left","0"),
         earnweek=ifelse(earnweek==9999.99,NA,earnweek)) %>%
  left_join(.,ind_refs %>% select(-ind_name),by=c("ind"="ind_code"))