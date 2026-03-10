Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178EC3BED20
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 16:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773158550; cv=none; b=PlP7wwOuqKGtS7BkAg/tMNxfeHO2n2bxPCuHSK5baEmPK/pI/ULE9aUsY9Ur6YXRrt91M8OgFU5W94PrARyUYRObwPCUHg13C6H6xgkzb/8pUeFNnkXwbVY6/HxtfBP45xIBuKaPm17ylhp1nVldDe0kEfm26DwRgjApMkaZ8HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773158550; c=relaxed/simple;
	bh=/NCDubX4ZG6V+SuK3bYrrAyHP9tsMHlSoWT5o6UYShA=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=FwGexCZpk8pJZjlbOPOT7ogu4/FVWJUt3qr004KAvQJxomeTJekM0IxaC04sll/SjbOagL7VPrjDEAHAcjTfMhM+a8snKZTGjYa3aWRrUPQPZm+k3hSVEYg9/WOr5ToU0CojXyaMYgII2qEIHA6kO5mOEabStjO2+C6SI6CLy4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OLzgMhuQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n1Bx5OCH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OLzgMhuQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n1Bx5OCH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773158548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+OEYoXFKm0BkEsqGzaltKYN94yuau3xOQX1u9M7pX7k=;
	b=OLzgMhuQArK6Bvp0Cz4nsFa3v1Kp0sLcqXKcu5eItO9F3MHH2laMysMLAZtXeZQxt0jf5U
	5yHvtQq1CrFSIydriTswp/nUdrlHwRr7uJVg8B9GFNMm6XJL3hlUcRaVD5A3SSgSOipnvL
	L51FDtsVmbOjuzkaotY6hq+e/OvPbvs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-g679TDBCMf-7E34K8aSkIw-1; Tue, 10 Mar 2026 12:02:26 -0400
X-MC-Unique: g679TDBCMf-7E34K8aSkIw-1
X-Mimecast-MFC-AGG-ID: g679TDBCMf-7E34K8aSkIw_1773158545
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-439b9116e2eso6120365f8f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773158545; x=1773763345; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OEYoXFKm0BkEsqGzaltKYN94yuau3xOQX1u9M7pX7k=;
        b=n1Bx5OCHYSZ/cuxUZGMW5E+ShAMC0qDijQr9hKbXQ2LIZIWNvj1mh2fm0jfNCBHTh4
         e1wxtzu+1TJQqNNI/1oNhBhPPm4JflvTgONb+4PE8r2Sa+m6Tfnil6s5em2+w23L0FA8
         lIYjxwWAaIBsQItrQ/TFRs36RDvUutrpChRl1ATHFuinehOIXOKs9Nxe9PY3XMabt783
         xhDGGlAuUHGadN4STVpcnTqP/dd7JYPwhfI1BMCYOnlDrwTe6EDrjj5LR/iuGMvq10mm
         TmwVKdnCzwm478rMHfZJJzsLrgU49400BGUYNiEuixRD+65aCvFrHdkqYk2mIcziZINl
         pIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773158545; x=1773763345;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+OEYoXFKm0BkEsqGzaltKYN94yuau3xOQX1u9M7pX7k=;
        b=V3Hc4FRzTtG5gKmKnBW1lGE7vsDiJRPoAkuCRx5ELbL2F6LZbn8K0oOeDOFxFUvobL
         aVqYTxXVIdxq4ZM+r6lZv/uN9I6b0DEd7glrjBiXm37xxW689Fsw8p3ZEMaaXn9I3lm0
         OTeB2QvqcoV0d3DmBv1hj3KaKinjwDWr1zLpdxPQIOqj5LLa8EYCCBzMfe8jYs4ZXQ/c
         DDnUkNTpHV0+Wqt8GFV/w08nppu66T7uQa9tq0GyOaXMAtgdON8GoLtUvPGw47GEJZiq
         qvIsrfMdz5UTDZoMCcOLrgmNKMIJFNuPyLLqRZqEJpdSqyY9i/zFbBNI8UNEHzz8OwXI
         viwQ==
X-Gm-Message-State: AOJu0Yx4W1nt7ofEtUSSGrx/X8z5LEkVZQIUgdBpeE/0NWsR1ydp4KIF
	YT8GJAgff8QY8U/rwHr6yoXrlUp6rRUJOuONqZZBrBVZxiD2CyKxAhbkqYS4vfe3eJs8TvU+qSx
	R4iXlJFFAYFdlY3oVMNJGHZZYglzEE+KWaFlahuX1x7C91xRnYsmvRdzBvjNR9YTXzDpyng==
