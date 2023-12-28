
[dbs]
%{ for i, host in dbs ~}
${dbs[i].hostname} ansible_host=${dbs[i].network[0].ip}
%{ endfor ~}

[bes]
%{ for i, host in bes ~}
${bes[i].hostname} ansible_host=${bes[i].network[0].ip}
%{ endfor ~}

[lbs]
%{ for i, host in lbs ~}
${lbs[i].hostname} ansible_host=${lbs[i].network[0].ip}
%{ endfor ~}

[bes:vars]
srv_name=wordpress