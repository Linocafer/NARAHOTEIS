-- ========================================= -- CRIAR BANCO DE DADOS -- =========================================
CREATE DATABASE Projeto;

USE Projeto;

SET GLOBAL local_infile = 1;
-- ========================================= -- DIMENSÕES -- ========================================= -- 
-- 1 - Canal

CREATE TABLE canal(
canal_id INT primary key,
canal_nome VARCHAR(100),
canal_grupo VARCHAR(100));

drop table canal;

LOAD DATA INFILE'C:/Users/marcelino.fernandes/Desktop/SQL/d_canal_tratado.csv'
INTO TABLE canal
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(canal_id,canal_nome,canal_grupo); # nome das colunas 

SELECT* FROM canal;

-- 2 - Data Hospedagem
CREATE TABLE d_data(
data_id INT primary key,
data_hospedagem date,
ano INT,
mes VARCHAR(100),
nome_mes INT,
trimestre INT,
dia_semana INT,
fim_de_semana_flag INT,
feriado_flag INT,
alta_temporada_flag INT);

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/d_data_tratado.csv'
INTO TABLE d_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(data_id,data_hospedagem,ano,mes,nome_mes,trimestre,dia_semana,fim_de_semana_flag,feriado_flag,alta_temporada_flag); # nome das colunas 

SELECT* FROM d_data;

-- 3 - Hóspede
CREATE TABLE hospede(
hospede_id INT primary key,
pais VARCHAR(100),
uf VARCHAR(100),
cidade VARCHAR(100),
faixa_etaria VARCHAR(100),
segmento VARCHAR(100));

DROP TABLE hospede;

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/d_hospede_tratado.csv'
INTO TABLE Hospede
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(hospede_id,pais,uf,cidade,faixa_etaria,segmento); # nome das colunas 

SELECT* FROM hospede;

-- 4️ - Hotel
CREATE TABLE hotel(
hotel_id INT primary key,
nome VARCHAR(100),
cidade VARCHAR(100),
uf VARCHAR(100),
categoria_estrelas INT,
possui_spa_flag INT);

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/d_hotel_tratado.csv'
INTO TABLE hotel
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(hotel_id,nome,cidade,uf,categoria_estrelas,possui_spa_flag); # nome das colunas 

SELECT* FROM hotel;

-- 5 -

DROP TABLE IF EXISTS f_inventario_diario;

CREATE TABLE f_inventario_diario (
    hotel_id INT,
    data_id INT,
    tipo_quarto VARCHAR(50),
    quartos_total INT,
    quartos_manutencao INT,
    quartos_disponiveis INT
);

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/f_inventario_diario_tratado.csv'
INTO TABLE f_inventario_diario
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(hotel_id, data_id, tipo_quarto, quartos_total, quartos_manutencao, quartos_disponiveis);

SELECT * FROM f_inventario_diario;


-- 6 - Motivo de cancelamento
CREATE TABLE motivos_cancelamento(
motivo_id INT primary key,
categoria VARCHAR(100),
descricao VARCHAR(100));

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/d_motivo_cancelamento_tratado.csv'
INTO TABLE motivos_cancelamento
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(motivo_id,categoria,descricao); # nome das colunas 

SELECT* FROM motivos_cancelamento;

-- 7️ -Plano tarifário
CREATE TABLE plano_tarifario(
rate_plan_id INT primary key,
nome_plano VARCHAR(100),
reembolsavel_flag INT,
cafe_incluso_flag INT,
politica_cancelamento VARCHAR(150));

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/d_plano_tarifario_tratado.csv'
INTO TABLE plano_tarifario
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rate_plan_id,nome_plano,reembolsavel_flag,cafe_incluso_flag,politica_cancelamento); # nome das colunas

SELECT* FROM plano_tarifario;

-- 8️ - Tipo de quarto
CREATE TABLE tipo_quarto(
tipo_quarto_id INT primary key,
tipo_quarto VARCHAR(100),
capacidade INT);

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/d_tipo_quarto_tratado.csv'
INTO TABLE tipo_quarto
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(tipo_quarto_id,tipo_quarto,capacidade); # nome das colunas

