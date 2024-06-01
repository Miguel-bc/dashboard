library(shiny)
library(readxl)

# Load SuperStoreSalesDataset

df_sales <- as.data.frame(read_xlsx("SuperStoreSalesDataSet.xlsx"))



# Define server logic

server <- function(input, output){
  
  total_sales <- reactive({
    sum(df_sales$Sales)
  })
  
  output$sales <- renderValueBox({
    valueBox(
      total_sales(), "Sales", icon = icon("wallet"),
      color = "blue"
    )
  })
  
  output$quantity <- renderValueBox({
    valueBox(
      "1000", "Quantity", icon = icon("object-group"),
      color = "green"
    )
  })
  
  output$returns <- renderValueBox({
    valueBox(
      "1500", "Returns", icon = icon("trash"),
      color = "orange"
    )
  })
  
  output$tbl_sales <- renderDataTable({
    datatable(df_sales)
  })
  
  
}

