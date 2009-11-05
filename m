From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Thu, 05 Nov 2009 15:32:59 +0100
Message-ID: <4AF2E21B.4050801@trash.net>
References: <4AF1D08C.2030907@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37132 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbZKEOc5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:32:57 -0500
In-Reply-To: <4AF1D08C.2030907@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Hi,
> 
> The attached patch does the following:
> 1. fix a bug introduced in commit
> 9d02002d2dc2c7423e5891b97727fde4d667adf1 (2/10/2006) which made
> ipt_REJECT stop work for bridged traffic (use of nskb instead of oldskb)
> 2. use the correct source MAC address for the response (bug reported in
> bug 531 of netfilter's bugzilla)
> 
> Tested for plain IP traffic and IP traffic encapsulated inside a VLAN
> header (should also work for PPPoE encapsulated IP traffic).
> 
> 
> --- linux-2.6.31-uml/net/bridge/br_netfilter.c.fixed	2009-11-02 21:22:00.000000000 +0100
> +++ linux-2.6.31-uml/net/bridge/br_netfilter.c	2009-11-03 22:18:41.000000000 +0100
> @@ -775,6 +766,13 @@ static unsigned int br_nf_local_out(unsi
>  		return NF_DROP;
>  
>  	nf_bridge = skb->nf_bridge;
> +	/* Enable complete transparency for e.g. ipt_REJECT */
> +	if (nf_bridge->mask & BRNF_COPY_MAC_SADDR) {
> +		skb_copy_to_linear_data_offset(skb, -8, nf_bridge->data, 6);

Please use the proper ETH_*LEN values. I guess that would be
skb_copy_to_linear_data_offset(skb, -(ETH_HLEN - ETH_ALEN),
                               nf_bridge->data, ETH_ALEN)

> +		nf_bridge_put(nf_bridge);
> +		skb->nf_bridge = NULL;
> +		return NF_ACCEPT;

Shouldn't packets with BRNF_BRIDGED_DNAT continue through NF_BR_FORWARD
like they used to?

> +	}
>  	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
>  		return NF_ACCEPT;
>  
> --- linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c.ori	2009-10-31 19:31:54.000000000 +0100
> +++ linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c	2009-11-03 21:55:08.000000000 +0100
> @@ -100,11 +100,19 @@ static void send_reset(struct sk_buff *o
>  						    sizeof(struct tcphdr), 0));
>  
>  	addr_type = RTN_UNSPEC;
> -	if (hook != NF_INET_FORWARD
>  #ifdef CONFIG_BRIDGE_NETFILTER
> -	    || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
> +	if (oldskb->nf_bridge && oldskb->nf_bridge->mask & BRNF_BRIDGED) {
> +		int daddr_offset = -14 - nf_bridge_encap_header_len(oldskb);
> +
> +		addr_type = RTN_LOCAL;
> +		if (!nf_bridge_alloc(nskb))
> +			goto free_nskb;
> +		nskb->nf_bridge->mask |= BRNF_COPY_MAC_SADDR;
> +		skb_copy_from_linear_data_offset(oldskb, daddr_offset,
> +						 nskb->nf_bridge->data, 6);

Also proper ETH_* values please. But I'm wondering, we already save
the entire header in br_nf_post_routing(). Can't that be done earlier
so the upper layers don't have to care about this stuff and can simply
attach the original nf_bridge reference?

I'm also wondering - how are ICMP rejects handled?

> +	} else
>  #endif
> -	   )
> +	if (hook != NF_INET_FORWARD)
>  		addr_type = RTN_LOCAL;

We used to route all bridged packets as RTN_LOCAL for some reason
which I'm not sure of. This is not necessary anymore?
