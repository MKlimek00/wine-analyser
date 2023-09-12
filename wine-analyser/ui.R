#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Wine Analyser"),

    # Interactive parts
    sidebarLayout(
        # get inputs
        sidebarPanel(
            textInput("text", "wpisz jakiś tekst"),
        ),

        # Show outputs
        mainPanel(
            h3("Wine Dataset"),
            tableOutput("wine_data")
        )
    )
)
