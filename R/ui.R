ui <- fluidPage(
  titlePanel("CSV converter by JVM"),
  includeCSS(css_btn_area),
  
  fluidRow(
    column(
      12,
      fileInputArea(
        "input_files",
        label = "Drop your .csv text files here!",
        buttonLabel = "Only .csv files, max 100 MB each.",
        multiple = TRUE,
        accept = "text/plain"
      )
    ),
    column(12,
           radioButtons(inputId = "details", 
                        label = "Convert how?", 
                        choices = c("Auto", "EU->US", "US->EU"), 
                        inline = TRUE),
           actionButton(inputId = "btn_check",
                        label = "Check",
                        icon = icon("magnifying-glass")),
           actionButton(inputId = "btn_convert",
                        label = "Convert",
                        icon = icon("microchip"))
    ),
    column(12,
           tags$br(),
           textAreaInput(inputId = "text_log",
                         label = "Output",
                         rows = 6)
    ),
    column(12,
           downloadButton(outputId = "download",
                          label = "Download",
                          icon = icon("download"))
    )
  )
)