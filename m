Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBF51428E6
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718808528; cv=none; b=uMLDRrSiYgWhrhR0/vTnHqKt7znMdB55W+xyXHB4o7GGUNlsIsBhosL2h1Pn4E4Jfclv0Bs3rRkkG3ijnDXy0h8lvF7OMdDIhpn96WvueO04m92i9gpbym+6hdCDxNjTT5dZXK/uEAqj5FxF6T7o2x5oZbKQsQWjpHr+NBwUBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718808528; c=relaxed/simple;
	bh=lh92JGSv8xCcwAyLRiD2968GcmM1u8g3Q4SDBQJ9e5A=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQf2Sza/RdYEJhOY5gzs36QYWd9D3PCPRX0QgYRgW2YDmyol/+xmOhjJJgndmKJpfZWriMnwq4Ncyrj1GASBK/zDau5HXpAeFpIHK21PxACqnUDwrIh0VCTQBq733sndSiQmWVK0LW6jjegLEk/f8d70NOUTt5uVN7u1G+oleUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57768 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJwc0-00FBB2-QN; Wed, 19 Jun 2024 16:48:39 +0200
Date: Wed, 19 Jun 2024 16:48:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH v2 0/7] Dynamic hook interface binding
Message-ID: <ZnLvw0MbcL81GUrc@calendula>
References: <20240517130615.19979-1-phil@nwl.cc>
 <ZnDCXfYr7qZ0bD9E@calendula>
 <ZnLAiiJJldqUXl_s@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnLAiiJJldqUXl_s@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Wed, Jun 19, 2024 at 01:27:06PM +0200, Phil Sutter wrote:
