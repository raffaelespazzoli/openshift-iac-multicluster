## Active / Active  -- Round robin

```sh
watch curl -sv httpbin.apps.global.practice.redhat.com/ip
watch dig httpbin.apps.global.practice.redhat.com
```
scale up and down.


## Active / Passive with failover

```shell
watch curl -sv httpbin-ap.apps.global.practice.redhat.com/ip
watch dig httpbin-ap.apps.global.practice.redhat.com
```

scale up and down.

## Active / Active with weighted lb -- Blue Gree releases


```shell
watch curl -sv httpbin-bg.apps.global.practice.redhat.com/ip
watch dig httpbin-bg.apps.global.practice.redhat.com
```

scale up and down.