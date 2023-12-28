[all]
%{ for host in dbs ~}
${host.name} ansible_host=${host.default_ipv4_address}
%{ endfor ~}
%{ for host in bes ~}
${host.name} ansible_host=${host.default_ipv4_address}
%{ endfor ~}
%{ for host in lbs ~}
${host.name} ansible_host=${host.default_ipv4_address}
%{ endfor ~}

[dbs]
%{ for host in dbs ~}
${host.name}
%{ endfor ~}

[bes]
%{ for host in bes ~}
${host.name}
%{ endfor ~}

[lbs]
%{ for host in lbs ~}
${host.name}
%{ endfor ~}

[bes:vars]
srv_name=wordpress