-- Tarea 10: Promedios con NULL y Reporte de Actividad de Crédito

-- 1. Construye una muestra de Cuatro Valores
WITH muestra (id, val) AS (
    VALUES
    (1, 10000.0::numeric),
    (2, 0.0::numeric),
    (3, 0.0::numeric),
    (4, NULL::numeric)
)
SELECT 
    ROUND(AVG(val), 2) AS promedio_null,
    COUNT(val) AS denominador
FROM muestra;

SELECT 
    ROUND(AVG(COALESCE(val, 0.0)), 2) AS promedio_sin_null,
    COUNT(*) AS denominador_observaciones
FROM muestra;

-- 2. Desde accounts y transactions, informe para Crédito
SELECT
    a.account_id,
    a.account_type,
    a.balance AS saldo_almuerzo,
    COUNT(t.transaction_id) AS numero_mov,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto
FROM Core.accounts a
LEFT JOIN Core.transactions t 
    ON a.account_id = t.account_id
WHERE a.account_type = 'CREDIT'
  AND a.is_active = true
GROUP BY a.account_id, a.account_type, a.balance;

-- 3. Usa HAVING para seleccionar cuentas de Crédito con criterios específicos
SELECT
    a.account_id,
    a.account_type,
    a.balance AS saldo_almuerzo,
    COUNT(t.transaction_id) AS numero_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto
FROM Core.accounts a
LEFT JOIN Core.transactions t 
    ON a.account_id = t.account_id
WHERE a.account_type = 'CREDIT'
  AND a.is_active = true
GROUP BY a.account_id, a.account_type, a.balance
HAVING COUNT(t.transaction_id) = 0
    OR COALESCE(SUM(t.amount), 0) >= 300
ORDER BY a.account_id ASC;