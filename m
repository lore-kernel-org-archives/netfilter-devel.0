Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D0B370AF6
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786625929; cv=none; b=UABGuIvcqHnHhvxLqMJn9/J6vh55DoamzrFxU6bpZWv+rdzFRvOgy1EadCl+ajjAfPkw3WIAPp9OIAhwTr3helOkZ18js3zQ2kGE5sfcd12Rz3GKYDweSH3QDn+bUN2d5Fy8e3YOkNxGVGS7jYVxa2rIvxYSCQGWQvkcnq+ux/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786625929; c=relaxed/simple;
	bh=yJmzG+EgAjtP+juW9ZUOSRbW45vhY+U18DDRPDYtzLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igHfXr9MYfJl2r7pv5IOUqVARSAG59YwqPfZCy9u53xPBza6fLHklepuVXThhztNzpXBd2NAm8B77NAakpQlg9WZZ52SE/VimzEBLRnR7OdZy9J+L1+0twFe2ci5ntwEAP9JW9Mdq6vE0AYzgG0R9XT3lxvoPlxX6DZBYWafFY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sA9ddR0/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sA9ddR0/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786625924;
	bh=WKGHMPuW9+F13eKvreOmA5tufj9OLtbYHagNBkcrjKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sA9ddR0/TQ53PCe4TIKEWThWqSWOh3PYjCnhqAfLbdqcptApxMrNUEqmOYXuGbgU/
	 /h32iJDhvhmrZXh0VCr1gfvF+oMiYDqSdArPVssHYcSIzkd0Rvf7dkfPIRIFBKoaKa
	 Nw4TkBjMsmi9cCanoOUlpGqENviO+Oyt1cltg+ApzVeNB/ZvLx7fbfcSyed2VK/KRU
	 Va7fhYcurUUysMx4ft0gtUeUAD/R4dNQWBUwKYTK4Ht7OjyJPWzDmakDekHAHOigiR
	 G0NXRMff1nX2b1XaRBqwNfP91GtUjcSa+0f68fbFvzSM0zNpx052vrw0Z8uAiKpdgq
	 1wakeBVy3kwcQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B8C6E60081;
	Thu, 13 Aug 2026 14:58:44 +0200 (CEST)
Date: Thu, 13 Aug 2026 14:58:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Avinash Duduskar <avinash.duduskar@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: reject negative values for unsigned
 datatypes
Message-ID: <an2_gW-ZhrAACQmb@chamomile>
References: <20260808013318.2766219-1-avinash.duduskar@gmail.com>
 <an2o0fusJ0K-_CbS@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <an2o0fusJ0K-_CbS@orbyte.nwl.cc>

On Thu, Aug 13, 2026 at 01:21:53PM +0200, Phil Sutter wrote:
> On Sat, Aug 08, 2026 at 07:03:18AM +0530, Avinash Duduskar wrote:
> > expr_evaluate_integer() only tests the upper bound, so a negative value
> > passes the range check and mpz_export() then drops the sign:
> > 
> >   # nft add element ip t m { "-1" }
> >   # nft list set ip t m
> >   table ip t {
> >           set m {
> >                   type mark
> >                   elements = { 0x00000001 }
> >           }
> >   }
> > 
> > The error string has read "Value %s exceeds valid range 0-%s" since the
> > check was added, so the contract was already unsigned; only the upper
> > half of it was enforced. The result is not a wrap either: "-1" gives 1
> > while "-4294967295" gives 0xffffffff.
> > 
> > Reject a negative value, unless the evaluation context is a chain
> > priority, which is signed.
> > 
> > Fixes: cb7cb885d65e ("evaluate: add expr_evaluate_integer()")
> > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
> > ---
> >  src/evaluate.c                                | 12 +++++
> >  tests/py/any/meta.t                           |  2 +
> >  .../parsing/dumps/negative_values_0.nodump    |  0
> >  .../shell/testcases/parsing/negative_values_0 | 46 +++++++++++++++++++
> >  4 files changed, 60 insertions(+)
> >  create mode 100644 tests/shell/testcases/parsing/dumps/negative_values_0.nodump
> >  create mode 100755 tests/shell/testcases/parsing/negative_values_0
> > 
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index 8bb7b609..f5b88c0b 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -447,6 +447,18 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
> >  		return -1;
> >  	}
> >  
> > +	/* chain priorities are signed, everything else is an unsigned key:
> > +	 * mpz_export() drops the sign, so "-1" would silently become 1.
> > +	 */
> > +	if (mpz_sgn(expr->value) < 0 && ctx->ectx.dtype != &priority_type) {
> 
> Although it might remain the only case, I don't like the special-casing
> here. Looking at struct datatype, we have a 32bit field for flags with
> only two bits used yet. Maybe introduce an 'is_signed' bit to check
> here?

Yes, I wonder if we can do this in a more generic way, like specifying
in the datatype itself the min and maximum value expected from the
integer. I don't expect "signed 128-bit only". Maybe add a new
interface to struct datatype to validate the value is within the
boundaries? Maybe something like:

 if (ctx->ectx.dtype && ctx->ectx.dtype->validate) {
        erec = ctx->ectx.dtype->validate(expr->value));
        if (erec)
                return -1;
 }

