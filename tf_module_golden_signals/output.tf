output "apm_app_id" {

  # newrelic_application Terraform reference 
  # Link : https://www.terraform.io/docs/providers/newrelic/d/application.html

  value = "${data.newrelic_application.app.id}"
}

output "apm_dashboard_id" {

  # newrelic_dashboard Terraform reference
  # Link : https://www.terraform.io/docs/providers/newrelic/r/dashboard.html

  value = "${newrelic_dashboard.tf_dashboard_as_code.id}"
}

output "apm_alert_id" {

  # newrelic_alert_policy Terraform reference
  # Link : https://www.terraform.io/docs/providers/newrelic/r/alert_policy.html
  
  value = "${newrelic_alert_policy.tf_alert_as_code.id}"
}