# Data Analysis of 'survival' package's veteran dataset -------------------
# playing with dataset and functions to brainstorm ideas for app

# Packages ----------------------------------------------------------------
library(survival)
library(survminer)
library(dplyr)

# Load/Analyze/Adjust Data ------------------------------------------------
dat <- veteran

# Analyze Continuous Variables:
hist(dat$karno)
hist(dat$diagtime)
hist(dat$age)

karno_med <- median(dat$karno)

# Factorize:
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
    karno = factor(
      ifelse(
        karno >= karno_med,
        "good",
        "bad"
      )
    ),
    diagtime = factor(
      ifelse(
        diagtime >= 5,
        ">=5",
        "<5"
      )
    ),
    age = factor(
      ifelse(
        age >= median(age),
        "old",
        "young"
      )
    )
  )

str(dat)

# Fit survival model using Kaplan-Meier method:
surv_object <- Surv(time = dat$time, event = dat$status)

# Analyze each possible predictor variable separately:
# trt
fit1 <- survival::survfit(surv_object ~ trt, data = dat)
summary(fit1)
survminer::ggsurvplot(fit1, data = dat, pval = TRUE) # trt not significant

# celltype
fit2 <- survfit(surv_object ~ celltype, data = dat)
ggsurvplot(fit2, data = dat, pval = TRUE)

# prior
fit3 <- survfit(surv_object ~ prior, data = dat)
ggsurvplot(fit3, data = dat, pval = TRUE)


# cox proportional hazards model to include multiple covariates:
fit.coxph <- coxph(surv_object ~ trt + celltype + prior + karno + diagtime + age, data = dat)
fit.coxph

ggforest(fit.coxph, data = dat)


fit <- coxph(surv_object ~ celltype + karno, data = dat)
fit

fit <- survival::survfit(Surv(time, status) ~ trt + celltype, data = dat)
fit

hold_summary <- summary(fit)
cols <- lapply(c(8, 2:6, 9:11) , function(x) hold_summary[x])
tbl <- do.call(data.frame, cols)
