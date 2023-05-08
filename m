Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55289C77B7F
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 14:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbjEHODN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 10:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbjEHODL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 10:03:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AD436550
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2023 07:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683554543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g89QiS7Yr/Bf0N+baMVDnM3swXZxmvGD0RfxhQxLY4o=;
        b=ZgimxqMvM2zm1PA03+3LHrlfFSD3N+Z+oicWtvhetQWC3dCML0kZ/s4BQ+XBMcgfVDY1jr
        eA05ydRF2UUZL8IvZ4vYOr3TG5CNv6lEf6QlRnwsAIq4kOfxSOmxBlrIS9imQ6nR8nm9/K
        d2ALHRzXKdWf807wT2XdTv5zaH2P4xo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-YPD7AhbZNIqFG-MMRfnFTA-1; Mon, 08 May 2023 10:02:21 -0400
X-MC-Unique: YPD7AhbZNIqFG-MMRfnFTA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E28AA8995AE;
        Mon,  8 May 2023 14:02:20 +0000 (UTC)
Received: from elisabeth (unknown [10.39.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B4C4492B00;
        Mon,  8 May 2023 14:02:19 +0000 (UTC)
Date:   Mon, 8 May 2023 16:02:12 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: integrate pipapo into commit
 protocol
Message-ID: <20230508160212.0d092d19@elisabeth>
In-Reply-To: <20230424133320.145860-1-pablo@netfilter.org>
References: <20230424133320.145860-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sorry for the delay.

On Mon, 24 Apr 2023 15:33:20 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> The pipapo set backend follows copy-on-update approach, maintaining one
> clone of the existing datastructure that is being updated. The clone
> and current datastructures are swapped via rcu from the commit step.
> 
> The existing integration with the commit protocol is flawed because
> there is no operation to clean up the clone if the transaction is
> aborted. Moreover, the datastructure swap happens on set element
> activation.
> 
> This patch adds two new operations for sets: commit and abort, these new
> operations are invoked from the commit and abort steps, after the
> transactions have been digested, and it updates the pipapo set backend
> to use it.
> 
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Hi Stefano,
> 
> I don't see any path to reset ->dirty in case that the transaction is aborted.
> This might lead to this sequence:
> 
> 1) add set element: ->insert adds new entry in the clone (preparation phase)
> 2) any command that fails (preparation phase)
> 3) abort phase (->dirty bit is left set on and priv->clone contains an partial update)

That's because nft_pipapo_activate() can't fail on elements that are
successfully inserted by nft_pipapo_insert() -- that is, the
pipapo_get() call from nft_pipapo_activate() should always succeed.

Now, let's say that one call to nft_pipapo_insert() fails: at that
point I would expect all the pending insertions to be deleted before
the abort phase completes. So yes, we have a dirty bit unnecessarily
set, but the clone shouldn't actually contain a partial update.

Regardless of that, having an actual abort operation is cleaner than
this and definitely welcome.

> I am trying to figure out if this could be related to:
> https://bugzilla.netfilter.org/show_bug.cgi?id=1583

For sure this simplifies the matter, but I'm not sure exactly in which
way it could be related (I'm not saying that there's no way, though).

>  include/net/netfilter/nf_tables.h |  3 +-
>  net/netfilter/nf_tables_api.c     | 36 +++++++++++++++++++++
>  net/netfilter/nft_set_pipapo.c    | 53 ++++++++++++++++++++++---------
>  3 files changed, 76 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 552e19ba4f43..211921dd0ac6 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -462,7 +462,8 @@ struct nft_set_ops {
>  					       const struct nft_set *set,
>  					       const struct nft_set_elem *elem,
>  					       unsigned int flags);
> -
> +	void				(*commit)(const struct nft_set *set);
> +	void				(*abort)(const struct nft_set *set);
>  	u64				(*privsize)(const struct nlattr * const nla[],
>  						    const struct nft_set_desc *desc);
>  	bool				(*estimate)(const struct nft_set_desc *desc,
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 0e072b2365df..ef8d9f6a7e9c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9259,6 +9259,22 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
>  	}
>  }
>  
> +static void nft_set_commit_update(struct net *net)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(net);
> +	struct nft_table *table;
> +	struct nft_set *set;
> +
> +	list_for_each_entry(table, &nft_net->tables, list) {
> +		list_for_each_entry(set, &table->sets, list) {
> +			if (!set->ops->commit)
> +				continue;
> +
> +			set->ops->commit(set);
> +		}
> +	}
> +}
> +
>  static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
> @@ -9513,6 +9529,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  		}
>  	}
>  
> +	nft_set_commit_update(net);
> +
>  	nft_commit_notify(net, NETLINK_CB(skb).portid);
>  	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
>  	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
> @@ -9572,6 +9590,22 @@ static void nf_tables_abort_release(struct nft_trans *trans)
>  	kfree(trans);
>  }
>  
> +static void nft_set_abort_update(struct net *net)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(net);
> +	struct nft_table *table;
> +	struct nft_set *set;
> +
> +	list_for_each_entry(table, &nft_net->tables, list) {
> +		list_for_each_entry(set, &table->sets, list) {
> +			if (!set->ops->abort)
> +				continue;
> +
> +			set->ops->abort(set);
> +		}
> +	}
> +}
> +
>  static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
> @@ -9737,6 +9771,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  		}
>  	}
>  
> +	nft_set_abort_update(net);
> +
>  	synchronize_rcu();
>  
>  	list_for_each_entry_safe_reverse(trans, next,

I didn't imagine it would be so simple -- I would have gone with this
right away. On the other hand, I had no idea where to put those calls :)

