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
shinyUI(navbarPage('aha',

    tabPanel("read photo",
             # tags$head(
             #     tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
             # ),

             fluidRow(
                 column(width = 8,
                        fileInput(
                            "img",
                            "Choose Image File",
                            multiple = FALSE,
                            accept = c("image/jpeg", "image/jpg")
                        )),
                 column(width = 4, uiOutput('gps'))
             ),

             hr(),

             leafletOutput('mymap')
             ),

    tabPanel("find pos",
             numericInput('lng', label = 'Longitude', value = 116.3914,
                          min  = -180, max = 180, step = 0.5),
             numericInput('lat', label = 'Latitude', value = 39.9030,
                          min  = -90, max = 90, step = 0.5),

             hr(),

             leafletOutput('mymap_2'))
))
