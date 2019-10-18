## Observability as Code with Terraform and New Relic

#### Technical Overview

This is a consolidated best practice guide available for anyone who is interested to use Terraform with New Relic.

It’s possible to treat configurations as code with New Relic, called “**Observability as code**”, adopting infrastructure as code for your monitoring and alerting environment.

These materials were prepared as part of my technical talk at DevOps Days 2019 (Taiwan). Further details about implementating Terraform with New Relic can be found in the **Terraform and New Relic Best Practice Guide** and the **Additional Links** section. 

#### Recommended steps to start with Terraform and New Relic

1. Start by exploring available online resources. 
2. Review your existing deployment pipeline.
3. Determine which dynamic variables that you can pass into Terraform.
4. Work through the design considerations with Terraform and New Relic.
5. Experiment with a one simple Terraform module before adding more.
6. Consider implementing contextual application metadata for better observability.

#### Recomended modules to start with Terraform and New Relic

1. Small modules = tf_single_alert & tf_single_dashboard 
2. tf_single_alert + tf_single_dashboard = tf_module_examples
3. Complex modules based on Google SRE 4 Golden Signals = tf_module_golden_signals

## Notes

The provided tf files **WILL NOT** work out of the box. 

Please replace the following: 
- <'ADMIN_KEY'> with your New Relic admin API key
- <'APM_APPNAME'> with your designated application name
- <'EMAIL'> with your preferred email address

Many [Terraform recommeded practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html) are applicable especially when it comes to encrypting [New Relic Admin API keys](https://www.terraform.io/docs/state/sensitive-data.html). 

Please review your Terraform deployment pipeline and decide the best method for production. With my environment, I used [Terraform Cloud](https://app.terraform.io) to encrypt senstive data in the UI. 

## Addtional Links

[DevOps Days 2019 (Taiwan) Presentation - Mandarin](https://www.dropbox.com/s/iqbm5qo363rzp89/Observability%20as%20Code%20%28DevOps%20Days%20TW%202019%29%20Traditional%20Mandarin.pdf?dl=0)

DevOps Days 2019 (Taiwan) Presentation - English - Coming Soon

[Terraform and New Relic Best Practice Guide](https://www.dropbox.com/s/yp2tq72et0rrf7n/Terraform%20with%20New%20Relic%20Best%20Practices.pdf?dl=0)

[Modular Infrastructure Deployments at New Relic with Terraform](https://www.hashicorp.com/resources/modular-infrastructure-deployments-new-relic-terraform)