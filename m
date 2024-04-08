Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9495A1411EF
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591145; cv=none; b=vFR1zaT9ZR4t9SLLDIZGC2zvJsvIer1StUots2F/8ycqzP2f6fO4ZIGP6Dsd1gXXeWNeKUZLG+vumcbROiqUeEc1zW049p6tqDHfkbRaleUIWBle1H2D6clRAwL3pG2wckKbaEFztdY1sgXbxmxvyIotNKsghdydc6+OiNYdW3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591145; c=relaxed/simple;
	bh=P3t0bltrDhUazrFiWGo/4OgNrJl8pqZxHIZQTXT21k4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwwF2HMiuESRYkiH9BiupLmm3AthIBXcvVyZtcHiKUW5MeKJZYntMGPkaLF7z1e8dfo4n+3gAwExjhcl+eRY5yE3CYuBYTk/+hA+wOLo2zvljXr+rh8txNVFmyS8QvzySz8Smbkr6goBN/4tBBEJ/8vTHH9owgg6ictV1mlhen8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bYQ4tRof; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYQ4tRof"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712591142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQrWAUUZILKoyTcZmhXIl+dSIxG2wDs6zNu2FsX1mbk=;
	b=bYQ4tRofeY4UaMA/LKkJfvH5Lscw5SozhLC/HlDJdFxviB1iggPVRRpVF/O7+Drp3SzFcm
	rYL67+iQgrWh5uTs6l6GQonrbK1BMRi6Q6Fv+yYIMPJ9L8ZF3X2+PGKpVjitLrm/YuYqft
	M8bViFr51ZzKk9GKpvfknPIFW8pDAjo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-VYvBGb0NM6-KmEXmxX2QWw-1; Mon, 08 Apr 2024 11:45:41 -0400
X-MC-Unique: VYvBGb0NM6-KmEXmxX2QWw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a51abd0d7c6so212765466b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2024 08:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712591140; x=1713195940;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oQrWAUUZILKoyTcZmhXIl+dSIxG2wDs6zNu2FsX1mbk=;
        b=NesbL9IFdnT6mNO4XULXHYMBcJkPM41g7qC50pce7GN5DQqSCC/5Vnp2eOJf0se+tu
         11AHaO8246oPJDEF2MituaA7BQsY/Dc/Io/jgl9Rjzx6occeneAI5GVyd4BQLS4LVId3
         mKR/4uaSY3k1J9DZM1zaLBFDTUX1ndye1m4KDQXrnJiS3Ig9ctqvpkcTzPP/r79/+4ai
         2+jexNkXii9a7mKfbP9a/xFN400fvm0WPJkeGZZaM9h/Bhk29SoEbqE0J2fUXlXolS7T
         S2tEuGvIqElT4gVJuqUKIcCzW2aSAwp+A2LGjoB+m/ACrLcN/17+fDhh5iubCqqD5kDJ
         PqeA==
X-Gm-Message-State: AOJu0YzqiBQnBvnskqQrdhC/8rfWYV+5cCzkFh/9G8X5Euuq9V0B+N59
	1TepVBIw+yVw1kTGgQWkJFfD4G/+mdZ3GgRAt9rU885mVuzTJGIV1+JF8wUDZ/y7Vh3/c4Q1ZuV
	s8VyHpKHcec6vau6nozVrM5e0els3iLZSoX+w2Kp78PfQQ2BqMopYXLNtkhkWRM+Z/Q==
X-Received: by 2002:a17:907:3ea6:b0:a51:b383:f587 with SMTP id hs38-20020a1709073ea600b00a51b383f587mr5678956ejc.15.1712591139721;
        Mon, 08 Apr 2024 08:45:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6ACsqb9eJjk7FkAM047Ofy4sno7wLrJWbS3CKa0B0JpRwTa2isTGSWPRM+XP6YaWOVPm3Bw==
X-Received: by 2002:a17:907:3ea6:b0:a51:b383:f587 with SMTP id hs38-20020a1709073ea600b00a51b383f587mr5678928ejc.15.1712591139048;
        Mon, 08 Apr 2024 08:45:39 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id k14-20020a1709063fce00b00a4e8a47107asm4535956ejj.200.2024.04.08.08.45.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2024 08:45:38 -0700 (PDT)
Date: Mon, 8 Apr 2024 17:45:03 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 3/9] netfilter: nft_set_pipapo: prepare destroy
 function for on-demand clone
Message-ID: <20240408174503.0792a92e@elisabeth>
In-Reply-To: <20240403084113.18823-4-fw@strlen.de>
References: <20240403084113.18823-1-fw@strlen.de>
	<20240403084113.18823-4-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  3 Apr 2024 10:41:03 +0200
Florian Westphal <fw@strlen.de> wrote:

> Once priv->clone can be NULL in case no insertions/removals occurred
> in the last transaction we need to drop set elements from priv->match
> if priv->clone is NULL.
> 
> While at it, condense this function by reusing the pipapo_free_match
> helper instead of open-coded version.
> 
> The rcu_barrier() is removed, its not needed: old call_rcu instances
> for pipapo_reclaim_match do not access struct nft_set.

True, pipapo_reclaim_match() won't, but nft_set_pipapo_match_destroy()
will, right? That is:

> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 27 ++++++---------------------
>  1 file changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 48d5600f8836..d2ac2d5560e4 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -2323,33 +2323,18 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct nft_pipapo_match *m;
> -	int cpu;
>  
>  	m = rcu_dereference_protected(priv->match, true);
> -	if (m) {
> -		rcu_barrier();

...before b0e256f3dd2b ("netfilter: nft_set_pipapo: release elements in
clone only from destroy path"), this rcu_barrier() was needed because we'd
call nft_set_pipapo_match_destroy() on 'm'.

That call is now gone, and we could have dropped it at that point, but:

> -
> -		for_each_possible_cpu(cpu)
> -			pipapo_free_scratch(m, cpu);
> -		free_percpu(m->scratch);
> -		pipapo_free_fields(m);
> -		kfree(m);
> -		priv->match = NULL;
> -	}
>  
>  	if (priv->clone) {
> -		m = priv->clone;
> -
> -		nft_set_pipapo_match_destroy(ctx, set, m);
> -
> -		for_each_possible_cpu(cpu)
> -			pipapo_free_scratch(priv->clone, cpu);
> -		free_percpu(priv->clone->scratch);
> -
> -		pipapo_free_fields(priv->clone);
> -		kfree(priv->clone);
> +		nft_set_pipapo_match_destroy(ctx, set, priv->clone);
> +		pipapo_free_match(priv->clone);
>  		priv->clone = NULL;
> +	} else {
> +		nft_set_pipapo_match_destroy(ctx, set, m);

now it's back, so we should actually move rcu_barrier() before this
call? I think it's needed because nft_set_pipapo_match_destroy() does
access nft_set data.

>  	}
> +
> +	pipapo_free_match(m);
>  }
>  
>  /**

-- 
Stefano

