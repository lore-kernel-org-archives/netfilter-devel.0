Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6451E347BAF;
	Wed, 12 Aug 2026 20:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786567281; cv=none; b=X33PkpXEd8/HaY380VWZ90zQEiP7rUkiCcSpBuj8hXZdM+m3SJ+V7BVY+lvVYzUC6qamZCY4t7TgcessUdApnSnKlHlbZAhZ0gQSzLQz5tJAi5jcYkwWE0P+e9jRen+noFP3Zue/5WdlazH0+PS4SPUEfnHTYhRxi0NMspKzgVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786567281; c=relaxed/simple;
	bh=AuvqZ6tFRNwtWATSE4lMZ8B9aUnXx9QVwFIVGP2Hhds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFWxE4Ir9qzH8WB64+/UeCnwIRmkVGn2xzRZ3UKHss/03igcYeyLrhG0PY1IUpA+iqBZsOKAPNyeJg1FCqbqULpfUWk/BDe5M4Y0tD7tdPmc17RKu8TTR/aI4x3WgY2bPeSxKT8T1uDnE4FL3Ev5P5fy5u8rB/52Zz8W07GtCH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dj7U+uUF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dj7U+uUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786567275;
	bh=2PdZvmo2DtzLs6Je7aFkJG+P5sGUdrrK26EOsevMX2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dj7U+uUF+DtNn5BACch5xevaSYG83z0Nt6zVFyGkw3oJLIlJz3YywxA769df3Lmz6
	 BILJhrXNyfieVLnGdAWlsepyqdGt0+40eV8ja+BrskJMBNvlwqCuhzrwDlKoTCSYOh
	 f54LpyYlWnOguLvEnM0o2tvRSOclELeNvXyNHhWi2WlwROuv43s466SsDiukgAvWgA
	 9EdGAcdpvCMpsXWAUNP5CwvS4ch/LBf+rEyWrWLrp8tVrU4Jkqyd+W0roeJpFgmO33
	 R8+Kku178fgIXeKu/1qPiuW9p8G6+c16Do5Hh8Wt4m+eOtQM+elq6VOEV16mZcPz6N
	 7Cd14qg9xRb3A==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 683906007B;
	Wed, 12 Aug 2026 22:41:15 +0200 (CEST)
Date: Wed, 12 Aug 2026 22:41:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 09/12] netfilter: nft_ct: move custom
 expectation support to helper
Message-ID: <anzaaCW-5UkvPy4B@chamomile>
References: <20260810194015.932627-10-pablo@netfilter.org>
 <20260812013446.1676035-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260812013446.1676035-1-kuba@kernel.org>

