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
shinyUI(
  pageWithSidebar(
  
  # Application title
    headerPanel("Surgical mortality simulation"),
  
  # Sidebar with a slider input for number of bins 
    sidebarPanel(
      actionButton("button", "Refresh"),
      sliderInput("accMort", "Acceptable mortality", min = 0.05, max = 0.15, value = 0.10),
      numericInput("meanAge", "Mean of patient age", min = 40, max = 90, value = 70),
      sliderInput("ageDev", "Standard deviation of patient age", min = 5, max = 10, value = 8),
      numericInput("numPatients", "Number of patients in trial", min = 1000, max = 5000, step = 1000, value = 1000),
      selectInput("numTests", "Number of trials", choices = c(50, 100)),
      sliderInput("pulmo", "Probability of pulmonary complication in the average age patient", min = 0.1, max = 0.3, value = 0.2, step = 0.05),
      sliderInput("kardio", "Probability of cardiac complication  in the average age patient", min = 0.02, max = 0.1, value = 0.07, step = 0.01),
      sliderInput("CNS", "Probability of CNS complication  in the average age patient", min = 0.05, max = 0.15, value = 0.13, step = 0.01),
      sliderInput("krg", "Probability of surgical complication in the average age patient", min = 0.1, max = 0.3, value = 0.2, step = 0.05)
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Mortality plot", plotOutput("Plot"), textOutput("Text")),
        tabPanel("Number of complications", plotOutput("Barplot")),
        tabPanel("Complication distribution by age", plotOutput("Barplot2")),
        tabPanel("Code flowchart", imageOutput("Slika"))
      )
    )
  )
)