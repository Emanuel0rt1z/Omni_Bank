-- Actividad 9: Reportes Relacionales para Operaciones de OmniBank

-- 1. Punto de Control de la Semilla
SELECT 'Core.Customers' AS tabla, COUNT(*) AS total_registros
FROM Core.Customers
UNION ALL
SELECT 'Core.accounts' AS tabla, COUNT(*) AS total_registros
FROM Core.accounts
UNION ALL
SELECT 'Core.transactions' AS tabla, COUNT(*) AS total_registros
FROM Core.transactions;

-- 2. Recorrido de Cada Movimiento
SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    a.account_number,
    t.tx_type,
    t.amount
FROM Core.transactions t
INNER JOIN Core.accounts a 
    ON t.account_id = a.account_id
INNER JOIN Core.Customers c 
    ON a.customer_id = c.customer_id
ORDER BY t.tx_timestamp ASC, t.transaction_id ASC;

-- 3. Cuentas sin Movimiento
SELECT
    a.account_number,
    a.is_active,
    CASE
        WHEN a.is_active = true 
            THEN 'Actividad sin uso registrado'
        ELSE 'Cuenta desactivada'
    END AS estado_presentacion
FROM Core.accounts a
LEFT JOIN Core.transactions t 
    ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL
ORDER BY a.account_number ASC;

-- 4. Titulares con Cuenta Elegible si Existe
SELECT
    c.email,
    a.account_number,
    a.balance
FROM Core.Customers c
LEFT JOIN Core.accounts a 
    ON c.customer_id = a.customer_id 
    AND a.balance > 0
ORDER BY c.email ASC, a.account_number ASC;
