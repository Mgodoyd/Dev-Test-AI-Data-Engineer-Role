# N8N Workflow Documentation / Documentación del Workflow N8N

## English Version

### Overview
This N8N workflow is designed to automate marketing data analysis and KPI reporting. It combines data ingestion, AI-powered SQL query generation, BigQuery execution, and natural language analysis to provide insights on Customer Acquisition Cost (CAC) and Return on Ad Spend (ROAS).

### Workflow Name
**Dev Test – AI Data Engineer Role**

### Architecture Overview
The workflow consists of two main execution paths:
1. **Automated Data Pipeline**: Scheduled data ingestion and processing
2. **Interactive Chat Interface**: AI-powered query generation and analysis

### Node-by-Node Breakdown

#### 1. Schedule Trigger
- **Type**: `scheduleTrigger`
- **Purpose**: Initiates the automated data pipeline every second
- **Configuration**: Interval-based trigger for continuous data processing

#### 2. Download File
- **Type**: `httpRequest`
- **Purpose**: Downloads CSV data from Google Drive
- **URL**: `https://drive.google.com/uc?export=download&id=1RXj_3txgmyX2Wyt9ZwM7l4axfi5A6EC-`
- **Output**: Raw CSV data for processing

#### 3. Extract from File
- **Type**: `extractFromFile`
- **Purpose**: Parses and extracts data from the downloaded CSV
- **Input**: Raw CSV content
- **Output**: Structured data objects

#### 4. Code (Data Enrichment)
- **Type**: `code`
- **Purpose**: Adds metadata to extracted data
- **Functionality**: 
  - Adds `load_date` timestamp
  - Sets `source_file_name` to "ads_spend.csv"
- **Code**:
```javascript
return items.map(item => {
  item.json.load_date = new Date().toISOString();
  item.json.source_file_name = "ads_spend.csv";
  return item;
});
```

#### 5. Insert Rows in BigQuery Table
- **Type**: `googleBigQuery`
- **Purpose**: Loads processed data into BigQuery
- **Configuration**:
  - Project ID: `demorag-462121`
  - Dataset: `DevTestAIDataEngineerRole`
  - Table: `ads_spend`
- **Operation**: Insert new rows with enriched data

#### 6. Chat Interface Trigger
- **Type**: `chatTrigger`
- **Purpose**: Receives user queries via webhook
- **Webhook ID**: `e1777a01-e025-4dd2-b979-360d544dd655`
- **Input**: User chat messages for KPI analysis

#### 7. AI Agent (Query Generation)
- **Type**: `agent` (LangChain)
- **Purpose**: Generates BigQuery SQL queries based on user questions
- **Model**: GPT-4o-mini
- **System Message**: Comprehensive prompt for SQL generation with specific rules:
  - Calculates CAC (spend/conversions) and ROAS ((conversions*100)/spend)
  - Generates ready-to-run BigQuery SQL
  - Handles date-based comparisons
  - Includes error correction for common SQL issues

#### 8. Conditional Logic (If)
- **Type**: `if`
- **Purpose**: Routes greetings vs. analytical queries
- **Conditions**: 
  - If input equals "hi" or "hello" → No Operation
  - Otherwise → SQL processing pipeline

#### 9. Clean Script
- **Type**: `code`
- **Purpose**: Fixes common SQL syntax issues
- **Functionality**:
  - Fixes missing multiplication operators
  - Corrects WHERE clause syntax
  - Ensures proper table path formatting
  - Fixes literal alias quotes

#### 10. Execute SQL Query
- **Type**: `googleBigQuery`
- **Purpose**: Executes the cleaned SQL query
- **Input**: Processed and corrected SQL from AI Agent
- **Output**: Query results with KPI metrics

#### 11. Aggregate
- **Type**: `aggregate`
- **Purpose**: Consolidates query results
- **Operation**: Aggregates all item data for analysis

#### 12. AI Agent (Analysis)
- **Type**: `agent` (LangChain)
- **Purpose**: Converts query results to natural language insights
- **Model**: GPT-4.1-mini
- **Function**: Generates detailed summaries of CAC and ROAS metrics
- **Output**: Human-readable analysis of marketing performance

