Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DB32E0925
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 23:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768690812; cv=none; b=pNWbyb1Zoxl2q5G23I5m0qp4wckRpvn8/aJgOS2BnO5UQv7hIFs7+QOHw2/yUIlJZQwlVbQFlzwYSjYctIpVe4D/mV8tRiqsI8tFHiM+jBziLfnNLDvceeysDC+caSpnYeeXg4GMBBsHMQE7ORlilR+kRiVr2TIkMOuo+hpuz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768690812; c=relaxed/simple;
	bh=nSspEfmgBk6fkAYzUVKJuMPXIKNKA+g7PcZEzj7ZECc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+SGDyftGuuWvuUsUdj9CzqFqENnotfHoAQbUM85f/2Y3fkMgUw4hLuKqftAT/GjQjfSJw++b34EgzvJ4WYok6PX6V3jPxKKZHVtCI55LdjyCOhc253RpKiosrKuJtilooZQdnL1T7VLq4jXn7X+QimwrP+6eaktEqdQz/0r5pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D00B9603A1; Sun, 18 Jan 2026 00:00:07 +0100 (CET)
Date: Sun, 18 Jan 2026 00:00:07 +0100
From: Florian Westphal <fw@strlen.de>
To: scott.k.mitch1@gmail.com
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v6 2/2] netfilter: nfnetlink_queue: optimize verdict
 lookup with hash table
Message-ID: <aWwUd1Z8xz5Kk30j@strlen.de>
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-3-scott.k.mitch1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117173231.88610-3-scott.k.mitch1@gmail.com>

scott.k.mitch1@gmail.com <scott.k.mitch1@gmail.com> wrote:
> From: Scott Mitchell <scott.k.mitch1@gmail.com>
> 
> The current implementation uses a linear list to find queued packets by
> ID when processing verdicts from userspace. With large queue depths and
> out-of-order verdicting, this O(n) lookup becomes a significant
> bottleneck, causing userspace verdict processing to dominate CPU time.
> 
> Replace the linear search with a hash table for O(1) average-case
> packet lookup by ID. The hash table automatically resizes based on
> queue depth: grows at 75% load factor, shrinks at 25% load factor.
> To prevent rapid resize cycling during traffic bursts, shrinking only
> occurs if at least 60 seconds have passed since the last shrink.

Ouch.  Can we first try something simpler rather than starting a
reimplementation of rhashtable?

Or just use a global rhashtable for this?

> Hash table memory is allocated with GFP_KERNEL_ACCOUNT so memory is
> attributed to the cgroup rather than kernel overhead.
> 
> The existing list data structure is retained for operations requiring
> linear iteration (e.g. flush, device down events). Hot fields
> (queue_hash_mask, queue_hash pointer, resize state) are placed in the
> same cache line as the spinlock and packet counters for optimal memory
> access patterns.
> 
> Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>
> ---
>  include/net/netfilter/nf_queue.h |   1 +
>  net/netfilter/nfnetlink_queue.c  | 237 +++++++++++++++++++++++++++++--
>  2 files changed, 229 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> index 4aeffddb7586..3d0def310523 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -11,6 +11,7 @@
>  /* Each queued (to userspace) skbuff has one of these. */
>  struct nf_queue_entry {
>  	struct list_head	list;
> +	struct hlist_node	hash_node;
>  	struct sk_buff		*skb;
>  	unsigned int		id;
>  	unsigned int		hook_index;	/* index in hook_entries->hook[] */
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 7b2cabf08fdf..772d2a7d0d7c 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -30,6 +30,11 @@
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #include <linux/list.h>
>  #include <linux/cgroup-defs.h>
> +#include <linux/workqueue.h>
> +#include <linux/jiffies.h>
> +#include <linux/log2.h>
> +#include <linux/memcontrol.h>
> +#include <linux/sched/mm.h>
>  #include <net/gso.h>
>  #include <net/sock.h>
>  #include <net/tcp_states.h>
> @@ -46,7 +51,11 @@
>  #include <net/netfilter/nf_conntrack.h>
>  #endif
>  
> -#define NFQNL_QMAX_DEFAULT 1024
> +#define NFQNL_QMAX_DEFAULT         1024
> +#define NFQNL_HASH_MIN_SIZE        16
> +#define NFQNL_HASH_MAX_SIZE        131072

Is there a use case for such a large table?

> +#define NFQNL_HASH_DEFAULT_SIZE    NFQNL_HASH_MIN_SIZE
> +#define NFQNL_HASH_SHRINK_INTERVAL (60 * HZ)	/* Only shrink every 60 seconds */

>  /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
>   * includes the header length. Thus, the maximum packet length that we
> @@ -59,6 +68,11 @@
>  struct nfqnl_instance {
>  	struct hlist_node hlist;		/* global list of queues */
>  	struct rcu_head rcu;
> +	struct work_struct destroy_work;
> +	struct work_struct resize_work;
> +#ifdef CONFIG_MEMCG
> +	struct mem_cgroup *resize_memcg;
> +#endif

I feel this is way too complicated and over-the-top.

Can we either
1). use a global rhashtable, shared by all netns + all queues (so we
    have no extra memory tied down per queue).

OR

2). Try with a simple, statically sized hash table (16? 32? 64?) without
    any magic resizing?

And, if we go route 2), how much confidence is there that its good
enough?

Because if you already suspect you need all this extra grow/shrink logic
then then 1) is my preferred choice.

What is the deal-breaker wrt. rhashtable so that one would start to
reimplement the features it already offers?
