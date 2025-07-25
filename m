Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AAA2E6112
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753442138; cv=none; b=YyHRMfy3pGSTsINK08t7QOqBXy/NYq60jRyFbPL9b2GTdvpIjy5GG/trP9TSYD9bKBANTsXc5eEPJgrOixYCUOZ2FQMewyTMOMk6C2Ps54NL8LMpbPoUF3n9dJ5EFHND+Jmc4JnGlQ9nu02hOkZ8U2CAUt+SogA7lOpylh6OW30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753442138; c=relaxed/simple;
	bh=dhOdqqRjnjGmE3HXfBBB1PB2qkCTZI0C4XUFcG5Z6fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFkj+KQVkLI6VT3qudjsUzHgMoky/BIsXvz1caxF7LGbIy2Zt3HCXWn4oPAhVUTWz5d93n37b7fKTit7WHI0s+KH8HK9JP7vHQn+T409woyVtQtMjnFEmuZaLwn63NZpz372UKOKonaV+tQl/QFJcTBL4djGZ0iKlgZE/9Tzxyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7F30C604C6; Fri, 25 Jul 2025 13:15:27 +0200 (CEST)
Date: Fri, 25 Jul 2025 13:15:27 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aINnTy_Ifu66N8dp@strlen.de>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aINYGACMGoNL77Ct@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I think the key is to be able to identify what elements have been
> flushed by what flush command, so abort path can just restore/undo the
> state for the given elements.
> 
> Because this also is possible:
> 
>        flush set x + [...] + flush set x
> 
> And [...] includes possible new/delete elements in x.
> 
> It should be possible to store an flush command id in the set element
> (this increases the memory consumption of the set element, which your
> series already does it) to identify what flush command has deleted it.
> This is needed because the transaction object won't be in place but I
> think it is a fair tradeoff. The flush command id can be incremental
> in the batch (the netlink sequence number cannot be used for this
> purpose).

OK, that might work.  So the idea is to do the set walk as-is, but
instead of allocating a NFT_MSG_DELSETELEM for each transaction
object, introduce NFT_MSG_FLUSHSET transaction.

Then, for a DELSETELEM request with no elements (== flush),
allocate *one* NFT_MSG_FLUSHSET transaction.

The NFT_MSG_FLUSHSET transaction holds the set being flushed
and an id, that increments sequentially once for each flush.

Then, do the walk as-is:

static int nft_setelem_flush(const struct nft_ctx *ctx,
                             struct nft_set *set,
                             const struct nft_set_iter *iter,
                             struct nft_elem_priv *elem_priv)
{
        const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
        struct nft_trans *trans;

	/* previous delsetelem or erlier flush marked it inactive */
        if (!nft_set_elem_active(ext, iter->genmask))
                return 0;

/* No allocation per set elemenet anymore */
/* trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM, */

	/* trans_flush could be obtained from the tail of
	 * the transaction list.  Or placed in *iter.
	 */
	elem_priv->flush_id = trans_flush->flush_id
        set->ops->flush(ctx->net, set, elem_priv);
        set->ndeact++;

        nft_setelem_data_deactivate(ctx->net, set, elem_priv);

        return 0;
}

On abort, NFT_MSG_FLUSHSET would do another walk, for all set elements,
and then calls nft_setelem_data_activate/nft_setelem_activate in case
elem_priv->flush_id == trans_flush->flush_id.

Did I get that right?  I don't see any major issues with this, except
the need to add u32 flush_id to struct nft_elem_priv.
Or perhaps struct nft_set_ext would be a better fit as nft_elem_priv is
just a proxy.

> Of course, this needs careful look, but if the set element can be used
> to annotate the information that allows us to restore to previous
> state before flush (given the transaction object is not used anymore),
> then it should work. Your series is extending the set element size for
> a different purpose, so I think the extra memory should not be an
> issue.

Agree, it would need 4 bytes per elem which isn't much compared to the
transaction log savings.

Will you have a look or should I have a go at this?
