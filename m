Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333138F927
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 10:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778666721; cv=none; b=tNchU4fv8GSf2Xt131XGROdH/zpJOndrJ1YVZqTzeS/GvRPqD55HgifVkvr63y7cpUtlkNmtH7J0DZwvyLY7WCPyKGIY2m2vg2PqgoZSZhz1Gwu0qbR45lee8q7R2l6iJK+NupyeZ7qBv2/fMA3p4TU4cVpYyDLqrS4e45g++AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778666721; c=relaxed/simple;
	bh=cm1KM7wod12gh8B5XPFgdGD+Fqd7Sdyl8iP1ISs04eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHrBhl3T3h11MvTpGmR2dy9CPKH7BEM3ToOunsYGSxLvt8n2n1Gz0U1rpr/hdFq9OMJJyXNw0Lz1G0C+29XPLE14bKq9K3mx6BOyqkNb4xNCBkx9BNR/mGgmqiRZbgaLjQ5On7bI6MLjYAKQqwLpV3oQD0eB6hep983cYJYpKhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6D3306099C; Wed, 13 May 2026 12:05:07 +0200 (CEST)
Date: Wed, 13 May 2026 12:05:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: add dead flag to helpers
Message-ID: <agRMzvHgYCblnbrO@strlen.de>
References: <20260512205823.803476-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512205823.803476-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Add a new NF_CT_HELPER_F_DEAD helper flag to notify the packet path that
> this helper is going away. Thus, helpers are effectively disabled and no
> new expectations are created while removing the expectations created by
> this helper as well as unhelping the existing conntrack entries.
> 
> Add the check for NF_CT_HELPER_F_DEAD in the packet path to:
> - Conntrack confirmation path which invokes the helper callback.
> - Propagation of helper to conntrack via expectation.
> - OVS ct helper invocation.
> 
> Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
> Reported-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack_helper.h | 6 ++++++
>  net/netfilter/nf_conntrack_core.c           | 2 +-
>  net/netfilter/nf_conntrack_helper.c         | 5 ++++-
>  net/netfilter/nf_conntrack_ovs.c            | 3 +++
>  net/netfilter/nf_conntrack_proto.c          | 2 +-
>  5 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index de2f956abf34..1faa42efe42e 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -25,6 +25,7 @@ struct module;
>  enum nf_ct_helper_flags {
>  	NF_CT_HELPER_F_USERSPACE	= (1 << 0),
>  	NF_CT_HELPER_F_CONFIGURED	= (1 << 1),
> +	NF_CT_HELPER_F_DEAD		= (1 << 2),
>  };
>  
>  #define NF_CT_HELPER_NAME_LEN	16
> @@ -63,6 +64,11 @@ struct nf_conntrack_helper {
>  	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
>  };
>  
> +static inline bool nf_ct_helper_alive(const struct nf_conntrack_helper *helper)
> +{
> +	return likely(!(helper->flags & NF_CT_HELPER_F_DEAD));
> +}
> +
>  /* Must be kept in sync with the classes defined by helpers */
>  #define NF_CT_MAX_EXPECT_CLASSES	4
>  
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 8ba5b22a1eef..d54da6babcfe 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1818,7 +1818,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>  			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
>  			ct->master = exp->master;
>  			assign_helper = rcu_dereference(exp->assign_helper);
> -			if (assign_helper) {
> +			if (assign_helper && nf_ct_helper_alive(assign_helper)) {

At this time, the new ct isn't in any hash.  As-is, I don't think this
will guarantee such nfct canot escape.  See below.

>  				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
>  				if (help)
>  					rcu_assign_pointer(help->helper, assign_helper);
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index b594cd244fe1..b3752ccca75e 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -415,8 +415,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  	nf_ct_helper_count--;
>  	mutex_unlock(&nf_ct_helper_mutex);
>  
> +	me->flags |= NF_CT_HELPER_F_DEAD;
> +

Does this need to be toggled while under lock?
I don't think synchronize_rcu() is a barrier.

Also, it looks like this can be racing with nfnl_cthelper_update().
We probably need to add some new lock, or reuse existing one like
nf_ct_helper_mutex, or expectation spinlock.

>  	/* Make sure every nothing is still using the helper unless its a
> -	 * connection in the hash.
> +	 * connection in the hash, no more expectations are created after
> +	 * this rcu grace period.
>  	 */
>  	synchronize_rcu();

... that makes things wait until we leave rcu protection.
I think we should also drop nfqueued packets here to make sure
they can't be reinjected.

Also, should __nf_ct_expect_check() also call nf_ct_helper_alive()
and refuse insertion of such exp into the table?

That would give following unreg sequence:
1. Unlink from hash
2. set flag -> prevent concurrent nf_ct_expect_related() from
   adding more expectations to the exp table
3. synchronize_rcu() -> all skbs that had this helper have
   left RCU protection
4. nf_ct_expect_iterate_destroy() removes all not-yet-found
   exp entries from table
5. nf_ct_iterate_destroy() -> clear exp from nf_conn's that are
   *in conntrack table*

That still means we could have a NEW conntrack queued via nfqueue.
I think we also need to toss nfqueued packets after step 3) and
need to refuse queueing to userspace if the flag is set (-> drop).

We could have several nfqueue back to back:
-t mangle -A PREROUTING -j NFQUEUE
-t mangle -A FORWARD -j NFQUEUE

... and each synchronize_rcu() might advance skb to next
'queue' instead of nf_confirm().

But I think that this a good direction, I think its better than my
rather destructive temporarily-block-all-exps idea.
