
[dbs]
%{ for host in dbs ~}
${host.hostname} ansible_host=${host.network[0].ip}
%{ endfor ~}

[bes]
%{ for i, host in bes ~}
${host.hostname} ansible_host=${bhost.network[0].ip}
%{ endfor ~}

[lbs]
%{ for i, host in lbs ~}
${host.hostname} ansible_host=${host.network[0].ip}
%{ endfor ~}

[bes:vars]
srv_name=wordpress