# AI Data Engineer Test Project / Proyecto de Prueba de Ingeniero de Datos IA

## English Version

### Project Overview
This project demonstrates a complete data engineering solution for marketing analytics, implementing automated data ingestion, KPI modeling, and AI-powered analysis. The solution addresses all four parts of the test requirements with a focus on scalability, automation, and intelligent insights.

### Project Structure
```
aidataengdevtest/
├── n8n/                          # Workflow orchestration
│   ├── Dev Test – AI Data Engineer Role.json  # Complete workflow
│   └── README.md                 # Workflow documentation
├── models/                       # dbt data models
│   └── kpis/                    # KPI calculations
├── resources/                    # Data and visualizations
│   ├── ads_spend.csv            # Source dataset
│   └── kpis.png                 # KPI analysis results
└── README.md                     # This file
```

---

## Part 1 – Data Ingestion (Foundation)

### Dataset Information
- **Source**: `ads_spend.csv`
- **Columns**: date, platform, account, campaign, country, device, spend, clicks, impressions, conversions
- **Download Link**: [Google Drive](https://drive.google.com/file/d/1RXj_3txgmyX2Wyt9ZwM7l4axfi5A6EC-/view)

### Ingestion Solution
**Technology**: N8N + Google BigQuery

**Workflow Components**:
1. **Schedule Trigger**: Automated ingestion every second
2. **HTTP Request**: Downloads CSV from Google Drive
3. **File Extraction**: Parses CSV data
4. **Data Enrichment**: Adds metadata (load_date, source_file_name)
5. **BigQuery Insert**: Loads data into warehouse table

**Metadata Added**:
- `load_date`: ISO timestamp of ingestion
- `source_file_name`: "ads_spend.csv"

**BigQuery Configuration**:
- Project: `demorag-462121`
- Dataset: `DevTestAIDataEngineerRole`
- Table: `ads_spend`

**Benefits**:
- ✅ Automated data pipeline
- ✅ Data provenance tracking
- ✅ Persistent storage in BigQuery
- ✅ Real-time ingestion capabilities

---

## Part 2 – KPI Modeling (SQL)

### KPI Definitions
- **CAC (Customer Acquisition Cost)**: `spend / conversions`
- **ROAS (Return on Ad Spend)**: `(conversions × 100) / spend`

### dbt Models Implementation
**Location**: `models/kpis/`

**Key Models**:
1. **`kpi_metrics.sql`**: Core KPI calculations
2. **`campaign_metrics.sql`**: Campaign-level aggregations
3. **`stg_ads_spend.sql`**: Staging table for source data

### Analysis Results
**Comparison**: Last 30 days vs Prior 30 days

**Results Visualization**: See `resources/kpis.png` && `resources/kpis_table.png` for detailed analysis

**Key Metrics**:
- CAC trends and comparisons
- ROAS performance analysis
- Period-over-period changes
- Absolute values and percentage deltas

**SQL Example**:
```sql
-- KPI calculation with date comparison
SELECT 
    period,
    SAFE_DIVIDE(spend, NULLIF(conversions, 0)) AS cac,
    SAFE_DIVIDE(conversions * 100, NULLIF(spend, 0)) AS roas
FROM (
    SELECT 'last_30' AS period, SUM(spend) AS spend, SUM(conversions) AS conversions
    FROM `demorag-462121.DevTestAIDataEngineerRole.ads_spend`
    WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    UNION ALL
    SELECT 'prev_30' AS period, SUM(spend) AS spend, SUM(conversions) AS conversions
    FROM `demorag-462121.DevTestAIDataEngineerRole.ads_spend`
    WHERE date BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY) 
                  AND DATE_SUB(CURRENT_DATE(), INTERVAL 31 DAY)
)
```

---

## Part 3 – Analyst Access

### Parameterized SQL Script Solution
**Script**: `campaign_metrics.sql` with dbt variables

**Implementation**: dbt model with configurable date parameters

**Usage**:
```bash
# Run with custom date ranges
dbt run --models kpis.campaign_metrics --vars '{"start_date": "2025-06-01", "end_date": "2025-06-28"}'
```

**Features**:
- ✅ Parameterized date ranges via dbt variables
- ✅ Flexible date filtering for analysis
- ✅ CAC and ROAS calculations on-demand
- ✅ Easy integration with existing dbt workflows

---

## Part 4 – Agent Demo (AI-Powered Analysis)

### Natural Language to SQL Conversion
**Question**: "Compare CAC and ROAS for last 30 days vs prior 30 days"

**AI Agent Process**:
1. **Input Processing**: Natural language query analysis
2. **SQL Generation**: GPT-4 powered query creation
3. **Syntax Correction**: Automated SQL validation
4. **Execution**: BigQuery query execution
5. **Analysis**: AI-generated insights in natural language

**Technology Stack**:
- **LangChain Agents**: GPT-4o-mini for query generation
- **OpenAI Models**: GPT-4.1-mini for analysis
- **Memory Management**: Context window optimization

**Example Output**:
> "In the last 30 days, the Customer Acquisition Cost (CAC) was 29.81 and the Return on Ad Spend (ROAS) was 3.35. This represents a 7.6% improvement in CAC and an 8.2% increase in ROAS compared to the previous 30-day period."

---

## Technical Architecture

### Data Flow
```
Google Drive CSV → N8N Workflow → BigQuery → dbt Models → API Endpoints → AI Analysis
```

### Key Technologies
- **Orchestration**: N8N
- **Data Warehouse**: Google BigQuery
- **Data Modeling**: dbt
- **AI/ML**: OpenAI GPT-4, LangChain
- **API**: Node.js/Express
- **Monitoring**: Built-in logging and error handling

### Scalability Features
- **Real-time Processing**: Continuous data ingestion
- **Modular Design**: Separated concerns for easy scaling
- **AI Integration**: Intelligent query generation and analysis
- **Cloud-Native**: BigQuery integration for enterprise scale

---

## Setup Instructions

### Prerequisites
1. **N8N Instance**: Active N8N workflow engine
2. **Google BigQuery**: Project access and credentials
3. **OpenAI API**: GPT-4 models access
4. **Python 3.8+**: For BigQuery operations and dbt
5. **dbt**: For data modeling

### Installation Steps
1. **Clone Repository**:
   ```bash
   git clone [repository](https://github.com/Mgodoyd/Dev-Test-AI-Data-Engineer-Role.git)
   cd aidataengdevtest
   ```

2. **Install Python Dependencies**:
   ```bash   
   # Install dbt
   pip install dbt-bigquery
   ```

3. **Configure Google Cloud Credentials**:
   ```bash
   # Set Google Cloud project
   gcloud config set project demorag-462121
   
   # Authenticate with service account
   export GOOGLE_APPLICATION_CREDENTIALS="service_account.json"
   
   # Verify BigQuery access
   bq ls --project_id=demorag-462121
   ```
   
   **Important**: The `service_account.json` file contains sensitive credentials. 
   - Keep it secure and never commit to version control
   - Ensure proper IAM permissions for BigQuery access
   - The service account needs BigQuery Admin or Data Editor roles
   - The `profiles.yml` file configures dbt connection to BigQuery

4. **Configure Credentials**:
   - Set up Google BigQuery credentials using `service_account.json`
   - Configure OpenAI API keys
   - Update N8N webhook endpoints
   - Verify `profiles.yml` configuration for dbt

5. **Verify BigQuery Connection**:
   ```bash
   # Test BigQuery connection with dbt
   dbt debug --target dev
   
   # This command will validate:
   # - BigQuery connection
   # - Service account authentication
   # - Project and dataset access
   # - Thread configuration
   ```
   
6. **Deploy Workflow**:
   - Import N8N workflow JSON
   - Configure BigQuery connections
   - Activate automated pipeline

7. **Run dbt Models**:
   ```bash
   dbt deps
   dbt debug --target dev
   ```

8. **Execute Specific Models**:
   ```bash
   # Run KPI metrics comparison (last 30 vs prior 30 days)
   dbt run --models kpis.kpi_metrics
   
   # Run campaign metrics with custom date range
   dbt run --models kpis.campaign_metrics --vars '{"start_date": "2025-06-01", "end_date": "2025-06-28"}'
   
   # Run staging model
   dbt run --models kpis.stg_ads_spend
   
   # Test all models
   dbt test --models kpis
   ```

---

## Results and Validation

### Data Persistence
- ✅ Data successfully loaded to BigQuery
- ✅ Metadata tracking functional
- ✅ Refresh operations maintain data integrity

### KPI Calculations
- ✅ CAC and ROAS formulas implemented
- ✅ Date range comparisons working
- ✅ Percentage change calculations accurate

### API Functionality
- ✅ Endpoint responding correctly
- ✅ Parameter validation functional
- ✅ JSON response format correct

### AI Agent Performance
- ✅ Natural language processing working
- ✅ SQL generation accurate
- ✅ Analysis insights valuable

---

## Versión en Español

### Descripción General del Proyecto
Este proyecto demuestra una solución completa de ingeniería de datos para análisis de marketing, implementando ingesta automatizada de datos, modelado de KPIs y análisis impulsado por IA. La solución aborda las cuatro partes de los requisitos de la prueba con un enfoque en escalabilidad, automatización e insights inteligentes.

### Estructura del Proyecto
```
aidataengdevtest/
├── n8n/                          # Orquestación de workflows
│   ├── Dev Test – AI Data Engineer Role.json  # Workflow completo
│   └── README.md                 # Documentación del workflow
├── models/                       # Modelos de datos dbt
│   └── kpis/                    # Cálculos de KPIs
├── resources/                    # Datos y visualizaciones
│   ├── ads_spend.csv            # Dataset fuente
│   └── kpis.png                 # Resultados del análisis de KPIs
└── README.md                     # Este archivo
```

---

## Parte 1 – Ingesta de Datos (Fundación)

### Información del Dataset
- **Fuente**: `ads_spend.csv`
- **Columnas**: date, platform, account, campaign, country, device, spend, clicks, impressions, conversions
- **Enlace de Descarga**: [Google Drive](https://drive.google.com/file/d/1RXj_3txgmyX2Wyt9ZwM7l4axfi5A6EC-/view)

### Solución de Ingesta
**Tecnología**: N8N + Google BigQuery

**Componentes del Workflow**:
1. **Disparador Programado**: Ingesta automatizada cada segundo
2. **Solicitud HTTP**: Descarga CSV desde Google Drive
3. **Extracción de Archivo**: Analiza datos CSV
4. **Enriquecimiento de Datos**: Agrega metadatos (load_date, source_file_name)
5. **Inserción BigQuery**: Carga datos en tabla del warehouse

**Metadatos Agregados**:
- `load_date`: Timestamp ISO de ingesta
- `source_file_name`: "ads_spend.csv"

**Configuración BigQuery**:
- Proyecto: `demorag-462121`
- Dataset: `DevTestAIDataEngineerRole`
- Tabla: `ads_spend`

**Beneficios**:
- ✅ Pipeline de datos automatizado
- ✅ Seguimiento de procedencia de datos
- ✅ Almacenamiento persistente en BigQuery
- ✅ Capacidades de ingesta en tiempo real

---

## Parte 2 – Modelado de KPIs (SQL)

### Definiciones de KPIs
- **CAC (Costo de Adquisición de Clientes)**: `spend / conversions`
- **ROAS (Retorno sobre Gasto en Publicidad)**: `(conversions × 100) / spend`

### Implementación de Modelos dbt
**Ubicación**: `models/kpis/`

**Modelos Clave**:
1. **`kpi_metrics.sql`**: Cálculos principales de KPIs
2. **`campaign_metrics.sql`**: Agregaciones a nivel de campaña
3. **`stg_ads_spend.sql`**: Tabla de staging para datos fuente

### Resultados del Análisis
**Comparación**: Últimos 30 días vs 30 días anteriores

**Visualización de Resultados**: Ver `resources/kpis.png` y `resources/kpis_table.png` para análisis detallado

**Métricas Clave**:
- Tendencias de CAC y comparaciones
- Análisis de rendimiento ROAS
- Cambios período sobre período
- Valores absolutos y deltas porcentuales

**Ejemplo SQL**:
```sql
-- Cálculo de KPI con comparación de fechas
SELECT 
    period,
    SAFE_DIVIDE(spend, NULLIF(conversions, 0)) AS cac,
    SAFE_DIVIDE(conversions * 100, NULLIF(spend, 0)) AS roas
FROM (
    SELECT 'last_30' AS period, SUM(spend) AS spend, SUM(conversions) AS conversions
    FROM `demorag-462121.DevTestAIDataEngineerRole.ads_spend`
    WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    UNION ALL
    SELECT 'prev_30' AS period, SUM(spend) AS spend, SUM(conversions) AS conversions
    FROM `demorag-462121.DevTestAIDataEngineerRole.ads_spend`
    WHERE date BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 60 DAY) 
                  AND DATE_SUB(CURRENT_DATE(), INTERVAL 31 DAY)
)
```

---

## Parte 3 – Acceso para Analistas

### Solución de Script SQL Parametrizado
**Script**: `campaign_metrics.sql` con variables dbt

**Implementación**: Modelo dbt con parámetros de fecha configurables

**Uso**:
```bash
# Ejecutar con rangos de fechas personalizados
dbt run --models kpis.campaign_metrics --vars '{"start_date": "2025-06-01", "end_date": "2025-06-28"}'
```

**Características**:
- ✅ Rangos de fechas parametrizados vía variables dbt
- ✅ Filtrado de fechas flexible para análisis
- ✅ Cálculos CAC y ROAS bajo demanda
- ✅ Fácil integración con workflows dbt existentes

---

## Parte 4 – Demo del Agente (Análisis Impulsado por IA)

### Conversión de Lenguaje Natural a SQL
**Pregunta**: "Compara CAC y ROAS para los últimos 30 días vs los 30 días anteriores"

**Proceso del Agente IA**:
1. **Procesamiento de Entrada**: Análisis de consulta en lenguaje natural
2. **Generación SQL**: Creación de consulta impulsada por GPT-4
3. **Corrección de Sintaxis**: Validación SQL automatizada
4. **Ejecución**: Ejecución de consulta BigQuery
5. **Análisis**: Insights generados por IA en lenguaje natural

**Stack Tecnológico**:
- **Agentes LangChain**: GPT-4o-mini para generación de consultas
- **Modelos OpenAI**: GPT-4.1-mini para análisis
- **Gestión de Memoria**: Optimización de ventana de contexto

**Ejemplo de Salida**:
> "En los últimos 30 días, el Costo de Adquisición de Clientes (CAC) fue 29.81 y el Retorno sobre Gasto en Publicidad (ROAS) fue 3.35. Esto representa una mejora del 7.6% en CAC y un aumento del 8.2% en ROAS comparado con el período de 30 días anterior."

---

## Arquitectura Técnica

### Flujo de Datos
```
CSV Google Drive → Workflow N8N → BigQuery → Modelos dbt → Endpoints API → Análisis IA
```

### Tecnologías Clave
- **Orquestación**: N8N
- **Data Warehouse**: Google BigQuery
- **Modelado de Datos**: dbt
- **IA/ML**: OpenAI GPT-4, LangChain
- **API**: Node.js/Express
- **Monitoreo**: Logging integrado y manejo de errores

### Características de Escalabilidad
- **Procesamiento en Tiempo Real**: Ingesta continua de datos
- **Diseño Modular**: Separación de responsabilidades para fácil escalado
- **Integración IA**: Generación y análisis inteligente de consultas
- **Nativo en la Nube**: Integración BigQuery para escala empresarial

---

## Instrucciones de Configuración

### Prerrequisitos
1. **Instancia N8N**: Motor de workflow N8N activo
2. **Google BigQuery**: Acceso al proyecto y credenciales
3. **API OpenAI**: Acceso a modelos GPT-4
4. **Python 3.8+**: Para operaciones BigQuery y dbt
5. **dbt**: Para modelado de datos
6. **Google Cloud SDK**: Para autenticación y configuración del proyecto

### Pasos de Instalación
1. **Clonar Repositorio**:
   ```bash
   git clone [repositorio](https://github.com/Mgodoyd/Dev-Test-AI-Data-Engineer-Role.git)
   cd aidataengdevtest
   ```

2. **Instalar Dependencias de Python**:
   ```bash
   # Instalar dbt
   pip install dbt-bigquery
   ```

3. **Configurar Credenciales de Google Cloud**:
   ```bash
   # Establecer proyecto de Google Cloud
   gcloud config set project demorag-462121
   
   # Autenticar con cuenta de servicio
   export GOOGLE_APPLICATION_CREDENTIALS="service_account.json"
   
   # Verificar acceso a BigQuery
   bq ls --project_id=demorag-462121
   ```
   
   **Importante**: El archivo `service_account.json` contiene credenciales sensibles. 
   - Manténgalo seguro y nunca lo incluya en control de versiones
   - Asegúrese de tener permisos IAM apropiados para acceso a BigQuery
   - La cuenta de servicio necesita roles de BigQuery Admin o Data Editor
   - El archivo `profiles.yml` configura la conexión de dbt a BigQuery

4. **Configurar Credenciales**:
   - Configurar credenciales de Google BigQuery usando `service_account.json`
   - Configurar claves de API OpenAI
   - Actualizar endpoints de webhook N8N
   - Verificar configuración de `profiles.yml` para dbt

5. **Verificar Conexión BigQuery**:
   ```bash
   # Probar conexión BigQuery con dbt
   dbt debug --target dev
   
   # Este comando validará:
   # - Conexión BigQuery
   # - Autenticación de cuenta de servicio
   # - Acceso al proyecto y dataset
   # - Configuración de hilos
   ```
6. **Desplegar Workflow**:
   - Importar JSON del workflow N8N
   - Configurar conexiones BigQuery
   - Activar pipeline automatizado

7. **Ejecutar Modelos dbt**:
   ```bash
   dbt deps
   dbt debug --target dev
   ```

8. **Ejecutar Modelos Específicos**:
   ```bash
   # Ejecutar métricas de KPI (últimos 30 vs 30 días anteriores)
   dbt run --models kpis.kpi_metrics
   
   # Ejecutar métricas de campaña con rango de fechas personalizado
   dbt run --models kpis.campaign_metrics --vars '{"start_date": "2025-06-01", "end_date": "2025-06-28"}'
   
   # Ejecutar modelo de staging
   dbt run --models kpis.stg_ads_spend
   
   # Probar todos los modelos
   dbt test --models kpis
   ```

---

## Resultados y Validación

### Persistencia de Datos
- ✅ Datos cargados exitosamente a BigQuery
- ✅ Seguimiento de metadatos funcional
- ✅ Operaciones de refresh mantienen integridad de datos

### Cálculos de KPIs
- ✅ Fórmulas CAC y ROAS implementadas
- ✅ Comparaciones de rangos de fechas funcionando
- ✅ Cálculos de cambio porcentual precisos

### Funcionalidad de Scripts Parametrizados
- ✅ Scripts dbt con variables configurables
- ✅ Parámetros de fecha flexibles
- ✅ Ejecución de modelos bajo demanda

### Rendimiento del Agente IA
- ✅ Procesamiento de lenguaje natural funcionando
- ✅ Generación SQL precisa
- ✅ Insights de análisis valiosos


