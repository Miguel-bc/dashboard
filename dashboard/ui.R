library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  
  dashboardHeader(title = "Dashboard Ventas"),
  
  dashboardSidebar(
    
  ),
  
  dashboardBody(
    fluidRow(
      valueBoxOutput("sales"),
      valueBoxOutput("quantity"),
      valueBoxOutput("returns")
      
    ),
    
    fluidRow(
      
      box(title = "Ingredients",
          solidHeader = T,
          width = 4,
          collapsible = T,
          div(DT::DTOutput("ing_df"), style = "font-size: 70%;")),
      
      box(title = "Macronutrients", solidHeader = T,
          width = 8, collapsible = T,
          plotlyOutput("macro_plot"))
      
    ),
    
    fluidRow(
      box(
        title = "Sales Detail",
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 12,
        dataTableOutput("tbl_sales")
      )
      
    ),
    
    fluidRow(
      
    )
  )
)