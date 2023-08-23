Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F56EE49A0
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 09:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbjHWJjD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 05:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbjHWJhi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 05:37:38 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDE44EF3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 02:29:21 -0700 (PDT)
Received: from [78.30.34.192] (port=38414 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qYkAv-0047wR-Cn; Wed, 23 Aug 2023 11:29:19 +0200
Date:   Wed, 23 Aug 2023 11:29:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: defer gc run if previous batch
 is still pending
Message-ID: <ZOXRbFFQnemZ15Pc@calendula>
References: <20230823073401.16625-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230823073401.16625-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 23, 2023 at 09:33:58AM +0200, Florian Westphal wrote:
> Don't queue more gc work, else we may queue the same elements multiple
> times.
> 
> If an element is flagged as dead, this can mean that either the previous
> gc request was invalidated/discarded by a transaction or that the previous
> request is still pending in the system work queue.
> 
> The latter will happen if the gc interval is set to a very low value,
> e.g. 1ms, and system work queue is backlogged.
> 
> The sets refcount is 1 if no previous gc requeusts are queued, so add
> a helper for this and skip gc run if old requests are pending.
> 
> Add a helper for this and skip the gc run in this case.
> 
> Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  include/net/netfilter/nf_tables.h | 5 +++++
>  net/netfilter/nft_set_hash.c      | 3 +++
>  net/netfilter/nft_set_rbtree.c    | 3 +++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index ffcbdf08380f..dd40c75011d2 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -587,6 +587,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
>  	return (void *)set->data;
>  }
>  
> +static inline bool nft_set_gc_is_pending(const struct nft_set *s)
> +{
> +	return refcount_read(&s->refs) != 1;
> +}
> +
>  static inline struct nft_set *nft_set_container_of(const void *priv)
>  {
>  	return (void *)priv - offsetof(struct nft_set, data);
> diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
> index cef5df846000..524763659f25 100644
> --- a/net/netfilter/nft_set_hash.c
> +++ b/net/netfilter/nft_set_hash.c
> @@ -326,6 +326,9 @@ static void nft_rhash_gc(struct work_struct *work)
>  	nft_net = nft_pernet(net);
>  	gc_seq = READ_ONCE(nft_net->gc_seq);
>  
> +	if (nft_set_gc_is_pending(set))
> +		goto done;
> +
>  	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
>  	if (!gc)
>  		goto done;
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index f9d4c8fcbbf8..c6435e709231 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -611,6 +611,9 @@ static void nft_rbtree_gc(struct work_struct *work)
>  	nft_net = nft_pernet(net);
>  	gc_seq  = READ_ONCE(nft_net->gc_seq);
>  
> +	if (nft_set_gc_is_pending(set))
> +		goto done;
> +
>  	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
>  	if (!gc)
>  		goto done;
> -- 
> 2.41.0
> 
