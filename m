Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29642288C9D
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 06:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759387315; cv=none; b=P/OITTFW2vtJmmWU+DqEfG9trYTfr4vJx18H/coTSWYmFCUG3TRH+XLgQCK6VhvHdOy19nXn4qllK0lo7yE2p3N4VDKOngW9fa0iLo6vhWh6LQdmmy/GprpeypT+k9ebYBDf6JRf1l0BR5WWFL1PW66BnKlnxZJVNy7HHB6Iqeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759387315; c=relaxed/simple;
	bh=k/zz6dV9LtiE9zsqlYP8IViXiaiaqGJ6X/vQQ9/gGyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epE4YYQfOp6znblpoWMySAUxOTzfRV76hpfSYAi06qElJxrlACh8AwjmFg7ikeXJwQrkmbqyzY8xDc0zqo4n10WxYkhkbvV15v/Z71U4qQ85FcTP5NTvOJqyburUBv+8HZLaSrUkfLFSB/5O7nxYSELlGB1sSKBnjn/3AemvtSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 63B4760326; Thu,  2 Oct 2025 08:41:40 +0200 (CEST)
Date: Thu, 2 Oct 2025 08:41:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [TEST] nf_nat_edemux.sh flakes
Message-ID: <aN4eozX50WVSf_LK@strlen.de>
References: <20250926163318.40d1a502@kernel.org>
 <aNfAv4Nkq_j9FlJS@strlen.de>
 <20250927090709.0b3cd783@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250927090709.0b3cd783@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> > Jakub Kicinski <kuba@kernel.org> wrote:
> > > nf_nat_edemux.sh started flaking in NIPA quite a bit more around a week ago.
> > > 
> > Weird, I don't recall changes in nat engine.
> > I'll have a look sometime next week.

Looks like its not a regression but just tripping due to
"1 second is long enough" not being safe anymore on debug builds.

I'll rewrite this to have it query conntrack for relevant entries
instead of failing in case socat needed more than 1s to complete.

> While you're looking, nft-fib-sh also flakes occasionally:
> https://netdev.bots.linux.dev/contest.html?pass=0&executor=vmksft-nf-dbg&test=nft-fib-sh

D'oh.  I think this is just because I did not RTFM.

"ping -c 1" can send more than 1 packet when combined with -w
(deadline), so its failing occasionally because the packet counter
is *higher* than expected.
