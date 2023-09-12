library(shiny)


function(input, output, session) {

    #jednorazowe rzeczy na początek
    base_wine_data <- read.csv("../winequality-red.csv")
    
    updateSelectInput(session, "select_var", choices=colnames(base_wine_data))
    
    #zmienne reaktywne
    processed_wine_data <- reactive({
      dt <- base_wine_data
      if(input$box_outliers)
      {
        dt[-1,]
      }
      else
      {
        dt
      }
    })
    
    data1 <- reactive({
      input$select_var
    })
    
    #output serwera do UI
    output$current_wine_data <- renderTable(processed_wine_data()[[data1()]])
    
    output$summary <-renderTable(summary(processed_wine_data()))
    
    output$Histogram <- renderPlot({
      hist(processed_wine_data()[[data1()]], col= 'blue', border = 'white')
    })

}
