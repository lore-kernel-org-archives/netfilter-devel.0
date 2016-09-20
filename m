From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_meta: support for nexthop and
 nexthop6
Date: Tue, 20 Sep 2016 17:28:16 +0200
Message-ID: <20160920152816.GA18239@salvia>
References: <1473832028.1006.35.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        fw@strlen.de
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33322 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754789AbcITP2X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 11:28:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5CA812791AF
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 17:28:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A0DDDA7F6
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 17:28:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6E49DA81F
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 17:28:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473832028.1006.35.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,

On Wed, Sep 14, 2016 at 05:47:08AM +0000, Anders K. Pedersen | Cohaesio wrote:
> From: Anders K. Pedersen <akp@cohaesio.com>
> 
> Add meta support for IPv4 nexthop and IPv6 nexthop6 (i.e. the directly
> connected IP address that an outgoing packet is sent to), which can be used
> either for matching or accounting, eg.
> 
>  # nft add rule filter postrouting \
> 	ip daddr 192.168.1.0/24 meta nexthop != 192.168.0.1 drop
> 
> This will drop any traffic to 192.168.1.0/24 that is not routed via
> 192.168.0.1.
> 
>  # nft add rule filter postrouting \
> 	flow table acct { meta nexthop timeout 600s counter }
>  # nft add rule ip6 filter postrouting \
> 	flow table acct { meta nexthop6 timeout 600s counter }
> 
> These rules count outgoing traffic per nexthop. Note that the timeout
> releases an entry if no traffic is seen for this nexthop within 10 minutes.
> 
> Signed-off-by: Anders K. Pedersen <akp@cohaesio.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_meta.c                 | 23 +++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 24161e2..6ef8ac9 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -721,6 +721,8 @@ enum nft_meta_keys {
>  	NFT_META_OIFGROUP,
>  	NFT_META_CGROUP,
>  	NFT_META_PRANDOM,
> +	NFT_META_NEXTHOP,
> +	NFT_META_NEXTHOP6,
>  };

Florian is working on explicitly fib lookup expression, for the
existing route attached to the skbuff, I think we can add
nft_rt_ipv4.c, nft_rt_ipv6.c and nft_rt_inet.c expressions instead for
this? One per family, have a look at nft_meta_bridge.c for reference,
it should look similar.

I think many other rt fields could be useful with a valid usecase.

BTW, proposed syntax is:

# nft add rule filter postrouting \
	flow table acct { rt ip nexthop timeout 600s counter }

# nft add rule ip6 filter postrouting \
	flow table acct { rt ip6 nexthop timeout 600s counter }

Then, for the inet family:

# nft add rule inet filter postrouting \
	ether type ip flow table acct { rt ip nexthop timeout 600s counter }

This one should bail out if:

# nft add rule inet filter postrouting \
	ether type ip flow table acct { rt ip6 nexthop timeout 600s counter }
                   ~~                      ^^^

they don't match, this is just a bit of code at
nftables/src/evaluate.c

Thus, we pass an explicit NFTA_RT_FAMILY attribute to explicitly
indicate the family type so we can use this from the inet table too.

You need to add a expr/rt.c expression to libnftnl, it is boiler plate
code you can use meta expression as reference.

>From nft, you have to add a new EXPR_RT, there will be code missing in
evaluate.c, netlink_linearize.c and netlink_delinearize.c

>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 2863f34..a283c80 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -188,6 +190,23 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>  		*dest = prandom_u32_state(state);
>  		break;
>  	}
> +	case NFT_META_NEXTHOP: {
> +		const struct rtable *rt = skb_rtable(skb);
> +
> +		if (pkt->pf != NFPROTO_IPV4 || !rt)

With the approach above, we will not need to check for pkt->pf !=
NFPROTO_IPV4, given this will be checked from the _init() path of the
expression.

It will be a bit more code though.

Would you have a look at this? Let me know, thanks!
