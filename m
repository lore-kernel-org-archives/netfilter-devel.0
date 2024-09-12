Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254896EB4C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153554; cv=none; b=r8FqvAw5PvAnC6uyyNguGAssmVUsznfgbK/UuL8n4whmddmXay0QhE70krVatN4ZSkEtap0tYGwTXpbc6ZUaj974ri13qhmbM+bye/hUSnmwRXARB85Edz+tWOiKnnxv1eYJZHsTMJj/jtCjSbLE1MNA+jaBR7eS13P7XCVRnuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153554; c=relaxed/simple;
	bh=KN615jGt621B4FGziPM7wNNDW/nbsD2reQ6tR9/enB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObGxfOCbnRY4m/GNKHs7zcclfyb7L+6WM1FcDDRxfohFG/JuoB+FCIMUVEX6x5dXT88o3JkyoRG4DnN/WZraAQ3nH/hc9j08vHAQs+p67l52rlEB/vy9Lx/oynRmIEZ+oOPuLV1hUrt5g4oqnnZBbay/SjmE6TBdFlKpmVqTUss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aeHIJeCz; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aeHIJeCz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ukq32J2QSpPjUdkp51j094RetKrySR939W8zwa45fs4=; b=aeHIJeCz3AXqwPwKlNBa1y5xGA
	50ZNb5UYNtEsOvmAZe7qkd2rG1/FQcFa2dVuE9f2olvZOJ0DBcFQYncue3f1jqm27JEdTdQkeDuzw
	XenusPW+NlxGDdebHXc/4YJkgIfLzJa0qojyPJVt9bQ/HwBc7hk22db/8AH0Y58GXXAEJPxkqERtT
	5LdNt/2SLXPNm4PyX6bChMGoxM18STlW6i00/4HixUYcS5dT4zRnBV7FIpUbR2Q4e+nHNKT6ZowCj
	irfrl6KwYTmyQCCsG77LdFGTur5L44O6s6KngOPz9lTSIDoeNmf3uma3yVuUwGy9p0wYTujg2aqZ7
	sdIe/fUg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1solOG-000000006ja-3D8P;
	Thu, 12 Sep 2024 17:05:48 +0200
Date: Thu, 12 Sep 2024 17:05:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
 <20240912144041.GE2892@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912144041.GE2892@breakpoint.cc>

On Thu, Sep 12, 2024 at 04:40:41PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Hook into new devices if their name matches the hook spec.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/nft_chain_filter.c | 40 +++++++++++++++++++++++++-------
> >  1 file changed, 32 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> > index 2507e3beac5c..ec44c27a9d91 100644
> > --- a/net/netfilter/nft_chain_filter.c
> > +++ b/net/netfilter/nft_chain_filter.c
> > @@ -326,14 +326,37 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
> >  	struct nft_hook *hook;
> >  
> >  	list_for_each_entry(hook, &basechain->hook_list, list) {
> > -		ops = nft_hook_find_ops(hook, dev);
> > -		if (!ops)
> > -			continue;
> > +		switch (event) {
> > +		case NETDEV_UNREGISTER:
> > +			ops = nft_hook_find_ops(hook, dev);
> > +			if (!ops)
> > +				continue;
> >  
> > -		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
> > -			nf_unregister_net_hook(ctx->net, ops);
> > -		list_del(&ops->list);
> > -		kfree(ops);
> > +			if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
> > +				nf_unregister_net_hook(ctx->net, ops);
> > +			list_del(&ops->list);
> > +			kfree(ops);
> 
> This needs to use kfree_rcu() + list_del_rcu, nf_unregister_net_hook
> only stops new packets from executing for dev, it doesn't stop new
> packets.
> 
> Or is this guaranteed by UNREGISTER event already?
> If so, please add a comment.

Are packets relevant here? The question should be whether another CPU
traverses hook->ops_list at the same time, no? Looking at
nft_flowtable_find_dev() mentioned in your other mail, there seems to be
a case which doesn't synchronize on commit_mutex. So same rules apply to
ops_list as for hook_list and thus I need to add an rcu_head to
nf_hook_ops as well?

> > +			break;
> > +		case NETDEV_REGISTER:
> > +			if (strcmp(hook->ifname, dev->name))
> > +				continue;
> > +			ops = kzalloc(sizeof(struct nf_hook_ops),
> > +				      GFP_KERNEL_ACCOUNT);
> 
> ops = kmemdup(&basechain->ops, .. ?

Oh, sure!

> > +			if (ops) {
> > +				memcpy(ops, &basechain->ops, sizeof(*ops));
> > +				ops->dev = dev;
> > +			}
> > +			if (ops &&
> > +			    (ctx->chain->table->flags & NFT_TABLE_F_DORMANT ||
> > +			     !nf_register_net_hook(dev_net(dev), ops))) {
> > +				list_add_tail(&ops->list, &hook->ops_list);
> > +				break;
> > +			}
> > +			printk(KERN_ERR "chain %s: Can't hook into device %s\n",
> > +			       ctx->chain->name, dev->name);
> 
> I think its better to -ENOMEM and veto the netdevice register request in this case.

Ah, I wasn't aware we may influence netdev registration from a notifier.
So I'll change the callbacks to return NOTIFY_BAD in error case.

> I also think this needs extra handling for NETDEV_CHANGENAME rather than
> the 'treat as UNREG+REG' trick.
> 
> Else we may unregister and then fail to re-register which leaves the
> device without the registered hook op.

So search for another flowtable/chain with a hook matching the new name
first, then unregister, try to register in the new spot and undo on
failure? Sounds doable. :)

Thanks, Phil
