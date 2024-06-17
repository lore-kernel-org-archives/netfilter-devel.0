Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA3419A28A
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2024 23:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665835; cv=none; b=HXIgjXmRanRgyMb4CF81lx0h2zwdXbjqW76GMXSRLMUyM16zUsPXT0hfmprxBiyV5YHTsquDvxYKJi7AUxpJ9oCOmlnLeR7dbvYZi74W9ZDSIAkT3dyGG46fixl7ZhBCXAfptvUIzWCJ8ofC2qMp1l0Kf2bUGI47z79xlOFqZIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665835; c=relaxed/simple;
	bh=08jPpLyVW8iPRZyEw/fx+YarA4wg/P7K8ZmKQpIiBmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfyWTidgc6cSaR6jGXZkye9MMpvo16G8fKuQ13f0ksO/XLDwDiJN7Oevd/IngAt+1ilKsqTCnbzLnrau+HR4JidGK2TiO7+Z5X6zfNRUBajORRJcB4Q8NHpm6xE3XZzM8H+dnLEHxK48H09SHCz91ELf09oL2dtN7pyQSZ38ptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47644 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJLUU-00CXyC-Tb; Tue, 18 Jun 2024 01:10:27 +0200
Date: Tue, 18 Jun 2024 01:10:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH v2 0/7] Dynamic hook interface binding
Message-ID: <ZnDCXfYr7qZ0bD9E@calendula>
References: <20240517130615.19979-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240517130615.19979-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Fri, May 17, 2024 at 03:06:08PM +0200, Phil Sutter wrote:
> Changes since v1:
> - New patch 6 adding notifications for updated hooks.
> - New patch 7 adding the requested torture test.
> 
> Currently, netdev-family chains and flowtables expect their interfaces
> to exist at creation time. In practice, this bites users of virtual
> interfaces if these happen to be created after the nftables service
> starts up and loads the stored ruleset.
> 
> Vice-versa, if an interface disappears at run-time (via module unloading
> or 'ip link del'), it also disappears from the ruleset, along with the
> chain and its rules which binds to it. This is at least problematic for
> setups which store the running ruleset during system shutdown.

I'd suggest that you place your patch 2/7 to modify the existing
behaviour in first place.

> This series attempts to solve these problems by effectively making
> netdev hooks name-based: If no matching interface is found at hook
> creation time, it will be inactive until a matching interface appears.
> If a bound interface is renamed, a matching inactive hook is searched
> for it.
> 
> Ruleset dumps will stabilize in that regard. To still provide
> information about which existing interfaces a chain/flowtable currently
> binds to, new netlink attributes *_ACT_DEVS are introduced which are
> filled from the active hooks only.

Currently, NFTA_HOOK_DEVS already represents the netdevice that are
active. If one of these devices goes aways, then it is removed from
the basechain and it does not show up in NFTA_HOOK_DEVS anymore.

There are netlink notifications that need to fit into NLMSG_GOODSIZE,
but this adds yet another netlink array attribute.

I think we cannot escape adding new commands such as:

NFT_MSG_NEWDEVICE
NFT_MSG_GETDEVICE
NFT_MSG_DELDEVICE

to populate the basechain/flowtable, those can be used only if the
"subscription" mecanism is used, so older kernels still rely in
NFTA_HOOK_DEVS (older-older kernels actually already deal with
NFTA_HOOK_DEV only...).

NFT_MSG_NEWDEVICE can provide a flag to specify this is a wildcard
or exact matching.

There is also a need for a netlink attribute to specify if this is
adding a device to a chain or flowtable.

With these new commands, the NFT_NETDEVICE_MAX cap can also go away in
newer kernels with a command like this:

        nft add device flowtable ip x y { a, b, c }
        nft add device chain ip x y { a, b, c }

which expands to one one NFT_MSG_* message for each item.

Then, the nested notation will need to detect what to use depending on
the user input:

        table netdev x {
                chain y {
                        type filter hook ingress devices = { tap* } priority 0
                }
        }

this triggers the new commands path, same if the list of devices goes
over NFT_NETDEVICE_MAX (256).

This can also help incrementally report on new devices that match on a
given "subscription pattern" via new NFT_MSG_NEWDEVICE command for
monitoring purpose.

Maybe a command like:

        nft list device chain ip x y

could be used to list the existing devices that are "active" as per
your definition, so:

        nft list ruleset

does not show the listing of "active" devices that expand to tap*,
because this is only informational (not really required to restore a
ruleset), I guess the user only wants this to inspect to make sure
what devices are registered to the given tap* pattern.

There is also another case that would need to be handled:

        - chain A with device tap0
        - chain B with wildcard device tap*

I would expect a "exclude" clause for the wildcard case will come
sooner or later to define a different policy for a specify chain.
The new specific command approach would be extensible in that sense.

> This series is also prep work for a simple wildcard interface binding
> similar to the wildcard interface matching in meta expression. It should
> suffice to turn struct nft_hook::ops into an array of all matching
> interfaces, but the respective code does not exist yet.

I think this series is all about this wildcard interface matching,
which is not coming explicitly.
