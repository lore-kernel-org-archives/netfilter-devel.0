Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34AC3242AD
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769175551; cv=pass; b=TIiwEYNEA/PD+1F0JzomXlj5ARAceh6LbQ5VO28Os35uOXns/Cvnue5II5OHsp0klQjSm6EdL2wanUH93ITbdTyMpilfKXpFt1UAm+AeCM3xHDAqmWk/zBao2GeB6b8NioVd2+PkKsVZLaL70tRtHvARTyRg/l7BOXs+HhTsxek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769175551; c=relaxed/simple;
	bh=OuQaP7/SsqPmMszCZeghrJfE+VfRItEhgIxDsM7cxnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=it4DhU5H2sNVfbsdSuXoLzisruIO2+sOB25jLI4FH2t/sxfAUwjsqaEjL+J4qK2H6CTmeBai1bkb546qwJ6B/3rc9B+sTAqqYD0CG14iO35U5n9sRi1yw+7nRgboxdqDEujNSf/OUjwRGXTvJ8wd6y73Z34vmAwsTRDciz9SeU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UUwMQJlV; arc=pass smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUwMQJlV"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-93f5774571eso552874241.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 05:39:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769175549; cv=none;
        d=google.com; s=arc-20240605;
        b=KLiQ4aHvYiNKmH7XnYnkJq4tsSKfJVA2wTeukbzYsIRQZ755TQKTyu4Dz/v/x35Nqq
         p82vWFHOriuc4L/pBnW1Bzcx3qhZ+5Zs3c6N/szXYyjBvC+QiDnhT7M4XqWrzqMg1QPM
         5I7zcekx1BR0cThkevx79Nadr/SkXZ/99XVNuoys2N68bqIzGKQlRPi9vmMbK4my/EDZ
         jlKabvIYipbDXXVz8qhAPTyjW9V2GA/Puw19PJtX4iA+i6uezWne5PQ+cdI7cyqLFh9Z
         px9lqcb/XXk00CD/Kx9O86sz9/+x+hdsW3+5XTsv+7VwspKjH0OYBKIXoSCDB1hw2cY8
         MSDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OuQaP7/SsqPmMszCZeghrJfE+VfRItEhgIxDsM7cxnY=;
        fh=6o508ip0gR7vYwWwuRhyOT4DWPIt45TeavJkzNdl6Hk=;
        b=VAwWR5bxVJsMUpjWlzflfg8F1owdSkdvFswswJnkdG/tS1U8UT0OS4kJKaaoaiSHz8
         d/isD+2AXWg6UqGnF5cfZMePEUdjgf22LjqNi/4/bzmrL53eVyrG7MHYdL3hKdEBxDgL
         aS/q2RW2rFvC2XmimAKzBTz0/vFbaL7hta3rPHSiparUigWXm2wzNIQWskmHw65ki5Py
         baT1Gm+jfqztDQBEAXqvz15sEZVxGWazCa/4FkD8GJm8napF6ZIzAd366eznMQ75awqJ
         noirB9aWvG4V8b07LThmafefDQmRH/5cesIZJXotP3PG/ineOGTCVOTpOBQNW2RqmEOP
         /nwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769175549; x=1769780349; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OuQaP7/SsqPmMszCZeghrJfE+VfRItEhgIxDsM7cxnY=;
        b=UUwMQJlVS/qSrEtEYIb8bcPYycs6p9j4dc7QjXOG3emblsbq8UNIfFuP4u9rUO4ulr
         h5Gr65RQBSMBvpANoQDo/xx6Z6VuFY27AzuU4lsuCa0gcItDK7qW9ZsTBbo6XRLhGapX
         YRUlWdwxrQWYIFlm5DvhSyGVRWBMW6PERttEsYEJln49NGjXpPgU8KmNxWyIE4zOwiW/
         tGkbLLjKL7kEAPKKNCLQY+o/OwPdAf3MPKplBZfuFCjOzrrRg3Xh5OgpwDIKC4btb45K
         11vT/kIn8CJQeA4GzleQ9VeMvAm8D+41AWTdEI5Ww3ldb6BtJQO2DUerI5aun7Cn4REh
         5cLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769175549; x=1769780349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OuQaP7/SsqPmMszCZeghrJfE+VfRItEhgIxDsM7cxnY=;
        b=DlBVFgGuruwL6a8qGFHSCwfNXmc0V337JjQiCwcgGtEuDZZhIAoPsdI6e6ODhcJyS7
         8WJ9dbxlsG88AZpVRarEILguSIssJuAhxGKW11jVrdwAQsE+M47t2m8M7SisLiUVbxoZ
         zwOIaT6EFxOB1mVSiUmcc7ozRMGKZveEi++NgUbAFh8yIBGEBV7I2KfFVBHIV2k8PRTU
         egWCpkT255kIlakI1EOxEoXJa4BfnaqL3CNWQ4mLkkiSgSw+JFlEaDsGMUOl6wOsMr6m
         2ahSlohqLK51ns9XlGi3AS0Egd5InXfyppSMDUY46GYI2/DZyLfJUoBr//4yE/dr3mho
         TS9g==
