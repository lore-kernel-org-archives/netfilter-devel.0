Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D1233923
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 07:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779952257; cv=none; b=ZG8QyRJjNuo8xTHjef1zs6VyotA1EwTywVBRUgKoTDvpZTl8oHxjElL/gna5d5KqcymGOF+uYCu6ZgNRmSOYnLIrkf78ePsnqdQENN4Mh6UBvmKmblFYYg6hNg3lFMn97aSKsJ12vkIzKudf+WZnG8ueGhCZm1HW3IexSGxf7AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779952257; c=relaxed/simple;
	bh=Y+z0/xk8fXJMI5Ih3o7oQMr/USJm3DqnSZ68SRu6Vis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzAdyh0Ri/KEob/IlQfscsMlUnEyE2Pzs51DQFbJcyZAw7/lxrOSCjm3w71q6ru5LYOu7mbQ16bDg3Iu8Emsu1d2stMhwadOuxw71Qo39hJpDblKtSG9HGkNQkhJ56b/KOcmRI//EMFFzxJN6QzOfejcqez8hKTHMm8qs442PQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4E75660503; Thu, 28 May 2026 09:10:53 +0200 (CEST)
Date: Thu, 28 May 2026 09:10:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Message-ID: <ahfqfM6xQKZr_xbA@strlen.de>
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de>
 <ahfV6K6KrG0akLUZ@strlen.de>
 <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev>

Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > --- a/net/netfilter/nft_ct.c
> > +++ b/net/netfilter/nft_ct.c
> > @@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
> >   		break;
> >   	}
> > -	if (ct == NULL)
> > +	if (!ct || nf_ct_is_template(ct))
> >   		goto err;
> >   	switch (priv->key) {
> > diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
> > --- a/net/netfilter/nft_ct_fast.c
> > +++ b/net/netfilter/nft_ct_fast.c
> > @@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
> >   		break;
> >   	}
> > -	if (!ct) {
> > +	if (!ct || nf_ct_is_template(ct)) {
> >   		regs->verdict.code = NFT_BREAK;
> >   		return;
> >   	}
> > 
> 
> It looks more general and also covers the other GET keys that would equally
> misbehave on a template.

Would you mind sending a v2?

> > .... might also make sense to invert
> > nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16), i.e.:
> > nf_ct_l3num(ct) == NFPROTO_IPV6 ? 16 : 4);
> 
> As defense-in-depth, IIUC?

Yes, alternatively merge your v1 with the template check. I don't see how
we can ever have nf_ct_l3num(ct) != nft_pf(pkt) outside of the template
bug.
