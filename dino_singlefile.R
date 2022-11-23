###DINO APP
#install.packages("shiny")
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

#setwd("C:\\Users\\UTENTE\\Documents\\R\\dino")
######## REGRESSION ADJUSTMENT Read data #######
#load("C:\\Users\\UTENTE\\Documents\\R\\dino\\JTRAIN2.Rda")
data('jtrain2')
JTRAIN2<-as.data.frame(jtrain2)
vars <- names(JTRAIN2)

### subset 
JTRAIN2_W1 <- JTRAIN2 %>% filter(train==1) 
JTRAIN2_W0 <- JTRAIN2 %>% filter(train==0)

####################################
# User interface                   #
####################################
ui <- fluidPage(theme = shinytheme("sandstone"), #sandstone cosmo journal
                navbarPage(
                  p("DINO - Policy Evaluation App",style="color:white;text-align:justify;bold"),  ### APP NAME
            
            ########## REGRESSION ADJUSTMENT PANEL
            tabPanel("Regression Adjustment",
              tabsetPanel(type = "tabs",
                          tabPanel("Overview",
                                   fluidPage(h3("Regression adjustment"),
                                             br(),
                           p("Regression-adjustment (RA) can be seen as a general estimation procedure under selection on observables.
                            RA is suitable only when the conditional independence assumption (CIA) holds.
                            Both outcomes for treated and untreated units, m1(x) and m0(x),
                            can be estimated either parametrically, semi-parametrically, or nonparametrically: 
                            the choice depends on the assumption made on the form of the potential outcome."), 
                           br(), 
                           p("Note that the Regression-adjustment approach only uses the potential outcome means 
                            to recover ATEs and does not use the propensity-score.
                            It is mostly based on an imputation logic, where imputation can be performed in various ways and 
                            it is performed conditioning over the values of one ore more variables x."), 
                              br(),
                           p("References: https://www.jstor.org/stable/24033341"),
                            br(),
                          p(tags$img(src = "https://debruine.github.io/shinyintro/images/logos/shinyintro.png",
                                  width = "100px",
                                  height = "100px"))
                            )),   #end tabpanel overview
                          tabPanel("Dataset", box(withSpinner(DTOutput("table")), width = 12)),
                          tabPanel("Summary", 
                            fluidRow(
                              column(br(),verbatimTextOutput("summary"),br(),width=4,style="border:1px solid black"),
                              column(br(),verbatimTextOutput("summary1"),br(),width=4,style="border: 1px solid black;border-left: none"),
                              column(br(),verbatimTextOutput("summary0"),br(),width=4,style="border:1px solid black;border-left:none")
                            )),
                          tabPanel("Hist", 
                                   fluidPage(
                                       selectInput(inputId = "variable",
                                                              label = "Variable",
                                                              choices = colnames(JTRAIN2),
                                                              selected = vars[[11]]),
                                       plotOutput("hist"))),
                          tabPanel("Scatterplot",
                                   fluidPage(
                                     box(selectInput('ycol', 'Y Variable', vars, selected = vars[[11]])),
                                     box(selectInput('xcol', 'X Variable', vars))
                                            ),
                                    plotOutput("scatter")),
                          tabPanel("Correlation",
                                   plotOutput(
                                     "Corr"), width = 12),
                          tabPanel("Linear Regression",
                                sidebarLayout(
                                    sidebarPanel(
                                       box(selectInput("SelectY", 
                                                   label = "Y Variable", 
                                                   choices = names(JTRAIN2),
                                                   selected = vars[[11]]),
                                       solidHeader = TRUE,
                                       width = "6",
                                       status = "primary"
                                            ),
                                     box(checkboxGroupInput("SelectX",
                                                        label = "X Variable",
                                              choices = names(JTRAIN2),
                                              selected = vars[[1]]))
                                            ),
                                   mainPanel(
                                       box(withSpinner(verbatimTextOutput("Model")),
                                       width = 12,
                                       title = "Linear Regression Summary")
                                         ))  #end sidebarlayout
                          ),  #END tabpanel regr
                          
                          tabPanel("R Adjustment",
                                   sidebarLayout(
                                     sidebarPanel(
                                       box(selectInput("SelectY_adj", 
                                                     label = "Y Variable", 
                                                     choices = names(JTRAIN2),
                                                     selected = vars[[11]]),
                                                     solidHeader = TRUE,
                                                     width = "6",
                                                     status = "primary"),
                                       box(checkboxGroupInput("SelectX_adj",
                                                  label = "X Variable",
                                                  choices = names(JTRAIN2),
                                                  selected = names(JTRAIN2[c(9,10,2,18,7)]))) 
                                                  #re74+re75+age+agesq+nodegree
                                                  ),
                                     mainPanel(
                                       fluidPage(h3("Estimation procedure"),
                                                 br(),
                                    p("- JTRAIN2 dataset is filtered twice, for treatment variable train=1 and train=0."),
                                    p("- The regression model is estimated on both subsets, and values are predicted for the entire JTRAIN2 dataset."),
                                    p("- Average treatment effects are calculated as follows:"),
                                          br(),
                                     p("ATE   = mean (y1_x - y0_x)"), 
                                     p("ATET  = mean (y1_x)"),
                                     p("ATENT = mean (y0_x)"), 
                                                 br()),
                                       box(withSpinner(verbatimTextOutput("R_adj")),
                                         width = 12,
                                         title = "Regression Adjstment Summary")
                                          ))  #END tabpanel adj
                      ))),  ### END TABPANEL Regression Adjustment
   
            ########### SYNTHETIC CONTROL METHOD PANEL
            tabPanel("Synthetic Control", "This panel is intentionally left blank"),
            
            ########### MATCHING PANEL
            tabPanel("Matching","This panel is intentionally left blank"),
            
            ########### DID PANEL
            tabPanel("DID", "This panel is intentionally left blank"),
            
            ########### RDD PANEL
            tabPanel("RDD", "This panel is intentionally left blank"),
            
            ########### ITSA PANEL
            tabPanel("ITSA", "This panel is intentionally left blank"),
            
            ########### HOME PANEL
            tabPanel("About",
                     fluidPage(h1("An R application for Policy Evaluation"),
                               br(),
                               p(strong(em("DINO is not an acronym. It was just my father's name"))),
                                 br(),
                               p("I clearly remember how he used to get crazy while hearing a politician say: 'there is not enough money', 
                                      especially when referring to welfare."),
                               p("He truly believed in the possibility of a better policymaking."),
                                 br(),
                               p("What I've learned about it, is that better policies can be designed through the evidence of numbers. 
                                      If the elements of rationality get predominant 
                                      in the decision-making process, it is possible to generate well-being in society even with scarce resources."),
                                 br(),
                               p("This App wants to be an instrument to help as many people as possible to approach Policy Evaluation methods and 
                                 do their part in the common goal of improving the policymaking process and... consequently our society.")
                               ))
                ) # END navbarPage
 )# END fluidPage


####################################
# server function                  #
####################################
server <- function(input, output, session) {
  
######REGRESSION ADJUSTMENT PANEL
  ## table
  # output$table <- renderTable({
  #   JTRAIN2
  #   })
  InputDataset <- reactive({
    JTRAIN2
  })
  output$table <- renderDT(InputDataset())
  
  ## summary
  output$summary <- renderPrint({
    stargazer(JTRAIN2,type = "text", digits=1,title="Summary descriptive statistics", out="table1.txt")
  })
  
  output$summary1 <- renderPrint({
    stargazer(JTRAIN2_W1,type = "text", digits=1,title="Summary if treatment variable train=1", out="table2.txt")
  })
  output$summary0 <- renderPrint({
    stargazer(JTRAIN2_W0,type = "text", digits=1,title="Summary if treatment variable train=0", out="table3.txt")
  })
  
  ##hist
  output$hist <- renderPlot({
    req(input$variable)
    g <- ggplot(JTRAIN2, aes(x = !!as.symbol(input$variable)))
    if (input$variable %in% c("re78", "re74", "re75", "age", "educ", "qsec")) {
      # numeric
      g <- g + geom_histogram(color="darkblue", fill="blue")
    } else {
      # categorical
      g <- g + geom_bar(color="darkblue", fill="blue")
    }
      g
  })
  
  ##scatterplot
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    JTRAIN2[, c(input$xcol, input$ycol)]
  })
  
  output$scatter <- renderPlot({
    plot(selectedData(),
         pch = 20, cex = 3,
         col="blue")
  })
  
  ##correlation plot
  cormat <- reactive({
    round(cor(jtrain2), digits = 1)
  })
  output$Corr <-
    renderPlot(corrplot(
      cormat(),
      type = "lower",
      order = "hclust",
      method = "circle"
    ))
  
  ##linear regression
  f <- reactive({
    as.formula(paste(input$SelectY, "~",paste(c(input$SelectX),collapse="+")))
  })
  
  Linear_Model <- reactive({
    lm(f(), data = JTRAIN2)
  })
  
  output$Model <- renderPrint(summary(Linear_Model()))
  
  ##regression adjstment
  # lm(re78~re74+re75+age+agesq+nodegree)
  
  f_adj <- reactive({
    as.formula(paste(input$SelectY_adj, "~",paste(c(input$SelectX_adj),collapse="+")))
  })
  
  Linear_Model1 <- reactive({
    lm(f_adj(), data = JTRAIN2_W1)
  })
  
  Linear_Model0 <- reactive({
    lm(f_adj(), data = JTRAIN2_W0)
  })
  
  y1_x <- reactive({
    as.vector(predict(Linear_Model1(), type="response",JTRAIN2))
  })
  
  y0_x <- reactive({
    as.vector(predict(Linear_Model0(), type="response",JTRAIN2))
  })

  output$R_adj<-renderPrint({
    print(paste("Model:",c(f_adj()),collapse=" "))
    print(paste("AVERAGE TREATEMENT EFFECT =",mean(y1_x()-y0_x()),sep=" "))         #1.519323
    print(paste("AVERAGE TREATEMENT EFFECT ON TREATED =",mean(y1_x()),sep=" "))     #6.104073
    print(paste("AVERAGE TREATEMENT EFFECT ON NON TREATED =",mean(y0_x()),sep=" ")) #4.58475
          })
#####NEXT PANEL
 
  
} # END server

####################################
# Create Shiny object              #
####################################
shinyApp(ui = ui, server = server)