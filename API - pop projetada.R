# Pacotes
library(httr)
library(jsonlite)
library(tidyverse)
library(dplyr)

# https://apisidra.ibge.gov.br/home/ajuda


# Faz a requisição
# Busca todos os municípios
url <- 'https://apisidra.ibge.gov.br/values/t/9606/n6/all/n1/all'
res <- GET(url)
municipios <- fromJSON(content(res, "text", encoding = "UTF-8")) |> filter(str_detect(D1C, '[0-9]{7}')) |>  pull(D1C)




# LOOP POR MUNICÍPIO

consulta_api <- function(mun){

url <- paste0('https://apisidra.ibge.gov.br/values/t/9606/n6/', mun,'/v/allxp/p/last%201/c86/allxt/c2/allxt/c287/allxt')
res <- GET(url)
dados <- fromJSON(content(res, "text", encoding = "UTF-8")) |> 
  select(5,6,7,13,15,17)

# Usa a primeira linha como nomes das colunas
names(dados) <- c('populacao','CODMUNRES', 'nome_mun', 'raca_cor', 'genero', 'idade')

# Remove a primeira linha (que agora são os cabeçalhos)
dados <- dados[-1, ]
# Reseta os índices das linhas
rownames(dados) <- NULL

return(dados)

}


for(i in 1:length(municipios)){
  if(i == 1){
    
    info_censo <- consulta_api(municipios[i])
    print(municipios[i])
    next
    
  }
  
  info_censo <- bind_rows(info_censo, consulta_api(municipios[i]))
  print(municipios[i])
  
}


info_censo |> 
  mutate(idade = case_when(idade == 'Menos de 1 ano' ~ '0',
                           T ~ idade)) |> 
  mutate(idade = as.numeric(gsub('\\sano|\\sanos', '', idade)),
         idade = as.numeric(idade),
         populacao = as.numeric(populacao)) |> 
  filter(!is.na(idade),
         !is.na(populacao)) |> 
  pull(populacao) |> sum()



save(info_censo, file = paste0('c:/dev/painel/r/ibge/info_censo.rda'))

