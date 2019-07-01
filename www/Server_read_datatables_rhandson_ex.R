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
require(promises)

##############################
setwd("/home/jmoy001/Rds/")
###############################

# #read in files
#add Comments section, all KPIs
#pre comments, comments left there when post comments are inputed
Total_Experience_View <- readRDS(file="Total_Experience_View_Daily.rds")
#post comments
#NOTE, if any changes are made to the Total_Experience_View, change the RDS file below with the Total Experience View RDS file. Run through app to save output, then revert RDS files
daily_final <- readRDS(file="Rhandson_postcomments.rds")
#login time stamp
final_message <-readRDS(file="comment_submission.rds")
final_message_r <- reactive({final_message})

##pull yesterdays date
date_text <- paste("Daily View shows data from", format(Sys.Date()-1,format="%B %d %Y"))
date_r <- reactive({date_text})


#logic now is to update daily view daily so it changes when the data is available
#need the daily to pull the comments to later put back into the view

#pulled comments from daily
USCC_Comments<-daily_final$USCC_Comments
Project_Eagle_Comments <-daily_final$Project_Eagle_Comments
Iowa_Comments <-daily_final$Iowa_Comments
Wisconsin_Comments <-daily_final$Wisconsin_Comments
NW_Comments <-daily_final$NW_Comments
TMO_OB_Comments<-daily_final$TMO_OB_Comments
TMO_IB_Comments<-daily_final$TMO_IB_Comments



# #add comments into pre. This will leave comments into the login(good so it stays for the next person!)
Total_Experience_View$USCC_Comments<-USCC_Comments
Total_Experience_View$Project_Eagle_Comments<-Project_Eagle_Comments
Total_Experience_View$Iowa_Comments<-Iowa_Comments
Total_Experience_View$Wisconsin_Comments<-Wisconsin_Comments
Total_Experience_View$NW_Comments<-NW_Comments
Total_Experience_View$TMO_OB_Comments<-TMO_OB_Comments
Total_Experience_View$TMO_IB_Comments<-TMO_IB_Comments


#pick apart df to separate into separate dataframes
USCC_Total_Experience_View <- Total_Experience_View[c(1:22),c(1:5)]
Project_Eagle_View <- Total_Experience_View[c(2:4,6,9:22),c(1,2,6,7,8)]
Iowa_View <- Total_Experience_View[c(1:22),c(1,2,9,10,11)]
Wisconsin_View <- Total_Experience_View[c(1:22),c(1,2,12,13,14)]
NW_View <- Total_Experience_View[c(1:22),c(1,2,15,16,17)]
TMO_OB_View <- Total_Experience_View[c(2:4,6,9:22),c(1,2,18,19,20)]
TMO_IB_View <- Total_Experience_View[c(23,24), c(1,2,21,22,23)]


#reindex row numbers for dataframes that aren't continious.
#Dont need to reindex USCC_Total_Experience_View, Iowa, Wisconsin, and NW
rownames(Project_Eagle_View) <- 1:nrow(Project_Eagle_View)
rownames(TMO_OB_View) <- 1:nrow(TMO_OB_View)
rownames(TMO_IB_View) <- 1:nrow(TMO_IB_View)


### rename column, split
USCC_Total_Experience_View <- USCC_Total_Experience_View %>%
  rename("Threshold Passed?"="USCC Threshold") %>%
  select("Network KPI", "Set Threshold", "Threshold Passed?", "USCC", "USCC_Comments")

Project_Eagle_View <- Project_Eagle_View %>%
  rename("Threshold Passed?"="Project Eagle Threshold") %>%
  select("Network KPI", "Set Threshold", "Threshold Passed?", "Project_Eagle", "Project_Eagle_Comments")

Iowa_View <- Iowa_View %>%
  rename("Threshold Passed?"="Iowa Threshold") %>%
  select("Network KPI", "Set Threshold", "Threshold Passed?", "Iowa", "Iowa_Comments")

Wisconsin_View <- Wisconsin_View %>%
  rename("Threshold Passed?"="Wisconsin Threshold") %>%
  select("Network KPI", "Set Threshold", "Threshold Passed?", "Wisconsin", "Wisconsin_Comments")

NW_View <- NW_View %>%
  rename("Threshold Passed?"="NW Threshold") %>%
  select("Network KPI", "Set Threshold", "Threshold Passed?", "NW", "NW_Comments")

TMO_OB_View <- TMO_OB_View %>%
  rename("Threshold Passed?"="TMO OB Threshold") %>%
  select("Network KPI", "Set Threshold", "Threshold Passed?", "TMO OB", "TMO_OB_Comments")

