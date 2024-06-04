library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinycssloaders)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(DT)
library(corrplot)
library(stargazer)
library(wooldridge)
library(Synth)   #package Syntethic Control Method
library(foreign) ; library(tsModel) ; library("lmtest") ; library("Epi")
library("splines") ; library("vcd")

#setwd("C:/Users/UTENTE/Documents/R/dino")
# basedir = ("C:/Users/UTENTE/Documents/R/dino")

source("about_ui.R")
source("intro_ui.R")
source("r_adj_ui.R")
source("scm_ui.R")
source("itsa_ui.R")
source("dataset.R")

####################################
# DINO User interface              #
####################################
dino_ui <- shinyUI({
  
  fluidPage(theme = shinytheme("sandstone"), #sandstone cosmo journal
            navbarPage(
              p("DINO - Policy Evaluation App",style="color:yellow;text-align:justify;bold"),  ### APP NAME
              
              ########## ABOUT
              about_ui(),
              
              ########## INTRO POLICY EVALUATION
              intro_ui(),
              
              ########## REGRESSION ADJUSTMENT PANEL
              r_adj_ui(),
              
              ########### SYNTHETIC CONTROL METHOD PANEL
              scm_ui(),
              
              ########### ITSA PANEL
              itsa_ui(),
              
              ########### DID PANEL
              tabPanel("DID", "Coming soon"),
              
              ########### RDD PANEL
              tabPanel("RDD", "Coming soon"),
              
              ########### MATCHING PANEL
              tabPanel("Matching", "Coming soon"),
              
              ########### GPS PANEL
              tabPanel("GPS", "Coming soon"),
              
              ########### IV PANEL
              tabPanel("IV", "Coming soon"),
              
            ) # END navbarPage
  )# END fluidPage
})

####################################
# DINO Server                      #
####################################

source("scm_server.R")
source("r_adj_server.R")
source("itsa_server.R")

# Funzione server principale
dino_server <- function(input, output, session) {
  r_adj_server(input, output, session)
  scm_server(input, output, session)
  itsa_server(input, output, session)
}

# Crea l'applicazione Shiny
shinyApp(ui = dino_ui, server = dino_server)
