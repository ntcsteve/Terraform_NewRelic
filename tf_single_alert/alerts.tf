provider "newrelic" {
  api_key = "REPLACE HERE"
  admin_api_key = "REPLACE HERE"
  account_id = "REPLACE HERE"
  region = "REPLACE HERE"
}

# Use this data source to get information about a specific entity in New Relic that already exists. 
# https://www.terraform.io/docs/providers/newrelic/d/entity.html
data "newrelic_entity" "app_name" {
  name = "REPLACE HERE" # Note: This must be an exact match of your app name in New Relic (Case sensitive)
  type = "APPLICATION"
  domain = "APM"
}

# Create an alert policy
resource "newrelic_alert_policy" "tf_alert_policy_as_code" {
  name = "Observability : Alerts as Code (Simple)"
  incident_preference = "PER_POLICY" # PER_POLICY is default
}

# Add an alert condition
resource "newrelic_alert_condition" "tf_alert_condition_as_code" {
  policy_id = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"

  name        = "My First Alert as Code"
  type        = "apm_app_metric"
  entities    = [data.newrelic_entity.app_name.application_id]
  metric      = "apdex"
  runbook_url = "REPLACE HERE"

  # condition_scope - (Required for some types) application or instance. 
  # Choose application for most scenarios. If you are using the JVM plugin in New Relic, the instance setting allows your condition to trigger for specific app instances. 
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
  name = "REPLACE HERE"
  type = "email"

  config {
    recipients              = "REPLACE HERE"
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

output "alert_id" {
  value = "${newrelic_alert_policy.tf_alert_policy_as_code.id}"
}