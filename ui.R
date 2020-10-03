# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(

        dashboardHeader(title = "Code Highlight"),
    
        
        dashboardSidebar(collapsed = T,
            
            sidebarMenu(id = "menu",
                
                menuItem(tabName = "admin", text = "Set Your Role"),
                menuItem(tabName = "compare", text = "Compare Code")
                
            )
            
        )    ,
        
        dashboardBody(
            
            shinyDashboardThemes("grey_dark"),
            
            tabItems(
                
                # Set as Admin ------------------------
                tabItem(tabName = "admin", align = "center",
                        
                        h2("Set Your Role"),
                        h4("Set yourself either as student or as instructor"),
                        fluidRow(
                            
                            column(width = 6,
                                   selectInput("role", label = "Are you Student or Instructor?", 
                                               choices = c("Student", "Instructor"), selected = "Student")
                            ),
                            column(width = 6,
                                   textInput("code_instructor", label = "Enter Instructor Code", 
                                             value = "practice")
                            )
                        ),
                        
                        actionButton("submit", label = "Submit"),
                        
                        fluidRow( align = "justify",
                                  
                                  column(width = 5,
                                         textOutput("description")
                                  )
                                  
                        )
                        
                ),
                
                # Main Content -------------------
                
                tabItem(tabName = "compare",
                        
                        fluidRow(align = "center",
                            
                            box(width = 6, title = "Instructor's Text", 
                                background = "red",
                                textAreaInput(inputId = "input_origin", label = NULL, height = "300px", 
                                              value = init_origin)
                            ),
                            
                            box(width = 6, title = "Your Text", 
                                background = "light-blue",
                                textAreaInput(inputId = "insert_text", height = "300px", 
                                              label = NULL, value = init_input)
                            )
                        ),    
                        fluidRow( align = "center",
                            h2("Comparison Result"),
                            
                            box(width = 6, title = "Instructor's Text", 
                                background = "red",
                                reactableOutput("output_origin")
                            ),
                            
                            box(width = 6, title = "Your Text",
                                background = "light-blue",
                                reactableOutput("diff_text")
                            )
                            
                        )    
                        
                        )
                
               
                
            )
        )
        
    )


)