SELECT* FROM tipo_quarto;

-- 9 - Diárias
CREATE TABLE diarias(
hotel_id INT,
data_id date,
tipo_quarto VARCHAR(100),
quartos_vendidos INT,
adr_estimado DECIMAL(10,2),
receita_diarias DECIMAL(10,2));

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/f_diarias_tratado.csv'
INTO TABLE diarias
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(hotel_id,data_id,tipo_quarto,quartos_vendidos,adr_estimado,receita_diarias); # nome das colunas

SELECT* FROM diarias;

-- 10️ - Agência
CREATE TABLE agencia(
agencia_id INT primary key,
nome VARCHAR(100),
tipo VARCHAR(100),
comissao_pct DECIMAL(3,2));

DROP TABLE agencia;

LOAD DATA INFILE  'C:/Users/marcelino.fernandes/Desktop/SQL/d_agencia_tratado.csv'
INTO TABLE agencia
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(agencia_id,nome,tipo,comissao_pct); # nome das colunas

SELECT* FROM AGENCIA;

-- 11 - Reservas
CREATE TABLE reservas(
reserva_id INT primary key,
data_reserva_id INT,
data_cancelamento_id INT ,
motivo_cancelamento_id INT,
checkin_id INT,
checkout_id INT,
hotel_id INT,
hospede_id INT,
canal_id INT,
agencia_id INT,
rate_plan_id INT,
tipo_quarto VARCHAR(100),
status_reserva VARCHAR(100),
adultos INT,
criancas INT,
valor_previsto DECIMAL(10,2),
desconto DECIMAL(10,2),
moeda VARCHAR(100),
FOREIGN KEY (motivo_cancelamento_id) REFERENCES motivos_cancelamento(motivo_id),
FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id),
FOREIGN KEY (hospede_id) REFERENCES hospede(hospede_id),
FOREIGN KEY (canal_id) REFERENCES canal(canal_id),
FOREIGN KEY (agencia_id) REFERENCES agencia(agencia_id),
FOREIGN KEY (rate_plan_id) REFERENCES plano_tarifario(rate_plan_id));

drop table reservas;

LOAD DATA INFILE  'C:/Users/marcelino.fernandes/Desktop/SQL/f_reservas_tratado.csv'
INTO TABLE reservas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(reserva_id,data_reserva_id,data_cancelamento_id,motivo_cancelamento_id,checkin_id,checkout_id,hotel_id,hospede_id,canal_id,agencia_id,rate_plan_id,tipo_quarto,status_reserva,adultos,criancas,valor_previsto,desconto,moeda); # nome das colunas

select * from reservas;

-- 12 - Pagamentos
CREATE TABLE f_pagamentos (
    pagamento_id       INT PRIMARY KEY,
    reserva_id         INT,
    data_pagamento_id  INT,
    forma_pagamento    VARCHAR(20) ,
    valor_pago         DECIMAL(15,2) ,
    status_pagamento   VARCHAR(20) ,
    taxa_gateway       DECIMAL(15,2) 
    );

LOAD DATA INFILE  'C:/Users/marcelino.fernandes/Desktop/SQL/f_pagamentos_tratado.csv'
INTO TABLE f_pagamentos
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(pagamento_id, reserva_id, data_pagamento_id, forma_pagamento, valor_pago, status_pagamento, taxa_gateway); # nome das colunas

select * from f_pagamentos;

-- 13 - Reviews
CREATE TABLE f_reviews (
review_id INT PRIMARY KEY,
reserva_id INT,
data_review_id INT,
nota DECIMAL(4,2),
limpeza DECIMAL(4,2),
localizacao DECIMAL(4,2),
atendimento DECIMAL(4,2),
comentario_flag TINYINT(1)
);
DROP TABLE f_reviews;

LOAD DATA INFILE 'C:/Users/marcelino.fernandes/Desktop/SQL/f_reviews_tratado.csv'
INTO TABLE f_reviews
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, reserva_id, data_review_id, nota, limpeza, localizacao, atendimento, comentario_flag);

SELECT * FROM f_reviews

