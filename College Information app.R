
# Load required libraries
library(shiny)
library(tidyverse)
library(gridExtra)

# Read in data just once
collegedata <- read_csv("MERGED2015_16_PP.csv", na = c(" ", "NA", "NULL", "PrivacySuppressed"))

# Define the modified plot_college function
plot_college <- function(collegedata, INST, v = c("admission rate", "retention rate", "completion rate", "average salary"), match_control = TRUE, match_IC = TRUE) {

  require(tidyverse)
  require(gridExtra)

  v <- str_to_lower(v)  # this converts the case of intentval to title case (capitalized first letter and the rest lowercase).

  # Extract the row with data for the target institution:
  INST_DAT <- filter(collegedata, INSTNM == INST)

  # Check where institution names and plotting variables are valid:
  if (nrow(INST_DAT) == 0) return("error:institution unknown")
  if (sum(!v %in% c("admission rate", "retention rate", "completion rate", "average salary")) > 0) return("error: unknown variable")

  # Filter for CONTROL and ICLEVEL if these flags are set to TRUE
  if (match_control) collegedata <- filter(collegedata, CONTROL == INST_DAT$CONTROL)
  if (match_IC) collegedata <- filter(collegedata, ICLEVEL == INST_DAT$ICLEVEL)

  # I will make all of the possible plots and save them to objects.
  # Below, I choose which ones to plot based on the value of v
  padm1 <- ggplot(data = collegedata, aes(ADM_RATE)) +
    geom_histogram(color = "red", fill = "orange")

  yval <- median(ggplot_build(padm1)$data[[1]]$count)

  # browser()
  padm <- ggplot(data = collegedata, aes(ADM_RATE)) +
    geom_histogram(color = "red", fill = "orange") +
    xlab("admission rate") + ylab("Frequency")+
    geom_vline(xintercept = INST_DAT$ADM_RATE) +
    annotate("text", label = INST, x = 0.99 * INST_DAT$ADM_RATE, y = yval, angle = 90, color = "black") +
    ggtitle("Admission rate")

  pret4 <- ggplot(data = collegedata, aes(RET_FT4)) +
    geom_histogram(color = "red", fill = "orange") +
    xlab("retention rate") +  ylab("Frequency") +
    geom_vline(xintercept = INST_DAT$RET_FT4) +
    annotate("text", label = INST, x = 0.99 * INST_DAT$RET_FT4, y = yval, angle = 90, color = "black") +
    ggtitle("Retention rate for full-time four-year institutions")

  pretL4 <- ggplot(data = collegedata, aes(RET_FTL4)) +
    geom_histogram(color = "red", fill = "orange") +
    xlab("retention rate") + ylab("Frequency") +
    geom_vline(xintercept = INST_DAT$RET_FTL4) +
    annotate("text", label = INST, x = 0.99 * INST_DAT$RET_FTL4, y = yval, angle = 90, color = "black") +
    ggtitle("Retention rate for full-time less than four-year institutions")

  pasal <- ggplot(data = collegedata, aes(AVGFACSAL)) +
    geom_histogram(color = "red", fill = "orange") +
    xlab("average salary") +  ylab("Frequency") +
    geom_vline(xintercept = INST_DAT$AVGFACSAL) +
    annotate("text", label = INST, x = 0.99 * INST_DAT$AVGFACSAL, y = yval, angle = 90, color = "black") +
    ggtitle("Average salary")

  pcomp4 <- ggplot(data = collegedata, aes(C200_4)) +
    geom_histogram(color = "red", fill = "orange") +
    xlab("completion rate") +   ylab("Frequency") +
    geom_vline(xintercept = INST_DAT$C200_4) +
    annotate("text", label = INST, x = 0.99 * INST_DAT$C200_4, y = yval, angle = 90, color = "black") +
    ggtitle("Completion rate among four-year institutions")

  pcompL4 <- ggplot(data = collegedata, aes(C200_L4)) +
    geom_histogram(color = "red", fill = "orange") +
    xlab("completion rate") +  ylab("Frequency") +
    geom_vline(xintercept = INST_DAT$C200_L4) +
    annotate("text", label = INST, x = 0.99 * INST_DAT$C200_L4, y = yval, angle = 90, color = "black") +
    ggtitle("Completion rate among less than four-year institutions")

  # Choose which completion rate plot to show based on the value of ICLEVEL
  if (INST_DAT$ICLEVEL == 1) pcomp <- pcomp4 else pcomp <- pcompL4
  # Choose which retention rate for full time plot to show based on the value of ICLEVEL
  if (INST_DAT$ICLEVEL == 1) pret <- pret4 else pret <- pretL4
  

  # Make a list vv of the plots to be displayed
  # Apply the switch function to each element of v.
  # The switch function is used to determine which plot goes with each element of v
  vv <- lapply(v, switch, "admission rate" = padm, "retention rate" = pret , "completion rate" = pcomp, "average salary" = pasal)

  # grid.arrange arranges the plots based on the length of vv
 grid.arrange(arrangeGrob(grobs=vv))
 }

