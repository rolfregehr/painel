pasta <- dirname(rstudioapi::getSourceEditorContext()$path)
library(tidyverse)
load("C:/dev/painel/r/ibge/censo_2022.rda")

populacao = sum(censo_2022$populacao)

censo_2022$proporcao = censo_2022$populacao/populacao

save(censo_2022, file = 'c:/dev/painel/r/ibge/censo_2022.rda')
