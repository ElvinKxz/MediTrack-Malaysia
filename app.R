library(shiny)
library(shinydashboard)

# Source global configuration and setup
source("app/global.R")

# Run the Shiny app
shinyApp(
  ui = source("app/ui.R")$value,
  server = source("app/server.R")$value
)
