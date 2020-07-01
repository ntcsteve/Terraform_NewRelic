variable "nr_api_key" {

  # Locate your Personal API key by following New Relic's Personal API key docs.
  # Link > https://docs.newrelic.com/docs/apis/get-started/intro-apis/types-new-relic-api-keys#personal-api-key
  default = "REPLACE HERE"
}

variable "nr_admin_api_key" {

  # Locate your Admin's API key by following New Relic's Admin API key docs.
  # Link > https://docs.newrelic.com/docs/apis/get-started/intro-apis/types-new-relic-api-keys#admin
  default = "REPLACE HERE"

}

variable "nr_account_id" {

  # When you're signed into your account, the account ID is found in the URL after /accounts/
  # Link > https://docs.newrelic.com/docs/accounts/install-new-relic/account-setup/account-id
  default = "REPLACE HERE"

}

variable "nr_region" {

  # Locate your New Relic's global data hosting region
  # Link > https://docs.newrelic.com/docs/using-new-relic/welcome-new-relic/get-started/our-eu-us-region-data-centers
  default = "REPLACE HERE"

}

variable "nr_apm_app" {

  # Please use your application name as stated in your config file
  # Link > https://docs.newrelic.com/docs/agents/manage-apm-agents/app-naming/name-your-application#assigning
  default = "REPLACE HERE"
}

variable "nr_alert_email" {

  # Please use your designated email channel
  # Link > https://docs.newrelic.com/docs/alerts/new-relic-alerts/managing-notification-channels/notification-channels-control-where-send-alerts#channel-types
  default = "REPLACE HERE"
}