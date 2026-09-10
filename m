Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753E43C3BFC;
	Thu, 10 Sep 2026 09:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031505; cv=none; b=AOVHxchzo03ln7WGxXf7WUKzIrtavHFTumceKNWnsblAyyZnQTRbLCpk/LqjkPzWfUf5gEtrLlvBaHvtaKd3in3nHzQKlAPtBikupez5ckrjQo9g3orWKe4fOysbQ1g0w5yua4KIxafH8nBoYq4w26/XdC1yRkeC/rmZSrNncp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031505; c=relaxed/simple;
	bh=CFDaYu4+6et43fxtI1NK/1c4YQi65YsxPz/uHHyPJus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUqOOlKFE6nhQMA+Y4sIjYg2YvVRKQrWGWegrCfzp/QjARwSFWcNc8N1tGePevrKZxaENFld+W/+iDybTadYqG7RBBDTJeiuahY0kmYXUgB32xjx3++IcBB9JttSkN98GtsSKL0LEraBbjNemS6DDAtW2C2fBNMbJBVVBb5LIUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bN6O4D50; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bN6O4D50"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=VbjprH9AKZ8VdMwivsRpOX4zizjj4xMOL4WXqru46yY=; 
	b=bN6O4D50175gmNsvCW31AuOY5wcMzYK9o8o3LSiaTRKSOERB2BiS7cTM2i3D3JD3yiu/NIImKBy
	or2tTERAqWTD/KIa2zCaVFfve4gfsRfj3QFB7hmF+cl3w9m8j5PQvS6XD6vucmbDjQRgiV46B4DSS
	2g4huZOwvoKsG3JeN3ooXejATexm8B0aheT0CkPGhgICJak2wYqcMQa+WKM8Q25MRMl96xcBJgmZx
	5zLMxXGbCMnVRSmG9Tmg4t7xEwvjP+yOM2YYdNnLYnou9RMEB3Ri005kYW6HmCVAZm96FQmYjAX7l
	B9iXSe1308Wgd+j/F1ATQ7l8fC1MFWzgByqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4aoa-0000000CZhE-3zDV;
	Thu, 10 Sep 2026 17:11:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Sep 2026 19:11:28 +1000
Date: Thu, 10 Sep 2026 19:11:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqJ0QDwEIZg5sDql@gondor.apana.org.au>
References: <20260904185321.30313-2-fw@strlen.de>
 <aqDdwKMbvd9aErLy@gondor.apana.org.au>
 <aqFw-_Y4JGRF-0Za@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqFw-_Y4JGRF-0Za@strlen.de>

On Wed, Sep 09, 2026 at 04:45:15PM +0200, Florian Westphal wrote:
>
> Hmm. why?  AFAICS the rehash worker holds ht->mutex, i.e. a rehash
> might be pending, but it cannot run in parallel.

Because you're chaining the new table onto the end of the old table
in the original patch.  So a rehash could start moving entries
from the old table into the new table.

In fact it's still a problem if you set ht->tbl atomically, because
we need to differentiate between rehashes triggered by an insert
or remove that occurred on the old ht->tbl versus one that occured
on the new ht->tbl.

Since there is just one work struct it's impossible to tell the
difference.
 
> Hmm. What do you think of this version?
> 
> +void rhashtable_flush_and_free(struct rhashtable *ht,
> +                              void (*free_fn)(void *ptr, void *arg),
> +                              void *arg)
> +{
> +       struct bucket_table *tbl, *old_tbl, *new_tbl;
> +
> +       new_tbl = bucket_table_alloc(ht, rounded_hashtable_size(&ht->p),
> +                                    GFP_KERNEL);
> +       if (!new_tbl)
> +               new_tbl = bucket_table_alloc(ht, ht->p.min_size,
> +                                            GFP_KERNEL | __GFP_NOFAIL);
> +
> +       /* Make sure we won't race with rhashtable_rehash_table() */
> +       mutex_lock(&ht->mutex);
> +       old_tbl = rcu_replace_pointer(ht->tbl, new_tbl, lockdep_rht_mutex_is_held(ht));
> +       mutex_unlock(&ht->mutex);
> +
> +       /* Make sure all other CPUs no longer access the old table */
> +       synchronize_rcu();
> 
> Rest as before.  This way, we don't need to worry about concurrency,
> no readers or writers can reach old_tbl anymore.

Yes I think this should work.  But rehashes are still tricky if we allow
the caller to do insertions/removals during the flush operation.

It would be a lot simpler if you added the restriction that the
caller must not call insert/remove before the flush call returned.
Otherwise we would need to add a lot of complexity to rhashtable
in order to distinguish between insertions/removals on the table
before or after the flush.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
