From: Manu <manuprivat@gmx.de>
Subject: SNAT problem
Date: Wed, 01 Jul 2009 11:38:12 +0200
Message-ID: <4A4B2E84.3030501@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48622 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752887AbZGAJiK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:38:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello netfilter-list,

I have an issue with iptables and SNAT:
There is a NAT gateway between internet (eth0) an LAN (eth2) ( which is 
used by 200 people )
I've 200 internet fix IP, which are DNATted and SNATted for the 
communication with the internet:

iptables version: iptables v1.4.3.2
kernel: 2.6.23.9

NAT table:

Chain PREROUTING (policy ACCEPT 37177 packets, 3389K bytes)
 pkts bytes target     prot opt in     out     source               
destination
    5   211 DNAT       all  --  eth0   *       0.0.0.0/0            
80.xx.xxx.1         to:10.0.1.2
    7   684 DNAT       all  --  eth0   *       0.0.0.0/0            
80.xx.xxx.10        to:10.0.10.2
    7   352 DNAT       all  --  eth0   *       0.0.0.0/0            
80.xx.xxx.100       to:10.0.100.2
...

Chain POSTROUTING (policy ACCEPT 14096 packets, 1201K bytes)
 pkts bytes target     prot opt in     out     source               
destination
    0     0 SNAT       all  --  *      eth0    10.0.1.2             
0.0.0.0/0           to:80.xx.xxx.1
    6   288 SNAT       all  --  *      eth0    10.0.10.2            
0.0.0.0/0           to:80.xx.xxx.10
    0     0 SNAT       all  --  *      eth0    10.0.100.2           
0.0.0.0/0           to:80.xx.xxx.100
...


The problem is, there are pakets which are not SNATted:
# tcpdump -i eth0 -vvn | grep "10\.0\."
tcpdump: listening on eth0
11:24:50.553928 10.0.113.2.37295 > 19.6.34.13.61201: FP 
872115062:872115483(421) ack 2241938025 win 65535 (DF) (ttl 63, id 
22860, len 461)
11:24:54.558253 10.0.113.2.52741 > 129.13.233.195.80: F [tcp sum ok] 
1253290637:1253290637(0) ack 3260788409 win 33304 <nop,nop,timestamp 
1037069524 3028764969> (DF) (ttl 63, id 8213, len 52)
11:24:54.580499 10.0.113.2.52521 > 91.18.174.3.80: F [tcp sum ok] 
2182856414:2182856414(0) ack 4017845595 win 33304 <nop,nop,timestamp 
1037069524 1576465996> (DF) (ttl 63, id 39286, len 52)
11:25:50.282005 10.0.190.2.1036 > 74.125.43.104.80: F [tcp sum ok] 
0:0(0) ack 1 win 65129 (DF) (ttl 127, id 11722, len 40)
11:27:15.940457 10.0.12.2.1346 > 195.186.17.34.80: FP 
515820442:515820987(545) ack 3832399077 win 65535 (DF) (ttl 127, id 
6881, len 585)
11:27:15.941419 10.0.12.2.1344 > 195.186.17.34.80: FP 
3713984614:3713985159(545) ack 3897104309 win 65535 (DF) (ttl 127, id 
6882, len 585)
....

What could be the reason for ignoring the SNAT rule?!
Could the performance (CPU, Memory) of the gateway be the reason of the 
prob?
CPU:800MHz
RAM: 256MB

from /proc :
# cat ip_conntrack_max
16384
# cat ip_conntrack_count
1298
# cat ip_conntrack_buckets
4096
# cat ip_conntrack_udp_timeout
30
# cat ip_conntrack_tcp_loose
1


Any help will be very appreciated!
Thx in advance!

Manu

