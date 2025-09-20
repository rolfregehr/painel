pacman::p_load(tidyverse)


# Atualiza os dados do SIM
sim <- readRDS("C:/dev/nossasaudeemdados/gera_dados/rds/sim_20250917.rds")
pasta <- dirname(rstudioapi::getSourceEditorContext()$path)


sim_dic <- sim |> #                                              [sample(1:nrow(sim), 100000),]
  filter(str_sub(CAUSABAS, 1, 3) %in% c(paste0("I", 20:25))) |> 
  mutate(cid_3d = str_sub(CAUSABAS, 1, 3),
         genero = case_when(SEXO == '1' ~ "Masc",
                            SEXO == '2' ~ "Fem",
                            T ~ "Outro"),
         data_obito = dmy(DTOBITO),
         idade =  ceiling(interval(dmy(DTNASC), data_obito) / years(1)),
         raca_cor = case_when(RACACOR == "1" ~ "Branca",
                              RACACOR == '2' ~ 'Preta',
                              RACACOR == '3' ~ 'Amarela',
                              RACACOR == '4' ~ 'Parda',
                              RACACOR == '5' ~ 'Indígena',
                              T ~ "SI"),
         local_ocorrencia = case_when(LOCOCOR == "1" ~ "Hospital",
                                      LOCOCOR == '2' ~ 'Outrod estab. Saúde',
                                      LOCOCOR == '3' ~ 'Domicílio',
                                      LOCOCOR == '4' ~ 'Via pública',
                                      LOCOCOR == '5' ~ 'Outros',
                                      LOCOCOR == '6' ~ 'Aldeia indígena',
                                      LOCOCOR == '9' ~ 'SI',
                                      T ~ "SI")) |> 
  select(cid_3d, genero, data_obito, idade, raca_cor, local_ocorrencia, CODMUNRES, CIRCOBITO, ACIDTRAB) 


  save(sim_dic, file = paste0(pasta, '/sim_dic.rda'))



