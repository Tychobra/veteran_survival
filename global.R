library(shiny)
library(survival)
library(dplyr)
library(DT)
library(highcharter)
library(survminer)
library(shinyWidgets)
library(shinycssloaders)

dat <- veteran

rownames(dat) <- NULL

dat <- dat %>%
  mutate(
    trt = factor(
      trt,
      levels = c("1", "2"),
      labels = c("standard", "test")
    ),
    prior = factor(
      prior,
      levels = c("0", "10"),
      labels = c("no", "yes")
    ),
    karno = factor(ifelse(karno >= median(karno), "good", "bad")),
    diagtime = factor(ifelse(diagtime >= 5, ">=5", "<5")),
    age = factor(ifelse(age >= median(age), "old", "young"))
  )

predictor_var_choices <- c(
  "trt",
  "celltype",
  "prior",
  "karno",
  "age"
)
