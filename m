From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/7] netfilter: xtables2: initial table skeletal
 functions
Date: Fri, 20 Jan 2012 01:23:29 +0100
Message-ID: <20120120002329.GB3176@1984>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
 <1326990381-14534-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44583 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab2ATAXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:23:32 -0500
Content-Disposition: inline
In-Reply-To: <1326990381-14534-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Thu, Jan 19, 2012 at 05:26:15PM +0100, Jan Engelhardt wrote:
> This patch adds the xt2 table functions. Of course this does not do
> anything useful yet, chain and rule support directly follow.

First off, I'm happy to see these patches.

The netlink interface for iptables has been a missing feature for long
time.

> ---
>  include/net/netfilter/x_tables2.h |   17 +++++++
>  net/netfilter/Kconfig             |    8 +++-
>  net/netfilter/Makefile            |    1 +
>  net/netfilter/xt2_core.c          |   85 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 110 insertions(+), 1 deletions(-)
>  create mode 100644 include/net/netfilter/x_tables2.h
>  create mode 100644 net/netfilter/xt2_core.c
> 
> diff --git a/include/net/netfilter/x_tables2.h b/include/net/netfilter/x_tables2.h
> new file mode 100644
> index 0000000..a219952
> --- /dev/null
> +++ b/include/net/netfilter/x_tables2.h
> @@ -0,0 +1,17 @@
> +#ifndef _NET_NETFILTER_XTABLES2_H
> +#define _NET_NETFILTER_XTABLES2_H 1
> +
> +#define XTABLES2_VTAG "Xtables2 A8"

I don't want to center the discussion on naming, but I'd prefer if we
stick to xtables without version 2 and A8 (what does it mean A8, btw?).

At some point the old xtables infrastructure will be removed, then
we'll have lots of references to xt2 in the tree.

And, if we provide the netlink interface for xtables, we should
be able to remove the old setsockopt/getsockopt interface quite fast
(as soon as we provide user-space tools that can speak both netlink and
setsockopt/getsockopt interface for some time).

> +/**
> + * @master:	the master table
> + */
> +struct xt2_pernet_data {
> +	struct xt2_table __rcu *master;
> +};
> +
> +struct xt2_table {
> +	int _dummy;
> +};
> +
> +#endif /* _NET_NETFILTER_XTABLES2_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 32bff6d..5b3d9ca 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -321,7 +321,13 @@ config NETFILTER_XTABLES
>  	  This is required if you intend to use any of ip_tables,
>  	  ip6_tables or arp_tables.
>  
> -if NETFILTER_XTABLES
> +config NETFILTER_XTABLES2
> +	tristate "Netfilter Xtables2 packet filtering"
> +	---help---
> +	Xtables2 is a rework of the internal architecture of Xtables.
> +	It supersedes iptables, ip6tables, arptables and ebtables.

My idea is that this does not supersede any of these tools.

Instead, these tools should be ported to the netlink interface.
I prefer if users don't notice any change regarding tools in the
short term.

I still think there's valuable work in Patrick's nftables. IMO, the
scope of this work should be limited to providing the netlink
interface for iptables (ip6tables, arptables, and so on), not modifying
the command line tool syntax (which is a different discussion, don't
get me wrong I'm not telling that revisiting the syntax is bad, but
it's a different discussion and I don't want to mix things).
