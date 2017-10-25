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
library(sp)
library(rworldmap)

# ----- see: https://stackoverflow.com/a/14342127
# The single argument to this function, points, is a data.frame in which:
#   - column 1 contains the longitude in degrees
#   - column 2 contains the latitude in degrees
coords2country = function(points)
{
    countriesSP <- getMap(resolution = 'low')
    #countriesSP <- getMap(resolution='high') #you could use high res map from rworldxtra if you were concerned about detail

    # convert our list of points to a SpatialPoints object

    # pointsSP = SpatialPoints(points, proj4string=CRS(" +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))

    #setting CRS directly to that from rworldmap
    pointsSP = SpatialPoints(points, proj4string = CRS(proj4string(countriesSP)))


    # use 'over' to get indices of the Polygons object containing each point
    indices = over(pointsSP, countriesSP)

    # return the ADMIN names of each country
    indices$ADMIN
    #indices$ISO3 # returns the ISO3 code
    #indices$continent   # returns the continent (6 continent model)
    #indices$REGION   # returns the continent (7 continent model)
}

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

    get_country <- reactive({
        if (is.na(get_gps()$lng) || is.na(get_gps()$lat)) {
            NA_character_
        } else {
            as.character(coords2country(data.frame(
                lon = get_gps()$lng,
                lat = get_gps()$lat
            )))
        }
    })

    get_pos_input <- reactive({
        list(lat = input$lat, lng = input$lng)
    }) %>% debounce(1500)

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
        tags$div(
            tags$span('Country:', tags$span(class = 'text-primary', get_country())),
            tags$ul(
                tags$li('Longitude:',
                        tags$span(class = 'text-primary',
                                  round(get_gps()$lng, digits = 4))),
                tags$li('Latitude:',
                        tags$span(class = 'text-primary',
                                  round(get_gps()$lat, digits = 4)))
            )
        )
    })

    output$mymap_2 <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            addMarkers(lng = get_pos_input()$lng,
                       lat = get_pos_input()$lat)
    })
})
