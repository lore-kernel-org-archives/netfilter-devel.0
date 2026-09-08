Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3648725F99F
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875847; cv=none; b=crcoT8ZfimH/37hz2BSjCT/OLq9l57AEaf5aZ+/T9eJGN62JCmndPQFjMiciejijsb4GC+F3RZlC7VkzPzcnQJ1d6RWeYIrw5ZxN6sqQcLf3JcmTOiY9vpeL5glI3/OiVb7dggHeEgIWbARGe8aT/88uwpGp4Axemp3j91ug2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875847; c=relaxed/simple;
	bh=BuYp95HvAUz4gV6Q2gPxGpFZSqgB4dBy+Z9EQuklrJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTQb07/pqs5YN3eARiCIJ9pFZSaOrlo/GVLtSiDNatIbnoC6VY3gXm2khE4MMg09uLsvZRcEnuKiFeXm8ZdOJmiE8nkAUE9RRHjFlq72x8tLaYYG4uOvOMzBoGC8LAcrroYT70cwD/wfxK40AqSeplMUW+Tb1xWowc28iK3GQaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ALET8gfd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ALET8gfd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a9sWdgmn6TiBwqbsPjZTM2GjtLf/DPJayd4W5feYG+A=; b=ALET8gfdTdj2kx853t9HsRNs51
	3pvkAmRD1JOYMCPTNItCntgt1K7RDQ0cpMyitsMdaUBDCxTgQ35F4dFMT+dxWfiYFXFfM5gh3Qhp/
	PS4kNS54SAvZTNJOyBqY2fSn7jNdwhYwy7pO0xexpZUkzXrN3HuEdm2iSEyzqQqMSUvr0BEkkOGPS
	2RFiDB4wicVFwBi1krUoXHSpbIJJYBWyq3cAFXRVfdT+mjqBZGntVu2R5oiqkc+BV4FY2aYMDPDh2
	Uyt3dgNM43gGxpOB0FIMVdmzjaoNXqvO8gbu3dnXCPALCGAJQAkCyFqbmFTmkgmEPReXfkGFz1Jqp
	yahjpk+w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x3wJr-0000000005e-0zpv;
	Tue, 08 Sep 2026 15:57:03 +0200
Date: Tue, 8 Sep 2026 15:57:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v3] netfilter: nfnetlink: Fix for interrupted hook
 dumps
Message-ID: <aqAUL70ynrF6cT0G@orbyte.nwl.cc>
References: <20260904125215.1272252-1-phil@nwl.cc>
 <ap8AQ1DCUET8Ggkd@chamomile>
 <ap_T9yc-1IP0SPXs@orbyte.nwl.cc>
 <aqACYYwn1pYp735Z@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqACYYwn1pYp735Z@chamomile>

On Tue, Sep 08, 2026 at 02:41:05PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 08, 2026 at 11:23:03AM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Mon, Sep 07, 2026 at 08:19:47PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Sep 04, 2026 at 02:52:15PM +0200, Phil Sutter wrote:
> > > > @@ -338,27 +337,47 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
> > > >  }
> > > >  
> > > >  static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
> > > > -			      const struct nfnl_dump_hook_data *ctx,
> > > > -			      const struct nf_hook_ops *ops,
> > > > -			      int family, unsigned int seq)
> > > > +			      struct netlink_callback *cb,
> > > > +			      const struct nf_hook_ops *ops, int family)
> > > >  {
> > > >  	struct nf_nat_lookup_hook_priv *priv = ops->priv;
> > > > -	struct nf_hook_entries *e = rcu_dereference(priv->entries);
> > > > +	struct nfnl_dump_hook_data *ctx = cb->data;
> > > > +	struct net *net = sock_net(nlskb->sk);
> > > >  	struct nf_hook_ops **nat_ops;
> > > > -	int i, err;
> > > > +	unsigned int i = cb->args[1];
> > > > +	struct nf_hook_entries *e;
> > > > +	unsigned int base_seq;
> > > > +	int err = 0;
> > > >  
> > > > +	base_seq = smp_load_acquire(&net->nf.nat_hook_base_seq);
> > > 
> > > Maybe annnotate this base sequence in the .start via:
> > > 
> > > struct netlink_dump_control c = {
> > >         .start = ...;
> > > 
> > > We should probably start doing this in other nfnetlink subsystems too.
> > > 
> > > This will help catch an interference between two netlink recv() calls
> > > which results in calling netlink_dump() which calls this function.
> > 
> > I do not comprehend, sorry. The concurrent hook dumps have distinct cb
> > buffers and net->nf.{nat_,}hook_base_seq is shared but read-only. How
> > does the problematic interference happen?
> 
> See nf_tables_dump_rules_start() for instance. It allocates the struct
> nft_rule_dump_ctx, which is reachable through .start, .dump and .done
> callbacks. I think it should be possible to annotate the current
> base_seq at the beginning of the netlink dump from .start in a ctx
> object. Then, use it from .dump to check if dump is consistent (ie.
> turn on the NLM_F_DUMP_INTR flag).
> 
> So, instead of fetching the current sequence from .dump like this:
> 
>         cb->seq = nft_base_seq(net);
> 
> Use the sequence available in the new ctx object, ie. from .dump path
> you do this:
> 
>         cb->seq = ctx->seq;

But to detect a concurrent hook update between to .dump callback calls
(if skb space was exceeded), the current value in per-net data has to
be fetched, no? So this would have to look like this in .dump callback:

| ctx->seq = nft_base_seq(net);
| cb->seq = ctx->seq;

Then I don't get the detour via struct nfnl_dump_hook_data. Or is it
possible we get multiple concurrent dump requests on the same netlink
socket and thus cb->seq (and cb->prev_seq) gets shared between them?

> Because netlink_dump() is called for each userspace recv() call (netlink
> delivers the chunked listing in several messages), this would allow
> userspace to know that the listing is inconsistent, then optionally
> retry.
> 
> Makes sense to you?

Not quite, sorry.
