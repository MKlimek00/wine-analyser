library(shiny)
library(shinythemes)


# Define UI for application that draws a histogram
fluidPage(
  theme = shinytheme("lumen"),

    # Application title
    titlePanel("Wine Analyser, by: Maciej Klimek & Mateusz Stryjek"),
    tabsetPanel(
                type = "tab",
                tabPanel(
                    "Preview",
                    fluidRow(column(6, selectInput("select_var", "Choose variable", c()),
                                    checkboxInput("box_outliers", "Remove Outliers"),
                                    checkboxInput("box_norm", "Normalize variable"),
                                    checkboxInput("box_log", "Change to log")),
                             column(6, selectInput("sI_plotType",
                                                   "Select Plot Type",
                                                   choices = list("Histogram", "Scatter", "Boxplot"))),
                    fluidRow(plotOutput("selected_plot")))
                      
                ),
                tabPanel(
                    "Regression",
                    fluidRow(
                      column(3,checkboxGroupInput("cb_reg_vars", "Choose variables",
                                                choiceNames = list(), choiceValues = list()
                    )),
                    column(3,checkboxGroupInput("cb_outl", "Remove outliers",
                                                choiceNames = list(), choiceValues = list()
                    )),
                    column(3,checkboxGroupInput("cb_norm", "Normalize Variable",
                                                choiceNames = list(), choiceValues = list()
                    )),
                    column(3, checkboxGroupInput("cb_log", "Logarithmize variable",
                                                 choiceNames = list(), choiceValues = list()
                    ))),
                    textOutput("test"),
                    verbatimTextOutput("regression_result")
                )
            )
)
