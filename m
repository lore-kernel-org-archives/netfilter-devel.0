From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: avoid integer overflow when
 resizing
Date: Fri, 29 Apr 2016 11:59:02 +0200
Message-ID: <20160429095902.GA15406@salvia>
References: <1461453501-4428-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39577 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbcD2J7M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:59:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C201C1BFA8B
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:59:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B32D2100A4E
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:59:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 05978100A59
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:59:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461453501-4428-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 24, 2016 at 01:18:21AM +0200, Florian Westphal wrote:
> Can overflow so we might allocate very small table when bucket count is
> high on a 32bit platform.
> 
> Note: resize is only possible from init_netns.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 2bbb962..11daca5 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1563,8 +1563,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
>  	unsigned int nr_slots, i;
>  	size_t sz;
>  
> +	if (*sizep > (UINT_MAX / sizeof(struct hlist_nulls_head)))
> +		return NULL;

*sizep gets initially set to the number of buckets.

>  	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
>  	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));

Then, this value is divided by the number of hlist heads that fit into
a page.

> +
> +	if (nr_slots > (UINT_MAX / sizeof(struct hlist_nulls_head)))
> +		return NULL;

So, isn't is enough with this sole check? I might be missing anything.

> +
>  	sz = nr_slots * sizeof(struct hlist_nulls_head);
>  	hash = (void *)__get_free_pages(GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO,
>  					get_order(sz));
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
