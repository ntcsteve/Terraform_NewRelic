variable "nr_api_key" {

  # Please use your New Relic Admin API Key
  # Link > https://docs.newrelic.com/docs/apis/get-started/intro-apis/types-new-relic-api-keys#admin

  default = "<'ADMIN_KEY'>"
}

variable "nr_apm_app" {

  # Please use your application name as stated in your config file
  # Link > https://docs.newrelic.com/docs/agents/manage-apm-agents/app-naming/name-your-application#assigning
  
  default = "<'APM_APPNAME'>"
}

variable "nr_alert_email" {

  # Please use your designated email channel
  # Link > https://docs.newrelic.com/docs/alerts/new-relic-alerts/managing-notification-channels/notification-channels-control-where-send-alerts#channel-types
  
  default = "<'EMAIL'>"
}