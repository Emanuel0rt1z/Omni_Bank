-- Actividad 12: Subconsultas Correlacionadas y Cuentas sin Movimientos
-- Conserva la base acumulada hasta el día anterior y ejecuta este archivo antes de la tarea.
-- Cada bloque debe poder contrastarse con los datos de partida indicados.

-- 1 y 2. Calcula para cada movimiento el promedio de amount y filtra aquellos que superen su promedio de cuenta
SELECT
    t.transaction_id,
    t.account_id,
    t.amount,
    (
        SELECT ROUND(AVG(sub.amount), 2)
        FROM Core.transactions sub
        WHERE sub.account_id = t.account_id
    ) AS promedio_cuenta
FROM Core.transactions t
WHERE t.amount > (
    SELECT AVG(sub.amount)
    FROM Core.transactions sub
    WHERE sub.account_id = t.account_id
)
ORDER BY t.transaction_id ASC;

-- 3 y 4. Desde accounts, utiliza NOT EXISTS para hallar cuentas sin movimientos y explica el comportamiento
SELECT
    a.account_id,
    a.account_number,
    a.account_type,
    a.is_active
FROM Core.accounts a
WHERE NOT EXISTS (
    SELECT 1
    FROM Core.transactions t
    WHERE t.account_id = a.account_id
)
ORDER BY a.account_id ASC;