From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RAWNAT problem
Date: Mon, 15 Sep 2008 13:59:18 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809151246130.13892@fbirervta.pbzchgretzou.qr>
References: <48C91C06.4050201@gmx.de> <alpine.LNX.1.10.0809110925360.16098@fbirervta.pbzchgretzou.qr> <48CE870A.6020500@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Manu <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41529 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYIOR7U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:59:20 -0400
In-Reply-To: <48CE870A.6020500@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-09-15 12:02, Manu wrote:
>
> With an additional rule [at PREROUTING 3]:
> # iptables -nvL -t raw
> Chain PREROUTING (policy ACCEPT 18821 packets, 7969K bytes)
>  pkts bytes target     prot opt in     out     source               destination
> 11194  677K TRACE      all  --  *      *       0.0.0.0/0            0.0.0.0/0
>   353 28929 RAWSNAT    all  --  eth2   *       192.168.150.111      0.0.0.0/0 to-source 10.0.17.2/32
>     3   204 RAWDNAT    all  --  eth2   *       10.0.17.2            0.0.0.0/0 to-destination 10.0.17.1/32
>
> Chain OUTPUT (policy ACCEPT 21579 packets, 6930K bytes)
>  pkts bytes target     prot opt in     out     source               destination
>     0     0 RAWDNAT    udp  --  *      eth2    0.0.0.0/0            10.0.17.2 udp dpt:53 to-destination 192.168.150.111/32
> 16610 6550K TRACE      all  --  *      *       0.0.0.0/0            0.0.0.0/0
>
> I'm getting this result. If I'm doing the RAWDNAT operation in
> PREROUTING the pakets losts the destination-port? Or how do I
> have to read that!
>
> <4>TRACE: raw:PREROUTING:rule:2   SRC=192.168.150.111 DST=192.168.150.1
>    LEN=59 ID=5833 PROTO=UDP SPT=61014 DPT=53 LEN=39
> <4>TRACE: raw:PREROUTING:rule:3   SRC=10.0.17.2       DST=192.168.150.1
>    LEN=59 ID=5833 PROTO=UDP SPT=61014 DPT=53 LEN=39
> <4>TRACE: raw:PREROUTING:policy:4 SRC=10.0.17.2       DST=10.0.17.1
>    LEN=59 ID=5833 CE FRAG:7000 PROTO=UDP
>
> I'm feeling there is not much more to solve. A little bit help would be so
> greatly appreciated!
>
True true, something is not quite right yet.

I updated the branch with the latest commit ("updating checksumming 
code"), can you try that please? Thanks for keeping me on my toes ;-)
