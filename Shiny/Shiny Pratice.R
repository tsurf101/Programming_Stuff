# Shiny pratice 
# **** MESSY NOTEBOOK WITH NOTES ******* 

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

# --------------  Adding a slider Input   -------------------
ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number",
              value = 25, min = 1, max = 100)
)
server <- function(input, output) {}
shinyApp(server = server, ui = ui)

# --------------  Adding an output  -------------------
ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  plotOutput("hist")
  
)
server <- function(input, output) {}
shinyApp(server = server, ui = ui)

# --------------  Adjusting our server -------------------
# Server function is used to assemble inputs into outputs 
# rule 1, save objects to display to output$
# rule 2, build objects to display with render*(). Render*() function creates the type of output you wish to make()
# rule 3, use input values with input$
ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  plotOutput("hist")
  
)

server <- function(input, output) {
  output$hist <- renderPlot({
    title <- "100 random normal values"
    hist(rnorm(input$num), main = title)
  })#code # notice how hist matches from above. Curly braces allow you to write as must R code as you want inside 
}

shinyApp(server = server, ui = ui)

# notes, reactivity automatically occurs whenever you use an input value to render an output object.

# --------------  How to share a Shiny App -------------------

# look at video 
# Shiny server can also build your own server 


#https://www.shinyapps.io/
  
# ***********************************************
# -------- Part 2 Reactivity  ------ 
# ***********************************************
# Reactive values 

# reative values work together with reactive functions. 
# you cannot call a reactive value from outside of one. 

# -------------- Reactive Toolkit -------------- 
# Reactive functions
# (1) Use a code chunk to build (and rebuild) an object
  # - What code will the function use? 
# (2) - The object will respond to changes in a set of reactive values
  # - Which reactive values will the object respond to? 


# Render functions build output to display in the app
# renderDataTable() - An interactive table 
# renderImage() - An image(sved as a link to a source file)
# renderPlot({ INSERT CODE HERE}) - A plot #example 
# renderPrint() - A code block of printed outpput
# renderTable() - A table 
# render Text() - A character string
# render UI () - A Shiny UI element 


# ----- TWO INPUT EXAMPLE ----
# 01-two-inputs 

 # writing a title added 
ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  textInput(inputId = "title", 
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
  plotOutput("hist")
)

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num), main = input$title)
  })
}

shinyApp(ui = ui, server = server)


# Recap: render*()
# render*() functions make objects to display
# output$ Always save the result to output$
# render*() makes an observer object that has a block of code associated with it 

# The object will rerun the entire code block to update itself whenver it is invalidated 

# ----- reactive() ----
# builds a reactive object (reactive expression)
# example

data <- reactive({ rnorm(input$num)})

# using a reactive expression for the example above and redoing it.


ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  plotOutput("hist"),
  verbatimTextOutput("stats")
)

server <- function(input, output) {
  data <- reactive({
    rnorm(input$num)
  })
  output$hist <- renderPlot({
    hist(data())
  })
  output$stats <- renderPrint(summary(data()))
}

shinyApp(ui = ui, server = server)

# A reactive expression is special in two ways 
# data()
# 1 - You can a reactive expression like a function
# 2 - Reactive expressions cash their values (the expressions will return its most recent value, unless it has become invalidated)


# recap: reactive()
# 1 - reactive() makes an object to use (in downstream code)
# 2- reactive expressions are themselves reactive. Use them to modularize yours apps
# data() - Call a reactive expression like a function
# reactive expressions cach their values to avoid unnecessary computation 

# ----- prevent reactions with isolate() ----
# we prevent the title field from updating the plot 
# isolate({R CODE}) returns the result as a non-reactove value 

ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  textInput(inputId = "title", 
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
  plotOutput("hist")
)

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num), 
         main = isolate({input$title})) # notice how we are using isolate(). can also use this to debug reactive objects
  })
}

shinyApp(ui = ui, server = server)

# ----- how to trigger code on the server side based off input objects ----
# action buttons -> actionButton(inputID = "go", label = "Click Me!" )

#e.g.
ui <- fluidPage(
  actionButton(inputId = "clicks", 
             lebel = "Click Me")
)

# observeEvent() triggers events from "clickMe" buttons 
#e.g. 
# note to self - remember that when you run Shiny apps locally your server is the R session 
# good ideas when you want to save logs or save results, save to files, etc. 
library(shiny)

ui <- fluidPage(
  actionButton(inputId = "clicks",
               label = "Click Me")
)

server <- function(input, output){
  observeEvent(input$clicks, {
    print(as.numeric(input$clicks))
  })
}

shinyApp(ui = ui, server = server)


# observe() also triggers cod to run on the server
# - observe({print(input$clicks)})

# ----- Delay reactions with eventReactive() ----
# have the graph respond only once you hit an update function 
# data <- eventReactive(Input$go, {rnorm(input$num)})

