library(shiny)
library(shinydashboard)
library(DT)
library(leaflet)
library(readxl)
library(DT)
library(janitor)
library(tmaptools)
library(dplyr)
library(shinyjs)

ui <- dashboardPage(
  
  dashboardHeader(title = "Dashboard Sales"),
  
  dashboardSidebar(
    
    selectInput("category","Category", choices = NULL,  multiple = TRUE),
    selectInput("subcategory","Subcategory", choices = NULL, multiple = TRUE),
    selectInput("region","Region", choices = NULL, multiple = TRUE),
    selectInput("state","State", choices = NULL, multiple = TRUE),
    selectInput("city","City", choices = NULL, multiple = TRUE),
    selectInput("segment","Segment", choices = NULL, multiple = TRUE),
    selectInput("paymentmode","Payment Mode", choices = NULL, multiple = TRUE)
    
    
  ),
  
  dashboardBody(
    fluidRow(
      valueBoxOutput("sales"),
      valueBoxOutput("quantity"),
      valueBoxOutput("returns")
      
    ),
    
    fluidRow(
      leafletOutput("salesmap")   
    ),
    
    fluidRow(
      tags$br(),
      box(
        title = "Sales Detail",
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 12,
        DT::DTOutput("tbl_sales")
      )
    )
  )
)