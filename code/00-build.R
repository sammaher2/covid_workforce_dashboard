#This script serves as a makefile for the project


##################################################
#Load preliminaries
if(!file.exists("cache/occ_codes.Rdata")){
  get_cps_occ_codes()
}
load("cache/occ_codes.Rdata")

if(!file.exists("cache/ind_codes.Rdata")){
  get_cps_ind_codes()
}
load("cache/ind_codes.Rdata")


if(!file.exists("cache/met_codes.Rdata")){
  get_cps_metfips_codes()
}
load("cache/met_codes.Rdata")

if(!file.exists("cache/cps_data.Rdata")){
  source("code/01_import_data.R")
}
load("cache/cps_data.Rdata")

if(!file.exists("cache/cps_co.Rdata")){
  source("code/02_process_data.R")
}
load("cache/cps_co.Rdata")
  
###########NHIS DATA
if(!file.exists("cache/ind_codes_nhis.Rdata")){
  get_nhis_ind_codes()
}
load("cache/ind_codes_nhis.Rdata")

if(!file.exists("cache/occ_codes_nhis.Rdata")){
  get_nhis_ind_codes()
}
load("cache/occ_codes_nhis.Rdata")






############################################
#Summarize the data
message("Open 03_summarize_data.R to build out dataset.")