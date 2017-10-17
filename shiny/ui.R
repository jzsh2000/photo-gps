#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("photo gps"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        fileInput("img", "Choose Image File",
                  multiple = FALSE,
                  accept = c("image/jpeg", "image/jpg"))
    ),

    # Show a plot of the generated distribution
    mainPanel(
        leafletOutput('mymap')
    )
  )
))
