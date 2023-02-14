Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C0FC61DA4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Feb 2023 12:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjBNMxP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Feb 2023 07:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjBNMxO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Feb 2023 07:53:14 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0E151715E
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Feb 2023 04:53:12 -0800 (PST)
Date:   Tue, 14 Feb 2023 13:53:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: fix rmmod double-free race
Message-ID: <Y+uEM5Rmr5ARRoKz@salvia>
References: <20230213175737.26685-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230213175737.26685-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 13, 2023 at 06:57:37PM +0100, Florian Westphal wrote:
> nf_conntrack_hash_check_insert() callers free the ct entry directly, via
> nf_conntrack_free.
> 
> This isn't allowed anymore in all cases: Its possible that
> nf_conntrack_hash_check_insert() placed the entry into the conntrack
> table and then found that a conntrack extension has been removed at the
> same time.
> 
> In this case, the just-added entry is removed again and an error is
> returned to the caller.
> 
> Problem is that another cpu might have picked up this entry and
> incremented its reference count.
> 
> This results in a use-after-free/double-free, once by the other cpu and
> once by the caller of nf_conntrack_hash_check_insert().
> 
> Fix this by making nf_conntrack_hash_check_insert() always set a
> refcount.
> 
> Refcount is set to 2 right before insertion, so we only need to make
> sure we set it to 1 in all error branches that can occur before
> inserting the enry into the hash.
> 
> Callers can then just call nf_ct_put(), which will also take care of
> ct->master reference.
> 
> While at it, make the function return -EAGAIN in the rmmod (genid
> changed) case, this makes nfnetlink replay the command (suggested
> by Pablo Neira).
> 
> Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This is on top of
>  "net: netfilter: fix possible refcount leak in ctnetlink_create_conntrack()"
> 
>  net/netfilter/nf_conntrack_bpf.c     |  3 +--
>  net/netfilter/nf_conntrack_core.c    | 11 +++++++----
>  net/netfilter/nf_conntrack_netlink.c |  8 +++-----
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index 24002bc61e07..9de5a32088d2 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -381,10 +381,9 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
>  	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
>  	int err;
>  
> -	nfct->status |= IPS_CONFIRMED;
>  	err = nf_conntrack_hash_check_insert(nfct);
>  	if (err < 0) {
> -		nf_conntrack_free(nfct);
> +		nf_ct_put(nfct);
>  		return NULL;
>  	}
>  	return nfct;
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 496c4920505b..2eeb2e2b8e46 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -887,8 +887,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>  	zone = nf_ct_zone(ct);
>  
>  	if (!nf_ct_ext_valid_pre(ct->ext)) {
> -		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
> -		return -ETIMEDOUT;
> +		/* so caller can use nf_ct_put() */
> +		refcount_set(&ct->ct_general.use, 1);
> +		return -EAGAIN;
>  	}
>  
>  	local_bh_disable();
> @@ -924,6 +925,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>  			goto chaintoolong;
>  	}
>  
> +	ct->status |= IPS_CONFIRMED;
>  	smp_wmb();
>  	/* The caller holds a reference to this object */
>  	refcount_set(&ct->ct_general.use, 2);
> @@ -934,8 +936,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>  
>  	if (!nf_ct_ext_valid_post(ct->ext)) {
>  		nf_ct_kill(ct);

I think this nf_ct_kill() delivers a destroy to userspace for an entry
that was never added?

lock is not held anymore, so maybe a packet already got this
conntrack.

Maybe post validation also needs to hold the lock and
nf_conntrack_hash_check_insert() could undo the list insertion itself
leaving things as they were before calling this function?

> -		NF_CT_STAT_INC_ATOMIC(net, drop);
> -		return -ETIMEDOUT;
> +		return -EAGAIN;
>  	}
>  
>  	return 0;
> @@ -943,6 +944,8 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>  	NF_CT_STAT_INC(net, chaintoolong);
>  	err = -ENOSPC;
>  out:
> +	/* so caller can use nf_ct_put() */
> +	refcount_set(&ct->ct_general.use, 1);
>  	nf_conntrack_double_unlock(hash, reply_hash);
>  	local_bh_enable();
>  	return err;
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index ca4d5bb1ea52..dc448c5bc3f1 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2316,9 +2316,6 @@ ctnetlink_create_conntrack(struct net *net,
>  	nfct_seqadj_ext_add(ct);
>  	nfct_synproxy_ext_add(ct);
>  
> -	/* we must add conntrack extensions before confirmation. */
> -	ct->status |= IPS_CONFIRMED;
> -
>  	if (cda[CTA_STATUS]) {
>  		err = ctnetlink_change_status(ct, cda);
>  		if (err < 0)
> @@ -2382,8 +2379,9 @@ ctnetlink_create_conntrack(struct net *net,
>  	return ct;
>  
>  err3:
> -	if (ct->master)
> -		nf_ct_put(ct->master);
> +	rcu_read_unlock();
> +	nf_ct_put(ct);

I can see your intention is to consolidate all around nf_ct_put(), but
I wonder if it would be better if nf_conntrack_hash_check_insert()
handles error by removing the entry from the list.

> +	return ERR_PTR(err);
>  err2:
>  	rcu_read_unlock();
>  err1:
> -- 
> 2.39.1
> 
