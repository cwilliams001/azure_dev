[azure_vms]
%{ for ip in ips ~}
${ip}
%{ endfor ~}
