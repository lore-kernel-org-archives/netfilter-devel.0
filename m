Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DD632FA14;
	Wed,  4 Mar 2026 12:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772627212; cv=none; b=mqTa8ayPxSRFy7+RBTEfy9jCRgAR7IW45831qlEfBlUwgK8s7vPZZoAz7hD/P0Jm6ZCYXbvhtAGtOuWQ1gHsENVeG6CT3/uNb1loVl49SUPTbFrsdMOFlsRaNSiO1NPQoZzrrV5Y0w38MrUKd4gtQ/qSgW+V1JYZbKFwnyNuM/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772627212; c=relaxed/simple;
	bh=kzmYBN4Fmy2qyuiyCC4PywlZajPfYpzfGmvBUtDfGn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYjOBrTUk3Z9sb/rzUmXqTNx3OBoa4/svP7D1Zn1R9mVmfojVvgwGsGQRI0YyciUgj0l6u/Wq8CmsUQbnBsErc2oGXqI4AF/OJVLAuZRgEoMXJk7RVEMwsYp2dVsrG9XI+Hsk24BVLGJc9oYeRtKKZmxkbyCDTaVQeyNNgjZfOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Wr8aqQjB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Wr8aqQjB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KVKUva0XatBIz6K7/luN9CsihaDlLT4xSzZFo+SpHCs=; b=Wr8aqQjBpiPOWloOg6M/sLtw0R
	yTikI93KKK5A/JN1pmiLMKCxsLlrV8kYcfBxSWAJplx+5QYmZBWstrsMq9XYVslAeqA5/CoUDluiO
	0iJ23Go/jmhDCUUFsVNjfS7DLxsRcUdIlMn3E/fTAT/ovHoptrxJP/LJuuEhsmdGhtYUw7+MefSiu
	fwUCLaafMDhXUjHkg3lSxbooUY71DTbk0vYc2E/MghfQJ7y0bQIiP+vID/fU61Xr0KQf0KC/745yU
	vLLVkVHkr0UI6f3Nas8JyYw3QbsQogSbAFMkH9MdgROEZrjGu0Cw8OGpneFUGVS+9LAW0F357sa3B
	BfsypjcA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vxlJJ-000000007Wu-1Du8;
	Wed, 04 Mar 2026 13:26:41 +0100
Date: Wed, 4 Mar 2026 13:26:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Helen Koike <koike@igalia.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH] netfilter: nf_tables: fix use-after-free on ops->dev
Message-ID: <aaglAU8E48EF1m-_@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, Helen Koike <koike@igalia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
References: <20260302212605.689909-1-koike@igalia.com>
 <aaYYiPTO5JYOlhhY@chamomile>
 <17499d82-ad03-44a9-ab3a-429d2ebea02f@igalia.com>
 <aafD369eE31dh1VP@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aafD369eE31dh1VP@strlen.de>

Hi,

On Wed, Mar 04, 2026 at 06:32:15AM +0100, Florian Westphal wrote:
> Helen Koike <koike@igalia.com> wrote:
> 
> Phil, can you please take a look at this?
> 
> The reg/unregister logic is ... strange.
> 
> > But if I understood correctly from your comment below, the proper 
> > solution would be to fix the order that the hooks are released, is my 
> > understanding correct?
> 
> I don't think its about ordering.  I think the code allows to register
> devices multiple times in the same flowtable, but UNREG doesn't handle
> that.
> 
> static int nft_flowtable_event(unsigned long event, struct net_device *dev,
> 			       struct nft_flowtable *flowtable, bool changename)
> {
> 	struct nf_hook_ops *ops;
> 	struct nft_hook *hook;
> 	bool match;
> 
> 	list_for_each_entry(hook, &flowtable->hook_list, list) {
> 		ops = nft_hook_find_ops(hook, dev);
> 		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);
> 
> 		switch (event) {
> 		case NETDEV_UNREGISTER:
> 			/* NOP if not found or new name still matching */
> 			if (!ops || (changename && match))
> 				continue;
> 
> 			/* flow_offload_netdev_event() cleans up entries for us. */
> 			nft_unregister_flowtable_ops(dev_net(dev),
> 						     flowtable, ops);
> 			list_del_rcu(&ops->list);
> 			kfree_rcu(ops, rcu);
> 			break;
> 		case NETDEV_REGISTER:
> 			/* NOP if not matching or already registered */
> 			if (!match || (changename && ops))
> 				continue;
> 
> And *THIS* looks buggy.
> Shouldn't that simply be:
> 			if (!match || ops)
> 				continue;
> 
> Or can you explain why changename has any relevance here?
> changename means dev->name has already been updated.

The changename parameter is true if the event handler was called for a
NETDEV_CHANGENAME event. In that, case, we call nft_flowtable_event()
twice for each flowtable: First with NETDEV_REGISTER event value and
second with NETDEV_UNREGISTER value. If a device is renamed, we will try
to register it with all flowtables having a matching interface spec if
not already registered with. If that succeeds, we try to unregister it
from all flowtables it's registered with if not matching anymore.

In "changename mode" therefore, NETDEV_REGISTER case is skipped if name
matches but device is registered already. NETDEV_UNREGISTER case is
skipped if already registered but name still matches.

In regular mode, i.e. either real NETDEV_REGISTER or NETDEV_UNREGISTER,
the NETDEV_UNREGISTER case is skipped if the device was not registered.
If it was, the name is not relevant, we have to unregister it anyway.
The NETDEV_REGISTER case is skipped if the name does not match. If it
matches, we assume it is not registered already. This is true since
NETDEV_REGISTER notifier runs for each device just once, right?

> So, we want to skip a new registration if either:
> 1. the name doesn't match
> 2. it matches but its already registered.

The "already registered" part should not happen in real NETDEV_REGISTER
event, though: When parsing netdev hooks, non-distinct prefixes are
eliminated so that a given device name will never match more than a
single hook per flowtable. This is done by comparing with min prefix
length in nft_hook_list_find().

> In case changename is true, only UNREGISTER: case is
> relevant: If its not matching anymore -> unregister.
> 
> Still matching?  Keep it.  In that case, we havn't
> registered the device again because 'ops' was non-null in
> REGISTER case.

You're right, the 'changename' check in NETDEV_REGISTER is not needed
because even if not changing names one should skip if already
registered. Actually, this indicates a bug unless handling
NETDEV_CHANGENAME. Maybe add a WARN_ON_ONCE()?

> 		}
> 		break;
> 
> If its allowed to register the same device twice (or more), then the
> above 'break' needs to be removed, AND one has to alter UNREGISTER
> above to loop until no more ops are found, i.e.

A device may register to a single flowtable multiple times only
temporary while it is being renamed: If one hook matches the old name
and another the new name. It is supposed to register to the newly
matching hook first, then unregister from the no longer matching one.

Cheers, Phil
