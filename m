From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: iptables at scale
Date: Wed, 11 Mar 2015 21:15:22 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1503112023560.6523@nerf40.vanv.qr>
References: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Glen Miner <shaggie76@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:48343 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbCKUYw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 16:24:52 -0400
In-Reply-To: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-03-11 20:10, Glen Miner wrote:
>
>The ugly: as the number if iptables rules increases the time required =
to
>modify the table grows. At first this is linear but it starts to go
>super-linear after about 16,000 rules or so;=C2=A0=C2=A0I assume it's =
blowing out a CPU
>cache.

Quite possibly. And even if one operating system's implementation can
do 16000, and the other 20000 before the turning point is reached, be
aware that the limiting factor is generally capacity. The problem is
not specific to networking. The same can be observed when there is
not enough RAM for an arbitrary task and pages get swapped out to
disk. To date, the only solution was to "add more capacity" or to
reduce/split the workload, as there is only so much vertical scaling
one can do.


>Will nftables scale any better?

iptc: Processes entire rulesets. Many non-present options
take up space anyway (as "::/0"). Sent to kernel as-is as one huge
chunk. "One huge" allocation (per NUMA node) to copy it into the
kernel. Not a lot of parsing needed. Ruleset is linear.

nft: Single rules can be updated. The \0 space wastage is elided.
Sent to kernel in Netlink packets (max. 64K by now, I think), so
there is a forth-and-back of syscalls. Kernel needs to deserialize.
(Last time I checked, rules are held in a linked list like in BSD
*pf, therefore many small allocations all over the place.

The word on the street is that nft's expressiveness allows you to
have fewer rules. Whether it can really be exploited to that level
ultimately depends on the ruleset and how much conditions you
can aggregate, innit.

In other words, if you really want to know, measure.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
