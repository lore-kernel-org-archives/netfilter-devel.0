Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA4119FA91
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2024 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719252890; cv=none; b=H1UJiHlZJmRNaHkhd/EzaFcBgLYxN+igIbgRCK4H2LF6FOuKE+aYid2Z+S7KPTloXI7g3WuDPgHfQDFV/IC3T8lB6yvHm34ruYEI60l8RAcWqBF3jVsFTIeQ7IF8wnRhiLn3jNU/1+tfaQY9R4ID0gltPgz9nkvHUfrE4b2z8BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719252890; c=relaxed/simple;
	bh=Rt4B4oGK7OyavFVr5W7OugEc7kybxtRlT+vjhxvuCgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGD2hgV5Vime1N0LazegMolEmG6DO538aXscdbwsdjKgWDkkM+r9+ShzWHffkOpV9ncSx9ogqjb2K2IvlN7y2hy/KigsOkMIdH/qDHa5jV+/IfsKqzMlIObICdmwtqQv92s4LyUO9qI10jHABBa64pm0bSRzzh/84ZK937MNwX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=50210 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sLoDB-005BUu-26; Mon, 24 Jun 2024 20:14:43 +0200
Date: Mon, 24 Jun 2024 20:14:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: let nftables indicate incomplete dissections
Message-ID: <Znm3kJtti8kJYtPu@calendula>
References: <20240612075013.GA13354@breakpoint.cc>
 <ZnFBQmrX9FgTG8rb@calendula>
 <20240618093135.GC12262@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240618093135.GC12262@breakpoint.cc>
X-Spam-Score: -1.8 (-)

Hi Florian,

On Tue, Jun 18, 2024 at 11:31:35AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > If backend (libnftl) could mark expressions as incomplete (from .parse
> > > callbacks?), it would be then possible for the frontend (nft) to document
> > > this, e.g. by adding something like "# unknown attributes", or similar.
> > 
> > ack, how do you plan to handle this?
> 
> Add a "bool incomplete" to libnftnl strnct nftnl_expr, then set it
> from each expr->parse callback if there is a new netlink attribute that
> we did not understand.
> 
> nft then checks if this is incomplete-marker is set.

Is this sufficient? There are attribute values that could have an
unknown/unsupported value, eg. exthdr type (assuming a new extension
is supported).

I am afraid setting incomplete for an unknown attribute also restricts
netlink extensibility.

Netlink allows for adding new attributes. Attributes also determine
semantics, eg. exthdr type restricts the semantics of other existing
attributes. There are also flags attributes which provide a hint on
what is support or not, toggling such flag allows kernel to reject
something that is not support.

> > > Related problem: entity that is using the raw netlink interface, it
> > > that case libnftnl might be able to parse everything but nft could
> > > lack the ability to properly print this.
> > 
> > There are two options here:
> > 
> > - Add more raw expressions and dump them, eg. meta@15, where 15 is the type.
> >   This is more compact. If there is a requirement to allow to restore
> >   this from older nftables versions, then it might be not enough since
> >   maybe there is a need for meta@type,somethingelse (as in the ct direction
> >   case).
> 
> Yes, for attributes that libnftnl knows about but where nft lacks a name
> mapping (i.e., we can decode its META_KEY 0x42 but we have no idea what
> that means we could in fact add such a representation scheme.
> 
> > - Use a netlink representation as raw expression: meta@1,3,0x0x000000004
> >   but this requires dumping the whole list of attributes which is chatty.
> 
> Yes.  Perhaps its better to consider adding a new tool (script?) that
> can dump the netlink soup without interpretation.  IIRC libmnl debug
> already provides this functionality.
> 
> Very chatty but it would be good enough to figure out what such
> hypothetical raw client did.

I see, a binary netlink dump format.

> > Or explore a combination of both.
> 
> Right.
> 
> > I am telling all this because I suspect maybe this "forward
> > compatibility" (a.k.a. "old tools support the future") could rise the
> > bar again and have a requirement to be able to load rulesets that
> > contains features that old tools don't understand.
> 
> Well, I don't think we can do that.  Perhaps with a new tool
> that allows to assemble raw expressions, but I'm not sure its worth
> extending nft for this, the parser (and grammar) is already huge.
>
> > > If noone has any objections, I would place this on my todo list and
> > > start with adding to libnftnl the needed "expression is incomplete"
> > > marking by extending the .parse callbacks.
> > 
> > Maybe it is worth exploring what I propose above instead of displaying
> > "expression is incomplete"?
> 
> For cases where libnftnl is fine but nft lacks a human-readable name I
> think such @meta,42 would be fine.
> 
> But I don't think its good to allow decoding something arbitary, I think
> we would have to acknowledge that this can't be done unless you have
> a textual parser for raw netlink descriptions (i.e., full/unreadable TLV soup).

I agree such netlink binary dump should be last resort.
