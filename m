Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12B5C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jun 2023 05:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjFLFYY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 01:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjFLFYY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 01:24:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFE1B5
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jun 2023 22:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686547416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lkvt4507lvRaHywf5zem7jm7WNMkqcc/3sd+QVfX/fk=;
        b=HDj/ue6pHlHXc/+Frqry5BXi4nAF1qbj17hE29If3nUqdIJJANWHM/Rn4JDcYalJNdy6SL
        CFHjVfLTj5qr5e1w1d7fWQ+tFLQQhPqnx5k70SJcmf+YDroojV3x9hhIMtLjjl3oqTlB5A
        LF0AigMApBb+zEpJKiDWrhVbm5rVBT8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-tfVtZPpHO7OYuFqJeL7F_w-1; Mon, 12 Jun 2023 01:23:32 -0400
X-MC-Unique: tfVtZPpHO7OYuFqJeL7F_w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C62D185A797;
        Mon, 12 Jun 2023 05:23:32 +0000 (UTC)
Received: from elisabeth (unknown [10.39.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 044CF492CA6;
        Mon, 12 Jun 2023 05:23:31 +0000 (UTC)
Date:   Mon, 12 Jun 2023 07:23:23 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v3] netfilter: nf_tables: integrate pipapo into
 commit protocol
Message-ID: <20230612072323.76fc569a@elisabeth>
In-Reply-To: <20230608015701.133419-1-pablo@netfilter.org>
References: <20230608015701.133419-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu,  8 Jun 2023 03:57:00 +0200
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
> This patch adds a new ->pending_update field to sets to maintain a list
> of sets that require this new commit and abort operations.

As I mentioned on v1, maybe we can actually make activate and
deactivate calls optional (in the API) and drop them from
nft_set_pipapo, but this is something I can investigate (and test)
separately.

Some nits (code comments only) that went probably lost from my comments
on v1:

> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v3: fix sparse issue reported by robot.
> 
>  include/net/netfilter/nf_tables.h |  4 ++-
>  net/netfilter/nf_tables_api.c     | 56 +++++++++++++++++++++++++++++++
>  net/netfilter/nft_set_pipapo.c    | 55 +++++++++++++++++++++---------
>  3 files changed, 99 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 2e24ea1d744c..83db182decc8 100644
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
> @@ -557,6 +558,7 @@ struct nft_set {
>  	u16				policy;
>  	u16				udlen;
>  	unsigned char			*udata;
> +	struct list_head		pending_update;
>  	/* runtime data below here */
>  	const struct nft_set_ops	*ops ____cacheline_aligned;
>  	u16				flags:14,
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 0519d45ede6b..3bb0800b3849 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4919,6 +4919,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
>  
>  	set->num_exprs = num_exprs;
>  	set->handle = nf_tables_alloc_handle(table);
> +	INIT_LIST_HEAD(&set->pending_update);
>  
>  	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
>  	if (err < 0)
> @@ -9275,10 +9276,25 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
>  	}
>  }
>  
> +static void nft_set_commit_update(struct list_head *set_update_list)
> +{
> +	struct nft_set *set, *next;
> +
> +	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
> +		list_del_init(&set->pending_update);
> +
> +		if (!set->ops->commit)
> +			continue;
> +
> +		set->ops->commit(set);
> +	}
> +}
> +
>  static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
>  	struct nft_trans *trans, *next;
> +	LIST_HEAD(set_update_list);
>  	struct nft_trans_elem *te;
>  	struct nft_chain *chain;
>  	struct nft_table *table;
> @@ -9453,6 +9469,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  			nf_tables_setelem_notify(&trans->ctx, te->set,
>  						 &te->elem,
>  						 NFT_MSG_NEWSETELEM);
> +			if (te->set->ops->commit &&
> +			    list_empty(&te->set->pending_update)) {
> +				list_add_tail(&te->set->pending_update,
> +					      &set_update_list);
> +			}
>  			nft_trans_destroy(trans);
>  			break;
>  		case NFT_MSG_DELSETELEM:
> @@ -9467,6 +9488,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  				atomic_dec(&te->set->nelems);
>  				te->set->ndeact--;
>  			}
> +			if (te->set->ops->commit &&
> +			    list_empty(&te->set->pending_update)) {
> +				list_add_tail(&te->set->pending_update,
> +					      &set_update_list);
> +			}
>  			break;
>  		case NFT_MSG_NEWOBJ:
>  			if (nft_trans_obj_update(trans)) {
> @@ -9529,6 +9555,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  		}
>  	}
>  
> +	nft_set_commit_update(&set_update_list);
> +
>  	nft_commit_notify(net, NETLINK_CB(skb).portid);
>  	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
>  	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
> @@ -9588,10 +9616,25 @@ static void nf_tables_abort_release(struct nft_trans *trans)
>  	kfree(trans);
>  }
>  
> +static void nft_set_abort_update(struct list_head *set_update_list)
> +{
> +	struct nft_set *set, *next;
> +
> +	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
> +		list_del_init(&set->pending_update);
> +
> +		if (!set->ops->abort)
> +			continue;
> +
> +		set->ops->abort(set);
> +	}
> +}
> +
>  static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
>  	struct nft_trans *trans, *next;
> +	LIST_HEAD(set_update_list);
>  	struct nft_trans_elem *te;
>  
>  	if (action == NFNL_ABORT_VALIDATE &&
> @@ -9701,6 +9744,12 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  			nft_setelem_remove(net, te->set, &te->elem);
>  			if (!nft_setelem_is_catchall(te->set, &te->elem))
>  				atomic_dec(&te->set->nelems);
> +
> +			if (te->set->ops->abort &&
> +			    list_empty(&te->set->pending_update)) {
> +				list_add_tail(&te->set->pending_update,
> +					      &set_update_list);
> +			}
>  			break;
>  		case NFT_MSG_DELSETELEM:
>  		case NFT_MSG_DESTROYSETELEM:
> @@ -9711,6 +9760,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  			if (!nft_setelem_is_catchall(te->set, &te->elem))
>  				te->set->ndeact--;
>  
> +			if (te->set->ops->abort &&
> +			    list_empty(&te->set->pending_update)) {
> +				list_add_tail(&te->set->pending_update,
> +					      &set_update_list);
> +			}
>  			nft_trans_destroy(trans);
>  			break;
>  		case NFT_MSG_NEWOBJ:
> @@ -9753,6 +9807,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  		}
>  	}
>  
> +	nft_set_abort_update(&set_update_list);
> +
>  	synchronize_rcu();
>  
>  	list_for_each_entry_safe_reverse(trans, next,
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 06d46d182634..15e451dc3fc4 100644
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
> +static void pipapo_free_match(struct nft_pipapo_match *m)

Before this:

/**
 * pipapo_free_match() - Free fields from unused matching data
 * @m:		Matching data
 */

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
> @@ -1660,6 +1665,26 @@ static void pipapo_commit(const struct nft_set *set)
>  	priv->clone = new_clone;
>  }
>  
> +static void nft_pipapo_abort(const struct nft_set *set)

/**
 * nft_pipapo_abort() - Drop uncommitted matching data if any, reset dirty flag
 * @set:	nftables API set representation
 */

The rest looks good to me, thanks.

-- 
Stefano

