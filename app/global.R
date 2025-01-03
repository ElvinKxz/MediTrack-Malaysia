library(shiny)
library(dplyr)
library(RSQLite)
library(plotly)
library(DT)

# Source external scripts
source("utils/database_handler.R")
source("app/modules/dashboard_module.R")

# Initialize the database
initialize_database()
