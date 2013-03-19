From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 10:26:20 -0400 (EDT)
Message-ID: <20130319.102620.2063759629502166169.davem@davemloft.net>
References: <20130319141442.150005875@eitzenberger.org>
	<20130319141605.158831637@eitzenberger.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: holger@eitzenberger.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:43170 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3CSO0X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:26:23 -0400
In-Reply-To: <20130319141605.158831637@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: holger@eitzenberger.org
Date: Tue, 19 Mar 2013 15:14:43 +0100

> +			if (par->family == NFPROTO_IPV4)
> +				queue = (((u64) hash_v4(skb) * info->queues_total) >>
> +						 32) + queue;
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +			else if (par->family == NFPROTO_IPV6)
> +				queue = (((u64) hash_v6(skb) * info->queues_total) >>
> +						 32) + queue;
> +#endif

Maybe add a helper function so you don't have to indent so deeply.  Something
like:

static u32 compute_queue(struct sk_buff *skb, u32 queue, u16 family, u16 qtotl)
{
	u32 hash;

	if (family == NFPROTO_IPV4)
		hash = hash_v4(skb);
#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
	else if (family == NFPROTO_IPV6)
		hash = hash_v6(skb);
#endif

	return (((u64) hash * qtotl) >> 32) + queue;
}
