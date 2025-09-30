Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160E2262FD0
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759233194; cv=none; b=en00UeoNANXdSbU5W3YBznPEsRCn4exS36I/VjP6D9wiCBtlbBd1d+jPIOwGPOo+lvl0TzW6Rz71z+JN91a/lraBPjiZbJKH2m29aGOmiDCZCBMKEp/ZWE90hdWmWtuXojT5WDulCUnbrFPgM+52ONrzMMqaqjZookNgdlWNeM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759233194; c=relaxed/simple;
	bh=QCq7NtExK0OK7weX3LY+pchjGLD9Yg99HjFWUJYVzXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AkvFF1y4W0nP3rENWtXq2+HmGQT33dKQ8rmcXujp/2CRs2HUzpmp/6LDKxSQwbPaGFGg7N7og9SPc3fTgXJNwbId9QahOap0CHZbwFYxfDnKz2o0L2hHmP7KtqJN7Ec/NKKCo/712ay+FUsPXlw8PkY6ema8BMKDz8Cmt9OLnVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9D1FD60326; Tue, 30 Sep 2025 13:53:07 +0200 (CEST)
Date: Tue, 30 Sep 2025 13:53:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/7] doc: add some more documentation on bitmasks
Message-ID: <aNvEo4G7S4auSl2h@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
 <20250926021136.757769-6-mail@christoph.anton.mitterer.name>
 <aNvEXGTouxKGHqZ-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNvEXGTouxKGHqZ-@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> > +It should further be noted that *'expression' 'bit'[,'bit']...* is not the same
> > +as *'expression' {'bit'[,'bit']...}*.
> 
> Yes, but i think in this case it should also tell why.

Ah, i see its coming in a followup patch, never mind then.

Maybe add a reference to it.
