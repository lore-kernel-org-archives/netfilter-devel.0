Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B206927D765
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2025 05:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744350727; cv=none; b=rstxj+5JiWcIAoCs3/zypHB/is0dxLoN57dVQYKV9qhDE7zUqsiKudGzkqXz+Wwv9jtrdSk2Xzv0TupbJW9e4DdzQRJjsy7CT5VtgTGKXqFhwK7h/0JKQIUg4EOVwCimop+SlID9HHKBdBnGk5+ckMXCr8Vc5zIBqaLfgzxs2V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744350727; c=relaxed/simple;
	bh=3u370K3jFNpH4RvhYVYh48wyh6zIeximhyr6iOacyo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzZ9GAIGDma0/BkxAdCHz4him7pxzhQEwVBMthCPcc6VmivcUcp1/+/VHMsIArF8FKV9xGz9o448Boaiel3KNHnX8EMoOomXLrGSwkXzABmdf/Nl1/eCqe5LFVoNeqwu84NaFLPMQ+l1iyJkv6aRQLDC6uQY0WCl1N4E542OnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u37J3-0004h2-DK; Fri, 11 Apr 2025 07:52:01 +0200
Date: Fri, 11 Apr 2025 07:52:01 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: restrict allowed subtypes of
 concatenations
Message-ID: <20250411055201.GA17742@breakpoint.cc>
References: <20250402145045.4637-1-fw@strlen.de>
 <20250402145045.4637-2-fw@strlen.de>
 <Z_hLLgRswOjXUKMa@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Z_hLLgRswOjXUKMa@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index d099be137cb3..0c8af09492d1 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> [...]
> > @@ -1704,10 +1706,48 @@ static int expr_evaluate_concat(struct eval_ctx=
 *ctx, struct expr **expr)
> >  		if (list_member_evaluate(ctx, &i) < 0)
> >  			return -1;
> > =20
> > -		if (i->etype =3D=3D EXPR_SET)
> > +		switch (i->etype) {
> > +		case EXPR_VALUE:
> > +		case EXPR_UNARY:
> > +		case EXPR_BINOP:
> > +		case EXPR_RELATIONAL:
> > +		case EXPR_CONCAT:
> > +		case EXPR_MAP:
> > +		case EXPR_PAYLOAD:
> > +		case EXPR_EXTHDR:
> > +		case EXPR_META:
> > +		case EXPR_RT:
> > +		case EXPR_CT:
> > +		case EXPR_SET_ELEM:
> > +		case EXPR_NUMGEN:
> > +		case EXPR_HASH:
> > +		case EXPR_FIB:
> > +		case EXPR_SOCKET:
> > +		case EXPR_OSF:
> > +		case EXPR_XFRM:
>=20
> I am expecting more new selector expressions here that would need to
> be added and I think it is less likely to see new constant expressions
> in the future, so maybe reverse this logic ...
>=20
> 		if (i->etype =3D=3D EXPR_RANGE ||
>                     i->etype =3D=3D EXPR_PREFIX) {
> 			/* allowed on RHS (e.g. th dport . mark { 1-65535 . 42 }
> 			 *                                       ~~~~~~~~ allowed
> 			 * but not on LHS (e.g  1-4 . mark { ...}
> 			 *                      ~~~ illegal
>                         ...
>=20
> ... and let anything else be accepted?

I prefer "accept whats safe and reject rest" but I can invert
if you want.

> > +			 * EXPR_SET_ELEM (is used as RHS).
> > +			 */
> > +			if (ctx->recursion.list > 0)
> > +				break;
>=20
> So recursion.list is used to provide context to identify this is rhs,
> correct?

Yes.

> Is your intention is to use this recursion.list to control to
> deeper recursions in a follow up patch?

No, what did you have in mind?

I could see adding new members to ctx->recursion to control other
possible recursions in addition to what we have now.

But I don't see other uses for .list at this time.

> Not related, but if goal is to provide context then I also need more
> explicit context hints for bitfield payload and bitwise expressions
> where the evaluation needs to be different depending on where the
> expression is located (not the same if the expression is either used
> as selector or as lhs/rhs of assignment).
>=20
> I don't know yet how such new context enum to modify evaluation
> behaviour will look, so we can just use recursion.list by now, I don't
> want to block this fix.

OK.  Yes, it would also work if there was some different "where am I"
indicator, e.g. if (ctx->expr_side =3D=3D CTX_EXPR_LHS) or whatever.

This fix isn't urgent, we can keep it back and come back to this
if you prefer to first work on the ctx hint extensions.
