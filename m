Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E6F1A0AEF
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2024 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719264257; cv=none; b=Us1Bp4LbSzc/dp5N5VtbzrQfp2h8UoVB+QjuKIOquR6vb5rjT+ofdbSfGXzHwptQUQI+6XIJQBGwZ3Gat240aABxRud4jNC60ko6nLPGOBxXMEhl2A9AkqU+GH9VwVi6RKXSGqQxg/xy+92r53Qbbv+kOc5JRvcFMDkA+ol5Ijk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719264257; c=relaxed/simple;
	bh=mD+gPUMq88/AwHmqxSwBdWGhs4OSNres/o2zgbCiGIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8QtiJOXAGMEPRTOIH4vFIDF1PupA07yyZx3MofXnK4qzJsd1PVMeo9x8IAIkYpT49YjPxrBqucCUaPR+Th31jhsupvxSedObTrMhSzboZqUxGurpO15GS8I8IBmXKklfLFhDB9wPfXWiRx4qRuJ1bKt11OcUB0C7wpKGd/csIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sLrAb-0003qf-RQ; Mon, 24 Jun 2024 23:24:13 +0200
Date: Mon, 24 Jun 2024 23:24:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: let nftables indicate incomplete dissections
Message-ID: <20240624212413.GB14597@breakpoint.cc>
References: <20240612075013.GA13354@breakpoint.cc>
 <ZnFBQmrX9FgTG8rb@calendula>
 <20240618093135.GC12262@breakpoint.cc>
 <Znm3kJtti8kJYtPu@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Znm3kJtti8kJYtPu@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Add a "bool incomplete" to libnftnl strnct nftnl_expr, then set it
> > from each expr->parse callback if there is a new netlink attribute that
> > we did not understand.
> > 
> > nft then checks if this is incomplete-marker is set.
> 
> Is this sufficient? There are attribute values that could have an
> unknown/unsupported value, eg. exthdr type (assuming a new extension
> is supported).

No, but libnftnl can't known (and should not care) if nftables can
eat the value provided.

i.e., 'incomplete' means 'there were attributes that I did not understand',
nothing more.

> I am afraid setting incomplete for an unknown attribute also restricts
> netlink extensibility.

How so?

> Netlink allows for adding new attributes. Attributes also determine
> semantics, eg. exthdr type restricts the semantics of other existing
> attributes. There are also flags attributes which provide a hint on
> what is support or not, toggling such flag allows kernel to reject
> something that is not support.

But thats up to higher level tool, i.e. nftables?

I don't think libnftnl should try to guess if nftables can make
sense of the rule provided (or set, element, etc).

> > > > Related problem: entity that is using the raw netlink interface, it
> > > > that case libnftnl might be able to parse everything but nft could
> > > > lack the ability to properly print this.
> > > 
> > > There are two options here:
> > > 
> > > - Add more raw expressions and dump them, eg. meta@15, where 15 is the type.
> > >   This is more compact. If there is a requirement to allow to restore
> > >   this from older nftables versions, then it might be not enough since
> > >   maybe there is a need for meta@type,somethingelse (as in the ct direction
> > >   case).
> > 
> > Yes, for attributes that libnftnl knows about but where nft lacks a name
> > mapping (i.e., we can decode its META_KEY 0x42 but we have no idea what
> > that means we could in fact add such a representation scheme.
> > 
> > > - Use a netlink representation as raw expression: meta@1,3,0x0x000000004
> > >   but this requires dumping the whole list of attributes which is chatty.
> > 
> > Yes.  Perhaps its better to consider adding a new tool (script?) that
> > can dump the netlink soup without interpretation.  IIRC libmnl debug
> > already provides this functionality.
> > 
> > Very chatty but it would be good enough to figure out what such
> > hypothetical raw client did.
> 
> I see, a binary netlink dump format.

Yes, kinda like objump/readelf.
