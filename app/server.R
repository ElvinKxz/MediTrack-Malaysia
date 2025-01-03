function(input, output, session) {
  # Reactive value to track login state and user email
  logged_in <- reactiveVal(FALSE)
  user_email <- reactiveVal(NULL)
  
  # UI output for login/signup or dashboard
  output$mainUI <- renderUI({
    if (logged_in()) {
      tabItems(
        tabItem(tabName = "dashboard", dashboard_module_ui("dashboard"))
      )
    } else {
      div(
        class = "center-container",
        div(
          class = "login-box",
          h1("Welcome to MediTrack Malaysia"),
          uiOutput("formUI")
        )
      )
    }
  })
  
  # Reactive value to toggle between login and signup
  current_form <- reactiveVal("login")
  
  output$formUI <- renderUI({
    if (current_form() == "login") {
      tagList(
        textInput("login_email", "Email"),
        passwordInput("login_password", "Password"),
        actionButton("login_button", "Login"),
        br(), br(),
        tags$a(href = "#", "Create an Account", onclick = "Shiny.setInputValue('toggleForm', 'signup')")
      )
    } else {
      tagList(
        textInput("signup_username", "Username"),
        textInput("signup_email", "Email"),
        passwordInput("signup_password", "Password"),
        actionButton("signup_button", "Sign Up"),
        br(), br(),
        tags$a(href = "#", "Already have an account? Log In", onclick = "Shiny.setInputValue('toggleForm', 'login')")
      )
    }
  })
  
  # Toggle between login and signup forms
  observeEvent(input$toggleForm, {
    current_form(input$toggleForm)
  })
  
  # Login logic
  observeEvent(input$login_button, {
    if (authenticate_user(input$login_email, input$login_password)) {
      logged_in(TRUE)
      user_email(input$login_email)
      showNotification("Login successful!", type = "message")
    } else {
      showNotification("Invalid email or password.", type = "error")
    }
  })
  
  # Signup logic
  observeEvent(input$signup_button, {
    if (add_user(input$signup_username, input$signup_email, input$signup_password)) {
      showNotification("Signup successful! Please log in.", type = "message")
      current_form("login") # Switch to login form
    } else {
      showNotification("Signup failed. Email or username already exists.", type = "error")
    }
  })
  
  # Pass user email to the dashboard module
  dashboard_module_server("dashboard", user_email())
  
  # Track login state for sidebar visibility
  output$userLoggedIn <- reactive(logged_in())
  outputOptions(output, "userLoggedIn", suspendWhenHidden = FALSE)
}
