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
  title = "Observability : Dashboards as Code (Example)"

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

# Create the New Relic alert policy
resource "newrelic_alert_policy" "tf_alert_as_code" {
  name = "Observability : Alerts as Code (Example)"
}

# Add a condition
resource "newrelic_alert_condition" "alert" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "My First Alert as Code"
  type        = "apm_app_metric"

  # New Relic APM ID will be generated once it's registered successfully
  # Retrieve the right entities from the New Relic datasource

  entities    = ["${data.newrelic_application.app.id}"] 
  metric      = "apdex"
  runbook_url = "https://docs.example.com/my-runbook"

  # Configure the right condition scope
  # Link > https://docs.newrelic.com/docs/alerts/rest-api-alerts/new-relic-alerts-rest-api/alerts-conditions-api-field-names#condition-scope
  
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "below"
    priority      = "critical"
    threshold     = "0.75"
    time_function = "all"
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