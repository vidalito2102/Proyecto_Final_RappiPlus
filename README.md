# -Proyecto_Final_RappiPlus

Este repositorio contiene el análisis realizado durante el Sprint 12 del bootcamp de TripleeTen del caso RappiPlus

Se realizo la limpieza, se dio formato, se revisaron valores duplicados, se revisaron variables numéricas y categóricas así como la revisión de las consistencias de los montos.
Los Datasets procesados son los siguintes:

- **rappiplus_orders_raw.csv** → información de pedidos, precios, descuentos y revenue  
- **rappiplus_catalog.csv** → costos de productos, categorías y proveedores  
- **rappiplus_marketing_spend.csv** → inversión en marketing por canal y país 

También se realizo un analisis de Cohortes en SQL

- **events / users / user_activity (SQL)** → comportamiento del usuario dentro de la plataforma 

## 📂 Contenido del repositorio

- `notebooks/Proyecto_Final_RappiPlus.ipynb`
  → Notebook principal con limpieza, EDA, distribuciones, outliers y conclusiones.


1. Abre el archivo `.ipynb` en GitHub
2. Haz clic en **Open in Colab**

## 📘 Cómo reproducir el analisis

1. Abre `notebooks/Proyecto_Final_RappiPlus.ipynb`
2. Ejecuta las celdas en orden
3. El notebook carga automáticamente el dataset desde `/data/` o desde un enlace público (según corresponda)

## 🧠 Objetivo del análisis

El análisis sigue una lógica clara y progresiva:

1. 🔍 Evaluar si podemos confiar en los datos (calidad de datos en Python) 

2. 💰 Analizar si el negocio es rentable (revenue, costos y profit)  

3. 🛒 Entender dónde se pierden los usuarios (funnel de conversión)  

4. 🔁 Evaluar si los usuarios regresan (retención por cohortes)  

5. 🧪 Validar si los cambios generan impacto (test estadístico)  

6. 📊 Comunicar los resultados (dashboard en BI) 
