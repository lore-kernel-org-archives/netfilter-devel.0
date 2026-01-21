Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0484636CE04
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769009155; cv=pass; b=m+BeBG0gqhj+rsRP9Q07DhYVjNJek41W/dASa8sIeJJavXOQm1A0t0qExFMXq7SuMvWGqLBnFKiwfsrwPfp/tQ9aLTcsphYOn6G2rMliPSI8Qpjhcak24nnsRZPfSoJ+uI77nsIv1KuakLVuSDWhX6UY7pTVsnbixMMtzxbGh88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769009155; c=relaxed/simple;
	bh=6WGlmMkwppc+3Vk8UnSK7Cg7sWW7pPyMKHYbNbEVr94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bNpRjapolNdCqfkfXv0AEbVd7O83Z1BHH8IPJLfGXDeFxPy98D1dhyS5A3yIGz20Uv4D1/9bvwZZuslLnW4jORaWMLwypa8rgXUcW5qSdPAcCmdbiLr/hY/HiK/pDLTA+cjU1dFUC2Nh9MVzGK2Du9tipeBZOnCgIbiVB/fceWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=alrg7q+X; arc=pass smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alrg7q+X"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5f52e500e89so217702137.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 07:25:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769009153; cv=none;
        d=google.com; s=arc-20240605;
        b=JRq85E9+0a5nMFHaWiQF/QMJ1NsMCV80wEfhQP/VsjZ9O6BNbHjZzxO2VubqDqEaZi
         738js4fMJeD8vcmSJIOS0OpEyx7+CVGH/pI57GA+TQ8LCFMFPKXtoJePZ2VvcowbU59Y
         sCE4lt/SWgUwihMMoED5T4a3P5YUILBVUqB0y6uoh9umMuMYJpSDwcW/1N3OL4hMLJ6S
         EjVg+fjJrtvRml5U1cIKSCkjQQOK6vpCJdEV9w8L8xWxoqBPLTFR36B0HImYbi1FDu3t
         0IafovyySi483WRq+6nCwD0XOpmM6d7uBWW7BurcONThxCorkjpn7bEz7M59+TeZBIyW
         0n2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=V0ckXn0o4qqjUPgvR2G6eySZr5OYBvHPaQlAOwoE8Z0=;
        fh=6o508ip0gR7vYwWwuRhyOT4DWPIt45TeavJkzNdl6Hk=;
        b=kkeYCOFtxs1BaDZqoK2MfgwY5YEXMK6zANuMXlyx/Z0XOkONAt8qpQN/uer1MOT0eP
         c9eG0pmmnHGIXtmBYppzAgp1DnoksTPe0MgqFr4hS9hcxoUYeShZ4f8QPVs7b3pn3Rs6
         hbWlfDRaiR1YwECCUQ60qLvdzq3SzfHDwJQdsIH9z6xe3GAAIHEpE9XapSJAN4/KVuLW
         zCQAAAd35G6FbaUIU7/BjKQ8eHTB6xkN92eCYkKmjfWj2ZZaOAxtgu1bCm/6zK4Ny8rZ
         NsLiA6FP80D7dcIywTjYAFix9pb04M/QqP7fpIZqIsfh0wy2DJo4jJR8uJYqPN/c6/j8
         Pfqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769009153; x=1769613953; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V0ckXn0o4qqjUPgvR2G6eySZr5OYBvHPaQlAOwoE8Z0=;
        b=alrg7q+XFhnTYx86fsQuIJx4L2GvhprvREWmBnh1Gf4r01s7IsROpiZO9/eRnCoxjh
         gy2YvG1vtPmOShMufIi0NmlFRYhTNGGib4/iNLUImZHnskYjgnMixL0cFFJ4hC+XdA5a
         jFXFVQiej8+74e8IiCMtQukmIZYq59DkTSDAIW5Rmkc+GIwewBhRkI5EufoatCh0XV7+
         Wo7Mp8bFMIQdNHH57VmM/DF8RUsKxfbSFh74umNHmYuQXKEPTdXitshS9djAB/tpLCJu
         xaRYfuTbyLCzJXtvw1UfYHseJRJfbpZBhr2STXfCffWWJHkJ/AyDu+bCjG4Xn2N9VQJF
         wd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769009153; x=1769613953;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0ckXn0o4qqjUPgvR2G6eySZr5OYBvHPaQlAOwoE8Z0=;
        b=JhQiD9KuA5Qp16bpyZIm3hCSd/PbMbe66zxKczA2UBzaqJZlOG/7t9wND3QIRuTTHv
         nfU1Zmf0ZVEQjaXVEMmUnvsfJHvS0pdrdEqAgr9xbcgzNaboWfuW0Jaabn3gRSFGLE+G
         qnQkPSdlpy9iSvakyOVzJFBxHfnxY6iXUuVijcAG7KX8bv4Bk9LqswIw+R6sd/JIIiyU
         eYqazySQzWGehHUR10e82f22wMUJkYGHwzjplmvA8+F1CDuPrd8eCVCz+Z3YfTiqt7Ur
         UIOFm5ZYJy5sLj23M1oqLZMiplH5VUvw2bID8zZwn9tSxlibuKqXHO2IbqZjKZuaGK2o
         0nkA==
