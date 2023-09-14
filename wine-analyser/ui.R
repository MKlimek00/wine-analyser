library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Wine Analyser"),

    # Interactive parts
    sidebarLayout(
        # get inputs
        sidebarPanel(
            selectInput("select_var", "Choose variable", c()),
            br(),
            checkboxInput("box_outliers", "Remove Outliers"),
            checkboxInput("box_norm", "Normalize variable"),
            checkboxInput("box_log", "Change to log"),
            checkboxInput("box_regression", "Calculate regression"),
        ),

        # Show outputs
        mainPanel(
          tabsetPanel(type = "tab",
                      tabPanel("Plots", 
                               selectInput("sI_plotType",
                                           "Select Plot Type",
                                           choices = list("Histogram", "Scatter")
                               ),
                               plotOutput("selected_plot")),
                      tabPanel("Data",tableOutput("current_wine_data")),
                      tabPanel("Regression coefficients"),
                      tabPanel("Summary", tableOutput("summary"))
                      
                      )
                  )
        )
)
