From: Manu <manuprivat@gmx.de>
Subject: RAWNAT kernel crash
Date: Mon, 28 Jul 2008 13:01:52 +0200
Message-ID: <488DA720.9060303@gmx.de>
References: <4875D2DC.9040107@gmx.de> <alpine.LNX.1.10.0807101119180.27323@fbirervta.pbzchgretzou.qr> <4875DCD0.9070107@gmx.de> <alpine.LNX.1.10.0807101209050.27323@fbirervta.pbzchgretzou.qr> <4875EF77.8060700@gmx.de> <4875F12E.3010709@gmx.de> <487C8D4D.7080907@gmx.de> <487E2018.1010305@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56319 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754036AbYG1LBy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2008 07:01:54 -0400
In-Reply-To: <487E2018.1010305@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

my issue is to connect 2 pc's with different fix IP addresses!
PC1: 10.0.0.1 and 10.0.17.1
PC2: 192.168.0.123 with gateway: 192.168.0.1
I modified the sources of actual RAWNAT (xtables-addons-6e918514b752.... 
) module from  http://dev.computergmbh.de/. See attachement!
I modified the sources of my kernel-2.6.23, as well. See attachment.

Interfaces on PC1:
eth0: 10.0.0.1
eth0:2 10.0.17.1

My arptables rules are:
arptables -A OUTPUT -d 10.0.17.2 -j mangle --mangle-ip-d 192.168.0.123 
--mangle-ip-s 10.0.17.1
arptables -A INPUT -s 192.168.0.123 -j mangle --mangle-ip-s 10.0.17.2 
--mangle-ip-d 10.0.0.1

My iptables rules are:
iptables -t raw -I PREROUTING -s 192.168.0.123 -j RAWSNAT --to-source 
10.0.17.2
iptables -t rawpost -I POSTROUTING -d 10.0.17.2 -j RAWDNAT 
--to-destination 192.168.0.123

Iptables: 1.4.1.2
Kernel: 2.6.23
gcc: 3.3

With "iptables -t rawpost -I POSTROUTING -d 10.0.17.2 -j RAWDNAT 
--to-destination 192.168.0.123", I can succesfully ping PC2 from PC1 
with command "ping 10.0.17.2"!
tcpdump says:
17:54:41.897864 10.0.17.1 > 192.168.0.123: icmp: echo request (DF) (ttl 
64, id 1, len 84)
17:54:41.898156 192.168.0.123 > 10.0.17.1: icmp: echo reply (DF) (ttl 
128, id 4526, len 84)

But If I want to ping PC1 from PC2 with command "ping 10.0.17.1" and 
with "iptables -t raw -I PREROUTING -s 192.168.0.123 -j RAWSNAT 
--to-source 10.0.17.2" I got a system "crash" (complete hang up) like 
descriped in my former postings?!
It seems that the modified paket with source address replacement is in 
improper format?!! maybe the checksum?
The system "crashed" everytime, if a paket comes from 192.168.0.123 and 
entered the rule from iptables!?! If I set a rule e.g. "iptables -t raw 
-I PREROUTING -s 192.168.0.123 -j DROP" - it works fine!

klogd says:
<3>compat_xtables: compat layer limits reached (xtnu_skb_make_writable) 
- dropping packets

one time I get this immediately before the crash:
# iptables -nvL -t raw
Chain PREROUTING (policy ACCEPT 16562 packets, 13M bytes)
 pkts bytes target     prot opt in     out     source               
destination
   15  1461 DROP       all  --  eth2   *       0.0.0.0/0            
224.0.0.251
    0     0 RAWSNAT    all  --  eth2   *       192.168.0.123        
0.0.0.0/0           to-source 10.0.17.2/32

Chain OUTPUT (policy ACCEPT 10293 packets, 1584K bytes)
 pkts bytes target     prot opt in     out     source               
destination
# iptables -nvL -t raw
Chain PREROUTING (policy ACCEPT 16575 packets, 13M bytes)
 pkts bytes target     prot opt in     out     source               
destination
Segmentation fault

happens when (tcpdump-trace): passierte bei:

13:41:39.810642 0:14:b:30:d0:2 0:30:18:49:f3:2a 0800 86: 
192.168.0.123.1025 > 192.168.0.1.53: [udp sum ok]  51493+ PTR? 
123.0.168.192.in-addr.arpa. (44) (ttl 255, id 7738, len 72)
0x0000   4500 0048 1e3a 0000 ff11 1b9e c0a8 007b        E..H.:.........{
0x0010   c0a8 0001 0401 0035 0034 efaf c925 0100        .......5.4...%..
0x0020   0001 0000 0000 0000 0331 3233 0130 0331        .........123.0.1
0x0030   3638 0331 3932 0769 6e2d 6164 6472 0461        68.192.in-addr.a
0x0040   7270 6100 000c 0001                            rpa.....


Any help would be so much appreciated!
Thank you very much in advance!

Regards,
Manu





