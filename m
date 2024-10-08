Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37A51E485
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2024 12:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389832; cv=none; b=rRNpp5sM+UTBGm2S8UQPXUlx1UrfLu8gPsuNDKyGQYmuVimEqmT2+FDlDjudp3PGFMUXbZrVMWi0wDhZQNbTIvFa9f02g9Xl2naaPpDtvtxp9Aw+9Lf3rT49yAsV1j/sGYEgCsL9yUlRTaQQ0y2m+1AUTcJ2jXQZ5NLbA/rZcbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389832; c=relaxed/simple;
	bh=fbG7VViUHCZwJtr2FBZZSkXXChVnbJCX+hAgAcmNG9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJgLt5S27k0LD/bUKOvrMGwMS8HdOGfiA8veQjiYBx8+UgXLe2Oz9lXmvJ7rlPbjvSYXbwfrcvh6Tfd3bosm+gmnyBoWvNHDpdvMtZvZbUbQnES1VhYE3GTfmvwi9lJZ2FX8kdM9qR+zf9y/uBtahUb9piHsu/iHJd0Ngb4uJdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sy99C-0001zX-Dc; Tue, 08 Oct 2024 14:17:02 +0200
Date: Tue, 8 Oct 2024 14:17:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 1/5] expr: add and use incomplete tag
Message-ID: <20241008121702.GA3610@breakpoint.cc>
References: <20241007094943.7544-1-fw@strlen.de>
 <20241007094943.7544-2-fw@strlen.de>
 <ZwUT3LGOMW_PPXFr@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwUT3LGOMW_PPXFr@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Oct 07, 2024 at 11:49:34AM +0200, Florian Westphal wrote:
> > Extend netlink dump decoder functions to set
> > expr->incomplete marker if there are unrecognized attributes
> > set in the kernel dump.
> >
> > This can be used by frontend tools to provide a warning to the user
> > that the rule dump might be incomplete.
> 
> This is to handle old binary and new kernel scenario, correct?

Yes, old binary is listing, newer binary added something old binary
can't understand.

> I think it is hard to know if this attribute is fundamental to rise a
> warning from libnftnl. It could be just an new attribute that can be
> ignored by userspace or not?

Yes, we can't know if its something harmless or not.

> I think libnftables (higher layer) knows
> better what to do in this case, if such new attribute is required or
> not.

Well, libnftables can't know that either.  libnfntl saw an netlink
attribute that it doesn't know about.

What that attibute is doing, if its harmless or important, we cannot
know.

> > diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> > index e99131a090ed..46346712e462 100644
> > --- a/src/expr/bitwise.c
> > +++ b/src/expr/bitwise.c
> > @@ -97,9 +97,6 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
> >  	const struct nlattr **tb = data;
> >  	int type = mnl_attr_get_type(attr);
> 
> Why not simplify with:
> 
> 	if (mnl_attr_type_valid(attr, NFTA_BITWISE_MAX) < 0) {
> 		tb[NFTA_BITWISE_UNSPEC] = attr;
> 		return MNL_CB_OK;
>         }

That would work too. I don't really get mnl_attr_type_valid().

All of the callbacks have a switch statement, so anything not handled
is 'unknown'.
But if you prefer the mnl_attr_type_valid() use then I can rewrite it.
