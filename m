Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AE0C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 22:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjBVWSh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 17:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjBVWSa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 17:18:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F8B44740A
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 14:18:12 -0800 (PST)
Date:   Wed, 22 Feb 2023 23:17:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [RFC nf-next PATCH] netfilter: nft: introduce broute chain type
Message-ID: <Y/aUfa1KmvN8igqF@salvia>
References: <20230222110337.15951-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230222110337.15951-1-sriram.yagnaraman@est.tech>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 22, 2023 at 12:03:37PM +0100, Sriram Yagnaraman wrote:
> Is there any interest or plan to implement BROUTE chain type for nftables?
> 
> We have a situation when a network interface that is part of a bridge is
> used to receive PTP and/or EAPOL packets. Userspace daemons that use
> AF_PACKET to capture specific ether types do not receive the packets,
> and they are instead bridged. We are currently still using etables -t
> broute to send packets packets up the stack. This functionality seems to
> be missing in nftables. Below you can find a proposal that could be used,
> of course there is some work to introduce the chain type and a default
> priority in nftables userspace tool.

Would it be possible to use the ingress hook for this feature?

> I could see there are other users asking for BROUTE:
> [1]: https://bugzilla.netfilter.org/show_bug.cgi?id=1316
> [2]: https://lore.kernel.org/netfilter-devel/20191024114653.GU25052@breakpoint.cc/
> [3]: https://marc.info/?l=netfilter&m=154807010116514
> 
> broute chain type is just a copy from etables -t broute implementation.
> NF_DROP: skb is routed instead of bridged, and mapped to NF_ACCEPT.

Would it be possible to add a specific action instead of (ab)using these
verdicts?

> All other verdicts are returned as it is.
> 
> Please advise if there are better ways to solve this instead of using
> the br_netfilter_broute flag.
> 
> ---
>  include/net/netfilter/nf_tables.h |  4 ++
>  net/netfilter/Makefile            |  2 +-
>  net/netfilter/nf_tables_api.c     |  2 +
>  net/netfilter/nft_chain_broute.c  | 82 +++++++++++++++++++++++++++++++
>  4 files changed, 89 insertions(+), 1 deletion(-)
>  create mode 100644 net/netfilter/nft_chain_broute.c
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 9430128aae99..cf7b36d54115 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1090,6 +1090,7 @@ enum nft_chain_types {
>  	NFT_CHAIN_T_DEFAULT = 0,
>  	NFT_CHAIN_T_ROUTE,
>  	NFT_CHAIN_T_NAT,
> +	NFT_CHAIN_T_BROUTE,
>  	NFT_CHAIN_T_MAX
>  };
>  
> @@ -1665,6 +1666,9 @@ void nft_chain_filter_fini(void);
>  void __init nft_chain_route_init(void);
>  void nft_chain_route_fini(void);
>  
> +void __init nft_chain_broute_init(void);
> +void nft_chain_broute_fini(void);
> +
>  void nf_tables_trans_destroy_flush_work(void);
>  
>  int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 5ffef1cd6143..fd0e79d2d11e 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -91,7 +91,7 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
>  		  nft_counter.o nft_objref.o nft_inner.o \
>  		  nft_chain_route.o nf_tables_offload.o \
>  		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
> -		  nft_set_pipapo.o
> +		  nft_set_pipapo.o nft_chain_broute.o
>  
>  ifdef CONFIG_X86_64
>  ifndef CONFIG_UML
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d73edbd4eec4..a95f138562e2 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -10389,6 +10389,7 @@ static int __init nf_tables_module_init(void)
>  		goto err_nfnl_subsys;
>  
>  	nft_chain_route_init();
> +	nft_chain_broute_init();
>  
>  	return err;
>  
> @@ -10417,6 +10418,7 @@ static void __exit nf_tables_module_exit(void)
>  	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
>  	nft_chain_filter_fini();
>  	nft_chain_route_fini();
> +	nft_chain_broute_fini();
>  	unregister_pernet_subsys(&nf_tables_net_ops);
>  	cancel_work_sync(&trans_destroy_work);
>  	rcu_barrier();
> diff --git a/net/netfilter/nft_chain_broute.c b/net/netfilter/nft_chain_broute.c
> new file mode 100644
> index 000000000000..9c8461ec8fde
> --- /dev/null
> +++ b/net/netfilter/nft_chain_broute.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/module.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <linux/netfilter_bridge.h>
> +#include <net/netfilter/nf_tables_ipv4.h>
> +#include <net/netfilter/nf_tables_ipv6.h>
> +#include "../bridge/br_private.h"
> +
> +#ifdef CONFIG_NF_TABLES_BRIDGE
> +static unsigned int
> +nft_do_chain_broute(void *priv,
> +		    struct sk_buff *skb,
> +		    const struct nf_hook_state *state)
> +{
> +	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
> +	unsigned char *dest;
> +	struct nft_pktinfo pkt;
> +	int ret;
> +
> +	nft_set_pktinfo(&pkt, skb, state);
> +
> +	switch (eth_hdr(skb)->h_proto) {
> +	case htons(ETH_P_IP):
> +		nft_set_pktinfo_ipv4_validate(&pkt);
> +		break;
> +	case htons(ETH_P_IPV6):
> +		nft_set_pktinfo_ipv6_validate(&pkt);
> +		break;
> +	default:
> +		nft_set_pktinfo_unspec(&pkt);
> +		break;
> +	}
> +
> +	ret = nft_do_chain(&pkt, priv);
> +	if ((ret & NF_VERDICT_MASK) == NF_DROP) {
> +		/* DROP in ebtables -t broute means that the
> +		* skb should be routed, not bridged.
> +		* This is awkward, but can't be changed for compatibility
> +		* reasons.
> +		*
> +		* We map DROP to ACCEPT and set the ->br_netfilter_broute flag.
> +		*/
> +		ret = NF_ACCEPT;
> +		BR_INPUT_SKB_CB(skb)->br_netfilter_broute = 1;
> +		/* undo PACKET_HOST mangling done in br_input in case the dst
> +		* address matches the logical bridge but not the port.
> +		*/
> +		dest = eth_hdr(skb)->h_dest;
> +		if (skb->pkt_type == PACKET_HOST &&
> +		    !ether_addr_equal(skb->dev->dev_addr, dest) &&
> +		    ether_addr_equal(p->br->dev->dev_addr, dest))
> +			skb->pkt_type = PACKET_OTHERHOST;
> +	}
> +	return ret;
> +}
> +
> +static const struct nft_chain_type nft_chain_broute = {
> +	.name		= "broute",
> +	.type		= NFT_CHAIN_T_BROUTE,
> +	.family		= NFPROTO_BRIDGE,
> +	.hook_mask	= (1 << NF_BR_PRE_ROUTING),
> +	.hooks		= {
> +		[NF_BR_PRE_ROUTING]	= nft_do_chain_broute,
> +	},
> +};
> +#endif
> +
> +void __init nft_chain_broute_init(void)
> +{
> +#ifdef CONFIG_NF_TABLES_BRIDGE
> +	nft_register_chain_type(&nft_chain_broute);
> +#endif
> +}
> +
> +void __exit nft_chain_broute_fini(void)
> +{
> +#ifdef CONFIG_NF_TABLES_BRIDGE
> +	nft_unregister_chain_type(&nft_chain_broute);
> +#endif
> +}
> -- 
> 2.34.1
> 
