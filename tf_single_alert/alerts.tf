provider "newrelic" {
  api_key = "<'ADMIN_KEY'>""
}

# Create an alert policy
resource "newrelic_alert_policy" "tf_alert_as_code" {
  name = "Observability : Alerts as Code (Simple)"
}

# Add a condition
resource "newrelic_alert_condition" "alert" {
  policy_id = "${newrelic_alert_policy.tf_alert_as_code.id}"

  name        = "My First Alert as Code"
  type        = "apm_app_metric"
  entities    = ["<'APM_APPNAME'>"] # You can look this up in New Relic
  metric      = "apdex"
  runbook_url = "https://docs.example.com/my-runbook"

  # https://docs.newrelic.com/docs/alerts/rest-api-alerts/new-relic-alerts-rest-api/alerts-conditions-api-field-names#condition-scope
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
    recipients              = "<'EMAIL'>"
    include_json_attachment = "1"
  }
}

# Link the channel to the policy
resource "newrelic_alert_policy_channel" "alert_email" {
  policy_id  = "${newrelic_alert_policy.tf_alert_as_code.id}"
  channel_id = "${newrelic_alert_channel.email.id}"
}

output "alert_id" {
  value = "${newrelic_alert_policy.tf_alert_as_code.id}"
}