Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F03233956;
	Wed,  9 Sep 2026 04:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788927433; cv=none; b=NcQIZeLlVVo8b54ZXe/ijGc7yqMbLz3Bk/8c0gWb+9hNr3cbwwsbqtluduZxtRaadS7PNreefx1QpfkNZn76yjen5niO8yrHXDouJnqNDc5F8lj7xQ4KP6DspdhQx86frxHaZaD4osPU8vq+dG9nbNUgVIRqlI+LDYobngH+BAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788927433; c=relaxed/simple;
	bh=bGs4Y4knPDmO1nXjVQ5ybGA0Nqi1ee5tzdcqakm0VHU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=BNYDit5zEKA3maSXRypXXkJj9P5kC94IxJskIlDTuzyXKWonYPpPYqnUnpFatsi2ES9fgbAHc3frTqgnQbmMCKWu2H2L+l/gLnKb3YY1qflFvwf+VuroEOtVMTVCAO9C8Fqzj7/KB7ZhvVAXtwhEdKObz4YqYoYO7NQ0e9kQ3aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eGTliDBC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eGTliDBC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=OXhqcdI0P8/u9DXixJVjUQyk5kYiT9r16XQzUG2qi6E=; b=eGTliDBCQdQyvkf0s9Wc0ByAVL
	afb/lqvfZIjpzQN+EtOBTH0HQzqV+5z9MJ6Dmxnc8Kgd4KTFvnxxgfsHX9OE7Wn12dao9Nrv+rRr5
	xu0Q8IPcYbbJ7tuYVzuKtpY+JN8Eg8CWtDiFFX9CP2L85MC7zTqbTa6yIwCB3RF/TmuH+Ig2Kes3Q
	i5V12CyxUtYYTllb7NiWn8GvryGcM6MMxFuvvpa/Lt6Ne1ln3A3UlHQ5hZO1sdjkyxeTjl+AwnStt
	ovqoEsSr/QgtUxQyvBQJiFbDYmjGHMPWsNmSrnRQ/uxFjwRxZmK0vuI8HGhG/EXtcuVrP9icOP4KF
	Qda5yT7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x49k8-0000000C7rs-351f;
	Wed, 09 Sep 2026 12:17:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Sep 2026 14:17:04 +1000
Date: Wed, 9 Sep 2026 14:17:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqDdwKMbvd9aErLy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904185321.30313-2-fw@strlen.de>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.netfilter.devel

Florian Westphal <fw@strlen.de> wrote:
>
> +void rhashtable_flush_and_free(struct rhashtable *ht,
> +                              void (*free_fn)(void *ptr, void *arg),
> +                              void *arg)
> +{
> +       struct bucket_table *tbl, *old_tbl, *last_tbl, *new_tbl;
> +       struct rhashtable_walker *walker;
> +       unsigned int i;
> +
> +       new_tbl = bucket_table_alloc(ht, rounded_hashtable_size(&ht->p),
> +                                    GFP_KERNEL);
> +       if (!new_tbl)
> +               new_tbl = bucket_table_alloc(ht, ht->p.min_size,
> +                                            GFP_KERNEL | __GFP_NOFAIL);
> +
> +       mutex_lock(&ht->mutex);

Before starting the work you need to stop all existing rehashes.

This is where it helps if you impose restrictions on the caller.
For example, if you could guarantee that no insertions or removals
occur during the call to rhashtable_flush_and_free (the duration of
the call does not include the actual freeing, which can occur later),
then it's much easier since you could just call cancel_work_sync on
the rehashes.

If you can't guarantee that, then we'll need some sort of a flag to
stop the rehashes manually.

> +       /* Splice the new, empty table onto the tail of the live table ... */
> +       old_tbl = rht_dereference(ht->tbl, ht);
> +       do {
> +               last_tbl = rhashtable_last_table(ht, old_tbl);
> +       } while (rhashtable_rehash_attach(ht, last_tbl, new_tbl));

This loop is only needed if you impose no restrictions on the caller.
And if we're going to do this, then you'd need to fix the logic in
rhashtable_insert_rehash as otherwise it may interpret this as a
rehash (as opposed to a resize) which could fail with EBUSY.

In fact I think this could become a lot simpler since the two
tables don't need to mix at all.

Just add an old_tbl field to struct rhashtable, then move the
old table into it and directly write the new table to tbl.  That
way none of the complications from overlapping insertions matter
anymore.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
