library(RSQLite)

# Initialize the SQLite database
initialize_database <- function(db_path = "app/db/healthcare_data.sqlite") {
  con <- dbConnect(SQLite(), dbname = db_path)
  
  # Create Users Table
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      email TEXT UNIQUE,
      password TEXT,
      signup_date TEXT
    )
  ")
  
  # Create Diseases Table
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS diseases (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      DateReported TEXT,
      State TEXT,
      Condition TEXT,
      AgeGroup TEXT,
      CasesReported INTEGER
    )
  ")
  
  dbDisconnect(con)
}

# Fetch data from a table
fetch_table_data <- function(table_name, db_path = "app/db/healthcare_data.sqlite") {
  con <- dbConnect(SQLite(), dbname = db_path)
  data <- dbReadTable(con, table_name)
  dbDisconnect(con)
  return(data)
}

# Add a new user
add_user <- function(username, email, password, db_path = "app/db/healthcare_data.sqlite") {
  con <- dbConnect(SQLite(), dbname = db_path)
  result <- tryCatch({
    dbExecute(con, "
      INSERT INTO users (username, email, password, signup_date) 
      VALUES (?, ?, ?, ?)",
              params = list(username, email, password, as.character(Sys.Date()))
    )
    TRUE
  }, error = function(e) FALSE)
  dbDisconnect(con)
  return(result)
}

# Authenticate a user
authenticate_user <- function(email, password, db_path = "app/db/healthcare_data.sqlite") {
  con <- dbConnect(SQLite(), dbname = db_path)
  user <- dbGetQuery(con, "
    SELECT * FROM users 
    WHERE email = ? AND password = ?", 
                     params = list(email, password)
  )
  dbDisconnect(con)
  return(nrow(user) > 0)
}
