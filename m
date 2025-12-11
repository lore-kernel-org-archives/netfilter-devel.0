Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A3A3B8D5D
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 00:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765413156; cv=none; b=JHLF318KhOARyyiDYUzRtUHXjnIfEhYPn5RNyvIx9Lr36Gk6zgNbKVfYzVKCYe3iLOVXSdxGg/psLndYshKoRGSnELTTn5aFzQ4lxPvE3Pu5csnp+ZOFi9qejY4VhPFs6MXRWiUiKOp5OPIllsnXDRCHM/xaZfM7mjCAFGIlCe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765413156; c=relaxed/simple;
	bh=nYKCLElM8av/eRDDNiNjkH4/Q6s/oS/AyW4VnGlVxws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtd+RWOHOIS5ejiGJcid5BAKE+syAvh+rP3Brae4V9coYboSQrl/UZ0dgr55yrBhTDzQrl4NdQ2Puh2LHa0em7nRiP8Qdj1XZKBZrHX3xZd8RdsE/wPSjmc4HNUIDDOKdSwIdRXFJYRXv9JB2Z63u88WAFOaefsHI1KQ6e3mA2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gsAdZHFu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gsAdZHFu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wjMqnHLGQeOaVpE4WejEaYQnqVVdn3rayZpzJOmjY0Y=; b=gsAdZHFuviqrf9TDHAxIglm+ab
	z9ZIdK1+CEQ2QfoXhgc2yTc0qj1kzX4/O4JGwZuveTOXTS7HEpem3XWiGnDWJg093K/cooTekc08h
	9+txo+plGeqsIXQuez0VT4Jlsihr9fKRmgPzeWq9EOVGG1fY0lQIr1h7KibIMHqpbLZ7/a1QXueGK
	t+TZqk+YVhqGnSjCzdnyFKzFzx5NMdV/0d/54MsDsejeYrHj3fxjsHC0NN/UVYZ0dqdy4dSuQ1TIV
	c8L/eOaZD9pl1IO4ggDMTCLAGjTgm/K+N4n8Ztb4Eo8jX/mE0mFsQf4K5WE7BlOmQ1MCztn5SApfh
	gI+TYbEg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vTUbe-000000000Ud-3fx7;
	Thu, 11 Dec 2025 01:32:30 +0100
Date: Thu, 11 Dec 2025 01:32:30 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH] datatype: Accept IPv4 addresses for ip6addr_type
Message-ID: <aToRHispbspGtCY0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20251210214945.31389-1-phil@nwl.cc>
 <aTnvXiYTlQtqVvug@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTnvXiYTlQtqVvug@strlen.de>

On Wed, Dec 10, 2025 at 11:08:30PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Complement on-demand ip {s,d}addr expression conversion to IPv4-mapped
> > IPv6 by accepting IPv4 addresses in places where an IPv6 one is
> > expected. This way users don't have to use IPv4-mapped notation when
> > populating sets.
> > 
> > In order to avoid chaos and breakage, prevent host names (temporarily)
> > resolving to IPv4 addresses only from being accepted as IPv6 address.
> > Map IPv4 addresses only if users explicitly specified them.
> 
> There is a usability issue here that I did not consider.
> 
> > -dnat ip6 to 1.2.3.4;fail
> > +dnat ip6 to 1.2.3.4;ok;dnat ip6 to ::ffff:1.2.3.4
> 
> Pablo, what do you think about this?
> 
> I think nft should always return an error here.
> I don't see how this makes sense (implicit dnat to a
> mapped address).
> 
> Phil/Pablo, do you see a way to limit the 1.2.3.4 -> ::ffff:1.2.3.4
> expansion to 'add element' ?

It might be possible for dnat statement to set a flag in eval phase
controlling ip6addr_type_parse() strictness. This should work even with
an anonymous map, e.g.

| dnat ip6 to ip6 saddr map { fec0::1 : 1.2.3.4 }

But this could also be a named map and we probably don't want to check
how it's used before accepting an element.

So all this kind of opens pandora's box and we probably either have to
accept the new ways for users to shoot their feet or:

> Alternatively we could just force users to manually expand the address
> when adding ipv4 addresses to ip6_addr sets, but I think its cumbersome.

Cheers, Phil
