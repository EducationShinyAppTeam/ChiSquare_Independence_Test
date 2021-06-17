library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyjs)
library(plotly)

#import dataset: Cars2015.csv
cars <- read.csv('Cars2015.csv')
cars <- cars[, c('Drive', 'Type', 'Size')]

#import dataset: 
hi <- read.csv('HeroesInformation.csv')

#import dataset: CocaineTreatment.csv
ct = read.csv('CocaineTreatment.csv')
class(ct) #data.frame
treatment <- c('Desipramine', 'Lithium', 'Placebo')
no <- c(14, 6, 4)
yes <- c(10, 18, 20)
treatmentData <- data.frame(treatment, no, yes)

#import dataset: CompassionateRats.csv
cr = read.csv('CompassionateRats.csv')
sex <- c('F', 'M')
no1 <- c(0, 7)
yes1 <- c(6, 17)
crData <- data.frame(sex, no1, yes1)

#import dataset: SandwichAnts.csv
sa <- read.csv('SandwichAnts.csv')
bread <- c('Multigrain', 'Rye', 'White', 'Wholemeal')
hpickles <- c(2, 2, 2, 2)
pbutter <- c(2, 2, 2, 2)
vegemite <- c(2, 2, 2, 2)
saData <- data.frame(bread, hpickles, pbutter, vegemite)

