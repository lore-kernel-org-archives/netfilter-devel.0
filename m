Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ADD8287C
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 11:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796439; cv=none; b=Mp6SaihcFjL/uH4jPSWtDr2+abATNyTq0EzcMUWfPs3vxv4aDibFAUQ3BbKmPmjvjNE9E+AUJbJHLDRuwq7MuplFQnK/UkdR3xUJtHwlRRfiFUPAt8/D/ssteD/6DCQ0ylwvWDX5sWe7aEOakYnfkfd648XL6PL2wSKTV89TlfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796439; c=relaxed/simple;
	bh=cq0hiArB67Gh2+K1ohdg+b+ys5bNUnCwj9BiuJRUTEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyFjWebdfaSfsYBxXwXKdQuKNtrq5zV/DJx36PYjKaVXSfqt1tDos1mqv4YdaIkZQ5EgFIdK/6W9htt9h86mdvtMq6mkqdJrhwHwQ3x2JGowNqPdPpb+wOMki/7BNtoBXpK3V9YMTdLG+T9pVGNmqtsCemJVaomqNcdm40Kqxkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LF7XbLW7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LF7XbLW7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EN32iD+jVu4E4AK4VfDhmYK81cc+ftW5vYYEirM/MVo=; b=LF7XbLW7PVC0GJQsX3pANFr2GY
	gEi8XvRHzcaNN5J9VTZ++0IQFajJ/+1/4icBhSvIT19Wj+4Jz3rzN0So0b0JZ83tvBqAeRE+V6PE4
	++rJ4JcN8P9pwzSAx04pqFO6oD4RqBJdlTHO1zaTRXh8wxCDIk/4rS6iwr0sreeNutZ93A2gA/zm2
	I1sZgSrVxsvA3JCQ0BtmlTLHeaFRQ9B0mRBH4vrRg96w+WSKIIFdk73Dxlm3q8luGieJvOJ6vvN2k
	ARq5pHyoymWVhyT5AwC3qxw72yk/BHJrWjxfRykFapIfhmT5HgC7MbZaAEpe4GD6Tqro/ACshv6c9
	6DPuImFw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sJtT0-000000000NY-33mx;
	Wed, 19 Jun 2024 13:27:06 +0200
Date: Wed, 19 Jun 2024 13:27:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH v2 0/7] Dynamic hook interface binding
Message-ID: <ZnLAiiJJldqUXl_s@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
References: <20240517130615.19979-1-phil@nwl.cc>
 <ZnDCXfYr7qZ0bD9E@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnDCXfYr7qZ0bD9E@calendula>

On Tue, Jun 18, 2024 at 01:10:21AM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, May 17, 2024 at 03:06:08PM +0200, Phil Sutter wrote:
> > Changes since v1:
> > - New patch 6 adding notifications for updated hooks.
> > - New patch 7 adding the requested torture test.
> > 
> > Currently, netdev-family chains and flowtables expect their interfaces
> > to exist at creation time. In practice, this bites users of virtual
> > interfaces if these happen to be created after the nftables service
> > starts up and loads the stored ruleset.
> > 
> > Vice-versa, if an interface disappears at run-time (via module unloading
> > or 'ip link del'), it also disappears from the ruleset, along with the
> > chain and its rules which binds to it. This is at least problematic for
> > setups which store the running ruleset during system shutdown.
> 
> I'd suggest that you place your patch 2/7 to modify the existing
> behaviour in first place.

