Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C588B311C35
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114132; cv=none; b=lixu5A7jCBEtB2WoTjvV6i0X+fswpPycydRYmffFMvM4db6yEOqYyn3MwHEWvS7DOTco7GvwhCisH6wH6pDLEDtG1dTBPWndLvr0L27rUgppEYxLBTqsiMzmz/C7000s0DtP34imyNFwxp87meIa/9XOJKhsYwB+3qEHExHz/CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114132; c=relaxed/simple;
	bh=gSixFFclTUS7ckGyJ6STwjNMBKoWCtWW79rUv1GMZXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZPPoAd4CZpPooK5Y+dGzTJZw3udv2MiN7fXO2hu419ZyNbAenTo7B6d9BpvnUztwIb/Q0Ng0tu4gcwOK6pUV48FWzd2yOwURno9Ofr0OtvXs2hzJeViDC3D3EyWMGeWvy0Ltx6S3ie10zbTJJrorkTmAkza++lKEOQQ772FAj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8jIZ2II; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8jIZ2II"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48e82c23840so17931515e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 07:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779114127; x=1779718927; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Oumtl4pXAJKEcGCQwup2CrdSSym8HzjHOOsWboStNg=;
        b=j8jIZ2IIsuxpWQ870MzemgZoBPQSu+i0AsYHIMBek6XI8VfiwGpMeweG1s/U8Jeu/w
         bswnS4SxwRZ3/lbWH9xBJjHltNY9EkfI5DralRIibUZnRVZ/4WwV1QIZvzkwXD/kHxMt
         ioVikITIBBqL258ANDW7aVQoeDB66sftmIZafvjqz24jKTK/JYEQ6zZde8o2bRiyDCxT
         rtHsfOuGmP1XEgBVa+Sz5DJRUsgnGltCUSaPvIAludNRAsDpwRPtejaUSTIn15MgacFs
         cxss4wlpunyxk0AeZfM4jJqmc54spg3y3y/hw70xkQA1ZJwHrz5GnqNTVsl1ogcwx5yd
         g2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779114127; x=1779718927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Oumtl4pXAJKEcGCQwup2CrdSSym8HzjHOOsWboStNg=;
        b=eZ1UA/6lTfFc6tZ+WNKL3wsNkIwCkLGp6Mqs7LYpCjQSR/SIEQF3WGjj5K3y9mcBF/
         V4xOx4lo0gF/0xpYhoXzO14xgpEJ4Qr+oaei61GE1Ybb1/ph8p28Bz4FF3JSj8oZYDon
         r8PTXuyUoq6WIWaEmIdtHNgNEqnN7ED+x+nbVSROLkbcQZvQ1/9VH9mrAblVlMJIJalx
         6XAwZAppaeynGm1XXAwPD4RTVWkhlb8c+YJsqbhJqHu2vjffuuVgM8LPZarqKmHI4ycm
         szOQwHXTD7p8aGn0sc4GkvCI2NUzUoyBmo5MbAi5ZnZf0AvGfZnz3Cl3ZQzynruC6vca
         AZpA==
X-Forwarded-Encrypted: i=1; AFNElJ9MdAjoaDXG4gU8QWsX6Gn7Z1v1ZS8j4Qf/vlPlyufvo2tCPfTcP1NWHZ4tzxjMm/I9MATrVbpcBcPIUZJ9Grc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmwHZ0PxG4DYQoY+mvcwDjixZ8gd5h02UrGpzFShTKnsj3ZtP6
	m9rq4Ht+aiIt9LNJauTa6RYXq0FeNx1ewtyeBP6siQvQRS4Ii7wuvdEq
X-Gm-Gg: Acq92OH7zDSUYtGoJtyW5Qfj+lqMBabKuEPhnZ7yHR0GnixEFg13T/SRcDmwPjo5X4U
	CT5Mw45yTTQc6uuQZlG6OK3i+Qu1mqaQOk6uYGcjsaOpmWa1vB7o2mJYhpVYUDV2YTWeMgKprgx
	F2wjGO+Bo1XZwZl8BzkJzxTjCngIf1Acu/C5xrwdmzL0fwW3paUuSb7KPdaNEyYu4sqtsWsnrdL
	8qNvuUTw+91ZQd4HCF6PEmrwy3wz8IMKPZlCz3L29IXUqHhu0uXsIDmHGXPrfhdRhcvzWIo535b
	5KOWwPTAHUju86wHKZNZWZhO9y8vL87yPpi6MFFSbssPjg8fEBq0B8dzP8uDngitz3rWirt+Vzb
	IQ+VtKIXWLPLS5SYuiNBhwpbZcjkyECalE5acud7CBgVSPpTXjUvzECbIbaAe0nkjeMKN6R4ccg
	wBMxJs5/+3AGY5KdgjmkEUjnX1aKAoFq7/RPqY2s+WYff+pIZyqiTNtGj5yWh+urXIew==