Now that we have commit and abort operations, I'm wondering: what if we
make activate and deactivate callbacks optional? They're not really
needed by nft_set_pipapo: all the elements could be directly "active"
on insertion, and remain active until we have a commit operation after
they are deleted.

I'm not sure if there are drawbacks, and I think that your patch works
anyway as expected.

> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 06d46d182634..06b8b26e666a 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1600,17 +1600,10 @@ static void pipapo_free_fields(struct nft_pipapo_match *m)
>  	}
>  }
>  
> -/**
> - * pipapo_reclaim_match - RCU callback to free fields from old matching data
> - * @rcu:	RCU head
> - */
> -static void pipapo_reclaim_match(struct rcu_head *rcu)

/**
 * pipapo_free_match() - Free fields from unused matching data
 * @m:		Matching data
 */

> +static void pipapo_free_match(struct nft_pipapo_match *m)
>  {
> -	struct nft_pipapo_match *m;
>  	int i;
>  
> -	m = container_of(rcu, struct nft_pipapo_match, rcu);
> -
>  	for_each_possible_cpu(i)
>  		kfree(*per_cpu_ptr(m->scratch, i));
>  
> @@ -1625,7 +1618,19 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
>  }
>  
>  /**
> - * pipapo_commit() - Replace lookup data with current working copy
> + * pipapo_reclaim_match - RCU callback to free fields from old matching data

 * pipapo_reclaim_match() - RCU callback to free unused matching data

...it's not necessarily "old" anymore.

> + * @rcu:	RCU head
> + */
> +static void pipapo_reclaim_match(struct rcu_head *rcu)
> +{
> +	struct nft_pipapo_match *m;
> +
> +	m = container_of(rcu, struct nft_pipapo_match, rcu);
> +	pipapo_free_match(m);
> +}
> +
> +/**
> + * nft_pipapo_commit() - Replace lookup data with current working copy
>   * @set:	nftables API set representation
>   *
>   * While at it, check if we should perform garbage collection on the working
> @@ -1635,7 +1640,7 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
>   * We also need to create a new working copy for subsequent insertions and
>   * deletions.
>   */
> -static void pipapo_commit(const struct nft_set *set)
> +static void nft_pipapo_commit(const struct nft_set *set)
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct nft_pipapo_match *new_clone, *old;
> @@ -1660,6 +1665,24 @@ static void pipapo_commit(const struct nft_set *set)
>  	priv->clone = new_clone;
>  }
>  
> +static void nft_pipapo_abort(const struct nft_set *set)

/**
 * nft_pipapo_abort() - Drop uncommitted matching data if any, reset dirty flag
 * @set:	nftables API set representation
 */

> +{
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	struct nft_pipapo_match *new_clone;
> +
> +	if (!priv->dirty)
> +		return;
> +
> +	new_clone = pipapo_clone(priv->match);
> +	if (IS_ERR(new_clone))
> +		return;
> +
> +	priv->dirty = false;
> +
> +	pipapo_free_match(priv->clone);
> +	priv->clone = new_clone;

This is essentially a non-RCU version of (the new) nft_pipapo_commit(),
minus the garbage collection stuff, but I think a tiny bit of
duplication here as you already implemented it is clearer than trying
to factor this out into some helper.

> +}
> +
>  /**
>   * nft_pipapo_activate() - Mark element reference as active given key, commit
>   * @net:	Network namespace
> @@ -1667,8 +1690,7 @@ static void pipapo_commit(const struct nft_set *set)
>   * @elem:	nftables API element representation containing key data
>   *
>   * On insertion, elements are added to a copy of the matching data currently
> - * in use for lookups, and not directly inserted into current lookup data, so
> - * we'll take care of that by calling pipapo_commit() here. Both
> + * in use for lookups, and not directly inserted into current lookup data. Both
>   * nft_pipapo_insert() and nft_pipapo_activate() are called once for each
>   * element, hence we can't purpose either one as a real commit operation.
>   */
> @@ -1684,8 +1706,6 @@ static void nft_pipapo_activate(const struct net *net,
>  
>  	nft_set_elem_change_active(net, set, &e->ext);
>  	nft_set_elem_clear_busy(&e->ext);
> -
> -	pipapo_commit(set);
>  }
>  
>  /**
> @@ -1931,7 +1951,6 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
>  		if (i == m->field_count) {
>  			priv->dirty = true;
>  			pipapo_drop(m, rulemap);
> -			pipapo_commit(set);
>  			return;
>  		}
>  
> @@ -2230,6 +2249,8 @@ const struct nft_set_type nft_set_pipapo_type = {
>  		.init		= nft_pipapo_init,
>  		.destroy	= nft_pipapo_destroy,
>  		.gc_init	= nft_pipapo_gc_init,
> +		.commit		= nft_pipapo_commit,
> +		.abort		= nft_pipapo_abort,
>  		.elemsize	= offsetof(struct nft_pipapo_elem, ext),
>  	},
>  };
> @@ -2252,6 +2273,8 @@ const struct nft_set_type nft_set_pipapo_avx2_type = {
>  		.init		= nft_pipapo_init,
>  		.destroy	= nft_pipapo_destroy,
>  		.gc_init	= nft_pipapo_gc_init,
> +		.commit		= nft_pipapo_commit,
> +		.abort		= nft_pipapo_abort,
>  		.elemsize	= offsetof(struct nft_pipapo_elem, ext),
>  	},
>  };

Everything else looks good to me, thanks!

-- 
Stefano