On Tue, Aug 11, 2026 at 06:34:46PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nft_ct: move custom expectation support to helper
> 
> This moves the nft ct expectation support from creating the expectation
> directly in the object eval path to allocating an internal (unregistered)
> conntrack helper that is attached to the conntrack, so the expectation is
> created from the helper callback at confirmation time. A new exported
> nf_conntrack_helper_release() is added to tear down that internal helper.
> 
> Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me
> 
> A few questions below.
> 
> > diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> > index 506c580347615..c30ae3f203bee 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -448,6 +448,15 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
> >  	return this == me;
> >  }
> >  
> > +void nf_conntrack_helper_release(struct nf_conntrack_helper *me)
> > +{
> > +	nf_ct_expect_iterate_destroy(expect_iter_me, me);
> > +
> > +	if (refcount_dec_and_test(&me->ct_refcnt))
> > +		kfree_rcu(me, rcu);
> > +}
> > +EXPORT_SYMBOL_GPL(nf_conntrack_helper_release);
> > +
> >  void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
> >  {
> >  	mutex_lock(&nf_ct_helper_mutex);
> > @@ -463,10 +472,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
> >  	 */
> >  	synchronize_rcu();
> >  
> > -	nf_ct_expect_iterate_destroy(expect_iter_me, me);
> > -
> > -	if (refcount_dec_and_test(&me->ct_refcnt))
> > -		kfree_rcu(me, rcu);
> > +	nf_conntrack_helper_release(me);
> >  }
> >  EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
> >  
> > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > index 358b9287e12e8..9dbf127df9c81 100644
> > --- a/net/netfilter/nft_ct.c
> > +++ b/net/netfilter/nft_ct.c
> 
> [ ... ]
> 
> > @@ -1226,6 +1228,93 @@ static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
> >  	return 0;
> >  }
> >  
> > +#if IS_ENABLED(CONFIG_NF_NAT)
> > +static void nft_ct_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this)
> > +{
> > +	const struct nf_ct_helper_expectfn *expfn;
> > +
> > +	expfn = nf_ct_helper_expectfn_find_by_name("nat-follow-master");
> > +	if (expfn)
> > +		expfn->expectfn(ct, this);
> > +}
> > +#endif
> > +
> > +struct nft_ct_expect_data {
> > +	struct nft_ct_expect_obj	obj;
> > +	enum ip_conntrack_dir		dir;
> > +};
> > +
> > +static int ct_expect_help(struct sk_buff *skb, unsigned int protoff,
> > +			  struct nf_conn *ct, enum ip_conntrack_info ctinfo)
> > +{
> > +	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
> > +	struct nft_ct_expect_data *expect_data;
> > +	struct nf_conntrack_expect *exp;
> > +	int ret = NF_ACCEPT;
> > +	u16 l3num;
> > +
> > +	if (nf_ct_is_confirmed(ct))
> > +		return NF_ACCEPT;
> > +
> > +	expect_data = nfct_help_data(ct);
> > +	if (!expect_data)
> > +		return NF_ACCEPT;
> > +
> > +	if (expect_data->dir != dir)
> > +		return NF_ACCEPT;
> > +
> > +	exp = nf_ct_expect_alloc(ct);
> > +	if (!exp)
> > +		return NF_DROP;
> > +
> > +	if (expect_data->obj.l3num == NFPROTO_INET)
> > +		l3num = nf_ct_l3num(ct);
> > +	else
> > +		l3num = expect_data->obj.l3num;
> 
> [Severity: Low]
> This isn't a bug introduced by this patch, but can obj.l3num ever be
> NFPROTO_INET here?  nft_ct_expect_obj_init() rejects it:
> 
> 	case NFPROTO_INET: /* tuple.src.l3num supports NFPROTO_IPV4/6 only */
> 	default:
> 		return -EAFNOSUPPORT;
> 
> so priv->l3num, and therefore the copy in expect_data->obj.l3num, can never
> hold NFPROTO_INET and the nf_ct_l3num(ct) branch looks unreachable.  The same
> code existed in the old nft_ct_expect_obj_eval() and was moved verbatim, so
> this is only a cleanup note: either drop the branch or let init accept
> NFPROTO_INET and resolve it per packet.

Pre-existing issue. As the patch describes, this existing expectation
support usecase is limited to ip and ip6. Not sure I will follow up,
I would like to hear about possible usecases given this is very
limited due to expect_clash() returning EBUSY in case an expectation
already exists.

> > +
> > +	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
> > +			  &ct->tuplehash[!dir].tuple.src.u3,
> > +			  &ct->tuplehash[!dir].tuple.dst.u3,
> > +			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);
> > +	exp->timeout += expect_data->obj.timeout;
> > +
> > +#if IS_ENABLED(CONFIG_NF_NAT)
> > +	if (ct->status & IPS_NAT_MASK) {
> > +		exp->saved_proto.tcp.port = expect_data->obj.dport;
> > +		exp->dir = !dir;
> > +		exp->expectfn = nft_ct_nat_follow_master;
> > +	}
> > +#endif
> > +	if (nf_ct_expect_related(exp, 0) != 0)
> > +		ret = NF_ACCEPT;
> > +
> > +	nf_ct_expect_put(exp);
> > +
> > +	return ret;
> > +}
> > +
> > +static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
> > +{
> > +	struct nf_conntrack_helper *ct_expect_helper;
> > +
> > +	ct_expect_helper = kzalloc_obj(struct nf_conntrack_helper,
> > +				       GFP_KERNEL_ACCOUNT);
> > +	if (!ct_expect_helper)
> > +		return -ENOMEM;
> > +
> > +	snprintf(ct_expect_helper->name, sizeof(ct_expect_helper->name), "%s",
> > +		 "nft_ct_expect");
> > +	ct_expect_helper->me = THIS_MODULE;
> > +	ct_expect_helper->expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected = priv->size;
> > +	rcu_assign_pointer(ct_expect_helper->help, ct_expect_help);
> > +	refcount_set(&ct_expect_helper->ct_refcnt, 1);
> > +
> > +	/* No need to register this helper, this is internal. */
> > +	priv->helper = ct_expect_helper;
> > +
> > +	return 0;
> > +}
> > +
> 
> [ ... ]
> 
> > @@ -1272,13 +1363,31 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
> >  
> >  	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
> >  	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
> > +	if (!priv->size)
> > +		priv->size = NF_CT_EXPECT_MAX_CNT;
> 
> [Severity: Medium]
> Does this break the round-trip of NFTA_CT_EXPECT_SIZE?  priv->size is what
> nft_ct_expect_obj_dump() echoes back:
> 
> 	    nla_put_u8(skb, NFTA_CT_EXPECT_SIZE, priv->size))
> 
> so an object created with size 0 is now listed as size 255.  The policy
> [NFTA_CT_EXPECT_SIZE] = { .type = NLA_U8 } accepts 0, so this is reachable
> from userspace.
> 
> The meaning of size 0 also flips: the pre-patch eval tested
> 
> 	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size)
> 
> which is always true for 0, i.e. size 0 meant "never create expectations",
> whereas it now means "allow the maximum".
> 
> Would it work to apply the substitution only where it is needed, i.e. to
> expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected in
> nft_ct_expect_helper_alloc(), and keep the user-supplied value in
> priv->size?  That is what __nf_conntrack_helper_register() does, but there
> the clamped value lives in an internal policy struct that is never sent to
> userspace.
> 
> Related: with the new scheme ct_expect_help() only runs while the conntrack
> is unconfirmed and only for the single recorded direction, so at most one
> expectation per conntrack is created and the size attribute has no
> observable effect anymore.

