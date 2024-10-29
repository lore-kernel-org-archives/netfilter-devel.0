Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769E61DED68
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 07:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730186189; cv=none; b=hxALPMIRB/63OuUjhHu0IzdWyYNzK+TBfQhd6cQkmFWvYq3EM36cs1U2dPnXdb3bERo7+X7mN3Dqyufsp3EIuWyPPLapsWwvqkQH8ougnH0143pxX4Lth+uWvmWojLMfDvGongdPea1tKrvz1anSiXbyANFFBLxGgUJ7i75yC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730186189; c=relaxed/simple;
	bh=Wn/8gnhstmrDSIPyyM99fuJvHKsf9gNdFSVeKPOvpBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aljhg6EL3uwm2/dlxFSU2s1qASzt/Sz3mNC8ss3+ukyr8wlsbMY7LJBvwhKnaZCG5XXkQY61lRR5g00ONshd61CFEEQyl+I+W4dLWgTLAI9dtYq7CW1bAFEq3FR8pbcu4ES0UpHQ0UyLwtRKI8xhKoVB9rCn65zHzh0xyMygARs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t5gSm-0004RD-Im; Tue, 29 Oct 2024 08:16:24 +0100
Date: Tue, 29 Oct 2024 08:16:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241029071624.GA16983@breakpoint.cc>
References: <20241026105030.75254-1-fw@strlen.de>
 <ZyAZogr_F4GlCpPo@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyAZogr_F4GlCpPo@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Oct 26, 2024 at 12:50:13PM +0200, Florian Westphal wrote:
> > Sample start time at allocation time, not when the conntrack entry
> > is inserted into the hashtable.
> 
> Back at the time, long time ago, I remember to have measured a
> performance impact on this.

You mean when enabling timestamp + conntracks get dropped before
confirm, correct?

> > In most cases this makes very little difference, but there are
> > cases where there is significant delay beteen allocation and
> > confirmation, e.g. when packets get queued to userspace.
> 
> I delayed this to insertion time because packet could dropped before,
> rendering this conntrack timestamp useless? There is no event
> reporting for conntrack that never get confirmed.

Sure, but the "issue" is that the reported start time doesn't account
for a possible delay.  I did not measure huge delta before/after this
patch but if you have e.g. nfqueue in between alloc+confirm then the
start timestamp will account for that delay after this patch.
