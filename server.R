library(dplyr)
library(leaflet)
library(shiny)


shinyServer(function(input, output, session) {
  
  # data source to use
  # currently, metals or wastewater
  dataSource <- reactive({
    
    if (input$dataSourceSelect == "Metals"){
      return(metals)
    }
    else if (input$dataSourceSelect == "Wastewater") {
      return(wastewater)
    }
    
  })
  
  # drop down menu list of items based on data source
  dataSourceList <- reactive({
    if (input$dataSourceSelect == "Metals"){
      return(metals.list)
    }
    else if (input$dataSourceSelect == "Wastewater") {
      return(wastewater.list)
    }
  })
  
  # create drop down functionality  for color
  # updates based on source
  output$colorOutput <- renderUI({
    
    myChoices <- dataSourceList()
    
    selectInput("colorSelect",
                    label = "Select Contaminant to Color By:",
                    choices = c("All Same Color", myChoices),
                    selected = "All Same Color")
  })

  # create drop down functionality  for size
  # updates based on source
  output$sizeOutput <- renderUI({
    
    myChoices <- dataSourceList()
    
    selectInput("sizeSelect",
                    label = "Select Contaminant to Size By:",
                    choices = c("All Same Size", myChoices),
                    selected = "All Same Size")
    
    
  })
  
  # plot data
  output$usgs.plot <- renderLeaflet({
    
    myData <- dataSource()

    # separate for factors
    if(input$colorSelect == "All Same Color") {
      
      myData$color <- "Station Location"
      colorData <- myData$color
      pal <- colorFactor(c("cornflowerblue"), colorData)
      myPopup <- paste(metals$Location.Name)
    }
    
    #else if (input$colorSelect == "Region") {
    #  colorData <- metals[[input$colorSelect]]
    #  pal <- colorFactor("Spectral", colorData)
    #  myPopup <- paste(metals$Location.Name, "<BR>", input$colorSelect, metals[, input$colorSelect])
    #}
    
    # colors for continuous data
    else {
     # if (input$dataSourceSelect == "Wastewater") {
     #   myColorSelect = paste(input$colorSelect, ".Qualifier", sep = "")
     #  colorData <- myData[[myColorSelect]]
     #  pal <- colorFactor("Spectral", colorData)
        
    #  }
    #  else {
      colorData <- myData[[input$colorSelect]]
      pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
     # }
      
      # popup tool tip
      myPopup <- paste(myData$Location.Name, "<BR>", input$colorSelect, myData[, input$colorSelect])
    }
    
    # set size of circles
    if(input$sizeSelect == "All Same Size") {
      radius = 1000
    }
    else {
      radius <- myData[[input$sizeSelect]] / max(myData[[input$sizeSelect]]) * 10000
      
    }
  
    # plot the data
    leaflet(myData) %>% 
      addTiles() %>% 
      addCircles(lng = ~Long,
                 lat = ~Lat,
                 popup = myPopup,
                 radius = radius, 
                 color = pal(colorData), 
                 fillOpacity = 0.4) %>% 
      addLegend("bottomright", pal = pal, values = colorData, title = paste(input$colorSelect, "(mg/kg, dry weight)"))
  })
  

  ### THIS CODE SHOULD BE ABLE TO UPDATE THE SIZE/COLOR WITHOUT RELOADING THE MAP
 # observe({
    
#    colorData <- metals[[input$colorSelect]]
#    pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
    
    #myTitle <- paste(input$colorSelect, "-", input$attributeSelect)
    
    #myPopup <- paste(metals$Location.Name, "<BR>", input$colorSelect, metals[, input$colorSelect])
    
#    leafletProxy(metals) %>% 
#      clearShapes()
#      addTiles() %>% 
#      addCircles(lng = ~Long,
#                 lat = ~Lat,
#                 radius = 1000, 
#                 color = pal(colorData), 
#                 fillOpacity = 0.4) %>% 
#      addLegend("bottomright", pal = pal, values = colorData, title = paste(input$colorSelect, "(mg/kg, dry weight)"))
    
    
#  })
})