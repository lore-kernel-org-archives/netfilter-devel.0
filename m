From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2 v2] bridge: set the pktinfo for IPv4/IPv6 traffic
Date: Tue, 25 Nov 2014 00:22:23 +0100
Message-ID: <20141124232223.GB3372@salvia>
References: <1416856550-15589-1-git-send-email-alvaroneay@gmail.com>
 <1416856550-15589-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39165 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaKXXUO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:20:14 -0500
Content-Disposition: inline
In-Reply-To: <1416856550-15589-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 08:15:50PM +0100, Alvaro Neira Ayuso wrote:
> This patch sets the pktinfo for IPv4/IPv6 traffic. Therefore, we can check the
> meta l4proto for IPv4/IPv6 traffic in bridge, before we don't have enough
> information to do it. Example:

I suggest:

"This patch adds the missing bits to allow to match per meta l4proto
 from the bridge. Example:" 

>   nft add rule bridge filter input ether type {ip, ip6} meta l4proto udp counter
> and
>   nft add rule bridge filter input ether type {ip, ip6} meta l4proto tcp counter

One example is enough. These two look too similar.

> With this patch, we can filter the traffic using the transport context that we
> want.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [changes in v2]
>  * Refactor the code to make it more clear
>  * Make sure that IPv6 is enabled
> 
>  net/bridge/netfilter/nf_tables_bridge.c |   21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
> index d468c19..f4471d7 100644
> --- a/net/bridge/netfilter/nf_tables_bridge.c
> +++ b/net/bridge/netfilter/nf_tables_bridge.c
> @@ -16,6 +16,8 @@
>  #include <net/netfilter/nf_tables_bridge.h>
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
> +#include <net/netfilter/nf_tables_ipv4.h>
> +#include <net/netfilter/nf_tables_ipv6.h>
>  
>  int nft_bridge_iphdr_validate(struct sk_buff *skb)
>  {
> @@ -71,7 +73,24 @@ nft_do_chain_bridge(const struct nf_hook_ops *ops,
>  {
>  	struct nft_pktinfo pkt;
>  
> -	nft_set_pktinfo(&pkt, ops, skb, in, out);
> +	switch (eth_hdr(skb)->h_proto) {
> +	case htons(ETH_P_IP):
> +		if (!nft_bridge_iphdr_validate(skb))
> +			nft_set_pktinfo(&pkt, ops, skb, in, out);
> +		else
> +			nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
> +		break;
> +	case htons(ETH_P_IPV6):
> +		#if IS_ENABLED(CONFIG_IPV6)

Never indent #if's and #endif.

In case of doubt, just check around to see how this is done in other
code, so you don't need to figure out how to make it.

Thanks.

> +			if (!nft_bridge_ip6hdr_validate(skb) ||
> +			    nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
> +				nft_set_pktinfo(&pkt, ops, skb, in, out);
> +			break;
> +		#endif
> +	default:
> +		nft_set_pktinfo(&pkt, ops, skb, in, out);
> +		break;
> +	}
>  
>  	return nft_do_chain(&pkt, ops);
>  }
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
