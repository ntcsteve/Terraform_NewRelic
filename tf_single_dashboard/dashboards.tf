provider "newrelic" {
  api_key = "REPLACE HERE"
  admin_api_key = "REPLACE HERE"
  account_id = "REPLACE HERE"
  region = "REPLACE HERE"
}

resource "newrelic_dashboard" "tf_dashboard_as_code" {
  title = "Observability : Dashboards as Code (Simple)"
  editable = "read_only"

  widget {
    title         = "Transaction Response Time by Appname"
    row           = 1
    column        = 1
    width         = 3

    # visualization - (Required) How the widget visualizes data. 
    # Valid values are billboard, gauge, billboard_comparison, facet_bar_chart, faceted_line_chart, facet_pie_chart, facet_table, faceted_area_chart, heatmap, attribute_sheet, single_event, histogram, funnel, raw_json, event_feed, event_table, uniques_list, line_chart, comparison_line_chart, markdown, and metric_line_chart. 
    visualization = "faceted_line_chart"

    # NRQL is a query language you can use to query the New Relic database. This document explains NRQL syntax, clauses, components, and functions.
    # https://docs.newrelic.com/docs/query-data/nrql-new-relic-query-language/getting-started/nrql-syntax-clauses-functions
    nrql          = "SELECT average(duration) from Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago EXTRAPOLATE"
  }

  widget {
    title         = "Throughput Per Hour by Appname"
    row           = 2
    column        = 1
    width         = 3

    # visualization - (Required) How the widget visualizes data. 
    # Valid values are billboard, gauge, billboard_comparison, facet_bar_chart, faceted_line_chart, facet_pie_chart, facet_table, faceted_area_chart, heatmap, attribute_sheet, single_event, histogram, funnel, raw_json, event_feed, event_table, uniques_list, line_chart, comparison_line_chart, markdown, and metric_line_chart. 
    visualization = "faceted_line_chart"

    # NRQL is a query language you can use to query the New Relic database. This document explains NRQL syntax, clauses, components, and functions.
    # https://docs.newrelic.com/docs/query-data/nrql-new-relic-query-language/getting-started/nrql-syntax-clauses-functions
    nrql          = "SELECT rate(count(*), 1 hour) FROM Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago EXTRAPOLATE"
  }

    widget {
    title         = "Error by Appname"
    row           = 3
    column        = 1
    width         = 3

    # visualization - (Required) How the widget visualizes data. 
    # Valid values are billboard, gauge, billboard_comparison, facet_bar_chart, faceted_line_chart, facet_pie_chart, facet_table, faceted_area_chart, heatmap, attribute_sheet, single_event, histogram, funnel, raw_json, event_feed, event_table, uniques_list, line_chart, comparison_line_chart, markdown, and metric_line_chart. 
    visualization = "faceted_line_chart"

    # NRQL is a query language you can use to query the New Relic database. This document explains NRQL syntax, clauses, components, and functions.
    # https://docs.newrelic.com/docs/query-data/nrql-new-relic-query-language/getting-started/nrql-syntax-clauses-functions
    nrql          = "SELECT percentage(count(*), WHERE error is true) FROM Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago EXTRAPOLATE"
  }
}

output "dashboard_id" {
  value = "${newrelic_dashboard.tf_dashboard_as_code.id}"
}