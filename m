From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: NFQUEUE: queue balancing support
Date: Fri, 05 Jun 2009 13:26:06 +0200
Message-ID: <4A2900CE.5090004@trash.net>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55303 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZFEL0L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:26:11 -0400
In-Reply-To: <1244164542-10739-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> Adds support for specifying a range of queues instead of a single queue
> id.
> Flows will be distributed across the given range.
> 
> This is useful for multicore systems: Instead of having a single
> application read packets from a queue, start multiple
> instances on queues x, x+1, .. x+n. Each instance can process
> flows independently.
> 
> Packets for the same connection are put into the same queue.

Nice work, applied. I've made two minor cosmetic changes:

> +#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
> +static u32 hash_v6(const struct sk_buff *skb)
> +{
> +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +	u32 addr[4];
> +
> +	addr[0] = ip6h->saddr.s6_addr32[0] ^ ip6h->daddr.s6_addr32[0];
> +	addr[1] = ip6h->saddr.s6_addr32[1] ^ ip6h->daddr.s6_addr32[1];
> +	addr[2] = ip6h->saddr.s6_addr32[2] ^ ip6h->daddr.s6_addr32[2];
> +	addr[3] = ip6h->saddr.s6_addr32[3] ^ ip6h->daddr.s6_addr32[3];
> +
> +	return jhash2(addr, 4, jhash_initval);

I changed 4 to ARRAY_SIZE(addr)

> +static bool nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
> +{
> +	const struct xt_NFQ_info_v1 *info = par->targinfo;
> +	u32 maxid;
> +
> +	if (info->queues_total == 0) {
> +		printk(KERN_ERR "NFQUEUE: number of total queues is 0\n");
> +		return false;
> +	}
> +	maxid = info->queues_total - 1  + info->queuenum;
> +	if (maxid > 0xffff) {
> +		printk(KERN_ERR "NFQUEUE: number of queues (%u) out of range (got %u)\n",
> +							info->queues_total, maxid);
> +		return false;
> +	}
> +	return true;
> +}

and these printks to use pr_err to bring the line size down.
