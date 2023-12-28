
[dbs]
%{ for host in dbs ~}
${host.name} ansible_host=${host.default_ipv4_address}
%{ endfor ~}

[bes]
%{ for host in bes ~}
${host.name} ansible_host=${host.default_ipv4_address}
%{ endfor ~}

[lbs]
%{ for host in lbs ~}
${host.name} ansible_host=${host.default_ipv4_address}
%{ endfor ~}

[bes:vars]
srv_name=wordpress