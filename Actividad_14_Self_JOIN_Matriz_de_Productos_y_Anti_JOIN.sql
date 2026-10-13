-- Actividad 14: Self JOIN, Matriz de Productos y Anti JOIN

-- 1. Self JOIN en transacciones
SELECT
    t1.account_id,
    t1.transaction_id AS earlier_id,
    t1.tx_timestamp AS earlier_timestamp,
    t2.transaction_id AS later_id,
    t2.tx_timestamp AS later_timestamp
FROM Core.transactions t1
JOIN Core.transactions t2 
    ON t1.account_id = t2.account_id
AND (
    t1.tx_timestamp, 
    t1.transaction_id
) < (
    t2.tx_timestamp, 
    t2.transaction_id
)
AND t2.tx_timestamp <= t1.tx_timestamp + INTERVAL '48 hours'
ORDER BY t1.account_id, t1.tx_timestamp;

-- 2. Matriz de Productos y Anti JOIN
WITH tipos_cuenta AS (
    SELECT unnest(enum_range(NULL::core.tipo_cuenta)) AS account_type
),
matriz_posibilidades AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        tc.account_type
    FROM Core.Customers c
    CROSS JOIN tipos_cuenta tc
)
SELECT
    m.customer_id,
    m.first_name,
    m.last_name,
    m.email,
    m.account_type
FROM matriz_posibilidades m
LEFT JOIN Core.accounts a 
    ON a.customer_id = m.customer_id
    AND a.account_type = m.account_type
WHERE a.account_id IS NULL
ORDER BY m.email, m.account_type;