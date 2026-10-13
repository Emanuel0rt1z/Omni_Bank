-- Actividad 10: Tablero de Saldos y Actividad Registrada de OmniBank

-- 1. Tablero de Productos: Una fila por tipo de cuenta activa
SELECT
    account_type,
    COUNT(*) AS n_cuentas,
    SUM(balance) AS saldo_total,
    MIN(balance) AS saldo_min,
    MAX(balance) AS saldo_max,
    ROUND(AVG(balance), 2) AS promedio_saldo
FROM Core.accounts
WHERE is_active = true
GROUP BY account_type
ORDER BY saldo_total DESC, account_type ASC;

-- 2. Segmentación de titulares: Una fila por cliente elegible
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(t.transaction_id) AS cantidad_movimiento,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto_registrado
FROM Core.Customers c
LEFT JOIN Core.accounts a 
    ON c.customer_id = a.customer_id
LEFT JOIN Core.transactions t 
    ON a.account_id = t.account_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(t.transaction_id) >= 2
    OR COALESCE(SUM(t.amount), 0) > 100
ORDER BY volumen_bruto_registrado DESC, c.email ASC;

-- 3. Control Independiente
SELECT
    account_id,
    COUNT(transaction_id) AS cantidad_movimiento,
    COALESCE(SUM(amount), 0) AS volumen_bruto
FROM Core.transactions
GROUP BY account_id
ORDER BY account_id ASC;

SELECT
    COUNT(*) AS total_movimiento,
    SUM(amount) AS volumen_bruto
FROM Core.transactions;