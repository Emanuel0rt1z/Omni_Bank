-- Monedas admitidas
CREATE TYPE core.tipo_moneda AS ENUM ('USD', 'EUR', 'MXN', 'GBP');

-- Tipos de cuentas de clientes
CREATE TYPE core.tipo_cuenta AS ENUM ('CHECKING', 'SAVINGS', 'CREDIT');

-- Categorizaciones transaccionales permitidas
CREATE TYPE core.tipo_transaccion AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER');