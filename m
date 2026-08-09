Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99243C4577
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 11:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786275006; cv=none; b=ZWfW5mZFX2PLsRU5iMTq4JfnUTY0WiYQfULTo1U4UKD9SD5blZaozWwyeQ3nwurf0nWr6kOZXQomBujYptcaAjwCdDQI2ctbeaBe7taDJek5edZK+Y+lmuvPi+G5k/O64pmF3kd17GQAa5aCHxdR8QRgyeLzrnI8Yh5am81mRZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786275006; c=relaxed/simple;
	bh=79OjYAgf5nXOtFO8jItqwyBDFVKvRdQEz14ELKNChxw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lSYIKTQe5F5R3BKtVcvGRkdEuQjCAKwJgf8DOdwkqIMKy4FFiOe3p8PPHiktJ+2oSiExDqzFfTEY4c9nLVA6du+wLpvUW6uzrcgpvUmvigaZpq/sgsZVbEXj6LDrVXLlM7ooIF7MROyv+3l769xwn9sZxdNUb4kkuCDL+yOb5Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4hHwRR3dHcz3sb0S;
	Sun, 09 Aug 2026 13:20:35 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id IG0ypVnKAz0e; Sun,  9 Aug 2026 13:20:33 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (78-131-74-220.pool.digikabel.hu [78.131.74.220])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4hHwRP3l4Zz3sb0R;
	Sun, 09 Aug 2026 13:20:33 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 39F79140E07; Sun,  9 Aug 2026 13:20:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 36C1B14015A;
	Sun,  9 Aug 2026 13:20:33 +0200 (CEST)
Date: Sun, 9 Aug 2026 13:20:33 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: let destroy callbacks adjust ext
 mem size
In-Reply-To: <20260804170228.27262-1-fw@strlen.de>
Message-ID: <bd594feb-8728-6c2a-df17-deddbe222cea@netfilter.org>
References: <20260804170228.27262-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%

Hi Florian,

On Tue, 4 Aug 2026, Florian Westphal wrote:

> For bitmap this change makes no difference, because destructors are
> called synchronously.
> 
> sashiko pointed out list type destruction is partially done via call_rcu:
> mem accounting could be subtracting after list_set_flush() did reset the
> value to 0.  set->elements assignment can be removed for the same reason,
> this already walks the entire set and does 'set->elements--' for each
> entry synchronously.

Yes, I agree, about set->elements too. And one DEBUG_NET_WARN_ON_ONCE() is 
enough and it should catch any problem in list_set_del() about element 
number or extension size.
 
> Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Won't apply, this assumes the pending nf PR is applied.
>  In case that PR is rejected, this patch could be
>  reworked to logically come before the atomic64 conversion,
>  but it doesn't buy mutch.
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
> index ca3ef9479e83..024de3bc9fc3 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -420,8 +420,7 @@ list_set_flush(struct ip_set *set)
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

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
