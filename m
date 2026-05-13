Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094A34A1392
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 15:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778686178; cv=none; b=Jmq13accuJchX/FPQzilWVUhHZtcEUrkV9+bJgw+4QD8Av2UnzLnNJ75jEWnp/NK4h7NebXx4+JBvI/vWwGT39TH6wPGHuSHQyNk0iI5FIYFFf74Gpi92H+ORrgPEJ7jFSlY/XwRNKI4fCD4Qs51ORvuuYAaUFZjzhgcmIz8UTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778686178; c=relaxed/simple;
	bh=54ufDLXha5fOW7jnhxQbeRrspPd1u4jkPXmBI8r4tnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDW1vo/6ej2QBLKJHh4phPc5A7PTR+wdIqS5G063FaJBRn8Vc/VpVTmKbk6ah6jjtIV/YSK7IXVpOOS8SkPI34rWbCsIT7KyBjc3FDRBBE1qu2U7Ej6wj1UoIff+oa67u9ldjd6hJj57cZTovpXaMI3UInboGckqKwu66qxZi6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZVtXXGlW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZVtXXGlW"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D0F376019F;
	Wed, 13 May 2026 17:29:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778686167;
	bh=jL2OLJWgobkSTmgyZoChII4U+mn6CoZtywzVC/CwzFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZVtXXGlWOzY6epyvOCgZK6tAgffB4rwWIkizSldSk2jCil1DGxQffkXOvE3xsbmCK
	 Tq51MXV5lS28+cVseW4jD5O+GqhFRG/SEQqfJijDKnIRj62gj9jMs0LJbxHUuGNVkv
	 uRZgpAYcMW/k3IKw8UAk4TZ1jbv9OYw5/Y8eq0ZFP+EGExUDAx8yE04+Dggvs0nJmL
	 DHc8VbFNaghTq4wtCEDb2W1PHBSP2aY7bi29KqgAwp1jeNpnbovpbc7nwSyCxOvMCQ
	 FLTEI//DC7g/OSUMT9uYHWtnlq7GfoKbIlq1VhX/kwWXixv8cswKYWNKsQxvjkSqBt
	 mu2pIHWr3hdjw==
Date: Wed, 13 May 2026 17:29:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: add dead flag to helpers
Message-ID: <agSY1PyVKRhf4zDc@chamomile>
References: <20260512205823.803476-1-pablo@netfilter.org>
 <agRMzvHgYCblnbrO@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <agRMzvHgYCblnbrO@strlen.de>

