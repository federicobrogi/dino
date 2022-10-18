source("dataset.r", local = TRUE)

####################################
# DINO User interface              #
####################################
dino_ui <- shinyUI({
  fluidPage(theme = shinytheme("sandstone"), #sandstone cosmo journal
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
                                                              p("JTRAIN2 dataset is filtered twice, for treatment variable train=1 and train=0."),
                                                              p("The regression model is estimated on both subsets, and values are predicted for the entire JTRAIN2 dataset."),
                                                              p("Average treatment effects are calculated as follows:"),
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
                  tabPanel("Home",
                           fluidPage(h1("An R application for Policy Evaluation"),
                                     br(),
                                     p(strong(em("Let's try to spread the culture of evaluation and help evidence based policy making move forward!"))),
                                     br(),
                                     p("Evidence-based policymaking has two goals: to use what we already know from program evaluation to
                                        make policy decisions and to build more knowledge to better inform future decisions. This approach
                                        prioritizes rigorous research findings, data, analytics, and evaluation of new innovations above
                                        anecdotes, ideology, marketing, and inertia around the status quo."), 
                                     br(),
                                     p("DINO is not an acronym. It was just my father's name.
                                      Among other things, he gave me the duty to do something so that everyone can live dignified lives.
                                      Good policies can help people live more dignified lives. Better and better evidence-based policies can help society thrive.
                                      "),
                                     p("This App wants to be an instrument to help as many people as possible to approach Policy Evaluation methods and do their part in the common goal of improving 
                                       the policymaking process and consequently our society.")
                                     
                           ))
                ) # END navbarPage
)# END fluidPage
})