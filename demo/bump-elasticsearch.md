## usecase
The doc's aim is instructing through the scaling of ES cluster

<!-- TOC -->

- [1. add volume size](#1-add-volume-size)
    - [1.1. example: ca.bc.gov-prod1 150 → 200 GB; 2 nodes; r5.large.elasticsearch](#11-example-cabcgov-prod1-150-→-200-gb-2-nodes-r5largeelasticsearch)
- [2. sources](#2-sources)

<!-- /TOC -->

### 1. add volume size
* check type in grafana
* check if addition of volume is applicable
* add volume by estimate - the key equals to node volume
* deploy

```
@Snowdroid deploy stacks/apply_last 0.1.0 true for ca_bc.gov-prod1 aws_elasticsearch
@Snowdroid deploy stacks/apply_last 0.1.0 false for ca_bc.gov-prod1 aws_elasticsearch
```

#### 1.1. example: ca.bc.gov-prod1 150 → 200 GB; 2 nodes; r5.large.elasticsearch

* the deploy job takes ~ 10 minutes
* the number of nodes doubles during the resize

![change_node_size_visualized](../assets/img002391.jpg)


### 2. sources
* [Elasticsearch Cluster Disk Space Alerts - Support Engineering - Confluence](https://snplow.atlassian.net/wiki/spaces/SE/pages/1052213325/Elasticsearch+Cluster+Disk+Space+Alerts)