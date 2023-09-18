library(shiny)
library(ggplot2)
library(stringr)

source("helpers.R")


function(input, output, session) {
  # jednorazowe rzeczy na początek
  base_wine_data <- read.csv("../winequality-red.csv", sep = ",", fill = FALSE)

  updateSelectInput(session, "select_var", choices = colnames(base_wine_data))

  updateCheckboxGroupInput(session, "cb_reg_vars", choices = colnames(base_wine_data))

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

  regression_checkboxes <- reactive({
    input$cb_reg_vars
  })

  # output serwera do UI
  output$current_wine_data <- renderTable(processed_wine_data()[[selected_variable()]])

  output$summary <- renderTable(summary(processed_wine_data()))

  # TODO kosmetyka wykresów
  output$selected_plot <- renderPlot({
    switch(plot_type(),
      "Histogram" = hist(as.numeric(processed_wine_data()[[selected_variable()]]),
        main = " ", col = "blue", border = "white", breaks = "FD"
      ),
      "Scatter" = plot(processed_wine_data()[[selected_variable()]], processed_wine_data()$quality),
      "Boxplot" = boxplot(processed_wine_data()[[selected_variable()]])
    )
  })

  output$regression_result <- renderPrint(summary(
      run_regression(base_wine_data, regression_checkboxes())
    ))
}
