#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(exifr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    get_gps <- reactive({
        if (is.null(input$img)) {
            list(lng = NA_real_, lat = NA_real_)
        } else {
            img_exif = read_exif(input$img$datapath)
            if (!("GPSPosition" %in% names(img_exif))) {
                list(lng = NA_real_, lat = NA_real_)
            } else {
                list(lng = img_exif$GPSLongitude, lat = img_exif$GPSLatitude)
            }
        }
    })

    output$mymap <- renderLeaflet({

        lng = get_gps()$lng
        lat = get_gps()$lat

        if (is.na(lng) || is.na(lat)) {
            leaflet()
        } else {
            leaflet() %>%
                addTiles() %>%
                addMarkers(lng = lng, lat = lat)
        }
    })

    output$gps <- renderUI({
        tags$ul(
            tags$li('Longitude:',
                    tags$span(class = 'text-primary',
                              round(get_gps()$lng, digits = 4))),
            tags$li('Latitude:',
                    tags$span(class = 'text-primary',
                              round(get_gps()$lat, digits = 4)))
        )
    })
})
