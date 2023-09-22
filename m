Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B66CD4F49
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 10:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjIVKMh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 06:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjIVKMe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 06:12:34 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D718F
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 03:12:26 -0700 (PDT)
Received: from [78.30.34.192] (port=55796 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qjd94-00EV3W-EB; Fri, 22 Sep 2023 12:12:24 +0200
Date:   Fri, 22 Sep 2023 12:12:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf] netfilter: nf_tables: nft_set_rbtree: invalidate
 greater range element on removal
Message-ID: <ZQ1ohTAB/u2XZRpV@calendula>
References: <20230921135212.31288-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230921135212.31288-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Thu, Sep 21, 2023 at 03:52:09PM +0200, Florian Westphal wrote:
> nft_rbtree_gc_elem() walks back and removes the end interval element that
> comes before the expired element.
> 
> There is a small chance that we've cached this element as 'rbe_ge'.
> If this happens, we hold and test a pointer that has been queued for
> freeing.
> 
> It also causes spurious insertion failures:
> 
> $ cat nft-test.20230921-143934.826.dMBwHt/test-testcases-sets-0044interval_overlap_0.1/testout.log
> Error: Could not process rule: File exists
> add element t s {  0 -  2 }
>                    ^^^^^^
> Failed to insert  0 -  2 given:
> table ip t {
>         set s {
>                 type inet_service
>                 flags interval,timeout
>                 timeout 2s
>                 gc-interval 2s
>         }
> }
> 
> The set (rbtree) is empty. The 'failure' doesn't happen when userspace
> retries immediately.
> 
> Reason is that when we try to insert, the tree may hold an expired
> element that collides with the range we're adding.
> While we do evict/erase this element, we can trip over this check:
> 
> if (rbe_ge && nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
>       return -ENOTEMPTY;
> 
> But rbe_ge was already erased/collected by the synchronous gc, we should
> not have done this check.
> 
> Because the pointer is stale, next attempt won't find it and insertion
> can succeed.
> 
> I'd feel better if the entire procedure would be re-tried to make sure
> we do not mask/skip an earlier colliding element post invalidation
> of rbe_ge.
> 
> Caching the old rbe_ge would work, but would make this even more
> messy.
> 
> Any comments?

Thanks a lot for tracking down this issue.

> Main agenda here is to not just fix the spurious failure but to
> get rid of the async gc worker.

I would like to move this sync GC collection from insert() path, it is
sloppy and zapping entries that we hold references to as in this case.
I would like to move to use the .commit phase just like pipapo.

I cannot currently do it this because this GC run is required by the
overlap check and the insertion itself (I made a patch to move it
.commit but it breaks).

The only solution I can see right now is to maintain two copies of the
rbtree, just like pipapo, then use the .commit phase, I started
sketching this updates.

Meanwhile setting rbe_ge and rbe_le to NULL if the element that is
referenced is removed makes sense to me.

The current GC sync inlined in insert() is also making it hard to
support for timeout refresh (element update command) without
reintroducing the _BUSY bit, which is something I would like to skip.

Then, there is another possibility that is to provide a hint to
userspace to use pipapo instead rbtree, via _GENMSG, but there is a
need to update pipapo to allow for singleton sets (with no
concatenation), which requires a oneliner in the kernel.

The rbtree set backend is the corner that holds more technical debt
IMO.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_rbtree.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 487572dcd614..836f3a71e15b 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -233,10 +233,9 @@ static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
>  	rb_erase(&rbe->node, &priv->root);
>  }
>  
> -static int nft_rbtree_gc_elem(const struct nft_set *__set,
> -			      struct nft_rbtree *priv,
> -			      struct nft_rbtree_elem *rbe,
> -			      u8 genmask)
> +static const struct nft_rbtree_elem *
> +nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
> +		   struct nft_rbtree_elem *rbe, u8 genmask)
>  {
>  	struct nft_set *set = (struct nft_set *)__set;
>  	struct rb_node *prev = rb_prev(&rbe->node);
> @@ -246,7 +245,7 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
>  
>  	gc = nft_trans_gc_alloc(set, 0, GFP_ATOMIC);
>  	if (!gc)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	/* search for end interval coming before this element.
>  	 * end intervals don't carry a timeout extension, they
> @@ -261,6 +260,7 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
>  		prev = rb_prev(prev);
>  	}
>  
> +	rbe_prev = NULL;
>  	if (prev) {
>  		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
>  		nft_rbtree_gc_remove(net, set, priv, rbe_prev);
> @@ -272,7 +272,7 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
>  		 */
>  		gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
>  		if (WARN_ON_ONCE(!gc))
> -			return -ENOMEM;
> +			return ERR_PTR(-ENOMEM);
>  
>  		nft_trans_gc_elem_add(gc, rbe_prev);
>  	}
> @@ -280,13 +280,13 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
>  	nft_rbtree_gc_remove(net, set, priv, rbe);
>  	gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
>  	if (WARN_ON_ONCE(!gc))
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	nft_trans_gc_elem_add(gc, rbe);
>  
>  	nft_trans_gc_queue_sync_done(gc);
>  
> -	return 0;
> +	return rbe_prev;
>  }
>  
>  static bool nft_rbtree_update_first(const struct nft_set *set,
> @@ -314,7 +314,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  	struct nft_rbtree *priv = nft_set_priv(set);
>  	u8 cur_genmask = nft_genmask_cur(net);
>  	u8 genmask = nft_genmask_next(net);
> -	int d, err;
> +	int d;
>  
>  	/* Descend the tree to search for an existing element greater than the
>  	 * key value to insert that is greater than the new element. This is the
> @@ -363,10 +363,14 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  		 */
>  		if (nft_set_elem_expired(&rbe->ext) &&
>  		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
> -			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
> -			if (err < 0)
> -				return err;
> +			const struct nft_rbtree_elem *removed_end;
> +
> +			removed_end = nft_rbtree_gc_elem(set, priv, rbe, genmask);
> +			if (IS_ERR(removed_end))
> +				return PTR_ERR(removed_end);
>  
> +			if (removed_end == rbe_ge)
> +				rbe_ge = NULL;
>  			continue;
>  		}
>  
> -- 
> 2.41.0
> 
