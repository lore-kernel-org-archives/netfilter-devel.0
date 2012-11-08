From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Thu, 8 Nov 2012 18:55:00 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:39077 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab2KHRzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:55:02 -0500
In-Reply-To: <alpine.DEB.2.02.1211081627150.6644@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-11-08 17:35, Chris Wilson wrote:
>
> Summary: UDP devices (e.g. SIP phones) that don't change their source=
 port,
> behind NAT, when routing to their destination changes, keep a conntra=
ck entry
> valid which contains the old (wrong) SNAT-to address

Actually, not {changing the tuple and thus breaking at least
stream-type connections} could be considered a feature, for example
when you migrate off a certain address and onto a new one.

This(^) thought applies to both SNAT and DNAT scenarios. In fact,
IPv6 (non-NAT) temporary addresses follow the same principle=C2=A0=E2=80=
=94 they
continue to be valid for a certain time even after their
preferred_lifetime has run out.

You can remove "old" NFCT entries by use of conntrack(8) if you
the time between preferred_lft and valid_lft running out is too
short.

> However I suspect this is not easily generalisable to other NAT types=
, and
> violates layering (the source address and port after SNAT may not be
> available at the time of the lookup) so I guess there may be a more
> acceptable solution.
>
> Another option which doesn't violate layering might be to update the =
NAT rule
> when the outgoing address is known (after routing),

That is what MASQUERADE is usually for.

> if it's different to the
> current outgoing address. This would break existing TCP connections i=
f the
> routing changes, but in most cases the connection is already broken b=
y the
> routing change, and what we're trying to fix is that future connectio=
n
> attempts, reusing the same conntrack, should not fail as well.
>
> Another option might be to remember the destination interface as part=
 of
> the conntrack entry, and continue to send matching packets out of tha=
t
> interface even if the routing changes. [...]

Consider this 2=C3=972 event matrix (giving 4 cases a packet can end up
in):

  route out on {A, B} =C3=97 use outgoing address {A, B}

It is certainly possible that a customer may be multi-linked (2 or
more ISPs), and each ISP accepting traffic from/to his multi-home (1
or more subnets), whilst he is doing round-robin loadbalancing.

An operating system can therefore never automatically know whether
it is ok to continue using certain tuples over a link or not, unless
the user intervenes in some way.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
