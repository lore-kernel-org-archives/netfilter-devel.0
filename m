Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F273840FDAD;
	Thu, 10 Sep 2026 10:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036893; cv=none; b=d0qXhBlS8h5vUGFfF/gaVvACS5GrVJrFirf3P6U1qamuh4JVhrS8W6d8HZhfBXD0aRFo3UA/albWrVIuILACeJob7fDy1jo0+zAj1F66ZiGJl/UZ7YpdFkaB/OZ9SW54beGaFtUgX0Fba8/mpKpF3l6EXtqaC6Yue5U9p5vZmhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036893; c=relaxed/simple;
	bh=HXgQPBDdfs3D+UBfEDBPgbT46i6XV1A9nXCBJFZwSVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4ELT+2MD1USVk6B6WgUp/rH1cGpgf7PKJss2MRQH+Lypf+VOnmwF2symzgChVAZc+MCmRRqwIWGiyyf8P3yy58TxYLRe/XxvGfT7dCci/tYNy3F77YxV2KguMr+Ahat7MliVEs3GE4iT39ItxXvNGDojrppOjDL+n09hMC49B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3753B60380; Thu, 10 Sep 2026 12:41:28 +0200 (CEST)
Date: Thu, 10 Sep 2026 12:41:27 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqKJUOQYHEGWKgCn@strlen.de>
References: <20260904185321.30313-2-fw@strlen.de>
 <aqDdwKMbvd9aErLy@gondor.apana.org.au>
 <aqFw-_Y4JGRF-0Za@strlen.de>
 <aqJ0QDwEIZg5sDql@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqJ0QDwEIZg5sDql@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > +void rhashtable_flush_and_free(struct rhashtable *ht,
> > +                              void (*free_fn)(void *ptr, void *arg),
> > +                              void *arg)
> > +{
> > +       struct bucket_table *tbl, *old_tbl, *new_tbl;
> > +
> > +       new_tbl = bucket_table_alloc(ht, rounded_hashtable_size(&ht->p),
> > +                                    GFP_KERNEL);
> > +       if (!new_tbl)
> > +               new_tbl = bucket_table_alloc(ht, ht->p.min_size,
> > +                                            GFP_KERNEL | __GFP_NOFAIL);
> > +
> > +       /* Make sure we won't race with rhashtable_rehash_table() */
> > +       mutex_lock(&ht->mutex);
> > +       old_tbl = rcu_replace_pointer(ht->tbl, new_tbl, lockdep_rht_mutex_is_held(ht));
> > +       mutex_unlock(&ht->mutex);
> > +
> > +       /* Make sure all other CPUs no longer access the old table */
> > +       synchronize_rcu();
> > 
> > Rest as before.  This way, we don't need to worry about concurrency,
> > no readers or writers can reach old_tbl anymore.
> 
> Yes I think this should work.  But rehashes are still tricky if we allow
> the caller to do insertions/removals during the flush operation.

What problems do you see?  Shouldn't a rehash be a no-op, since it
can't see anything in the hashtable once the flusher releases the
mutex post replace_pointer() call?

If a rehash is in progress, the flusher will block on ht->mutex.

Same for removals, no entries will be found, insertions are ok too as they
add to the new backing store.

> It would be a lot simpler if you added the restriction that the
> caller must not call insert/remove before the flush call returned.

How to assert that?  Or should that be an 'external' requirement?

That will, at least afaics, defeat rhashtables purpose, I'd have to
either serialize by external single lock, or add a flag that would
'eat' new insertions while the flush is running.

I could do the latter, if that helps, but I don't see why its
needed with the proposed 'replace, then synchronize_rcu()'.

> Otherwise we would need to add a lot of complexity to rhashtable
> in order to distinguish between insertions/removals on the table
> before or after the flush.

I would like to avoid extra complexity or even new tests in insert/removal
fast paths.

Thanks for reviewing!
