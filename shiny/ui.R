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

    fluidRow(
        column(width = 8,
               fileInput(
                   "img",
                   "Choose Image File",
                   multiple = FALSE,
                   accept = c("image/jpeg", "image/jpg")
               )),
        column(width = 4, textOutput('country'))
    ),

    hr(),

    leafletOutput('mymap')
))
