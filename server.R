#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("helper.R")
shinyServer(function(input, output) {
  observeEvent(input$button, {
    poskus <- reactive(simulacija(input$numTests, input$numPatients, input$meanAge, input$ageDev, input$pulmo, input$kardio, input$CNS, input$krg))
    zasliko <- reactive(zapleti(input$numPatients, input$meanAge, input$ageDev, input$pulmo, input$kardio, input$CNS, input$krg))
    povprecje <- reactive(signif(mean(poskus()), 3))
    std <- reactive(signif(sd(poskus()), 3))
    output$Text <- renderText({
      sprintf("The average mortality is %f with a standard deviation of %f", povprecje(), std())
    })
    output$Plot <- renderPlot({
      hist(poskus(), breaks = 10, freq=TRUE, xlab="Mortality", ylab="Frequency", main="Distribution of simulated patient mortality", col="blue")
      abline(v=input$accMort, col="red")
    })
    output$Barplot <- renderPlot({
      barplot(table(zasliko()[,1]), xlab="Number of complications", ylab="Frequency", main="Distribution of the number of complications")
    })
    output$Barplot2 <- renderPlot({
      boxplot(zasliko()[, 2] ~ zasliko()[, 1], ylab="Age of patients [years]", xlab="Number of complications")
    })
  })
  output$Slika <- renderImage({
    list(src="flowchart.png", contentType = "image/png")}, deleteFile = FALSE)
})
  