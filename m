Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D80396591
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 12:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616132; cv=none; b=ceKdp8d7LumJ/NFzxR5Zw0fNklmoE2OJ2yUGlCe6XkMPQ8tlHvTDfUSPjCME9fbW+sIUWOYyH5OLRxtlt498Nb6XOa87BdbGPglhTerfoDQjBuYu1zfrGJ84NPGcJS5Yt4jtai153I4i3kXgoCLDJSIESWnmVvmoBJGrA6cQ1G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616132; c=relaxed/simple;
	bh=LWqbvh3FeikukKL/Ot4NgwDYa+s99h0ef6596oxgW00=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u7vE/43aTSVvXk8PoXNLOEoVHFS9tRfVlJ0+/bYaD0MBIqiWxyU+ftv3FE2NQz/dBXUhAOI+NiOLXzKU3Q/cQkXk+quseNlHsl5n2RIwrNTua5ynLk9WUosRywuafwN5KlMUVBuLtPYCoF5bSZtiUh9soJ+jZkz3rzpGwZqBOw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YN8sghLm; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YN8sghLm"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48374014a77so25191825e9.3
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 05:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774616129; x=1775220929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MP30gO10RQY6yXiMpOxuMeuGTT1rodnXb+jcK+Xa1Wg=;
        b=YN8sghLmTaOw2FvVeIPViL24BP2LmqV69Iu1JTPmXnGAX2BRw+MMm3U6aRuqsUVZDy
         n2i2p+t+Q7pg6PcpV3XEYAsOkMsYzN4D4df/2IwdkaTowinFc9Xq2Dv6kX8bvtNdSDed
         Yq21nD16yE/VGIjU6xFN0FUsMmxmLeN5T5uOk2u+MO5DiOVZ3+U2xWyzV5oAw2jqCkTg
         Es4cId3ZX8EW6KunGxr5UaNph9u8WIayf6SgG0yB1RC/Ss7+/Sa8yx9hUdXJFYh/bW37
         FpUyEHedOXP0u3PYRfLsydyeU4igik2La6KlI+QJQ/y+fsaaz87NmEma3EBjw3emtXKT
         rMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774616129; x=1775220929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MP30gO10RQY6yXiMpOxuMeuGTT1rodnXb+jcK+Xa1Wg=;
        b=l1MmtoNTGDKh5jC2KF55zvEfMxrsg0PzCcYuFDGK1z3oaVZH8CwEWlxi36aaVHjQ9B
         WjLZARD8TWzOtNSzMi66A0wO6riYho3EmLDYOTxgumq2DZs5vPQ7chT4a6+NxxDqXe3E
         ubm1/aQ9JvaG+SCF5eQm3zjKsTHGvgYpZ06Hu8acctfaziL2gl5K/DA3kSUzyg2ykCD8
         /bsWsmwPnF3Y4n/gk9r77pVSTIcT4jtc4q1ngi7bCDZ6jCgWnIdeVJ3ZdryQx7sDktrW
         o0t/4ZvNVCe/ogu4xqm9Bx1Pxxm5bjNm1rwI5jyg7q1PM95dp+0AYZ8ZwR96tJaPz0iR
         h5Zw==
X-Forwarded-Encrypted: i=1; AJvYcCWZ18Yd0J290//mSOfGq2+MrUJWcZM671kR2afwwNEctZDv6GkTAHATF7w7JDV8+nFds8/XOlHQkHazd5yhTfM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc0xV27/LSPT47tzoeYI8jQ8dQ9j2VB7f2sN21nwWu/MUknsZG
	eoTKE3cNKY7rq2ViIjMxUYYIPowMCGnEQTO9VCUxCcHHn2zFUPDSDmpb
X-Gm-Gg: ATEYQzwYMH2uehzZhhKde5MpjHUChpV70suAp97MmisIYEBpoPaWTrLWu3/NaDAf/Ur
	dm1ISGV7gURgVHpGbJVQ6LBWb9of+KmRnrREK6XBZehyTc49+J/WZ9PoQO13UpPHb9YtAFpRfXp
	Cxy/Imrigv9jFB4GioZYbu0puwJ/qw2jDsMfl/2QKLp8Tyboxze7Kb2tGpnuYQX586H4Mv04zoc
	aeelSdtqEujh+B3OvZdv+9LtcfMs+RH6agvzZ+jVSq6w2qQd69+PugTgdEPc4VXwJJ9+/p171Rg
	0BHlXBQlIpmLNo6xfmbTUP927dZP8rMymZ3FYmikKin+QyqWCQnaG5Bd2K6SePK9OelHTcn2sun
	81F4fgir4ZAi5sW6O/nGT08SZEMOSfH53kgcg9SLQ28Vr8bhTOCJzAkWVA8CHyVnWUaiMgc5ffu
	KTr8O70NcVD86G8wehng1TCB4Zb3IuuYdWj+LAz7D6mX458AY2B4FiSIYjCPFFJ86n
X-Received: by 2002:a05:600c:c168:b0:485:35a4:939f with SMTP id 5b1f17b1804b1-48727eddeacmr41627195e9.28.1774616128950;
        Fri, 27 Mar 2026 05:55:28 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722be608bsm118640275e9.0.2026.03.27.05.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 05:55:28 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:55:27 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal
 <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH next] netfilter: nf_conntrack_h323: Correct indentation
 when H323_TRACE defined
Message-ID: <20260327125527.13aaf590@pumpkin>
In-Reply-To: <acZSPeowuYC7ivgA@pathway.suse.cz>
References: <20260326201819.3900-1-david.laight.linux@gmail.com>
	<acZSPeowuYC7ivgA@pathway.suse.cz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Mar 2026 10:47:41 +0100
Petr Mladek <pmladek@suse.com> wrote:

> On Thu 2026-03-26 20:18:19, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > The trace lines are indented using PRINT("%*.s", xx, " ").
> > Userspace will treat this as "%*.0s" and will output no characters
> > when 'xx' is zero, the kernel treats it as "%*s" and will output
> > a single ' ' - which is probably what is intended.
> > 
> > Change all the formats to "%*s" removing the default precision.
> > This gives a single space indent when level is zero.
> > 
> > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > ---
> >  net/netfilter/nf_conntrack_h323_asn1.c | 38 +++++++++++++-------------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> > index 7b1497ed97d2..287402428975 100644
> > --- a/net/netfilter/nf_conntrack_h323_asn1.c
> > +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> > @@ -276,7 +276,7 @@ static unsigned int get_uint(struct bitstr *bs, int b)
> >  static int decode_nul(struct bitstr *bs, const struct field_t *f,
> >                        char *base, int level)
> >  {
> > -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> > +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
> >  
> >  	return H323_ERROR_NONE;
> >  }  
> 
> The change is important for making the kernel %*.s handling POSIX
> compliant. The dot '.' without any following number is handled
> a zero precision by POSIX. It would print no space "" when
> also the field width was zero, aka when level == 0.
> 
> It has no efect if the field width (@level) is always > 0 because
> vsprintf() would add the required emptry spaces ' ' anyway.

That looks like C&P AI output...

> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> Best Regards,
> Petr
> 
> 

