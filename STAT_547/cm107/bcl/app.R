#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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
ui <- fluidPage(
  titlePanel("BC Liquor price app", 
             windowTitle = "BCL app"),
  sidebarLayout(
    sidebarPanel("This text is in the sidebar."),
    mainPanel(
      plotOutput("price_hist"), # this makes the list "Output" and populates with "price_hist"
      tableOutput("bcl_data")) # this adds another traincar to the list
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$price_hist <- renderPlot(ggplot2::qplot(bcl$Price)) # subset price_hist and assign a plot to it
  output$bcl_data <- renderTable(bcl)
}

# Run the application 
shinyApp(ui = ui, server = server)

