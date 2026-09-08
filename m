Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5434CB8B5
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 09:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859395; cv=none; b=T9Q9vNaW1OiOhDmotioFRwIt+lgS8RJ0lFM1Grk3jmp6uM0ju0OlWte5FyV9BUGOYNW3MrPSWnBNCBtenbHMxKEiK46iOkyqAlqEIGVDqH2RMotpeG86dlJd5a7VUZKFcvj41i0vFVCi/r1UHoPQuMjXqlTadRAb34kcNJ76f4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859395; c=relaxed/simple;
	bh=vqAsbIHzAeztXeBj7ebCDdE0lXvaZgp4HBQz5Fx/Z58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dP2p0wA8Bv+dEnHiyVgviCyAfrC1FftpleIwBnDLtpfa3SLCRv7NQMN9FY+1guAqqCttjH8fP29jsmnVtffyWyIZddYywJP4gRW8fqr6afoX1Z6PpG90tgieb+N/lXviVw9DZkCpmrwayzO8Mk2VRG/ZPHD8iSeyPJVTUv/nHk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KxLwUluO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KxLwUluO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CTCP5cDrEQ+rekoNe+L6oNCO5KXuB3k56EbKLztddkw=; b=KxLwUluO0PxRFKjeGQOWT7U+qq
	NmMSdob8HpXHZwOQpcrZDtN+ft9ISGjqWu2s34lTqSYenGhOoD5LeiHcC7PYTqtlOAFvhqny9peYd
	P4xmrd9gUgLFpkyZq/qUuM5VLEBTEo3kZs7JBXJgJjKMarZykfv9jmDcYV9cowUynp24rGq/Sx83r
	dLNhZSSkbQK4bpdOZbaJaZAt1XOJ14SFtxCqfpJTWw1dK/JqAZbnWbm2oKZo/Gyb+4Gt3Z9phOQ/J
	uK2oN+NtgTzhGj7DEdb0J+wKTJOl0Lsd0LFzS6oUfzBEpyT/u7j7Jxa8u4ybg7vrWiSQSMD+L1yTn
	qbOVnWIA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x3s2h-000000004lm-3dmc;
	Tue, 08 Sep 2026 11:23:03 +0200
Date: Tue, 8 Sep 2026 11:23:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v3] netfilter: nfnetlink: Fix for interrupted hook
 dumps
Message-ID: <ap_T9yc-1IP0SPXs@orbyte.nwl.cc>
References: <20260904125215.1272252-1-phil@nwl.cc>
 <ap8AQ1DCUET8Ggkd@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap8AQ1DCUET8Ggkd@chamomile>

Hi Pablo,

On Mon, Sep 07, 2026 at 08:19:47PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 04, 2026 at 02:52:15PM +0200, Phil Sutter wrote:
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
> 
> Maybe annnotate this base sequence in the .start via:
> 
> struct netlink_dump_control c = {
>         .start = ...;
> 
> We should probably start doing this in other nfnetlink subsystems too.
> 
> This will help catch an interference between two netlink recv() calls
> which results in calling netlink_dump() which calls this function.

I do not comprehend, sorry. The concurrent hook dumps have distinct cb
buffers and net->nf.{nat_,}hook_base_seq is shared but read-only. How
does the problematic interference happen?

Cheers, Phil