# Define the UI function
ui <- fluidPage(
  # Application title
  titlePanel("College Information"),

  # Sidebar layout
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      selectizeInput(inputId = "college", label = "Institution:",
                     choices = unique(collegedata$INSTNM),
                     options = list(placeholder = 'Select an institution')),
      helpText("Enter the institution name. If you start typing it will autofill suggestions. If the line is missing in the plot, it means that this data was missing for the institution."),

      checkboxGroupInput(inputId = "variables", label = "Select the Variables to Plot:",
                         choices = c("Admission Rate", "Retention Rate", "Completion Rate", "Average Salary"),
                         selected = c("Admission Rate", "Retention Rate", "Completion Rate", "Average Salary")),  

      # Radio button for Match Control
      radioButtons(inputId = "matchControl", label = "Match Control:",
                   choices = c("Yes", "No"), selected = "Yes"),
      helpText("If Match Control is yes, then the data in the admission rate, retention rate, average salary and completion rate histograms are limited to institutions of the same control type (public, private not-for-profit, for-profit) as the target institution"),

      # Radio button for Match IC Level
      radioButtons(inputId = "matchIC", label = "Match IC Level:",
                   choices = c("Yes", "No"), selected = "Yes"),
      helpText("If Match IC Level is yes, then the data in the admission rate, retention rate, average salary and completion rate histograms are limited to institutions of the same level (four-year, two-year, less-than-two-year) as the target institution")
    ),

    # Main panel for displaying outputs
    mainPanel(
      plotOutput(outputId = "collegePlot", height = "800px")
    )
  )
)


server <- function(input, output) {
  # Reactive function to filter data based on the selected institution
  filteredData <- reactive({
    filter(collegedata, INSTNM == input$college)
  })
  
  # Reactive function to filter data based on the selected control type
  filteredDataControl <- reactive({
    if (input$matchControl == "Yes") {
      control_type <- filteredData()$CONTROL
      filter(collegedata, CONTROL == control_type)
    } else {
      collegedata
    }
  })
  
  # Reactive function to filter data based on the selected IC level
  filteredDataIC <- reactive({
    if (input$matchIC == "Yes") {
      ic_level <- filteredData()$ICLEVEL
      filter(filteredDataControl(), ICLEVEL == ic_level)
    } else {
      filteredDataControl()
    }
  })
  
  # Render the plot based on the inputs
  output$collegePlot <- renderPlot({
    # Get the selected variables
    selected_variables <- tolower(input$variables)
    
    # Apply both Match Control and Match IC Level filtering
    filteredDataICValue <- filteredDataIC()  # Call the reactive function to get the filtered data
    
    # Plot the college information
    plot_college(collegedata = filteredDataICValue, INST = input$college, v = selected_variables, match_control = input$matchControl == "Yes", match_IC = input$matchIC == "Yes")
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)





