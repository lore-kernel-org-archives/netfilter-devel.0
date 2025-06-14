Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B352E11CB
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Jun 2025 21:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749938017; cv=none; b=nydCD6SQbxhUPeKu4o7iXVTN6JdKSyT8Vg8MTkLN00gO/wTQbTpekPiavr6c5y3A0x5CPOE67MEqd+2sB0/Of1gJuSqnBXAU2CQzTnd2w9ScMM4xXJBJQr+zCbhFpLcqnYCSYJ7Y7xMNh8NwJ74o4vKqK+vP/Z41ia4AWyNAiqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749938017; c=relaxed/simple;
	bh=76fpXwbhkJjHuM8tE052fUrI0R1HcZTYmSw12uq0huM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M65VPoYnbmbR+be1EoMhHjLHp42fsbwn8dH7evqfHl7HGhDrSdecub0o8CJjzNrHppHnQxVPWeurbhHRYwz+euhGf/74mj9QmXLq4LntyxkUIBt3dkyNGP0yWoBqsNPynCZx8p+h1zkz6ChV4hbPABhBYPoUkYHOeWkZn8Uuvto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DkguPLTG; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a98fxIsn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DkguPLTG";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a98fxIsn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 75E876036D; Sat, 14 Jun 2025 23:53:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749938003;
	bh=kVAqBwWSHYXUWlcPzY+0LW3Cf9b7uvcDoVsR4BBn6zs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=DkguPLTG/w5eWvc6THWI6w63FMZ+7u7zM3d6+XDGf45pSxpyN2KcA0M7ZA/cMGW6p
	 muIjmPh9aA4bhBH8NCRjKjN7nUqWXi4nS/Rvfj7NdETgbIAO86CGX/dzl+X7+9pwVb
	 gV6A6ukQLjck5fSGqULMg2w4bj1CG7XtbRsvl3eZMHM+DdTRdrWIeMXZMARTtpRWI0
	 R6m9jselmuLh+QEwhtKOQOjIC0X9CqMUFJXjFfATJ7P2fbR0ixhfJHkCtteqy11fUc
	 WTD2eD73y0tBfQ2187zmF1wSUiDZ7JXJGGLetIZM9oClcGy8ZAzHp9xUlqnvCI6HIX
	 NXqmOFzdPk5UQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8259C6034B;
	Sat, 14 Jun 2025 23:53:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749938002;
	bh=kVAqBwWSHYXUWlcPzY+0LW3Cf9b7uvcDoVsR4BBn6zs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=a98fxIsnOM8scocb3yPElgOL4hiKfkFhBHdCy+s7Z9FOKRolxfxbrH3/3s7R88cFi
	 hmGe4WIBkOL9vWjWx6jfEDg/KAFDTJsSlzueUnrw0Efzg8ELIL39n9JVdT8rMQdXFe
	 xRoxjQafrvvmACjd6DLq1qu/8mR0ny5EZZkO631MD4LBdA2B4amGyZBlq8nis9+7OM
	 ojozArc1OwMv58rESg9dadDCuJ5MDudwLFXGFy8cQK3gpoK7J5W882nwjUIluCI/qU
	 8i1K6Ck1x2UT72ifuBBD4XutwdFPpFTqefUxHe0KaoRbIlJGbfoIW5uMy48v6Y693L
	 Ku9DNrqfb1K6g==
Date: Sat, 14 Jun 2025 23:53:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evalute: don't BUG on unexpected base datatype
Message-ID: <aE3vUEmr6Ua291dK@calendula>
References: <20250613144612.67704-1-fw@strlen.de>
 <aExGZDqWdNgG0_BD@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aExGZDqWdNgG0_BD@orbyte.nwl.cc>

On Fri, Jun 13, 2025 at 05:40:20PM +0200, Phil Sutter wrote:
> On Fri, Jun 13, 2025 at 04:46:06PM +0200, Florian Westphal wrote:
> > Included bogo will cause a crash but this is the evaluation
> > stage where we can just emit an error instead.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  I wonder if we should just replace all BUGs in evaluate.c
> >  with expr_error() calls, it avoids constant whack-a-mole.

I think that can help uncover bugs, or are those json induced bugs?

> I guess the expectation was that bison catches these but I fear JSON
> parser has weakened that quite a bit.

It would be good to harden json parser to reject trivial non-sense, no
need to postpone this to the evaluation phase. If fuzzer can help in
that regard. I understand some issues can be more easily identified
from the evaluation step. I am not telling to only handle this from
the parser, I mean "it depends" on the issue.

> I wish libnftables to well-behave in error cases unless critical ones
> like ENOMEM.

Yes, I guess that's completary to my request above.
