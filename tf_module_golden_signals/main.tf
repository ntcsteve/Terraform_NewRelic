# Configure the New Relic provider
provider "newrelic" {
  api_key       = "${var.nr_api_key}"
  admin_api_key = "${var.nr_admin_api_key}"
  account_id    = "${var.nr_account_id}"
  region        = "${var.nr_region}"
}

# Use this data source to get information about a specific entity in New Relic that already exists. 
data "newrelic_entity" "app_name" {
  name   = "${var.nr_apm_app}"
  type   = "APPLICATION"
  domain = "APM"
}

# Configure the New Relic dashboard
resource "newrelic_dashboard" "tf_dashboard_as_code" {
  title    = "Observability : Dashboards as Code (Golden_Signals)"
  editable = "read_only"

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
    visualization = "billboard_comparison"
    nrql          = "SELECT average(databaseDuration) as 'Database AVG' FROM Transaction SINCE 1 day ago COMPARE WITH 1 day ago"
  }
}

# Create the New Relic alert policy
resource "newrelic_alert_policy" "tf_alert_policy_as_code" {
  name                = "Observability : Alerts as Code (Golden_Signals)"
  incident_preference = "PER_POLICY"
}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_200" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name            = "Golden Signals Latency - HTTP 200"
  runbook_url     = "https://docs.example.com/my-runbook"
  enabled         = true
  description     = "Alert when transactions are taking too long"
  type            = "static"
  value_function  = "single_value"
  violation_time_limit = "one_hour"

  critical {
    operator              = "above"
    threshold             = 4
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  nrql {
    query             = "SELECT percentile(totalTime, 95) FROM Transaction WHERE httpResponseCode = '200'"
    evaluation_offset = 3
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_500" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name            = "Golden Signals Latency - HTTP 500"
  runbook_url     = "https://docs.example.com/my-runbook"
  enabled         = true
  description     = "Alert when transactions are taking too long"
  type            = "static"
  value_function  = "single_value"
  violation_time_limit = "one_hour"

  critical {
    operator              = "above"
    threshold             = 4
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  nrql {
    query             = "SELECT percentile(totalTime, 95) FROM Transaction WHERE httpResponseCode = '500'"
    evaluation_offset = 3
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_3XX" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name            = "Golden Signals Errors - HTTP 3xx"
  runbook_url     = "https://docs.example.com/my-runbook"
  enabled         = true
  type            = "static"
  value_function  = "single_value"
  violation_time_limit = "one_hour"

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  nrql {
    query             = "SELECT count(*) FROM Transaction WHERE httpResponseCode LIKE '3%'"
    evaluation_offset = 3
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_4XX" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name            = "Golden Signals Errors - HTTP 4xx"
  runbook_url     = "https://docs.example.com/my-runbook"
  enabled         = true
  type            = "static"
  value_function  = "single_value"
  violation_time_limit = "one_hour"

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  nrql {
    query             = "SELECT count(*) FROM Transaction WHERE httpResponseCode LIKE '4%'"
    evaluation_offset = 3
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_HTTP_5XX" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name            = "Golden Signals Error - HTTP 5xx"
  runbook_url     = "https://docs.example.com/my-runbook"
  enabled         = true
  type            = "static"
  value_function  = "single_value"
  violation_time_limit = "one_hour"

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  nrql {
    query             = "SELECT count(*) FROM Transaction WHERE httpResponseCode LIKE '5%'"
    evaluation_offset = 3
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_Throughput" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name            = "Golden Signals Traffic - Throughput Per Minute"
  runbook_url     = "https://docs.example.com/my-runbook"
  enabled         = true
  type            = "static"
  value_function  = "single_value"
  violation_time_limit = "one_hour"

  critical {
    operator              = "above"
    threshold             = 300
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  nrql {
    query             = "SELECT rate(count(*), 1 minute) FROM Transaction"
    evaluation_offset = 3
  }

}

# Add a condition
resource "newrelic_nrql_alert_condition" "alert_Saturation_DB" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name            = "Golden Signals Saturation - Database"
  runbook_url     = "https://docs.example.com/my-runbook"
  enabled         = true
  type            = "static"
  value_function  = "single_value"
  violation_time_limit = "one_hour"

  critical {
    operator              = "above"
    threshold             = 4
    threshold_duration    = 120
    threshold_occurrences = "at_least_once"
  }

  nrql {
    query             = "SELECT average(databaseDuration) FROM Transaction"
    evaluation_offset = 3
  }
}

# Add a notification channel
resource "newrelic_alert_channel" "tf_alert_email" {
  name = "${var.nr_alert_email}"
  type = "email"

  config {
    recipients              = "${var.nr_alert_email}"
    include_json_attachment = "1"
  }
}

# Link the above notification channel to your policy
resource "newrelic_alert_policy_channel" "tf_alert_email" {
  policy_id   = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"
  channel_ids = [
    "${newrelic_alert_channel.tf_alert_email.id}"
  ]
}