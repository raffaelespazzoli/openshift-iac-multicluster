## Active / Active  -- Round robin

```sh
watch curl httpbin.apps.global.practice.redhat.com/get
watch dig httpbin.apps.global.practice.redhat.com
```
scale up and down.


## Active / Passive with failover

```shell
watch curl httpbin-ap.apps.global.practice.redhat.com/get
watch dig httpbin-ap.apps.global.practice.redhat.com
```

scale up and down.

## Active / Active with weighted lb -- Blue Gree releases


```shell
watch curl httpbin-bg.apps.global.practice.redhat.com/get
watch dig httpbin-bg.apps.global.practice.redhat.com
```

scale up and down.