Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291761DF728
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 11:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730200748; cv=none; b=sEvFIOLol+L0LESOlayzfKVGc/N+ymP8je4a74EqyND9UvkZnSZZUHCFvgdZykrhJ4n+qNzHTFRnjkEyf9C8n3y6y51eJFOZK68AciPMglvYEPNxbKShT4S8R3nxrSuFCjBN6tD6kUUISdUd6P99Pj4GmLd8SWVBF2DQlNvLrS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730200748; c=relaxed/simple;
	bh=n7n69YXvuFK7u9Fopu3hvmG5gFklxkneUIiEFkIaEkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ntd6vHlRHHlkZAJT0Ju7232SNZ7krnxj/EL9uU3D8sm/OyP9CPyPsS/s+EPBT2P69iV9dh+1MWQKjjBw1FCNO+y1+lfGbkTUlmKsZcuca11+MGg4DvxExXZawTPxzTUbgcgqNoH9vxEWXZ5PBbru4i0CiTFUReEOSFzm+m/lhWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t5kFW-0006ed-VH; Tue, 29 Oct 2024 12:18:58 +0100
Date: Tue, 29 Oct 2024 12:18:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241029111858.GA25003@breakpoint.cc>
References: <20241026105030.75254-1-fw@strlen.de>
 <ZyAZogr_F4GlCpPo@calendula>
 <20241029071624.GA16983@breakpoint.cc>
 <ZyCwlAhyQMLh_q-M@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyCwlAhyQMLh_q-M@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I delayed this to insertion time because packet could dropped before,
> > > rendering this conntrack timestamp useless? There is no event
> > > reporting for conntrack that never get confirmed.
> > 
> > Sure, but the "issue" is that the reported start time doesn't account
> > for a possible delay.  I did not measure huge delta before/after this
> > patch but if you have e.g. nfqueue in between alloc+confirm then the
> > start timestamp will account for that delay after this patch.
> 
> I see. I think the question is what this start timestamp is. For me,
> it is the start time since the conntrack is _confirmed_ which is what
> we expose to userspace via ctnetlink and /proc interface.

Sure, its a question on definition as to what "flow start time" means.
See below for yet another proposal.

> Is this user trying to trying to profile nfqueue? Why does this user
> assume conntrack allocation time is the right spot to push the
> timestamp on the ct?

If I understood correctly its about using conntrack events + timestamp
extension to get (passive) RTT measurements.

> On top of this, at that time I made this, I measured ~20-25%
> performance drop to get this accurate timestamp, probably this is
> cheaper now in modern equipment?

I think cost depends on the clock source, hopefully most systems do not
have a too expensive one nowadays.

What about using skb_tstamp() first?  If skb already had rx tstamp
enabled, we'd get an even more accurate start time (packet arrival),
even before ct got allocated.
