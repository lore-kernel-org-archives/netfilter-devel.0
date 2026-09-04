Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624A9322C73
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 08:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788510201; cv=none; b=fjeA3NSsQWdcauVz6y1pPwCsBbNWwE64VtTSxcuuINo9OuB3GH3gEwGvBOzbegLY0cV13jkdB/goZ8Yybou4ngmJGcJJYTOI75kihgKQdLbmoyOzP6U6IPptYTLO1NJar+zU5MriNwn57lgHMh4lOjhSzCS5Q2eL/Gd0ycCX7dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788510201; c=relaxed/simple;
	bh=moopsa7WIyW3v8i89wi5AcV6KVWZ+UJkOa+gVP5gfAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyyBZ8RSYa0FmKtsPRy1qhOEfDJas+UcZQiJ36Kfvhs9ee1eYEM85K9xmdcPQpl+GqUatJ3fncCCB62H3oUvHkxHWME+YMRvm6gB0ryn+eaMaxJrwhBHEfXgG1uh1jlb3I8tz7Ma1TDHkNmla5f4u2vCAeElIjx5N+deuvWXCj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ff55+UZz; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ff55+UZz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LfIsEq65pWJK9ZGyWZwi6tWgZta8SOqWLsuAwrCJiz0=; b=Ff55+UZzDLRWz6V9JSb5ssouaF
	BPiS9n8eou9txUCEeaY5xqzVFu52EnpNBzfzFLgK1vnZZ/p09OuD5pz8tHfv4HoG8oGEvUoyULhqz
	98EX0tgolY7ox8gMAeGnP8Ukox9HdbHIysgxVvE3m5MZNsrMGh+vdRts25K1QQu08bLdZPsTm2YWz
	WLF+aDuuz5ARUxdIe2vf9mwF8owJS7KWiSCOFqzNXf1LXa9wjnN4IaoP6nqeT6warpNt5D2QNPYZE
	dYw/t5EhDST41cVeo2yrfhBzMOZ6uXoR1IStJyCgJWJPSOaGUP78+iKRP0eMtGT+sK4h3X6Ie196y
	O9hc1kGw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x2PCa-000000002dB-2ggi;
	Fri, 04 Sep 2026 10:23:12 +0200
Date: Fri, 4 Sep 2026 10:23:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2] netfilter: nfnetlink: Fix for interrupted hook
 dumps
Message-ID: <app_8GDpUHIqNKf0@orbyte.nwl.cc>
References: <20260903143921.942724-1-phil@nwl.cc>
 <apme36chq_mKJnCh@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apme36chq_mKJnCh@chamomile>

Hi Pablo,

