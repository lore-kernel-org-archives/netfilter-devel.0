Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AC33148D3
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 05:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675491; cv=none; b=fHJwLz5H8nIehu3R3I6c+d50Nw7X+51KOaM+3gn8U3ms/xbK8p7sILzMLm3zXJFlWiAWUHvPxdNf3uu6olQT/Fprla1wYwVRTun+zLDZ+5NigGCktR8H+io5WlFSv0R0M6M4aCITLf39qMQt1MZl2AcvcoKV+HlnyBdQExT7SUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675491; c=relaxed/simple;
	bh=HuTcJiP4p/fK4S5EKthK6/znzF3DxzAcMSjQla4OkMo=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=nK2sw1l88OTsX/kVJ9AhBStVY8eA9THGzDAW8EqcrIfo289maBkvIXKSsCoz/cMwAKV4Mlh2oaUOlj999FMmXXzoCJk6xo1mKdnD8g9xefzfItELp9BEFZuy+ZjM5NiD4DZC1xzeHm8A2uAei94Nrj4whL8zig2Cxqjy7plAg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AVsRaStv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QC3Ebhir; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AVsRaStv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QC3Ebhir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781675488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4XP/tq8Y+jnLw3ONX2uWJzKqv2hODFa2ws9sWMtFMeo=;
	b=AVsRaStvOTdbnbEVVcly+KQ2+x1lqaDCiq6rCw/G5TFpyFuU0GRyjgroTJ+iwrI7mcC22n
	9uLQSoBPf+7hJJyJwBuSadlmUhGQ+GwNPKIirC2StBfblQmNbfYjulfwz6Q8IYcALBmbIL
	Wh2ftFnUhF48i4jghJikGeS+vKcStv4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-c6IyONDtO4SnL6Y5Jmo6eg-1; Wed, 17 Jun 2026 01:51:27 -0400
X-MC-Unique: c6IyONDtO4SnL6Y5Jmo6eg-1
X-Mimecast-MFC-AGG-ID: c6IyONDtO4SnL6Y5Jmo6eg_1781675486
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b37e1f48so36981245e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2026 22:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781675486; x=1782280286; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4XP/tq8Y+jnLw3ONX2uWJzKqv2hODFa2ws9sWMtFMeo=;
        b=QC3Ebhiri0WrvzYjgZnmXQmmkujZ93ELKzOv8XMI88cdWDl7zI0n3fFmZLs+0/FPZY
         DvzXxd/PWqG3z0cxRkeb96ORLBIbGtm1gx37oOCF05WSUItjQa+2oTrnREgRyQ99n0v0
         LC3Qblz3OZ4gROVtLRsRKc0VVNHzXqFM3pnpKImT6QearN8RCJAYS5t4axS4av6BBC7Q
         61HFUuI0y/SZZkYAXCLwfBjimOb73YvcWB/sJxtt+MiQjvlcNxdjR2SyuRqKuMQqRJt+
         12OeMH/9jrQjs4Tf/XdTF2e6m4gs0LcjyAo3BaIspbL2Ny0spuSpsFd7Y3AqvXpUijG/
         kJ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781675486; x=1782280286;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4XP/tq8Y+jnLw3ONX2uWJzKqv2hODFa2ws9sWMtFMeo=;
        b=DQUIvd5R5fA0uGE8/ip/0QUbFSXoO7hfU+62sQt9gp62BKLg2DNqmlecRMTUL6TMkd
         0DrvSzi4danzF0TZuKxqJ87XC0rd6E3wbgaZNXNeOOaPgxFgarR8vjq7SD7+XCjBUQsJ
         gJTSQEsUkQY0FeRB+uk1LUQZuEVssrtLZcfLhSsPNDKktIVh4YmyFG4w2fwts6/qr8VS
         Pa2+3dKEyyYu6gtIsi9KaL4pXwtIXMi6NyoR/LL8/Aow/y2HkEEEAhN5FpqY1SnTmqBd
         509JynuOyepOD3emoVgP+5y96XE9AmeWJ5lJf0Wg86wEI95rW6fp16MO+Zf5IevLEi68
         8VQQ==
