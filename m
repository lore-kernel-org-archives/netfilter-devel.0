From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Tue, 19 Jul 2011 22:38:57 +0100
Message-ID: <878vruymq6.fsf@sapphire.mobileactivedefense.com>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
	<20110718191956.GA2489@p183.telecom.by>
	<87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	<20110718.124638.30010338187296272.davem@davemloft.net>
	<87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
	<alpine.LNX.2.01.1107182218170.9579@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rainer Weikusat <rweikusat@mobileactivedefense.com>,
	David Miller <davem@davemloft.net>, adobriyan@gmail.com,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:50170 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1GSVjP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:39:15 -0400
In-Reply-To: <alpine.LNX.2.01.1107182218170.9579@frira.zrqbmnf.qr> (Jan Engelhardt's message of "Mon\, 18 Jul 2011 22\:28\:25 +0200 \(CEST\)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> writes:
> On Monday 2011-07-18 22:17, Rainer Weikusat wrote:
>>David Miller <davem@davemloft.net> writes:
>>>
>>>> [rw@sapphire]~/work/linux-2-6/net/netfilter $find -name '*.c' | xargs grep '^#ifdef' | wc -l
>>>> 239
>>>
>>> You've shown nothing.  Showing exceptions does not prove that the
>>> general effort has been to keep ifdef crap out of *.c files.
>>
>>I've 'shown' that the networking code contains a fair amount of
>>#ifdefs in .c files. Consequently, 'we did it without' is wrong. At
>>best, 'we would like to do without in future' seems justified.
>
> Your count of ifdefs is just telling that we use ifdef, not how we
> use it.
>
> There is a difference between #ifdefs sprinkled inside a function,
> and #ifdefs around functions or larger groups where possible,
> feasible and optically preferable (cf. security.h, xt_TEE.c).

Counting this one-by-one results in

	1.An #ifdef block in order to include the namespace headers
          conditionally. This could essentially just be dumped without
          any effects except a minor increase in compilation time.

	2.Two of them in order to conditionally include
          a single, namespace-specific pointer in the two structures.
          This is not 'sprinkled across functions' but inside a
          declaration which happens to be in a .c file. Could be
          omitted at the cost of including two otherwise useless
          pointers in the two structures when compiling w/o netns
          support.

	3.A 'large functional group' which conditionally compiles
          either the 'dummy' access functions that all reduce to
          using the static logging instances table the same way it is
          used in the existing code or the more complicated ones that
          actually go via a struct net in order to locate the
          per-namespace logging instance table. In this case, the
          possible cost for someoe who doesn't want to use the network
          namespace is a call to an not entirely trivial function per
          logged packet plus two additional pointer dereferences per
          batch of logged packets forwarded to a userspace
          application.

	4.A conditional pointer assignment in instance_create. That's
          not going to help much in either case and could just be
          dumped alongside the conditionally included pointers.

	5.A conditionally compiled function body for
          instances_for_seq. Could be moved into the 'larger group'
          mentioned in 3.

	6.Another 'larger group' which contains the namespace-specific
	  initialization/ finalization code and the corresponding
	  structure definition. Could be dumped completely by
	  exploiting the 'non-namespace' register_pernet_ interface.

	7.Two blocks of conditional additions to the module
	  initialization/ finalization routines. Both routines already
	  contain conditionally compiled code blocks (for proc
	  support). Apart from that, same as 6.

My opinion on that would be that 1), 6) and 7) should be removed and
that 2) and 4) are essentially cosmetic and thus, should be removed,
too. 5) should just be unified with 3) (meaning, treated identically
to it. 3), however, is different since this would impose an
essentially unbound additional cost on someone who doesn't want to use
network namespaces (roughly proportional to the number packets
logged). And this doesn't seem particularly fair to me (if someone
doesn't want to use network namespace, he shouldn't be paying for the
people who do want to use them).

It is, however, possible to change the instances_via_skb function to
something which gcc (at least 4.4.5) can correctly identify as no-op
for the 'no network namespace' case and to change the remaining code
such that only the 'lookup instances by going through a struct net'
inline routine is still conditionally compiled (either doing a
net_generic call or returning the value of a file scope pointer
variable). This means that the compiled code is roughly identical to
the one produced by the patch I originally posted while the set of
source code changes has become (relatively) significantly smaller and less
'variable'. I did this over the course of the day, mainly because I
was curious if it could be done and the result works with the
2.6.36.4-derived kernel used on 'our' appliances. A patch for nf-2.6
current/ 3.0-rc? also exists but I haven't gotten around to actually
testing that today. Provided that also works (which I expect), I will
post an updated change tomorrow.
