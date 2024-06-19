Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACED715216E
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812779; cv=none; b=lC+SOfWe2g/up/1P4ti1XZ2YADXo1h4wYB4m5kyrlYTxf8XEdgLzwlBfNkqUNOPJePxvM8+3e4vXNCz5XPPG8U8FvBfh2PVWFI92LKl7V6tZ8IHnaMQzGhRZNPZPzNyhGfcJ6+v6UWFpyaqIDUPJolWfx5qTMD/PPSjR3Q59Ajw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812779; c=relaxed/simple;
	bh=HRyamxkpMOyxQMlOB86Jr/TfOXphtDuf9r5Z7uaVFUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NI+Oydgrb5IDmuh+zdcrYjas6Ia5NiWhrgGv3xz/X8xzS/bcxuvhG/14/bzeP0sQJ5E1LTUjxomMDL9wGv/M5jJT3niiAzyuxvlfuoejYHkGydZMSVCokKdF742gijXw6tS1DA7mygn5pdeCx5o+vuwTst4t2XIveKVrw27BzbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U+3aahwd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U+3aahwd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ApsgCKfnV9/CIXTcU0h5aA62zqlW962lJ0/rf8sAmYg=; b=U+3aahwdD3e9g2kTioINnaFGaP
	9E/wx4twxWbwg8AvYlC/K8j4pNb8K4lFr1WNuySiZ6dItiovjGGW+Wfl23YZE9cYXw0EUIUXK4pKH
	Td24uZ0xlTg1rgpsguolnMl8qAPgkwf9Ac03fJ+2ERTchjEA15omUVGV+UC1psVGvWwqz1oQilTg9
	zNvyXpiVrBJbUtodnHxCN+MzgYGF0IOJYGDMuS2YsROpr2XxwmLMTOLANgA/rpi22iBKzx2082+ER
	CBrMPw0MLbNPirWzNT8T081BCVRke3HVJfqJQ4/+PYGJDP/bF/MBatjW3ekc6CvrK4OLoZf2q/0la
	W60ndtyg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sJxie-000000003Ez-3Xko;
	Wed, 19 Jun 2024 17:59:32 +0200
Date: Wed, 19 Jun 2024 17:59:32 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH v2 0/7] Dynamic hook interface binding
Message-ID: <ZnMAZPn263VZWaPd@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
References: <20240517130615.19979-1-phil@nwl.cc>
 <ZnDCXfYr7qZ0bD9E@calendula>
 <ZnLAiiJJldqUXl_s@orbyte.nwl.cc>
 <ZnLvw0MbcL81GUrc@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnLvw0MbcL81GUrc@calendula>

On Wed, Jun 19, 2024 at 04:48:35PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 19, 2024 at 01:27:06PM +0200, Phil Sutter wrote:
> > On Tue, Jun 18, 2024 at 01:10:21AM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Fri, May 17, 2024 at 03:06:08PM +0200, Phil Sutter wrote:
> > > > Changes since v1:
> > > > - New patch 6 adding notifications for updated hooks.
> > > > - New patch 7 adding the requested torture test.
> > > > 
> > > > Currently, netdev-family chains and flowtables expect their interfaces
> > > > to exist at creation time. In practice, this bites users of virtual
> > > > interfaces if these happen to be created after the nftables service
> > > > starts up and loads the stored ruleset.
> > > > 
> > > > Vice-versa, if an interface disappears at run-time (via module unloading
> > > > or 'ip link del'), it also disappears from the ruleset, along with the
> > > > chain and its rules which binds to it. This is at least problematic for
> > > > setups which store the running ruleset during system shutdown.
> > > 
> > > I'd suggest that you place your patch 2/7 to modify the existing
> > > behaviour in first place.
> > 
> > I did not to avoid "dead" entries in the hook list (with ops.dev gone,
> > there's nothing left identifying the hook). But it's only temporary and
> > maybe cleans up the diffs, will give it a go.
> 
> OK.
> 
> > > > This series attempts to solve these problems by effectively making
> > > > netdev hooks name-based: If no matching interface is found at hook
> > > > creation time, it will be inactive until a matching interface appears.
> > > > If a bound interface is renamed, a matching inactive hook is searched
> > > > for it.
> > > > 
> > > > Ruleset dumps will stabilize in that regard. To still provide
> > > > information about which existing interfaces a chain/flowtable currently
> > > > binds to, new netlink attributes *_ACT_DEVS are introduced which are
> > > > filled from the active hooks only.
> > > 
> > > Currently, NFTA_HOOK_DEVS already represents the netdevice that are
> > > active. If one of these devices goes aways, then it is removed from
> > > the basechain and it does not show up in NFTA_HOOK_DEVS anymore.
> > > 
> > > There are netlink notifications that need to fit into NLMSG_GOODSIZE,
> > > but this adds yet another netlink array attribute.
> > 
> > Hmm. I could introduce NFTA_HOOK_INACTIVE_DEVS which contains only those
> > entries missing in NFTA_HOOK_DEVS. This shouldn't bloat the dumps too
> > much (apart from the added overhead) and won't change old user space
> > behaviour.
> 
> Not sure. What does NFTA_HOOK_INACTIVE_DEVS contains? Could you
> provide an example? Again, if this array gets again too large, there
> could be issues with NLMSG_GOODSIZE again for notifications.

I assumed your intention was for NFTA_HOOK_DEVS to not change
semantically, i.e. remain to contain only devices which are present at
time of the dump. Then I could introduce INACTIVE_DEVS to contain those
we lost meanwhile. As an example:

1) add netdev chain for devices eth0, eth1, eth2
2) list ruleset:
   - HOOK_DEVS = { eth0, eth1, eth2 }
   - INACTIVE_DEVS = {}
