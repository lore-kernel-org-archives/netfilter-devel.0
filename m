From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Byte order problem in libxt_conntrack.c
Date: Sat, 9 Jul 2011 16:31:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107091630200.17124@frira.zrqbmnf.qr>
References: <1309992602.6466.41.camel@sami.shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58323 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1GIObN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:31:13 -0400
In-Reply-To: <1309992602.6466.41.camel@sami.shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-07-07 00:50, Tom Eastep wrote:

>Using iptables 4.4.11.1, the following input:
>
>-A lan-dmz -p 6 --dport 80 -m conntrack --ctorigdstport 8080 -d 70.90.191.125 -m conntrack --ctorigdst 172.20.1.254 -j ACCEPT
>
>Results in this:
>
>Chain lan-dmz (1 references)
> pkts bytes target     prot opt in     out     source               destination         
>    0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            70.90.191.125        tcp dpt:80 ctorigdstport 36895 ctorigdst 172.20.1.254
>
>Note that 8080 == 0x1f90 while 36895 == 0x901f.
>
>The attached patch seems to resolve the issue.

Thanks, taken it in.


FTR, links to DUPLICATE candidates: http://bugs.debian.org/632804
