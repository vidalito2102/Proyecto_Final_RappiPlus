-- ============================================================
-- RappiPlus | Consultas SQL del proyecto
-- Portafolio de Análisis de Datos
-- ============================================================
-- Estas consultas se conservaron del notebook final como evidencia
-- metodológica. Las tablas PostgreSQL originales del bootcamp no se
-- distribuyen públicamente, por lo que algunas consultas no son
-- reproducibles sin ese entorno.
--
-- IMPORTANTE:
-- No se incluyen credenciales, host, usuario ni contraseña.
-- ============================================================

-- ------------------------------------------------------------
-- Consulta 1
-- ------------------------------------------------------------
SELECT *
FROM events;

-- ------------------------------------------------------------
-- Consulta 2
-- ------------------------------------------------------------
SELECT COUNT(DISTINCT nombre_evento) AS total_eventos_unicos
FROM events;

-- ------------------------------------------------------------
-- Consulta 3
-- ------------------------------------------------------------
SELECT nombre_evento, COUNT(DISTINCT id_usuario) AS total_usuarios
FROM events
GROUP BY nombre_evento
ORDER BY case nombre_evento
    WHEN 'first_visit' THEN 1
    WHEN 'select_item' THEN 2
    WHEN 'add_to_cart' THEN 3
    WHEN 'begin_checkout' THEN 4
    WHEN 'add_payment_info' THEN 5
    WHEN 'purchase' THEN 6
END;

-- ------------------------------------------------------------
-- Consulta 4
-- ------------------------------------------------------------
WITH cte_first_visit AS (
  SELECT DISTINCT id_usuario
  FROM events
  WHERE nombre_evento = 'first_visit'
),

cte_item AS (
  SELECT DISTINCT id_usuario
  FROM events
  WHERE nombre_evento = 'select_item'

),

cte_cart AS (
  SELECT DISTINCT id_usuario
  FROM events
  WHERE nombre_evento = 'add_to_cart'

),

cte_checkout AS (
  SELECT DISTINCT id_usuario
  FROM events
  WHERE nombre_evento = 'begin_checkout'
),

cte_payment AS (
  SELECT DISTINCT id_usuario
  FROM events
  WHERE nombre_evento = 'add_payment_info'
),

cte_purchase AS (
  SELECT DISTINCT id_usuario
  FROM events
  WHERE nombre_evento = 'purchase'
)

SELECT
  (SELECT COUNT(*) FROM cte_first_visit)   AS first_visit_user,
  (SELECT COUNT(*) FROM cte_item) AS item_users,
  (SELECT COUNT(*) FROM cte_cart)     AS cart_users,
  (SELECT COUNT(*) FROM cte_checkout) AS checkout_user,
  (SELECT COUNT(*) FROM cte_payment) AS payment_user,
  (SELECT COUNT(*) FROM cte_purchase) AS purchase_user;

-- ------------------------------------------------------------
-- Consulta 5
-- ------------------------------------------------------------
WITH event_counts AS (
    SELECT
        nombre_evento,
        COUNT(DISTINCT id_usuario) AS usuarios
    FROM events
    GROUP BY nombre_evento
)
SELECT
    MAX(CASE WHEN nombre_evento = 'first_visit' THEN usuarios END) AS first_visit_user,
    MAX(CASE WHEN nombre_evento = 'select_item' THEN usuarios END) AS item_users,
    MAX(CASE WHEN nombre_evento = 'add_to_cart' THEN usuarios END) AS cart_users,
    MAX(CASE WHEN nombre_evento = 'begin_checkout' THEN usuarios END) AS checkout_user,
    MAX(CASE WHEN nombre_evento = 'add_payment_info' THEN usuarios END) AS payment_user,
    MAX(CASE WHEN nombre_evento = 'purchase' THEN usuarios END) AS purchase_user
FROM event_counts;

-- ------------------------------------------------------------
-- Consulta 6
-- ------------------------------------------------------------
SELECT *
FROM users;

-- ------------------------------------------------------------
-- Consulta 7
-- ------------------------------------------------------------
SELECT *
FROM user_activity;

-- ------------------------------------------------------------
-- Consulta 8
-- ------------------------------------------------------------
SELECT id_usuario,
count(fecha_registro) AS conteo_registros
FROM users
GROUP BY id_usuario
HAVING count(fecha_registro) > 1;

