-- Tarea 11: Porcentaje de Cuentas Desactivadas y Ventana de Revisión Temporal

-- 1. Porcentaje de cuentas desactivadas utilizando FILTER y condicionales numéricos
SELECT
    COUNT(a.account_id) AS total_cuentas,
    COUNT(a.account_id) FILTER (
        WHERE a.is_active = false
    ) AS cuenta_desactivadas,
    ROUND(
        (
            COUNT(a.account_id) FILTER (
                WHERE a.is_active = false
            )::numeric 
            / COUNT(a.account_id)::numeric
        ) * 100.0, 
        2
    ) AS porcentaje_desactivadas
FROM Core.accounts a;

-- 2. Ventana de revisión temporal sobre transacciones históricas
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
    EXTRACT(YEAR FROM t.tx_timestamp) AS year_origin,
    EXTRACT(MONTH FROM t.tx_timestamp) AS mes_origin
FROM Core.transactions t
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00:00+00'
ORDER BY t.transaction_id ASC;