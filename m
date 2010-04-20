From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink_queue: use hash table to speed up entry lookup
Date: Tue, 20 Apr 2010 16:57:56 +0200
Message-ID: <4BCDC0F4.5070904@trash.net>
References: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50436 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0DTO56 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:57:58 -0400
In-Reply-To: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> use hash table to speed up entry lookup
> 
> A hash table is used to speed up entry lookup when the verdicts aren't received
> in order. The size of hash table can be specified by NFQA_CFG_QUEUE_HTBLSIZ.
> Its default value is 1. Reciprocal division is used to lower the cost of
> division, and the entry IDs are generated carefully to get fair entry
> distribution in the buckets of the hash table.

> +static u32 __get_uniq_id(struct nfqnl_instance *queue)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < INT_MAX; i++) {
> +		queue->id_sequence += queue->id_increment;
> +		if (queue->id_sequence >= queue->id_limit) {
> +			if (++queue->id_offset >= queue->id_increment)
> +				queue->id_offset = 0;
> +			queue->id_sequence = queue->id_offset;
> +		}
> +		if (__find_entry(queue, queue->id_sequence) == NULL)
> +			return queue->id_sequence;

No freaking way. So you want to lower the overhead for your case
any everyone else has to pay the price? This means that every
existing user will now have to walk the entire queue of queued
packets for every new packet.

How about you start with something simple and try to optimize
later in case there are actually performance problems? That
probably means use a simple modulo operation for cases where
the hash table size is > 1.