3) ip link del eth1
4) list ruleset:
   - HOOK_DEVS = { eth0, eth2 }
   - INACTIVE_DEVS = { eth1 }

This avoids duplicate entries in both lists and thus avoids overhead.
This would fix for the interfaces missing in dumps problem.

Wildcards would appear as-is in either HOOK_DEVS (if there's at least
one matching interface) or INACTIVE_DEVS (if there is none). The actual
list of active interfaces would require a GETDEVICE call.

> I would just display these active devices (in the list of devices that
> are attached to this basechain) via the new command _GETDEV that we
> are discussing below? These netdevices that match the pattern come and
> go, I guess user only wants to make sure they are actually registered
> to this hook for diagnostics, showing an exact match, ie. tap0, or
> inexact match, ie. tap* should be should when listing the ruleset IMO.

OK, let's see if I can sum this up correctly:

1) NFTA_HOOK_DEVS is changed to always reflect what the user specified
2) Interfaces being removed or added trigger NEWDEV/DELDEV notifications
3) Active hooks are dumped by GETDEV netlink request
4) NEWDEV/DELDEV netlink requests/responses added to cover for oversized
chains/flowtables

You're saying we have to use (4) for wildcard interfaces, too. Is this
to keep them away from NFTA_HOOK_DEVS? Because in theory 1-3 are
sufficient for wildcards, too.

