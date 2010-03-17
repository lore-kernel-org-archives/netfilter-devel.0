From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/9] netfilter: xtables: inclusion of xt_TEE
Date: Wed, 17 Mar 2010 14:43:10 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003171437440.6297@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-9-git-send-email-jengelh@medozas.de> <4BA0DAB3.3000700@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42044 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab0CQNnM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:43:12 -0400
In-Reply-To: <4BA0DAB3.3000700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 14:35, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> +static void tee_tg_send(struct sk_buff *skb)
>> +{
>> +	const struct dst_entry *dst  = skb_dst(skb);
>> +	const struct net_device *dev = dst->dev;
>> +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
>> +
>> +	/* Be paranoid, rather than too clever. */
>> +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops != NULL)) {
>> +		struct sk_buff *skb2;
>> +
>> +		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
>> +		if (skb2 == NULL) {
>> +			kfree_skb(skb);
>> +			return;
>> +		}
>> +		if (skb->sk != NULL)
>> +			skb_set_owner_w(skb2, skb->sk);
>> +		kfree_skb(skb);
>> +		skb = skb2;
>> +	}
>> +
>> +	if (dst->hh != NULL) {
>> +		neigh_hh_output(dst->hh, skb);
>> +	} else if (dst->neighbour != NULL) {
>> +		dst->neighbour->output(skb);
>> +	} else {
>> +		if (net_ratelimit())
>> +			pr_debug(KBUILD_MODNAME
>> +				"no hdr & no neighbour cache!\n");
>> +		kfree_skb(skb);
>> +	}
>> +}
>
>Remind me again why we need this duplicated output function?

You did not yet approve of the reentrancy patch :-)

There is a comment block further below (at: "Normally, we would just use
ip_local_out.", quoted below) that explains the exact reasons.

>> +	if (par->hooknum == NF_INET_LOCAL_IN) {
>> +		struct iphdr *iph = ip_hdr(skb);
>> +
>> +		iph->check = 0;
>> +		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
>> +	}
>
>I guess it might make sense to decrease the TTL by one to
>avoid TEE loops between two hosts.

Sounds like a good idea. If the TTL of an incoming packet is already 1,
the administrator could use careful TTL boosting aka. -j HL/TTL --hl-inc 1.

Just one thing: as packets are manually sent out by xt_TEE currently,
is there any routing/output code left that still checks for ->ttl == 0
when it was decreased just before the hooknum check?

>> +	/*
>> +	 * Normally, we would just use ip_local_out. Because iph->check is
>> +	 * already correct, we could take a shortcut and call dst_output
>> +	 * [forwards to ip_output] directly. ip_output however will invoke
>> +	 * Netfilter hooks and cause reentrancy. So we skip that too and go
>> +	 * directly to ip_finish_output. Since we should not do XFRM, control
>> +	 * passes to ip_finish_output2. That function is not exported, so it is
>> +	 * copied here as tee_ip_direct_send.
>> +	 *
>> +	 * We do no XFRM on the cloned packet on purpose! The choice of
>> +	 * iptables match options will control whether the raw packet or the
>> +	 * transformed version is cloned.
>> +	 *
>> +	 * Also on purpose, no fragmentation is done, to preserve the
>> +	 * packet as best as possible.
>> +	 */
>> +	if (tee_tg_route4(skb, info))
>> +		tee_tg_send(skb);
>> +
>> +	return XT_CONTINUE;
>> +}
>> +
>

