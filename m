Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C54413D74
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779818103; cv=none; b=sGtTQUDMwur00BFj4S37Dg6P4orj+NeMAea7EGNGlGIDfA3/WCuZYs1s5rpOsLfqHnJeslYllc3MeZz+p1AtETdZb2+0NYNGB8zwSaftRY0lkuaNJXlCnnGgbtDwBagLcgd5PiH1F2D2wRh2TazrcV/eGPzhD/TinGjfRuMgWxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779818103; c=relaxed/simple;
	bh=lz5woo9V/uZEECSO2wScXD+HVyUsvxT2zyQwyM49+Ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ah9LRuUH36LTs9/6R1zeGO4hlFjNjRnVjWDrEUEVDkTeD0woSaANAP32JFcUS5KxuuL7tJfoA6y7MDJtcBDplSQZmsa/TqGpJaZR2BNNn9YgyuPAQ7G2hmDx+4SRazYVnKx2mtrASzdDWrhn/RTOr+X1oA7x44Adm8ZRUmcU//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA59860551; Tue, 26 May 2026 19:54:52 +0200 (CEST)
Date: Tue, 26 May 2026 19:54:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 5/6] netfilter: nf_conntrack_helper: add
 refcounting from datapath
Message-ID: <ahXea1N1w40Siqin@strlen.de>
References: <20260526164049.148218-1-pablo@netfilter.org>
 <20260526164049.148218-6-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526164049.148218-6-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> There is already a refcount for control plane, to ensure the helper
> does not go away if it is used by rulesets.
> 
> This patch adds a new ->ct_refcnt field to struct nf_conntrack_helper
> which is bumped when the helper is used by the ct helper extension. Drop
> this reference count when the conntrack entry is released. This is a
> packet path refcount which ensures that struct nf_conntrack_helper
> remains in place for tricky scenarios where a packet sits in nfqueue, or
> elsewhere, with a conntrack that refers to this helper.
> 
> On helper removal, the help callback is set to NULL to disable it from
> packet path and, after rcu grace period, existing expectations are
> removed. Update ctnetlink to disable access to .to_nlattr and
> .from_nlattr if the helper is going away.
> 
> Remove nf_queue_nf_hook_drop() since it has proven not to be effective
> because packets with unconfirmed conntracks which are still flying to
> sit in nfqueue.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack_helper.h | 25 +++++++++++++++---
>  net/netfilter/nf_conntrack_core.c           |  3 ++-
>  net/netfilter/nf_conntrack_helper.c         | 28 ++++++---------------
>  net/netfilter/nf_conntrack_netlink.c        | 12 ++++++---
>  net/netfilter/nf_conntrack_ovs.c            | 14 ++++++++++-
>  net/netfilter/nf_conntrack_proto.c          | 15 +++++++----
>  net/netfilter/nft_ct.c                      |  2 +-
>  net/netfilter/xt_CT.c                       |  7 +++---
>  8 files changed, 66 insertions(+), 40 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 1956bc12bf56..a03cb4e59ea9 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -35,20 +35,23 @@ enum nf_ct_helper_flags {
>  struct nf_conntrack_helper {
>  	struct hlist_node hnode;	/* Internal use. */
>  
> +	struct rcu_head rcu;
> +
>  	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
>  	refcount_t refcnt;
>  	struct module *me;		/* pointer to self */
>  	struct nf_conntrack_expect_policy expect_policy[NF_CT_MAX_EXPECT_CLASSES];
>  
> +	refcount_t ct_refcnt;

Why do we need two reference counts?  I find this very confusing.
Which refcount frees the structure?  And can one refcount hit 0 while
other one is still in use?

>  	/* Function to call when data passes; return verdict, or -1 to
>             invalidate. */
> -	int (*help)(struct sk_buff *skb,
> -		    unsigned int protoff,
> -		    struct nf_conn *ct,
> -		    enum ip_conntrack_info conntrackinfo);
> +	int __rcu (*help)(struct sk_buff *skb, unsigned int protoff,
> +			  struct nf_conn *ct,
> +			  enum ip_conntrack_info conntrackinfo);
>  
>  	void (*destroy)(struct nf_conn *ct);

Why is help RCU protected while other callbacks are not?

'destroy' not being rcu protected implies that the helper module must
remain in memory until after kfree_rcu has released the underlying
storage anyway.

If thats true, why do we need rcu head and kfree_rcu in the first place?
module has to remain in memory until after last possible caller has
called me->destroy(), no?  If that is correct, then there is no need for
dynamically allocated storage.

> @@ -445,19 +432,18 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  	nf_ct_helper_count--;
>  	mutex_unlock(&nf_ct_helper_mutex);
>  
> +	/* This helper is going away, disable it. */
> +	rcu_assign_pointer(me->help, NULL);
> +

OK, so this signals pending removal (refcnt can still be elevated) to
prevent new packets/expectations from grabbing another reference.
Correct?  Is this a 'dying' flag or is there more to it?

I looked at patched 'nf_conntrack_ftp_fini', but I don't see anything
that spins/waits for completion of referencing entries.

How does ->destroy/to_nlattr/from_nlattr etc. work?

I expected to find something that does a busywait until refcount has
hit 0 to avoid any calls to the removed module.

The existing conntracks still hold a pointer to struct
nf_conntrack_helper, and its refcount can be elevated too, while
function pointers (not help, but others) are stale.

I suspect you need to move the function pointers to an 'op' sub-struct,
so that it can be cleared via single rcu_assign_pointer(me->help_ops, NULL) ?

But that still has one problem: if helper module is gone, how can you
call the destructor?

Maybe we need to accelerate pptp removal so the only user of destroy
is removed?
