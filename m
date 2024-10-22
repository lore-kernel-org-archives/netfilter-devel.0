Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B2013D516
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 11:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729596893; cv=none; b=JEYPM2FT5YT1aWYShYqe0Yi89EPn+9lMOD9mY9OQM2glDxejqv1z7b0pS7cD2m+5nahkP5pTh6ATWxVPDSHFsvXbFIXbsK2uUfU3b2SY/d7Ha6oA0iQZAYxq411Zl9Mu3Mtw7fQ490soOpDQt44OjAkCaNBMhUgSu+B5OmEmVQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729596893; c=relaxed/simple;
	bh=/MmlDsMErRpYXX9WqwVhbiUvD6OeOKcOEDASovHGIbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlGgt2N10g/1pB/64fbEaN0F1mNm6gY3Cdalr8I+y4r3DmqWccQaXgS/P0rZWAwm2hjtqWuzwo7wZ3z1mNeBMOmyWi8pkRtPBBOORqfWHfhwFPAYmFMJNY01UHgN2ef2SA4qzfeqR36RTvT3nIEYWVxaVHTqYK4jCR6aCqGnIj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34686 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t3D9r-00DXKs-CS; Tue, 22 Oct 2024 13:34:41 +0200
Date: Tue, 22 Oct 2024 13:34:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: extend description of fib expression
Message-ID: <ZxeNzTZLxw1NdgL2@calendula>
References: <20241010133745.28765-1-fw@strlen.de>
 <ZwqlbhdH4Fw__daA@calendula>
 <20241018120825.GC28324@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241018120825.GC28324@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Fri, Oct 18, 2024 at 02:08:25PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > -|Keyword| Description| Type
> > > +|flag| Description
> > > +|daddr| Perform a normal route lookup: search fib for route to the *destination address* of the packet.
> > > +|saddr| Perform a reverse route lookup: search the fib for route to the *source address* of the packet.
> > > +|mark | consider the packet mark (nfmark) when querying the fib.
> > > +|iif  | fail fib lookup unless route exists and its output interface is identical to the packets input interface
> > 
> > maybe easier to understand?
> > 
> >            if fib lookups provides a route then check its output interface is identical to the packets *input* interface.
> > 
> > > +|oif  | fail fib lookup unless route exists and its output interface is identical to the packets output interface.
> > 
> >            if fib lookups provides a route then check its output interface is identical to the packets *output* interface.
> 
> Its better, updated, thanks.
> 
> > > This flag can only be used with the *type* result.
> > 
> > Are you sure 'oif' can only be used with type? I can see NFTA_FIB_F_OIF is available in nft_fib4_eval()
> > 
> >         if (priv->flags & NFTA_FIB_F_OIF)
> >                 oif = nft_out(pkt);
> >         else if (priv->flags & NFTA_FIB_F_IIF)
> >                 oif = nft_in(pkt);
> >         else
> >                 oif = NULL;
> 
> Seems to be dead code.  nft_fib_init() has:
>         switch (priv->result) {
>         case NFT_FIB_RESULT_OIF:
>                 if (priv->flags & NFTA_FIB_F_OIF)
>                         return -EINVAL;
>                 len = sizeof(int);
>                 break;
>         case NFT_FIB_RESULT_OIFNAME:
>                 if (priv->flags & NFTA_FIB_F_OIF)
>                         return -EINVAL;
>                 len = IFNAMSIZ;
> 
> 
> since _OIF and _OIFNAME was restricted to prerouting, nf hookfn has NULL
> output interface, so there is nothing we could compare against.
> 
> Now its available in forward too so it could be selectively relaxed for
> this, but, what is the use case?
> 
> Do a RPF in forward, then we need to compare vs. incoming interface.

This is for an esoteric scenario: Policy-based routing using input
interface as key. The fib rule for RPF does not work from prerouting
because iif cannot be inferred, there is no way to know if route in
the reverse direction exists until the route lookup for this direction
is done.

commit be8be04e5ddb9842d4ff2c1e4eaeec6ca801c573
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Thu Mar 31 17:14:47 2022 +0200

    netfilter: nft_fib: reverse path filter for policy-based routing on iif

    If policy-based routing using the iif selector is used, then the fib
    expression fails to look up for the reverse path from the prerouting
    hook because the input interface cannot be inferred. In order to support
    this scenario, extend the fib expression to allow to use after the route
    lookup, from the forward hook.

> But for outgoing interface, we'd do a normal route lookup, but the stack
> already did that for us (as packet is already being forwarded).
>
> So what would be the desired outcome for a 'fib daddr . oif' check?

Hm, this always evaluates true from forward and any later hook.

I missing now, what is the point of . oif in general?
