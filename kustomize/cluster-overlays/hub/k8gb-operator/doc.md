this is the configuration for the zone delegation for this particular setup:

```
161 ; Below is what k8gb zone delegation needs Start    
162 ; glue records for global zone delegation    
163 gslb-ns-pool4-apps-global   IN      A      10.1.196.100    
164 gslb-ns-hub-apps-global    IN      A      10.1.196.111    
165    
166 ; zone delegation for global subdomain    
167 $ORIGIN         global.practice.redhat.com.    
168 $TTL 1H    
169 @             IN      NS     gslb-ns-here-apps-global.practice.redhat.com.    
170 @             IN      NS     gslb-ns-there-apps-global.practice.redhat.com.    
171 @             IN      NS     gslb-ns-pool4-apps-global.practice.redhat.com.    
172 @             IN      NS     gslb-ns-hub-apps-global.practice.redhat.com.    
173    174 ; Above is what k8gb zone delegation needs End
 ```   