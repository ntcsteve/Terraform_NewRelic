# Configure the New Relic provider
provider "newrelic" {
  api_key = "${var.nr_api_key}"
  admin_api_key = "${var.nr_admin_api_key}"
  account_id = "${var.nr_account_id}"
  region = "${var.nr_region}"
}

# Use this data source to get information about a specific entity in New Relic that already exists. 
data "newrelic_entity" "app_name" {
  name = "${var.nr_apm_app}"
  type = "APPLICATION"
  domain = "APM"
}

# Configure the New Relic dashboard
resource "newrelic_dashboard" "tf_dashboard_as_code" {
  title = "Observability : Dashboards as Code (Example)"
  editable = "read_only"

  widget {
    title         = "Transaction Response Time by Appname"
    row           = 1
    column        = 1
    width         = 3
    visualization = "faceted_line_chart"
    nrql          = "SELECT average(duration) from Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago EXTRAPOLATE"
  }

  widget {
    title         = "Throughput Per Hour by Appname"
    row           = 2
    column        = 1
    width         = 3
    visualization = "faceted_line_chart"
    nrql          = "SELECT rate(count(*), 1 hour) FROM Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago EXTRAPOLATE"
  }

    widget {
    title         = "Error by Appname"
    row           = 3
    column        = 1
    width         = 3
    visualization = "faceted_line_chart"
    nrql          = "SELECT percentage(count(*), WHERE error is true) FROM Transaction FACET appName TIMESERIES 1 hour SINCE 1 week ago EXTRAPOLATE"
  }
}

# Create an alert policy
resource "newrelic_alert_policy" "tf_alert_policy_as_code" {
  name = "Observability : Alerts as Code (Example)"
  incident_preference = "PER_POLICY"
}

# Add an alert condition
resource "newrelic_alert_condition" "tf_alert_condition_as_code" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name        = "My First Alert as Code"
  type        = "apm_app_metric"
  entities    = [data.newrelic_entity.app_name.application_id] 
  metric      = "apdex"
  runbook_url = "https://docs.example.com/my-runbook" 
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
  policy_id  = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"
  channel_ids = [
    "${newrelic_alert_channel.tf_alert_email.id}"
  ]
}