-- Tarea 13: Extensión de CTE y Pipeline de Métricas por Cuenta

-- 1. Reutiliza la etapa de Volumen por Cuenta de la actividad y conserva cuentas activas sin eventos
WITH movimiento_por_cuentas AS (
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
    LEFT JOIN movimiento_por_cuentas m 
        ON m.account_id = a.account_id
    WHERE a.is_active = true
),
-- 2. Agrupa esa salida por Currency para obtener número de cuentas, volumen bruto y promedio por cuenta
resumen_por_moneda AS (
    SELECT
        ca.currency,
        COUNT(ca.account_id) AS total_cuentas_activas,
        SUM(ca.volumen_bruto) AS volumen_bruto,
        ROUND(AVG(ca.volumen_bruto), 2) AS promedio_por_cuenta
    FROM cuentas_activas ca
    GROUP BY ca.currency
)
SELECT
    currency,
    total_cuentas_activas,
    volumen_bruto,
    promedio_por_cuenta
FROM resumen_por_moneda
ORDER BY currency ASC;

-- 3. Verificación de manera independiente
SELECT COUNT(account_id) AS total_cuentas_activas
FROM Core.accounts
WHERE is_active = true;

SELECT SUM(amount) AS volumen_bruto_movimientos
FROM Core.transactions
WHERE amount > 0;