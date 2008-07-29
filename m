From: Manu <manuprivat@gmx.de>
Subject: Re: RAWNAT kernel crash
Date: Tue, 29 Jul 2008 12:11:49 +0200
Message-ID: <488EECE5.7090206@gmx.de>
References: <4875D2DC.9040107@gmx.de> <alpine.LNX.1.10.0807101119180.27323@fbirervta.pbzchgretzou.qr> <4875DCD0.9070107@gmx.de> <alpine.LNX.1.10.0807101209050.27323@fbirervta.pbzchgretzou.qr> <4875EF77.8060700@gmx.de> <4875F12E.3010709@gmx.de> <487C8D4D.7080907@gmx.de> <487E2018.1010305@gmx.de> <488DA720.9060303@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34311 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758471AbYG2KLm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:11:42 -0400
In-Reply-To: <488DA720.9060303@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have further informations in my issue:
If I modified the sources (see below) - so I can succesfully replace the 
source address:

xtables-addons/extensions/xt_RAWNAT.c

...
static unsigned int
rawsnat_tg4(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
            const struct xt_target *target, const void *targinfo)
{
        const struct xt_rawnat_tginfo *info = targinfo;
...
       /*     if (!skb_make_writable(skb, sizeof(struct iphdr)))
                return NF_DROP; */
...

My question is: why do I have to make the skb writeable, if I can 
already replace the source address?
My tcpdump from PC1: 10.0.12.1 to PC2: 192.168.0.123


08:56:32.453443 0:30:18:49:b2:2f 0:40:f4:82:df:94 0800 98: 10.0.12.1 > 
192.168.0.123: icmp: echo request (DF) (ttl 64, id 0, len 84)
0x0000   4500 0054 0000 4000 4001 6385 0a00 0c01        E..T..@.@.c.....
0x0010   c0a8 007b 0800 40cd c53c 0001 20bf 8e48        ...{..@..<.....H
0x0020   51ea 0600 0809 0a0b 0c0d 0e0f 1011 1213        Q...............
0x0030   1415 1617 1819 1a1b 1c1d 1e1f 2021 2223        .............!"#
0x0040   2425 2627 2829 2a2b 2c2d 2e2f 3031 3233        $%&'()*+,-./0123
0x0050   3435                                           45
08:56:32.453749 0:40:f4:82:df:94 0:30:18:49:b2:2f 0800 98: 10.0.12.2 > 
10.0.12.1: icmp: echo reply (DF) (ttl 128, id 18266, len 84)
0x0000   4500 0054 475a 4000 8001 874c 0a00 0c02        E..TGZ@....L....
0x0010   0a00 0c01 0000 48cd c53c 0001 20bf 8e48        ......H..<.....H
0x0020   51ea 0600 0809 0a0b 0c0d 0e0f 1011 1213        Q...............
0x0030   1415 1617 1819 1a1b 1c1d 1e1f 2021 2223        .............!"#
0x0040   2425 2627 2829 2a2b 2c2d 2e2f 3031 3233        $%&'()*+,-./0123
0x0050   3435                                           45




Manu schrieb:
> Hello,
>
> my issue is to connect 2 pc's with different fix IP addresses!
> PC1: 10.0.0.1 and 10.0.17.1
> PC2: 192.168.0.123 with gateway: 192.168.0.1
> I modified the sources of actual RAWNAT 
> (xtables-addons-6e918514b752.... ) module from  
> http://dev.computergmbh.de/. See attachement!
> I modified the sources of my kernel-2.6.23, as well. See attachment.
>
> Interfaces on PC1:
> eth0: 10.0.0.1
> eth0:2 10.0.17.1
>
> My arptables rules are:
> arptables -A OUTPUT -d 10.0.17.2 -j mangle --mangle-ip-d 192.168.0.123 
> --mangle-ip-s 10.0.17.1
> arptables -A INPUT -s 192.168.0.123 -j mangle --mangle-ip-s 10.0.17.2 
> --mangle-ip-d 10.0.0.1
>
> My iptables rules are:
> iptables -t raw -I PREROUTING -s 192.168.0.123 -j RAWSNAT --to-source 
> 10.0.17.2
> iptables -t rawpost -I POSTROUTING -d 10.0.17.2 -j RAWDNAT 
> --to-destination 192.168.0.123
>
> Iptables: 1.4.1.2
> Kernel: 2.6.23
> gcc: 3.3
>
> With "iptables -t rawpost -I POSTROUTING -d 10.0.17.2 -j RAWDNAT 
> --to-destination 192.168.0.123", I can succesfully ping PC2 from PC1 
> with command "ping 10.0.17.2"!
> tcpdump says:
> 17:54:41.897864 10.0.17.1 > 192.168.0.123: icmp: echo request (DF) 
> (ttl 64, id 1, len 84)
> 17:54:41.898156 192.168.0.123 > 10.0.17.1: icmp: echo reply (DF) (ttl 
> 128, id 4526, len 84)
>
> But If I want to ping PC1 from PC2 with command "ping 10.0.17.1" and 
> with "iptables -t raw -I PREROUTING -s 192.168.0.123 -j RAWSNAT 
> --to-source 10.0.17.2" I got a system "crash" (complete hang up) like 
> descriped in my former postings?!
> It seems that the modified paket with source address replacement is in 
> improper format?!! maybe the checksum?
> The system "crashed" everytime, if a paket comes from 192.168.0.123 
> and entered the rule from iptables!?! If I set a rule e.g. "iptables 
> -t raw -I PREROUTING -s 192.168.0.123 -j DROP" - it works fine!
>
> klogd says:
> <3>compat_xtables: compat layer limits reached 
> (xtnu_skb_make_writable) - dropping packets
>
> one time I get this immediately before the crash:
> # iptables -nvL -t raw
> Chain PREROUTING (policy ACCEPT 16562 packets, 13M bytes)
> pkts bytes target     prot opt in     out     source               
> destination
>   15  1461 DROP       all  --  eth2   *       0.0.0.0/0            
> 224.0.0.251
>    0     0 RAWSNAT    all  --  eth2   *       192.168.0.123        
> 0.0.0.0/0           to-source 10.0.17.2/32
>
> Chain OUTPUT (policy ACCEPT 10293 packets, 1584K bytes)
> pkts bytes target     prot opt in     out     source               
> destination
> # iptables -nvL -t raw
> Chain PREROUTING (policy ACCEPT 16575 packets, 13M bytes)
> pkts bytes target     prot opt in     out     source               
> destination
> Segmentation fault
>
> happens when (tcpdump-trace): passierte bei:
>
> 13:41:39.810642 0:14:b:30:d0:2 0:30:18:49:f3:2a 0800 86: 
> 192.168.0.123.1025 > 192.168.0.1.53: [udp sum ok]  51493+ PTR? 
> 123.0.168.192.in-addr.arpa. (44) (ttl 255, id 7738, len 72)
> 0x0000   4500 0048 1e3a 0000 ff11 1b9e c0a8 007b        E..H.:.........{
> 0x0010   c0a8 0001 0401 0035 0034 efaf c925 0100        .......5.4...%..
> 0x0020   0001 0000 0000 0000 0331 3233 0130 0331        .........123.0.1
> 0x0030   3638 0331 3932 0769 6e2d 6164 6472 0461        68.192.in-addr.a
> 0x0040   7270 6100 000c 0001                            rpa.....
>
>
> Any help would be so much appreciated!
> Thank you very much in advance!
>
> Regards,
> Manu

I have further informations in my issue:
If I modify the sources (see below) - I can succesfully replace the 
source address:

xtables-addons/extensions/xt_RAWNAT.c

...
static unsigned int
rawsnat_tg4(struct sk_buff *skb, const struct net_device *in,
            const struct net_device *out, unsigned int hooknum,
            const struct xt_target *target, const void *targinfo)
{
        const struct xt_rawnat_tginfo *info = targinfo;
...
       /*     if (!skb_make_writable(skb, sizeof(struct iphdr)))
                return NF_DROP; */
...

My question is: why do I have to make the skb writeable, if I can 
already replace the source address?
My tcpdump from PC1: 10.0.12.1 to PC2: 192.168.0.123
with iptables:
iptables -t raw -I PREROUTING -s 192.168.0.123 -j RAWSNAT --to-source 
10.0.12.2
iptables -t rawpost -I POSTROUTING -d 10.0.12.2 -j RAWDNAT 
--to-destination 192.168.0.123

08:56:32.453443 0:30:18:49:b2:2f 0:40:f4:82:df:94 0800 98: 10.0.12.1 > 
192.168.0.123: icmp: echo request (DF) (ttl 64, id 0, len 84)
0x0000   4500 0054 0000 4000 4001 6385 0a00 0c01        E..T..@.@.c.....
0x0010   c0a8 007b 0800 40cd c53c 0001 20bf 8e48        ...{..@..<.....H
0x0020   51ea 0600 0809 0a0b 0c0d 0e0f 1011 1213        Q...............
0x0030   1415 1617 1819 1a1b 1c1d 1e1f 2021 2223        .............!"#
0x0040   2425 2627 2829 2a2b 2c2d 2e2f 3031 3233        $%&'()*+,-./0123
0x0050   3435                                           45
08:56:32.453749 0:40:f4:82:df:94 0:30:18:49:b2:2f 0800 98: 10.0.12.2 > 
10.0.12.1: icmp: echo reply (DF) (ttl 128, id 18266, len 84)
0x0000   4500 0054 475a 4000 8001 874c 0a00 0c02        E..TGZ@....L....
0x0010   0a00 0c01 0000 48cd c53c 0001 20bf 8e48        ......H..<.....H
0x0020   51ea 0600 0809 0a0b 0c0d 0e0f 1011 1213        Q...............
0x0030   1415 1617 1819 1a1b 1c1d 1e1f 2021 2223        .............!"#
0x0040   2425 2627 2829 2a2b 2c2d 2e2f 3031 3233        $%&'()*+,-./0123
0x0050   3435                                           45


Maybe somebody can help me to solve my problem?!
thank you in advance


