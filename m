Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8663368BD;
	Wed,  4 Mar 2026 05:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772602344; cv=none; b=SK16R/eSLis1Wq75a0xjYKtfmXUhkDPEUMwRLfEMfeZG+rh5dD/TXoNj0o1Wb0Vj4AuvCus1WllTMK6hQOT5R7begE0iVfmflsQ1THyF86wYwEgl3E8J8+92BFXxhgGaZbEvaMtrL4IwXloqmvEk7A23iwjALWWaWIq/kvFwvpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772602344; c=relaxed/simple;
	bh=xoqHvfs/WmMCAA44T1hWY8qugXUi3Ofc4llwLvOxpUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BfI92bgJaELKxh7FBrml3IL4/h7hnUDRGXeTwKNb89RlzGbTbqFsXTIEo+e6NlVD5IjEH7lBSX7txtvPBmbGpT9wLJsEa1rbGxU47F8bx5G4vn5hg1L8/ECPy3xCF7S+/zTYcX4NyfBSUHsKz07lHCXS9n0r5qz7cXSptw5YKeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7005560492; Wed, 04 Mar 2026 06:32:20 +0100 (CET)
Date: Wed, 4 Mar 2026 06:32:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Helen Koike <koike@igalia.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, phil@nwl.cc,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH] netfilter: nf_tables: fix use-after-free on ops->dev
Message-ID: <aafD369eE31dh1VP@strlen.de>
References: <20260302212605.689909-1-koike@igalia.com>
 <aaYYiPTO5JYOlhhY@chamomile>
 <17499d82-ad03-44a9-ab3a-429d2ebea02f@igalia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17499d82-ad03-44a9-ab3a-429d2ebea02f@igalia.com>

Helen Koike <koike@igalia.com> wrote:

Phil, can you please take a look at this?

The reg/unregister logic is ... strange.

> But if I understood correctly from your comment below, the proper 
> solution would be to fix the order that the hooks are released, is my 
> understanding correct?

I don't think its about ordering.  I think the code allows to register
devices multiple times in the same flowtable, but UNREG doesn't handle
that.

static int nft_flowtable_event(unsigned long event, struct net_device *dev,
			       struct nft_flowtable *flowtable, bool changename)
{
	struct nf_hook_ops *ops;
	struct nft_hook *hook;
	bool match;

	list_for_each_entry(hook, &flowtable->hook_list, list) {
		ops = nft_hook_find_ops(hook, dev);
		match = !strncmp(hook->ifname, dev->name, hook->ifnamelen);

		switch (event) {
		case NETDEV_UNREGISTER:
			/* NOP if not found or new name still matching */
			if (!ops || (changename && match))
				continue;

			/* flow_offload_netdev_event() cleans up entries for us. */
			nft_unregister_flowtable_ops(dev_net(dev),
						     flowtable, ops);
			list_del_rcu(&ops->list);
			kfree_rcu(ops, rcu);
			break;
		case NETDEV_REGISTER:
			/* NOP if not matching or already registered */
			if (!match || (changename && ops))
				continue;

And *THIS* looks buggy.
Shouldn't that simply be:
			if (!match || ops)
				continue;

Or can you explain why changename has any relevance here?
changename means dev->name has already been updated.

So, we want to skip a new registration if either:
1. the name doesn't match
2. it matches but its already registered.

In case changename is true, only UNREGISTER: case is
relevant: If its not matching anymore -> unregister.

Still matching?  Keep it.  In that case, we havn't
registered the device again because 'ops' was non-null in
REGISTER case.

		}
		break;

If its allowed to register the same device twice (or more), then the
above 'break' needs to be removed, AND one has to alter UNREGISTER
above to loop until no more ops are found, i.e.
		case NETDEV_UNREGISTER:
			/* NOP if not found or new name still matching */
			if (!ops || (changename && match))
				continue;

			do {
				/* flow_offload_netdev_event() cleans up entries for us. */
				nft_unregister_flowtable_ops(dev_net(dev),
							     flowtable, ops);
				list_del_rcu(&ops->list);
				kfree_rcu(ops, rcu);
				ops = nft_hook_find_ops(hook, dev);
			} while (ops);
			break;

Phil, can you please have a look?  Thanks!
