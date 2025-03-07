# Init functions:
# These functions help to initialize the project without
# leaving artifacts in the workspace

#####################################################
#Loading and installing packages
init.pacs <- function(package.list){
  check <- unlist(lapply(package.list, require, character.only = TRUE))
  #Install if not in default library
  if(any(!check)){
    for(pac in package.list[!check]){
      install.packages(pac)
    }
    lapply(package.list, require, character.only = TRUE)
  }
}
#unit test
#init.pacs(c("scales"))


#####################################################
#Run all scripts in a directory
run.script <- function(dir.name){
  #check whether directory exists
  if(dir.exists(dir.name)){
    if(!is.null(dir(dir.name,pattern = ".R"))){
      invisible(lapply(dir(dir.name,pattern = ".R",full.names = T),source))
    }
  } else {
    stop("Invalid directory name")
  }
}
#unit test
#run.script("functions")

#This function builds out the folder structure
folder.setup <- function(){
  require(purrr)
  folder.list <- c("code",
                   "cache",
                   "inputs",
                   "functions",
                   "outputs")
  
  map(folder.list,
      function(x){
        if(!dir.exists(x)){
          dir.create(x,recursive = T)
          message(str_c("The ",x," folder has been created."))
        } else {
          message(str_c("The ",x," folder already exists."))
        }
      })
  
  return(NULL)
}