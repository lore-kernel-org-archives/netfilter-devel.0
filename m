Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6453DB31D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 10:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781086725; cv=pass; b=QgWIdF3rTnve8EN/Fr58QfvOr+vCdRNy1UwRdkC450TTtOZBGM+1iQBstF0xjnM8PWtA6Z/G0FKn+Llp7AsPDyFPsJtJP1ZmLnQL1MG+4SH+jWgdlE0Jm9hNz9TXAy8EYdADvIT0W7l1aU10d2vtZCPKcH7MrgAAVPPesXslUII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781086725; c=relaxed/simple;
	bh=ui0GdkCGuCsIcJRXz2OyNHXmU4r/DI0pxvNjiCDLHjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oujHyeA2R/Z+TRJWP54UhCovP8/W6dnaWNMEvgy5RNa7ie5nhJH9fFrQL6Va8ruEozpZttwsc8uTkbYJaYLHOV857YEk3KjsCcHo3CBwHA8Kw3bX2KQnfzsxb45UcyVcXhmahOq8l1Ghz5Rtd0e6Rya2lSREaZbt3IGOYujMCao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XuPF31Cj; arc=pass smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XuPF31Cj"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-396aacc5bcfso64929771fa.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 03:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781086722; cv=none;
        d=google.com; s=arc-20240605;
        b=QV5Q3uAb7SPZFzlqbhCAqmybx7xAtYRHrpMaPLF8ORTQ3lnRXmQs/EaJjU+p/g3KaL
         AVrcPgctbvNkMQr2sA8sm4sAfZDEST9qLOUnusaMXlA5hDeLjUo6faEWK9vn41n7WLAO
         s8/bV0tthhCija7Ewv2Z5+nMV3AOR10976CaI3b5mD76JBUlD7zv0DkaSwwYds5PhRCZ
         i5LnCySgnBsO4tT9/9RMvBYedeedN48wBEaiHfC4SxngJpVafFihq6UAhxY5UPgOmhdv
         w44FUIKyFBqfFCUo1vxhRstqnQ4fG+eQmX+PYetoKHoWHAUbaer3wh/iVY/c7U2hIhgK
         xL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k/4EMOuNn6TektDFfik+66ykAw8mGkn8dGwF/XG1k4U=;
        fh=WBXL2Z1stMBOTxIaR8rIHNXns9n1sRdh1Ccu/aBqEWo=;
        b=M5NjNe/mXjIovIghGiC6fSR1n9NIbyAUHrRk4xkI0dITNDzV5gHg+SPO0sWRfRTupo
         xD8s6X7RKMGI7bRGUz9uM7epYWCbhyWC9CLIdGcilVOzB9U4YdIFU8vHECz6WfZgVQMq
         /SIxFrvrL3WClRlgSRIVrmYlx5RutZNSTR9rV0nK/iQUPkINMnH12D0dert+josMqe8c
         Q4xFk7F4J41H02H6sWhLFnBGuJypKzb2Lh+5WBIBrsCE41cc/d/DP3mOpsbkS2MadHDJ
         VbCbAgP3GJMPsppX0YGHAze+7G7TJ7kpiyhCAvTDaLQvb17AgxncAy0wP+ezvcVXBrwf
         WBtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781086722; x=1781691522; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k/4EMOuNn6TektDFfik+66ykAw8mGkn8dGwF/XG1k4U=;
        b=XuPF31CjduFwpJWdwSm+86TqTC8BtfSfmrkBMOIuoYMnvfqY+xtUoYxwC1o9WFe+Ns
         u/dVFGxUdtKhBKYfcnaZZgU0nZvVxYQGbSHb1BAW5a1AOuFRxJJe30Ubm50kbuVv0RGF
         df/kTDJ6mrRaMmQ4LZt8U5qdVq/IPUX5qzxuyX+TjzJsCTtA+of1FFwZW187Y7AXYz5W
         KUTvBzkOJky5kRaDG1DEb6XXL0ql4tVz5Z4T/iK186q+lHdU5C0Vr7PKaWwkCKecXgFz
         esyKHR9em47bIJpTtYvu853YWZQIomVSiFn0lUeOoLuA+mB5FXKKT3cjL2zd0s829ai8
         ORKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781086722; x=1781691522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/4EMOuNn6TektDFfik+66ykAw8mGkn8dGwF/XG1k4U=;
        b=TaFCuppduGns/xhtt5BR+yH13ZCV5wH6QUJIhWz8oYsvz+AJA7hMLrTVA11dDRwvgN
         z5OkewR+J3MzzvhR1eUZ1iW+rQiFMBhGoYmiOT/S1XpsPgoiGTQH2RcQhvCfBe7KuVWE
         pqccxpnqvw2LdVJ5Dt5EGT/IPAQGYm9DWO3G/hcLmVln7zw8KY3LdrHzQPVh+u0u6L+5
         EfqPdZ86m+qHK79NtDmE/TEnW9nb+k0tYG2/d2eSZQoBEHUXWROynBrLAtSZLBLAi4bT
         eHc9NDR7PtaC1pppjrOLEZro2nOh/1kcroapintJYbCX5pzP11Z/azFky1ev7T4QfYaq
         lsMg==
