From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] bridge-netfilter: fix refragmenting IP traffic encapsulated
 in PPPoE traffic
Date: Thu, 15 Apr 2010 12:29:33 +0200
Message-ID: <4BC6EA8D.2030602@trash.net>
References: <4BC5BFB4.4080101@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60616 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0DOK3g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:29:36 -0400
In-Reply-To: <4BC5BFB4.4080101@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE
> traffic
> 
> The MTU for IP traffic encapsulated inside PPPoE traffic is smaller
> than the MTU of the Ethernet device (1500). Connection tracking
> gathers all IP packets and sometimes will refragment them in
> ip_fragment(). We then need to subtract the length of the
> encapsulating header from the mtu used in ip_fragment(). The check in
> br_nf_dev_queue_xmit() which determines if ip_fragment() has to be
> called is also updated for the PPPoE-encapsulated packets.
> nf_bridge_copy_header() is also updated to make sure the PPPoE data
> length field has the correct value.
> 
> Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
> 
> --- nf-next-2.6/net/bridge/br_netfilter.c.ori3	2010-04-14 14:06:05.000000000 +0200
> +++ nf-next-2.6/net/bridge/br_netfilter.c	2010-04-14 14:11:34.000000000 +0200
> @@ -221,6 +221,8 @@ int nf_bridge_copy_header(struct sk_buff
>  	skb_copy_to_linear_data_offset(skb, -header_size,
>  				       skb->nf_bridge->data, header_size);
>  	__skb_push(skb, nf_bridge_encap_header_len(skb));
> +	if (unlikely(skb->protocol == htons(ETH_P_PPP_SES)))
> +		((struct pppoe_hdr *)skb->data)->length = htons(skb->len-sizeof(struct pppoe_hdr));
>  	return 0;
>  }
>  
> @@ -744,7 +746,7 @@ static unsigned int br_nf_forward_arp(un
>  static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>  {
>  	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
> -	    skb->len > skb->dev->mtu &&
> +	    skb->len + ((skb->nf_bridge->mask & BRNF_PPPoE) ? PPPOE_SES_HLEN:0) > skb->dev->mtu &&
>  	    !skb_is_gso(skb))
>  		return ip_fragment(skb, br_dev_queue_push_xmit);
>  	else
> --- nf-next-2.6/net/ipv4/ip_output.c.ori	2010-04-14 14:01:28.000000000 +0200
> +++ nf-next-2.6/net/ipv4/ip_output.c	2010-04-14 14:02:41.000000000 +0200
> @@ -468,6 +468,10 @@ int ip_fragment(struct sk_buff *skb, int
>  
>  	hlen = iph->ihl * 4;
>  	mtu = dst_mtu(&rt->u.dst) - hlen;	/* Size of data space */
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	if (unlikely(skb->nf_bridge && (skb->nf_bridge->mask & BRNF_PPPoE)))
> +		mtu -= PPPOE_SES_HLEN;
> +#endif

I think it would be nice to encapsulate this in a small inline
function, perhaps nf_bridge_adjust_mtu(skb, mtu) or something
like that.

Please also fix the overly long lines.
