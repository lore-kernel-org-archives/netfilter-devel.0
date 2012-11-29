From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] [PATCH] Handle routing changes for the MASQUERADE target
Date: Thu, 29 Nov 2012 23:44:29 +0100
Message-ID: <20121129224429.GB9370@1984>
References: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43293 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2K2Woe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:44:34 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Thu, Nov 29, 2012 at 10:12:54PM +0100, Jozsef Kadlecsik wrote:
> Hi,
> 
> This is the second variant of the patch which addresses the route 
> changes affecting already masqueraded connections.
> 
> When the route changes (backup default route, VPNs), the packets are sent 
> out with wrong source address. The patch addresses the issue by comparing 
> the outgoing interface directly with the masquerade interface in the nat 
> table. It *is* MASQUERADE specific, so probably the inserted code could be 
> enclosed in a proper ifdef.
> 
> Events are inefficient, because it'd require scanning the whole conntrack 
> table at any route change and re-checking the route for all entry, which 
> is simply way too expensive.

I still have to waste the bullet of proposing to do this from
user-space.

I think a new command for the conntrack utility to iterate over the
table and kill entries with wrong masq_index would be relatively
simple. You will have to pass the ifindex you want to compare from
user-space.

People have to update their scripts when they consider that this
action is required and we save doing this for each packet.

> Comments are highly welcomed.
> 
> Best regards,
> Jozsef
> 
> ---
>  net/ipv4/netfilter/iptable_nat.c  |   19 +++++++++++++++++++
>  net/ipv6/netfilter/ip6table_nat.c |   19 +++++++++++++++++++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
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
> +			if (del_timer(&ct->timeout)) {
> +				if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
> +					nf_ct_delete_from_lists(ct);
> +					nf_ct_insert_dying_list(ct);
> +					nf_ct_put(ct);
> +					return NF_DROP;
> +				}
> +				set_bit(IPS_DYING_BIT, &ct->status);
> +				nf_ct_delete_from_lists(ct);
> +				nf_ct_put(ct);
> +			}
> +			nf_ct_put(ct);
> +			return NF_DROP;
> +		}
>  	}
>  
>  	return nf_nat_packet(ct, ctinfo, hooknum, skb);
> diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
> index fa84cf8..d06d7de 100644
> --- a/net/ipv6/netfilter/ip6table_nat.c
> +++ b/net/ipv6/netfilter/ip6table_nat.c
> @@ -19,6 +19,7 @@
>  #include <net/netfilter/nf_nat.h>
>  #include <net/netfilter/nf_nat_core.h>
>  #include <net/netfilter/nf_nat_l3proto.h>
> +#include <net/netfilter/nf_conntrack_ecache.h>
>  
>  static const struct xt_table nf_nat_ipv6_table = {
>  	.name		= "nat",
> @@ -137,6 +138,24 @@ nf_nat_ipv6_fn(unsigned int hooknum,
>  		/* ESTABLISHED */
>  		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
>  			     ctinfo == IP_CT_ESTABLISHED_REPLY);
> +		if (hooknum == NF_INET_POST_ROUTING &&
> +		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> +		    nat->masq_index && nat->masq_index != out->ifindex) {
> +			/* Outgoing interface changed, kill ct.  */
> +			if (del_timer(&ct->timeout)) {
> +				if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
> +					nf_ct_delete_from_lists(ct);
> +					nf_ct_insert_dying_list(ct);
> +					nf_ct_put(ct);
> +					return NF_DROP;
> +				}
> +				set_bit(IPS_DYING_BIT, &ct->status);
> +				nf_ct_delete_from_lists(ct);
> +				nf_ct_put(ct);
> +			}
> +			nf_ct_put(ct);
> +			return NF_DROP;
> +		}
>  	}
>  
>  	return nf_nat_packet(ct, ctinfo, hooknum, skb);
> -- 
> 1.7.0.4
> 
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
