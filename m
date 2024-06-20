Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B367C1A4F11
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 09:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718875851; cv=none; b=Se79jDCZwE4W4wegLFlSqBsolCVNSTSvQl2MVe8vzGiRRPgl2HTN2lqZqReV/CguFYLObQKRptbOCi4cLlqHyJyHwUVKkv4PBNRKl3XsEJWuECn71F14sz1bXPI2G9VBWb1U+PVe+x0NgqYUH5V/eCQ+VISrICH3mG6DCW5jIRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718875851; c=relaxed/simple;
	bh=flvjLcXoVY51KG2y7bNtnSc3hGoWC6Snd8kMUN/MSQk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhCw4TtY/twBKdKhJENv94w7k9HM5L5wskPVVBlMmBJi95y3miCe2TgIS/Q3wTmWj/OX774UfFadunZcGjNThv6KHPd1CHQqnD/aiFaOAVSmha+2WZ9Ve0DCe/zUFVobzKdIPyvdKwtcb0gLmpMkXVSAzcMFwxIqEeVdeWXFtzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38574 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sKE7v-00GLTJ-Ku; Thu, 20 Jun 2024 11:30:46 +0200
Date: Thu, 20 Jun 2024 11:30:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH v2 0/7] Dynamic hook interface binding
Message-ID: <ZnP2wloF4FF3bFHW@calendula>
References: <20240517130615.19979-1-phil@nwl.cc>
 <ZnDCXfYr7qZ0bD9E@calendula>
 <ZnLAiiJJldqUXl_s@orbyte.nwl.cc>
 <ZnLvw0MbcL81GUrc@calendula>
 <ZnMAZPn263VZWaPd@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnMAZPn263VZWaPd@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Wed, Jun 19, 2024 at 05:59:32PM +0200, Phil Sutter wrote:
> On Wed, Jun 19, 2024 at 04:48:35PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jun 19, 2024 at 01:27:06PM +0200, Phil Sutter wrote:
> > > On Tue, Jun 18, 2024 at 01:10:21AM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, May 17, 2024 at 03:06:08PM +0200, Phil Sutter wrote:
[...]
> > > > > This series attempts to solve these problems by effectively making
> > > > > netdev hooks name-based: If no matching interface is found at hook
> > > > > creation time, it will be inactive until a matching interface appears.
> > > > > If a bound interface is renamed, a matching inactive hook is searched
> > > > > for it.
> > > > > 
> > > > > Ruleset dumps will stabilize in that regard. To still provide
> > > > > information about which existing interfaces a chain/flowtable currently
> > > > > binds to, new netlink attributes *_ACT_DEVS are introduced which are
> > > > > filled from the active hooks only.
> > > > 
> > > > Currently, NFTA_HOOK_DEVS already represents the netdevice that are
> > > > active. If one of these devices goes aways, then it is removed from
> > > > the basechain and it does not show up in NFTA_HOOK_DEVS anymore.
> > > > 
> > > > There are netlink notifications that need to fit into NLMSG_GOODSIZE,
> > > > but this adds yet another netlink array attribute.
> > > 
> > > Hmm. I could introduce NFTA_HOOK_INACTIVE_DEVS which contains only those
> > > entries missing in NFTA_HOOK_DEVS. This shouldn't bloat the dumps too
> > > much (apart from the added overhead) and won't change old user space
> > > behaviour.
> > 
> > Not sure. What does NFTA_HOOK_INACTIVE_DEVS contains? Could you
> > provide an example? Again, if this array gets again too large, there
> > could be issues with NLMSG_GOODSIZE again for notifications.
> 
> I assumed your intention was for NFTA_HOOK_DEVS to not change
> semantically, i.e. remain to contain only devices which are present at
> time of the dump. Then I could introduce INACTIVE_DEVS to contain those
> we lost meanwhile. As an example:
> 
> 1) add netdev chain for devices eth0, eth1, eth2
> 2) list ruleset:
>    - HOOK_DEVS = { eth0, eth1, eth2 }
>    - INACTIVE_DEVS = {}
> 3) ip link del eth1
> 4) list ruleset:
>    - HOOK_DEVS = { eth0, eth2 }
>    - INACTIVE_DEVS = { eth1 }

Hm. I think such list could grow up collecitng devices that could not
ever show up again.

> This avoids duplicate entries in both lists and thus avoids overhead.
> This would fix for the interfaces missing in dumps problem.
> 
> Wildcards would appear as-is in either HOOK_DEVS (if there's at least
> one matching interface) or INACTIVE_DEVS (if there is none). The actual
> list of active interfaces would require a GETDEVICE call.

I think wildcards should inconditionally show in HOOK_DEVS, otherwise
this tracking becomes tricky?

I am not sure ACTIVE_DEVS or INACTIVE_DEVS is worth in the basechain
notification, since this is merely for diagnostics, just let this
information be listed in the specific command that allows to inspect
what devices are matching the wildcard (to me this is for debugging
purpose only, because if users says tap* then that is all tap devices
will be registered in such basechain/flowtable).

> > I would just display these active devices (in the list of devices that
> > are attached to this basechain) via the new command _GETDEV that we
> > are discussing below? These netdevices that match the pattern come and
> > go, I guess user only wants to make sure they are actually registered
> > to this hook for diagnostics, showing an exact match, ie. tap0, or
> > inexact match, ie. tap* should be should when listing the ruleset IMO.
> 
> OK, let's see if I can sum this up correctly:
> 
> 1) NFTA_HOOK_DEVS is changed to always reflect what the user specified
> 2) Interfaces being removed or added trigger NEWDEV/DELDEV notifications
> 3) Active hooks are dumped by GETDEV netlink request
> 4) NEWDEV/DELDEV netlink requests/responses added to cover for oversized
> chains/flowtables

Makes sense.

> You're saying we have to use (4) for wildcard interfaces, too. Is this
> to keep them away from NFTA_HOOK_DEVS? Because in theory 1-3 are
> sufficient for wildcards, too.

As said, I would only expose active devices in GETDEV.

[...]
> > > > There is also another case that would need to be handled:
> > > > 
> > > >         - chain A with device tap0
> > > >         - chain B with wildcard device tap*
> > > > 
> > > > I would expect a "exclude" clause for the wildcard case will come
> > > > sooner or later to define a different policy for a specify chain.
> > > > The new specific command approach would be extensible in that sense.
> > > 
> > > As a first implementation, I would just forbid such combinations.
> > > Assuming "tap*" is just "tap" with length 3 and "tap0" is "tap0\0" with
> > > length 5, modifying the duplicate hook check in
> > > nf_tables_parse_netdev_hooks() to perform a strncmp(namea, nameb,
> > > min(lena, lenb)) should suffice.
> > 
> > That is fine to ensure a given basechain does not have both tap0 and tap*
> 
> Ah, I missed that nf_tables_parse_netdev_hooks() merely searches the
> current list for duplicate entries, not all chains'/flowtables' ones.
> 
> Hmm. I can create multiple netdev chains attaching to the same
> interfaces, but only a single flowtable. Is this intentional?

For basechain, definitely because one could have a pure hardware
basechain (for offload) while a pure software policy in separated
basechain, placing hardware before software.

Thanks.