TMO_IB_View <- TMO_IB_View %>%
  rename("Threshold Passed?"="TMO IB Threshold") %>%
  select("Network KPI", "Set Threshold", "Threshold Passed?", "TMO IB", "TMO_IB_Comments")

#VoLTE KPIs
Wisconsin_Final_r <- reactive({Wisconsin_Final})
Iowa_Final_r <- reactive({Iowa_Final})
NW_DB_r <- reactive({NW_DB})
Mid_Atlantic_Final_r <- reactive({Mid_Atlantic_Final})
New_England_Final_r <- reactive({New_England_Final})



#View on Add Comments - 1 date for comments section, This view contains all data in comments section
Total_Experience_View_r <- reactive({Total_Experience_View})


#Views on Daily View
USCC_Total_Experience_View_r <- reactive({USCC_Total_Experience_View})
Project_Eagle_View_r <- reactive({Project_Eagle_View})
Iowa_View_r <- reactive({Iowa_View})
Wisconsin_View_r <- reactive({Wisconsin_View})
NW_View_r <- reactive({NW_View})
TMO_OB_View_r <- reactive({TMO_OB_View})
TMO_IB_View_r <- reactive({TMO_IB_View})

  

#need to fix render object, DT wont work for rhandson
#may need to create rhandson inside here
 output$Total_Experience_DT <- rhandsontable::renderRHandsontable({
  rhandsontable::rhandsontable(Total_Experience_View_r(), width =1600 , height =1000) %>%
    hot_col("Network KPI", readOnly=T) %>%
    hot_col("Set Threshold", readOnly=T) %>%
    hot_col("USCC Threshold", readOnly = T) %>%
    hot_col("USCC", readOnly=T) %>%
    hot_col("USCC_Comments", readOnly=F) %>%
    hot_col("Project Eagle Threshold", readOnly = T) %>%
    hot_col("Project_Eagle", readOnly=T) %>%
    hot_col("Project_Eagle_Comments", readOnly=F) %>%
    hot_col("Iowa Threshold", readOnly = T) %>%
    hot_col("Iowa", readOnly=T) %>%
    hot_col("Iowa_Comments", readOnly=F) %>%
    hot_col("Wisconsin Threshold", readOnly = T) %>%
    hot_col("Wisconsin", readOnly=T) %>%
    hot_col("Wisconsin_Comments", readOnly=F) %>%
    hot_col("NW Threshold", readOnly = T) %>%
    hot_col("NW", readOnly=T) %>%
    hot_col("NW_Comments", readOnly=F) %>%
    hot_col("TMO OB Threshold", readOnly = T) %>%
    hot_col("TMO OB", readOnly=T) %>%
    hot_col("TMO_OB_Comments", readOnly=F) %>%
    hot_col("TMO IB Threshold", readOnly = T) %>%
    hot_col("TMO IB", readOnly=T) %>%
    hot_col("TMO_IB_Comments", readOnly=F) %>%
    hot_cols(colWidths = c(270,90,90,100,300,90,100,300,90,100,300, 90,100,300, 90,100,300, 90,100,300, 90,100,300), fixedColumnsLeft=1) %>%
    hot_rows(fixedRowsTop = 1)
})



output$USCC_Total_Experience_View_DT <- DT::renderDataTable(server=FALSE,{
  DT::datatable(USCC_Total_Experience_View_r(),
                extensions = c('FixedColumns','KeyTable','Scroller'), #removed 'ColReorder', 'RowReorder'
                options = list(keys=TRUE,
                               columnDefs= list(list(targets = 3, visible = F)),
                               #scroller=T,
                               #remove search bar on top right
                               searching = FALSE,
                               processing=FALSE,
                               scrollx=1000,
                               #22 rows of data shown
                               pageLength = 22,
                               #scrollY=1000,
                               rowReorder=T,
                               colReorder = TRUE,
                               paging=T,
                               dom = 'Bfrtip',
                               autoWidth=F)) %>%
    formatStyle(
      "Threshold Passed?",
      target="row",
      backgroundColor = styleEqual(c(0,1), c('red','white'))
    )
})

##
output$Project_Eagle_View_DT <- DT::renderDataTable(server=FALSE,{
  DT::datatable(Project_Eagle_View_r(),
                extensions = c('FixedColumns','KeyTable','Scroller'), #removed 'ColReorder', 'RowReorder'
                options = list(keys=TRUE,
                               columnDefs= list(list(targets = 3, visible = F)),
                               #scroller=T,
                               #remove search bar on top right
                               searching = FALSE,
                               processing=FALSE,
                               scrollx=1000,
                               pageLength = 22,
                               #scrollY=1000,
                               rowReorder=T,
                               colReorder = TRUE,
                               paging=T,
                               dom = 'Bfrtip',
                               autoWidth=F)) %>%
    formatStyle(
      "Threshold Passed?",
      target="row",
      backgroundColor = styleEqual(c(0,1), c('red','white'))
    )
})



