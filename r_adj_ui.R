r_adj_ui <- function() {
tabPanel("Regression Adjustment",
         tabsetPanel(type = "tabs",
                     tabPanel("Overview",
                              fluidPage(br(),
                                        p(strong(em("Method"))), 
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
                                        p(strong(em("Dataset"))),
                                        p("Professor Lalonde obtained the data from the National SupportedWork Demonstration job-training
                              program conducted by the Manpower Demonstration Research Corporation in the mid 1970s. 
                              Training status was randomly assigned, so this is essentially experimental data.
                             It is possible to carry out an evaluation exercise of the effects of a 
                             training course on the real earnings of a group of people recorded in '74, '76 and '78."), 
                                        p("Dataframe with 445 observations on 19 variables."), 
                                        p("re78 = real earnings, 1978, $1000s"), 
                                        p("unem78 = 1 if unemployed all of 1978"), 
                                        p("age = age in 1977"), 
                                        p("train = 1 if assigned to job training in '77"), 
                                        p("mostrn = months in training"), 
                                        br(),
                                        p("Datasets complete info: https://cran.r-project.org/web/packages/wooldridge/wooldridge.pdf")
                              )),   #end tabpanel overview
                     tabPanel("Dataset", box(withSpinner(DTOutput("table")), width = 12)),
                     tabPanel("Summary", 
                              fluidRow(
                                column(br(),verbatimTextOutput("summary"),br(),width=4,style="border:1px solid black"),
                                column(br(),verbatimTextOutput("summary1"),br(),width=4,style="border: 1px solid black;border-left: none"),
                                column(br(),verbatimTextOutput("summary0"),br(),width=4,style="border:1px solid black;border-left:none")
                              )),
                     tabPanel("Plot", 
                              fluidPage(
                                selectInput(inputId = "variable",
                                            label = "Variable",
                                            choices = colnames(JTRAIN2),
                                            selected = names(JTRAIN2)[11]),
                                plotOutput("hist"))),
                     tabPanel("Scatterplot",
                              fluidPage(
                                box(selectInput('ycol', 'Y Variable', names(JTRAIN2), selected = names(JTRAIN2)[11])),
                                box(selectInput('xcol', 'X Variable', names(JTRAIN2), selected = names(JTRAIN2)[2]))
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
                                                  selected = names(JTRAIN2)[11]),
                                      solidHeader = TRUE,
                                      width = "6",
                                      status = "primary"
                                  ),
                                  box(
                                  selectInput("SelectTrain",
                                              label = "Dataset Subset", 
                                              choices = c("Entire dataset" = "all", 
                                                          "train == 1" = 1, 
                                                          "train == 0" = 0),
                                              selected = "all"),
                                  solidHeader = TRUE,
                                  width = 6,
                                  status = "primary"
                                ),
                                box(checkboxGroupInput("SelectX",
                                                       label = "X Variable",
                                                       choices = names(JTRAIN2),
                                                       selected = names(JTRAIN2)[2]),
                                    solidHeader = TRUE,
                                    width = "6",
                                    status = "primary"
                                )
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
                                                  selected = names(JTRAIN2)[11]),
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
                                      title = "Regression Adjstment Summary"),
                                  downloadButton("downloadAdjustment", "Download Results", class = "transparent-button")
                                ))  #END tabpanel adj
                     )))  ### END TABPANEL Regression Adjustment
}