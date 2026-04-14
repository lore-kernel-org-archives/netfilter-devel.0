Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC638E133;
	Tue, 14 Apr 2026 08:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776156936; cv=none; b=Zs1CfofVonHf00LTgMCfKtqYq7DzQ/tAXeQbr3W9fR0xWedcMe3QELUJmN/iO37u3pc2b9sZ61qJUa12A2c8HACgJyVo+tmk25bRDRJd7eIl/Jex/spC3VA+80KXIehhzhZVfZg7ZDi5sVYPh5zy1wm7uVdiiU93F//3K/kJm50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776156936; c=relaxed/simple;
	bh=YXM1eHsYH2YttKlFP3qPC3lpgYqcmLz1puBcQts+rh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e23sj4b+/b9woQPIIU5xS5lAtmx4LSGOcrhk0lQAM+GGndllPaqhkx2d8h9RePy7km9fCOlecUNJDqs5u1rmmaPWuezVEgNOcL8Ih9Mrc3S/dTEex2Wv+t3S8ZGYJxhZUJITJAy6acW6HTnCcrEpRKC3JLx2ka/TbjC3mHDEL6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Alc9FRls; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Alc9FRls"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 43A6B6017E;
	Tue, 14 Apr 2026 10:55:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776156932;
	bh=WCk4PdUEf2E10fBoVKFyPqt6NigSonrmzj0DhomGNm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Alc9FRlsKeM1ENVnTwR2/qn7vbkqLF7td814u7LvHHGqawqEz7FAdWN3bzbwrYsOp
	 8NNTmydCVGJB1RUGvhfa/XOLVPgbDY5EXKn1DZ1FxdHDT779jPJlTP0V6ADopW5n1y
	 yaX3tAEN9WgNZbWUI1953gj8YXuDw23IDp5u44iVPZF1aNSF/D6np58FdSk/mQscdF
	 hfZH1ynIo6M3oAlBWGC4xyV9f7UBq7bka2Z2LZCCze6pPJB+DYV9+p5CzdjwJvRuWt
	 t2lSr4wOrSJ3avcpKguUpKFaoAhzO7Q5KXjQzZFhYgRlUkVsJRwszlGovNJRzQpIF+
	 MX1utoq1dl+YA==
Date: Tue, 14 Apr 2026 10:55:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: "Kito Xu (veritas501)" <hxzene@gmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	ffmancera@riseup.net, fw@strlen.de, horms@kernel.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, phil@nwl.cc
Subject: Re: [PATCH] netfilter: nfnetlink_osf: fix null-ptr-deref in
 nf_osf_ttl
Message-ID: <ad4BAeDHyQ0UcQcL@chamomile>
References: <ad35LhIOSaEDJAhS@chamomile>
 <20260414083703.2531953-1-hxzene@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260414083703.2531953-1-hxzene@gmail.com>

On Tue, Apr 14, 2026 at 04:37:02PM +0800, Kito Xu (veritas501) wrote:
> From: Kito Xu <hxzene@gmail.com>
> 
> Hi Pablo,
> 
> On Tue, Apr 14, 2026 at 10:22:06AM +0200, Pablo Neira Ayuso wrote:
> > How could skb->dev be NULL !?
> 
> skb->dev is NOT NULL. The NULL value is `in_dev` returned by
> __in_dev_get_rcu(skb->dev), because dev->ip_ptr is NULL after
> inetdev_destroy().

More detailed report helps.

> > This is run from prerouting, input and forward.
> 
> Correct. The crash path is in PREROUTING on lo.
> 
> > I cannot believe this, I think AI is mocking KASAN splat, if that is
> > the case, I am sorry to say, but it is too bad if you are doing this.
> 
> This is a real bug with a reproducible PoC. I understand the KASAN
> output in my original patch email looked suspicious because it was
> interleaved with the PoC's stderr output (the PoC prints debug lines
> while the kernel oops scrolls by simultaneously). That was a formatting
> mistake on my part.

No need for PoC, just a bit more details is enough.

Thanks for explaining.
