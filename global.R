library(shiny)
library(shinydashboard)
library(tidyverse)
library(dashboardthemes)
library(reactable)
library(googlesheets4)
library(googledrive)
library(shinyWidgets)

# designate project-specific cache
options(gargle_oauth_cache = ".secrets")
# check the value of the option, if you like
gargle::gargle_oauth_cache()
# trigger auth on purpose to store a token in the specified cache
# a broswer will be opened
googlesheets4::sheets_auth()
# see your token file in the cache, if you like
list.files(".secrets/")
# sheets reauth with specified token and email address
sheets_auth(
  cache = ".secrets",
  email = T
)

init_origin <- 'library(shiny)
df <- iris
iris_species <- iris$Species'

init_input <- 'library(shiny)
df <- iris
iris_species <- iris$species'

desc_student <- "You will receive all text and syntax shared by the instructor. Enter the code from the instructor. If you do not receive any code, ask the instructor to set the code"

desc_instructor <- "All your text that is written on the compare code Tab will be shared to student who enter your instructor code"

url <- "https://docs.google.com/spreadsheets/d/1BVj6Id4qBlfSpeANZAePQtk-86xc8B8KA-CJ3-MgyUU/edit?usp=sharing"

df <- read_sheet(url)

df_code <- df %>% 
  distinct(instructor_code) %>% 
  pull(instructor_code)

print(df)