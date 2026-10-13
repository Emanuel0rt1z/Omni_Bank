-- Actividad 13: CTE y Pipeline de Métrica por Cuenta

WITH movimientos_por_cuenta AS (
    SELECT
        t.account_id,
        COUNT(t.transaction_id) AS total_eventos,
        SUM(t.amount) AS volumen_bruto
    FROM Core.transactions t
    WHERE t.amount > 0
    GROUP BY t.account_id
),
cuentas_activas AS (
    SELECT
        a.account_id,
        a.customer_id,
        a.account_number,
        a.account_type,
        a.currency,
        COALESCE(m.total_eventos, 0) AS recuento_eventos,
        COALESCE(m.volumen_bruto, 0.00) AS volumen_bruto
    FROM Core.accounts a
    LEFT JOIN movimientos_por_cuenta m 
        ON m.account_id = a.account_id
    WHERE a.is_active = true
),
reporte_por_cuenta AS (
    SELECT
        ca.account_number,
        (c.first_name || ' ' || c.last_name) AS titular,
        ca.account_type,
        ca.currency,
        ca.recuento_eventos,
        ca.volumen_bruto,
        CASE
            WHEN ca.recuento_eventos = 0 THEN 'SIN ACTIVIDAD'
            WHEN ca.recuento_eventos BETWEEN 1 AND 2 THEN 'ACTIVIDAD BAJA'
            ELSE 'ACTIVIDAD ALTA'
        END AS banda_actividad
    FROM cuentas_activas ca
    JOIN Core.Customers c 
        ON c.customer_id = ca.customer_id
)
SELECT
    account_number,
    titular,
    account_type,
    currency,
    recuento_eventos,
    volumen_bruto,
    banda_actividad
FROM reporte_por_cuenta
ORDER BY account_number ASC;

-- 4. Contrasta el recuento de cuentas activas y el volumen total
SELECT COUNT(account_id) AS recuento_cuentas_activas
FROM Core.accounts
WHERE is_active = true;

SELECT SUM(amount) AS volumen_total
FROM Core.transactions
WHERE amount > 0;