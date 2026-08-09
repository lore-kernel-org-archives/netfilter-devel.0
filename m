Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969AA23D7FF
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786280354; cv=none; b=O4JhuNkKTUYGmvSPJMWkDafAWB43/DTEf1KQ1tnZqwkJ67P3BJRPMD24QyNz6aTy0PoFQDxFcOhOyD5B5+xuDCUVzSnl+VZEEgfbC8ZrTVeoz+lJyfDiQwMTNqude4vrVxEo6VxLHgEElNtdGxSc9z5lubkGGGj/gvaKyj+P+KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786280354; c=relaxed/simple;
	bh=awgruIrpBHtLVmE7JyFGWI7hjfd1dsSgJ/4Sna7YmEY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LyNUHth6kt+PbcsqIhX3Z8MqhtE1PsgSFqLhjBeu3WyV62c6WdIuETgdD1inx/wd7wqf0xZUIAEYO8+Pdyp3J4p+1Kwmisj/H+Hzoac1dup5i7xFksiDJtD6aRUm8JW5RwZxHg/nq23fcl0p70nuMbfzZc2e/97Zi6ClXFEYQU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4hHyd95Vs9z3sb0R;
	Sun, 09 Aug 2026 14:59:09 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id FF9cyztIH_Bz; Sun,  9 Aug 2026 14:59:07 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (78-131-74-220.pool.digikabel.hu [78.131.74.220])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4hHyd75dstz3sb0L;
	Sun, 09 Aug 2026 14:59:07 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 9930A140E07; Sun,  9 Aug 2026 14:59:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 95C5C140986;
	Sun,  9 Aug 2026 14:59:07 +0200 (CEST)
Date: Sun, 9 Aug 2026 14:59:07 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: let destroy callbacks adjust ext
 mem size
In-Reply-To: <20260806141750.10441-1-fw@strlen.de>
Message-ID: <e47c438b-617b-63c1-fd4d-fb1321601db9@netfilter.org>
References: <20260806141750.10441-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 1%

On Thu, 6 Aug 2026, Florian Westphal wrote:

> For bitmap this change makes no difference, because destructors are
> called synchronously.
> 
> List type however calls them via call_rcu() so accounting decrement can
> happen after list_set_flush() set ext_size to 0.
> 
> 'set->elements = 0' can be removed for the same reason in the list type
> case, it calls 'set->elements--' for each element.
> 
> Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
> Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
> ---
>  sashiko: list_set_uadd() may call list_set_replace() and
>  then erronously increments set->elements, causing a counter
>  drift. This bug will be resolved in a different patch.
> 
>  net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
>  net/netfilter/ipset/ip_set_list_set.c   | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
> index 226fdf17b683..d6a7e6604542 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_gen.h
> +++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
> @@ -77,7 +77,7 @@ mtype_flush(struct ip_set *set)
>  		mtype_ext_cleanup(set);
>  	bitmap_zero(map->members, map->elements);
>  	set->elements = 0;
> -	atomic64_set(&set->ext_size, 0);
> +	DEBUG_NET_WARN_ON_ONCE(atomic64_read(&set->ext_size) > 0);
>  }
>  
>  /* Calculate the actual memory size of the set data */
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> index 56626f4943a9..b4967a9d82b0 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -423,8 +423,7 @@ list_set_flush(struct ip_set *set)
>  
>  	list_for_each_entry_safe(e, n, &map->members, list)
>  		list_set_del(set, e);
> -	set->elements = 0;
> -	atomic64_set(&set->ext_size, 0);
> +	DEBUG_NET_WARN_ON_ONCE(set->elements > 0);
>  }
>  
>  static void
> -- 
> 2.54.0
> 
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
