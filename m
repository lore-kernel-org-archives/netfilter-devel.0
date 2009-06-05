From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: NFQUEUE: queue balancing support
Date: Fri, 05 Jun 2009 11:50:39 +0200
Message-ID: <4A28EA6F.1080109@netfilter.org>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZFEJut (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:50:49 -0400
In-Reply-To: <1244164542-10739-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> Adds support for specifying a range of queues instead of a single queue
> id.
> Flows will be distributed across the given range.

Interesting :-). One question.

> This is useful for multicore systems: Instead of having a single
> application read packets from a queue, start multiple
> instances on queues x, x+1, .. x+n. Each instance can process
> flows independently.
> 
> Packets for the same connection are put into the same queue.
> 
> Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>
> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
> ---
>  include/linux/netfilter/xt_NFQUEUE.h |    5 ++
>  net/netfilter/xt_NFQUEUE.c           |   93 ++++++++++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
> index 982a89f..2584f4a 100644
> --- a/include/linux/netfilter/xt_NFQUEUE.h
> +++ b/include/linux/netfilter/xt_NFQUEUE.h
> @@ -15,4 +15,9 @@ struct xt_NFQ_info {
>  	__u16 queuenum;
>  };
>  
> +struct xt_NFQ_info_v1 {
> +	__u16 queuenum;
> +	__u16 queues_total;
> +};
> +
>  #endif /* _XT_NFQ_TARGET_H */
> diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
> index 6e0f84d..2215b7a 100644
> --- a/net/netfilter/xt_NFQUEUE.c
> +++ b/net/netfilter/xt_NFQUEUE.c
> @@ -11,6 +11,10 @@
>  #include <linux/module.h>
>  #include <linux/skbuff.h>
>  
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/jhash.h>
> +
>  #include <linux/netfilter.h>
>  #include <linux/netfilter_arp.h>
>  #include <linux/netfilter/x_tables.h>
> @@ -23,6 +27,8 @@ MODULE_ALIAS("ipt_NFQUEUE");
>  MODULE_ALIAS("ip6t_NFQUEUE");
>  MODULE_ALIAS("arpt_NFQUEUE");
>  
> +static u32 jhash_initval __read_mostly;
> +
>  static unsigned int
>  nfqueue_tg(struct sk_buff *skb, const struct xt_target_param *par)
>  {
> @@ -31,6 +37,72 @@ nfqueue_tg(struct sk_buff *skb, const struct xt_target_param *par)
>  	return NF_QUEUE_NR(tinfo->queuenum);
>  }
>  
> +static u32 hash_v4(const struct sk_buff *skb)
> +{
> +	const struct iphdr *iph = ip_hdr(skb);
> +	u32 ipaddr;
> +
> +	/* packets in either direction go into same queue */
> +	ipaddr = iph->saddr ^ iph->daddr;

Does this guarantee that packets with NAT handlings go to the same queue?

> +
> +	return jhash_2words(ipaddr, iph->protocol, jhash_initval);
> +}

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
