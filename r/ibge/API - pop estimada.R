
pasta <- dirname(rstudioapi::getSourceEditorContext()$path)
# Pacotes
library(httr)
library(jsonlite)
library(tidyverse)
library(dplyr)

# https://apisidra.ibge.gov.br/home/ajuda


# Faz a requisição
url <- 'https://apisidra.ibge.gov.br/values/t/6579/p/2023/n6/all/C2/all'
res <- GET(url)
dados <- fromJSON(content(res, "text", encoding = "UTF-8"))

# Usa a primeira linha como nomes das colunas
names(dados) <- as.character(dados[1, ])

# Remove a primeira linha (que agora são os cabeçalhos)
dados <- dados[-1, ]

# Reseta os índices das linhas
rownames(dados) <- NULL


urls <- paste0('https://apisidra.ibge.gov.br/values/t/6579/p/', 2015:2025,'/n6/all')


for(url in urls){
  if(url == urls[1]){
    res <- GET(url)
    dados <- fromJSON(content(res, "text", encoding = "UTF-8"))
    # Usa a primeira linha como nomes das colunas
    names(dados) <- as.character(dados[1, ])
    # Remove a primeira linha (que agora são os cabeçalhos)
    dados <- dados[-1, ]
    # Reseta os índices das linhas
    rownames(dados) <- NULL
    
    print(url)
    next
    }
  
    res <- GET(url)
    temp <- fromJSON(content(res, "text", encoding = "UTF-8"))
    # Usa a primeira linha como nomes das colunas
    names(temp) <- as.character(temp[1, ])
    # Remove a primeira linha (que agora são os cabeçalhos)
    temp <- temp[-1, ]
    # Reseta os índices das linhas
    rownames(temp) <- NULL
    
    dados <- bind_rows(dados, temp)
    
    print(url)
}


populacao_estimada <- dados |> select(7, 8, 9, 5)

save(populacao_estimada, file = paste0(pasta, '/populacao_estimada.rda'))
