#Importando bibliotecas
import pandas as pd
import numpy as np
import matplotlib as plt


#Importando tabelas Dimensão
df_agencia = pd.read_csv('d_agencia.csv')
df_canal = pd.read_csv('d_canal.csv')
df_data = pd.read_csv('d_data.csv')
df_hospede = pd.read_csv('d_hospede.csv')
df_hotel = pd.read_csv('d_hotel.csv')
df_cancelamento = pd.read_csv('d_motivo_cancelamento.csv')
df_plano = pd.read_csv('d_plano_tarifario.csv')
df_quarto = pd.read_csv('d_tipo_quarto.csv')


#Importando tabelas Fato
df_diarias = pd.read_csv('f_diarias.csv')
df_inventario = pd.read_csv('f_inventario_diario.csv')
df_pagamentos = pd.read_csv('f_pagamentos.csv')
df_reservas = pd.read_csv('f_reservas.csv')
df_reviews = pd.read_csv('f_reviews.csv')


#Achando diárias com receita negativa
df_diarias_negativas = df_diarias.loc[df_diarias['receita_diarias'] < 0]


#Transformando valores negativos em positivos
coluna = 'receita_diarias'
df_diarias[coluna] = np.where(df_diarias[coluna] < 0, df_diarias[coluna] * -1, df_diarias[coluna])


#Cálculo das medidas estatísticas do ADR
array_adr = np.array(df_diarias['adr_estimado'])
media = np.mean(array_adr)
mediana = np.median(array_adr)
q1 = np.quantile(array_adr, 0.25)
q2 = np.quantile(array_adr, 0.50)
q3 = np.quantile(array_adr, 0.75)
distancia = (media-mediana)/ mediana


#Cálculo dos limites para detecção de outliers
iqr = q3 - q1
limite_superior = q3 + 1.5 * iqr
limite_inferior = q1 - 1.5 * iqr


#Resultados
print(f'A média de adr é {media}')
print(f'A mediana é {mediana}')
print(f'Primeiro quartil (Q1): {q1}')
print(f'Segundo quartil (Q2, Mediana): {q2}')
print(f'Terceiro quartil (Q3): {q3}')
print(f'a distancia entre a média e a mediana é: {distancia}')
print(f'o valor do limite superior é: {limite_superior}')
print(f'o valor do limite inferior é: {limite_inferior}')


#Identificação de outliers
outliers_adr = df_diarias.loc[df_diarias['adr_estimado'] > limite_superior]


#Exportando Outliers para CSV
outliers_adr.to_csv("Outliers_Adr.csv", sep=';', index=False)

#Criando CSV sem outliers
inliers_adr = df_diarias.loc[df_diarias['adr_estimado'] < limite_superior]
inliers_adr.to_csv("Diaria_s_Outliers.csv", sep=';', index=False)


#Copiando a tabela de diárias para análise de overbooking
df_overbooking = df_diarias.copy()
#Adicionando a coluna de quartos disponíveis
df_overbooking['quartos_disponiveis']= df_inventario['quartos_disponiveis'].astype(int)
#Criando a coluna de overbooking(quartos disponíveis - quartos vendidos)
df_overbooking['overbooking'] = df_overbooking['quartos_disponiveis'] - df_overbooking['quartos_vendidos']
#Achando os casos de overbooking
df_overbooking = df_overbooking.loc[df_overbooking['overbooking'] < 0]
#Criando CSV de overbooking
df_overbooking.to_csv("Overbooking.csv", sep=';', index=False)


#Achando reservas duplicadas
df_reservas.duplicated()

#Removendo reservas duplicadas
df_reservas.drop_duplicates(inplace=True)
df_reservas

#Atualizando o CSV de Reservas
df_reservas.to_csv('Rerserva_Atualizada.csv', sep = ';', index = False)

#Criando CSV com duplicatas
df_duplicatas = df_reservas[df_reservas.duplicated(keep=False)]
df_duplicatas.to_csv('Rerserva_Duplicatas.csv', sep = ';', index = False)

#Transformando notas acima do máximo para o máximo
df_review['nota']= df_review['nota'].astype(str)
df_review['nota'] = df_review['nota'].str.replace('11.0', '10.0').astype(float)

#Atualizando o CSV de Reviews
df_review.to_csv('Review_Atualizado.csv', sep = ';', index = False)

#Criando colunas RevPAR e Ocupação com apenas 2 casas decimais
df_revpar['revpar'] = (df_revpar['receita_diarias'] / df_revpar['quartos_disponiveis']).round(2)
df_revpar['ocupacao'] = (df_revpar['quartos_vendidos'] / df_revpar['quartos_disponiveis']*100).round(2)

#Cálculo das medidas estatísticas de RevPAR
array_revpar = np.array(df_revpar['revpar'])
media_revpar = np.mean(array_revpar)
mediana_revpar = np.median(array_revpar)
q1_revpar = np.quantile(array_revpar, 0.25)
q2_revpar = np.quantile(array_revpar, 0.50)
q3_revpar = np.quantile(array_revpar, 0.75)
distancia_revpar = (media_revpar-mediana_revpar)/ mediana_revpar

#Cálculo dos limites para detecção de outliers
iqr_revpar = q3_revpar - q1_revpar
limite_superior_revpar = q3_revpar + 1.5 * iqr_revpar
limite_inferior_revpar = q1_revpar - 1.5 * iqr_revpar

#Resultados
print(f'A média de RevPar é {media_revpar}')
print(f'A mediana de RevPar é {mediana_revpar}')
print(f'Primeiro quartil de RevPar(Q1): {q1_revpar}')
print(f'Segundo quartil de RevPar(Q2, Mediana): {q2_revpar}')
print(f'Terceiro quartil de RevPar(Q3): {q3_revpar}')
print(f'a distancia entre a média e a mediana de RevPar é: {distancia_revpar}')
print(f'o valor do limite superior de RevPar é: {limite_superior_revpar}')
print(f'o valor do limite inferior de RevPar é: {limite_inferior_revpar}')