X-Gm-Gg: ATEYQzz2uIAlnhcFl9BKoAYj+QIbcCYjp0RSHQIsI9ZRymmX+aEUBqgFMPHK264yyNu
	8sCWIRbinnHUUfQIFlTXiaxRNzSawdoO0iUFyT0gFAkU9/+/rSdosndKblYjlA8lc+DOgcx5m2C
	//rf0q3YDclhKkdXalWA8tB6nEhdgCpYouzY/uo3+o9qyTrFuE4MSJVsSuhSehf2RfsCyu/OyAz
	Iu7lFDAXtjH3Peg1SkRQZUJ0m6BGfI1rQxmKCUuMUVWZvIARersnt7JyDrzDZzJEyxJ5fUib9RT
	4h+B5CuFWjiPMCRd+9VoaYJ8ixWw+5a/PyA3jXaDj0UV/87hWVxBezIvufuugAtkJw4Pj5f2yMo
	HuibBoeHsDcarr3PMGyJ7IUQtVgLtx6mc
X-Received: by 2002:a05:6000:310c:b0:439:b1d8:6084 with SMTP id ffacd0b85a97d-439da67bdebmr27118229f8f.44.1773158544843;
        Tue, 10 Mar 2026 09:02:24 -0700 (PDT)
X-Received: by 2002:a05:6000:310c:b0:439:b1d8:6084 with SMTP id ffacd0b85a97d-439da67bdebmr27118167f8f.44.1773158544192;
        Tue, 10 Mar 2026 09:02:24 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad97da3sm40739544f8f.12.2026.03.10.09.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 09:02:23 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>, Yiming Qian <yimingqian591@gmail.com>
Subject: Re: [PATCH v2 nf] netfilter: nft_set_pipapo: split gc in unlink and
 reclaim phase
Message-ID: <20260310170221.086297b2@elisabeth>
In-Reply-To: <20260304053611.15197-1-fw@strlen.de>
References: <20260304053611.15197-1-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Mar 2026 17:02:22 +0100 (CET)

Sorry for the late review. Just one (perhaps dumb) question:

On Wed,  4 Mar 2026 06:36:07 +0100
Florian Westphal <fw@strlen.de> wrote:

> Yiming Qian reports Use-after-free in the pipapo set type:
>   Under a large number of expired elements, commit-time GC can run for a very
>   long time in a non-preemptible context, triggering soft lockup warnings and
>   RCU stall reports (local denial of service).
> 
> We must split GC in an unlink and a reclaim phase.
> 
> We CANNOT queue elements for reaping by the GC engine until after
> pointers have been swapped.  Expired elements are still fully exposed to
> both the packet path and userspace dumpers via the live copy of the data
> structure.
> 
> call_rcu() does NOT protect us: dump operations or element lookups starting
> after call_rcu has fired can still observe the free'd element, unless the
> commit phase has made enough progress to swap the clone and live pointers.
> 
> This a similar approach as done recently for the rbtree backend in commit
> 35f83a75529a ("netfilter: nft_set_rbtree: don't gc elements on insert").
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Reported-by: Yiming Qian <yimingqian591@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  v2: allocate gc containers and stash them in priv->gc_head, then
>  pass them to gc engine after pointer swap.  Avoids adding a pointer
>  in nft_pipapo_elem structure.
> 
>  include/net/netfilter/nf_tables.h |  5 +++
>  net/netfilter/nf_tables_api.c     |  5 ---
>  net/netfilter/nft_set_pipapo.c    | 51 ++++++++++++++++++++++++++-----
>  net/netfilter/nft_set_pipapo.h    |  2 ++
>  4 files changed, 50 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index ea6f29ad7888..e2d2bfc1f989 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1863,6 +1863,11 @@ struct nft_trans_gc {
>  	struct rcu_head		rcu;
>  };
>  
> +static inline int nft_trans_gc_space(const struct nft_trans_gc *trans)
> +{
> +	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
> +}
> +
>  static inline void nft_ctx_update(struct nft_ctx *ctx,
>  				  const struct nft_trans *trans)
>  {
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 058f7004cb2b..1862bd7fe804 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -10493,11 +10493,6 @@ static void nft_trans_gc_queue_work(struct nft_trans_gc *trans)
>  	schedule_work(&trans_gc_work);
>  }
>  
> -static int nft_trans_gc_space(struct nft_trans_gc *trans)
> -{
> -	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
> -}
> -
>  struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
>  					      unsigned int gc_seq, gfp_t gfp)
>  {
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index c091898df710..a34632ae6048 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1680,11 +1680,11 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
>  }
>  
>  /**
> - * pipapo_gc() - Drop expired entries from set, destroy start and end elements
> + * pipapo_gc_scan() - Drop expired entries from set and link them to gc list
>   * @set:	nftables API set representation
>   * @m:		Matching data
>   */
> -static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
> +static void pipapo_gc_scan(struct nft_set *set, struct nft_pipapo_match *m)
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct net *net = read_pnet(&set->net);
> @@ -1697,6 +1697,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
>  	if (!gc)
>  		return;
>  
> +	list_add(&gc->list, &priv->gc_head);

