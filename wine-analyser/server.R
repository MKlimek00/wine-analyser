#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

    output$wine_data <- renderTable({

        file_path <- "../winequality-red.csv"
        wine_data <- read.csv(file_path)
    })

}
