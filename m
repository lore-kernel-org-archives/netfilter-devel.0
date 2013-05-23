From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: add and use nf_ipv6_ops in xt_addrtype
Date: Thu, 23 May 2013 13:18:43 +0200
Message-ID: <20130523111843.GA22664@localhost>
References: <1368798970-5837-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55930 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab3EWLSx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 May 2013 07:18:53 -0400
Content-Disposition: inline
In-Reply-To: <1368798970-5837-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 17, 2013 at 03:56:10PM +0200, Florian Westphal wrote:
> /quote https://bugzilla.netfilter.org/show_bug.cgi?id=812 :
> [ ip6tables -m addrtype ]
> When I tried to use in the nat/PREROUTING it messes up the
> routing cache even if the rule didn't matched at all.
> [..]
> If I remove the --limit-iface-in from the non-working scenario, so just
> use the -m addrtype --dst-type LOCAL it works!
> /unquote
> 
> This happens when LOCAL type matching is requested with
> --limit-iface-in, and the default ipv6 route is via the interface the
> packet we test arrived on.
> 
> Because xt_addrtype uses ip6_route_output, the ipv6 routing implementation
> creates an unwanted cached entry, and the packet won't make it to the
> real/expected destination.
> 
> Silently ignoring --limit-iface-in makes the routing work but it breaks
> rule matching (--dst-type LOCAL with limit-iface-in is supposed to only
> match if the dst address is configured on the incoming interface;
> without --limit-iface-in it will match if the address is reachable via lo).
> 
> The test should call ipv6_chk_addr() instead.  However, this would add
> a link-time dependency on ipv6.
> 
> There are two possible solutions:
> 
> 1), revert the commit that moved ipt_addrtype to xt_addrtype,
>     and put ipv6 specific code into ip6t_addrtype.
> 2) add new "nf_ipv6_ops" struct to register pointers to ipv6 functions.
> 
> While the former might seem preferable, Pablo pointed out that there are more
> xt modules with link-time dependeny issues regarding ipv6, so lets go for 2).

Applied to nf, thanks Florian.

I made some minor glitches (see below).

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo,
> 
>  as discussed this adds nf_ipv6_ops.
>  I've decided to add everything in one patch; just adding
>  empty struct nf_ipv6_ops didn't make much sense to me.
> 
>  include/linux/netfilter.h   |   14 ++++++++++++++
>  include/net/addrconf.h      |    2 +-
>  net/ipv6/addrconf.c         |    2 +-
>  net/ipv6/netfilter.c        |    7 +++++++
>  net/netfilter/core.c        |    2 ++
>  net/netfilter/xt_addrtype.c |   24 ++++++++++++++----------
>  6 files changed, 39 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 0060fde..2ed1ef5 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -230,6 +230,14 @@ struct nf_afinfo {
>  				   const struct nf_queue_entry *entry);
>  	int		route_key_size;
>  };
> +/*
> + * Hook functions for ipv6 to allow xt_* modules to be builtin even
> + * if ipv6 is a module.
> + */
> +struct nf_ipv6_ops {
> +	int (*ipv6_chk_addr)(struct net *net, const struct in6_addr *addr,
> +			     const struct net_device *dev, int strict);

Renamed this to chk_addr, all functions there will be ipv6 related and
moved this to include/linux/netfilter_ipv6.h