X-Received: by 2002:a05:600c:6383:b0:489:1c1f:35f9 with SMTP id 5b1f17b1804b1-48fe60ea4ebmr233939685e9.9.1779114126375;
        Mon, 18 May 2026 07:22:06 -0700 (PDT)
Received: from gmail.com (deskosmtp.auranext.com. [195.134.167.217])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768072sm37137502f8f.5.2026.05.18.07.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:22:05 -0700 (PDT)
Date: Mon, 18 May 2026 16:22:04 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
	yonghong.song@linux.dev, jordan@jrife.io, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, martin.lau@kernel.org,
	eddyz87@gmail.com, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v6 2/6] net: move netfilter
 nf_reject6_fill_skb_dst to core ipv6
Message-ID: <agsgjAvP3atsziMx@gmail.com>
References: <20260518122842.218522-3-mahe.tardy@gmail.com>
 <1637d7e04ac3c65239ef77709175697bff287250913d1da68e8d4072e0ff34e1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637d7e04ac3c65239ef77709175697bff287250913d1da68e8d4072e0ff34e1@mail.kernel.org>

On Mon, May 18, 2026 at 01:07:57PM +0000, bot+bpf-ci@kernel.org wrote:
> > diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> > index 09ffe0f13ce7..eb5a60d3babe 100644
> > --- a/include/net/ip6_route.h
> > +++ b/include/net/ip6_route.h
> > @@ -100,6 +100,8 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
> >  	return ip6_route_output_flags(net, sk, fl6, 0);
> >  }
> >
> > +int ip6_route_reply_fill_dst(struct sk_buff *skb);
> > +
> 
> [ ... ]
> 
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index e3d355d1fbd6..37a7627a94de 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -2725,6 +2725,24 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
> >  }
> >  EXPORT_SYMBOL_GPL(ip6_route_output_flags);
> >
> > +int ip6_route_reply_fill_dst(struct sk_buff *skb)
> > +{
> > +	struct dst_entry *result;
> > +	struct flowi6 fl = {
> > +		.daddr = ipv6_hdr(skb)->saddr
>                          ^^^^^^^^^^^^^^^^^^^^
> 
> Is it possible for the IPv6 header to span paged fragments here?
> 
> If the packet header isn't guaranteed to be in the linear data area, and
> there are no linearization checks like pskb_may_pull() before accessing
> ipv6_hdr(), could this read out-of-bounds memory or cause a page fault
> when processing undersized or fragmented packets supplied by BPF programs?
> 
> While v6 cover letter mentions "call pskb_network_may_pull on the cloned
> pkt", this linearization check is not present in this function.

Same answer, caller is calling pskb_may_pull, outdated.

> 
> > +	};
> > +	int err;
> > +
> > +	result = ip6_route_output(dev_net(skb->dev), NULL, &fl);
>                                   ^^^^^^^^^^^^
> 
> Could skb->dev be NULL in contexts where this function will be used?
> 
> Since this is being exported for use by BPF kfuncs, it might be called
> from program types where the device reference is not retained, such as
> socket filters.
> 
> If skb->dev is NULL in these contexts, won't dev_net(skb->dev) cause a
> NULL pointer dereference?
> 
> While the netfilter caller (nf_send_unreach6) checks and sets skb->dev to
> loopback_dev if NULL, the exported function itself does not have this
> protection. When called from BPF kfuncs, especially in contexts like socket
> filters or tc ingress before device assignment, skb->dev could be NULL.

Ditto, outdated.

> 
> > +	err = result->error;
> > +	if (err)
> > +		dst_release(result);
> > +	else
> > +		skb_dst_set(skb, result);
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(ip6_route_reply_fill_dst);
> > +
> 
> [ ... ]
> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26034287312