I did not to avoid "dead" entries in the hook list (with ops.dev gone,
there's nothing left identifying the hook). But it's only temporary and
maybe cleans up the diffs, will give it a go.

> > This series attempts to solve these problems by effectively making
> > netdev hooks name-based: If no matching interface is found at hook
> > creation time, it will be inactive until a matching interface appears.
> > If a bound interface is renamed, a matching inactive hook is searched
> > for it.
> > 
> > Ruleset dumps will stabilize in that regard. To still provide
> > information about which existing interfaces a chain/flowtable currently
> > binds to, new netlink attributes *_ACT_DEVS are introduced which are
> > filled from the active hooks only.
> 
> Currently, NFTA_HOOK_DEVS already represents the netdevice that are
> active. If one of these devices goes aways, then it is removed from
> the basechain and it does not show up in NFTA_HOOK_DEVS anymore.
> 
> There are netlink notifications that need to fit into NLMSG_GOODSIZE,
> but this adds yet another netlink array attribute.

Hmm. I could introduce NFTA_HOOK_INACTIVE_DEVS which contains only those
entries missing in NFTA_HOOK_DEVS. This shouldn't bloat the dumps too
much (apart from the added overhead) and won't change old user space
behaviour.

> I think we cannot escape adding new commands such as:
> 
> NFT_MSG_NEWDEVICE
> NFT_MSG_GETDEVICE
> NFT_MSG_DELDEVICE
> 
> to populate the basechain/flowtable, those can be used only if the
> "subscription" mecanism is used, so older kernels still rely in
> NFTA_HOOK_DEVS (older-older kernels actually already deal with
> NFTA_HOOK_DEV only...).

Why can't they co-exist? I.e., NFTA_HOOK_DEV{,S} continues to behave as
before and NEWDEV/DELDEV modify the list of existing chains/flowtables.
An explicit GETDEV to dump currently active interfaces seems reasonable,
especially with wildcard specifiers in mind.

> NFT_MSG_NEWDEVICE can provide a flag to specify this is a wildcard
> or exact matching.

I had the same mechanism we use for wildcard ifname matching in mind
which is to specify a name length which either includes or excludes the
terminating NUL-char. Using strncmp() is sufficient then. Or do you
think more advanced (e.g. "enp*s0") wildcards are useful?

> There is also a need for a netlink attribute to specify if this is
> adding a device to a chain or flowtable.

Since one has to specify the specific chain or flowtable to add to
anyway, one could just add NFTA_DEV_CHAIN and NFTA_DEV_FLOWTABLE
attributes, which are mutually exclusive and together with
NFTA_DEV_TABLE identify the object to manipulate.

> With these new commands, the NFT_NETDEVICE_MAX cap can also go away in
> newer kernels with a command like this:
> 
>         nft add device flowtable ip x y { a, b, c }
>         nft add device chain ip x y { a, b, c }
> 
> which expands to one one NFT_MSG_* message for each item.
> 
> Then, the nested notation will need to detect what to use depending on
> the user input:
> 
>         table netdev x {
>                 chain y {
>                         type filter hook ingress devices = { tap* } priority 0
>                 }
>         }
> 
> this triggers the new commands path, same if the list of devices goes
> over NFT_NETDEVICE_MAX (256).

This is for user space to remain compatible to older kernels, right?

> This can also help incrementally report on new devices that match on a
> given "subscription pattern" via new NFT_MSG_NEWDEVICE command for
> monitoring purpose.

Yes, adding NEWDEV/DELDEV notifications is a nice approach!

> Maybe a command like:
> 
>         nft list device chain ip x y
> 
> could be used to list the existing devices that are "active" as per
> your definition, so:
> 
>         nft list ruleset
> 
> does not show the listing of "active" devices that expand to tap*,
> because this is only informational (not really required to restore a
> ruleset), I guess the user only wants this to inspect to make sure
> what devices are registered to the given tap* pattern.

ACK.

> There is also another case that would need to be handled:
> 
>         - chain A with device tap0
>         - chain B with wildcard device tap*
> 
> I would expect a "exclude" clause for the wildcard case will come
> sooner or later to define a different policy for a specify chain.
> The new specific command approach would be extensible in that sense.

As a first implementation, I would just forbid such combinations.
Assuming "tap*" is just "tap" with length 3 and "tap0" is "tap0\0" with
length 5, modifying the duplicate hook check in
nf_tables_parse_netdev_hooks() to perform a strncmp(namea, nameb,
min(lena, lenb)) should suffice.

Another option avoiding maintenance of an exclusion list would be to
just add a new interface to the first chain/flowtable with matching hook
in the list. This should work since 'nft list ruleset' does not sort the
ruleset, so 'add chain t b; add chain t a' is a meaningful difference to
'add chain t a; add chain t b'.

The exclusion list approach either means tracking a list of active
hooks' matching names in each wildcard hook or some preference when
searching a hook for a new interface. All this may become increasingly
complicated by stuff like one hook for 'eth*' and another for 'et*'.

> > This series is also prep work for a simple wildcard interface binding
> > similar to the wildcard interface matching in meta expression. It should
> > suffice to turn struct nft_hook::ops into an array of all matching
> > interfaces, but the respective code does not exist yet.
> 
> I think this series is all about this wildcard interface matching,
> which is not coming explicitly.

My motivation for this series is an open ticket complaining about the
inability to define a flowtable for an interface which is created by
NetworkManager (which depends on nftables service for startup).

A related (but not complained so far) issue is in reverse direction: If
the interface vanishes before nftables service saves the ruleset upon
shutdown, the dump will be incomplete.

I consider wildcard interface hooks merely a (nice) side-effect from
fixing the above. Which should not require too much additional work.

Thanks for your review,

Phil
