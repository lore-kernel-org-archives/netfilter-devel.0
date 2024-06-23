Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E94365C
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Jun 2024 22:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719180739; cv=none; b=G4TpXrIg33zRSbHzvhpKgEmKQ+uLtdkgzPjf6XpgBIQoMsqxNvvCFjTjAw0NrTcYAfLFBAGpvjfFw/QVg2BJ5JseGFp9yuCy+RHd13P5xsH8I+0CKRRes2Xn+Y7hH3g6FiusLgOPi4+4j2GARBmt5JhkD9g/rlJ/pFpaOPypwSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719180739; c=relaxed/simple;
	bh=3qW5AAHZHI10L25QoKLtp/rsWdhdZWD0Yh6TKBcIeJA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxT3nect45mjmb3VFjSjU1FlTi4fb+alVTOtsF8FxESnC0sfwEaPWaVfSJU5YetPyazgdNzIio5M0gD3+eHcw2vrtvklyvyDTb9C6nTRLqLUZYC/A7JO8LpLoMLT+CWW07yzyhxL5RsDGhdT3pEyw5/MELKwaP5FFaVjpUQNVNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=37206 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sLVRU-003x22-UY; Mon, 24 Jun 2024 00:12:14 +0200
Date: Mon, 24 Jun 2024 00:12:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: Re: [PATCH v2 0/7] Dynamic hook interface binding
Message-ID: <ZnidvHKBjXUnkYXx@calendula>
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

Hi again Phil,

On Wed, Jun 19, 2024 at 05:59:32PM +0200, Phil Sutter wrote:
[...]
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
> 
> This avoids duplicate entries in both lists and thus avoids overhead.
> This would fix for the interfaces missing in dumps problem.
> 
> Wildcards would appear as-is in either HOOK_DEVS (if there's at least
> one matching interface) or INACTIVE_DEVS (if there is none). The actual
> list of active interfaces would require a GETDEVICE call.
[...]
> OK, let's see if I can sum this up correctly:
> 
> 1) NFTA_HOOK_DEVS is changed to always reflect what the user specified
> 2) Interfaces being removed or added trigger NEWDEV/DELDEV notifications
> 3) Active hooks are dumped by GETDEV netlink request
> 4) NEWDEV/DELDEV netlink requests/responses added to cover for oversized
> chains/flowtables

It should be possible to use:

        nft list hooks

to display the flowtable

if user specifies the device, then it displays the ingress patch from
the given device, the flowtable hook could be shown there for
debugging purpose.

Then, there is no need for the ACTIVE_DEVS/INACTIVE_DEVS attribute.

Rewinding a bit: The NEWDEV/DELDEV interface I am proposing has a
downside, which is that userspace has to deal with two interfaces to
add netdevice to basechain/flowtables (currently NEWCHAIN/NEWFLOWTABLE
can be used for this purpose).

Probably I am overdoing a bit with this new interface.

Then, there is the concern with NLMSG_GOODSIZE, but it should be
possible to deliver independent notifications to userspace via
NEWCHAIN/NEWFLOWTABLE including only the netdevices, ie. allocate one
transaction for each new netdevice, so one notification is send per
new netdevice.

In summary: If ACTIVE_DEVS/INACTIVE_DEVS can go away, and nft list
hooks is used instead to check if there is a hook registered for such
device matching the wildcard netdevice, eg. tap*, then your existing
patch can be used as is.

As said, only purpose to know if the device is registered is
debugging, if user requires tap*, then if tap0 exists it is
registered, otherwise it is a kernel bug.

Apologies for this u-turn a bit, this is taking you back to this
original patch of you minus ACTIVE_DEVS/INACTIVE_DEVS and document
that 'nft link hooks' can be use to check if the netdevice got a hook
registered for the flowtable/basechain.

Thanks.
