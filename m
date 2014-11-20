From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2] bridge: set the pktinfo for IPv4/IPv6 traffic
Date: Thu, 20 Nov 2014 14:06:18 +0100
Message-ID: <20141120130618.GA12553@salvia>
References: <1415960990-19489-1-git-send-email-alvaroneay@gmail.com>
 <1415960990-19489-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52956 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaKTNEP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:04:15 -0500
Content-Disposition: inline
In-Reply-To: <1415960990-19489-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 14, 2014 at 11:29:50AM +0100, Alvaro Neira Ayuso wrote:
> This patch sets the pktinfo for IPv4/IPv6 traffic. Therefore, we can check the
> meta l4proto for IPv4/IPv6 traffic in bridge, before we don't have enough
> information to do it.
>
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  net/bridge/netfilter/nf_tables_bridge.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
> index d468c19..0a0f0ca 100644
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
> @@ -71,8 +73,21 @@ nft_do_chain_bridge(const struct nf_hook_ops *ops,
>  {
>  	struct nft_pktinfo pkt;
>  
> -	nft_set_pktinfo(&pkt, ops, skb, in, out);
> +	switch (eth_hdr(skb)->h_proto) {
> +	case htons(ETH_P_IP):
> +		if (!nft_bridge_iphdr_validate(skb))
> +			break;
> +		nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
> +		return nft_do_chain(&pkt, ops);

Please, clean up this, add this function:

static inline void nft_bridge_set_pktinfo_ipv4(...)
{
        if (nft_bridge_iphdr_validate(skb))
                nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
        else
                nft_set_pktinfo(&pkt, ops)
}

And use it.

> +	case htons(ETH_P_IPV6):
> +		if (!nft_bridge_ip6hdr_validate(skb))
> +			break;
> +		if (nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
> +			break;
> +		return nft_do_chain(&pkt, ops);

static inline void nft_bridge_set_pktinfo_ipv4(...)
{
#if IS_ENABLED(CONFIG_IPV6)
        if (!nft_bridge_ip6hdr_validate(skb) ||
            nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
                nft_set_pktinfo(&pkt, ops);
#endif
}

And use it. The #if is needed because nft_set_pktinfo_ipv6 calls
ipv6_find_hdr() which may not be available if CONFIG_IPV6 is set.

Then, don't forget to:

        return nft_do_chain(&pkt, ops);

so we only have one single out output path in this function.
