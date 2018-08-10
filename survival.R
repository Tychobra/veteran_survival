# script for playing with survival package and the
# veteran dataset provided with the survival package
library(survival)

veteran <- veteran

veteran$trt <- factor(veteran$trt)
result <- coxph(Surv(time, status) ~ trt + celltype, data=veteran)

result
