library(shiny)
require(data.table)
require(ROracle)
require(dplyr)
require(tidyr)
library(shinyjs)
require(shinydashboard)
require(DT)
require(gdata)
require(dygraphs)
require(xts)
require(base)
require(cronR)
require(ggplot2)
require(gridExtra)
require(ggpubr)
require(scales)
require(lubridate)
require(rhandsontable)
require(forecast)
require(jsonlite)
require(httr)
require(RPostgreSQL)
require(promises)



#login information
source("/home/jmoy001/ShinyApps/Dummy/www/login_credentials.R", local=T)


#dashboard
ui <- dashboardPage(skin="blue",
                    dashboardHeader(title="Service Engineering", titleWidth = 260),
                    dashboardSidebar(width=260,
                                     sidebarMenu(
                                       menuItem("Add Comments", tabName="Login_Table", icon=icon("log-in", lib ="glyphicon"), startExpanded=F)
                                     )),
                    dashboardBody(
                      tabItems(
                        tabItem(tabName="Login_Table",
                                bootstrapPage(
                                  tagList(
                                    tags$head(
                                    )
                                  ),
                                  
                                  ## Login module;
                                  div(class = "login",
                                      uiOutput("uiLogin"),
                                      textOutput("pass")
                                  ),
                                  
                                  fluidRow(uiOutput("MoySave1")),
                                  #RHANDSONTABLE OUTPUT,
                                  ######
                                  #Purpose of the shinyjs::hidden below is to hide commands and show them when necessary
                                  #Will be shown in the rhottable
                                  ######
                                  #hidden until logged in!
                                  shinyjs::hidden(
                                    div(
                                      id="output_table",
                                      h5(tags$b("Enter in your comments and click 'save' when you are done")),
                                      h5(tags$b("For Threshold columns, 0 means KPI has passed the set threshold and 1 means KPI has not passed set threshold")),
                                      h3(""),
                                      h3(""),
                                      h3(""),
                                      #editted for rhandson
                                      #shows edit-able table
                                      rHandsontableOutput("Total_Experience_DT")
                                    )),
                                  shinyjs::hidden(
                                    div(
                                      id = "downloadbutton",
                                      downloadButton(outputId="testbutton", "Download CSV"))
                                  ),
                                  shinyjs::hidden(
                                    div(
                                      id = "save_msg",
                                      h3("Thank you, please click the download csv button to download a copy of the comments entered."),
                                      h3("Refresh your browser and the changes will be shown on the Daily View Tab!")
                                    ),
                                    #data saved in login portion will remain hidden until YOU successfully logged in
                                    #otherwise, data is seen before you log in
                                    #removes the your data has been saved in the login portion
                                    shinyjs::useShinyjs()
                                  )
                                ))
                                )))


server <- function(input,output){
  #if problem with java script, use full filepath to fix
  show("app-content")
  source("/home/jmoy001/ShinyApps/Dummy/www/login.R", local=T)
  source("/home/jmoy001/ShinyApps/Dummy/www/RHotTable.R", local=T)
  source("/home/jmoy001/ShinyApps/Dummy/www/Server_read_datatables_rhandson_ex.R", local=T)
}

#Call shiny app
shinyApp(ui=ui, server=server)