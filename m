From: Manu <manuprivat@gmx.de>
Subject: RAWNAT problem
Date: Thu, 11 Sep 2008 15:24:22 +0200
Message-ID: <48C91C06.4050201@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53956 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754422AbYIKNYR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:24:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Jan, thank you for fixing the RAWNAT targets in xtables-addons!!! It 
works very well, without any crashes!
For my issue ( I want to exchange the source address for incoming 
pakets, and to exchange the destination address for outgoing pakets) I 
modified the xt_RAWNAT.c like that:

function: static unsigned int rawsnat_tg4
...
//      na  = remask(iph->saddr, info->addr.ip, info->mask);
        na = info->addr.ip;
...

and function: static unsigned int rawdnat_tg4
...
//    new_addr = remask(iph->daddr, info->addr.ip, info->mask);
      new_addr = info->addr.ip;
...

I have connected 2 PC's:
PC1 (acts as a gateway ):
LAN1 connected to internet router; IP: eth0=192.168.0.176
LAN2 connected to PC2; IP: eth1=10.0.0.1, eth1:2=10.0.12.1,....

PC2
FIX-IP: eth0=192.168.150.111; gw=192.168.150.1

rules in PC1:
iptables:
iptables -t raw -I PREROUTING -i eth1 -s 192.168.150.111 -j RAWSNAT 
--to-source 10.0.12.2
and
iptables -t rawpost -I POSTROUTING -o eth1 -d 10.0.12.2 -j RAWDNAT 
--to-destination 192.168.150.111

# arptables -nvL
Chain INPUT (policy ACCEPT 3691 packets, 103K bytes)
-j DROP -i * -o * -s 0.0.0.0 -d 10.0.12.2 --h-length 6 --opcode 1 , 
pcnt=0 -- bcnt=0
-j mangle -i eth1 -o * -s 192.168.150.111 --mangle-ip-s 10.0.12.2 
--mangle-ip-d 10.0.12.1 , pcnt=648 -- bcnt=18144

Chain OUTPUT (policy ACCEPT 7363 packets, 206K bytes)
-j mangle -i * -o eth1 -d 10.0.12.2 --mangle-ip-s 10.0.0.1 --mangle-ip-d 
192.168.150.111 , pcnt=88 -- bcnt=2464

Setted the rules like that, I can succesfully ping from one PC to the 
other - from PC2: ping 10.0.12.1 or from PC1: ping 10.0.12.2!

<4>TRACE: raw:PREROUTING:rule:2 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=192.168.150.111 
DST=10.0.12.1 LEN=84 TOS=0x00 PREC=0x00 TTL=128 ID=60868 DF PROTO=ICMP 
TYPE=0 CODE=0 ID=54363 SEQ=1
<4>TRACE: raw:PREROUTING:rule:3 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=192.168.150.111 
DST=10.0.12.1 LEN=84 TOS=0x00 PREC=0x00 TTL=128 ID=60868 DF PROTO=ICMP 
TYPE=0 CODE=0 ID=54363 SEQ=1
<4>TRACE: raw:PREROUTING:policy:4 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=10.0.12.2 
DST=10.0.12.1 LEN=84 TOS=0x00 PREC=0x00 TTL=128 ID=60868 DF PROTO=ICMP 
TYPE=0 CODE=0 ID=54363 SEQ=1
<4>TRACE: mangle:PREROUTING:policy:1 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=10.0.12.2 
DST=10.0.12.1 LEN=84 TOS=0x00 PREC=0x00 TTL=128 ID=60868 DF PROTO=ICMP 
TYPE=0 CODE=0 ID=54363 SEQ=1
<4>TRACE: mangle:INPUT:policy:1 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=10.0.12.2 
DST=10.0.12.1 LEN=84 TOS=0x00 PREC=0x00 TTL=128 ID=60868 DF PROTO=ICMP 
TYPE=0 CODE=0 ID=54363 SEQ=1
<4>TRACE: filter:INPUT:rule:2 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=10.0.12.2 
DST=10.0.12.1 LEN=84 TOS=0x00 PREC=0x00 TTL=128 ID=60868 DF PROTO=ICMP 
TYPE=0 CODE=0 ID=54363 SEQ=1


Ping works fine, but if I open a browser, I didn't get the web-page 
displayed. In my iptables nat rules I set a rule to redirect requests 
for port 53 to local process! But these requests went into FORWARD chain 
of mangle table?! Is there a problem with connection tracking?!

