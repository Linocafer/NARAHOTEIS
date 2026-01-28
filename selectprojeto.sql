USE Projeto;

-- 1 - Receita total (geral)
SELECT
    ROUND(SUM(receita_diarias), 2) AS receita_total_diarias
FROM diarias;

-- 2- Receita por hotel
SELECT
    h.nome AS hotel,
    ROUND(SUM(d.receita_diarias), 2) AS receita_total_diarias
FROM diarias d
JOIN hotel h
    ON d.hotel_id = h.hotel_id
GROUP BY h.nome
ORDER BY receita_total_diarias DESC;

-- 3- Receita por hotel e mês
SELECT
    h.nome AS hotel,
    dt.ano,
    dt.mes,
    ROUND(SUM(d.receita_diarias), 2) AS receita_total_diarias
FROM diarias d
JOIN hotel h
    ON d.hotel_id = h.hotel_id
JOIN d_data dt
    ON d.data_id = dt.data_id
GROUP BY
    h.nome,
    dt.ano,
    dt.mes
ORDER BY
    h.nome,
    dt.ano,
    dt.mes;

-- 4 - Receita por tipo de quarto
SELECT
    tipo_quarto,
    ROUND(SUM(receita_diarias), 2) AS receita_total_diarias
FROM diarias
GROUP BY tipo_quarto
ORDER BY receita_total_diarias DESC;

-- 5 - Total de reservas canceladas
SELECT
    COUNT(*) AS total_cancelamentos
FROM reservas
WHERE data_cancelamento_id IS NOT NULL;

-- 6 - % Cancelamento = Reservas Canceladas / Total de Reservas
SELECT
    h.nome AS hotel,
    d.ano,
    d.mes,
    ROUND(
        SUM(CASE WHEN r.status_reserva = 'Cancelada' THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS taxa_cancelamento_pct
FROM reservas r
JOIN d_data d ON r.data_reserva_id = d.data_id
JOIN hotel h ON r.hotel_id = h.hotel_id
GROUP BY h.nome, d.ano, d.mes;

-- 7-  Cancelamento por Canal
SELECT
    c.canal_nome,
    COUNT(*) AS total_reservas,
    SUM(CASE WHEN r.status_reserva = 'Cancelada' THEN 1 ELSE 0 END) AS canceladas,
    ROUND(
        SUM(CASE WHEN r.status_reserva = 'Cancelada' THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS taxa_cancelamento_pct
FROM reservas r
JOIN canal c ON r.canal_id = c.canal_id
GROUP BY c.canal_nome
ORDER BY taxa_cancelamento_pct DESC;

-- 8 - Ticket Médio por Reserva
SELECT
    h.nome AS hotel,
    ROUND(AVG(r.valor_previsto - r.desconto), 2) AS ticket_medio
FROM reservas r
JOIN hotel h ON r.hotel_id = h.hotel_id
WHERE r.status_reserva = 'Finalizada'
GROUP BY h.nome;

-- 9 - Nota Média de Avaliação por Hotel
SELECT
    h.nome AS hotel,
    ROUND(AVG(fr.nota), 2) AS nota_media
FROM f_reviews fr
JOIN reservas r ON fr.reserva_id = r.reserva_id
JOIN hotel h ON r.hotel_id = h.hotel_id
GROUP BY h.nome
ORDER BY nota_media DESC;


-- ADR — Average Daily Rate
-- 10 - Receita de diárias / quartos vendidos
SELECT
    h.nome AS hotel,
    d.ano,
    d.mes,
    ROUND(
        SUM(f.receita_diarias) / NULLIF(SUM(f.quartos_vendidos), 0),
        2
    ) AS adr
FROM diarias f
JOIN hotel h        ON f.hotel_id = h.hotel_id
JOIN d_data d       ON f.data_id  = d.data_id
GROUP BY h.nome, d.ano, d.mes
ORDER BY h.nome, d.ano, d.mes;
