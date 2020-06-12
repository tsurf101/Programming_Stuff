# Shiny pratice 

library(shiny)

runExample("01_hello")

# ------  SHINY APP TEMPLATE ---- basically shortest variable shiny app 
ui <- fluidPage() # sets up an UI object 
server <- function(input, output) {} # sets up a server object 
shinyApp(ui = ui, server = server) # knitts the two together into a shiny app 


# --------------

# Think about inputs and ouputs when building an app
# You add elements as arguments to the fluidPage() 
# create reactive inputs with an *Input() function
# Display reactive results with an *Output() function
# Use the server function to assemble inputs into outputs 

ui <- fluidPage(
  # * Input() functions,
  # * Output() functions 
) # sets up an UI object 
server <- function(input, output) {} # sets up a server object 
shinyApp(ui = ui, server = server) # knitts the two together into a shiny app 

# --------------  Adding a slider Input 
ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number",
              value = 25, min = 1, max = 100)
)
server <- function(input, output) {}
shinyApp(server = server, ui = ui)

# --------------  Adding an output
ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  plotOutput("hist")
  
)
server <- function(input, output) {}
shinyApp(server = server, ui = ui)