<4>TRACE: raw:PREROUTING:rule:2 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=192.168.150.111 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=128 ID=19126 PROTO=UDP 
SPT=2012 DPT=53 LEN=38
<4>TRACE: raw:PREROUTING:policy:4 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=10.0.12.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=128 ID=19126 PROTO=UDP 
SPT=2012 DPT=53 LEN=38
<4>TRACE: mangle:PREROUTING:policy:1 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=10.0.12.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=128 ID=19126 PROTO=UDP 
SPT=2012 DPT=53 LEN=38
<4>TRACE: mangle:FORWARD:policy:1 IN=eth1 OUT=eth0 SRC=10.0.12.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=127 ID=19126 PROTO=UDP 
SPT=2012 DPT=53 LEN=38
<4>TRACE: filter:FORWARD:rule:3 IN=eth1 OUT=eth0 SRC=10.0.12.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=127 ID=19126 PROTO=UDP 
SPT=2012 DPT=53 LEN=38

my other iptables-rules:
# iptables -nvL -t raw
Chain PREROUTING (policy ACCEPT 35980 packets, 2728K bytes)
 pkts bytes target     prot opt in     out     source               
destination
  285 22307 TRACE      all  --  eth2   *       0.0.0.0/0            
0.0.0.0/0
  293 23053 RAWSNAT    all  --  eth2   *       192.168.150.111      
0.0.0.0/0           to-source 10.0.12.2/32

Chain OUTPUT (policy ACCEPT 45319 packets, 9536K bytes)
 pkts bytes target     prot opt in     out     source               
destination

# iptables -nvL -t rawpost
Chain POSTROUTING (policy ACCEPT 45356 packets, 9540K bytes)
 pkts bytes target     prot opt in     out     source               
destination
  140 11760 RAWDNAT    all  --  *      eth2    0.0.0.0/0            
10.0.12.2           to-destination 192.168.150.111/32

# iptables -nvL -t mangle
Chain PREROUTING (policy ACCEPT 34447 packets, 2595K bytes)
 pkts bytes target     prot opt in     out     source               
destination

Chain INPUT (policy ACCEPT 33860 packets, 2551K bytes)
 pkts bytes target     prot opt in     out     source               
destination

Chain FORWARD (policy ACCEPT 524 packets, 35017 bytes)
 pkts bytes target     prot opt in     out     source               
destination

Chain OUTPUT (policy ACCEPT 44144 packets, 9426K bytes)
 pkts bytes target     prot opt in     out     source               
destination

Chain POSTROUTING (policy ACCEPT 44135 packets, 9425K bytes)
 pkts bytes target     prot opt in     out     source               
destination

# iptables -nvL -t nat
Chain PREROUTING (policy ACCEPT 9199 packets, 846K bytes)
 pkts bytes target     prot opt in     out     source               
destination
    0     0 REDIRECT   tcp  --  eth1   *       0.0.0.0/0            
0.0.0.0/0           tcp dpt:53
    0     0 REDIRECT   udp  --  eth1   *       0.0.0.0/0            
0.0.0.0/0           udp dpt:53
    0     0 REDIRECT   tcp  --  eth1   *       0.0.0.0/0            
0.0.0.0/0           tcp dpt:80 redir ports 11111

Chain POSTROUTING (policy ACCEPT 4756 packets, 369K bytes)
 pkts bytes target     prot opt in     out     source               
destination
 1073 87213 SNAT       all  --  *      eth0    0.0.0.0/0            
0.0.0.0/0           to:192.168.0.176

Chain OUTPUT (policy ACCEPT 5829 packets, 456K bytes)
 pkts bytes target     prot opt in     out     source               
destination


and without the rules for RAWNAT - I get following:

<4>TRACE: raw:PREROUTING:policy:3 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=192.168.150.111 
DST=192.168.150.1 LEN=70 TOS=0x00 PREC=0x00 TTL=128 ID=20296 PROTO=UDP 
SPT=2012 DPT=53 LEN=50
<4>TRACE: mangle:PREROUTING:policy:1 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=192.168.150.111 
DST=192.168.150.1 LEN=70 TOS=0x00 PREC=0x00 TTL=128 ID=20296 PROTO=UDP 
SPT=2012 DPT=53 LEN=50
<4>TRACE: mangle:INPUT:policy:1 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=192.168.150.111 
DST=10.0.0.1 LEN=70 TOS=0x00 PREC=0x00 TTL=128 ID=20296 PROTO=UDP 
SPT=2012 DPT=53 LEN=50
<4>TRACE: filter:INPUT:rule:6 IN=eth1 OUT= 
MAC=00:30:18:49:b2:2f:00:40:f4:82:df:94:08:00 SRC=192.168.150.111 
DST=10.0.0.1 LEN=70 TOS=0x00 PREC=0x00 TTL=128 ID=20296 PROTO=UDP 
SPT=2012 DPT=53 LEN=50

Hope somebody can help.

cheers


