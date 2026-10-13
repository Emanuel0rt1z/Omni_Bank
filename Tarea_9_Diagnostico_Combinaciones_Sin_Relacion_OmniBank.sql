-- Tarea 9: Diagnóstico de Combinaciones sin Relación de OmniBank

-- 1. Cuantificación la matriz sin relaciones
SELECT
    (SELECT COUNT(*) FROM Core.Customers) AS total_clientes,
    (SELECT COUNT(*) FROM Core.accounts) AS total_cuentas,
    (SELECT COUNT(*) FROM Core.transactions) AS total_transacciones,
    (
        (SELECT COUNT(*) FROM Core.Customers) *
        (SELECT COUNT(*) FROM Core.accounts) *
        (SELECT COUNT(*) FROM Core.transactions)
    ) AS producto_cartesiano
FROM Core.Customers
CROSS JOIN Core.accounts
CROSS JOIN Core.transactions;

-- 2. Repara el reporte de Movimientos
SELECT
    c.email,
    a.account_number,
    t.tx_type,
    t.amount,
    t.tx_timestamp
FROM Core.transactions t
INNER JOIN Core.accounts a 
    ON t.account_id = a.account_id
INNER JOIN Core.Customers c 
    ON a.customer_id = c.customer_id
WHERE c.is_active = true
  AND t.amount >= 100
ORDER BY t.tx_timestamp ASC, t.transaction_id ASC;