### Data Flow
1. **Automated Pipeline**: Schedule → Download → Extract → Enrich → Load to BigQuery
2. **Interactive Analysis**: Chat → AI Query Generation → SQL Execution → AI Analysis → Insights

### Key Features
- **Real-time Data Processing**: Continuous data ingestion every second
- **AI-Powered Query Generation**: Natural language to SQL conversion
- **Automated Data Quality**: SQL syntax correction and validation
- **Intelligent Analysis**: AI-generated insights from raw metrics
- **BigQuery Integration**: Direct database operations and analytics

### Technical Requirements
- **N8N Instance**: Active N8N workflow engine
- **Google BigQuery**: Project access and credentials
- **OpenAI API**: GPT-4 models for AI operations
- **Google Drive**: CSV data source access
- **Webhook Endpoint**: For chat interface

### Error Handling
- **SQL Validation**: Automatic syntax correction
- **Data Validation**: Structured data processing
- **Memory Management**: Context window limitations for AI agents

---

## Versión en Español

### Descripción General
Este workflow de N8N está diseñado para automatizar el análisis de datos de marketing y la generación de reportes de KPIs. Combina la ingesta de datos, generación de consultas SQL impulsada por IA, ejecución en BigQuery y análisis en lenguaje natural para proporcionar insights sobre el Costo de Adquisición de Clientes (CAC) y el Retorno sobre Gasto en Publicidad (ROAS).

### Nombre del Workflow
**Dev Test – AI Data Engineer Role**

### Arquitectura General
El workflow consta de dos rutas de ejecución principales:
1. **Pipeline de Datos Automatizado**: Ingesta y procesamiento programado de datos
2. **Interfaz de Chat Interactiva**: Generación de consultas y análisis impulsado por IA

### Desglose Nodo por Nodo

#### 1. Disparador Programado
- **Tipo**: `scheduleTrigger`
- **Propósito**: Inicia el pipeline de datos automatizado cada segundo
- **Configuración**: Disparador basado en intervalos para procesamiento continuo

#### 2. Descarga de Archivo
- **Tipo**: `httpRequest`
- **Propósito**: Descarga datos CSV desde Google Drive
- **URL**: `https://drive.google.com/uc?export=download&id=1RXj_3txgmyX2Wyt9ZwM7l4axfi5A6EC-`
- **Salida**: Datos CSV sin procesar

#### 3. Extracción de Archivo
- **Tipo**: `extractFromFile`
- **Propósito**: Analiza y extrae datos del CSV descargado
- **Entrada**: Contenido CSV sin procesar
- **Salida**: Objetos de datos estructurados

#### 4. Código (Enriquecimiento de Datos)
- **Tipo**: `code`
- **Propósito**: Agrega metadatos a los datos extraídos
- **Funcionalidad**: 
  - Agrega timestamp `load_date`
  - Establece `source_file_name` como "ads_spend.csv"
- **Código**:
```javascript
return items.map(item => {
  item.json.load_date = new Date().toISOString();
  item.json.source_file_name = "ads_spend.csv";
  return item;
});
```

#### 5. Inserción de Filas en Tabla BigQuery
- **Tipo**: `googleBigQuery`
- **Propósito**: Carga datos procesados en BigQuery
- **Configuración**:
  - ID del Proyecto: `demorag-462121`
  - Dataset: `DevTestAIDataEngineerRole`
  - Tabla: `ads_spend`
- **Operación**: Inserta nuevas filas con datos enriquecidos

#### 6. Disparador de Interfaz de Chat
- **Tipo**: `chatTrigger`
- **Propósito**: Recibe consultas de usuarios vía webhook
- **ID del Webhook**: `e1777a01-e025-4dd2-b979-360d544dd655`
- **Entrada**: Mensajes de chat para análisis de KPIs

