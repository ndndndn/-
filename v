#!/bin/bash
# editor: elang overdosis
# Copyright 2012 (c) elang
# 
# Revisi 1:
# Penambahan config agar proxy menjadi super elite
#   header_access Via deny all
#	header_access Forwarded-For deny all
# 	header_access X-Forwarded-For deny all
# 


function baca_port {
    echo -n "Masukkan port untuk squid: "
    read port

	if [[ "$port" =~ ^[0-9]+$ ]] ; then
		echo "http_port $port transparent" >> /tmp/squid.conf.tmp1
		baca_port_lagi
	else
		echo -e "\e[1;31mInput salah!\e[0m"
		baca_port
	fi
}



function baca_port_lagi {
	echo -n "Masukkan port lain untuk squid atau Ketik \"n\" untuk melanjutkan: "
	read port

	if [[ "$port" =~ ^[0-9]+$ ]] ; then
		echo "http_port $port transparent" >> /tmp/squid.conf.tmp1
		baca_port_lagi
	else
		if [ "$port" = "n" ]; then
			echo -e "\e[1;33mInstalasi squid!\e[0m"
		else
			echo -e "\e[1;31mInput salah!\e[0m"
			baca_port_lagi
		fi
	fi
}

function preinstall_squid {
	DEBIAN_FRONTEND=noninteractive apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -q -y remove --purge squid squid3
	DEBIAN_FRONTEND=noninteractive apt-get -q -y install squid3
	mv /etc/squid3/squid.conf /etc/squid3/squid.conf.bak
	cat > /tmp/squid.conf.tmp2 <<END
cache allow all
via off
httpd_suppress_version_string    on
acl manager proto cache_object
cat > /etc/squid/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
acl SSH dst 128.199.157.230-128.199.157.230/255.255.255.255
acl SSH dst 178.128.18.93-178.128.18.93/255.255.255.255
acl SSH dst 178.128.61.6-178.128.61.6/255.255.255.255
acl SSH dst 159.65.13.145-159.65.13.145/255.255.255.255
acl SSH dst 128.199.111.9-128.199.111.9/255.255.255.255
acl SSH dst 159.65.140.10-159.65.140.10/255.255.255.255
acl SSH dst 178.128.219.61-178.128.219.61/255.255.255.255
acl SSH dst 128.199.198.111-128.199.198.111/255.255.255.255
acl all src 0.0.0.0/0
http_access allow all
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8888
http_port 8080
http_port 8000
http_port 80
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname daybreakersx
END
	
	cat /tmp/squid.conf.tmp2 /tmp/squid.conf.tmp1	> /etc/squid3/squid.conf	
	service squid3 restart 
}


echo "******************************************************************"
echo "*                                                                *"
echo "*                   INSTALLASI SQUID PROXY                            *"
echo "*        HARAP ISI DENGAN BENAR by Elang overdosis                *"
echo "*                                                                *"
echo "******************************************************************"

echo ""
echo ""

baca_port
preinstall_squid
