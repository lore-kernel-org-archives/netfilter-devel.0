Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBE733F368
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 08:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790412504; cv=none; b=FoST3efV/DKrO/T6cM/SkdXMCht5PG8tL3BElptqwhC0SriHiprhdRcx0pVfc1nMxzlHhNNZbDQRco2xgNGfg1FS3vDIgEhF61WfFLn6VJIfLhg1QK8eqSX4arFYUpwk3gSQ1EJZciS5HLRXgjrTdaAQ2+EYELaQK4sHAdsCboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790412504; c=relaxed/simple;
	bh=qP+vfuYSN0uxxUUacFUqszSGECDnt2lXgSfCiW60ifM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3pclGDeOGdXmNZ+gZuu/NzoAqj9YMfcGJ0iFvC4fpaHMJlFPY6gWg5zPQfk/aRMiMmOS+gqNlZvUmAJT7hhtCAda5Y/ND3KxYGutt/EBQUrfGzmo50OCQE/Yoad0Dhp7a5RXx+lNxrqTZk93E4ETc98vX3U0PMG+h31nxSa3DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XSSVievw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XSSVievw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790412490;
	bh=bfsZ/evKSXGdncdLAo3WOA8KZo4rW0hoGuRtnUcsgKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XSSVievwNhU2zZPYDp9/9VYIFrH1/7ZvInQZfveq0tPUTtFYSs/xSjlFWmH2crcOk
	 pb2za5laPZv8smChdQtCEc4RiJ/UWbVV+Alnpz4CPk+2yJa+11rEzrAKRYzu8Tqh0+
	 ZmQOJtDXQiEQM8HUGZMQQWXV9A/BTHO1iXF43ahzLyfHzqu9gCwyWQFXj3lPDiif4p
	 D99DmDTe6qXRwGvuHgLVnmMEG8l1yROuUuc5Hhph+IWh2H1oey8DXnTWm24cRvNh/A
	 lKxbZ9+MbwLSzfkmRjEJDg+72e69IGDB2DvmKMkztNWFtN1QdeMpbpz4l6zfyTN6jD
	 eWHHBiE49NcGQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3580D60965;
	Sat, 26 Sep 2026 10:48:10 +0200 (CEST)
Date: Sat, 26 Sep 2026 10:48:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v4] netfilter: nfnetlink: Fix for interrupted hook
 dumps
Message-ID: <areGx5hXucpyThwn@chamomile>
References: <20260909093455.3034863-1-phil@nwl.cc>
 <araL5hxspkhlCoFn@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <araL5hxspkhlCoFn@orbyte.nwl.cc>

Hi Phil,

I am preparing a PR with nf fixes and nf-next updates later today.

On Fri, Sep 25, 2026 at 04:57:42PM +0200, Phil Sutter wrote:
> Bump!
> 
> On Wed, Sep 09, 2026 at 11:34:55AM +0200, Phil Sutter wrote:
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
> > Changes since v3:
> > - Bump hook_base_seq after potential array shrinking for consistency
> > 
> > Changes since v2:
> > - Bump seq after RCU-pointer assign in __nf_register_net_hook
> > - Fix coding style (braces)
> > - Rebase onto https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260902232856.1024959-1-pablo@netfilter.org/
> > 
> > Changes since v1:
> > - Reset cursor value and perform EINTR check if NAT priv->entries
> >   becomes NULL during dump.
> > ---
> >  include/net/netns/netfilter.h  |  2 +
> >  net/netfilter/core.c           | 18 ++++++++-
> >  net/netfilter/nf_nat_core.c    | 11 +++++
> >  net/netfilter/nfnetlink_hook.c | 74 ++++++++++++++++++++--------------
> >  4 files changed, 73 insertions(+), 32 deletions(-)
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
> > index 675a1034b340..940dea2663e9 100644
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
> > @@ -430,6 +439,7 @@ static int __nf_register_net_hook(struct net *net, int pf,
> >  	if (!IS_ERR(new_hooks)) {
> >  		hooks_validate(new_hooks);
> >  		rcu_assign_pointer(*pp, new_hooks);
> > +		bump_hook_base_seq(net);
> >  	}
> >  
> >  	mutex_unlock(&nf_hook_mutex);
> > @@ -483,6 +493,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
> >  {
> >  	struct nf_hook_entries __rcu **pp;
> >  	struct nf_hook_entries *p;
> > +	bool found;
> >  
> >  	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
> >  	if (!pp)
> > @@ -496,7 +507,8 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
> >  		return;
> >  	}
> >  
> > -	if (nf_remove_net_hook(p, reg)) {
> > +	found = nf_remove_net_hook(p, reg);
> > +	if (found) {
> >  #ifdef CONFIG_NETFILTER_INGRESS
> >  		if (nf_ingress_hook(reg, pf))
> >  			net_dec_ingress_queue();
> > @@ -511,6 +523,8 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
> >  	}
> >  
> >  	p = __nf_hook_entries_try_shrink(p, pp);
> > +	if (found)
> > +		bump_hook_base_seq(net);
> >  	mutex_unlock(&nf_hook_mutex);
> >  	if (!p)
> >  		return;
> > @@ -784,6 +798,8 @@ static int __net_init netfilter_net_init(struct net *net)
> >  		return -ENOMEM;
> >  	}
> >  #endif
> > +	net->nf.hook_base_seq = 1;
> > +	net->nf.nat_hook_base_seq = 1;
> >  
> >  	return 0;
> >  }
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index a4858c2b2d65..27d67a677aa4 100644
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
> > @@ -1244,6 +1253,7 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
> >  		nat_proto_net->nat_hook_ops = nat_ops;
> >  
> >  	nat_proto_net->users++;
> > +	bump_nat_hook_base_seq(net);
> >  
> >  	mutex_unlock(&nf_nat_proto_mutex);
> >  
> > @@ -1298,6 +1308,7 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
> >  		goto unlock;
> >  	priv = nat_ops[hooknum].priv;
> >  	nf_hook_entries_delete_raw(&priv->entries, ops);
> > +	bump_nat_hook_base_seq(net);
> >  
> >  	if (nat_proto_net->users == 0) {
> >  		nf_unregister_net_hooks(net, nat_ops, ops_count);
> > diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
> > index 95005e9a6066..b05fd79397c5 100644
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
> > @@ -338,27 +337,47 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
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
> > +	if (!err)
> > +		i = 0;
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
> > @@ -373,35 +392,31 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
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
> > +		if (cur->hook_ops_type == NF_HOOK_OP_NAT) {
> > +			err = nfnl_hook_dump_nat(nlskb, cb, cur, family);
> > +		} else {
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
> > +		nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
> >  	rcu_read_unlock();
> >  	cb->args[0] = i;
> >  	return nlskb->len;
> > @@ -442,10 +457,7 @@ static int nfnl_hook_dump_start(struct netlink_callback *cb)
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
> > 
> > 