X-Gm-Message-State: AOJu0YzYJJEYNnT/7rRjcCKELnjFU33m4kiUaLsXgKAz4K6hKSWZtX4t
	w4223Cu1YDM0Dgj4NVClWHnBe5Al5YmyRD4cOx67ZBYczqv/FKVW8VMfOkGsCrU9NTEeMNWD1pP
	vIEaXr7lzJHgmhRqixLmiARqY0JthTRMf5AQc+yaFjFO1ZpSQJFgCSrZQoerk5MxcD1zIMA==
X-Gm-Gg: Acq92OGNUFFIZzbkRQmrbvWbwmuqdjhwkBlJoIgVTVw8qrWoyLJSdnwu/GzHAJ3W9GE
	b8vK5ued0c3Nb8n80pR2DeGC1lEjh8eG6EwVaMHPzigpWrysOyskETwWzCl74riKSxUlcyBwjP1
	zb/hMgkM3+X8Fy6QHsHw+0lvcLi2152ctQbu21tEt9mYNhinl+OJN2ytWzil5jvRCx9fbnXhpp5
	g8RcicPuzThDidhjaqmM5GZhdVXxK3RtGuPxCMw0yorzwR66c7kJxugsQzyulhOYvzYiQlHAUPA
	DsX48csoe2nKFVGewhymLMaoQERuM+hK0L8/pUm0URsffbGNVUN7iwhMAdRi9TnoVTs9+kZs3nl
	Vt3uY87rtE6qgkfq1vnKWfg==
X-Received: by 2002:a05:600c:8287:b0:490:e1e6:cb69 with SMTP id 5b1f17b1804b1-492333ba388mr41679395e9.7.1781675486027;
        Tue, 16 Jun 2026 22:51:26 -0700 (PDT)
X-Received: by 2002:a05:600c:8287:b0:490:e1e6:cb69 with SMTP id 5b1f17b1804b1-492333ba388mr41678965e9.7.1781675485456;
        Tue, 16 Jun 2026 22:51:25 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a458f2sm123605575e9.3.2026.06.16.22.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 22:51:24 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>, Seesee <cjc000013@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: don't leak bad clone into
 future transaction
Message-ID: <20260617075123.7a62e22c@elisabeth>
In-Reply-To: <20260616191938.2875-1-fw@strlen.de>
References: <20260616191938.2875-1-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Jun 2026 07:51:24 +0200 (CEST)

On Tue, 16 Jun 2026 21:19:34 +0200
Florian Westphal <fw@strlen.de> wrote:

> On memory allocation failure the cloned nft_pipapo_match can enter a bad
> state:
>  - some fields can have their lookup tables resized while others did
>    not
>  - bits might have been toggled
>  - scratch map can be undersized which also means m->bsize_max can be
>    lower than what is required

If I understand it correctly, this is about pipapo_realloc_scratch()
failing to allocate memory for per-CPU scratch maps but
pipapo_maybe_clone() succeeding, right?

> This means that the next insertion in the same batch can trigger
> out-of-bounds writes.
> 
> Futhermore, a failure in the first can result in the bad clone to
> leak into the next transaction because the abort callback is never
> executed in this case (the upper layer saw an error and no attempt to
> allocate a transactional request was made).
> 
> Record a state for the nft_pipapo_match structure:
> - NEW (pristine clone)
> - MOD (modified clone with good state)
> - ERR (potentially bogus content)
> 
> Then make it so that deletes and insertions fail when the clone
> entered ERR state.
> 
> In case the very first insert attempt results in an error, free the
> clone right away.

I don't see anything wrong with this approach, but I guess there might
be a more obvious alternative, even though I didn't really think this
through: undo what we did in nft_pipapo_insert() up to that point
(perhaps calling nft_pipapo_delete() with a particular argument).

I can try to get to this in the next few days (I would have some ideas
about testing, see below), but I suppose we want a fix quickly if that's
really the case so I'm actually fine with this, with one nit, also
reported below.

> Reported-by: Seesee <cjc000013@gmail.com>
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

> ---
>  For some reason reporter did not share a PoC despite claiming
>  there is one, so I have no fucking clue if this patch
>  is correct or not, its based on guesswork without
>  any validation.

Maybe we could run test scripts against a modified version of
pipapo_realloc_scratch() returning -ENOMEM every 20th time or so?

