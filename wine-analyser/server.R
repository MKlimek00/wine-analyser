library(shiny)

source("helpers.R")


function(input, output, session) {
  # jednorazowe rzeczy na początek
  base_wine_data <- read.csv("../winequality-red.csv", sep = ",", fill = FALSE)
  base_wine_data <- base_wine_data[complete.cases(base_wine_data),]
  
  names <- head(colnames(base_wine_data),-1)

  updateSelectInput(session, "select_var", choices = names)

  updateCheckboxGroupInput(session, "cb_reg_vars", choices = names)
  
  updateCheckboxGroupInput(session, "cb_outl", choiceNames = rep(".", times=(ncol(base_wine_data)-1)), choiceValues = names)
  
  updateCheckboxGroupInput(session, "cb_norm", choiceNames = rep(".", times=(ncol(base_wine_data)-1)), choiceValues = names)
  
  updateCheckboxGroupInput(session, "cb_log", choiceNames = rep(".", times=(ncol(base_wine_data)-1)), choiceValues = names)

  # zmienne reaktywne
  processed_wine_data <- reactive({
    datafr <- base_wine_data
    dt <- na.omit(dt)

    if (input$box_outliers == 1) {
      datafr <- remove_outliers(datafr, selected_variable())
    }
    if (input$box_log == 1) {
      datafr <- log_transform(datafr, selected_variable())
    }
    if (input$box_norm == 1) {
      datafr <- scale_standard(datafr, selected_variable())
    }
    datafr
  })

  selected_variable <- reactive({
    input$select_var
  })

  plot_type <- reactive({
    input$sI_plotType
  })

  regression_vars <- reactive({
    input$cb_reg_vars
  })
  
  regression_outliers <- reactive({
    input$cb_outl
  })
  
  regression_norms <- reactive ({
    input$cb_norm
  })
  
  regression_logs <- reactive({
    input$cb_log
  })
  
  regression_wine_data <- reactive({
    dt <- base_wine_data
    for(n in regression_outliers())
    {
      dt <- remove_outliers(dt, n)
    }
    for(n in regression_logs())
    {
      dt <- log_transform(dt, n)
    }
    for(n in regression_norms())
    {
      dt <- scale_standard(dt, n)
    }
    run_regression(dt,regression_vars())
  })
  

  # output serwera do UI
  output$current_wine_data <- renderTable(processed_wine_data()[[selected_variable()]])
  
  output$selected_plot <- renderPlot({
    switch(plot_type(),
      "Histogram" = hist(as.numeric(processed_wine_data()[[selected_variable()]]),
        main = "Histogram",xlab = selected_variable(), ylab = "Counts", 
        col = "blue", border = "white", breaks = "FD"
      ),
      "Scatter" = plot(processed_wine_data()[[selected_variable()]], processed_wine_data()$quality, 
                       main  = "Scatterplot", xlab = selected_variable(),
                       ylab = "quality"),
      "Boxplot" = boxplot(processed_wine_data()[[selected_variable()]], main = "Boxplot", ylab = selected_variable())
    )
  })
  
  output$var_summary <- renderPrint({
    summary(processed_wine_data()[[selected_variable()]])
  })

  output$regression_result <- renderPrint({
    summary(regression_wine_data())
    })
  
  output$regr_plot <- renderPlot({
    par(mfrow = c(2,2))
    plot(regression_wine_data())
    })
  
}

