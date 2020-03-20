

#Extract occupation codes
get_cps_occ_codes <- function(){
  require(rvest)
  require(dplyr)
  cps.pointer <- read_html("https://cps.ipums.org/cps/codes/occ_2011_codes.shtml")
  
  occ_codes <- cbind(
    cps.pointer %>%
      html_nodes("dt") %>%
      html_text(),
    cps.pointer %>%
      html_nodes("dd") %>%
      html_text()
  ) %>%
    as_tibble(.name_repair = ~ c("codes", "description"))
  
  #############################
  #Defining health occupation subsets
  
  #Define health category
  occ_health_all <- occ_codes %>% 
    filter(codes %in% as.character(seq.int(3000,3655)))
  
  #Define specific health sector
  occ_health_subset <- occ_codes %>%
    filter(codes %in% c(
      "3210",
      "3060",
      "3256",
      "3110",
      "3220",
      "3255",
      "3258",
      "3260",
      "3300",
      "3320",
      "3400",
      "3420",
      "3500",
      "3510",
      "3540",
      "3600",
      "3645",
      "0350",
      "1650",
      "2025"
    ))
  
  
  
  
  save(occ_codes,occ_health_subset,occ_health_all,file = "cache/occ_codes.Rdata")
  
  return(NULL)
}


get_cps_metfips_codes <- function(){
  require(rvest)
  require(dplyr)
  cps.pointer <- read_html("https://cps.ipums.org/cps/codes/metfips_2014onward_codes.shtml")
  
  met_codes <- cbind(
    cps.pointer %>%
      html_nodes("dt") %>%
      html_text(),
    cps.pointer %>%
      html_nodes("dd") %>%
      html_text()
  ) %>%
    as_tibble(.name_repair = ~ c("codes", "description"))
  
  save(met_codes,file = "cache/met_codes.Rdata")
}


get_cps_ind_codes <- function(){
  #This function scrapes the CPS table and reads the google sheet defining occupation code subsets
  
  #Dependencies
  require(googledrive)
  require(dplyr)
  require(readxl)
  require(janitor)
  require(rvest)
  ########################################
  cps.pointer <- read_html("https://cps.ipums.org/cps/codes/ind_2014_codes.shtml")
  
  ind_codes <- cbind(
    cps.pointer %>%
      html_nodes("dt") %>%
      html_text(),
    cps.pointer %>%
      html_nodes("dd") %>%
      html_text()
  ) %>%
    as_tibble(.name_repair = ~ c("codes", "description"))
  
  
  #Pull latest copy of the shared google sheet from 
  drive_download(file=as_id("1El3XUkgUbPRglRl3BCAl5ErDIkWJnqxtt_uXDs8QCMM"),
                 path = "inputs/reference_codes.xlsx",
                 overwrite = T)
  
  #Read in data from ind_code
  ind_refs <- read_excel(path = "inputs/reference_codes.xlsx",
                         sheet = "ind_code") %>%
    clean_names("snake") %>%
    mutate(essential=ifelse(essential=="x",1,essential),
           ind_code=str_pad(ind_code,4,"left","0")) 
  
  
  save(ind_codes,ind_refs,file="cache/ind_codes.Rdata")
  
}


get_labels <- function(df,var.name){
  df %>%
    select(!!var.name) %>%
    distinct() %>%
    transmute(code=!!as.name(var.name),
              description=to_factor(code)) %>%
    arrange(code)
}

#unit test
#get_labels(df=cps_data,var.name="relate")

  