On Wed, May 13, 2026 at 12:05:02PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Add a new NF_CT_HELPER_F_DEAD helper flag to notify the packet path that
> > this helper is going away. Thus, helpers are effectively disabled and no
> > new expectations are created while removing the expectations created by
> > this helper as well as unhelping the existing conntrack entries.
> > 
> > Add the check for NF_CT_HELPER_F_DEAD in the packet path to:
> > - Conntrack confirmation path which invokes the helper callback.
> > - Propagation of helper to conntrack via expectation.
> > - OVS ct helper invocation.
> > 
> > Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
> > Reported-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/net/netfilter/nf_conntrack_helper.h | 6 ++++++
> >  net/netfilter/nf_conntrack_core.c           | 2 +-
> >  net/netfilter/nf_conntrack_helper.c         | 5 ++++-
> >  net/netfilter/nf_conntrack_ovs.c            | 3 +++
> >  net/netfilter/nf_conntrack_proto.c          | 2 +-
> >  5 files changed, 15 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> > index de2f956abf34..1faa42efe42e 100644
> > --- a/include/net/netfilter/nf_conntrack_helper.h
> > +++ b/include/net/netfilter/nf_conntrack_helper.h
> > @@ -25,6 +25,7 @@ struct module;
> >  enum nf_ct_helper_flags {
> >  	NF_CT_HELPER_F_USERSPACE	= (1 << 0),
> >  	NF_CT_HELPER_F_CONFIGURED	= (1 << 1),
> > +	NF_CT_HELPER_F_DEAD		= (1 << 2),
> >  };
> >  
> >  #define NF_CT_HELPER_NAME_LEN	16
> > @@ -63,6 +64,11 @@ struct nf_conntrack_helper {
> >  	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
> >  };
> >  
> > +static inline bool nf_ct_helper_alive(const struct nf_conntrack_helper *helper)
> > +{
> > +	return likely(!(helper->flags & NF_CT_HELPER_F_DEAD));
> > +}
> > +
> >  /* Must be kept in sync with the classes defined by helpers */
> >  #define NF_CT_MAX_EXPECT_CLASSES	4
> >  
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 8ba5b22a1eef..d54da6babcfe 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1818,7 +1818,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
> >  			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
> >  			ct->master = exp->master;
> >  			assign_helper = rcu_dereference(exp->assign_helper);
> > -			if (assign_helper) {
> > +			if (assign_helper && nf_ct_helper_alive(assign_helper)) {
> 
> At this time, the new ct isn't in any hash.  As-is, I don't think this
> will guarantee such nfct canot escape.  See below.
> 
> >  				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> >  				if (help)
> >  					rcu_assign_pointer(help->helper, assign_helper);
> > diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> > index b594cd244fe1..b3752ccca75e 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -415,8 +415,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
> >  	nf_ct_helper_count--;
> >  	mutex_unlock(&nf_ct_helper_mutex);
> >  
> > +	me->flags |= NF_CT_HELPER_F_DEAD;
> > +
> 
> Does this need to be toggled while under lock?
> I don't think synchronize_rcu() is a barrier.
> 
> Also, it looks like this can be racing with nfnl_cthelper_update().
> We probably need to add some new lock, or reuse existing one like
> nf_ct_helper_mutex, or expectation spinlock.
> 
> >  	/* Make sure every nothing is still using the helper unless its a
> > -	 * connection in the hash.
> > +	 * connection in the hash, no more expectations are created after
> > +	 * this rcu grace period.
> >  	 */
> >  	synchronize_rcu();
> 
> ... that makes things wait until we leave rcu protection.
> I think we should also drop nfqueued packets here to make sure
> they can't be reinjected.

See below, at the end of this email.

> Also, should __nf_ct_expect_check() also call nf_ct_helper_alive()
> and refuse insertion of such exp into the table?
> 
> That would give following unreg sequence:
> 1. Unlink from hash
> 2. set flag -> prevent concurrent nf_ct_expect_related() from
>    adding more expectations to the exp table

My understanding is that during the rcu grace period, packets
might keep walking over the helper function and create an
expectations. These expectations will be destroyed by
nf_ct_expect_iterate_destroy(). 

But after the rcu grace period, new packets will start seeing the
helper dead flag, hence skipping the helper logic / no new expectation
is created. And the existing expectation cannot be reached, because
_find_expect() is disabled.

> 3. synchronize_rcu() -> all skbs that had this helper have
>    left RCU protection
> 4. nf_ct_expect_iterate_destroy() removes all not-yet-found
>    exp entries from table
> 5. nf_ct_iterate_destroy() -> clear exp from nf_conn's that are
>    *in conntrack table*
> 
> That still means we could have a NEW conntrack queued via nfqueue.
> I think we also need to toss nfqueued packets after step 3) and
> need to refuse queueing to userspace if the flag is set (-> drop).

Those conntrack entries would now have help->helper == NULL because of
the unhelp call.

> We could have several nfqueue back to back:
> -t mangle -A PREROUTING -j NFQUEUE
> -t mangle -A FORWARD -j NFQUEUE
> 
> ... and each synchronize_rcu() might advance skb to next
> 'queue' instead of nf_confirm().
> 
> But I think that this a good direction, I think its better than my
> rather destructive temporarily-block-all-exps idea.

Thanks for your feedback, let me know if I still don't see anything
obvious.
