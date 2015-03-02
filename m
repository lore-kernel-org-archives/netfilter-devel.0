From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next v3] netfilter: reject: don't send icmp error if
 csum is invalid
Date: Mon, 2 Mar 2015 12:18:34 +0100
Message-ID: <20150302111834.GA4780@salvia>
References: <1424109244-23649-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44786 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbbCBLPE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 06:15:04 -0500
Content-Disposition: inline
In-Reply-To: <1424109244-23649-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

Sorry it took me a while to go back to this.

On Mon, Feb 16, 2015 at 06:54:04PM +0100, Florian Westphal wrote:
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index d05b364..68e0bb4 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -208,4 +208,39 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
>  }
>  EXPORT_SYMBOL_GPL(nf_send_reset6);
>  
> +static bool reject6_csum_ok(struct sk_buff *skb, int hook)
> +{
> +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +	int thoff;
> +	__be16 fo;
> +	u8 proto;
> +
> +	if (skb->csum_bad)
> +		return false;
> +
> +	if (skb_csum_unnecessary(skb))
> +		return true;
> +
> +	proto = ip6h->nexthdr;
> +	thoff = ipv6_skip_exthdr(skb, ((u8*)(ip6h+1) - skb->data), &proto, &fo);
> +
> +	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
> +		return false;

I think you can use thoff and fragoff from struct xt_action_param, so
we can save some cycles here.

> +	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
> +}

In the bridge patch it should be possible too, using pkt->xt. Probably
it's a good idea to pass pkt to nft_reject_br_send_v*_unreach().

I can take over these patches and make this changes if you like, let
me know. Thanks.
