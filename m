Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9249B495AE8
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 12:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992974; cv=none; b=MSHUJa+70IQMiGKAdkXsf2m1ovMUTtA8pIEP3Y4COipmOzv3LC96hAlM73Aw303zcXRYUUSgfgEPQhxtFaVTBqQESMmiwI+Axn3Did0t35kIekBCpTgK/M3NnVryDbIFgQ75ZWNYlhgPqrVC/tmrjjTnrSfZT/NZmvacH0Q0WLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992974; c=relaxed/simple;
	bh=0NKkKeXWzuTCe0jMLEDxRSD60ynAhkWC1PFjOvUpMXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/tHy7Ll6RdW0J+2hkjOErdEvZ+KF5Wo+EbcWIaayvWLmWefZBJVkt65g9HJM9r2tS8OANREv7fv0zVbvdZ+KAMKqvC7eylBiS01VZq2kK1Soj3tk1a35uwcxbcOoqwNNkSzUmSkWBEPe5A2ZorYrS0AGXbG6IZQRpzflBd+yLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j4MWmXbW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j4MWmXbW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789992518;
	bh=0wBbmYv0BR0Iu5SXwY4CEBgaE7ba65RwLsCGrjPZfpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j4MWmXbWcqwF6DD1bKmWNNt+7xvHjE7xW5e00khcSZhglAB0QQOrEuOyS5WNP/jNU
	 Yr1ohAA3T+fUqf+MsUeH8Ac/3Rp3Fn5GvYPbFXtZnMbGu2k4K1qpL3xo0SLYKFl0+A
	 Q8y3ovR9uM+1So/eBGh4QTOgc2bn+89EuigUuhaQIQw4z/HgRPX27ypJiBAezWoJJD
	 v9XdJDX0aqkOmSlmCKQlo9o+7YbhfN4DrZgTV04cH+a67mZ8p2T9NUlfI7WJQJmvAh
	 lBfQFLr40Ejk/qxNAw0b/XOxbcT0S+6pRG6acVE+BReovtpUBF8dMxvWbqlvPaNOZ+
	 DZocbZLoCb+UA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BB6856005B;
	Mon, 21 Sep 2026 14:08:38 +0200 (CEST)
Date: Mon, 21 Sep 2026 14:08:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: bestswngs@gmail.com
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	phil@nwl.cc, xmei5@asu.edu, co+ee5e50ef2670e5f4@bugs.sh
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: skip transaction elements
 during GC
Message-ID: <arEeRLnELoQYlEur@chamomile>
References: <20260921020821.2587086-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260921020821.2587086-2-bestswngs@gmail.com>

On Mon, Sep 21, 2026 at 10:08:22AM +0800, bestswngs@gmail.com wrote:
> From: Weiming Shi <bestswngs@gmail.com>
> 
> Since nft_set_commit_update() runs set commit callbacks before processing
> NEWSETELEM transactions, nft_rbtree_gc_scan() can observe elements added by
> the transaction being committed.
> 
> The scan records an interval end in rbe_end without checking the element's
> transaction state. A later, unrelated expired start then moves both
> elements to the expired list. The synchronous GC queue can free the new end
> element before the transaction subsequently activates it, causing a
> use-after-free.
> 
> Only consider elements that are fully active in both generations. This
> keeps transaction-state elements out of the GC scan and preserves interval
> pairing across skipped elements.
>
> KASAN reports:
> 
>   BUG: KASAN: slab-use-after-free in nft_setelem_activate
>   nft_setelem_activate net/netfilter/nf_tables_api.c:7047
>   nf_tables_commit net/netfilter/nf_tables_api.c:11137
> 
>   Allocated by task 130:
>   nft_set_elem_init net/netfilter/nf_tables_api.c:6794
>   nft_add_set_elem net/netfilter/nf_tables_api.c:7523
> 
>   Freed by task 130:
>   nft_trans_gc_trans_free net/netfilter/nf_tables_api.c:10506
>   rcu_core kernel/rcu/tree.c:2919
>
> Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
> Reported-by: <co+ee5e50ef2670e5f4@bugs.sh>
> Assisted-by: LLM
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  net/netfilter/nft_set_rbtree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 9894832281c4b..12431b55752fb 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -900,6 +900,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
>  		next = rb_next(node);
>  
>  		rbe = rb_entry(node, struct nft_rbtree_elem, node);
> +		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
> +			continue;
>  
>  		/* elements are reversed in the rbtree for historical reasons,
>  		 * from highest to lowest value, that is why end element is

Maybe simply set rbe_end to NULL when rbe is found and is not
expired?

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9894832281c4..a9f2ae3c91cf 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -909,8 +909,10 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
                        rbe_end = rbe;
                        continue;
                }
-               if (!__nft_set_elem_expired(&rbe->ext, tstamp))
+               if (!__nft_set_elem_expired(&rbe->ext, tstamp)) {
+                       rbe_end = NULL;
                        continue;
+               }
 
                /* end element needs to be removed first, it has
                 * no timeout extension.