> > > I think we cannot escape adding new commands such as:
> > > 
> > > NFT_MSG_NEWDEVICE
> > > NFT_MSG_GETDEVICE
> > > NFT_MSG_DELDEVICE
> > > 
> > > to populate the basechain/flowtable, those can be used only if the
> > > "subscription" mecanism is used, so older kernels still rely in
> > > NFTA_HOOK_DEVS (older-older kernels actually already deal with
> > > NFTA_HOOK_DEV only...).
> > 
> > Why can't they co-exist? I.e., NFTA_HOOK_DEV{,S} continues to behave as
> > before and NEWDEV/DELDEV modify the list of existing chains/flowtables.
> > An explicit GETDEV to dump currently active interfaces seems reasonable,
> > especially with wildcard specifiers in mind.
> 
> yes, NFTA_HOOK_DEVS and these new commands need to coexist, there is
> no other way to retain backward compatibility.
> 
> > > NFT_MSG_NEWDEVICE can provide a flag to specify this is a wildcard
> > > or exact matching.
> > 
> > I had the same mechanism we use for wildcard ifname matching in mind
> > which is to specify a name length which either includes or excludes the
> > terminating NUL-char. Using strncmp() is sufficient then.
> 
> That's fine.
> 
> > Or do you think more advanced (e.g. "enp*s0") wildcards are useful?
> 
> I prefer future does not bring "enp*s0", but let's agree on an API
> that can be extended to accomodate new requirements, that's my only
> comment in this regard.
> 
> > > There is also a need for a netlink attribute to specify if this is
> > > adding a device to a chain or flowtable.
> > 
> > Since one has to specify the specific chain or flowtable to add to
> > anyway, one could just add NFTA_DEV_CHAIN and NFTA_DEV_FLOWTABLE
> > attributes, which are mutually exclusive and together with
> > NFTA_DEV_TABLE identify the object to manipulate.
> 
> Right.
> 
> > > With these new commands, the NFT_NETDEVICE_MAX cap can also go away in
> > > newer kernels with a command like this:
> > > 
> > >         nft add device flowtable ip x y { a, b, c }
> > >         nft add device chain ip x y { a, b, c }
> > > 
> > > which expands to one one NFT_MSG_* message for each item.
> > > 
> > > Then, the nested notation will need to detect what to use depending on
> > > the user input:
> > > 
> > >         table netdev x {
> > >                 chain y {
> > >                         type filter hook ingress devices = { tap* } priority 0
> > >                 }
> > >         }
> > > 
> > > this triggers the new commands path, same if the list of devices goes
> > > over NFT_NETDEVICE_MAX (256).
> > 
> > This is for user space to remain compatible to older kernels, right?
> 
> Yes.
> 
> > > This can also help incrementally report on new devices that match on a
> > > given "subscription pattern" via new NFT_MSG_NEWDEVICE command for
> > > monitoring purpose.
> > 
> > Yes, adding NEWDEV/DELDEV notifications is a nice approach!
> 
> This will also help to remove the existing NFT_NETDEVICE_MAX limit.
> 
> > > Maybe a command like:
> > > 
> > >         nft list device chain ip x y
> > > 
> > > could be used to list the existing devices that are "active" as per
> > > your definition, so:
> > > 
> > >         nft list ruleset
> > > 
> > > does not show the listing of "active" devices that expand to tap*,
> > > because this is only informational (not really required to restore a
> > > ruleset), I guess the user only wants this to inspect to make sure
> > > what devices are registered to the given tap* pattern.
> > 
> > ACK.
> > 
> > > There is also another case that would need to be handled:
> > > 
> > >         - chain A with device tap0
> > >         - chain B with wildcard device tap*
> > > 
> > > I would expect a "exclude" clause for the wildcard case will come
> > > sooner or later to define a different policy for a specify chain.
> > > The new specific command approach would be extensible in that sense.
> > 
> > As a first implementation, I would just forbid such combinations.
> > Assuming "tap*" is just "tap" with length 3 and "tap0" is "tap0\0" with
> > length 5, modifying the duplicate hook check in
> > nf_tables_parse_netdev_hooks() to perform a strncmp(namea, nameb,
> > min(lena, lenb)) should suffice.
> 
> That is fine to ensure a given basechain does not have both tap0 and tap*

Ah, I missed that nf_tables_parse_netdev_hooks() merely searches the
current list for duplicate entries, not all chains'/flowtables' ones.

Hmm. I can create multiple netdev chains attaching to the same
interfaces, but only a single flowtable. Is this intentional?

> > Another option avoiding maintenance of an exclusion list would be to
> > just add a new interface to the first chain/flowtable with matching hook
> > in the list. This should work since 'nft list ruleset' does not sort the
> > ruleset, so 'add chain t b; add chain t a' is a meaningful difference to
> > 'add chain t a; add chain t b'.
> > 
> > The exclusion list approach either means tracking a list of active
> > hooks' matching names in each wildcard hook or some preference when
> > searching a hook for a new interface. All this may become increasingly
> > complicated by stuff like one hook for 'eth*' and another for 'et*'.
> > 
> > > > This series is also prep work for a simple wildcard interface binding
> > > > similar to the wildcard interface matching in meta expression. It should
> > > > suffice to turn struct nft_hook::ops into an array of all matching
> > > > interfaces, but the respective code does not exist yet.
> > > 
> > > I think this series is all about this wildcard interface matching,
> > > which is not coming explicitly.
> > 
> > My motivation for this series is an open ticket complaining about the
> > inability to define a flowtable for an interface which is created by
> > NetworkManager (which depends on nftables service for startup).
> > 
> > A related (but not complained so far) issue is in reverse direction: If
> > the interface vanishes before nftables service saves the ruleset upon
> > shutdown, the dump will be incomplete.
> >
> > I consider wildcard interface hooks merely a (nice) side-effect from
> > fixing the above. Which should not require too much additional work.
> 
> OK.
> 
> Thanks.
> 
