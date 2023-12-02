library(dplyr)
library(openxlsx)
library(shiny)
library(stringr)

data <- read.xlsx("disney_filme.xlsx")

ui <- fluidPage(
  fluidRow(
    column(6, h1("Disney++")),
    column(6, img(src='logo.png', align = "right", width = "150"))
  ),
  br(),
  sidebarLayout(
    sidebarPanel( actionButton("button", "Hey Cri-Kee, schmeiß' die Losfee an!")),
    mainPanel(
      textOutput("chosen_film")
      )
  )
)

server <- function(input, output, session) {
  
  rvals <- reactiveValues(
    rolled_movies = NULL
  )
  
  observeEvent(input$button, ignoreInit = T, {
    
    rolled_movie <- 
      data %>% 
      filter(!(film %in% rvals$rolled_movies)) %>%
      slice_sample(n = 1, replace = F) %>% 
      pull(film) 
   
   rvals$rolled_movies <- c(rvals$rolled_movies, rolled_movie )
   
   print(rvals$rolled_movies)
    output$chosen_film <- renderText({
        str_c("Ihr schaut heute... ",  rolled_movie)
    })
    
  })

}

shinyApp(ui, server)