Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDD924EF76
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 09:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751621430; cv=none; b=EmO7fGgDd7+QoYBgNQUeWTI37yWX1yR9lzosGaN9Kr9pGUaT3/HBLTOdt2dFGE9mFoLRJyqVAySTz6FMnwCynRoh2E2qv4msMiOi15b4iO3vX+tjV6i/F6Eopqc2Ru9XVc2m7Jg0rGHeDLY5vjzD/qpM3Vfqkc/K/3F3hLgYprQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751621430; c=relaxed/simple;
	bh=TtYa2s9EXvqiYqbJCLmaVZMZTcZJH7NBmZ36s4ajTbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z6kT7Na+iFIDpkPlmlqoVRDRyRjKI4jgVuQrePt68CvOCJ8vImm+MEI3ywwNcG2D6KgC92VRlyR38yD6NjfACWBTq8QGWIwyEG07ev0yrlNT07Ys+GRpu6XaOXNzVs8e6cevSP/gqXBfURb7aQL4lyY0Bs1dpv6t7s5dwPj9mag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BA6DC602AA; Fri,  4 Jul 2025 11:30:25 +0200 (CEST)
Date: Fri, 4 Jul 2025 11:30:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: add conntrack information to trace monitor mode
Message-ID: <aGefMZy8MwpZ2jVJ@strlen.de>
References: <20250508153358.8015-1-fw@strlen.de>
 <aGeGqWYZy-ng2Xrm@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGeGqWYZy-ng2Xrm@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > @@ -98,7 +98,11 @@ static const struct symbol_table ct_status_tbl = {
> >  		SYMBOL("confirmed",	IPS_CONFIRMED),
> >  		SYMBOL("snat",		IPS_SRC_NAT),
> >  		SYMBOL("dnat",		IPS_DST_NAT),
> > +		SYMBOL("seq-adjust",	IPS_SEQ_ADJUST),
> > +		SYMBOL("snat-done",	IPS_SRC_NAT_DONE),
> > +		SYMBOL("dnat-done",	IPS_DST_NAT_DONE),
> 
> These will be now exposed through 'ct status' forever, not sure we
> have a usecase to allow users to match on this.

I don't.  Its so ct status is pretty printed here:

 trace id 32 t INPUT conntrack: ct ... ct status dnat-done ...

I can see if I can somehow restrict this to the trace display side.
OTOH I don't see a reason to artificially limit this.

> I know these are exposed through uapi, but I don't have a usecase for
> them to allow users to match on them.

I don't have that either.  But I don't see why we should prevent it.

> If we go for exposing these flags through ct status, do you think it
> is possible to provide terse description of these "new flags" in the
> manpage?

Sure, will add.

> > --- a/src/netlink.c
> > +++ b/src/netlink.c
> > @@ -2116,6 +2116,114 @@ next:
> >  	}
> >  }
> >  
> > +static struct expr *trace_alloc_list(const struct datatype *dtype,
> > +				     enum byteorder byteorder,
> > +				     unsigned int len, const void *data)
> 
> Suggestion, not deal breaker: It would be good to start a new
> src/trace.c file to add this and move tracing infrastructure?

OK, let me respin this after splitting the existing stuff to trace.c.

Thanks for reviewing!