X-Gm-Message-State: AOJu0YyGYUx8agS/950mFoZA7K3g6r9FyD6J9gkKVYzeuC4zX19Tabwz
	ynQFG7RqiLyvdbVmNopHsCqIEEuOGqa3o0C6QZOXOrWI8kzKZ1r027cq7Rj7jRTe8x10QO2hpWT
	iDOKLWB2ODj4CQqTAjyUvycI1PtZ7TgA=
X-Gm-Gg: AZuq6aLi5E5vs0AmuX23wt90IIRQwMCWaTvxFMWe2+99BFXI2Abc4QZDR2RHCN9pBff
	ink+VFmf4Gd/jqc330mw3+4FbtXMr4HQWepn3rn+TEhqZdDok/FbyLXu0MvlGwSfy2cdcUgarl1
	DMnpad6KOOj1ZQvk7yQI6hVcqVYJ17MlT6TDnfIBLzTwTbfI+obhDaZSlROTVmPAzi7lObmdnw6
	Lws95Xbbpr2dN8bspQxaRus2zK/FfqaQSf486gpzs5xHbwPj54Sxm/zsy1Va4rNWKqycUQ=
X-Received: by 2002:a05:6102:c90:b0:5ef:b033:8abd with SMTP id
 ada2fe7eead31-5f54bd383a0mr869278137.45.1769175548633; Fri, 23 Jan 2026
 05:39:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-3-scott.k.mitch1@gmail.com> <aWwUd1Z8xz5Kk30j@strlen.de>
 <CAFn2buDVyipnvn8iW1dsPN827D1BBrZ9xLjcuJHC7W00xjioSg@mail.gmail.com>
 <aXD1ior73lU4LYwm@strlen.de> <CAFn2buAFkjBHZL2LRGkfaAXGd9ut+uta1MaxaHuM+=MJdGf_zQ@mail.gmail.com>
 <aXMbOwOw0yVpIWZl@strlen.de>
In-Reply-To: <aXMbOwOw0yVpIWZl@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Fri, 23 Jan 2026 05:38:57 -0800
X-Gm-Features: AZwV_QiXmfUqvvb8G3ZpX-TItj6tjaC263EW8bRqHKoiF9mkaZfCU_5sh3IUsbU
Message-ID: <CAFn2buDj1+X_zKqy-ex5x-fz05g_0a3V_u0gJr7Z_n5pGK4rqQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] netfilter: nfnetlink_queue: optimize verdict
 lookup with hash table
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

> > I agree byte-based memory accounting would be valuable for preventing
> > memory exhaustion with large queues (especially with GSO). However, I
> > believe this is orthogonal to the hash verdict lookup optimization
> > (hash table itself has bounded memory overhead, skb memory pressure
> > exists today with the linear list). Does that align with your
> > thinking?
>
> Yes, this is an existing bug.
>
> > For my use case, packet sizes are bounded and NFQA_CFG_QUEUE_MAXLEN
> > provides sufficient protection.
>
> Its sufficient for cooperative use cases only, we have to get
> rid of NFQA_CFG_QUEUE_MAXLEN (resp. translate it to a byte
> approximation) soon.
>
> If you have time it would be good if you could followup.
> If not, I can see if I can make cycles available to do this.
>
> Unfotunately its not that simple due to 64k queues, so the
> accouting will have to be pernet and not per queue.

For NFQA_CFG_QUEUE_MAXLEN API translation there are a few challenges:
1. Max packet size - If GRO is enabled, the MTU may not be a reliable
upper bound. Using 2mb would be a conservative approach but also
overcommit memory in many cases. Since there is no per-byte limit
today it is likely safest to go with the conservative approach for
backwards compatibility.
2. Per queue limit vs pernet limit - The number of queues and
NFQA_CFG_QUEUE_MAXLEN are dynamic. How would you derive a pernet
limit? One approach is "number of queues * queue with the max
NFQA_CFG_QUEUE_MAXLEN" (which requires some additional state
tracking).

For the pernet byte limit API, were you thinking sysctl similar to
nf_conntrack_max (e.g., /proc/sys/net/netfilter/nfqueue_max_bytes)?

I don't know if I will have cycles to implement this but I'm curious
on the approach and backwards compatibility.
