import pandas as pd
import os

# 1️⃣ Carregar CSVs
df_agencia = pd.read_csv('d_agencia.csv')
df_canal = pd.read_csv('d_canal.csv')
df_data = pd.read_csv('d_data.csv')
df_hospede = pd.read_csv('d_hospede.csv')
df_hotel = pd.read_csv('d_hotel.csv')
df_motivo_cancelamento = pd.read_csv('d_motivo_cancelamento.csv')
df_plano_tarifario = pd.read_csv('d_plano_tarifario.csv')
df_tipo_quarto = pd.read_csv('d_tipo_quarto.csv')
df_diarias = pd.read_csv('f_diarias.csv')
df_inventario_diario = pd.read_csv('f_inventario_diario.csv')
df_pagamentos = pd.read_csv('f_pagamentos.csv')
df_reservas = pd.read_csv('f_reservas.csv')
df_reviews = pd.read_csv('f_reviews.csv')

# 2️⃣ Tratamento de duplicatas em df_reservas
print(f"Linhas duplicadas completas antes: {df_reservas.duplicated().sum()}")
df_reservas = df_reservas.drop_duplicates()  # Remove duplicatas completas

print(f"Duplicatas por reserva_id antes: {df_reservas.duplicated(subset=['reserva_id']).sum()}")
df_reservas = df_reservas.drop_duplicates(subset=['reserva_id'])  # Remove duplicatas por ID
print("Duplicatas removidas em df_reservas!")

# 3️⃣ Criar pasta para CSVs tratados
os.makedirs('tratados', exist_ok=True)

# 4️⃣ Dicionário de DataFrames
dfs = {
    'd_agencia': df_agencia,
    'd_canal': df_canal,
    'd_data': df_data,
    'd_hospede': df_hospede,
    'd_hotel': df_hotel,
    'd_motivo_cancelamento': df_motivo_cancelamento,
    'd_plano_tarifario': df_plano_tarifario,
    'd_tipo_quarto': df_tipo_quarto,
    'f_diarias': df_diarias,
    'f_inventario_diario': df_inventario_diario,
    'f_pagamentos': df_pagamentos,
    'f_reservas': df_reservas,
    'f_reviews': df_reviews
}

# 5️⃣ Salvar todos os CSVs tratados
for nome, df in dfs.items():
    caminho = f'tratados/{nome}_tratado.csv'
    df.to_csv(caminho, index=False)
    print(f"{caminho} salvo com sucesso!")

print("✅ Todos os arquivos tratados foram salvos na pasta 'tratados'.")


