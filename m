From: "Jeff Haran" <jharan@bytemobile.com>
Subject: RE: cant specify -m mark and -m connmark in same rule
Date: Fri, 22 Jul 2011 14:24:48 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A70295CCA9@hq-exchange01.bytemobile.com>
References: <6F5DE7538AFCDA45A114F5E7510424A70295CBBC@hq-exchange01.bytemobile.com> <alpine.LNX.2.01.1107221116020.16357@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:37344 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab1GVVYt convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:24:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <alpine.LNX.2.01.1107221116020.16357@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Jan Engelhardt [mailto:jengelh@medozas.de]
> Sent: Friday, July 22, 2011 2:19 AM
> To: Jeff Haran
> Cc: netfilter-devel@vger.kernel.org
> Subject: Re: cant specify -m mark and -m connmark in same rule
> 
> On Friday 2011-07-22 01:46, Jeff Haran wrote:
> 
> >Is this a bug?
> >
> > [root@cap-x2100m2-01 ~]# \
> >> iptables -A FORWARD -i eth2.11 -o eth1.111 -p tcp -m mark --mark
> >0x0/0xfff -m connmark --mark 0x0/0xfff -j NFQUEUE --queue-num 10
> >iptables v1.4.7: mark: "--mark" option may only be specified once
> >Try `iptables -h' or 'iptables --help' for more information.
> >[root@cap-x2100m2-01 ~]#
> 
> Fixed since iptables 1.4.11.

Indeed it was:

[root@cap-x2100m2-01 iptables]# \
> ./xtables-multi iptables -A FORWARD -i eth2.11 -o eth1.111 -p tcp -m
mark --mark 0x0/0xfff -m connmark --mark 0x0/0xfff -j NFQUEUE
--queue-num 10
[root@cap-x2100m2-01 iptables]# ./xtables-multi iptables --version
iptables v1.4.11.1
[root@cap-x2100m2-01 iptables]# ./xtables-multi iptables -L -n -v
Chain INPUT (policy ACCEPT 179 packets, 21269 bytes)
 pkts bytes target     prot opt in     out     source
destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
    0     0 NFQUEUE    tcp  --  eth2.11 eth1.111  0.0.0.0/0
0.0.0.0/0            mark match 0x0/0xfff connmark match  0x0/0xfff
NFQUEUE num 10

Chain OUTPUT (policy ACCEPT 55 packets, 6088 bytes)
 pkts bytes target     prot opt in     out     source
destination
[root@cap-x2100m2-01 iptables]#

Thanks a bunch!



