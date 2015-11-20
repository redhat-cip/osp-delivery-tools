### analyse_heat.sh 

Will show details of all failed resources and make the association between server/IP address.

Usage:
```
[stack@rcip-dev-undercloud ~]$ ./analyse_heat.sh -h
This script allow you to manage the ironic-discovered Swift bucket.

Usage: ./analyse_heat.sh
  -f : Output to file 'deploy-fail-DATE' as well. (default: False)
  -s : Name of the stack to analyze. (default: overcloud)
  -l : Level of depth for the stack. (default: 3)

Think about sourcing your FILErc, this script will NOT do it.
```
Sample truncated output:
```
-------------------------
Resource 03336dc1-a6b2-4066-aa49-45148ac866d8:
{
  "deploy_stdout": "Trying to ping 10.231.132.74 for local network 10.231.132.64/27...SUCCESS\nTrying to ping 10.42.2.18 for local network 10.42.2.0/24...FAILURE\n", 
  "deploy_stderr": "10.42.2.18 is not pingable. Local Network: 10.42.2.0/24\n", 
  "deploy_status_code": 1
}
Server rcip-dev-controller-1 => ctlplane=10.42.1.40
```
