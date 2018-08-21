
library(shiny)
library(car)
library(rgl)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$head(tags$style(
    HTML('
         #sidebar {
         background-color: #ffffff;
         }
         
         body, label, input, button, select {
         font-family: "Arial";
         }')
 )),
  # Application title
  titlePanel("Predict trees' volume of timber"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      id="sidebar",
      "In the current project the dataset 'trees' is used. Two linear models are built. 
      The 1st one examines the relationship between Volume and Height of trees and the 2nd model examines the 
      relationship between Volume, Height and Girth of trees. 
      Three tabs are created. The first two tabs illustate the linear relationship of each model. In both scatter plots the
      user's input values are represented with a different color.
      The last one illustrates the predictions of each model based on user's input
      as well as the R squared value. It is obvious that the second model fits better as its R squared value 
      is much higher than that of the first model.",
      br(),
      "GitHub repository:",
      a('https://github.com/DemmiKo/Predict_trees_timber_volume', href = 'https://github.com/DemmiKo/Predict_trees_timber_volume'),
      hr(),
      sliderInput("Height",
                  "Height:",
                  step = 1,
                min = 30,
                max = 150,
                value = 70),
      conditionalPanel(condition = "input.main_menu == 'Model 2' | input.main_menu == 'Compare Models'",
          sliderInput("Girth",
                      "Girth:",
                      step = 0.1,
                      min = 5,
                      max = 40,
                      value = 12.2))
  ),
  
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel( id = "main_menu",
        tabPanel( "Model 1",
          plotOutput("plot1")
          ),
        tabPanel( "Model 2",
                  rglwidgetOutput("plot2",  width = 800, height = 600)
        ),
        tabPanel( "Compare Models",
                  h3("Predicted Volume from Model 1:"),
                  textOutput("pred1"),
                  h4("R squared:"),
                  textOutput("r1"),
                  br(),
                  hr(),
                  h3("Predicted Volume from Model 2:"),
                  textOutput("pred2"),
                  h4("R squared:"),
                  textOutput("r2")
        )
        )
    )
  )
))
