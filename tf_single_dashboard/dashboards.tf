provider "newrelic" {
  api_key = "<'ADMIN_KEY'>"
}

resource "newrelic_dashboard" "tf_dashboard_as_code" {
  title = "Observability : Dashboards as Code (Simple)"

  widget {
    title         = "Average Transaction Duration by Appname"
    row           = 1
    column        = 1
    width         = 3
    visualization = "faceted_line_chart"
    nrql          = "SELECT average(duration) from Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago"
  }

  widget {
    title         = "Throughput Per Hour by Appname"
    row           = 2
    column        = 1
    width         = 3
    visualization = "faceted_line_chart"
    nrql          = "SELECT rate(count(*), 1 hour) FROM Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago"
  }
}

output "dashboard_id" {
  value = "${newrelic_dashboard.tf_dashboard_as_code.id}"
}