This is explaining the existing limitations in this nft_ct expectation
support.

The main goal with this patch is to address a real issue in the
conntrack core as the patch describes, which is more important than
this feature.

> > +
> > +	err = nf_ct_netns_get(ctx->net, ctx->family);
> > +	if (err < 0)
> > +		return err;
> >  
> > -	return nf_ct_netns_get(ctx->net, ctx->family);
> > +	err = nft_ct_expect_helper_alloc(priv);
> > +	if (err < 0) {
> > +		nf_ct_netns_put(ctx->net, ctx->family);
> > +		return err;
> > +	}
> > +
> > +	return err;
> >  }
> >  
> >  static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
> > -				       struct nft_object *obj)
> > +				      struct nft_object *obj)
> >  {
> > +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> > +	struct nf_conntrack_helper *me = priv->helper;
> > +
> > +	/* This helper is going away, disable it. */
> > +	rcu_assign_pointer(me->help, NULL);
> > +	nf_conntrack_helper_release(me);
> >  	nf_ct_netns_put(ctx->net, ctx->family);
> >  }
> 
> [Severity: High]
> Is a grace period needed between clearing me->help and sweeping the
> expectation table here?  nf_conntrack_helper_unregister() does exactly these
> two steps with a synchronize_rcu() in between:
> 
> 	rcu_assign_pointer(me->help, NULL);
> 
> 	/* Make sure every nothing is still using the helper unless its a
> 	 * connection in the hash.
> 	 */
> 	synchronize_rcu();
> 
> 	nf_conntrack_helper_release(me);
> 
> The refactor left the grace period in the unregister wrapper, so the new
> external caller does not get it.
> 
> Can an in-flight ct_expect_help() then insert an expectation after the sweep
> has finished?
> 
> CPU A (softirq), nf_confirm():
> 	helper_cb = rcu_dereference(helper->help);	/* still ct_expect_help */
> 	...
> 	ret = helper_cb(skb, protoff, ct, ctinfo);
> 	  ct_expect_help()
> 	    nf_ct_expect_alloc() / nf_ct_expect_init()
> 
> CPU B (process context), object delete:
> 	nft_ct_expect_obj_destroy()
> 	  rcu_assign_pointer(me->help, NULL);
> 	  nf_conntrack_helper_release()
> 	    nf_ct_expect_iterate_destroy(expect_iter_me, me);  /* sweeps */
> 
> CPU A continues:
> 	    nf_ct_expect_related(exp, 0)	/* takes nf_conntrack_expect_lock
> 						   after the sweep, inserts */
> 
> rcu_assign_pointer() does not wait for a reader that already loaded the old
> pointer, and the callback is reached through the conntrack's own
> help->helper in nf_confirm() (and nf_ct_helper() in nf_conntrack_ovs.c), not
> through the nft object, so the nf_tables commit-time synchronize_rcu() that
> precedes ops->destroy() does not fence it.
> 
> Since this sweep is the only teardown for these expectations, would the
> escaped expectation (exp->helper == me, and exp->expectfn ==
> nft_ct_nat_follow_master when NAT is in use) then keep admitting a RELATED
> connection after the object/rule is gone, until its timeout expires or the
> master conntrack dies?
> 
> The commit message says:
> 
>     The nft_ct module removal always waits for rcu grace period, then the
>     NULL helper callback is observed after this.
> 
> but nft_ct_expect_obj_destroy() itself does not wait; object destruction is
> not module removal.  Would keeping the unregister ordering here (or folding
> the synchronize_rcu() into nf_conntrack_helper_release()) be preferable?