X-Gm-Message-State: AOJu0YwCYK+uZl1GIzNdExPadKKP0pCyamEr7kRlAEb8HfJ2jfDGynVJ
	2eda73G6gx5HuaWk185nqq+vfhdKwIQFnCADZ4cHeB1OzidH9L4lgIyo5MdNkRjM/+5yS5rAvxs
	r0jOd3QTNa9W/NLolvEYtxaZdhcPw5S7GGJMK2R2yEw==
X-Gm-Gg: Acq92OFQlPzTry5Tto83GLOMcHDpu0UE6rb6z2IzubWVkuJnbXUx5sff/qjagBxj3j/
	IQRWtjT0QxiOds9HF5TwJ1vnn939uFZ8c0vN6DbjjgrFxrpPzqrMePcP4T1+3s85ZloPnsTEre6
	baCKzqOfP7uKp+s8IjUZckWqiToMsEmDBsJ+kCr1uGQ/UKhgXNCfj8RHBZfxaQxImHjyhEioCE8
	Y98/A9cy/AUXfi+HFShvM4w3It5eHV70FjnrguziiC+SNZpaCAt0ed2UknYMHFLLKuKg12fogPe
	d3JKWdfzAe+2dF+7HFKIDIVNn3DA
X-Received: by 2002:a05:651c:1509:b0:396:9043:bb97 with SMTP id
 38308e7fff4ca-396d074c5c0mr68417741fa.8.1781086721898; Wed, 10 Jun 2026
 03:18:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609163215.1102215-1-d.ornaghi97@gmail.com>
 <20260609163215.1102215-2-d.ornaghi97@gmail.com> <aih1JpA0iAD84GNb@strlen.de>
In-Reply-To: <aih1JpA0iAD84GNb@strlen.de>
From: Davide Ornaghi <d.ornaghi97@gmail.com>
Date: Wed, 10 Jun 2026 12:18:30 +0200
X-Gm-Features: AVVi8Ce9Zh1dIuiTxYH-zkbk3Q7m1t7nHyPHM-mW9eS6ut7WEPp9Vg2LmdKarrk
Message-ID: <CAHH-0Uep=gt--eWNtQKZ1qOHFAVh7WsUAGsrPTiN8F2kTHkL6g@mail.gmail.com>
Subject: Re: [PATCH 1/2] netfilter: nft_fib: fix stale stack leak via the
 OIFNAME register
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Will do. v2 rejects NFTA_FIB_F_PRESENT for every result type except
NFT_FIB_RESULT_OIF (and keeps the u8 register for that case). Sending shortly.

Il giorno mar 9 giu 2026 alle ore 22:18 Florian Westphal
<fw@strlen.de> ha scritto:
>
> Davide Ornaghi <d.ornaghi97@gmail.com> wrote:
> > diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
> > index 327a5f3365..6df811b8d5 100644
> > --- a/net/netfilter/nft_fib.c
> > +++ b/net/netfilter/nft_fib.c
> > @@ -107,6 +107,9 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> >               return -EINVAL;
> >       }
> >
> > +     if (priv->flags & NFTA_FIB_F_PRESENT)
> > +             len = sizeof(u8);
> > +
>
> Would you mind sending a v2 that also rejects NFTA_FIB_F_PRESENT for all
> cases except NFT_FIB_RESULT_OIF ?
>
> Its not strictly required but its better to be explicit, I think.
>
> Rest looks good.
