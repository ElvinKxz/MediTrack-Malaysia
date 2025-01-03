dashboard_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      h2("Welcome to Your Dashboard!"),
      valueBoxOutput(ns("total_cases"), width = 6),
      valueBoxOutput(ns("average_cases"), width = 6)
    ),
    fluidRow(
      plotlyOutput(ns("trend_plot")),
      DT::dataTableOutput(ns("data_table"))
    )
  )
}

dashboard_module_server <- function(id, user_email) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Fetch disease data
    disease_data <- reactive({
      fetch_table_data("diseases")
    })
    
    # Total cases
    output$total_cases <- renderValueBox({
      total <- sum(disease_data()$CasesReported, na.rm = TRUE)
      valueBox(total, "Total Cases", icon = icon("hospital"))
    })
    
    # Average cases
    output$average_cases <- renderValueBox({
      avg <- round(mean(disease_data()$CasesReported, na.rm = TRUE), 2)
      valueBox(avg, "Average Cases", icon = icon("chart-line"))
    })
    
    # Trend plot
    output$trend_plot <- renderPlotly({
      plot <- ggplot(disease_data(), aes(x = DateReported, y = CasesReported)) +
        geom_line() + labs(title = "Cases Over Time")
      ggplotly(plot)
    })
    
    # Data table
    output$data_table <- renderDataTable({
      datatable(disease_data())
    })
  })
}