> On Tue, Jun 18, 2024 at 01:10:21AM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Fri, May 17, 2024 at 03:06:08PM +0200, Phil Sutter wrote:
> > > Changes since v1:
> > > - New patch 6 adding notifications for updated hooks.
> > > - New patch 7 adding the requested torture test.
> > > 
> > > Currently, netdev-family chains and flowtables expect their interfaces
> > > to exist at creation time. In practice, this bites users of virtual
> > > interfaces if these happen to be created after the nftables service
> > > starts up and loads the stored ruleset.
> > > 
> > > Vice-versa, if an interface disappears at run-time (via module unloading
> > > or 'ip link del'), it also disappears from the ruleset, along with the
> > > chain and its rules which binds to it. This is at least problematic for
> > > setups which store the running ruleset during system shutdown.
> > 
> > I'd suggest that you place your patch 2/7 to modify the existing
> > behaviour in first place.
> 
> I did not to avoid "dead" entries in the hook list (with ops.dev gone,
> there's nothing left identifying the hook). But it's only temporary and
> maybe cleans up the diffs, will give it a go.

OK.

> > > This series attempts to solve these problems by effectively making
> > > netdev hooks name-based: If no matching interface is found at hook
> > > creation time, it will be inactive until a matching interface appears.
> > > If a bound interface is renamed, a matching inactive hook is searched
> > > for it.
> > > 
> > > Ruleset dumps will stabilize in that regard. To still provide
> > > information about which existing interfaces a chain/flowtable currently
> > > binds to, new netlink attributes *_ACT_DEVS are introduced which are
> > > filled from the active hooks only.
> > 
> > Currently, NFTA_HOOK_DEVS already represents the netdevice that are
> > active. If one of these devices goes aways, then it is removed from
> > the basechain and it does not show up in NFTA_HOOK_DEVS anymore.
> > 
> > There are netlink notifications that need to fit into NLMSG_GOODSIZE,
> > but this adds yet another netlink array attribute.
> 
> Hmm. I could introduce NFTA_HOOK_INACTIVE_DEVS which contains only those
> entries missing in NFTA_HOOK_DEVS. This shouldn't bloat the dumps too
> much (apart from the added overhead) and won't change old user space
> behaviour.

Not sure. What does NFTA_HOOK_INACTIVE_DEVS contains? Could you
provide an example? Again, if this array gets again too large, there
could be issues with NLMSG_GOODSIZE again for notifications.

I would just display these active devices (in the list of devices that
are attached to this basechain) via the new command _GETDEV that we
are discussing below? These netdevices that match the pattern come and
go, I guess user only wants to make sure they are actually registered
to this hook for diagnostics, showing an exact match, ie. tap0, or
inexact match, ie. tap* should be should when listing the ruleset IMO.

> > I think we cannot escape adding new commands such as:
> > 
> > NFT_MSG_NEWDEVICE
> > NFT_MSG_GETDEVICE
> > NFT_MSG_DELDEVICE
> > 
> > to populate the basechain/flowtable, those can be used only if the
> > "subscription" mecanism is used, so older kernels still rely in
> > NFTA_HOOK_DEVS (older-older kernels actually already deal with
> > NFTA_HOOK_DEV only...).
> 
> Why can't they co-exist? I.e., NFTA_HOOK_DEV{,S} continues to behave as
> before and NEWDEV/DELDEV modify the list of existing chains/flowtables.
> An explicit GETDEV to dump currently active interfaces seems reasonable,
> especially with wildcard specifiers in mind.

yes, NFTA_HOOK_DEVS and these new commands need to coexist, there is
no other way to retain backward compatibility.

> > NFT_MSG_NEWDEVICE can provide a flag to specify this is a wildcard
> > or exact matching.
> 
> I had the same mechanism we use for wildcard ifname matching in mind
> which is to specify a name length which either includes or excludes the
> terminating NUL-char. Using strncmp() is sufficient then.

That's fine.

> Or do you think more advanced (e.g. "enp*s0") wildcards are useful?

I prefer future does not bring "enp*s0", but let's agree on an API
that can be extended to accomodate new requirements, that's my only
comment in this regard.

> > There is also a need for a netlink attribute to specify if this is
> > adding a device to a chain or flowtable.
> 
> Since one has to specify the specific chain or flowtable to add to
> anyway, one could just add NFTA_DEV_CHAIN and NFTA_DEV_FLOWTABLE
> attributes, which are mutually exclusive and together with
> NFTA_DEV_TABLE identify the object to manipulate.

Right.

> > With these new commands, the NFT_NETDEVICE_MAX cap can also go away in
> > newer kernels with a command like this:
> > 
> >         nft add device flowtable ip x y { a, b, c }
> >         nft add device chain ip x y { a, b, c }
> > 
> > which expands to one one NFT_MSG_* message for each item.
> > 
> > Then, the nested notation will need to detect what to use depending on
> > the user input:
> > 
> >         table netdev x {
> >                 chain y {
> >                         type filter hook ingress devices = { tap* } priority 0
> >                 }
> >         }
> > 
> > this triggers the new commands path, same if the list of devices goes
> > over NFT_NETDEVICE_MAX (256).
> 
> This is for user space to remain compatible to older kernels, right?

Yes.

> > This can also help incrementally report on new devices that match on a
> > given "subscription pattern" via new NFT_MSG_NEWDEVICE command for
> > monitoring purpose.
> 
> Yes, adding NEWDEV/DELDEV notifications is a nice approach!

This will also help to remove the existing NFT_NETDEVICE_MAX limit.

> > Maybe a command like:
> > 
> >         nft list device chain ip x y
> > 
> > could be used to list the existing devices that are "active" as per
> > your definition, so:
> > 
> >         nft list ruleset
> > 
> > does not show the listing of "active" devices that expand to tap*,
> > because this is only informational (not really required to restore a
> > ruleset), I guess the user only wants this to inspect to make sure
> > what devices are registered to the given tap* pattern.
> 
> ACK.
> 
> > There is also another case that would need to be handled:
> > 
> >         - chain A with device tap0
> >         - chain B with wildcard device tap*
> > 
> > I would expect a "exclude" clause for the wildcard case will come
> > sooner or later to define a different policy for a specify chain.
> > The new specific command approach would be extensible in that sense.
> 
> As a first implementation, I would just forbid such combinations.
> Assuming "tap*" is just "tap" with length 3 and "tap0" is "tap0\0" with
> length 5, modifying the duplicate hook check in
> nf_tables_parse_netdev_hooks() to perform a strncmp(namea, nameb,
> min(lena, lenb)) should suffice.

That is fine to ensure a given basechain does not have both tap0 and tap*

> Another option avoiding maintenance of an exclusion list would be to
> just add a new interface to the first chain/flowtable with matching hook
> in the list. This should work since 'nft list ruleset' does not sort the
> ruleset, so 'add chain t b; add chain t a' is a meaningful difference to
> 'add chain t a; add chain t b'.
> 
> The exclusion list approach either means tracking a list of active
> hooks' matching names in each wildcard hook or some preference when
> searching a hook for a new interface. All this may become increasingly
> complicated by stuff like one hook for 'eth*' and another for 'et*'.
> 
> > > This series is also prep work for a simple wildcard interface binding
> > > similar to the wildcard interface matching in meta expression. It should
> > > suffice to turn struct nft_hook::ops into an array of all matching
> > > interfaces, but the respective code does not exist yet.
> > 
> > I think this series is all about this wildcard interface matching,
> > which is not coming explicitly.
> 
> My motivation for this series is an open ticket complaining about the
> inability to define a flowtable for an interface which is created by
> NetworkManager (which depends on nftables service for startup).
> 
> A related (but not complained so far) issue is in reverse direction: If
> the interface vanishes before nftables service saves the ruleset upon
> shutdown, the dump will be incomplete.
>
> I consider wildcard interface hooks merely a (nice) side-effect from
> fixing the above. Which should not require too much additional work.

OK.

Thanks.
