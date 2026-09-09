Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC157980C;
	Wed,  9 Sep 2026 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788965122; cv=none; b=c7O5R7a8UowgLDf4EzeRP2J3tKYE1icvfG9i5Gw9cyg+V4YtmYWNgAQzXHi9/4kJX7icFX9CTHEYNS/n0DY945plvSGfOyDYXAOvaInh7LRts8J10iYNjn9LPdGeOHWIi9W5FsHG8yTy8Llm73Ncj4i+hojvA6Yi9eCK2k7UJs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788965122; c=relaxed/simple;
	bh=UFoL6UC3db89fJq33Fqm8coBBuyDpiQnfNW31ywfCLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwx738teQkMP8ptsxcs3buVX94LauGzvq8uCieeY6NPDVojrQKQ/AVD/xLhFQlAEnMFI8ydeidyfOSS7qHUtOeGcgmMJ+dE5Ii8BZjXQx/FvgnFEN74wnB2l3L621ZwBUUZdwMZ4F5sIK5snopXsIm1KpQONJm5tADyQsTP1Q9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 97A026036C; Wed, 09 Sep 2026 16:45:16 +0200 (CEST)
Date: Wed, 9 Sep 2026 16:45:15 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqFw-_Y4JGRF-0Za@strlen.de>
References: <20260904185321.30313-2-fw@strlen.de>
 <aqDdwKMbvd9aErLy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqDdwKMbvd9aErLy@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> >
> > +void rhashtable_flush_and_free(struct rhashtable *ht,
> > +                              void (*free_fn)(void *ptr, void *arg),
> > +                              void *arg)
> > +{
> > +       struct bucket_table *tbl, *old_tbl, *last_tbl, *new_tbl;
> > +       struct rhashtable_walker *walker;
> > +       unsigned int i;
> > +
> > +       new_tbl = bucket_table_alloc(ht, rounded_hashtable_size(&ht->p),
> > +                                    GFP_KERNEL);
> > +       if (!new_tbl)
> > +               new_tbl = bucket_table_alloc(ht, ht->p.min_size,
> > +                                            GFP_KERNEL | __GFP_NOFAIL);
> > +
> > +       mutex_lock(&ht->mutex);
> 
> Before starting the work you need to stop all existing rehashes.
> 
> This is where it helps if you impose restrictions on the caller.
> For example, if you could guarantee that no insertions or removals
> occur during the call to rhashtable_flush_and_free (the duration of
> the call does not include the actual freeing, which can occur later),
> then it's much easier since you could just call cancel_work_sync on
> the rehashes.
> 
> If you can't guarantee that, then we'll need some sort of a flag to
> stop the rehashes manually.

Hmm. why?  AFAICS the rehash worker holds ht->mutex, i.e. a rehash
might be pending, but it cannot run in parallel.

We called 'rcu_assign_pointer(ht->tbl, new_tbl);' before unlocking the
mutex, so a pending work (resize or rehash) will only see elements
that have been added right after that point.

Am I misreading anything here?

> > +       /* Splice the new, empty table onto the tail of the live table ... */
> > +       old_tbl = rht_dereference(ht->tbl, ht);
> > +       do {
> > +               last_tbl = rhashtable_last_table(ht, old_tbl);
> > +       } while (rhashtable_rehash_attach(ht, last_tbl, new_tbl));
> 
> This loop is only needed if you impose no restrictions on the caller.

Yes, no restrictions are imposed on the caller, at least thats the idea.

> In fact I think this could become a lot simpler since the two
> tables don't need to mix at all.
> 
> Just add an old_tbl field to struct rhashtable, then move the
> old table into it and directly write the new table to tbl.  That
> way none of the complications from overlapping insertions matter
> anymore.

Hmm. What do you think of this version?

+void rhashtable_flush_and_free(struct rhashtable *ht,
+                              void (*free_fn)(void *ptr, void *arg),
+                              void *arg)
+{
+       struct bucket_table *tbl, *old_tbl, *new_tbl;
+
+       new_tbl = bucket_table_alloc(ht, rounded_hashtable_size(&ht->p),
+                                    GFP_KERNEL);
+       if (!new_tbl)
+               new_tbl = bucket_table_alloc(ht, ht->p.min_size,
+                                            GFP_KERNEL | __GFP_NOFAIL);
+
+       /* Make sure we won't race with rhashtable_rehash_table() */
+       mutex_lock(&ht->mutex);
+       old_tbl = rcu_replace_pointer(ht->tbl, new_tbl, lockdep_rht_mutex_is_held(ht));
+       mutex_unlock(&ht->mutex);
+
+       /* Make sure all other CPUs no longer access the old table */
+       synchronize_rcu();

Rest as before.  This way, we don't need to worry about concurrency,
no readers or writers can reach old_tbl anymore.

I'll give this a try.