# 1 - use eventReactive() to delay reactions 
# 2 - eventReactive() creates a reactive expression 
# 3 - You can specify precisely which reactive values should invalidate the expression 

ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  actionButton(inputId = "go",
               label = "Update"),
  plotOutput("hist")
)

server <- function(input, output) {
  data <- eventReactive(input$go, 
                        {rnorm(input$num)})
  output$hist <- renderPlot({
    hist(rnorm(data())) # using reactive expression 
  })
}

shinyApp(ui = ui, server = server)


# ----- Manage state with reactiveValues() ----
# Shiny does not allow you to overwrite values in your app 
# reactiveValues() creates a list of reactive values to manipulate programmatically ( usually with observeEvent())

# rv <- reactiveValues(data = rnorm(100))

ui <- fluidPage(  
  actionButton(inputId = "norm",
               label = "Normal"),
  actionButton(inputId = "unif",
               label = "Uniform"),
  plotOutput("hist")
)

server <- function(input, output) {
  rv <- reactiveValues(data = rnorm(100))
  observeEvent(input$norm, {rv$data <- rnorm(100)})
  observeEvent(input$unif, {rv$data <- runif(100)})
  
  output$hist <- renderPlot({
    hist(rv$data)
  })
}

shinyApp(ui = ui, server = server)

# -----TIPS ----
# Code outside the server function will be run once per R session(worker)
# code inside the server function will be run once per end user (connection)

# Always put the bear minimum inside a render function into the server function. 
# Code inside a reactive function will be run once per reaction ( MANY TIMES )

# ***********************************************
# -------- Part 3 HOW TO STYLIZE SHINNY APPS AND APPERANACE ------ 
# ***********************************************

# User Interacce 
# When writing R, you add content with tag functions. SHINY HTML TAGS 
# tags$h1() <> <h1></ht>
# tags$a() <> <a></a> 
names(tags)

#e.g.
tags$a(href = "www.rstudio.com", "Rstudio")
fluidPage(
  tags$h1("First level - Hello world"), # or just use the wrapper function h1() 
  "Writing text example Hershey",
  tags$p("Writing text in a paragraph"), #organzining your text # or just use the wrapper function p() 
  tags$img(height = 100, 
           width = 100,
           src = "path...........") # or just use the wrapper function a() 
)


# TO ADD AN IMAGE FROM A FILE, SAVE THE FILE IN A SUBDIRECTORY NAMED WWW 

# you can pass in html into a shiny app by doing 
fluidPage(
  HTML(
    
  )
)

# ----- Create a layout  ------ 
# add html that divides the UI into a grid 
# example functions (1) fluidRow() (2) column(width = 2 )

ui <- fluidPage(
  fluidRow(),
  fluidRow() # adds a row to the grid, so this would be the second row 
)

# column() adds columns withi na row. Specify the width and offest of each column out of 12
# example

ui <- fluidPage(
  fluidRow(
    column(3),
    column(5, sliderInput(.........))),
  fluidRow(
    column(4, offset = 8,
           plotOutput("hist"))
  ))


# assemble layers of panels 
#add wellPanel() 
# look at the Panel() objects 

ui <- fluidPage(  
  wellPanel(actionButton(inputId = "norm",
               label = "Normal"),
  actionButton(inputId = "unif",
               label = "Uniform"),
  plotOutput("hist")
))

server <- function(input, output) {
  rv <- reactiveValues(data = rnorm(100))
  observeEvent(input$norm, {rv$data <- rnorm(100)})
  observeEvent(input$unif, {rv$data <- runif(100)})
  
  output$hist <- renderPlot({
    hist(rv$data)
  })
}

shinyApp(ui = ui, server = server)

# ---- TabPanel() ----
# creates a stackable layer of elements. Each tab is like a small UI of its own. 

# combine tabPanels() with one of these:
# tabsetPanel() #combines tabs into a single panel. Use tabs to navigate between tabs 
# navlistPanel() # combines tabs into a single panels. Use Links to navigate between tabs 
# navarPage() # combines tab links into a dropdown menu for navbarPage()

fluidPage(
  tabsetPanel(
    tabPanel("tab 1", "contents"),
    tabPanel("tab 2", "contents")
  )
)

# **** ------ use a prepackaged layour in Shiny  --------- *******

ui <- FluidPage(
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

# shinyDashboard package 
# dashboardPage() allows you easy to create dasboards. This is a package in R 

# ---- Style with CSS ----
# CSS (cascading Style Sheets) are a framework for customizing the appearance of elements in a web page. 

# 3 ways to style a webpage 
# 1 - Link to an external CSS File (put in the www folder )
# 2 - Write global CSS in header 
# 3 - Write individual CSS in a tag's style attribute 

# Shiny uses the Boostrap 3 CSS framework, getbootstrap.com

# set the theme argument of FluidPage() to the .css filename, or 

ui <- fluidPage(
  theme = "bootswatch-cerelean.css",
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)


ui <- fluidPage(
  includeCSS("filepath.CSS")
)

# add google Analytics to a Shiny app 
# track visiter actions with Google analytics 
