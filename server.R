
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    output$output_origin <- renderReactable({
        
        origin_split <- input$input_origin %>% 
            str_split("\n") %>% 
            unlist() %>% 
            str_squish() %>% 
            str_trim()
        input_split <- input$insert_text %>%
            str_split("\n") %>% 
            unlist() %>% 
            str_squish() %>% 
            str_trim()
        
        correct <- origin_split[origin_split %in% input_split]
        
        df_table <- data.frame(code = origin_split)
        
        df_table %>% 
            reactable(defaultPageSize = 100, borderless = T, height = 400,
                      style = list(background = "#44505A"),
                      columns = list(
                          code = colDef(
                              style = function(value){
                                  back_color <- ifelse(value %in% correct, "#44505A", "firebrick")
                                  color <- ifelse(value %in% correct, "#AEC5BE", "white")
                                  list(background = back_color, 
                                       color = color,
                                       fontSize = "14px")
                              }
                              
                          )
                      )
            )
        
    }
    )
    
    output$diff_text <- renderReactable({
        
        origin_split <- input$input_origin %>% 
            str_split("\n") %>% 
            unlist() %>% 
            str_squish() %>% 
            str_trim()
        input_split <- input$insert_text %>%
            str_split("\n") %>% 
            unlist() %>% 
            str_squish() %>% 
            str_trim()
        
        correct <- origin_split[origin_split %in% input_split]
        
        df_table <- data.frame(code = input_split)
        
        df_table %>% 
            reactable(defaultPageSize = 100, borderless = T, height = 400,
                      style = list(background = "#44505A"), 
                      columns = list(
                          code = colDef(
                              style = function(value){
                                  back_color <- ifelse(value %in% correct, "#44505A", "firebrick")
                                  color <- ifelse(value %in% correct, "#AEC5BE", "white")
                                  list(background = back_color, 
                                       color = color,
                                       fontSize = "14px")
                              }
                    
                )
            )
            )
        
    }
    )

    output$description <- renderText({
        
        if (input$role == "Student") {
            desc_student
        } else {
            desc_instructor
        }
        
    })
    
    observeEvent(input$submit,{
        
        if (input$role == "Student" & input$code_instructor %in% df_code) {
            
            df_new <- read_sheet(url)
            text_instructor <- df_new %>% 
                filter(instructor_code == input$code_instructor) %>% 
                pull(text)
            
            updateTextAreaInput(session, inputId = "input_origin", label = NULL,
                                value = text_instructor)
            
            sendSweetAlert(session, title = "Success", 
                           text = "Go to the Compare Code Tab", 
                           type = "success")
            
            df <- read_sheet(url)
            
            updateTabItems(session, "menu", "compare")
            
            observe({
                
                invalidateLater(10*1e3)
                df_new <- read_sheet(url)
                text_instructor <- df_new %>% 
                    filter(instructor_code == input$code_instructor) %>% 
                    pull(text)
                
                updateTextAreaInput(session, inputId = "input_origin", label = NULL,
                                    value = text_instructor)
            })
            
        } else if (input$role == "Instructor") {
            df %>% 
                filter(instructor_code != input$code_instructor) %>% 
            bind_rows(
                data.frame(instructor_code = input$code_instructor,
                           text = input$input_origin
                ) 
            ) %>% 
                write_sheet(url, sheet = "base")
            
            sendSweetAlert(session, title = "Success", 
                           text = "Now your text will be shared to student", 
                           type = "success")
            
            updateTabItems(session, "menu", "compare")
            
            observe({

                invalidateLater(10*1e3)
                df %>%
                    filter(instructor_code != input$code_instructor) %>%
                    bind_rows(
                        data.frame(instructor_code = input$code_instructor,
                                   text = input$input_origin
                        )
                    ) %>%
                    write_sheet(url, sheet = "base")
            })

        } else {
            
            sendSweetAlert(session, title = "Instructor Not Found", 
                           text = "Check the instructor code again", 
                           type = "error")
        }
        
    })
    
})
