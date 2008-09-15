From: Manu <manuprivat@gmx.de>
Subject: Re: RAWNAT problem
Date: Mon, 15 Sep 2008 18:02:18 +0200
Message-ID: <48CE870A.6020500@gmx.de>
References: <48C91C06.4050201@gmx.de> <alpine.LNX.1.10.0809110925360.16098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44071 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754225AbYIOQCD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:02:03 -0400
In-Reply-To: <alpine.LNX.1.10.0809110925360.16098@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt schrieb:
>> rules in PC1:
>> iptables:
>> iptables -t raw -I PREROUTING -i eth1 -s 192.168.150.111 -j RAWSNAT --to-source 10.0.12.2                                                           
>> and                                                                             
>> iptables -t rawpost -I POSTROUTING -o eth1 -d 10.0.12.2 -j RAWDNAT --to-destination 192.168.150.111
>>
>> Ping works fine, but if I open a browser, I didn't get the web-page displayed.
>> In my iptables nat rules I set a rule to redirect requests for port 53 to local
>> process! But these requests went into FORWARD chain of mangle table?! Is there
>> a problem with connection tracking?!
>>     
>
> You also need a rule in the OUTPUT chain of the raw table
> if you are initiating connections from the machine itself.
> libxt_RAWSNAT.man has been updated with this info
This doesn't solve my problem. I'm not entering the OUTPUT chain at all 
(with the destination port 53)!

If I set the following iptables-rules:
# iptables -nvL -t raw
Chain PREROUTING (policy ACCEPT 26290 packets, 8421K bytes)
 pkts bytes target     prot opt in     out     source               
destination
18663 1129K TRACE      all  --  *      *       0.0.0.0/0            
0.0.0.0/0
  524 43031 RAWSNAT    all  --  eth2   *       192.168.150.111      
0.0.0.0/0           to-source 10.0.17.2/32

Chain OUTPUT (policy ACCEPT 31998 packets, 14M bytes)
 pkts bytes target     prot opt in     out     source               
destination
    0     0 RAWDNAT    udp  --  *      eth2    0.0.0.0/0            
10.0.17.2           udp dpt:53 to-destination 192.168.150.111/32
27029   14M TRACE      all  --  *      *       0.0.0.0/0            
0.0.0.0/0

I get this result:

<4>TRACE: raw:PREROUTING:rule:2 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=192.168.150.111 
DST=192.168.150.1 LEN=89 TOS=0x00 PREC=0x00 TTL=255 ID=5101 PROTO=UDP 
SPT=1026 DPT=53 LEN=69
<4>TRACE: raw:PREROUTING:policy:3 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=10.0.17.2 
DST=192.168.150.1 LEN=89 TOS=0x00 PREC=0x00 TTL=255 ID=5101 PROTO=UDP 
SPT=1026 DPT=53 LEN=69
<4>TRACE: mangle:PREROUTING:policy:1 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=10.0.17.2 
DST=192.168.150.1 LEN=89 TOS=0x00 PREC=0x00 TTL=255 ID=5101 PROTO=UDP 
SPT=1026 DPT=53 LEN=69
<4>TRACE: mangle:FORWARD:policy:1 IN=eth2 OUT=eth0 SRC=10.0.17.2 
DST=192.168.150.1 LEN=89 TOS=0x00 PREC=0x00 TTL=254 ID=5101 PROTO=UDP 
SPT=1026 DPT=53 LEN=69
<4>TRACE: filter:FORWARD:rule:3 IN=eth2 OUT=eth0 SRC=10.0.17.2 
DST=192.168.150.1 LEN=89 TOS=0x00 PREC=0x00 TTL=254 ID=5101 PROTO=UDP 
SPT=1026 DPT=53 LEN=69

I would like to achieve the request goes into INPUT chain. (like if I'm 
doing the ping command)


With an additional rule:
# iptables -nvL -t raw
Chain PREROUTING (policy ACCEPT 18821 packets, 7969K bytes)
 pkts bytes target     prot opt in     out     source               
destination
11194  677K TRACE      all  --  *      *       0.0.0.0/0            
0.0.0.0/0
  353 28929 RAWSNAT    all  --  eth2   *       192.168.150.111      
0.0.0.0/0           to-source 10.0.17.2/32
    3   204 RAWDNAT    all  --  eth2   *       10.0.17.2            
0.0.0.0/0           to-destination 10.0.17.1/32

Chain OUTPUT (policy ACCEPT 21579 packets, 6930K bytes)
 pkts bytes target     prot opt in     out     source               
destination
    0     0 RAWDNAT    udp  --  *      eth2    0.0.0.0/0            
10.0.17.2           udp dpt:53 to-destination 192.168.150.111/32
16610 6550K TRACE      all  --  *      *       0.0.0.0/0            
0.0.0.0/0

I'm getting this result. If I'm doing the RAWDNAT operation in 
PREROUTING the pakets losts the destination-port ?!?! Or how do I have 
to read that!

<4>TRACE: raw:PREROUTING:rule:2 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=192.168.150.111 
DST=192.168.150.1 LEN=59 TOS=0x00 PREC=0x00 TTL=128 ID=5833 PROTO=UDP 
SPT=61014 DPT=53 LEN=39
<4>TRACE: raw:PREROUTING:rule:3 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=10.0.17.2 
DST=192.168.150.1 LEN=59 TOS=0x00 PREC=0x00 TTL=128 ID=5833 PROTO=UDP 
SPT=61014 DPT=53 LEN=39
<4>TRACE: raw:PREROUTING:policy:4 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=10.0.17.2 
DST=10.0.17.1 LEN=59 TOS=0x00 PREC=0x00 TTL=128 ID=5833 CE FRAG:7000 
PROTO=UDP
<4>TRACE: mangle:PREROUTING:policy:1 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=10.0.17.2 
DST=10.0.17.1 LEN=59 TOS=0x00 PREC=0x00 TTL=128 ID=5833 CE FRAG:7000 
PROTO=UDP


I'm feeling there is not much more to solve. A little bit help would be 
so greatly appreciated!
Thx & cheers
