From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_addrtype limit-iface-in is broken for ipv6
Date: Tue, 7 May 2013 02:46:06 +0200
Message-ID: <20130507004606.GA5088@localhost>
References: <20130505093610.GA19796@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58061 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab3EGAqM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 20:46:12 -0400
Content-Disposition: inline
In-Reply-To: <20130505093610.GA19796@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 05, 2013 at 11:36:10AM +0200, Florian Westphal wrote:
> quoting
> 
> https://bugzilla.netfilter.org/show_bug.cgi?id=812
> 
> [..]
> When I tried to use in the nat/PREROUTING it messes up the
> routing cache even if the rule didn't matched at all.
> [..]
> If I remove the --limit-iface-in from the non-working scenario, so just
> use the -m addrtype --dst-type LOCAL it works!
> 
> This happens when LOCAL type matching is requested with
> --limit-iface-in, and the default route is via the interface the packet
> we test arrived on.
> 
> Because xt_addrtype uses ip6_route_output, the ipv6 routing
> implementation creates an unwanted cached entry, and the packet
> won't make it to the real/expected destination.
> 
> Silently ignoring --limit-iface-in makes the routing work
> but it breaks rule matching (--dst-type LOCAL with limit-iface-in
> is supposed to only match if the dst address is configured on
> the incoming interface; without --limit-iface-in it will match if
> the address is reachable via lo).
> 
> AFAIU the only solution is to use ipv6_chk_addr() when
> LOCAL is requested instead of a route lookup.
> 
> Since this would create a dependeny on ipv6 its a no-go.
> So, it boils down to two possible solutions:
> 
> a), extend struct nf_afinfo to also register
>     ipv6_chk_addr(), OR
> b), revert the commit that moved ipt_addrtype to xt_addrtype,
>     and keep the ipv6 code in ip6t_addrtype.

I'd prefer something smaller  so I can pass a fix to -stable. We
cannot pass patches bigger than 100 lines including context.
