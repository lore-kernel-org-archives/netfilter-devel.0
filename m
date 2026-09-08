Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B4153D0AF
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 12:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788871274; cv=none; b=K6tnPBfwmSlIWz1I0DvLhOPb5ne1IO4l5Meh5jHtMh4Lrjme2dcnB3FzPdVBEKNZmtUrcsJQJSq8yZtevGay8ZrTbS6MOvOmBGFL5mC3D7CAc8mSe+xwwkxeAfyIeRV6Kgg9qLm/F0Ji7nEcVx6PYvKFtpYMA5xGwNJjnYSNx9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788871274; c=relaxed/simple;
	bh=JQdWLovzDg+KAFKzst0VCsQKh7nFugxZkL7PFI9knGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2ZBtiQgjQnOCXqs2yHfgGIDfwRJVETBmwovluKQWYaYP+RcK7HUJHrbAKVJk9ERpiTcY0a0TyqvcC+GHAWtD+7Gc4kD0U6YkK9zdQjV59Stw/LtS94DLbayxw95udoi/Q/iwRCu9t4+j7eWBBTmByqyoEIUOlLzAshtOkMM644=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BkA8N4qU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BkA8N4qU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788871268;
	bh=7BvSMiT9qn0flt1xQ2ZFpPPlb0DWXAo+iucJIimZjo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkA8N4qUCMcDTPey3SsrQvWALOIs9A00X1aLp1d7+YwfGNS2uCWXhY4EjALw/1efK
	 iZUgEhHN7oCD4SqdforW8kb0eV6habSo1GDiJ6K5LOfYpC3mBjfYxLqQUh2OkpVYD3
	 cyByi8x0H9AwM+dD6fFHYZ/S7OcxcF2YqVIUX8QEsTGB3xSF7hrR+a293UTY2rcXI9
	 Fic3W13582rJTwuN6pTPTfeu9u/apMMUMAK0tgkUTbmiHkb//kGwxHdyfYQ5in/5R9
	 p2t097mSJZ3XH8k68XHr7KSfysOJgRetBG3frPOibnsr4iv3jQ+V+GAGe+lujM8PHX
	 ZqTVL4zdJ7ycA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 02EEE6079A;
	Tue,  8 Sep 2026 14:41:08 +0200 (CEST)
Date: Tue, 8 Sep 2026 14:41:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v3] netfilter: nfnetlink: Fix for interrupted hook
 dumps
Message-ID: <aqACYYwn1pYp735Z@chamomile>
References: <20260904125215.1272252-1-phil@nwl.cc>
 <ap8AQ1DCUET8Ggkd@chamomile>
 <ap_T9yc-1IP0SPXs@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ap_T9yc-1IP0SPXs@orbyte.nwl.cc>

On Tue, Sep 08, 2026 at 11:23:03AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Sep 07, 2026 at 08:19:47PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Sep 04, 2026 at 02:52:15PM +0200, Phil Sutter wrote:
> > > @@ -338,27 +337,47 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
> > >  }
> > >  
> > >  static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
> > > -			      const struct nfnl_dump_hook_data *ctx,
> > > -			      const struct nf_hook_ops *ops,
> > > -			      int family, unsigned int seq)
> > > +			      struct netlink_callback *cb,
> > > +			      const struct nf_hook_ops *ops, int family)
> > >  {
> > >  	struct nf_nat_lookup_hook_priv *priv = ops->priv;
> > > -	struct nf_hook_entries *e = rcu_dereference(priv->entries);
> > > +	struct nfnl_dump_hook_data *ctx = cb->data;
> > > +	struct net *net = sock_net(nlskb->sk);
> > >  	struct nf_hook_ops **nat_ops;
> > > -	int i, err;
> > > +	unsigned int i = cb->args[1];
> > > +	struct nf_hook_entries *e;
> > > +	unsigned int base_seq;
> > > +	int err = 0;
> > >  
> > > +	base_seq = smp_load_acquire(&net->nf.nat_hook_base_seq);
> > 
> > Maybe annnotate this base sequence in the .start via:
> > 
> > struct netlink_dump_control c = {
> >         .start = ...;
> > 
> > We should probably start doing this in other nfnetlink subsystems too.
> > 
> > This will help catch an interference between two netlink recv() calls
> > which results in calling netlink_dump() which calls this function.
> 
> I do not comprehend, sorry. The concurrent hook dumps have distinct cb
> buffers and net->nf.{nat_,}hook_base_seq is shared but read-only. How
> does the problematic interference happen?

See nf_tables_dump_rules_start() for instance. It allocates the struct
nft_rule_dump_ctx, which is reachable through .start, .dump and .done
callbacks. I think it should be possible to annotate the current
base_seq at the beginning of the netlink dump from .start in a ctx
object. Then, use it from .dump to check if dump is consistent (ie.
turn on the NLM_F_DUMP_INTR flag).

So, instead of fetching the current sequence from .dump like this:

        cb->seq = nft_base_seq(net);

Use the sequence available in the new ctx object, ie. from .dump path
you do this:

        cb->seq = ctx->seq;

Because netlink_dump() is called for each userspace recv() call (netlink
delivers the chunked listing in several messages), this would allow
userspace to know that the listing is inconsistent, then optionally
retry.

Makes sense to you?
