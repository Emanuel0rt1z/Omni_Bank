-- Tarea 12: Exclusión Segura con NOT EXISTS y NULL

-- 1. Extiende la consulta de ausencia de la actividad para devolver solo cuentas activas sin ningún movimiento
SELECT
    a.account_id,
    a.account_number,
    a.account_type,
    a.is_active
FROM Core.accounts a
WHERE a.is_active = true
  AND NOT EXISTS (
      SELECT 1
      FROM Core.transactions t
      WHERE t.account_id = a.account_id
  )
ORDER BY a.account_id ASC;

-- 2. Construye un segundo NOT EXISTS que busque ausencia de DEPOSIT para todas las cuentas
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
        AND t.tx_type = 'DEPOSIT'
  )
ORDER BY a.account_id ASC;

-- 3. Compara los dos conjuntos con recuentos independientes
WITH sample_data (val) AS (
    VALUES (1), (NULL::integer)
)
SELECT
    (2 NOT IN (SELECT val FROM sample_data)) AS not_in_result,
    (NOT EXISTS (SELECT 1 FROM sample_data WHERE val = 2)) AS not_exist_result;
    