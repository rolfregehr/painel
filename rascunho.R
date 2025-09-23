library(tidyverse)
load("./r/dic/sim_dic.rda")
proporcao_masc__total <- sim_dic |>
  group_by(genero) |>
  reframe(n = n()) |>
  pivot_wider(names_from = genero, values_from = n, values_fill = 0) |>
  select(-Outro) |> 
  mutate(prop = Masc/(Masc+Fem)) |> 
  pull(prop)
