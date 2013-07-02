From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ip[6]t_REJECT: tcp-reset using wrong MAC
 source if bridged
Date: Wed, 3 Jul 2013 01:41:31 +0200
Message-ID: <20130702234131.GA8412@localhost>
References: <20130626211627.GA22947@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57860 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab3GBXlq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:41:46 -0400
Content-Disposition: inline
In-Reply-To: <20130626211627.GA22947@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 26, 2013 at 05:16:28PM -0400, Phil Oester wrote:
> As reported by Casper Gripenberg, in a bridged setup, using ip[6]t_REJECT
> with the tcp-reset option sends out reset packets with the src MAC address
> of the local bridge interface, instead of the MAC address of the intended
> destination.  This causes some routers/firewalls to drop the reset packet
> as it appears to be spoofed.  Fix this by bypassing ip[6]_local_out and
> setting the MAC of the sender in the tcp reset packet. 
> 
> This closes netfilter bugzilla #531.
> 
> Phil
> 
> Signed-off-by: Phil Oester <kernel@linuxace.com>

> diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
> index 04b18c1..b969131 100644
> --- a/net/ipv4/netfilter/ipt_REJECT.c
> +++ b/net/ipv4/netfilter/ipt_REJECT.c
> @@ -119,7 +119,26 @@ static void send_reset(struct sk_buff *oldskb, int hook)
>  
>  	nf_ct_attach(nskb, oldskb);
>  
> -	ip_local_out(nskb);
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	/* If we use ip_local_out for bridged traffic, the MAC source on
> +	 * the RST will be ours, instead of the destination's.  This confuses
> +	 * some routers/firewalls, and they drop the packet.  So we need to
> +	 * build the eth header using the original destination's MAC as the
> +	 * source, and send the RST packet directly.
> +	 */
> +	if (oldskb->nf_bridge) {
> +		struct ethhdr *oeth = eth_hdr(oldskb);
> +		nskb->dev = oldskb->nf_bridge->physindev;

This won't work for locally generated traffic, physindev is null in
that case.

> +		niph->tot_len = htons(nskb->len);
> +		ip_send_check(niph);
> +		if (dev_hard_header(nskb, nskb->dev, ntohs(nskb->protocol),
> +				    oeth->h_source, oeth->h_dest, nskb->len) < 0)
> +			goto free_nskb;
> +		dev_queue_xmit(nskb);
> +	} else
> +#endif
> +		ip_local_out(nskb);
> +
>  	return;
>  
>   free_nskb:
> diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
> index 70f9abc..56eef30 100644
> --- a/net/ipv6/netfilter/ip6t_REJECT.c
> +++ b/net/ipv6/netfilter/ip6t_REJECT.c
> @@ -169,7 +169,25 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
>  
>  	nf_ct_attach(nskb, oldskb);
>  
> -	ip6_local_out(nskb);
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	/* If we use ip6_local_out for bridged traffic, the MAC source on
> +	 * the RST will be ours, instead of the destination's.  This confuses
> +	 * some routers/firewalls, and they drop the packet.  So we need to
> +	 * build the eth header using the original destination's MAC as the
> +	 * source, and send the RST packet directly.
> +	 */
> +	if (oldskb->nf_bridge) {
> +		struct ethhdr *oeth = eth_hdr(oldskb);
> +		nskb->dev = oldskb->nf_bridge->physindev;
> +		nskb->protocol = htons(ETH_P_IPV6);
> +		ip6h->payload_len = htons(sizeof(struct tcphdr));
> +		if (dev_hard_header(nskb, nskb->dev, ntohs(nskb->protocol),
> +				    oeth->h_source, oeth->h_dest, nskb->len) < 0)
> +			return;
> +		dev_queue_xmit(nskb);
> +	} else
> +#endif
> +		ip6_local_out(nskb);
>  }
>  
>  static inline void

