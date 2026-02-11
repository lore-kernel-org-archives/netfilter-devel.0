Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4722EA151
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 19:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770838985; cv=none; b=TijlBbORRmy2kizZzhxgnjFc1W1b9XFKCjRR/oqTn/r8ngarS3v4+rNHGNi5/CSKP2op5nEvPtMvvj6kQ2TQswym0CwGDOVqrv6IxFY1xchLcvmr3NJ3bfSgX+i0SNvzKqNx6fCYU03cvy0QQzUvtM2owlNR+9g420+arhmct0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770838985; c=relaxed/simple;
	bh=BNBlHwnfdLcmMhp4kWo5PVvJjvEb5yg+/wcYwSDUtBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fROzvGY7QyPt4mNa7fDYCcg+iZa2kannOb33Ui851ATNHhvPa2SlaBFglcos2CjUrmvQm5v3/2szkYPCkqU/FY3wH8QTQELvWL4uNv8VewuUIY99ve3Qk68QDi8iH/o2rAWCS7a5Eq5dzHl7ArqXCkAnExGXSYFlQ5syfU9tbwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lqTh2TOa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lqTh2TOa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oZA/cjs3FTs2lHKqYku8KxL+cEU4DIrbQnejs+MiMDs=; b=lqTh2TOasTe234S3bYt7q74uty
	2CT+BN/uVDFGwfK8fwZdD0CYhmTrJ5FL0ruDVOuX85IAvr7Rrf9TmGd3+khAN9qR9xs0Sfme0rfLD
	vqoAM3kXJWuJAxwXzPpfjNOkNLrKHFt4DVTSu3iGIfxF0k1SYKEozWAsK1R/2keYO3vD4fKqcDqGk
	bItxbaEwC+0LJeOaR8ocz40ErsaEXG/BXcTHU1pybK92Lkuz2Q5doSGlS3hNUU8Fgf6hXLmQt8Lta
	Mc1x5GAejoF8BxSHWbcBlpHnA4JWZv0m2r46aQrA741GQ/tn75f+pZULFRUuULvg2QZLX9jVKWj+B
	LwHbgR3Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqG75-000000007kh-0u3T;
	Wed, 11 Feb 2026 20:43:03 +0100
Date: Wed, 11 Feb 2026 20:43:03 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Ilia Kashintsev <ilia.kashintsev@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: Global buffer overflow in parse_ip6_mask()
Message-ID: <aYzbx0c5wIiXdzxL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Ilia Kashintsev <ilia.kashintsev@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAF6ebR70NXKv54uEE=kGC2O9tg5K+LoB5gZCm7tKJJaJRGLZcg@mail.gmail.com>
 <aUQTNcIKD-7YzYQQ@orbyte.nwl.cc>
 <aYx_Wupq7R-2ndbc@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYx_Wupq7R-2ndbc@strlen.de>

On Wed, Feb 11, 2026 at 02:08:42PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > The reason why the second memset() call may mis-behave is the broken
> > div-round-up in there: It does (bits / 8) + 1 when it should do
> > (bits + 7) / 8 instead. Fixed that, only the p[bits / 8] field access
> > needs to remain conditional:
> > 
> > @@ -364,8 +364,9 @@ static struct in6_addr *parse_ip6_mask(char *mask)
> >         if (bits != 0) {
> >                 char *p = (char *)&maskaddr;
> >                 memset(p, 0xff, bits / 8);
> > -               memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
> > -               p[bits / 8] = 0xff << (8 - (bits & 7));
> > +               memset(p + (bits + 7) / 8, 0, (128 - bits) / 8);
> > +               if (bits & 7)
> > +                       p[bits / 8] = 0xff << (8 - (bits & 7));
> >                 return &maskaddr;
> >         }
> 
> Phil, would you mind formally submitting this as fix?

DONE, thanks for the reminder.
