Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9718340862
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 12:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729253310; cv=none; b=mNCRI6tmatAZAO7TicP3HXWx+DnhZjPtyVrvTIuLpHeQGj+mvWEJe3/8t5sj9v56OK10OsxZXDkl5+D8rw2lM7JObJGb1hUdAAU93em3syaQ1g7TTtcieMaVgEjzRm3NldZSzHgp86aA47Bb0HDxTrpsbSLLmkMZaG5vBTBDghk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729253310; c=relaxed/simple;
	bh=oIKuqnXYSnbNTlZpd90Dx/swAIWYzkTMlbgcd6EDKUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hc9H7ksNN+jYvaRj4WTDae85JLvx9Dha1Z5K5sitZ8H2o5851p6JWYOHNYXQu24XBRRQTyjt46RT28FHdj/lcIoLaLjN/YCcepoPtELSaflwMuVpWztd3B7xYhN8BRePALXIcmSLKrbd51MbFKtyMv+be4V214TIL3hF+FVRU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t1lmL-0007jX-Sh; Fri, 18 Oct 2024 14:08:25 +0200
Date: Fri, 18 Oct 2024 14:08:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: extend description of fib expression
Message-ID: <20241018120825.GC28324@breakpoint.cc>
References: <20241010133745.28765-1-fw@strlen.de>
 <ZwqlbhdH4Fw__daA@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwqlbhdH4Fw__daA@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > -|Keyword| Description| Type
> > +|flag| Description
> > +|daddr| Perform a normal route lookup: search fib for route to the *destination address* of the packet.
> > +|saddr| Perform a reverse route lookup: search the fib for route to the *source address* of the packet.
> > +|mark | consider the packet mark (nfmark) when querying the fib.
> > +|iif  | fail fib lookup unless route exists and its output interface is identical to the packets input interface
> 
> maybe easier to understand?
> 
>            if fib lookups provides a route then check its output interface is identical to the packets *input* interface.
> 
> > +|oif  | fail fib lookup unless route exists and its output interface is identical to the packets output interface.
> 
>            if fib lookups provides a route then check its output interface is identical to the packets *output* interface.

Its better, updated, thanks.

> > This flag can only be used with the *type* result.
> 
> Are you sure 'oif' can only be used with type? I can see NFTA_FIB_F_OIF is available in nft_fib4_eval()
> 
>         if (priv->flags & NFTA_FIB_F_OIF)
>                 oif = nft_out(pkt);
>         else if (priv->flags & NFTA_FIB_F_IIF)
>                 oif = nft_in(pkt);
>         else
>                 oif = NULL;

Seems to be dead code.  nft_fib_init() has:
        switch (priv->result) {
        case NFT_FIB_RESULT_OIF:
                if (priv->flags & NFTA_FIB_F_OIF)
                        return -EINVAL;
                len = sizeof(int);
                break;
        case NFT_FIB_RESULT_OIFNAME:
                if (priv->flags & NFTA_FIB_F_OIF)
                        return -EINVAL;
                len = IFNAMSIZ;


since _OIF and _OIFNAME was restricted to prerouting, nf hookfn has NULL
output interface, so there is nothing we could compare against.

Now its available in forward too so it could be selectively relaxed for
this, but, what is the use case?

Do a RPF in forward, then we need to compare vs. incoming interface.

But for outgoing interface, we'd do a normal route lookup, but the stack
already did that for us (as packet is already being forwarded).

So what would be the desired outcome for a 'fib daddr . oif' check?
