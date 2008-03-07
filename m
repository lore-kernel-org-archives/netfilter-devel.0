From: pedro noticioso <cucnews@yahoo.com>
Subject: Re: transparent proxy per client
Date: Fri, 7 Mar 2008 12:56:59 -0800 (PST)
Message-ID: <720441.90317.qm@web55410.mail.re4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web55410.mail.re4.yahoo.com ([206.190.58.204]:42514 "HELO
	web55410.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757991AbYCGU5B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:57:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi there, I am picking up on someone elses work. he
left the company on negative terms I am not even aware
of, but now I have been given this job and have
stumbled on a brick wall here, believe it or not, this
firewall script, has no transparent proxy rule, but
users are being sent to squid! the FORWARD rule is
used to bypass squid for the bosses, please help me
analyze how this script works and why, since it is an
awesome solution that allows the use of so.called
transparent proxy plus authentication at the same
time.

The problem with this script is that, it currently
does not allow users from inside a nerwork access to a
hosted email server from the internet for outlook to
use.

Using an example line from the script, I can use

/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.1 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.1 -j ACCEPT

and with that, the pc bypasses squid server, I
checked, there is no wpad.pac file on the web server

so, after looking at the script after my message, Id
appreciate if you help me with allowing pop and smtp
out cleanly without the lines above.

As you see I just need a little help tweaking this
script to meet my needs

on my previous email, I made a question about
transparent proxy, but I was actually hacking this
original. the importance of this example, is that the
web is flooded with this example

iptables -t nat -A PREROUTING -i eth0 -p tcp --dport
80 -j REDIRECT --to-port 3128

but, this method does NOT work with authentication.
but this script solves the problem!!

I noticed on squid.conf btw, webmin users are being
authenticated.

thanks!






#!/bin/bash
# Firewall
# LAN1 & LAN2
# to Internet. No traffic among lans

# constants
#
INT_INTERFACE="eth2"
LOOPBACK_INTERFACE="lo"
LAN_INTERFACE1="eth0"
LAN_INTERFACE2="eth1"
# Direccion de la interfaz a INTERNET
#
DIR_PUBLICA="200.76.188.51"
DIR_LAN1="192.168.16.254"
DIR_LAN2="192.168.17.254"
LOOPBACK="127.0.0.1"
BROADCAST_SRC="0.0.0.0"
BROADCAST_DEST="255.255.255.255"
CLASS_D_MULTICAST="224.0.0.0/4"
CLASS_E_RESERVED_NET="240.0.0.0/5"
RED1="192.168.16.0/24"
BROADCAST1="192.168.16.255"
RED2="192.168.17.0/24"
BROADCAST2="192.168.17.255"
PTOS_PRIV="0:1023"
PTOS_N_PRIV="1024:65535"
SERVIDOR="192.168.17.1"
VIDEO="192.168.17.61"


# Habilita la proteccion contra icmp broadcast echo
# (Proteccion vs. ecos de icmp de regreso)
# 
echo 1 >
/proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
# 
# Deshabilita los paquetes ruteados desde la direccion
# origen
#
for f in
/proc/sys/net/ipv4/conf/*/accept_source_route; do
  echo 0 > $f
done
#
# Habilita la proteccion vs. inundacion de TCP SYN
# 
 echo 1 > /proc/sys/net/ipv4/tcp_syncookies
#
# Deshabilita aceptacion de redirecciones de rutas
#
for f in /proc/sys/net/ipv4/conf/*/accept_redirects;
do
  echo 0 > $f
done
#
# Elimina paquetes cuya direccion de origen pertenezca
# a otra interface
#
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
  echo 0 > $f
done
#
# Graba en el log los paquetes que llegan con
# direcciones imposibles como en las redes 0 o 127
#  
for f in /proc/sys/net/ipv4/conf/*/log_martians; do
  echo 0 > $f
done
# Habilita el ip_forwarding requerido por los sevicios
# ofrecidos a INTERNET
# 
echo 1 > /proc/sys/net/ipv4/ip_forward
#
# Remueve reglas en todas las cadenas
#


/sbin/iptables -A OUTPUT -j LOG
/sbin/iptables -A INPUT -j LOG
/sbin/iptables -A FORWARD -j LOG


/sbin/iptables --flush
/sbin/iptables -t nat --flush
/sbin/iptables -t mangle --flush

#
# Acepta el trafico de loopback y de las redes al
firewall
#
/sbin/iptables -A INPUT  -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT
/sbin/iptables -A INPUT -i $LAN_INTERFACE1 -j ACCEPT
/sbin/iptables -A OUTPUT -o $LAN_INTERFACE1 -j ACCEPT
/sbin/iptables -A INPUT -i $LAN_INTERFACE2 -j ACCEPT
/sbin/iptables -A OUTPUT -o $LAN_INTERFACE2 -j ACCEPT
/sbin/iptables -t nat -A POSTROUTING -s 192.168.0.0/24
-j MASQUERADE

echo "1" > /proc/sys/net/ipv4/ip_forward

#
#
# Establece la politica de las cadenas
#
/sbin/iptables --policy INPUT DROP
/sbin/iptables --policy OUTPUT DROP
/sbin/iptables --policy FORWARD DROP
/sbin/iptables -t nat --policy PREROUTING ACCEPT 
/sbin/iptables -t nat --policy OUTPUT  ACCEPT
/sbin/iptables -t nat --policy POSTROUTING ACCEPT
/sbin/iptables -t mangle --policy PREROUTING  ACCEPT
/sbin/iptables -t mangle --policy OUTPUT  ACCEPT
#
# Habilita el masquerading para los servicios que
# tiene acceso la red area local
/sbin/iptables -t nat -A POSTROUTING -o $INT_INTERFACE
-j MASQUERADE


## 82 -253 restringido
#/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p udp \
#    -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
#    --dport 53 -j ACCEPT
#/sbin/iptables -A INPUT -i $INT_INTERFACE -p udp \
#    --sport 53 \
#    -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j ACCEPT

    

# Habilita la salida de los JEFES
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.1 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.1 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.20 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.20 -j ACCEPT
 /sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.21 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.21 -j ACCEPT
 /sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.22 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.22 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.23 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.23 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.24 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.24 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.25 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.25 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.26 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.26 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.27 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.27 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.28 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.28 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.29 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.29 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.30 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.30 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.31 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.31 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.32 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.32 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.33 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.33 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.34 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.34 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.35 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.35 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.36 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.36 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.37 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.37 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.38 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.38 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.39 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.39 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.40 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.40 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.41 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.41 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.42 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.42 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.43 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.43 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.44 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.44 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.45 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.45 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.46 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.46 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.47 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.47 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.48 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.48 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.49 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.49 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.50 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.50 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.51 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.51 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.52 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.52 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.54 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.54 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.55 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.55 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.56 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.56 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.57 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.57 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.58 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.58 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.59 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.59 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.60 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.60 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.61 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.61 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.62 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.62 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.63 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.63 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.64 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.64 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.65 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.65 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.66 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.66 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.67 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.67 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.68 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.68 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.69 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.69 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.70 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.70 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.71 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.71 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.72 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.72 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.73 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.73 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.74 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.74 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.75 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.75 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.76 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.76 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.77 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.77 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.78 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.78 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.79 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.79 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.80 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.80 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.81 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.81 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.82 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.82 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.83 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.83 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.84 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.84 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 \
  -d 192.168.17.85 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE \
  -s 192.168.17.85 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.1 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.1 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.10 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.10 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.11 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.11 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.12 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.12 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.13 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.13 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.14 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.14 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.15 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.15 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.16 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.16 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.22 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.22 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.23 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.23 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.24 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.24 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.25 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.25 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.26 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.26 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.27 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.27 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.28 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.28 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.29 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.29 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.30 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.30 -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE2 \
  -d 192.168.16.31 -j ACCEPT
/sbin/iptables -A FORWARD -i $LAN_INTERFACE2 -o
$INT_INTERFACE \
  -s 192.168.16.31 -j ACCEPT
#
# Elimina paquetes de respuesta de TCP sobre
# paquetes con combinaciones ilegales de banderas 
#
/sbin/iptables -A INPUT -p tcp --tcp-flags ALL NONE -j
DROP
#/sbin/iptables -A FORWARD -p tcp --tcp-flags ALL NONE
-j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags SYN,FIN
SYN,FIN -j DROP
#/sbin/iptables -A FORWARD -p tcp --tcp-flags SYN,FIN
SYN,FIN -j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags SYN,RST
SYN,RST -j DROP
#/sbin/iptables -A FORWARD -p tcp --tcp-flags SYN,RST
SYN,RST -j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags FIN,RST
FIN,RST -j DROP
#/sbin/iptables -A FORWARD -p tcp --tcp-flags FIN,RST
FIN,RST -j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN
-j DROP
#/sbin/iptables -A FORWARD -p tcp --tcp-flags ACK,FIN
FIN -j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH
-j DROP
#/sbin/iptables -A FORWARD -p tcp --tcp-flags ACK,PSH
PSH -j DROP
/sbin/iptables -A INPUT -p tcp --tcp-flags ACK,URG URG
-j DROP
#/sbin/iptables -A FORWARD -p tcp --tcp-flags ACK,URG
URG -j DROP
#
# Elimina paquetes cuya direccion de origen coincide
# con la direccion publica asignada al equipo
#
/sbin/iptables -A INPUT -i $INT_INTERFACE -s
$DIR_PUBLICA -j DROP
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -s
$DIR_PUBLICA -j DROP
#
# Elimina paquetes que tengan como direccion origen
loopbak
# pero ingrese por la interfaz de internet
#
/sbin/iptables -A INPUT -i $INT_INTERFACE -s $LOOPBACK
-j DROP
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -s
$LOOPBACK -j DROP
#
# Rehusa paquetes con direcciones de broadcast
incorrectas
#
/sbin/iptables -A INPUT -i $INT_INTERFACE -s
$BROADCAST_DEST -j LOG
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -s
$BROADCAST_DEST -j LOG
/sbin/iptables -A INPUT -i $INT_INTERFACE -s
$BROADCAST_DEST -j DROP 
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -s
$BROADCAST_DEST -j DROP 
/sbin/iptables -A INPUT -i $INT_INTERFACE -d
$BROADCAST_SRC -j LOG
/sbin/iptables -A INPUT -i $INT_INTERFACE -d
$BROADCAST_SRC -j DROP 
/sbin/iptables -A INPUT -i $INT_INTERFACE -d $RED1 -j
DROP
/sbin/iptables -A INPUT -i $INT_INTERFACE -d
$BROADCAST1 -j DROP
/sbin/iptables -A INPUT -i $INT_INTERFACE -d $RED2 -j
DROP
/sbin/iptables -A INPUT -i $INT_INTERFACE -d
$BROADCAST2 -j DROP
#
# Elimina paquetes que tiene direccion multicast,
estas solamente
# son validas como direcciones destino y con protocolo
udp
#
/sbin/iptables -A INPUT -i $INT_INTERFACE -s
$CLASS_D_MULTICAST -j DROP
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -s
$CLASS_D_MULTICAST -j DROP
/sbin/iptables -A INPUT -i $INT_INTERFACE -p ! udp -d
$CLASS_D_MULTICAST -j DROP
/sbin/iptables -A INPUT -i $INT_INTERFACE -p udp -d
$CLASS_D_MULTICAST -j ACCEPT
#
# Elimina paquetes de la red clase E reservada
#
/sbin/iptables -A INPUT -i $INT_INTERFACE -s
$CLASS_E_RESERVED_NET -j DROP
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -s
$CLASS_E_RESERVED_NET -j DROP
#
# Acceso como Servidor de DNS
#/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p udp \
#               -s $DIR_PUBLICA --sport 53 \
#       --dport $PTOS_N_PRIV -j ACCEPT
#/sbin/iptables -A INPUT -i $INT_INTERFACE -p udp \
#               --sport $PTOS_N_PRIV -d $DIR_PUBLICA \
#       --dport 53 -j ACCEPT
#/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
#               -s $DIR_PUBLICA --sport 53 \
#       --dport $PTOS_N_PRIV -j ACCEPT
#/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp \
#               --sport $PTOS_N_PRIV -d $DIR_PUBLICA \
#       --dport 53 -j ACCEPT

#
#
# DNS ( Acceso DNS Cliente)
#
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p udp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 53 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p udp \
               --sport 53 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
# 
# DNS ( Querys de cliente enviados por tcp)
#
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 53 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp \
               --sport 53 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
#
# Servicios de WWW ( Cliente de SQUID)
#
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 80 -j ACCEPT

/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 80 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT

/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 443 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 443 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 143 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 143 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 21 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 21 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 20 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 20 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 8080 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 8080 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 8081 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 8081 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 5052 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 5052 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 5054 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 5054 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
# 
# Filtra y enruta los servicios publicos ofrecidos en
SERVIDOR
#  Servicios de DNS
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p udp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport 53 \
# -j DNAT --to-destination $SERVIDOR:53
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p udp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
53 \
#           -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p udp \
#          -s $SERVIDOR --sport 53  --dport
$PTOS_N_PRIV \
#          -j ACCEPT 
# 
# Filtra y enruta los servicios publicos ofrecidos en
SERVIDOR
#  Servicios de DNS
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport 53 \
# -j DNAT --to-destination $SERVIDOR:53
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
53 \
#           -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport 53  --dport
$PTOS_N_PRIV \
#          -j ACCEPT 
# 
# Filtra y enruta los servicios publicos ofrecidos en
SERVIDOR
#  Servicios de WWW
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport 80 \
# -j DNAT --to-destination $SERVIDOR:80
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
80 \
#           -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport 80  --dport
$PTOS_N_PRIV \
#          -j ACCEPT 
# Accesar webmin provisionalmente	  
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport 9501 \
# -j DNAT --to-destination $SERVIDOR:9501
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
9501 \
#           -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport 9501  --dport
$PTOS_N_PRIV \
#          -j ACCEPT 
#
# Filtra y enruta los servicios publicos ofrecidos en
SERVIDOR
#  Servicios de FTP
#  (Conexiones Activas)
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport 20 \
# -j DNAT --to-destination $SERVIDOR:20
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
20 \
#           -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp ! --syn #\
#          -s $SERVIDOR --sport 20  --dport
$PTOS_N_PRIV \
#          -j ACCEPT 

#
# Filtra y enruta los servicios publicos ofrecidos en
SERVIDOR
#  Servicios de FTP
#  (Conexiones Pasivas)
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
#--sport $PTOS_N_PRIV  -d $DIR_PUBLICA --dport
$PTOS_N_PRIV \
# -j DNAT --to-destination $SERVIDOR:$PTOS_N_PRIV
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV  -d $SERVIDOR --dport
$PTOS_N_PRIV \
#           -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport $PTOS_N_PRIV  --dport
$PTOS_N_PRIV  \
#          -j ACCEPT 
#
# Filtra y enruta los servicios publicos ofrecidos en
SERVIDOR
#  Servicios de FTP
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport 21 \
# -j DNAT --to-destination $SERVIDOR:21
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
21 \
#           -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp ! --syn #\
#          -s $SERVIDOR --sport 21  --dport
$PTOS_N_PRIV \
#          -j ACCEPT 

#
# Servicios de WWW (SSL)
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport 443 \
# -j DNAT --to-destination $SERVIDOR:443
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
443 \
#          -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport 443  --dport
$PTOS_N_PRIV \
#          -j ACCEPT 
#
# Servicios de correo (SMTP)
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport  25 \
# -j DNAT --to-destination $SERVIDOR:25
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
25 \
#          -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport 25 --dport
$PTOS_N_PRIV \
#          -j ACCEPT 
#
# Servicios de correo (POP3)
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport  110 \
# -j DNAT --to-destination $SERVIDOR:110
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
110 \
#          -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport 110 --dport
$PTOS_N_PRIV \
#          -j ACCEPT 
#
# Servicios de video 
#
/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
 --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport  5550 \
 -j DNAT --to-destination $VIDEO:5550
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
          --sport $PTOS_N_PRIV -d $VIDEO --dport 5550
\
          -j ACCEPT 
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
          -s $VIDEO --sport 5550 --dport $PTOS_N_PRIV
\
          -j ACCEPT 
#
# Servicios de video 
#
/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
 --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport  4550 \
 -j DNAT --to-destination $VIDEO:4550
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
          --sport $PTOS_N_PRIV -d $VIDEO --dport 4550
\
          -j ACCEPT 
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
          -s $VIDEO --sport 4550 --dport $PTOS_N_PRIV
\
          -j ACCEPT 
#
# Servicios de video 
#
/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
 --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport  5900 \
 -j DNAT --to-destination $VIDEO:5900
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
          --sport $PTOS_N_PRIV -d $VIDEO --dport 5900
\
          -j ACCEPT 
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
          -s $VIDEO --sport 5900 --dport $PTOS_N_PRIV
\
          -j ACCEPT 
#
# Servicios de video 
#
/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
 --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport  9000 \
 -j DNAT --to-destination $VIDEO:9000
/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
          --sport $PTOS_N_PRIV -d $VIDEO --dport 9000
\
          -j ACCEPT 
/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
          -s $VIDEO --sport 9000 --dport $PTOS_N_PRIV
\
          -j ACCEPT 
#
# puerto de prepa virtual
#
#/sbin/iptables -t nat -A PREROUTING -i $INT_INTERFACE
-p tcp \
# --sport $PTOS_N_PRIV -d $DIR_PUBLICA --dport  7800 \
# -j DNAT --to-destination $SERVIDOR:7800
#/sbin/iptables -A FORWARD -i $INT_INTERFACE -o
$LAN_INTERFACE1 -p tcp \
#          --sport $PTOS_N_PRIV -d $SERVIDOR --dport
7800 \
#          -j ACCEPT 
#/sbin/iptables -A FORWARD -i $LAN_INTERFACE1 -o
$INT_INTERFACE -p tcp \
#          -s $SERVIDOR --sport 7800 --dport
$PTOS_N_PRIV \
#          -j ACCEPT 

#
# SSH.
# Habilita el cliente de SSH del servidor Bourbon
#
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
               -s $DIR_PUBLICA --sport $PTOS_N_PRIV \
               --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp !
--syn \
               --sport 22 \
               -d $DIR_PUBLICA --dport $PTOS_N_PRIV -j
ACCEPT
#
# Habilita el acceso al servidor de SSH del servidor
Bourbon
#
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp \
               --sport $PTOS_N_PRIV \
               -d $DIR_PUBLICA --dport 22 -j ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp !
--syn \
               -s $DIR_PUBLICA --sport 22 \
               --dport $PTOS_N_PRIV -j ACCEPT
#
# Impide conexiones de/hacia INTERNET a  XWINDOWS
#
XWINDOW_PORTS="6000:6063"
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp
--syn \
   --destination-port $XWINDOW_PORTS -j REJECT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp --syn
\
   --destination-port $XWINDOW_PORTS -j DROP 
#
# Impide conexiones a servicios exclusivos de la
intranet
#
NFS_PORT="2049"
SQUID_PORT="3128"
LOCKD_PORT="4045"
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p tcp \
  -m multiport --destination-port
$NFS_PORT,$SQUID_PORT \
  --syn -j DROP 
/sbin/iptables -A INPUT -i $INT_INTERFACE -p tcp \
  -m multiport --destination-port
$NFS_PORT,$SQUID_PORT \
  --syn -j DROP 
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p udp \
  -m multiport --destination-port
$NFS_PORT,$LOCKD_PORT \
  -j REJECT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p udp \
  -m multiport --destination-port
$NFS_PORT,$LOCKD_PORT \
  -j DROP
#
# Filtrado de mensajes ICMP y status messages
#
# Eliminar fragmentos de ICMP
#
/sbin/iptables -A INPUT -i $INT_INTERFACE --fragment
-p icmp -j LOG \
      --log-prefix "Fragmented ICMP:"
/sbin/iptables -A INPUT -i $INT_INTERFACE --fragment
-p icmp -j DROP
# 
# Habilita el control de flujo entre dos ruteadores
permitiendo
# los tipos de mensajes 4,12 y 3
#
/sbin/iptables -A INPUT -i $INT_INTERFACE -p icmp \
   --icmp-type source-quench -d $DIR_PUBLICA -j ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p icmp \
   -s $DIR_PUBLICA --icmp-type source-quench -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p icmp \
   --icmp-type parameter-problem -d $DIR_PUBLICA -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p icmp \
   -s $DIR_PUBLICA --icmp-type parameter-problem -j
ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p icmp \
   --icmp-type destination-unreachable -d $DIR_PUBLICA
-j ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p icmp \
      -s $DIR_PUBLICA --icmp-type fragmentation-needed
-j ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p icmp \
    -s $DIR_PUBLICA --icmp-type
destination-unreachable -j DROP
/sbin/iptables -A INPUT -i $INT_INTERFACE -p icmp \
    --icmp-type time-exceeded -d $DIR_PUBLICA -j
ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p icmp \
    -s $DIR_PUBLICA --icmp-type echo-request -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p icmp \
    --icmp-type echo-reply -d $DIR_PUBLICA -j ACCEPT
/sbin/iptables -A INPUT -i $INT_INTERFACE -p icmp \
    --icmp-type echo-request -d $DIR_PUBLICA -j ACCEPT
/sbin/iptables -A OUTPUT -o $INT_INTERFACE -p icmp \
    -s $DIR_PUBLICA --icmp-type echo-reply -j ACCEPT
# Inserta el modulo de nat para FTP
/sbin/modprobe ip_nat_ftp    



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
