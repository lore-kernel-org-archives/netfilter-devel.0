From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] [PATCH] Handle routing changes for the MASQUERADE target
Date: Thu, 29 Nov 2012 22:26:40 +0100
Message-ID: <20121129212640.GB26937@breakpoint.cc>
References: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59425 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab2K2V0l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:26:41 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:

Hi Jozsef,

this looks really good, two minor nits below.

> diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
> index ac635a7..128885d 100644
> --- a/net/ipv4/netfilter/iptable_nat.c
> +++ b/net/ipv4/netfilter/iptable_nat.c
> @@ -17,6 +17,7 @@
>  #include <net/netfilter/nf_nat.h>
>  #include <net/netfilter/nf_nat_core.h>
>  #include <net/netfilter/nf_nat_l3proto.h>
> +#include <net/netfilter/nf_conntrack_ecache.h>
>  
>  static const struct xt_table nf_nat_ipv4_table = {
>  	.name		= "nat",
> @@ -134,6 +135,24 @@ nf_nat_ipv4_fn(unsigned int hooknum,
>  		/* ESTABLISHED */
>  		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
>  			     ctinfo == IP_CT_ESTABLISHED_REPLY);
> +		if (hooknum == NF_INET_POST_ROUTING &&
> +		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> +		    nat->masq_index && nat->masq_index != out->ifindex) {
> +			/* Outgoing interface changed, kill ct.  */

Would it be possible to use nf_ct_kill_acct() here instead of

> +			if (del_timer(&ct->timeout)) {
> +				if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
[..]

?

> --- a/net/ipv6/netfilter/ip6table_nat.c
> +++ b/net/ipv6/netfilter/ip6table_nat.c
> @@ -19,6 +19,7 @@
>  #include <net/netfilter/nf_nat.h>
>  #include <net/netfilter/nf_nat_core.h>
>  #include <net/netfilter/nf_nat_l3proto.h>
[..]
>  static const struct xt_table nf_nat_ipv6_table = {
> +		if (hooknum == NF_INET_POST_ROUTING &&
> +		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> +		    nat->masq_index && nat->masq_index != out->ifindex) {
> +			/* Outgoing interface changed, kill ct.  */
> +			if (del_timer(&ct->timeout)) {

perhaps this could be a helper in include/net/netfilter/nf_nat.h?

It would avoid the code duplication and the needed #if IS_ENABLED() MASQ
check.
