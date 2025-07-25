Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64C5475E
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753455813; cv=none; b=pbB5bpJJXQQvJJFm4I2GGPyJfzkf6EJHEotGPgBPnXLXOIsnH4sI5XBLmutoECd+Ir+nk/qAoEwhXRGExIyCu9/qwILKyNOwGlAM803ghNvIsZvIqmy9Bmt9II50ifnAee858Xio1ULcTFfV+y8kBQBns2nrCpfqcqXbDTBZF5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753455813; c=relaxed/simple;
	bh=rNC7lM+756hoXSCUwDAmVyg36i2EWNdbhNMoqKyDF3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhYQCh+JD2XHFnWPx4BDRMkOTpx4inoEu3AtNYsSiuAJo8AztIwdQIXnleRP/zW/uVWazL1WoUehIAr+sGZTe4GTIPvSJN2Usdzf99Oo1Ur7LOCTzHDcOo5rhCgU2xUctamz8TAiZ6t6Q4TU1l2sop1pAGrlZrIr/nD2svNVpdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vxWGe306; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=caHIn6AY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vxWGe306";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="caHIn6AY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 54DDE60269; Fri, 25 Jul 2025 17:03:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753455808;
	bh=1kUEelZ1ySwN5rs6K8g+vnhLOTmlOqxme19AGSnyZJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vxWGe306OvjJvDfxdc9bUnPZEEg6MZtlHN3DSHWRN6zSj27ptdqiAtH+5eZD9B24F
	 HibSd4/0PUNwM6GnYmI1BqYcTLmHDHBPIcJz5eJffVQQs6+jNTAaE0BxpeQTyS204E
	 +7WPWjIUQzFlTYx6kVbLmrkD3IQBr3+2w00RGk2fVfdMVw6azbA6nmZAo7cnBHNgG7
	 5FCfTDHp2pCCHWZW6OGUB48plQNgaf1zr8C6ATzEpqLsXtHwWKXF8qkaaCtFHtZrQN
	 67iUIQoI3/FJ33FQdguVWfeq7Tw8kfbEwvar40qAqGTpicZf1IZ5Jd5XjqSFgdAMJs
	 j4F+uMuTCOX7w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38B1A60269;
	Fri, 25 Jul 2025 17:03:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753455807;
	bh=1kUEelZ1ySwN5rs6K8g+vnhLOTmlOqxme19AGSnyZJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=caHIn6AY3g28KVXCo+ehE0mWLGX5uz+NXNCHPoDgUGPIC3RfeH7WqC38QU8QLiDS3
	 vzU+WdXi66NBmTYRQfPieW46Qc1cdh/pXUPySOAcU4EAbeUvrxPHgz0wUFz+5b6oVf
	 9JmhtteexwCkO8tvN7qGM4q+L+aqVFSRWfd7TeI5BRaIQ9L1z1juXzrwpuIV++RxR2
	 Kw7Otd/k1AknWY1BAias2fuVEyGGflHJsktpOLanK7WQa8iHojNzVR3swIYtPYKNCo
	 K/Ykv+CWyye/Tj8ob5V5OKH3qr5evdJMS1J9dw3FNzsxODDvJBJkZzAjq5OtrB+ghZ
	 vsJamMThPKZnw==
Date: Fri, 25 Jul 2025 17:03:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIOcq2sdP17aYgAE@calendula>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aINnTy_Ifu66N8dp@strlen.de>

On Fri, Jul 25, 2025 at 01:15:27PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I think the key is to be able to identify what elements have been
> > flushed by what flush command, so abort path can just restore/undo the
> > state for the given elements.
> > 
> > Because this also is possible:
> > 
> >        flush set x + [...] + flush set x
> > 
> > And [...] includes possible new/delete elements in x.
> > 
> > It should be possible to store an flush command id in the set element
> > (this increases the memory consumption of the set element, which your
> > series already does it) to identify what flush command has deleted it.
> > This is needed because the transaction object won't be in place but I
> > think it is a fair tradeoff. The flush command id can be incremental
> > in the batch (the netlink sequence number cannot be used for this
> > purpose).
> 
> OK, that might work.  So the idea is to do the set walk as-is, but
> instead of allocating a NFT_MSG_DELSETELEM for each transaction
> object, introduce NFT_MSG_FLUSHSET transaction.

Or simply using NFT_MSG_DELSET and add a flag to note this is a flush.

> Then, for a DELSETELEM request with no elements (== flush),
> allocate *one* NFT_MSG_FLUSHSET transaction.

Yes.

> The NFT_MSG_FLUSHSET transaction holds the set being flushed
> and an id, that increments sequentially once for each flush.

Yes.

> Then, do the walk as-is:
> 
> static int nft_setelem_flush(const struct nft_ctx *ctx,
>                              struct nft_set *set,
>                              const struct nft_set_iter *iter,
>                              struct nft_elem_priv *elem_priv)
> {
>         const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
>         struct nft_trans *trans;
> 
> 	/* previous delsetelem or erlier flush marked it inactive */
>         if (!nft_set_elem_active(ext, iter->genmask))
>                 return 0;
> 
> /* No allocation per set elemenet anymore */
> /* trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM, */
> 
> 	/* trans_flush could be obtained from the tail of
> 	 * the transaction list.  Or placed in *iter.
> 	 */
> 	elem_priv->flush_id = trans_flush->flush_id
>         set->ops->flush(ctx->net, set, elem_priv);
>         set->ndeact++;
> 
>         nft_setelem_data_deactivate(ctx->net, set, elem_priv);
> 
>         return 0;

Maybe use nft_map_deactivate() ?

> }
> 
> On abort, NFT_MSG_FLUSHSET would do another walk, for all set elements,
> and then calls nft_setelem_data_activate/nft_setelem_activate in case
> elem_priv->flush_id == trans_flush->flush_id.

Exactly, maybe nft_map_activate() can help.

> Did I get that right?  I don't see any major issues with this, except
> the need to add u32 flush_id to struct nft_elem_priv.
> Or perhaps struct nft_set_ext would be a better fit as nft_elem_priv is
> just a proxy.

Yes, u32 flush_id (or trans_id) needs to be added, then set
transaction id incrementally.

> > Of course, this needs careful look, but if the set element can be used
> > to annotate the information that allows us to restore to previous
> > state before flush (given the transaction object is not used anymore),
> > then it should work. Your series is extending the set element size for
> > a different purpose, so I think the extra memory should not be an
> > issue.
> 
> Agree, it would need 4 bytes per elem which isn't much compared to the
> transaction log savings.
> 
> Will you have a look or should I have a go at this?

Please, go for it.
