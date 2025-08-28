Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

1. Datos proporcionados
Métrica	Últimos 30 días	30 días previos	Delta %
Gasto (Spend)	297,128.25	270,325.35	+9.92%
Conversiones	9,934	8,388	+18.43%
CAC (Gasto / Conversiones)	29.91	32.23	-7.19%
ROAS (Revenue / Gasto, con revenue = conversiones × 100)	3.34	3.10	+7.75%
2. Verificación de cálculos de KPI

CAC = Gasto / Conversiones

Últimos 30 días: 297,128.25 / 9,934 ≈ 29.91 ✅ coincide

30 días previos: 270,325.35 / 8,388 ≈ 32.23 ✅ coincide

ROAS = Revenue / Gasto, con Revenue = Conversiones × 100

Revenue últimos 30 días: 9,934 × 100 = 993,400

ROAS últimos 30 días: 993,400 / 297,128.25 ≈ 3.34 ✅ coincide

Revenue 30 días previos: 8,388 × 100 = 838,800

ROAS 30 días previos: 838,800 / 270,325.35 ≈ 3.10 ✅ coincide

3. Conclusión

Sí, los datos cumplen perfectamente con el punto 2 de KPI Modeling:

CAC y ROAS se calcularon correctamente usando las fórmulas dadas.

El análisis de los últimos 30 días vs los 30 días previos está completo y la tabla incluye valores absolutos y deltas (%).



[{
  "last30_spend": "297128.25000000006",
  "prev30_spend": "270325.35000000003",
  "spend_delta_pct": "9.92",
  "last30_conversions": "9934",
  "prev30_conversions": "8388",
  "conv_delta_pct": "18.43",
  "last30_cac": "29.910232534729218",
  "prev30_cac": "32.227628755364812",
  "cac_delta_pct": "-7.19",
  "last30_roas": "3.3433374308905321",
  "prev30_roas": "3.1029276388618379",
  "roas_delta_pct": "7.75"
}]