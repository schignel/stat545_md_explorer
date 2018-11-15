#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
# Any code before "Define UI" runs, so you can set things up for it. 
a <- 5
bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram

## In-class example for reference ##
# ui <- fluidPage(
#    tags$b("This is some text"),
#    p(tags$i("This is more text.")),
#    tags$h1("Level 1 header"), # call function from tags package
#    h1("Level 1 header, pt 2"), # use shortcut (recommended)
#    h1(em("Level 1 header, pt 2")), # italics
#    HTML("<h1>Level 1 header, part 3</h1>"), # write your own html
#    a # example of calling from pre-UI code
# )

# This will output html, so we can't put R code in it
# each of these functions output html
ui <- fluidPage(
  titlePanel("BC Liquor price app", 
             windowTitle = "BCL app"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Select your desired price range.",
                  min = 0, max = 100, value = c(15, 30), pre="$"), #settings
      radioButtons("typeInput", "Select your alcoholic beverage type.",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                               selected = "WINE") # set the default
    ),
    mainPanel(
      plotOutput("price_hist"), # this makes the list "Output" and populates with "price_hist"
      tableOutput("bcl_data")) # this adds another traincar to the list
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observe(print(input$priceInput))
  bcl_filtered <- reactive({ #defining a variable to put filtered data in. Reactive means it updates
    bcl %>%
      filter(Price < input$priceInput[2], # [2] = upper bound from value argument
             Price > input$priceInput[1], # [1] = lower bound
             Type == input$typeInput)     # Whatever type is selected in the radio 
  })
  output$price_hist <- renderPlot({
    bcl_filtered() %>% # need to include () since it's reactive
      ggplot(aes(Price)) +
      geom_histogram()
  })
  output$bcl_data <- renderTable({
    bcl %>% 
      filter(Price < input$priceInput[2],
             Price > input$priceInput[1],
             Type == input$typeInput)
  })
}
# Run the application 
shinyApp(ui = ui, server = server)

