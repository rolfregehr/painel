# Use o CRAN oficial
options(repos = c(CRAN = "https://cloud.r-project.org"))

# (opcional) confirme
getOption("repos")

# Agora instale
install.packages("ojs")

# Teste
library(ojs)