#### 7. Agente IA (Generación de Consultas)
- **Tipo**: `agent` (LangChain)
- **Propósito**: Genera consultas SQL de BigQuery basadas en preguntas de usuarios
- **Modelo**: GPT-4o-mini
- **Mensaje del Sistema**: Prompt comprehensivo para generación SQL con reglas específicas:
  - Calcula CAC (gasto/conversiones) y ROAS ((conversiones*100)/gasto)
  - Genera SQL de BigQuery listo para ejecutar
  - Maneja comparaciones basadas en fechas
  - Incluye corrección de errores para problemas SQL comunes

#### 8. Lógica Condicional (Si)
- **Tipo**: `if`
- **Propósito**: Enruta saludos vs. consultas analíticas
- **Condiciones**: 
  - Si la entrada es igual a "hi" o "hello" → Sin Operación
  - De lo contrario → Pipeline de procesamiento SQL

#### 9. Script de Limpieza
- **Tipo**: `code`
- **Propósito**: Corrige problemas comunes de sintaxis SQL
- **Funcionalidad**:
  - Corrige operadores de multiplicación faltantes
  - Corrige sintaxis de cláusulas WHERE
  - Asegura formato correcto de rutas de tabla
  - Corrige comillas de alias literales

#### 10. Ejecución de Consulta SQL
- **Tipo**: `googleBigQuery`
- **Propósito**: Ejecuta la consulta SQL limpia
- **Entrada**: SQL procesado y corregido del Agente IA
- **Salida**: Resultados de consulta con métricas de KPIs

#### 11. Agregación
- **Tipo**: `aggregate`
- **Propósito**: Consolida resultados de consulta
- **Operación**: Agrega todos los datos de elementos para análisis

#### 12. Agente IA (Análisis)
- **Tipo**: `agent` (LangChain)
- **Propósito**: Convierte resultados de consulta a insights en lenguaje natural
- **Modelo**: GPT-4.1-mini
- **Función**: Genera resúmenes detallados de métricas CAC y ROAS
- **Salida**: Análisis legible del rendimiento de marketing

### Flujo de Datos
1. **Pipeline Automatizado**: Programación → Descarga → Extracción → Enriquecimiento → Carga a BigQuery
2. **Análisis Interactivo**: Chat → Generación de Consulta IA → Ejecución SQL → Análisis IA → Insights

### Características Clave
- **Procesamiento de Datos en Tiempo Real**: Ingesta continua de datos cada segundo
- **Generación de Consultas Impulsada por IA**: Conversión de lenguaje natural a SQL
- **Calidad de Datos Automatizada**: Corrección y validación de sintaxis SQL
- **Análisis Inteligente**: Insights generados por IA desde métricas sin procesar
- **Integración BigQuery**: Operaciones directas de base de datos y analytics

### Requisitos Técnicos
- **Instancia N8N**: Motor de workflow N8N activo
- **Google BigQuery**: Acceso al proyecto y credenciales
- **API OpenAI**: Modelos GPT-4 para operaciones de IA
- **Google Drive**: Acceso a fuente de datos CSV
- **Endpoint Webhook**: Para interfaz de chat

### Manejo de Errores
- **Validación SQL**: Corrección automática de sintaxis
- **Validación de Datos**: Procesamiento de datos estructurados
- **Gestión de Memoria**: Limitaciones de ventana de contexto para agentes IA

### Casos de Uso
- **Monitoreo Continuo**: Seguimiento automático de métricas de marketing
- **Análisis Ad Hoc**: Consultas personalizadas sobre rendimiento de campañas
- **Reportes Automatizados**: Generación de insights sin intervención manual
- **Optimización de Campañas**: Identificación de tendencias en CAC y ROAS

### Beneficios del Workflow
- **Automatización Completa**: Reducción de trabajo manual en análisis de datos
- **Insights en Tiempo Real**: Acceso inmediato a métricas de rendimiento
- **Escalabilidad**: Manejo de grandes volúmenes de datos de marketing
- **Inteligencia Artificial**: Análisis avanzado sin necesidad de expertise técnico
- **Integración Empresarial**: Conexión directa con infraestructura de datos existente
