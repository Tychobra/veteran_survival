fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "styles.css")
  ),
  fluidRow(
    column(
      12,
      div(
        style = "display: inline",
      h1("Veteran Survival Analysis"),
      h3(
        class = "text-center",
        textOutput("formula_string_out")
      )),
      br()
    )
  ),
  fluidRow(
    div(
      class = "col-lg-2 col-sm-3",
      br(),
      wellPanel(
        br(),
        shinyWidgets::pickerInput(
          inputId = "predictor_var",
          label = "Strata",
          choices = predictor_var_choices,
          options = list(`actions-box` = TRUE),
          multiple = TRUE,
          selected = predictor_var_choices[1:2],
          width = "100%"
        ),
        br(),
        downloadButton(
          "download_data",
          "Veteran Data",
          icon = icon("download"),
          class = "full_width"
        ),
        br()
      )
    ),
    div(
      class = "col-lg-10 col-sm-9",
      tabsetPanel(
        tabPanel(
          title = "Chart",
          br(),
          br(),
          fluidRow(
            column(
              11,
              plotOutput(
                "predictor_chart_out",
                height = "600px"
              ) %>% shinycssloaders::withSpinner()
            ),
            column(
              1,
              dropdownButton(
                circle = FALSE,
                status = "white_background",
                size = "lg",
                icon = icon("gear"),
                width = "300px",
                right = TRUE,
                tooltip = tooltipOptions(
                  placement = "bottom",
                  title = "Chart Options",
                  html = FALSE
                ),
                div(
                  class = "text-center",
                  tags$h3("Chart Options"),
                  br(),
                  radioButtons(
                    "show_cl",
                    "Show Confidence Interval",
                    choices = c(
                      "Yes",
                      "No"
                    ),
                    selected = "No",
                    inline = TRUE
                  ),
                  br(),
                  downloadButton(
                    "download_chart",
                    "Download Chart",
                    class = "full_width"
                  ),
                  br(),
                  br()
                )
              )
            )
          )
        ),
        tabPanel(
          title = "Table",
          br(),
          br(),
          DTOutput("fit_table_out")
        ),
        tabPanel(
          title = "Analysis Detail",
          br(),
          br(),
          column(1),
          column(
            10,
            h3(
              style = "line-height: 1.5;",
              paste0(
                "This is a simple survival analysis using of the 'verteran' data set available with the survival package.  ",
                "Several of the predictor varibales in verteran are discretized before being used in the model fit.  You ",
                "can see how the discretization is perfomed in 'Global.R' ().  Some exploratory data analysis is available ",
                "in 'data_prep/data-analysis.R'.  Better detail and more info would be provided for any actual analysis.  I ",
                "often include .Rmd reports in Shiny apps which can be downloaded to html or pdf..."
              )
            )
          )
        )
      )
    )
  )
)