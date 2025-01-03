dashboardPage(
  dashboardHeader(title = "MediTrack Malaysia"),
  dashboardSidebar(
    conditionalPanel(
      condition = "output.userLoggedIn == true",
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
      )
    )
  ),
  dashboardBody(
    uiOutput("mainUI") # Dynamically render login/signup or dashboard
  )
)
