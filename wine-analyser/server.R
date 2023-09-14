library(shiny)
library(ggplot2)

source("helpers.R")


function(input, output, session) {

    #jednorazowe rzeczy na początek
    base_wine_data <- read.csv("../winequality-red.csv")
    
    updateSelectInput(session, "select_var", choices=colnames(base_wine_data))
    
    updateCheckboxGroupInput(session, "cb_reg_vars", choices = colnames(base_wine_data))
    
    #zmienne reaktywne
    processed_wine_data <- reactive({
      dt <- base_wine_data
      if(input$box_outliers) {dt<- remove_outliers(dt, selected_variable())}
      else {dt}
    })
    
    selected_variable <- reactive({
      input$select_var
    })
    
    plot_Type <- reactive({
      input$sI_plotType
    })
    
    
    #output serwera do UI
    output$current_wine_data <- renderTable(processed_wine_data()[[selected_variable()]])
    
    output$summary <-renderTable(summary(processed_wine_data()))
    
    #TODO kosmetyka wykresów
    output$selected_plot <- renderPlot({
      switch(plot_Type(),
             "Histogram" = hist(as.numeric(processed_wine_data()[[selected_variable()]]), 
                                main = " ", col = 'blue', border = 'white', breaks = "FD"),
             "Scatter" = plot(processed_wine_data()[[selected_variable()]], processed_wine_data()$quality),
             "Boxplot" = boxplot(processed_wine_data()[[selected_variable()]])
             )
    })
    
    output$test <- renderText({
      length(input$cb_reg_vars)
    })
}
