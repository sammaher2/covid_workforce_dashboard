#Extract occupation codes
get_nhis_ind_codes <- function(){

  #Dependencies
  require(googledrive)
  require(dplyr)
  require(readxl)
  require(janitor)
  require(rvest)
  ########################################

  #Pull latest copy of the shared google sheet from 
  drive_download(file=as_id("1El3XUkgUbPRglRl3BCAl5ErDIkWJnqxtt_uXDs8QCMM"),
                 path = "inputs/reference_codes.xlsx",
                 overwrite = T)
  
  #Read in data from ind_code
  ind_refs_nhis <- read_excel(path = "inputs/reference_codes.xlsx",
                         sheet = "ind_nhis") %>%
    clean_names("snake") %>%
    mutate(essential=ifelse(essential=="x",1,essential),  #SAM THIS IS THE LINE YOU CHANGED
           ind_code=str_pad(ind_code,4,"left","0")) 
  
  ind_codes_nhis <- ind_refs_nhis %>%
    select(ind_code, description)
  
    save(ind_codes_nhis,ind_refs_nhis,file="cache/ind_codes_nhis.Rdata")
}

#Extract occupation codes
get_nhis_occ_codes <- function(){
  
  #Dependencies
  require(googledrive)
  require(dplyr)
  require(readxl)
  require(janitor)
  require(rvest)
  ########################################
  
  #Pull latest copy of the shared google sheet from 
  drive_download(file=as_id("1El3XUkgUbPRglRl3BCAl5ErDIkWJnqxtt_uXDs8QCMM"),
                 path = "inputs/reference_codes.xlsx",
                 overwrite = T)
  
  #Read in data from ind_code
  occ_refs_nhis <- read_excel(path = "inputs/reference_codes.xlsx",
                              sheet = "occ_nhis") %>%
    clean_names("snake") %>%
    mutate(essential=ifelse(essential=="x",1,essential),  #SAM THIS IS THE LINE YOU CHANGED
           occ_code=str_pad(occ_code,4,"left","0")) 
  
  occ_codes_nhis <- occ_refs_nhis %>%
    select(occ_code, description)
  
  save(occ_codes_nhis,occ_refs_nhis,file="cache/occ_codes_nhis.Rdata")
}
