Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25271492E35
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2026 00:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788914048; cv=none; b=oHy1Lu6rIjg7+HVE1gkNmQLlTo5ZbfdORHX57PNc60M4PdMuWwAsknUaLMqZh7QXOUGMn6wkzNIxbi8mjevIVBju/4H3ocLkNSdxDQCy6V7Jp8yKYbNBp03yvfl5Gbdnn3bG44h2eJw/YC6EuuA2L0rOw0Ei2q/8BrEKlKSaA1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788914048; c=relaxed/simple;
	bh=7vFbFVExogiZDgMXxFawmHinnL5ylrVDBmYXfL4VR5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAIWtYCpUs8E3UtpCJcunkJ4FPXaK5muwCkmjv9CVY4CAruj9aePOGN2Sn1Ng6LUaCCio145KQEFOVi48EmR9b5bGhSEoxnsY8HDojgAVLu1NQj2drEVUbRypDZbNIITJA8QrXfSHFyf/wBO9dJX20H8FXlrqP31FbPPXHtADGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PICoCU1v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PICoCU1v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788914044;
	bh=cX71tHeHMsSQNid3GR0olVpDxLx/poWhRTF3U8bcmKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PICoCU1vjuANA8iAS7HEdEmgFeqkZ50sWFReC24+nd6G4Al5NygM/ImHUD3lVELAt
	 +uAIBiylwm3fGrjFn37c+5JqnQubVlTHpKk5p9q4VZ3vGVFufDnE+s+sQMkbcrvSSI
	 fm6htTT/mHBygi4R26MvUNNwwsKVnUVDchovzgNvvNt6uzpGg0a4TMs0qk6ihfx8z7
	 pcvaBTX+STCDyniR217C5LHClVkjD4p8daAMTwnehBT4yRsnYv61cJJ7R01Ru8TOSD
	 DnIi22EMCS1Kq/3XI3u14+27GWWGewUVDY5PvVTFp04e3YxOgoQGKEZhceYu5K0p1d
	 BFOOzCtJteseA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 29D7B607CD;
	Wed,  9 Sep 2026 02:34:04 +0200 (CEST)
Date: Wed, 9 Sep 2026 02:34:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v3] netfilter: nfnetlink: Fix for interrupted hook
 dumps
Message-ID: <aqCpea5w45dXZ3p1@chamomile>
References: <20260904125215.1272252-1-phil@nwl.cc>
 <ap8AQ1DCUET8Ggkd@chamomile>
 <ap_T9yc-1IP0SPXs@orbyte.nwl.cc>
 <aqACYYwn1pYp735Z@chamomile>
 <aqAUL70ynrF6cT0G@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqAUL70ynrF6cT0G@orbyte.nwl.cc>

On Tue, Sep 08, 2026 at 03:57:03PM +0200, Phil Sutter wrote:
> On Tue, Sep 08, 2026 at 02:41:05PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Sep 08, 2026 at 11:23:03AM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Mon, Sep 07, 2026 at 08:19:47PM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, Sep 04, 2026 at 02:52:15PM +0200, Phil Sutter wrote:
> > > > > @@ -338,27 +337,47 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
> > > > >  }
> > > > >  
> > > > >  static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
> > > > > -			      const struct nfnl_dump_hook_data *ctx,
> > > > > -			      const struct nf_hook_ops *ops,
> > > > > -			      int family, unsigned int seq)
> > > > > +			      struct netlink_callback *cb,
> > > > > +			      const struct nf_hook_ops *ops, int family)
> > > > >  {
> > > > >  	struct nf_nat_lookup_hook_priv *priv = ops->priv;
> > > > > -	struct nf_hook_entries *e = rcu_dereference(priv->entries);
> > > > > +	struct nfnl_dump_hook_data *ctx = cb->data;
> > > > > +	struct net *net = sock_net(nlskb->sk);
> > > > >  	struct nf_hook_ops **nat_ops;
> > > > > -	int i, err;
> > > > > +	unsigned int i = cb->args[1];
> > > > > +	struct nf_hook_entries *e;
> > > > > +	unsigned int base_seq;
> > > > > +	int err = 0;
> > > > >  
> > > > > +	base_seq = smp_load_acquire(&net->nf.nat_hook_base_seq);
> > > > 
> > > > Maybe annnotate this base sequence in the .start via:
> > > > 
> > > > struct netlink_dump_control c = {
> > > >         .start = ...;
> > > > 
> > > > We should probably start doing this in other nfnetlink subsystems too.
> > > > 
> > > > This will help catch an interference between two netlink recv() calls
> > > > which results in calling netlink_dump() which calls this function.
> > > 
> > > I do not comprehend, sorry. The concurrent hook dumps have distinct cb
> > > buffers and net->nf.{nat_,}hook_base_seq is shared but read-only. How
> > > does the problematic interference happen?
> > 
> > See nf_tables_dump_rules_start() for instance. It allocates the struct
> > nft_rule_dump_ctx, which is reachable through .start, .dump and .done
> > callbacks. I think it should be possible to annotate the current
> > base_seq at the beginning of the netlink dump from .start in a ctx
> > object. Then, use it from .dump to check if dump is consistent (ie.
> > turn on the NLM_F_DUMP_INTR flag).
> > 
> > So, instead of fetching the current sequence from .dump like this:
> > 
> >         cb->seq = nft_base_seq(net);
> > 
> > Use the sequence available in the new ctx object, ie. from .dump path
> > you do this:
> > 
> >         cb->seq = ctx->seq;
> 
> But to detect a concurrent hook update between to .dump callback calls
> (if skb space was exceeded), the current value in per-net data has to
> be fetched, no? So this would have to look like this in .dump callback:
> 
> | ctx->seq = nft_base_seq(net);
> | cb->seq = ctx->seq;
> 
> Then I don't get the detour via struct nfnl_dump_hook_data. Or is it
> possible we get multiple concurrent dump requests on the same netlink
> socket and thus cb->seq (and cb->prev_seq) gets shared between them?
> 
> > Because netlink_dump() is called for each userspace recv() call (netlink
> > delivers the chunked listing in several messages), this would allow
> > userspace to know that the listing is inconsistent, then optionally
> > retry.
> > 
> > Makes sense to you?
> 
> Not quite, sorry.

Right, I got confused by the LLM report.

Should be postpone bumping the seq also after array has been shrunk as
LLM suggest in the remove path? For consistency with the insert
operations, just bump sequence _after_ the datastructure update.