>  net/netfilter/nft_set_pipapo.c | 34 +++++++++++++++++++++++++++++-----
>  net/netfilter/nft_set_pipapo.h |  8 ++++++++
>  2 files changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 50d4a4f04309..61b8601ee377 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -342,6 +342,8 @@
>  #include "nft_set_pipapo_avx2.h"
>  #include "nft_set_pipapo.h"
>  
> +static void nft_pipapo_abort(const struct nft_set *set);
> +
>  /**
>   * pipapo_refill() - For each set bit, set bits from selected mapping table item
>   * @map:	Bitmap to be scanned for set bits
> @@ -1296,7 +1298,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  	const u8 *start_p, *end_p;
>  	int i, bsize_max, err = 0;
>  
> -	if (!m)
> +	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
>  		return -ENOMEM;
>  
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
> @@ -1367,8 +1369,10 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  		else
>  			ret = pipapo_expand(f, start, end, f->groups * f->bb);
>  
> -		if (ret < 0)
> -			return ret;
> +		if (ret < 0) {
> +			err = ret;
> +			goto abort;
> +		}
>  
>  		if (f->bsize > bsize_max)
>  			bsize_max = f->bsize;
> @@ -1384,7 +1388,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  
>  		err = pipapo_realloc_scratch(m, bsize_max);
>  		if (err)
> -			return err;
> +			goto abort;
>  
>  		m->bsize_max = bsize_max;
>  	} else {
> @@ -1396,7 +1400,26 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  
>  	pipapo_map(m, rulemap, e);
>  
> +	m->state = NFT_PIPAPO_CLONE_MOD;
>  	return 0;
> +abort:
> +	DEBUG_NET_WARN_ON_ONCE(m->state == NFT_PIPAPO_CLONE_ERR);
> +
> +	/* Two rollback cases:
> +	 * 1) no previous changes.  nft_pipapo_abort is not
> +	 * guaranteed to be invoked (there might be no further
> +	 * add/delete requests coming after this).
> +	 *
> +	 * 2) we had previous changes: there are transaction
> +	 * records pointing to this set.  Leave the rollback to
> +	 * the transaction handling.
> +	 */
> +	if (m->state == NFT_PIPAPO_CLONE_NEW)
> +		nft_pipapo_abort(set); /* releases m */
> +	else
> +		m->state = NFT_PIPAPO_CLONE_ERR;
> +
> +	return err;
>  }
>  
>  /**
> @@ -1473,6 +1496,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
>  		dst++;
>  	}
>  
> +	new->state = NFT_PIPAPO_CLONE_NEW;
>  	return new;
>  
>  out_mt:
> @@ -1896,7 +1920,7 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
>  	/* removal must occur on priv->clone, if we are low on memory
>  	 * we have no choice and must fail the removal request.
>  	 */
> -	if (!m)
> +	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
>  		return NULL;
>  
>  	e = pipapo_get(m, (const u8 *)elem->key.val.data,
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
> index b82abb03576e..a19e980d06ef 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -131,9 +131,16 @@ struct nft_pipapo_scratch {
>  	unsigned long __map[];
>  };
>  
> +enum nft_pipapo_clone_state {

Nit: if would be nice to have the canonical:

/**
 * enum nft_pipapo_clone_state - Validity states for clones of matching data
 * @NFT_PIPAPO_CLONE_NEW	Pristine clone of currently active data
 * @NFT_PIPAPO_CLONE_MOD	Modified clone (insertion or deletions), valid
 * @NFT_PIPAPO_CLONE_ERR	Some operations failed, invalid state, don't use
 */

> +	NFT_PIPAPO_CLONE_NEW,
> +	NFT_PIPAPO_CLONE_MOD,
> +	NFT_PIPAPO_CLONE_ERR,
> +};
> +
>  /**
>   * struct nft_pipapo_match - Data used for lookup and matching
>   * @field_count:	Amount of fields in set
> + * @state:		add/delete state; used from control plane
>   * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
>   * @scratch:		Preallocated per-CPU maps for partial matching results
>   * @rcu:		Matching data is swapped on commits
> @@ -141,6 +148,7 @@ struct nft_pipapo_scratch {
>   */
>  struct nft_pipapo_match {
>  	u8 field_count;
> +	enum nft_pipapo_clone_state state:8;
>  	unsigned int bsize_max;
>  	struct nft_pipapo_scratch * __percpu *scratch;
>  	struct rcu_head rcu;

-- 
Stefano

