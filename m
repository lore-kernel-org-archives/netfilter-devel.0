Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140B01DF730
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2024 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728398601; cv=none; b=ixpcwBRS9nBoC8IKfmUad3UZDEs2/r9Rgw8acvUElwNRFTf7+KsApbU+MpzIVbnWiIuTyNjNPsC3LA15aCVdeg75siu7MWQXywwIk5/W4Xbr/nW6Ikor+3XVb52N9OSfHEz8GOdRUQ37O+rKkqgc+cocU9IV6F5z29tHBcQTXVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728398601; c=relaxed/simple;
	bh=WazyxFVWd86igLSmKjYZtcgczQbJmIgLbLrCQcrX7X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKMkNJIWlc9Rf2jmKo+L1Lmn1VbgqwhWvAfojZ0FBMi+OJ1bhOKxb0zBsSsMQTdB12zcsZJgF6MNMlUPhKlq02l6f459Xkp/aLBZwyiRLIUNcQ5lcRKJlm2RMlnCi5akl7hWS5uMWvojF+3XaNTiWMVvLL2txSdRYa5vL4ks/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34164 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1syBQh-008dkQ-Vy; Tue, 08 Oct 2024 16:43:18 +0200
Date: Tue, 8 Oct 2024 16:43:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 1/5] expr: add and use incomplete tag
Message-ID: <ZwVFA_0gJCwvaT0i@calendula>
References: <20241007094943.7544-1-fw@strlen.de>
 <20241007094943.7544-2-fw@strlen.de>
 <ZwUT3LGOMW_PPXFr@calendula>
 <20241008121702.GA3610@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241008121702.GA3610@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Tue, Oct 08, 2024 at 02:17:02PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Oct 07, 2024 at 11:49:34AM +0200, Florian Westphal wrote:
> > > Extend netlink dump decoder functions to set
> > > expr->incomplete marker if there are unrecognized attributes
> > > set in the kernel dump.
> > >
> > > This can be used by frontend tools to provide a warning to the user
> > > that the rule dump might be incomplete.
> > 
> > This is to handle old binary and new kernel scenario, correct?
> 
> Yes, old binary is listing, newer binary added something old binary
> can't understand.

I see.

> > I think it is hard to know if this attribute is fundamental to rise a
> > warning from libnftnl. It could be just an new attribute that can be
> > ignored by userspace or not?
> 
> Yes, we can't know if its something harmless or not.
> 
> > I think libnftables (higher layer) knows
> > better what to do in this case, if such new attribute is required or
> > not.
> 
> Well, libnftables can't know that either.  libnfntl saw an netlink
> attribute that it doesn't know about.

Indeed.

> What that attibute is doing, if its harmless or important, we cannot
> know.

Yes, this is an old binary, it does not know.

> > > diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> > > index e99131a090ed..46346712e462 100644
> > > --- a/src/expr/bitwise.c
> > > +++ b/src/expr/bitwise.c
> > > @@ -97,9 +97,6 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
> > >  	const struct nlattr **tb = data;
> > >  	int type = mnl_attr_get_type(attr);
> > 
> > Why not simplify with:
> > 
> > 	if (mnl_attr_type_valid(attr, NFTA_BITWISE_MAX) < 0) {
> > 		tb[NFTA_BITWISE_UNSPEC] = attr;
> > 		return MNL_CB_OK;
> >         }
> 
> That would work too. I don't really get mnl_attr_type_valid().

mnl_attr_type_valid() can go away if all switch() are audited, yes, it
is just defensive.

> All of the callbacks have a switch statement, so anything not handled
> is 'unknown'.
> But if you prefer the mnl_attr_type_valid() use then I can rewrite it.

There is also _PAD attributes that maybe trigger default case.
