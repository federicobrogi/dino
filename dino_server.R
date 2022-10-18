source("dataset.r", local = TRUE)

####################################
#DINO server function              #
####################################
dino_server <- function(input, output, session) {
  
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