function(input, output, session) {

  formula_string <- reactive({
    req(input$predictor_var)
    pred <- input$predictor_var

    if (length(pred) == 1) {
      preds <- pred
    } else {
      preds <- paste0(pred, collapse = " + ")
    }

    paste0("Surv(time, status) ~ ", preds)
  })

  predictor_fit <- reactive({

    formula_object <- as.formula(formula_string())

    # fit survival
    fit <- survival::survfit(formula_object, data = dat)
    fit$call$formula <- formula_object

    fit
  })

  # download Veteran dataset
  output$download_data <- downloadHandler(
    filename = "veteran.csv",
    content = function(file) {
      write.csv(
        dat,
        file,
        row.names = FALSE
      )
    }
  )

  ### Chart tab ----------------------------


  output$formula_string_out <- renderText({
    formula_string()
  })

  predictor_chart <- reactive({
    survminer::ggsurvplot(
      predictor_fit(),
      data = veteran,
      risk.table = TRUE,
      pval = TRUE,
      conf.int = if (input$show_cl == "Yes") TRUE else FALSE,
      risk.table.y.text = FALSE,
      title = paste0("Survival Probability by ", paste0(input$predictor_var, collapse = " + "))
    )
  })

  output$predictor_chart_out <- renderPlot({
    predictor_chart()
  })

  output$download_chart <- downloadHandler(
    filename =  "veteran_chart.png",
    # content is a function with argument file. content writes the plot to the device
    content = function(file) {
      ggsave(file, print(predictor_chart()), height = 10, width = 16)
    }
  )

  ### Table tab --------------------

  fit_table_prep <- reactive({
    req(predictor_fit())
    fit <- predictor_fit()

    hold_summary <- summary(fit)
    cols <- lapply(c(8, 2:6, 9:11) , function(x) hold_summary[x])

    # return a data frame
    do.call(data.frame, cols)
  })

  output$fit_table_out <- renderDT({
    datatable(
      fit_table_prep(),
      rownames = FALSE,
      extensions = "Buttons",
      options = list(
        dom = "Bfltip",
        pageLength = 12,
        scrollX = TRUE,
        buttons = list(
          list(
            extend = "excel",
            text = "Download",
            title = "verteran_table"
          )
        )
      )
    ) %>%
      formatRound(
        6:9,
        digits = 3
      )
  }, server = FALSE)

}