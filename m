From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] netfilter: NFQUEUE: queue balancing support
Date: Fri, 5 Jun 2009 15:07:20 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051503470.17010@fbirervta.pbzchgretzou.qr>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <heitzenberger@astaro.com>,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34485 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZFENHT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:07:19 -0400
In-Reply-To: <1244164542-10739-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-06-05 03:15, Florian Westphal wrote:
> 
>+static u32 hash_v4(const struct sk_buff *skb)
>+{
>+	const struct iphdr *iph = ip_hdr(skb);
>+	u32 ipaddr;
>+
>+	/* packets in either direction go into same queue */
>+	ipaddr = iph->saddr ^ iph->daddr;
>+
>+	return jhash_2words(ipaddr, iph->protocol, jhash_initval);
>+}
>+
>+static unsigned int
>+nfqueue_tg4_v1(struct sk_buff *skb, const struct xt_target_param *par)
>+{
>+	const struct xt_NFQ_info_v1 *info = par->targinfo;
>+	u32 queue = info->queuenum;
>+
>+	if (info->queues_total > 1)
>+		queue = hash_v4(skb) % info->queues_total + queue;
>+	return NF_QUEUE_NR(queue);
>+}
>+
>+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
>+static u32 hash_v6(const struct sk_buff *skb)
>+{
>+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
>+	u32 addr[4];
>+
>+	addr[0] = ip6h->saddr.s6_addr32[0] ^ ip6h->daddr.s6_addr32[0];
>+	addr[1] = ip6h->saddr.s6_addr32[1] ^ ip6h->daddr.s6_addr32[1];
>+	addr[2] = ip6h->saddr.s6_addr32[2] ^ ip6h->daddr.s6_addr32[2];
>+	addr[3] = ip6h->saddr.s6_addr32[3] ^ ip6h->daddr.s6_addr32[3];
>+
>+	return jhash2(addr, 4, jhash_initval);
>+}
>+
>+static unsigned int
>+nfqueue_tg6_v1(struct sk_buff *skb, const struct xt_target_param *par)
>+{
>+	const struct xt_NFQ_info_v1 *info = par->targinfo;
>+	u32 queue = info->queuenum;
>+
>+	if (info->queues_total > 1)
>+		queue = hash_v6(skb) % info->queues_total + queue;
>+	return NF_QUEUE_NR(queue);
>+}
>+#endif
>+
>+static bool nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
>+{
>+	const struct xt_NFQ_info_v1 *info = par->targinfo;
>+	u32 maxid;
>+
>+	if (info->queues_total == 0) {
>+		printk(KERN_ERR "NFQUEUE: number of total queues is 0\n");
>+		return false;
>+	}
>+	maxid = info->queues_total - 1  + info->queuenum;
>+	if (maxid > 0xffff) {
>+		printk(KERN_ERR "NFQUEUE: number of queues (%u) out of range (got %u)\n",
>+							info->queues_total, maxid);
>+		return false;
>+	}
>+	return true;
>+}
>+
> static struct xt_target nfqueue_tg_reg[] __read_mostly = {
> 	{
> 		.name		= "NFQUEUE",
>@@ -39,10 +111,31 @@ static struct xt_target nfqueue_tg_reg[] __read_mostly = {
> 		.targetsize	= sizeof(struct xt_NFQ_info),
> 		.me		= THIS_MODULE,
> 	},
>+	{
>+		.name		= "NFQUEUE",
>+		.revision	= 1,
>+		.family		= NFPROTO_IPV4,
>+		.checkentry	= nfqueue_tg_v1_check,
>+		.target		= nfqueue_tg4_v1,
>+		.targetsize	= sizeof(struct xt_NFQ_info_v1),
>+		.me		= THIS_MODULE,
>+	},
>+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
>+	{
>+		.name		= "NFQUEUE",
>+		.revision	= 1,
>+		.family		= NFPROTO_IPV6,
>+		.checkentry	= nfqueue_tg_v1_check,
>+		.target		= nfqueue_tg6_v1,
>+		.targetsize	= sizeof(struct xt_NFQ_info_v1),
>+		.me		= THIS_MODULE,
>+	},
>+#endif

I'd say this could be done with much less code:

	(tg_reg with NFPROTO_UNSPEC entry) and

static bool nfqueue_v1(skb, tgpar)
{
	const struct xt_NFQ_info_v1 *info = par->targinfo;
	u32 queue = info->queuenum;

	if (info->queues_total > 1) {
		if (tgpar->target->family == NFPROTO_IPV4)
			queue = hash_v4(skb) % info->queues_total + queue;
#if IPV6
		else if (tgpar->target->family == NFPROTO_IPV6)
			queue = hash_v6(skb) % info->queues_total + queue;
#endif
	}
	return NF_QUEUE_NR(queue);
}

