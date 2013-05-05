From: Florian Westphal <fw@strlen.de>
Subject: xt_addrtype limit-iface-in is broken for ipv6
Date: Sun, 5 May 2013 11:36:10 +0200
Message-ID: <20130505093610.GA19796@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43743 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784Ab3EEJgN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 May 2013 05:36:13 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

quoting

https://bugzilla.netfilter.org/show_bug.cgi?id=812

[..]
When I tried to use in the nat/PREROUTING it messes up the
routing cache even if the rule didn't matched at all.
[..]
If I remove the --limit-iface-in from the non-working scenario, so just
use the -m addrtype --dst-type LOCAL it works!

This happens when LOCAL type matching is requested with
--limit-iface-in, and the default route is via the interface the packet
we test arrived on.

Because xt_addrtype uses ip6_route_output, the ipv6 routing
implementation creates an unwanted cached entry, and the packet
won't make it to the real/expected destination.

Silently ignoring --limit-iface-in makes the routing work
but it breaks rule matching (--dst-type LOCAL with limit-iface-in
is supposed to only match if the dst address is configured on
the incoming interface; without --limit-iface-in it will match if
the address is reachable via lo).

AFAIU the only solution is to use ipv6_chk_addr() when
LOCAL is requested instead of a route lookup.

Since this would create a dependeny on ipv6 its a no-go.
So, it boils down to two possible solutions:

a), extend struct nf_afinfo to also register
    ipv6_chk_addr(), OR
b), revert the commit that moved ipt_addrtype to xt_addrtype,
    and keep the ipv6 code in ip6t_addrtype.

IMO, the latter seems to be preferable.

http://git.breakpoint.cc/cgit.cgi/fw/nf-next.git/commit/?h=addrtype_2&id=3b30d692a351237f73b37b218f5310c5dc29cec0

implements this.

I plan to test this some more and will submit a patch once -next opens.

If someone has a better solution, please let me know.

Regards,
Florian
