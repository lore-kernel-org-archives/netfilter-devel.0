Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4A916193C
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 10:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724064969; cv=none; b=O5OhKHNIlLS5R7LNlQ0e5DVYgnfFXkcXvdyQ3Nr+DmMDbMCbuRnIqcD27rGqUFZbjZ8ZckOf3wWCx6bHLpdns1mn1UQskYst246rnn3bLaSndx7W5kVezC0C0Zs0uTdXbfekNFRj4jG8VBe43MKGxymsK5HXinVEPFFdLvzpV8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724064969; c=relaxed/simple;
	bh=cPrMLj0qMKNX4As+L8UJTPXx/2quL2MPIYj27r3rcTk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZSypxRnDbB6HB42h9gxMNXPRJ8P0AZGVUIXrxtkL5aRSIWVGe6oHd0zUzKzRAK2DVOp0rsZCgzvoK2jF9vtBQyLEGHKlX9/RwsyYAX0wDoP5RaXhAjQZuf7JN3pQGBWTASVO0E+iLM3VVox6UjToOL4muIbJXfVuU77kxLmXwds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38402 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg03N-005DEe-Rv; Mon, 19 Aug 2024 12:56:04 +0200
Date: Mon, 19 Aug 2024 12:56:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <ZsMkwTdIp1hYWBXt@calendula>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
 <ZqbR0yOY87wI0VoS@calendula>
 <20240728233736.GA31560@breakpoint.cc>
 <ZqbgmMzuOQShJWXK@calendula>
 <20240729153211.GA26048@breakpoint.cc>
 <Zrs-STpwUN2rqnl2@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zrs-STpwUN2rqnl2@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil, Florian,

@Florian, could you push out what you have to flush your queue in this front?

On Tue, Aug 13, 2024 at 01:06:49PM +0200, Phil Sutter wrote:
> On Mon, Jul 29, 2024 at 05:32:11PM +0200, Florian Westphal wrote:
> [...]
> Let me suggest a deviation which seems more user-friendly:
> 
> > 1. nft list hooks
> >   dump everything EXCEPT netdev families/devices
> 
> Include netdev here, make it really list *all* hooks. Iterating over
> the list of currently existing NICs in this netns is no big deal, is
> it?

I like this suggestion.

I think it should be possible to incrementally extend with these
suggestions, it should be possible to submit patches for your review.

> > 2. nft list hooks netdev device foo
> >    dump ingress/egress netdev hooks,
> >    INCLUDING inet ingress (its scoped to the device).
> 
> Drop 'netdev' from the syntax here. The output really is "all hooks
> specific to that NIC", not necessarily only netdev ones. (And "device"
> is a distinct identifier for network interfaces in nftables syntax.)

I think allowing 'device foo' without family would be good.

> > 3. nft list hooks arp
> >    dump arp input and output, if any
> > 4. nft list hooks bridge
> >    dump bridge pre/input/forward/out/postrouting
> > 5. nft list hooks ip
> >    dump ip pre/input/forward/out/postrouting
> > 6. nft list hooks ip6 -> see above
> > 7. nft list hooks inet -> alias for dumping both ip+ip6 hooks.
> 
> I wonder if this is more confusing than not - on the netfilter hooks
> layer, it doesn't quite exist. The only thing which persists a tad
> longer is inet ingress, indicated by nf_register_net_hook() passing it
> down to __nf_register_net_hook for nf_hook_entry_head() to return the
> same value as for netdev ingress. I guess they could be spliced even
> further up.

inet is an "alias". I think dumpg both ip+ip6 hooks should be fine.

> > This also means that i'd make 'inet device foo' return a warning
> > that the device will be ignored because "inet ingress" is syntactic
> > frontend sugar similar to inet pseudo-family.
> 
> Iff my claim holds true, there is no such thing as an inet hook and
> thus also no inet device one. :)
> 
> > We could try the 'detect pipeline' later.  But, as per example
> > above, I don't think its easy, unless one omits all packet rewrites
> > (stateless nat, dnat, redirect) and everything else that causes
> > re-routing, e.g. policy routing, tproxy, tc(x), etc.
> > 
> > And then there is l3 and l2 multicasting...
> > 
> > But, admittingly, it might be nice to have something and it might be
> > good enough if pipeline alterations by ruleset and other entities
> > are omitted.
> 
> I seem to recall us discussing something like that on NFWS, but to
> simulate traversal of a packet with given properties through the
> ruleset. Which would also identify the hooks involved, I guess?

Yes, this all is more complicated and it needs a whole lot of work to
add this feature in a complete way, which makes sense to schedule this
for the _future_.
