From: Manu <manuprivat@gmx.de>
Subject: Re: RAWNAT problem
Date: Tue, 16 Sep 2008 17:05:25 +0200
Message-ID: <48CFCB35.3070007@gmx.de>
References: <48C91C06.4050201@gmx.de> <alpine.LNX.1.10.0809110925360.16098@fbirervta.pbzchgretzou.qr> <48CE870A.6020500@gmx.de> <alpine.LNX.1.10.0809151246130.13892@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752631AbYIPPE6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:04:58 -0400
In-Reply-To: <alpine.LNX.1.10.0809151246130.13892@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt schrieb:
> On Monday 2008-09-15 12:02, Manu wrote:
>   
>> With an additional rule [at PREROUTING 3]:
>> # iptables -nvL -t raw
>> Chain PREROUTING (policy ACCEPT 18821 packets, 7969K bytes)
>>  pkts bytes target     prot opt in     out     source               destination
>> 11194  677K TRACE      all  --  *      *       0.0.0.0/0            0.0.0.0/0
>>   353 28929 RAWSNAT    all  --  eth2   *       192.168.150.111      0.0.0.0/0 to-source 10.0.17.2/32
>>     3   204 RAWDNAT    all  --  eth2   *       10.0.17.2            0.0.0.0/0 to-destination 10.0.17.1/32
>>
>> Chain OUTPUT (policy ACCEPT 21579 packets, 6930K bytes)
>>  pkts bytes target     prot opt in     out     source               destination
>>     0     0 RAWDNAT    udp  --  *      eth2    0.0.0.0/0            10.0.17.2 udp dpt:53 to-destination 192.168.150.111/32
>> 16610 6550K TRACE      all  --  *      *       0.0.0.0/0            0.0.0.0/0
>>
>> I'm getting this result. If I'm doing the RAWDNAT operation in
>> PREROUTING the pakets losts the destination-port? Or how do I
>> have to read that!
>>
>> <4>TRACE: raw:PREROUTING:rule:2   SRC=192.168.150.111 DST=192.168.150.1
>>    LEN=59 ID=5833 PROTO=UDP SPT=61014 DPT=53 LEN=39
>> <4>TRACE: raw:PREROUTING:rule:3   SRC=10.0.17.2       DST=192.168.150.1
>>    LEN=59 ID=5833 PROTO=UDP SPT=61014 DPT=53 LEN=39
>> <4>TRACE: raw:PREROUTING:policy:4 SRC=10.0.17.2       DST=10.0.17.1
>>    LEN=59 ID=5833 CE FRAG:7000 PROTO=UDP
>>
>> I'm feeling there is not much more to solve. A little bit help would be so
>> greatly appreciated!
>>
>>     
> True true, something is not quite right yet.
>
> I updated the branch with the latest commit ("updating checksumming 
> code"), can you try that please? Thanks for keeping me on my toes ;-)
>
>   
Jan,

some more informations:

If I only set these rules I can also sucessfully ping each other but the 
DNS-request enters the mangle:FORWARD after the mangle:PREROUTING.

# iptables -nvL -t raw
Chain PREROUTING (policy ACCEPT 21972 packets, 10M bytes)
 pkts bytes target     prot opt in     out     source               
destination
  535 57863 TRACE      all  --  *      *       0.0.0.0/0            
0.0.0.0/0
   11   860 RAWSNAT    all  --  eth2   *       192.168.150.111      
0.0.0.0/0           to-source 10.0.17.2/32

Chain OUTPUT (policy ACCEPT 12897 packets, 5591K bytes)
 pkts bytes target     prot opt in     out     source               
destination
  168 30512 TRACE      all  --  *      *       0.0.0.0/0            
0.0.0.0/0
    7   588 RAWDNAT    all  --  *      eth2    0.0.0.0/0            
10.0.17.2           to-destination 192.168.150.111/32


<4>TRACE: raw:PREROUTING:policy:3 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=10.0.17.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=128 ID=16945 PROTO=UDP 
SPT=56929 DPT=53 LEN=38
<4>TRACE: mangle:PREROUTING:policy:1 IN=eth2 OUT= 
MAC=00:30:18:49:f3:2a:00:14:0b:30:d0:02:08:00 SRC=10.0.17.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=128 ID=16945 PROTO=UDP 
SPT=56929 DPT=53 LEN=38
<4>TRACE: mangle:FORWARD:policy:1 IN=eth2 OUT=eth0 SRC=10.0.17.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=127 ID=16945 PROTO=UDP 
SPT=56929 DPT=53 LEN=38
<4>TRACE: filter:FORWARD:rule:3 IN=eth2 OUT=eth0 SRC=10.0.17.2 
DST=192.168.150.1 LEN=58 TOS=0x00 PREC=0x00 TTL=127 ID=16945 PROTO=UDP 
SPT=56929 DPT=53 LEN=38


Like described in my former postings, this stuff already worked in an 
earlier version of kernel and iptables. I posted the sources as well. In 
the former version I only have to set these rules above, but there was 
no raw-table support integrated and the rules were set in the PREROUTING 
and POSTROUTING chain in mangle table!

If I can do something else, please let me know!