output$Iowa_View_DT <- DT::renderDataTable(server=FALSE,{
  DT::datatable(Iowa_View_r(),
                extensions = c('FixedColumns','KeyTable','Scroller'), #removed 'ColReorder', 'RowReorder'
                options = list(keys=TRUE,
                               columnDefs= list(list(targets = 3, visible = F)),
                               #scroller=T,
                               #remove search bar on top right
                               searching = FALSE,
                               processing=FALSE,
                               scrollx=1000,
                               pageLength = 22,
                               #scrollY=1000,
                               rowReorder=T,
                               colReorder = TRUE,
                               paging=T,
                               dom = 'Bfrtip',
                               autoWidth=F)) %>%
    formatStyle(
      "Threshold Passed?",
      target="row",
      backgroundColor = styleEqual(c(0,1), c('red','white'))
    )
})


output$Wisconsin_View_DT <- DT::renderDataTable(server=FALSE,{
  DT::datatable(Wisconsin_View_r(),
                extensions = c('FixedColumns','KeyTable','Scroller'), #removed 'ColReorder', 'RowReorder'
                options = list(keys=TRUE,
                               columnDefs= list(list(targets = 3, visible = F)),
                               #scroller=T,
                               #remove search bar on top right
                               searching = FALSE,
                               scrollx=1000,
                               processing=FALSE,
                               pageLength = 22,
                               #scrollY=1000,
                               rowReorder=T,
                               colReorder = TRUE,
                               paging=T,
                               dom = 'Bfrtip',
                               autoWidth=F)) %>%
    formatStyle(
      "Threshold Passed?",
      target="row",
      backgroundColor = styleEqual(c(0,1), c('red','white'))
    )
})


output$NW_View_DT <- DT::renderDataTable(server=FALSE,{
  DT::datatable(NW_View_r(),
                extensions = c('FixedColumns','KeyTable','Scroller'), #removed 'ColReorder', 'RowReorder'
                options = list(keys=TRUE,
                               columnDefs= list(list(targets = 3, visible = F)),
                               #remove search bar on top right
                               searching = FALSE,
                               #scroller=T,
                               scrollx=1000,
                               processing=FALSE,
                               pageLength = 22,
                               #scrollY=1000,
                               rowReorder=T,
                               colReorder = TRUE,
                               paging=T,
                               dom = 'Bfrtip',
                               autoWidth=F)) %>%
    formatStyle(
      "Threshold Passed?",
      target="row",
      backgroundColor = styleEqual(c(0,1), c('red','white'))
    )
})


##
output$TMO_OB_View_DT <- DT::renderDataTable(server=FALSE,{
  DT::datatable(TMO_OB_View_r(),
                extensions = c('FixedColumns','KeyTable','Scroller'), #removed 'ColReorder', 'RowReorder'
                options = list(keys=TRUE,
                               columnDefs= list(list(targets = 3, visible = F)),
                               #scroller=T,
                               #remove search bar on top right
                               searching = FALSE,
                               processing=FALSE,
                               scrollx=1000,
                               pageLength = 22,
                               #scrollY=1000,
                               rowReorder=T,
                               colReorder = TRUE,
                               paging=T,
                               dom = 'Bfrtip',
                               autoWidth=F)) %>%
    formatStyle(
      "Threshold Passed?",
      target="row",
      backgroundColor = styleEqual(c(0,1), c('red','white'))
    )
})

output$TMO_IB_View_DT <- DT::renderDataTable(server=FALSE,{
  DT::datatable(TMO_IB_View_r(),
                extensions = c('FixedColumns','KeyTable','Scroller'), #removed 'ColReorder', 'RowReorder'
                options = list(keys=TRUE,
                               columnDefs= list(list(targets = 3, visible = F)),
                               #scroller=T,
                               #remove search bar on top right
                               searching = FALSE,
                               processing=FALSE,
                               scrollx=1000,
                               pageLength = 21,
                               #scrollY=1000,
                               rowReorder=T,
                               colReorder = TRUE,
                               paging=T,
                               dom = 'Bfrtip',
                               autoWidth=F)) %>%
    formatStyle(
      "Threshold Passed?",
      target="row",
      backgroundColor = styleEqual(c(0,1), c('red','white'))
    )
})

