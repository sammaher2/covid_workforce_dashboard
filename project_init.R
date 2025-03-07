#This script initializes the project and should be run at the beginning of each
#session

#########################
#Load init functions
source("functions/init_functions.R")

#Loading and installing packages
init.pacs(c("tidyverse",      #shortcut to many useful packages (eg, dplyr, ggplot)
            "conflicted",     #resolves function conflict across packages
            "lubridate",      #working with dates
            "sf",             #for GIS
            "USAboundaries",  #easily access US maps in sf
            "tigris",         #census maps
            "cowplot",
            "svDialogs",      #dialog boxes on all platforms
            "googledrive",
            "readxl",
            "ipumsr",
            "data.table",
            "labelled",
            "gtools",
            "R.utils",
            "scales"

))

#Setting package::function priority with conflicted package
conflict_prefer("filter", "dplyr")
conflict_prefer("between", "dplyr")
conflict_prefer("ggsave", "ggplot2")
conflict_prefer("vars", "dplyr")
conflict_prefer("year", "lubridate")
conflict_prefer("recode", "dplyr")
conflict_prefer("na_if", "dplyr")

options(scipen = 999)


#########################
#Loading project helper functions (all scripts within folder)
run.script("functions")

#Setup project directory
folder.setup()

#Check if data has been downloaded
if(!file.exists("inputs/cps_00005.dat.gz")){
  stop("Please download the data from: https://drive.google.com/drive/folders/1YtuHk_iK5QBj3IM_NhdWrL4BpT3ckQBI?usp=sharing")

} else {
  source("code/00-build.R")
}

#Check if data has been downloaded for HIS
if(!file.exists("inputs/inputs/nhis_00002.dat.gz")){
  stop("Please download the data from: https://drive.google.com/drive/folders/1IalDjovcZ4Hc9tRuDP3O8k7LK1zG9evL?usp=sharing")
  
} else {
  source("code/00-build.R")
}

shell("ignore_large.sh")

#dlgMessage("Do you need to pull the repo?")
