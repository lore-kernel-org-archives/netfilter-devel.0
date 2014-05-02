From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC] Bridge: do not defragment packets unless connection
 tracking is enabled
Date: Sat, 3 May 2014 00:55:22 +0200
Message-ID: <20140502225522.GA12404@breakpoint.cc>
References: <20140430092905.GA4318@localhost>
 <5363BC86.6050608@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59018 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbaEBWz0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 May 2014 18:55:26 -0400
Content-Disposition: inline
In-Reply-To: <5363BC86.6050608@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin <vvs@parallels.com> wrote:
> Also I have one more question -- about defrag user check.
> 
> In my patch I use
> if ((user >= IP_DEFRAG_CONNTRACK_BRIDGE_IN) && 
>     (user <= __IP_DEFRAG_CONNTRACK_BRIDGE_IN))
> because nf_ct_defrag_user can add zone.
> 
> I've found defrag user check in ip_expire() -- but it does not take
> account of zone.
> Is it a bug in ip_expire() or I missed something?

Looks like a bug to me.

> ---[patch rfc]---
> Currently bridge can silently drop ipv4 fragments.
> If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
> br_nf_pre_routing defragments incoming ipv4 fragments, but skb->nfct check
> in br_nf_dev_queue_xmit does not allow to re-fragment combined packet back,
> and therefore it is dropped in br_dev_queue_push_xmit without incrementing
> of any failcounters.
> 
> According to Patrick McHardy, bridge should not defragment and fragment
> packets unless conntrack is enabled.
> 
> This patch adds per network namespace flag to manage ipv4 defragmentation
> in bridge.
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>

Are we sure this is required rather than just removing the skb->nfct
test in br_nf_dev_queue_xmit() and be done with it?

Because that seems a lot saner to me, I fail to see how

if (skb->protocol == htons(ETH_P_IP) &&
           skb->len + nf_bridge_mtu_reduction(skb) >
		    skb->dev->mtu && !skb_is_gso(skb)) {

Would evaluate as 'true' without nf_defrag_ipv4 module loaded.

[ its from br_nf_dev_queue_xmit function ]

>  struct nf_generic_net {
>  	struct nf_proto_net pn;
>  	unsigned int timeout;
> +	bool br_ipv4_defrag_disabled;
>  };

>  struct nf_tcp_net {
> diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
> index d807822..5f773d4 100644
> --- a/net/ipv4/netfilter/nf_defrag_ipv4.c
> +++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
> @@ -87,6 +87,20 @@ static unsigned int ipv4_conntrack_defrag(const struct nf_hook_ops *ops,
>  		enum ip_defrag_users user =
>  			nf_ct_defrag_user(ops->hooknum, skb);
>  
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK) && defined (CONFIG_BRIDGE_NETFILTER)
> +		if ((user >= IP_DEFRAG_CONNTRACK_BRIDGE_IN) &&
> +		    (user <= __IP_DEFRAG_CONNTRACK_BRIDGE_IN)) {
> +#ifdef CONFIG_NET_NS
> +			struct net *net = skb->sk->sk_net;
> +#else
> +			struct net *net = &init_net;
> +#endif
> +			/* A bridge should not defragment and fragment packets. 
> +			   We only do it if connection tracking is enabled. */
> +			if (net->ct.nf_ct_proto.generic.br_ipv4_defrag_disabled)
> +				return NF_ACCEPT;
> +		}
> +#endif

I wonder who would be responsible to set br_ipv4_defrag_disabled to false
to enable conntracking on a bridge again?

Did i miss something in the patch?

Thanks.
