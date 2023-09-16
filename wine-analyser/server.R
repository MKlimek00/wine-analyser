library(shiny)
library(ggplot2)

source("helpers.R")


function(input, output, session) {

    #jednorazowe rzeczy na początek
    base_wine_data <- read.csv("../winequality-red.csv", sep=",", fill = FALSE)

    updateSelectInput(session, "select_var", choices=colnames(base_wine_data))

    #zmienne reaktywne
    processed_wine_data <- reactive({
      datafr <- base_wine_data

      if(input$box_outliers == 1)
      {
        datafr <- remove_outliers(datafr, selected_variable())
      }
      if(input$box_log == 1)
      {
        datafr <- log_transform(datafr, selected_variable())
      }
      if(input$box_norm == 1)
      {
        datafr <- scale_standard(datafr, selected_variable())
      }
      datafr
    })

    selected_variable <- reactive({
      input$select_var
    })

    plot_Type <- reactive({
      input$sI_plotType
    })


    #output serwera do UI
    output$current_wine_data <- renderTable(processed_wine_data()[[selected_variable()]])

    output$summary <- renderTable(summary(processed_wine_data()))

    output$selected_plot <- renderPlot({
      if(plot_Type() == "Histogram")
      {
        hist(as.numeric(processed_wine_data()[[selected_variable()]], na.rm = TRUE), main = "title", col = 'blue', border = 'white', breaks = "FD")
      }
      else
      {
        plot(processed_wine_data()[[selected_variable()]], processed_wine_data()$quality)
      }
    })

    #TODO generowanie tytułu wykresu
    output$Histogram <- renderPlot({

    })

    output$regression_result <- renderPrint((summary(run_regression(base_wine_data, FALSE))))

}
