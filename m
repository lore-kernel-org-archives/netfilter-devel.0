From: Glen Miner <shaggie76@hotmail.com>
Subject: RE: iptables at scale
Date: Wed, 11 Mar 2015 16:30:44 -0400
Message-ID: <SNT152-W39C0E6395F651401801121B8190@phx.gbl>
References: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>,<alpine.LSU.2.11.1503112023560.6523@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from snt004-omc1s22.hotmail.com ([65.55.90.33]:64672 "EHLO
	SNT004-OMC1S22.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbbCKUin convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 16:38:43 -0400
In-Reply-To: <alpine.LSU.2.11.1503112023560.6523@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>The ugly: as the number if iptables rules increases the time required=
 to
>>modify the table grows. At first this is linear but it starts to go
>>super-linear after about 16,000 rules or so; I assume it's blowing ou=
t a CPU
>>cache.
>
> Quite possibly. And even if one operating system's implementation can
> do 16000, and the other 20000 before the turning point is reached, be
> aware that the limiting factor is generally capacity. The problem is
> not specific to networking. The same can be observed when there is
> not enough RAM for an arbitrary task and pages get swapped out to
> disk. To date, the only solution was to "add more capacity" or to
> reduce/split the workload, as there is only so much vertical scaling
> one can do.

To be clear: judging by the scaling of kernel performance thus far the =
only bottleneck at this point is table modification. I've easily got 20=
x the headroom on the server as it is but am choked because I can't cre=
ate rules fast enough.=A0

And yes -- we're ready to go wide -- but that has its own problems. I'd=
 really like to find a way to get a lot better utilization per node.=A0

> nft: Single rules can be updated. The \0 space wastage is elided.
=2E..
> In other words, if you really want to know, measure.

Ok thanks for the info -- I don't know enough of the state this package=
 is in but I'll take a look. I'm not sure I can dump iptables out of my=
 current system and drop in nftables instead but maybe I'll try tomorro=
w. If I get nftables working I'll definitely post scaling numbers.

-g 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
