###DINO APP
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinycssloaders)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(DT)
library(caret)
library(stargazer)

setwd("C:\\Users\\UTENTE\\Documents\\R\\dino")
#basedir = ("C:\\Users\\UTENTE\\Documents\\R\\dino")

source("dino_ui.r", local = TRUE)
source("dino_server.r")

####################################
# Create Shiny object              #
####################################
shinyApp(
  ui = dino_ui,
  server = dino_server
)