I can follow harden this, to kill existing expectations on module
removal for nft_ct and nfnetlink_cthelper, this race is unlikely to
happen but it is possible on module removal.

> > @@ -1297,27 +1406,14 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
> 
> [ ... ]
> 
> >  static void nft_ct_expect_obj_eval(struct nft_object *obj,
> >  				   struct nft_regs *regs,
> >  				   const struct nft_pktinfo *pkt)
> >  {
> >  	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> > -	struct nf_conntrack_expect *exp;
> > +	struct nft_ct_expect_data *expect_data;
> >  	enum ip_conntrack_info ctinfo;
> >  	struct nf_conn_help *help;
> > -	enum ip_conntrack_dir dir;
> > -	u16 l3num = priv->l3num;
> >  	struct nf_conn *ct;
> >  
> >  	ct = nf_ct_get(pkt->skb, &ctinfo);
> > @@ -1325,45 +1421,30 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
> >  		regs->verdict.code = NFT_BREAK;
> >  		return;
> >  	}
> > -	dir = CTINFO2DIR(ctinfo);
> >  
> >  	help = nfct_help(ct);
> > -	if (!help)
> > -		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> > -	if (!help) {
> > -		regs->verdict.code = NF_DROP;
> > -		return;
> > -	}
> > -
> > -	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
> > +	if (help) {
> >  		regs->verdict.code = NFT_BREAK;
> >  		return;
> >  	}
> 
> [Severity: Medium]
> Is this change of behaviour intended?  The old code reused an existing
> nf_conn_help extension; now any conntrack that already carries one gives up
> with NFT_BREAK and no expectation is created at all.
> 
> A help extension can already be present on an unconfirmed conntrack from
> several places, for example:
> 
>   - nft_ct_helper_obj_eval() calling nf_ct_helper_ext_add() for a preceding
>     "ct helper set" statement
>   - __nf_ct_try_assign_helper() from init_conntrack()
>   - the exp->assign_helper path in init_conntrack():
> 
> 	assign_helper = rcu_dereference(exp->assign_helper);
> 	if (assign_helper) {
> 		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> 
>   - ctnetlink created conntracks
>   - a second "ct expectation set" statement
> 
> Since NFT_BREAK aborts the whole rule, do the statements following
> "ct expectation set" (counter/log/accept/jump) get skipped too, so such
> packets now fall through to the next rule or the chain policy?
> 
> Also, on the commit message:
> 
>     I'd rather not increase the size of the struct nf_conn for this feature
>     has very limited scope: only one expectation can be created at a time
>     given expect_clash() will make nf_ct_expect_related() reports EBUSY.
> 
> Is that accurate for the pre-patch code?  expect_clash() goes through
> nf_ct_tuple_mask_cmp(), which compares the destination tuple including
> dst.u.all, so two expectation objects with different dports on the same
> master did not clash and could coexist up to priv->size.  Should the commit
> message describe the single-expectation limit as something this patch
> introduces rather than as existing behaviour?
> 
> > -	if (l3num == NFPROTO_INET)
> > -		l3num = nf_ct_l3num(ct);
> >  
> > -	exp = nf_ct_expect_alloc(ct);
> > -	if (exp == NULL) {
> > +	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> > +	if (!help) {
> >  		regs->verdict.code = NF_DROP;
> >  		return;
> >  	}
> 
> [ ... ]
> 
> > +	expect_data = nfct_help_data(ct);
> > +	if (!expect_data) {
> > +		regs->verdict.code = NFT_BREAK;
> > +		return;
> >  	}
> > -#endif
> > -	if (nf_ct_expect_related(exp, 0) != 0)
> > -		regs->verdict.code = NF_DROP;
> > +	expect_data->obj = *priv;
> > +	expect_data->obj.helper = NULL;
> > +	expect_data->dir = CTINFO2DIR(ctinfo);
> >  
> > -	nf_ct_expect_put(exp);
> > +	if (help && refcount_inc_not_zero(&priv->helper->ct_refcnt))
> > +		rcu_assign_pointer(help->helper, priv->helper);
> >  }
