# Configure the New Relic provider
provider "newrelic" {
  api_key = "${var.nr_api_key}"
}

# Configure the New Relic datasource
data "newrelic_application" "app" {
  name = "${var.nr_apm_app}"
}

# Configure the New Relic dashboard
resource "newrelic_dashboard" "tf_dashboard_as_code" {
  title = "Observability : Dashboards as Code (Golden_Signals)"

  widget {
    title         = "Golden Signals Latency - HTTP 200"
    row           = 1
    column        = 1
    width         = 2
    visualization = "line_chart"
    nrql          = "SELECT percentile(totalTime, 50, 90, 95) FROM Transaction WHERE httpResponseCode = '200' SINCE 1 day ago TIMESERIES 1 hour EXTRAPOLATE"
  }

  widget {
    title         = "Golden Signals Traffic - Throughput Per Minute"
    row           = 1
    column        = 3
    visualization = "billboard"
    nrql          = "SELECT rate(count(*), 1 minute) AS 'Requests per Minute' FROM Transaction since 1 day ago"
  }

  widget {
    title         = "Golden Signals Errors - HTTP 3xx, 4xx & 5xx"
    row           = 2
    column        = 1
    width         = 2
    visualization = "line_chart"
    nrql          = "SELECT filter(count(*), WHERE httpResponseCode LIKE '3%' as '3xx'), filter(count(*), WHERE httpResponseCode LIKE '4%' as '4xx'), filter(count(*), WHERE httpResponseCode LIKE '5%' as '5xx') FROM Transaction SINCE 1 day ago TIMESERIES 10 minutes EXTRAPOLATE"
  }

  widget {
    title         = "Golden Signals Saturation - Database"
    row           = 2
    column        = 3
    visualization = "billboard"
    nrql          = "SELECT average(databaseDuration) as 'Database AVG' FROM Transaction SINCE 1 day ago"
  }
}

# Create the New Relic alert policy
resource "newrelic_alert_policy" "tf_alert_as_code" {
  name = "Observability : Alerts as Code (Golden_Signals)"
}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_200" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "Golden Signals Latency - HTTP 200"
  runbook_url = "https://docs.example.com/my-runbook"
  enabled     = true

  term {
    duration      = 3
    operator      = "above"
    priority      = "critical"
    threshold     = "4"
    time_function = "all"
  }

  nrql {
    query       = "SELECT percentile(totalTime, 95) FROM Transaction WHERE httpResponseCode = '200'"
    since_value = "1"
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_500" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "Golden Signals Latency - HTTP 500"
  runbook_url = "https://docs.example.com/my-runbook"
  enabled     = true

  term {
    duration      = 3
    operator      = "above"
    priority      = "critical"
    threshold     = "6"
    time_function = "all"
  }

  nrql {
    query       = "SELECT percentile(totalTime, 95) FROM Transaction WHERE httpResponseCode = '500'"
    since_value = "1"
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_3XX" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "Golden Signals Errors - HTTP 3xx"
  runbook_url = "https://docs.example.com/my-runbook"
  enabled     = true

  term {
    duration      = 3
    operator      = "above"
    priority      = "critical"
    threshold     = "100"
    time_function = "all"
  }

  nrql {
    query       = "SELECT count(*) FROM Transaction WHERE httpResponseCode LIKE '3%'"
    since_value = "1"
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_4XX" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "Golden Signals Errors - HTTP 4xx"
  runbook_url = "https://docs.example.com/my-runbook"
  enabled     = true

  term {
    duration      = 3
    operator      = "above"
    priority      = "critical"
    threshold     = "100"
    time_function = "all"
  }

  nrql {
    query       = "SELECT count(*) FROM Transaction WHERE httpResponseCode LIKE '4%'"
    since_value = "1"
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_5XX" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "Golden Signals Error - HTTP 5xx"
  runbook_url = "https://docs.example.com/my-runbook"
  enabled     = true

  term {
    duration      = 3
    operator      = "above"
    priority      = "critical"
    threshold     = "100"
    time_function = "all"
  }

  nrql {
    query       = "SELECT count(*) FROM Transaction WHERE httpResponseCode LIKE '5%'"
    since_value = "1"
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_Throughput" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "Golden Signals Traffic - Throughput Per Minute"
  runbook_url = "https://docs.example.com/my-runbook"
  enabled     = true

  term {
    duration      = 3
    operator      = "above"
    priority      = "critical"
    threshold     = "100"
    time_function = "all"
  }

  nrql {
    query       = "SELECT rate(count(*), 1 minute) FROM Transaction"
    since_value = "1"
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_Saturation_DB" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "Golden Signals Saturation - Database"
  runbook_url = "https://docs.example.com/my-runbook"
  enabled     = true

  term {
    duration      = 3
    operator      = "above"
    priority      = "critical"
    threshold     = "2"
    time_function = "all"
  }

  nrql {
    query       = "SELECT average(databaseDuration) FROM Transaction"
    since_value = "1"
  }
}

# Add a notification channel
resource "newrelic_alert_channel" "email" {
  name = "email"
  type = "email"

  configuration = {
    recipients              = "${var.nr_alert_email}"
    include_json_attachment = "1"
  }
}

# Link the channel to the policy
resource "newrelic_alert_policy_channel" "alert_email" {
  policy_id  = "${newrelic_alert_policy.tf_alert_as_code.id}"
  channel_id = "${newrelic_alert_channel.email.id}"
}