##############################
setwd("/home/jmoy001/Rds/")
###############################

observe({
  if (USER$Logged == TRUE) {
    output$MoySave1 <- renderUI({
      #prevously actionButton
      actionButton(inputId="Save","Save Table")
    })
    #Refers to shiny js messages in UI. Hidden until observeEvent is triggered (click on save button).
    shinyjs::hide("save_msg")
    shinyjs::hide("save comments")
    #show once logged in
    shinyjs::show("output_table")
    ####observe event is used when an action happens with regards to a button. if that button is press then the code is executed
    observeEvent(input$Save,{
      #outputsaved to df_output
      ##Total_Experience_DT in App.r file
      df_output <-hot_to_r(input$Total_Experience_DT)
      #save output to RDS
      saveRDS(df_output, file="Rhandson_postcomments.rds")
      
      #For whoever logged in and changed the comments, save the information for Daily View
      #Has to be done here since we wouldnt know who did it if we have no login information
      Username <- readRDS(file="login_name.rds")
      final_message <- paste(Username, "made an update on", format(Sys.time(), format='%B %d %Y %H:%M:%S %Z', tz="America/Chicago"))
      saveRDS(final_message, file="comment_submission.rds")
      #save rds
      #Refers to shiny js messages in UI. Show now that it is triggered
      #hide once saved
      shinyjs::show("save_msg")
      #hide output so no more changes can be done
      shinyjs::hide("output_table")
      #hides save button
      shinyjs::hide("Save")
      #show download button
      shinyjs::show("downloadbutton")
      #should occur when download button is clicked on
      output$testbutton <- downloadHandler(
        filename= function() {
          paste("Comments_dataset","-",as.character(Sys.Date()-1),".","csv",sep="")
        },
        content = function(file) {
          write.csv(hot_to_r(input$Total_Experience_DT), file, row.names=F)
         #dev.off()
       })
      
    })
    
  }})