On Thu, Sep 03, 2026 at 06:22:55PM +0200, Pablo Neira Ayuso wrote:
> Thanks for your patch, see comments below.
> 
> On Thu, Sep 03, 2026 at 04:39:21PM +0200, Phil Sutter wrote:
> > Handling of concurrent hook changes with a dump in progress was
> > problematic in nfnl_hook_dump and entirely broken in nfnl_hook_dump_nat.
> > Address all issues in a single patch to please the review LLM.
> > 
> > Introduce sequence numbers in struct netns_nf to replace pointer
> > value-based modification detection which may fail due to memory buffer
> > reuse. This also eliminates the need for most manual cb->seq updates and
> > excessive array index value checks.
> > 
> > Since nat hook updates are protected by a different mutex than others,
> > they have to bump their own sequence number. nfnl_hook_dump_nat
> > therefore open-codes what nl_dump_check_consistent does but bumps
> > cb->seq instead of setting NLM_F_DUMP_INTR flag.
> > 
> > Dumps of many nat hooks was entirely broken since the array index was
> > not (re)stored. Use cb->args[1] for that and make sure it is reset upon
> > completion as the same dump may loop over multiple arrays of nat hooks.
> > 
> > In nfnl_hook_dump, don't signal NLM_F_DUMP_INTR if
> > nfnl_hook_entries_head returns error: This is a permanent condition
> > which does not change during a dump. It is already caught by
> > nfnl_hook_dump_start though, so should not happen anyway.
> > 
> > In general, access ops array pointer values using READ_ONCE since they
> > are assigned to using WRITE_ONCE.
> > 
> > Avoid setting NLM_F_DUMP_INTR flag in garbage memory by calling
> > nl_dump_check_consistent only for non-empty skbs. If not a single
> > netlink message was created, nfnetlink code will take care of setting
> > the flag.
> > 
> > Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
> > Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v1:
> > - Reset cursor value and perform EINTR check if NAT priv->entries
> >   becomes NULL during dump.
> > ---
> >  include/net/netns/netfilter.h  |  2 +
> >  net/netfilter/core.c           | 13 ++++++
> >  net/netfilter/nf_nat_core.c    | 14 ++++++-
> >  net/netfilter/nfnetlink_hook.c | 75 ++++++++++++++++++++--------------
> >  4 files changed, 72 insertions(+), 32 deletions(-)
> > 
> > diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
> > index a6a0bf4a247e..7fd78394d1e7 100644
> > --- a/include/net/netns/netfilter.h
> > +++ b/include/net/netns/netfilter.h
> > @@ -33,5 +33,7 @@ struct netns_nf {
> >  #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
> >  	unsigned int defrag_ipv6_users;
> >  #endif
> > +	unsigned int hook_base_seq;
> > +	unsigned int nat_hook_base_seq;
> >  };
> >  #endif
> > diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> > index 675a1034b340..a284b3241211 100644
> > --- a/net/netfilter/core.c
> > +++ b/net/netfilter/core.c
> > @@ -386,6 +386,15 @@ static void nf_static_key_dec(const struct nf_hook_ops *reg, int pf)
> >  #endif
> >  }
> >  
> > +static void bump_hook_base_seq(struct net *net)
> > +{
> > +	unsigned int base_seq = READ_ONCE(net->nf.hook_base_seq);
> > +
> > +	while (++base_seq == 0)
> > +		;
> > +	smp_store_release(&net->nf.hook_base_seq, base_seq);
> > +}
> > +
> >  static int __nf_register_net_hook(struct net *net, int pf,
> >  				  const struct nf_hook_ops *reg)
> >  {
> > @@ -428,6 +437,7 @@ static int __nf_register_net_hook(struct net *net, int pf,
> >  	new_hooks = nf_hook_entries_grow(p, reg);
> >  
> >  	if (!IS_ERR(new_hooks)) {
> > +		bump_hook_base_seq(net);
> >  		hooks_validate(new_hooks);
> >  		rcu_assign_pointer(*pp, new_hooks);
> 
> I think you have to call bump_hook_base_seq(net) here after
> rcu_assign_pointer()?

I had it both ways and Sashiko complained in each case. Either about
readers seeing the bumped seq and old pointer value or new pointer value
with old seq.

IMO all this is ridiculous anyway: The seq bump becomes effective
immediately, the pointer update happens after RCU grace period. So AIUI,
readers will always see the bumped seq with old pointer value.

Though we need the seq only to detect modification during the round-trip
to user space, which unifies the two value updates.

> >  	}
> > @@ -506,6 +516,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
> >  			net_dec_egress_queue();
> >  #endif
> >  		nf_static_key_dec(reg, pf);
> > +		bump_hook_base_seq(net);
> >  	} else {
> >  		WARN_ONCE(1, "hook not found, pf %d num %d", pf, reg->hooknum);
> >  	}
> > @@ -784,6 +795,8 @@ static int __net_init netfilter_net_init(struct net *net)
> >  		return -ENOMEM;
> >  	}
> >  #endif
> > +	net->nf.hook_base_seq = 1;
> > +	net->nf.nat_hook_base_seq = 1;
> >  
> >  	return 0;
> >  }
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index 8ac326e1eb5b..ff2cba8df886 100644
> > --- a/net/netfilter/nf_nat_core.c
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -1160,6 +1160,15 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
> >  }
> >  #endif
> >  
> > +static void bump_nat_hook_base_seq(struct net *net)
> > +{
> > +	unsigned int base_seq = READ_ONCE(net->nf.nat_hook_base_seq);
> > +
> > +	while (++base_seq == 0)
> > +		;
> > +	smp_store_release(&net->nf.nat_hook_base_seq, base_seq);
> > +}
> > +
> >  static struct nf_ct_helper_expectfn follow_master_nat = {
> >  	.name		= "nat-follow-master",
> >  	.expectfn	= nf_nat_follow_master,
> > @@ -1245,8 +1254,10 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
> >  	}
> >  
> >  	ret = nf_hook_entries_insert_raw(&priv->entries, ops);
> > -	if (ret == 0)
> > +	if (ret == 0) {
> > +		bump_nat_hook_base_seq(net);
> >  		nat_proto_net->users++;
> 
> Sashiko refers to another issue that is fixed here:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260902232856.1024959-1-pablo@netfilter.org/
> 
> This patch needs a rebase on top of that fix above. Maybe it is good
> to get the two patches in the same batch.

ACK, I will rebase on top of that before sending a v3.

> I think fixing the ordering in which base_seq is bumped (after
> publishing the new hook) should be fine.

I don't think it matters, but if you prefer the bump after RCU pointer
assign, fine with me.

> A few more comments below.
> 
> > +	}
> >  
> >  	mutex_unlock(&nf_nat_proto_mutex);
> >  	return ret;
> > @@ -1284,6 +1295,7 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
> >  		goto unlock;
> >  	priv = nat_ops[hooknum].priv;
> >  	nf_hook_entries_delete_raw(&priv->entries, ops);
> > +	bump_nat_hook_base_seq(net);
> >  
> >  	if (nat_proto_net->users == 0) {
> >  		nf_unregister_net_hooks(net, nat_ops, ops_count);
> > diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
> > index 95005e9a6066..21a759168c38 100644
> > --- a/net/netfilter/nfnetlink_hook.c
> > +++ b/net/netfilter/nfnetlink_hook.c
> > @@ -54,7 +54,6 @@ static int nf_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
> >  
> >  struct nfnl_dump_hook_data {
> >  	char devname[IFNAMSIZ];
> > -	unsigned long headv;
> >  	u8 hook;
> >  };
> >  
> > @@ -338,27 +337,48 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
> >  }
> >  
> >  static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
> > -			      const struct nfnl_dump_hook_data *ctx,
> > -			      const struct nf_hook_ops *ops,
> > -			      int family, unsigned int seq)
> > +			      struct netlink_callback *cb,
> > +			      const struct nf_hook_ops *ops, int family)
> >  {
> >  	struct nf_nat_lookup_hook_priv *priv = ops->priv;
> > -	struct nf_hook_entries *e = rcu_dereference(priv->entries);
> > +	struct nfnl_dump_hook_data *ctx = cb->data;
> > +	struct net *net = sock_net(nlskb->sk);
> >  	struct nf_hook_ops **nat_ops;
> > -	int i, err;
> > +	unsigned int i = cb->args[1];
> > +	struct nf_hook_entries *e;
> > +	unsigned int base_seq;
> > +	int err = 0;
> >  
> > +	base_seq = smp_load_acquire(&net->nf.nat_hook_base_seq);
> > +
> > +	e = rcu_dereference(priv->entries);
> >  	if (!e)
> > -		return 0;
> > +		goto out;
> >  
> >  	nat_ops = nf_hook_entries_get_hook_ops(e);
> >  
> > -	for (i = 0; i < e->num_hook_entries; i++) {
> > -		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
> > -					 ops->priority, family, seq);
> > +	for (; i < e->num_hook_entries; i++) {
> > +		err = nfnl_hook_dump_one(nlskb, ctx,
> > +					 READ_ONCE(nat_ops[i]),
> > +					 ops->priority, family,
> > +					 cb->nlh->nlmsg_seq);
> >  		if (err)
> > -			return err;
> > +			break;
> > +
> >  	}
> > -	return 0;
> > +out:
> > +	if (!err) {
> > +		i = 0;
> > +	}
> 
> Comestic: This curly braces can be removed for single statement.

Oh, right!

> > +	cb->args[1] = i;
> > +
> > +	if (cb->args[2] && base_seq != cb->args[2]) {
> > +		cb->seq++;
> > +		err = -EINTR;
> > +	}
> > +	cb->args[2] = base_seq;
> > +
> > +	return err;
> >  }
> >  
> >  static int nfnl_hook_dump(struct sk_buff *nlskb,
> > @@ -373,35 +393,31 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
> >  	unsigned int i = cb->args[0];
> >  
> >  	rcu_read_lock();
> > +	cb->seq = smp_load_acquire(&net->nf.hook_base_seq);
> >  
> >  	e = nfnl_hook_entries_head(family, ctx->hook, net, ctx->devname);
> > -	if (!e)
> > +	if (!e || IS_ERR(e))
> >  		goto done;
> >  
> > -	if (IS_ERR(e)) {
> > -		cb->seq++;
> > -		goto done;
> > -	}
> > -
> > -	if ((unsigned long)e != ctx->headv || i >= e->num_hook_entries)
> > -		cb->seq++;
> > -
> >  	ops = nf_hook_entries_get_hook_ops(e);
> >  
> >  	for (; i < e->num_hook_entries; i++) {
> > -		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
> > -			err = nfnl_hook_dump_nat(nlskb, ctx, ops[i], family,
> > -						 cb->nlh->nlmsg_seq);
> > -		else
> > -			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
> > -						 ops[i]->priority, family,
> > +		const struct nf_hook_ops *cur = READ_ONCE(ops[i]);
> > +
> > +		if (cur->hook_ops_type == NF_HOOK_OP_NAT)
> > +			err = nfnl_hook_dump_nat(nlskb, cb, cur, family);
> 
> Missing curly brace for consistency with the else below (IIRC, if
> either if () or else is multistatement or multiline then curly braces
> are recommended.

Ah, indeed. Sorry for these obvious ones. Too much focus on eliminating
the LLM complaints, I guess.

> > +		else {
> > +			err = nfnl_hook_dump_one(nlskb, ctx, cur,
> > +						 cur->priority, family,
> >  						 cb->nlh->nlmsg_seq);
> > +		}
> >  		if (err)
> >  			break;
> >  	}
> >  
> >  done:
> > -	nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
> > +	if (nlskb->len > 0)
> 
> Is this new check needed? I think the consistency check can be
> performed inconditionally?

If seq is bumped and not a single message was generated yet,
nl_dump_check_consistent sets the flag in uninitialized data. I tried to
follow the advice in nl_dump_check_consistent's comment and call it "for
each message that is generated" but it's not easy given the detour for
nat hooks which may or may not produce a message. Checking nlskb->len is
easy and straightforward. If it's zero, netlink_dump_done will set the
flag in the NLMSG_DONE message it creates.

Cheers, Phil

> > +		nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
> >  	rcu_read_unlock();
> >  	cb->args[0] = i;
> >  	return nlskb->len;
> > @@ -442,10 +458,7 @@ static int nfnl_hook_dump_start(struct netlink_callback *cb)
> >  		return -ENOMEM;
> >  
> >  	strscpy(ctx->devname, name, sizeof(ctx->devname));
> > -	ctx->headv = (unsigned long)head;
> >  	ctx->hook = hooknum;
> > -
> > -	cb->seq = 1;
> >  	cb->data = ctx;
> >  
> >  	return 0;
> > -- 
> > 2.54.0
> > 
> 
> 
