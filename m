From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Wed, 17 Mar 2010 14:35:47 +0100
Message-ID: <4BA0DAB3.3000700@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab0CQNft (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:35:49 -0400
In-Reply-To: <1268831945-6041-9-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +static void tee_tg_send(struct sk_buff *skb)
> +{
> +	const struct dst_entry *dst  = skb_dst(skb);
> +	const struct net_device *dev = dst->dev;
> +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
> +
> +	/* Be paranoid, rather than too clever. */
> +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops != NULL)) {
> +		struct sk_buff *skb2;
> +
> +		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
> +		if (skb2 == NULL) {
> +			kfree_skb(skb);
> +			return;
> +		}
> +		if (skb->sk != NULL)
> +			skb_set_owner_w(skb2, skb->sk);
> +		kfree_skb(skb);
> +		skb = skb2;
> +	}
> +
> +	if (dst->hh != NULL) {
> +		neigh_hh_output(dst->hh, skb);
> +	} else if (dst->neighbour != NULL) {
> +		dst->neighbour->output(skb);
> +	} else {
> +		if (net_ratelimit())
> +			pr_debug(KBUILD_MODNAME
> +				"no hdr & no neighbour cache!\n");
> +		kfree_skb(skb);
> +	}
> +}

Remind me again why we need this duplicated output function?

> +
> +/*
> + * To detect and deter routed packet loopback when using the --tee option, we
> + * take a page out of the raw.patch book: on the copied skb, we set up a fake
> + * ->nfct entry, pointing to the local &route_tee_track. We skip routing
> + * packets when we see they already have that ->nfct.
> + */
> +static unsigned int
> +tee_tg4(struct sk_buff *skb, const struct xt_target_param *par)
> +{
> +	const struct xt_tee_tginfo *info = par->targinfo;
> +
> +#ifdef WITH_CONNTRACK
> +	if (skb->nfct == &tee_track.ct_general) {
> +		/*
> +		 * Loopback - a packet we already routed, is to be
> +		 * routed another time. Avoid that, now.
> +		 */
> +		if (net_ratelimit())
> +			pr_debug(KBUILD_MODNAME "loopback - DROP!\n");
> +		return NF_DROP;
> +	}
> +#endif
> +	if (!skb_make_writable(skb, sizeof(struct iphdr)))
> +		return XT_CONTINUE;
> +	/*
> +	 * If we are in INPUT, the checksum must be recalculated since
> +	 * the length could have changed as a result of defragmentation.
> +	 */
> +	if (par->hooknum == NF_INET_LOCAL_IN) {
> +		struct iphdr *iph = ip_hdr(skb);
> +
> +		iph->check = 0;
> +		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
> +	}

I guess it might make sense to decrease the TTL by one to
avoid TEE loops between two hosts.

> +	/*
> +	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
> +	 * the original skb, which should continue on its way as if nothing has
> +	 * happened. The copy should be independently delivered to the TEE
> +	 * --gateway.
> +	 */
> +	skb = skb_copy(skb, GFP_ATOMIC);
> +	if (skb == NULL)
> +		return XT_CONTINUE;
> +
> +#ifdef WITH_CONNTRACK
> +	nf_conntrack_put(skb->nfct);
> +	skb->nfct     = &tee_track.ct_general;
> +	skb->nfctinfo = IP_CT_NEW;
> +	nf_conntrack_get(skb->nfct);
> +#endif
> +	/*
> +	 * Normally, we would just use ip_local_out. Because iph->check is
> +	 * already correct, we could take a shortcut and call dst_output
> +	 * [forwards to ip_output] directly. ip_output however will invoke
> +	 * Netfilter hooks and cause reentrancy. So we skip that too and go
> +	 * directly to ip_finish_output. Since we should not do XFRM, control
> +	 * passes to ip_finish_output2. That function is not exported, so it is
> +	 * copied here as tee_ip_direct_send.
> +	 *
> +	 * We do no XFRM on the cloned packet on purpose! The choice of
> +	 * iptables match options will control whether the raw packet or the
> +	 * transformed version is cloned.
> +	 *
> +	 * Also on purpose, no fragmentation is done, to preserve the
> +	 * packet as best as possible.
> +	 */
> +	if (tee_tg_route4(skb, info))
> +		tee_tg_send(skb);
> +
> +	return XT_CONTINUE;
> +}
> +
