-- Actividad 11: Transformación de Escalares y Fechas de OmniBank
-- Conserva la base acumulada hasta el día anterior y ejecuta este archivo antes de la tarea.
-- Cada bloque debe poder contratarse con los datos de partida indicados.

-- Bloque 1: Transformación de cadenas y presentación
SELECT
    a.account_id,
    a.account_number,
    c.email,
    a.is_active,
    CONCAT(
        UPPER(TRIM(c.first_name)), 
        ' ', 
        UPPER(TRIM(c.last_name)), 
        ' - ACC-...', 
        RIGHT(a.account_number, 4)
    ) AS etiqueta_presentacion,
    a.account_type,
    a.balance AS saldo_almacenado
FROM Core.accounts a
JOIN Core.Customers c 
    ON c.customer_id = a.customer_id
ORDER BY a.account_id ASC;

-- Bloque 2: Operaciones y extracción sobre fechas
SELECT
    t.transaction_id,
    t.account_id,
    t.amount::text AS importe_texto,
    t.tx_timestamp AS fecha_original,
    t.tx_timestamp + INTERVAL '15 days' AS fecha_revision,
    AGE(
        TIMESTAMPTZ '2026-10-01 00:00:00+00', 
        t.tx_timestamp
    ) AS antiguedad_al_corte,
    EXTRACT(YEAR FROM t.tx_timestamp) AS anio_original,
    EXTRACT(MONTH FROM t.tx_timestamp) AS mes_original
FROM Core.transactions t
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00:00+00'
ORDER BY t.transaction_id ASC;

-- Bloque 3: Conteo global de cuentas y eventos históricos filtrados por fecha
SELECT 
    COUNT(account_id) AS total_cuentas
FROM Core.accounts;

SELECT 
    COUNT(transaction_id) AS total_eventos
FROM Core.transactions
WHERE tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00:00+00';