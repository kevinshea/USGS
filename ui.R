library(shiny)
library(leaflet)

shinyUI(navbarPage("USGS", id="nav",
                   
  div(class="outer",
      tags$head(# Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
        ),
                       
  # output map
  leafletOutput("usgs.plot", width="100%", height=850),
                       
  # Shiny versions prior to 0.11 should use class="modal" instead.
  # drop down menus
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
               draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
               width = 330, height = "auto",
                                     
              h2("USGS Contaminants"),
              selectInput("dataSourceSelect",
                          label = "Select Data Source: ",
                          choices = c("Metals", "Wastewater"),
                          selected = "Metals"),
              
              # dynamic drop down menu for color selection
              uiOutput("colorOutput"),
             # selectInput("colorSelect",
            #    label = "Select Contaminant to Color By:",
            #    choices = c("All Same Color", metals.list),
            #    selected = "Region"),
              
            # dynamic drop down menu for size selection                       
              uiOutput("sizeOutput")
              
            #  selectInput("sizeSelect",
            #    label = "Select Contaminant to Size By:",
            #    choices = c("All Same Size", metals.list),
            #    selected = "All Same Size")
             )
  )
)
)