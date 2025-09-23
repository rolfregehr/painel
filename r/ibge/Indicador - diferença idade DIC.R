load("C:/dev/painel/r/dic/sim_dic.rda")
load("C:/dev/painel/r/ibge/censo_2022.rda")



estados = unique(str_sub(sim_dic$CODMUNRES, 1, 2))


dados_uf = tibble(uf = character(),
                  diferenca = numeric())


for(estado in estados){
  dif = sim_dic |> 
    filter(data_obito >= as.Date('2015-01-01') & data_obito < as.Date('2024-01-01')) |> 
    mutate(uf = str_sub(CODMUNRES, 1, 2)) |> 
    group_by(uf, genero, idade) |> 
    reframe(mortes = n()) |> 
    filter(uf == estado,
           genero == 'Masc') |> 
    arrange(-mortes) |> 
    slice(1) |>
    pull(idade)-sim_dic |> 
    filter(data_obito >= as.Date('2015-01-01') & data_obito < as.Date('2024-01-01')) |> 
    mutate(uf = str_sub(CODMUNRES, 1, 2)) |> 
    group_by(uf, genero, idade) |> 
    reframe(mortes = n()) |> 
    filter(uf == estado,
           genero == 'Fem') |> 
    arrange(-mortes) |> 
    slice(1) |>
    pull(idade)
  
  dados_uf = bind_rows(dados_uf, tibble(uf = estado, diferenca = dif))
  print(estado)
}


dados_uf |> 
  arrange(diferenca) |> 
  print(n=Inf) |> 
  left_join(info_censo |> 
              mutate(cod_uf = str_sub(CODMUNRES, 1, 2),
                     sigla_uf = str_extract(nome_mun, '\\([A-Z]{2}\\)') |>  str_remove_all("[()]")) |>
              distinct(cod_uf, sigla_uf),
            by = c('uf' = 'cod_uf')) |> 
  select(sigla_uf, diferenca) |> 
  print(n=Inf)





municipios = unique(str_sub(sim_dic$CODMUNRES, 1, 6))


dados_mun = tibble(municipio = character(),
                   diferenca = numeric())

cont=1
for(municipio in municipios){
  dif <- sim_dic |> 
    filter(data_obito >= as.Date('2015-01-01') & data_obito < as.Date('2024-01-01'),
           str_sub(CODMUNRES, 1, 6) == municipio) |> 
    mutate(municipio = str_sub(CODMUNRES, 1, 6)) |> 
    group_by(municipio, genero, idade) |> 
    reframe(mortes = n()) |> 
    filter(municipio == municipio,
           genero == 'Masc') |> 
    arrange(-mortes, -idade) |> 
    slice(1) |>
    pull(idade)-sim_dic |> 
    filter(data_obito >= as.Date('2015-01-01') & data_obito < as.Date('2024-01-01'),
           str_sub(CODMUNRES, 1, 6) == municipio) |> 
    mutate(municipio = str_sub(CODMUNRES, 1, 6)) |> 
    group_by(municipio, genero, idade) |> 
    reframe(mortes = n()) |> 
    filter(municipio == municipio,
           genero == 'Fem') |> 
    arrange(-mortes, -idade) |> 
    slice(1) |>
    pull(idade)
  
  dados_mun = bind_rows(dados_mun, tibble(municipio = municipio, diferenca = dif))
  print(paste(cont, '-',municipio, '-',dif))
  cont = cont+1
}


dados |> 
  arrange(diferenca) |> 
  print(n=Inf) |> 
  left_join(info_censo |> 
              mutate(cod_uf = str_sub(CODMUNRES, 1, 2),
                     sigla_uf = str_extract(nome_mun, '\\([A-Z]{2}\\)') |>  str_remove_all("[()]")) |>
              distinct(cod_uf, sigla_uf),
            by = c('uf' = 'cod_uf')) |> 
  select(sigla_uf, diferenca) |> 
  print(n=Inf)

