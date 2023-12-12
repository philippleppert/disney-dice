library(dplyr)
library(openxlsx)
library(shiny)
library(stringr)
library(fontawesome)

data <- read.xlsx("disney_filme.xlsx")

ui <- fluidPage(
  includeCSS("www/styles.css"),
  title = "Disney-Dice",
  fluidRow(
    column(
      12, 
      tags$p("Disney-Dice", fa("dice", fill = "#006B99"),  style="font-size: 50px;")
      ), 
    ),
  br(),
  h4("Drückt den Button und Cri-Kee schmeißt die Losfee an!"),
  br(),
  fluidRow(
    column(
    12,
    tags$button(
      id = "button",
      class = "btn action-button",
      tags$img(
        src = "logo.png", id = "test",
        height = "300px"
        )
      )
    )
  ), 
  fluidRow(
    column(3, h3("Ihr schaut heute...")), column(9, h3(textOutput("chosen_film")))
  )
)

server <- function(input, output, session) {
  
  # store all rolled movies in session
  rvals <- reactiveValues(
    rolled_movies = NULL
  )
  
  # observe action button
  observeEvent(input$button, ignoreInit = T, {
    
    # currently rolled movie
    rolled_movie <- 
      data %>% 
      filter(!(film %in% rvals$rolled_movies)) %>%
      slice_sample(n = 1, replace = F) %>% 
      pull(film) 
   
    # add to reactive 
   rvals$rolled_movies <- c(rvals$rolled_movies, rolled_movie )
   
   # output rolled movie
   output$chosen_film <- renderText({
     rolled_movie
     })
    
  })

}

shinyApp(ui, server)