...is there a reason why we need to do this unconditionally, or could
we do this opportunistically if (__nft_set_elem_expired(&e->ext,
tstamp)) below, including the nft_trans_gc_alloc() call?

> +
>  	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
>  		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
>  		const struct nft_pipapo_field *f;
> @@ -1724,9 +1726,13 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
>  		 * NFT_SET_ELEM_DEAD_BIT.
>  		 */
>  		if (__nft_set_elem_expired(&e->ext, tstamp)) {
> -			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
> -			if (!gc)
> -				return;
> +			if (!nft_trans_gc_space(gc)) {
> +				gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
> +				if (!gc)
> +					return;
> +
> +				list_add(&gc->list, &priv->gc_head);
> +			}
>  
>  			nft_pipapo_gc_deactivate(net, set, e);
>  			pipapo_drop(m, rulemap);
> @@ -1740,10 +1746,30 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
>  		}
>  	}
>  
> -	gc = nft_trans_gc_catchall_sync(gc);
> +	priv->last_gc = jiffies;
> +}
> +
> +/**
> + * pipapo_gc_queue() - Free expired elements
> + * @set:	nftables API set representation
> + */
> +static void pipapo_gc_queue(struct nft_set *set)
> +{
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	struct nft_trans_gc *gc, *next;
> +
> +	/* always do a catchall cycle: */
> +	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
>  	if (gc) {
> +		gc = nft_trans_gc_catchall_sync(gc);
> +		if (gc)
> +			nft_trans_gc_queue_sync_done(gc);
> +	}
> +
> +	/* always purge queued gc elements. */
> +	list_for_each_entry_safe(gc, next, &priv->gc_head, list) {
> +		list_del(&gc->list);
>  		nft_trans_gc_queue_sync_done(gc);
> -		priv->last_gc = jiffies;
>  	}
>  }
>  
> @@ -1797,6 +1823,10 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
>   *
>   * We also need to create a new working copy for subsequent insertions and
>   * deletions.
> + *
> + * After the live copy has been replaced by the clone, we can safely queue
> + * expired elements that have been collected by pipapo_gc_scan() for
> + * memory reclaim.
>   */
>  static void nft_pipapo_commit(struct nft_set *set)
>  {
> @@ -1807,7 +1837,7 @@ static void nft_pipapo_commit(struct nft_set *set)
>  		return;
>  
>  	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
> -		pipapo_gc(set, priv->clone);
> +		pipapo_gc_scan(set, priv->clone);
>  
>  	old = rcu_replace_pointer(priv->match, priv->clone,
>  				  nft_pipapo_transaction_mutex_held(set));
> @@ -1815,6 +1845,8 @@ static void nft_pipapo_commit(struct nft_set *set)
>  
>  	if (old)
>  		call_rcu(&old->rcu, pipapo_reclaim_match);
> +
> +	pipapo_gc_queue(set);
>  }
>  
>  static void nft_pipapo_abort(const struct nft_set *set)
> @@ -2279,6 +2311,7 @@ static int nft_pipapo_init(const struct nft_set *set,
>  		f->mt = NULL;
>  	}
>  
> +	INIT_LIST_HEAD(&priv->gc_head);
>  	rcu_assign_pointer(priv->match, m);
>  
>  	return 0;
> @@ -2328,6 +2361,8 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct nft_pipapo_match *m;
>  
> +	WARN_ON_ONCE(!list_empty(&priv->gc_head));
> +
>  	m = rcu_dereference_protected(priv->match, true);
>  
>  	if (priv->clone) {
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
> index eaab422aa56a..9aee9a9eaeb7 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -156,12 +156,14 @@ struct nft_pipapo_match {
>   * @clone:	Copy where pending insertions and deletions are kept
>   * @width:	Total bytes to be matched for one packet, including padding
>   * @last_gc:	Timestamp of last garbage collection run, jiffies
> + * @gc_head:	list of nft_trans_gc to queue up for mem reclaim
>   */
>  struct nft_pipapo {
>  	struct nft_pipapo_match __rcu *match;
>  	struct nft_pipapo_match *clone;
>  	int width;
>  	unsigned long last_gc;
> +	struct list_head gc_head;
>  };
>  
>  struct nft_pipapo_elem;

The rest looks good to me, thanks for fixing this!

-- 
Stefano