shinyServer(function(input, output, session) {
  #Go to overview Button
  observeEvent(input$goover, {
    updateTabItems(session, "pages", "exp1")
  })
  #Go to game page Button
  observeEvent(input$bsButton2, {
    updateTabItems(session, "pages", "instr2")
  })
  

  
###### Download 5 datasets ######
  output$CarsDownload <- downloadHandler(
    filename = function() {
      paste('Cars2015-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(cars, con)
    }
  )
  
  output$HIDownload <- downloadHandler(
    filename = function() {
      paste('HeroesInformation-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(hi, con)
    }
  )
  
  output$CRDownload <- downloadHandler(
    filename = function() {
      paste('CompassionateRats-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(cr, con)
    }
  )
  
  output$SADownload <- downloadHandler(
    filename = function() {
      paste('SandwichAnts-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(sa, con)
    }
  )
  
  output$CTDownload <- downloadHandler(
    filename = function() {
      paste('CocaineTreatment-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(ct, con)
    }
  )
  
############ Display ############
############ ############ ############ ############
  
  #test your own dataset
  # output$fileinput = renderTable({
  #   inFile = input$file
  #   req(inFile)
  #   f <- read.table(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)
  #   vars = names(f)
  #   updateSelectInput(session, "columns", "Select Your X-Axis", choices = vars)
  #   updateSelectInput(session, "columns2", "Select Your Y-Axis", choices = vars)
  #   head(f, 5)
  # })

  inputDataset <- reactive({
    
    validate(
      need(input$file, 'Please Select Your Datafile')
    )
    
    inFile = input$file
    req(inFile)
    inputDataset <- read.table(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)
    return(inputDataset)
    
  })
  
  output$fileOutput <- renderTable ({
    vars = names(inputDataset())
    updateSelectInput(session, "columns", "Select Your X-Axis", choices = vars)
    updateSelectInput(session, "columns2", "Select Your Y-Axis", choices = vars)
    head(inputDataset(), 5)
  })
  
  output$fileChiSummary <- renderPrint({
    chisq.test(table(inputDataset()[ , c(input$columns, input$columns2)]))
  })
  
#question bank for exploratory data analysis
qbank <- read.csv('Workbook1.csv')
qbank$Question <- as.character(qbank$Question)
  
  #Challenge Question No.1 for HeroesInformation
  output$HIquestion <- renderText({
    paste('Is the variable', input$XHeroesInfo, 'independent from the variable', input$YHeroesInfo, '?')
  })
  
val <- reactiveValues()

  # #Challenge Question No.2 for HeroesInformation
  # output$HIquestion2 <- renderText({
  #   val$num <- sample(4:13, 1, replace = FALSE)
  #   HIq2 <- qbank$Question[val$num]
  #   HIq2
  # })

  #2D histogram for HeroesInformation
  output$hiplotly1 <- renderPlotly ({
    x <- list(title = input$XHeroesInfo)
    y <- list(title = input$YHeroesInfo)
    hip <- plot_ly(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo], type = "histogram2d") %>%
      layout(xaxis = x, yaxis = y)
    hip
  })
  
  #X^2 summary for HeroesInformation
  output$hisur <- renderPrint({
    hiSummary <- chisq.test(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo], simulate.p.value = TRUE)
    hiSummary
  })
  #chisq.test(table(hi[ , c(input$XHeroesInfo, input$YHeroesInfo)]))
  #Warning in chisq.test(table(hi[, c(input$XHeroesInfo, input$YHeroesInfo)])) :
  #Chi-squared approximation may be incorrect
  #chisq.test(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo],simulate.p.value = TRUE)
  
  #Challenge Question No.1 for Cars2015
  output$Carsquestion <- renderText({
    paste('Is the variable', input$XCars2015, 'independent from the variable', input$YCars2015, '?')
  })
  
  #Challenge Question No.2 for Cars2015
  output$Carsquestion2 <- renderText({
    val$num2 <- sample(1:3, 1, replace = FALSE)
    carsQuestion2 <- qbank$Question[val$num2]
    carsQuestion2
  })
  
  #2D histogram for Cars2015
  output$carsplotly <- renderPlotly({
    x <- list(title = input$XCars2015)
    y <- list(title = input$YCars2015)
    carsp <- plot_ly(x = cars[ , input$XCars2015], y = cars[ , input$YCars2015], marker = list(size = seq(0, 50, 5), color = seq(0, 50, 5),
                                                                                               colorbar = list(title = 'Count'), colorscale = 'Reds', 
                                                                                               reversescale = TRUE),type = "histogram2d") %>%
      layout(xaxis = x, yaxis = y)
    carsp
  })
  
  #X^2 summary for Cars2015
  output$carssur <- renderPrint({
    carsSummary <- chisq.test(x = cars[ , input$XCars2015], y = cars[ , input$YCars2015],simulate.p.value = TRUE)
    carsSummary
  })
  #chisq.test(table(cars[ , c(input$XCars2015, input$YCars2015)]))
  #chisq.test(x = hi[ , input$XHeroesInfo], y = hi[ , input$YHeroesInfo],simulate.p.value = TRUE)
  
  #2D histogram for SandwichAnts
  output$saplotly1 <- renderPlotly({
    x <- list(title = 'Filling')
    y <- list(title = 'Bread')
    sap1 <- plot_ly(x = sa$Filling, y = sa$Bread,type = "histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Sandwich & Ants Example')
    sap1
  })
  
  #stacked bar chart for SandwichAnts
  output$saplotly2 <- renderPlotly({
    x <- list(title = 'Bread')
    sap2 <- plot_ly(saData, x = ~bread, y = ~hpickles, type = 'bar', name = 'Ham & Pickles',type = "histogram2d") %>%
      add_trace(y = ~pbutter, name = 'Peanut Butter') %>%
      add_trace(y = ~vegemite, name = 'vegemite') %>%
      layout(xaxis = x, yaxis = list(title = 'Count'), barmode = 'stacked')
    sap2
  })
  
  #X^2 summary for SandwichAnts
  output$sasur <- renderPrint({
    sas <- chisq.test(table(sa[ , c(2, 3)]))
    sas
  })
  
  #2D histogram for CompassionateRats
  output$crplotly1 <- renderPlotly({
    x <- list(title = 'Sex')
    y <- list(title = 'Empathy')
    cr1 <- plot_ly(x = cr$Sex, y = cr$Empathy, type = "histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Compassionate Rats Example')
    cr1
  })
  
  #stacked bar chart for CompassionateRats
  output$crplotly2 <- renderPlotly({
    x <- list(title = 'Sex')
    cr2 <- plot_ly(crData, x = ~sex, y = ~no1, type = 'bar', name = 'No') %>%
      add_trace(y = ~yes1, name = 'yes') %>%
      layout(xaxis = x, yaxis = list(title = 'Count'), barmode = 'stacked')
    cr2
  })
  
  #X^2 summary for CompassionateRats
  output$crsur <- renderPrint({
    crsur1 <- chisq.test(table(as.matrix(cr)))
    crsur1
  })
  
  #2D histogram for CocaineTreatment
  output$plotly1 <- renderPlotly ({
    x <- list(title = 'Drug Treatment')
    y <- list(title = 'Relapse Status')
    ctp1 <- plot_ly(x = ct$Drug, y = ct$Relapse,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y)
    ctp1
  })
  
  #stacked bar chart for CocaineTreatment
  output$stack1 <- renderPlotly({
    x <- list(title = 'Drug Treatment')
    p2 <- plot_ly(treatmentData, x = ~treatment, y = ~no, type = 'bar', name = 'No') %>%
      add_trace(y = ~yes, name = 'Yes') %>%
      layout(xaxis = x, axis = list(title = 'Treatment'), yaxis = list(title = 'Count'), barmode = 'stacked')
    p2
  })
  #X^2 summary for CocaineTreatment
  output$chiSqrSummary1 <- renderPrint({
    chisqSummary1 <- chisq.test(ct$Drug, ct$Relapse)
    chisqSummary1
  })
  
############ Upload Your Own Dataset ############
############ ############ ############ ############
  # #Argument names:
  # ArgNames <- reactive({
  #   Names <- names(formals(input$readFunction)[-1])
  #   Names <- Names[Names != "..."]
  #   return(Names)
  # })
  # 
  # #Argument selector:
  # output$ArgSelect <- renderUI({
  #   if (length(ArgNames())==0) return(NULL)
  #   else {
  #     selectInput("arg", "Argument:", ArgNames())
  #   }
  # })
  # 
  # #Arg text field:
  # output$ArgText <- renderUI({
  #   fun__arg <- paste0(input$readFunction, "__", input$arg)
  #   if (is.null(input$arg)) return(NULL)
  #   
  #   Defaults <- formals(input$readFunction)
  #   
  #   if (is.null(input[[fun__arg]])) {
  #     textInput(fun__arg, label = "Enter value:", value = deparse(Defaults[[input$arg]])) 
  #   } 
  #   else {
  #     textInput(fun__arg, label = "Enter value:", value = input[[fun__arg]]) 
  #   }
  # })
  # 
  # #Data import:
  # Dataset <- reactive({
  #   
  #   validate(
  #     need(input$file, 'Please Select Your Datafile')
  #   )
  #   
  #   if (is.null(input$file)) {
  #     return(data.frame())
  #   }
  #   
  #   args <- grep(paste0("^", input$readFunction, "__"), names(input), value = TRUE)
  #   
  #   argList <- list()
  #   for (i in seq_along(args)) {
  #     argList[[i]] <- eval(parse(text=input[[args[i]]]))
  #   }
  #   names(argList) <- gsub(paste0("^", input$readFunction, "__"), "", args)
  #   
  #   argList <- argList[names(argList) %in% ArgNames()]
  #   
  #   Dataset <- as.data.frame(do.call(input$readFunction, c(list(input$file$datapath), argList)))
  #   return(Dataset)
  # })
  # 
  # #X^2 Summary from the file input
  # output$summaryFile <- renderPrint ({
  #   summaryInput <- chisq.test(table(Dataset()))
  #   summaryInput
  # })
  # 
  # #Show table:
  # output$table <- renderDataTable ({
  #   datafile <- Dataset()
  #   data.table::data.table(datafile)
  # })

############ Update Events ############
############ ############ ############ ############
  
  observeEvent(input$next1, {
    updateSelectInput(session, inputId = 'cq1', label = 'The Second Graph',
                      choices = c('',
                                  'A. In this dataset, midsized is the most common size for 7Pass cars',
                                  'B. In this dataset, midsized is the most common size for SUV cars',
                                  'C. In this dataset, small is the most common size for Sporty cars',
                                  'D. None of the above')
                      )
  })
  
  observeEvent(input$next2, {
    updateSelectInput(session, inputId = 'cq1', label = 'The Third Graph',
                      choices = c('',
                                  'A. The use of desipramine is largely associated with the relapse status',
                                  'B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo',
                                  'C. The use of placebo is equally associated with the relapse status and non-relapse status',
                                  'D. The use of lithium is more associated with the non-relapse status than the relapse status')
    )
  })
  
  observeEvent(input$bsButton1, {
    updateTabItems(session, 'pages', 'prerequisite')
  })
  
  observeEvent(input$bsButton2, {
    updateTabItems(session, 'pages', 'exp3')
  })
  
  observeEvent(input$bsButton4, {
    updateTabItems(session, 'games2', 'cha1')
  })
  
  observeEvent(input$bsButton6, {
    updateTabItems(session, 'games1', 'cha2')
  })
  
  observeEvent(input$bsButton7, {
    updateTabItems(session, 'pages', 'references')
  })
  
  observeEvent(input$bsButton8, {
    updateTabItems(session, 'pages', 'instr1')
  })
  
  observeEvent(input$next1, {
    updateTabItems(session, 'pages', 'cha2_2')
    updateSelectInput(session, inputId = 'graphId', selected = 'The Second Graph')
  })
  
  observeEvent(input$next2, {
    updateTabItems(session, 'pages', 'cha2_3')
    updateSelectInput(session, inputId = 'graphId', selected = 'The Third Graph')
  })
  
  observeEvent(input$next3, {
    updateTabItems(session, 'pages', 'cha2_4')
    updateSelectInput(session, inputId = 'graphId', selected = 'The Fourth Graph')
  })

  observeEvent(input$next4, {
    updateTabItems(session, 'pages', 'instr1')
  })

############ What's Going On in This Graph? ############
############ ############ ############ ############
  #cha2 plot1
  output$cha2plot1 <- renderPlotly({
    x <- list(title = 'Filling')
    y <- list(title = 'Bread')
    cha2p1 <- plot_ly(x = sa$Filling, y = sa$Bread,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Sandwich & Ants Example')
    cha2p1
  })

  observeEvent(input$cq1check1,{
    if(input$cq1 == 'D. A, B, and C') {
      output$cq1ans1 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed1 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans1 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed1 <- renderUI({
        tags$h4(strong('Please play with the interactive plots and think about what the axes represent!'))
      })
    }
  })

  
  #cha2 plot2
  output$cha2plot2 <- renderPlotly({
    x <- list(title = 'Type')
    y <- list(title = 'Size')
    cha2p2 <- plot_ly(x = cars$Type, y = cars$Size,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Cars Example')
    cha2p2
  })
  #cha2 answer2 + feed2
  observeEvent(input$cq1check2,{
    if(input$cq2 == 'C. In this dataset, small is the most common size for Sporty cars') {
      output$cq1ans2 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed2 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans2 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed2 <- renderUI({
        tags$h4(strong('Start with each car types and then go through the sizes corresponding to each type!'))
      })
    }
  })
  
  #cha2 plot3
  output$cha2plot3 <- renderPlotly({
    x <- list(title = 'Drug')
    y <- list(title = 'Relapse Status')
    cha2p3 <- plot_ly(x = ct$Drug, y = ct$Relapse,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Drug Treatment and Relapse Status')
    cha2p3
  })
  
  #cha2 answer3 + feed3
  observeEvent(input$cq1check3,{
    if(input$cq3 == 'B. People who use desipramine as drug treatment are less likely to relapse compared to those who use lithium and placebo') {
      output$cq1ans3 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed3 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans3 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed3 <- renderUI({
        tags$h4(strong('Compare the relapse and non-relapse status within each drug treatment! Go both vertically and horizontally!'))
      })
    }
  })
  
  #cha2 plot4
  output$cha2plot4 <- renderPlotly({
    x <- list(title = 'Sex')
    y <- list(title = 'Empathy')
    cha2p4 <- plot_ly(x = cr$Sex, y = cr$Empathy,type="histogram2d") %>%
      layout(xaxis = x, yaxis = y, title = '2D Histogram for the Compassionate Rats Example')
    cha2p4
  })
  
  #cha2 answer4 + feed4
  observeEvent(input$cq1check4,{
    if(input$cq4 == 'C. Both A and B') {
      output$cq1ans4 <- boastUtils::renderIcon(
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$cq1feed4 <- renderUI({
        tags$h4(strong('Congratulations!'))
      })
    }
    else {
      output$cq1ans4 <- boastUtils::renderIcon(
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$cq1feed4 <- renderUI({
        tags$h4(strong('Think about what could be done to make the graph more informative!'))
      })
    }
  })
  
  
############ Question Bank ############
############ ############ ############ ############
question <- read.delim('Workbook2.csv')
question$Question <- as.character(question$Question)
question$A <- as.character(question$A)
question$B <- as.character(question$B)
question$Correct <- as.character(question$Correct)
question$Feedback <- as.character(question$Feedback)
sapply(question, class)

values <- reactiveValues()

  output$questionCha <- renderUI ({
    values$num <- sample(1:8, 1, replace = FALSE)
    challengeQuestion <- question$Question[values$num]
    h4(challengeQuestion)
  })
  
  output$choiceCha <- renderUI({
    selectInput(inputId = 'challengeChoice', label = '', 
                choices = c("Please select your response",question$A[values$num], question$B[values$num]))
  })

  observeEvent(input$nextX, {
    output$questionCha <- renderUI ({
      values$num = sample(1:8, 1, replace = FALSE)
      questionUpdate <- question$Question[values$num]
      h4(questionUpdate)
    })
  })
  
  #feedback and mark
  observeEvent(input$submitX, {
    if (input$challengeChoice == question$Correct[values$num]) {
      output$challengeFeedback <- boastUtils::renderIcon (
        icon = "correct", 
        width = 36,
        html = FALSE
      )
      output$textFeedback <- renderUI ({
        div(h4(style = 'text-align: left', paste('Congratulations!')))
      })
    }
    else {
      output$challengeFeedback <- boastUtils::renderIcon (
        icon = "incorrect", 
        width = 36,
        html = FALSE
      )
      output$textFeedback <- renderUI ({
        text <- question$Feedback[values$num]
        div(h4(style = 'text-align: left', text))
      })
    }
  })
  
  observeEvent(input$nextX, {
    shinyjs::hideElement("challengeFeedback")
    shinyjs::hideElement('textFeedback')
  })
  
  observeEvent(input$submitX, {
    shinyjs::showElement("challengeFeedback")
    shinyjs::showElement('textFeedback')
  })
  
})