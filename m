Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E12C38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 13:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjARNl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 08:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjARNkz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 08:40:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1F274945
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 05:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674047392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gHmzRF55NDVvQDqugVqrIHRI91f2ypqbImcZx1JNd+8=;
        b=WcMyp+aSCK7ZcVm2B+PyAWmuSK4tucY9tth7An83tifspZo9m7mNh2zkze5wpkujT8+BID
        2HA8LBE7p66YkhFCgwy09uuBNIKGG22rWeKXG/RURW0BLybz0PuWK9JhbaSwIfvItayk6a
        PifBiVYr4MWCDvAW/OmTD1sFcvQZAAI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-EucLJPvmN5a6vsCtEYbbCQ-1; Wed, 18 Jan 2023 08:09:48 -0500
X-MC-Unique: EucLJPvmN5a6vsCtEYbbCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16A72811E6E;
        Wed, 18 Jan 2023 13:09:48 +0000 (UTC)
Received: from maya.cloud.tilaa.com (ovpn-208-4.brq.redhat.com [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89F441121315;
        Wed, 18 Jan 2023 13:09:47 +0000 (UTC)
Date:   Wed, 18 Jan 2023 14:09:44 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH 1/2 nf,v3] netfilter: nft_set_rbtree: Switch to node
 list walk for overlap detection
Message-ID: <20230118140944.6dad71a7@elisabeth>
In-Reply-To: <20230118111415.208127-1-pablo@netfilter.org>
References: <20230118111415.208127-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 18 Jan 2023 12:14:14 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> ...instead of a tree descent, which became overly complicated in an
> attempt to cover cases where expired or inactive elements would affect
> comparisons with the new element being inserted.
> 
> Further, it turned out that it's probably impossible to cover all those
> cases, as inactive nodes might entirely hide subtrees consisting of a
> complete interval plus a node that makes the current insertion not
> overlap.
> 
> To speed up the overlap check, descent the tree to find a greater
> element that is closer to the key value to insert. Then walk down the
> node list for overlap detection. Starting the overlap check from
> rb_first() unconditionally is slow, it takes 10 times longer due to the
> full linear traversal of the list.
> 
> Moreover, perform garbage collection of expired elements when walking
> down the node list to avoid bogus overlap reports.

...I'm quite convinced it's fine to perform the garbage collection
*after* we found the first element by descending the tree -- in the
worst case we include "too many" elements in the tree walk, but never
too little.

> For the insertion operation itself, this essentially reverts back to the
> implementation before commit 7c84d41416d8 ("netfilter: nft_set_rbtree:
> Detect partial overlaps on insertion"), except that cases of complete
> overlap are already handled in the overlap detection phase itself, which
> slightly simplifies the loop to find the insertion point.
> 
> Based on initial patch from Stefano Brivio, including text from the
> original patch description too.
> 
> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Nits only in case you happen to re-spin this:

> ---
> v3: simplify selection of first node, I observer long list walk with previous
>     approach.
> 
>  net/netfilter/nft_set_rbtree.c | 297 +++++++++++++++++++--------------
>  1 file changed, 170 insertions(+), 127 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 7325bee7d144..c2d3c2959084 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -38,10 +38,12 @@ static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
>  	return !nft_rbtree_interval_end(rbe);
>  }
>  
> -static bool nft_rbtree_equal(const struct nft_set *set, const void *this,
> -			     const struct nft_rbtree_elem *interval)
> +static int nft_rbtree_cmp(const struct nft_set *set,
> +			  const struct nft_rbtree_elem *e1,
> +			  const struct nft_rbtree_elem *e2)
>  {
> -	return memcmp(this, nft_set_ext_key(&interval->ext), set->klen) == 0;
> +	return memcmp(nft_set_ext_key(&e1->ext), nft_set_ext_key(&e2->ext),
> +		      set->klen);
>  }
>  
>  static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
> @@ -52,7 +54,6 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
>  	const struct nft_rbtree_elem *rbe, *interval = NULL;
>  	u8 genmask = nft_genmask_cur(net);
>  	const struct rb_node *parent;
> -	const void *this;
>  	int d;
>  
>  	parent = rcu_dereference_raw(priv->root.rb_node);
> @@ -62,12 +63,11 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
>  
>  		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
>  
> -		this = nft_set_ext_key(&rbe->ext);
> -		d = memcmp(this, key, set->klen);
> +		d = memcmp(nft_set_ext_key(&rbe->ext), key, set->klen);
>  		if (d < 0) {
>  			parent = rcu_dereference_raw(parent->rb_left);
>  			if (interval &&
> -			    nft_rbtree_equal(set, this, interval) &&
> +			    !nft_rbtree_cmp(set, rbe, interval) &&
>  			    nft_rbtree_interval_end(rbe) &&
>  			    nft_rbtree_interval_start(interval))
>  				continue;
> @@ -215,154 +215,197 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
>  	return rbe;
>  }
>  
> +static int nft_rbtree_gc_elem(const struct nft_set *__set,
> +			      struct nft_rbtree *priv,
> +			      struct nft_rbtree_elem *rbe)
> +{
> +	struct nft_set *set = (struct nft_set *)__set;
> +	struct rb_node *prev = rb_prev(&rbe->node);
> +	struct nft_rbtree_elem *rbe_prev;
> +	struct nft_set_gc_batch *gcb;
> +
> +	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
> +	if (!gcb)
> +		return -ENOMEM;
> +
> +	/* search for expired end interval coming before this element. */
> +	do {
> +		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
> +		if (nft_rbtree_interval_end(rbe_prev))
> +			break;
> +
> +		prev = rb_prev(prev);
> +	} while (prev != NULL);
> +
> +	rb_erase(&rbe_prev->node, &priv->root);
> +	rb_erase(&rbe->node, &priv->root);
> +	atomic_sub(2, &set->nelems);
> +
> +	nft_set_gc_batch_add(gcb, rbe);
> +	nft_set_gc_batch_complete(gcb);
> +
> +	return 0;
> +}
> +
>  static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  			       struct nft_rbtree_elem *new,
>  			       struct nft_set_ext **ext)
>  {
> -	bool overlap = false, dup_end_left = false, dup_end_right = false;
> +	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
> +	struct rb_node *node, *parent, **p, *first = NULL;
>  	struct nft_rbtree *priv = nft_set_priv(set);
>  	u8 genmask = nft_genmask_next(net);
> -	struct nft_rbtree_elem *rbe;
> -	struct rb_node *parent, **p;
> -	int d;
> +	int d, err;
>  
> -	/* Detect overlaps as we descend the tree. Set the flag in these cases:
> -	 *
> -	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
> -	 * a2. _ _ ___|  ?_ _ _>|  (insert end after existing end)
> -	 * a3. _ _ ___? >|_ _ __|  (insert start before existing end)
> -	 *
> -	 * and clear it later on, as we eventually reach the points indicated by
> -	 * '?' above, in the cases described below. We'll always meet these
> -	 * later, locally, due to tree ordering, and overlaps for the intervals
> -	 * that are the closest together are always evaluated last.
> -	 *
> -	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
> -	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
> -	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end, as a leaf)
> -	 *            '--' no nodes falling in this range
> -	 * b4.          >|_ _   !  (insert start before existing start)
> -	 *
> -	 * Case a3. resolves to b3.:
> -	 * - if the inserted start element is the leftmost, because the '0'
> -	 *   element in the tree serves as end element
> -	 * - otherwise, if an existing end is found immediately to the left. If
> -	 *   there are existing nodes in between, we need to further descend the
> -	 *   tree before we can conclude the new start isn't causing an overlap
> -	 *
> -	 * or to b4., which, preceded by a3., means we already traversed one or
> -	 * more existing intervals entirely, from the right.
> -	 *
> -	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
> -	 * in that order.
> -	 *
> -	 * The flag is also cleared in two special cases:
> -	 *
> -	 * b5. |__ _ _!|<_ _ _   (insert start right before existing end)
> -	 * b6. |__ _ >|!__ _ _   (insert end right after existing start)
> -	 *
> -	 * which always happen as last step and imply that no further
> -	 * overlapping is possible.
> -	 *
> -	 * Another special case comes from the fact that start elements matching
> -	 * an already existing start element are allowed: insertion is not
> -	 * performed but we return -EEXIST in that case, and the error will be
> -	 * cleared by the caller if NLM_F_EXCL is not present in the request.
> -	 * This way, request for insertion of an exact overlap isn't reported as
> -	 * error to userspace if not desired.
> -	 *
> -	 * However, if the existing start matches a pre-existing start, but the
> -	 * end element doesn't match the corresponding pre-existing end element,
> -	 * we need to report a partial overlap. This is a local condition that
> -	 * can be noticed without need for a tracking flag, by checking for a
> -	 * local duplicated end for a corresponding start, from left and right,
> -	 * separately.
> +	/* Descent the tree to search for an existing element greater than the

s/Descent/Descend/

> +	 * key value to insert that is greater than the new element. This is the
> +	 * first element to walk the ordered elements to find possible overlap.
>  	 */
> -
>  	parent = NULL;
>  	p = &priv->root.rb_node;
>  	while (*p != NULL) {
>  		parent = *p;
>  		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
> -		d = memcmp(nft_set_ext_key(&rbe->ext),
> -			   nft_set_ext_key(&new->ext),
> -			   set->klen);
> +		d = nft_rbtree_cmp(set, rbe, new);
> +
>  		if (d < 0) {
>  			p = &parent->rb_left;
> -
> -			if (nft_rbtree_interval_start(new)) {
> -				if (nft_rbtree_interval_end(rbe) &&
> -				    nft_set_elem_active(&rbe->ext, genmask) &&
> -				    !nft_set_elem_expired(&rbe->ext) && !*p)
> -					overlap = false;
> -			} else {
> -				if (dup_end_left && !*p)
> -					return -ENOTEMPTY;
> -
> -				overlap = nft_rbtree_interval_end(rbe) &&
> -					  nft_set_elem_active(&rbe->ext,
> -							      genmask) &&
> -					  !nft_set_elem_expired(&rbe->ext);
> -
> -				if (overlap) {
> -					dup_end_right = true;
> -					continue;
> -				}
> -			}
>  		} else if (d > 0) {
> +			first = &rbe->node;
>  			p = &parent->rb_right;
> -
> -			if (nft_rbtree_interval_end(new)) {
> -				if (dup_end_right && !*p)
> -					return -ENOTEMPTY;
> -
> -				overlap = nft_rbtree_interval_end(rbe) &&
> -					  nft_set_elem_active(&rbe->ext,
> -							      genmask) &&
> -					  !nft_set_elem_expired(&rbe->ext);
> -
> -				if (overlap) {
> -					dup_end_left = true;
> -					continue;
> -				}
> -			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				   !nft_set_elem_expired(&rbe->ext)) {
> -				overlap = nft_rbtree_interval_end(rbe);
> -			}
>  		} else {
> -			if (nft_rbtree_interval_end(rbe) &&
> -			    nft_rbtree_interval_start(new)) {
> +			if (nft_rbtree_interval_end(rbe))
>  				p = &parent->rb_left;
> -
> -				if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				    !nft_set_elem_expired(&rbe->ext))
> -					overlap = false;
> -			} else if (nft_rbtree_interval_start(rbe) &&
> -				   nft_rbtree_interval_end(new)) {
> +			else
>  				p = &parent->rb_right;
> +		}
> +	}
>  
> -				if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				    !nft_set_elem_expired(&rbe->ext))
> -					overlap = false;
> -			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				   !nft_set_elem_expired(&rbe->ext)) {
> -				*ext = &rbe->ext;
> -				return -EEXIST;
> -			} else {
> -				overlap = false;
> -				if (nft_rbtree_interval_end(rbe))
> -					p = &parent->rb_left;
> -				else
> -					p = &parent->rb_right;
> +	if (!first)
> +		first = rb_first(&priv->root);
> +
> +	/* Detect overlap by going through the list of valid tree nodes.
> +	 * Values stored in the tree are in reversed order, starting from
> +	 * highest to lowest value.
> +	 */
> +	for (node = first; node != NULL; node = rb_next(node)) {
> +		rbe = rb_entry(node, struct nft_rbtree_elem, node);
> +
> +		if (!nft_set_elem_active(&rbe->ext, genmask))
> +			continue;
> +
> +		/* perform garbage collection to avoid bogus overlap reports. */
> +		if (nft_set_elem_expired(&rbe->ext)) {
> +			err = nft_rbtree_gc_elem(set, priv, rbe);
> +			if (err < 0)
> +				return err;
> +
> +			continue;
> +		}
> +
> +		d = nft_rbtree_cmp(set, rbe, new);
> +		if (d == 0) {
> +			/* Matching end element: no need to look for an
> +			 * overlapping greater or equal element.
> +			 */
> +			if (nft_rbtree_interval_end(rbe)) {
> +				rbe_le = rbe;
> +				break;
>  			}
> +
> +			/* first element that is greater or equal to key value. */
> +			if (!rbe_ge) {
> +				rbe_ge = rbe;
> +				continue;
> +			}
> +
> +			/* this is a closer more or equal element, update it. */

Perhaps "Another greater or equal element, update the pointer"

> +			if (nft_rbtree_cmp(set, rbe_ge, new) != 0) {
> +				rbe_ge = rbe;
> +				continue;
> +			}
> +
> +			/* element is equal to key value, make sure flags are
> +			 * the same, an existing more or equal start element

"greater or equal"

> +			 * must not be replaced by more or equal end element.

Same here.

> +			 */
> +			if ((nft_rbtree_interval_start(new) &&
> +			     nft_rbtree_interval_start(rbe_ge)) ||
> +			    (nft_rbtree_interval_end(new) &&
> +			     nft_rbtree_interval_end(rbe_ge))) {
> +				rbe_ge = rbe;
> +				continue;
> +			}
> +		} else if (d > 0) {
> +			/* annotate element greater than the new element. */
> +			rbe_ge = rbe;
> +			continue;
> +		} else if (d < 0) {
> +			/* annotate element less than the new element. */
> +			rbe_le = rbe;
> +			break;
>  		}
> +	}
>  
> -		dup_end_left = dup_end_right = false;
> +	/* - new start element matching existing start element: full overlap
> +	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
> +	 */
> +	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
> +	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
> +		*ext = &rbe_ge->ext;
> +		return -EEXIST;
>  	}
>  
> -	if (overlap)
> +	/* - new end element matching existing end element: full overlap
> +	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
> +	 */
> +	if (rbe_le && !nft_rbtree_cmp(set, new, rbe_le) &&
> +	    nft_rbtree_interval_end(rbe_le) == nft_rbtree_interval_end(new)) {
> +		*ext = &rbe_le->ext;
> +		return -EEXIST;
> +	}
> +
> +	/* - new start element with existing closest, less or equal key value
> +	 *   being a start element: partial overlap, reported as -ENOTEMPTY.
> +	 *   Anonymous sets allow for two consecutive start element since they
> +	 *   are constant, skip them to avoid bogus overlap reports.
> +	 */
> +	if (!nft_set_is_anonymous(set) && rbe_le &&
> +	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
> +		return -ENOTEMPTY;
> +
> +	/* - new end element with existing closest, less or equal key value
> +	 *   being a end element: partial overlap, reported as -ENOTEMPTY.
> +	 */
> +	if (rbe_le &&
> +	    nft_rbtree_interval_end(rbe_le) && nft_rbtree_interval_end(new))
> +		return -ENOTEMPTY;
> +
> +	/* - new end element with existing closest, greater or equal key value
> +	 *   being an end element: partial overlap, reported as -ENOTEMPTY
> +	 */
> +	if (rbe_ge &&
> +	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
>  		return -ENOTEMPTY;
>  
> +	/* Accepted element: pick insertion point depending on key value */
> +	parent = NULL;
> +	p = &priv->root.rb_node;
> +	while (*p != NULL) {
> +		parent = *p;
> +		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
> +		d = nft_rbtree_cmp(set, rbe, new);
> +
> +		if (d < 0)
> +			p = &parent->rb_left;
> +		else if (d > 0)
> +			p = &parent->rb_right;
> +		else if (nft_rbtree_interval_end(rbe))
> +			p = &parent->rb_left;
> +		else
> +			p = &parent->rb_right;
> +	}
> +
>  	rb_link_node_rcu(&new->node, parent, p);
>  	rb_insert_color(&new->node, &priv->root);
>  	return 0;

-- 
Stefano