X-Gm-Message-State: AOJu0YytRTZhOaAbK2XBBSs2Z8QgoTRKj27Rjp+vEr9EhBFmAjNFzUlW
	Zp4XVZh7QKym761kKrqc+CEkMCFGwjktNVUZgrNmxQTlsxDUFWCK6ns5iGeBZ/08CP8w9YnxIZy
	JkOrpBYgCdmQL/V8SyyTkmVM4oTs5emU0EJ2p
X-Gm-Gg: AZuq6aLXXmWOtKC5ZChgvbzatxSC76q0rtXwnVDs/SmdyF5yYRXhiRzhf8yrJNfLkJo
	dxz2Sv8gLfP2a1X3FTN9FgETgbsGV5hntn63WSJm6FxugohRKv2wHY47UPx/aywKYpnRAHTdjxL
	WPz6uXelNXmu4YZu0ckvtCjFq+QEkHYSFeZDENmY3+oHChiIB+E8ZjjyfFT31j57VS6VpAewHA/
	IE4cNxbC5iAldEgcIpIzqMSaiyL77cCqY2juJPBWhrk2hFYQ8ksaIj+PYi7xPCw+lIr66evag==
X-Received: by 2002:a05:6102:cce:b0:5f5:2f71:b723 with SMTP id
 ada2fe7eead31-5f52f71b9damr228855137.31.1769009152576; Wed, 21 Jan 2026
 07:25:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-3-scott.k.mitch1@gmail.com> <aWwUd1Z8xz5Kk30j@strlen.de>
In-Reply-To: <aWwUd1Z8xz5Kk30j@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Wed, 21 Jan 2026 07:25:41 -0800
X-Gm-Features: AZwV_Qge5G6IxUvjHSvzCjQ3i_yUJ1szQfuro10xUj95aUPRfFRIUomYQoC4HYE
Message-ID: <CAFn2buDVyipnvn8iW1dsPN827D1BBrZ9xLjcuJHC7W00xjioSg@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] netfilter: nfnetlink_queue: optimize verdict
 lookup with hash table
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

> > +#define NFQNL_HASH_MAX_SIZE        131072
>
> Is there a use case for such a large table?

Order of magnitude goal is to gracefully handle 64k verdicts in a
queue (w/ out of order verdicting).

> I feel this is way too complicated and over-the-top.
>
> Can we either
> 1). use a global rhashtable, shared by all netns + all queues (so we
>     have no extra memory tied down per queue).
>
> OR
>
> 2). Try with a simple, statically sized hash table (16? 32? 64?) without
>     any magic resizing?
>
> And, if we go route 2), how much confidence is there that its good
> enough?

My concern with fixed size is that "right size" is use case dependent
(depends on queue_maxlen, packet rate, verdict rate, and available
memory). Hash structures that use a LIFO bucket (hlist_head,
rhashtable) will introduce a performance penalty vs existing linear
list iteration for in-order verdict use cases. For my use case, packet
verdicting is in the critical/hot path and I'm motivated to find a
solution that can scale.

>
> Because if you already suspect you need all this extra grow/shrink logic
> then then 1) is my preferred choice.
>
> What is the deal-breaker wrt. rhashtable so that one would start to
> reimplement the features it already offers?

Agreed if global rhashtable is within the ballpark of v6 performance
it would be preferred. I've implemented the global rhashtable approach
locally and I've also implemented an isolated test harness to assess
performance so we have data to drive the decision.

I captured the rationale for current approach here:
https://lore.kernel.org/netfilter-devel/CAFn2buB-Pnn_kXFov+GEPST=XCbHwyW5HhidLMotqJxYoaW-+A@mail.gmail.com/#t.
