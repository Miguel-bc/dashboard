

# Geocode cities using tmaptools

geocode_city <- function(location) {
  result <- geocode_OSM(location, as.data.frame = TRUE)
  if (nrow(result) > 0) {
    return(data.frame(city = location, lon = result$lon, lat = result$lat))
  } else {
    return(data.frame(city = location, lon = NA, lat = NA))
  }
}

# Load SuperStoreSalesDataset

df_sales <- as.data.frame(read_xlsx("SuperStoreSalesDataSet.xlsx"))
df_sales <- clean_names(df_sales)

# Extract unique states and initialize coordinates data frame

unique_states <- unique(df_sales$state)
coordinates <- data.frame(state = unique_states, lon = NA, lat = NA, stringsAsFactors = FALSE)

for (i in 1:nrow(coordinates)) {
  coords <- geocode_city(coordinates$state[i])
  coordinates$lon[i] <- coords["lon"]
  coordinates$lat[i] <- coords["lat"]
}

df_sales <- merge(df_sales, coordinates, by = "state", all.x = TRUE )

# Define server logic

server <- function(input, output, session){
  
  filtered_data <- reactive({
    
    data <- df_sales
    
    # Apply filters based on selected inputs
    if (!is.null(input$category) && length(input$category) > 0) {
      data <- data[data$category %in% input$category, ]
    }
    
    if (!is.null(input$subcategory) && length(input$subcategory) > 0) {
      data <- data[data$sub_category %in% input$subcategory, ]
    }
    
    if (!is.null(input$region) && length(input$region) > 0) {
      data <- data[data$region %in% input$region, ]
    }
    
    if (!is.null(input$state) && length(input$state) > 0) {
      data <- data[data$state %in% input$state, ]
    }
    
    if (!is.null(input$city) && length(input$city) > 0) {
      data <- data[data$city %in% input$city, ]
    }
    
    if (!is.null(input$segment) && length(input$segment) > 0) {
      data <- data[data$segment %in% input$segment, ]
    }
    
    if (!is.null(input$paymentmode) && length(input$paymentmode) > 0) {
      data <- data[data$payment_mode %in% input$paymentmode, ]
    }
    
    data
  })
  
  updateSelectInput(session, "category", choices = unique(df_sales$category))
  updateSelectInput(session, "subcategory", choices = unique(df_sales$sub_category))
  updateSelectInput(session, "region", choices = unique(df_sales$region))
  updateSelectInput(session, "state", choices = unique(df_sales$state))
  updateSelectInput(session, "city", choices = unique(df_sales$city))
  updateSelectInput(session, "segment", choices = unique(df_sales$segment))
  updateSelectInput(session, "paymentmode", choices = unique(df_sales$payment_mode))
  
  output$sales <- renderValueBox({
    
    sales_sum <- sum(filtered_data()$sales, na.rm = TRUE)
    
    pretty_sales <- paste("$", format(sales_sum, big.mark = ".", decimal.mark = ",", digits = 2))
    
    valueBox(
      pretty_sales, "Sales", icon = icon("wallet"),
      color = "blue"
    )
  })
  
  output$quantity <- renderValueBox({
    
    quantity_sum <- sum(filtered_data()$quantity, na.rm = TRUE)
    
    pretty_quantity <- format(quantity_sum, big.mark = ".", decimal.mark = ",", digits = 2)
    
    valueBox(
      pretty_quantity, "Quantity", icon = icon("object-group"),
      color = "green"
    )
    
  })
  
  output$returns <- renderValueBox({
    
    return_sum <- sum(filtered_data()$returns, na.rm = TRUE)
    
    pretty_return <- format(return_sum, big.mark = ".", decimal.mark = ",", digits = 2)
    
    valueBox(
      pretty_return, "Returns", icon = icon("trash"),
      color = "orange"
    )
  })
  
  output$tbl_sales <- DT::renderDT({
    datatable(filtered_data())
  })
  
  output$salesmap <- renderLeaflet({
    data <- filtered_data()
    
    # Convert lon and lat to numeric
    data$lon <- as.numeric(data$lon)
    data$lat <- as.numeric(data$lat)
    
    # Define colors based on quantity
    color_palette <- colorFactor(palette = c("green", "yellow", "red"),
                                 domain = data$quantity)
    
    leaflet(data = data) %>%
      addTiles() %>%
      addCircleMarkers(~lon, ~lat, popup = ~paste("Sales: ", sales, "<br>",
                                                  "City: ", city, "<br>",
                                                  "State: ", state),
                       color = ~color_palette(quantity))
  })
}

