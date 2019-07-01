#### Log in module ###
#used in Server
USER <- reactiveValues(Logged = F)

passwdInput <- function(inputId, label) {
  tagList(
    tags$label(label),
    tags$input(id = inputId, type="password", value="")
  )
}

#login page values
#called by uiLogin in UI side
output$uiLogin <- renderUI({
  if (USER$Logged == FALSE) {
    wellPanel(
      textInput("userName", "User Name:"),
      passwdInput("passwd", "Password:"),
      br(),
      actionButton("Login", "Login")
    )
  }
})

output$pass <- renderText({  
  if (USER$Logged == FALSE) {
    if (!is.null(input$Login)) {
      if (input$Login > 0) {
        Username <- isolate(input$userName)
        Password <- isolate(input$passwd)
        Id.username <- which(PASSWORD$Brukernavn == Username)
        Id.password <- which(PASSWORD$Passord    == Password)
        if (length(Id.username) > 0 & length(Id.password) > 0) {
          if (Id.username == Id.password) {
            USER$Logged <- TRUE
            #pull for message
            saveRDS(Username, file="/home/jmoy001/Rds/login_name.rds")
          } 
        } else  {
          "User name or password failed!"
        }
      } 
    }
  }
})