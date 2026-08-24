Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291943932E5
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787608568; cv=none; b=VIctBJKuEahraJNzo8PHQDQqUKTIE9wLRukJlOTTTfxeCJc/p7MgvSD02l6oyGW52Ce6H+V4qao+1Fu6VyMcyewgvg47XCI+OCStXJow9ivyya/7F7eTbYAlx1TF9Gag6N67GNX7OjTZ7cbmzOd3W61+MKNzcopeEdQKY0tB+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787608568; c=relaxed/simple;
	bh=A6vMBqiTX4RyuI2scNrUB///RJBLcTbeZUl7pevwzmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/AEHD4i2REwbXQy/GOMdkPvhK/tS1bIeCbjC6U5MdBLWs9EOhUeG+xeb51foIuUZKNRVKjxzofcAvTE30CtNwSOv7Pkhgt4nCTxPe9xtEvRX2oXgA9lTTA8fwkY6/jkO0rSU6W7HAy1X55b8rvLUUhMDmG55b1fb1OnAf20dWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4988160388; Mon, 24 Aug 2026 23:56:01 +0200 (CEST)
Date: Mon, 24 Aug 2026 23:55:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Zhiling Zou <zhilinz@nebusec.ai>
Subject: Re: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag
 and check for INV flag
Message-ID: <aoy977yxzSEsViun@strlen.de>
References: <20260821134136.18191-1-fw@strlen.de>
 <aohabszy_Ac23p7x@chamomile>
 <aolaWzC1PI7zeYRN@strlen.de>
 <aoy8kFZkXMNOHUcR@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoy8kFZkXMNOHUcR@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Sashiko also hinting to fix ip6_tables core check for this protocol
> > > flag:
> > > 
> > > https://sashiko.dev/#/patchset/20260821134136.18191-1-fw%40strlen.de
> > 
> > Not so sure.  Maybe just do this?  I don't think proto > 0 and flag
> > unset makes any sense.
> > 
> > diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> > --- a/net/ipv6/netfilter/ip6_tables.c
> > +++ b/net/ipv6/netfilter/ip6_tables.c
> > @@ -647,6 +647,13 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
> >  	/* Clear counters and comefrom */
> >  	e->counters = ((struct xt_counters) { 0, 0 });
> >  	e->comefrom = 0;
> > +
> > +	/* Make sure F_PROTO is set, else ip6_packet_match
> > +	 * won't do the right thing.
> > +	 */
> > +	if (e->ipv6.proto)
> > +		e->ipv6.flags |= IP6T_F_PROTO;
> 
> Userspace always provides a zeroed e->ipv6.proto when unused, correct?

Yes, ip6tables raises it when it parses '-p' option.

> If so, LGTM.

Alright, I will respin tomorrow, thanks.

Do you want me to include the TPROXY fix too?