-- ------------------------------------------------------------
-- Consulta 9
-- ------------------------------------------------------------
SELECT id_usuario,
       fecha_registro,
       DATE_TRUNC('month', MIN(CAST(fecha_registro AS DATE))) AS cohort_mensual
FROM users
GROUP BY id_usuario, fecha_registro;

-- ------------------------------------------------------------
-- Consulta 10
-- ------------------------------------------------------------
WITH cohortes AS (
    SELECT
        id_usuario,
        DATE_TRUNC('month', MIN(CAST(fecha_actividad AS DATE))) AS cohort_mensual,
        dias_despues_registro,
        activo
FROM user_activity
GROUP BY id_usuario, dias_despues_registro, activo
)
SELECT
    cohort_mensual,
    COUNT(*) AS clientes_iniciales,
    COUNT(CASE WHEN dias_despues_registro >= 7 AND activo = 1 THEN 1 END) AS retenido_w1,
    COUNT(CASE WHEN dias_despues_registro >= 14 AND activo = 1 THEN 1 END) AS retenido_w2,
    COUNT(CASE WHEN dias_despues_registro >= 21 AND activo = 1 THEN 1 END) AS retenido_w3
  FROM cohortes
  GROUP BY cohort_mensual;

-- ------------------------------------------------------------
-- Consulta 11
-- ------------------------------------------------------------
WITH cohortes AS (
    SELECT
        id_usuario,
        DATE_TRUNC('month', MIN(CAST(fecha_actividad AS DATE))) AS cohort_mensual,
        dias_despues_registro,
        activo
FROM user_activity
GROUP BY id_usuario, dias_despues_registro, activo
),
retencion AS (
SELECT
    cohort_mensual,
    COUNT(*) AS clientes_iniciales,
    COUNT(CASE WHEN dias_despues_registro >= 7 AND activo = 1 THEN 1 END) AS retenido_w1,
    COUNT(CASE WHEN dias_despues_registro >= 14 AND activo = 1 THEN 1 END) AS retenido_w2,
    COUNT(CASE WHEN dias_despues_registro >= 21 AND activo = 1 THEN 1 END) AS retenido_w3
FROM cohortes
GROUP BY cohort_mensual
)
SELECT
  TO_CHAR(cohort_mensual, 'YYYY-MM') AS cohorte, 
  clientes_iniciales,
  ROUND(retenido_w1::numeric / clientes_iniciales, 2) AS semana_1,
  ROUND(retenido_w2::numeric / clientes_iniciales, 2) AS semana_2,
  ROUND(retenido_w3::numeric / clientes_iniciales, 2) AS semana_3
FROM retencion
ORDER BY  cohort_mensual;

-- ------------------------------------------------------------
-- Consulta 12
-- ------------------------------------------------------------
WITH cohortes AS (
    SELECT
        id_usuario,
        DATE_TRUNC('month', CAST(fecha_registro AS DATE)) AS cohorte
    FROM users
),
actividad AS (
    SELECT
        c.id_usuario,
        c.cohorte,
        ua.dias_despues_registro,
        ua.activo
    FROM cohortes c
    LEFT JOIN user_activity ua
        ON c.id_usuario = ua.id_usuario
)
SELECT
    TO_CHAR(cohorte, 'YYYY-MM') AS cohorte,
    COUNT(DISTINCT id_usuario) AS usuarios_cohorte,
    COUNT(DISTINCT CASE
        WHEN dias_despues_registro = 7 AND activo = 1 THEN id_usuario
    END)::numeric / NULLIF(COUNT(DISTINCT id_usuario), 0) AS retencion_w1,
    COUNT(DISTINCT CASE
        WHEN dias_despues_registro = 14 AND activo = 1 THEN id_usuario
    END)::numeric / NULLIF(COUNT(DISTINCT id_usuario), 0) AS retencion_w2,
    COUNT(DISTINCT CASE
        WHEN dias_despues_registro = 21 AND activo = 1 THEN id_usuario
    END)::numeric / NULLIF(COUNT(DISTINCT id_usuario), 0) AS retencion_w3
FROM actividad
GROUP BY cohorte
ORDER BY cohorte;
