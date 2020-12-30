## usecase
The concern is documenting issues around AWS collector SSL certification management

### 1. 23846 and new custom cname

* Create CNAME record for the collector domain of your choice
* let us know what that will be so that we could set up monitoring for you

### 2. cert upload
* login to the AWS sub-account with ID `$clientAWSid`
* use the correct region
* open ACM

<https://eu-west-1.console.aws.amazon.com/acm/home?region=eu-west-1#/>

* select _Import a certificate_

#### 2.1. different sections of a cert
* Body: Will be a single public certificate block
* Private key: Is your secure private certificate key
    * upload the public chain certificates with your public and private keys. Do not send those directly to us.
* Chain: Will be your body certificate followed by the public chain certificates

#### 2.2. differentiation with headers
Note: You can differentiate between public and private by the surrounding headers on the key:

```
-----BEGIN RSA PRIVATE KEY-----

OR

-----BEGIN CERTIFICATE-----
```

#### 2.3. ARN
* after certificate import, let us know what ARN the certificate has 
* we attach this ARN to the loadbalancer, which sits in front of your collector/s
* When uploading the SSL certificate make sure to
    * use the correct account id 

```
arn:aws:acm:eu-west-1:111111111:certificate/1111-1111-1111-1111-11111
```

* consul key to update the `ARN`

```
https://consul.snplow.net/ui/eu-central-1/kv/customer/$CUSTOMER/aws_rt_pipeline_prod1/input/collector/custom_cert_arn/edit
```

### 3. sources
* [Amazon Resource Names (ARNs) - AWS General Reference](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)
* [GDPR: Deleting customer data from Redshift [tutorial] - GDPR - Discourse – Snowplow](https://discourse.snowplowanalytics.com/t/gdpr-deleting-customer-data-from-redshift-tutorial/1815)
* [Managing Certificates with AWS Certificate Manager — Pluralsight](https://app.pluralsight.com/library/courses/aws-certificate-manager-managing-certificates/table-of-contents)
* [Snowplow - Agent](https://snowplow.zendesk.com/agent/tickets/24393)