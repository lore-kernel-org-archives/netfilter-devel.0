Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB431BDA81
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153928; cv=none; b=LcmPF/5DSDaH0vo8Qpkh5WBTZyOkfF4uFm8xFF4xfLK8OVBVCDrnovNft5NkVJFWQFS8DTj+0HzfiHh+UfeiTrEnGpjVUsbWVeT7h5J1pNrHnOQCUvQxc7vv3cYKF+gsO7J6XrAD7w6RTWaK8GOoI3oGNyVDCC90uvzvH+e6pto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153928; c=relaxed/simple;
	bh=8g0aVjYe43Iif4DwaNyy/zh0DM3ftzcu5+BpbTdjcsg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ke5/5uZC+QHpIO3KdeImIEgkwtmW1GeqzACaRTeSEtfgLnk+ZRh4/gg1w3FQ/spD5q4JkBFGJDAJWrxfEd58aiHn9wx4E08+lnaCzgtdeCSnzYWb6Ont+wT2GJxWIPe/iPxTjfRpRIOdwdYJBKAyeGp+Svt1jeyxuPdf1JeaeFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1solUJ-0002jt-WB; Thu, 12 Sep 2024 17:12:04 +0200
Date: Thu, 12 Sep 2024 17:12:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <20240912151203.GA32404@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
 <20240912144041.GE2892@breakpoint.cc>
 <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> > Or is this guaranteed by UNREGISTER event already?
> > If so, please add a comment.
> 
> Are packets relevant here? The question should be whether another CPU
> traverses hook->ops_list at the same time, no?

Yes, but also if anyone else can look at the structure in parallel.

> Looking at
> nft_flowtable_find_dev() mentioned in your other mail, there seems to be
> a case which doesn't synchronize on commit_mutex. So same rules apply to
> ops_list as for hook_list and thus I need to add an rcu_head to
> nf_hook_ops as well?

I will need to apply your series locally first to get the full picture,
sorry.

> > > +			if (ops) {
> > > +				memcpy(ops, &basechain->ops, sizeof(*ops));
> > > +				ops->dev = dev;
> > > +			}
> > > +			if (ops &&
> > > +			    (ctx->chain->table->flags & NFT_TABLE_F_DORMANT ||
> > > +			     !nf_register_net_hook(dev_net(dev), ops))) {
> > > +				list_add_tail(&ops->list, &hook->ops_list);
> > > +				break;
> > > +			}
> > > +			printk(KERN_ERR "chain %s: Can't hook into device %s\n",
> > > +			       ctx->chain->name, dev->name);
> > 
> > I think its better to -ENOMEM and veto the netdevice register request in this case.
> 
> Ah, I wasn't aware we may influence netdev registration from a notifier.
> So I'll change the callbacks to return NOTIFY_BAD in error case.
> 
> > I also think this needs extra handling for NETDEV_CHANGENAME rather than
> > the 'treat as UNREG+REG' trick.
> > 
> > Else we may unregister and then fail to re-register which leaves the
> > device without the registered hook op.
> 
> So search for another flowtable/chain with a hook matching the new name
> first, then unregister, try to register in the new spot and undo on
> failure? Sounds doable. :)

If possible i'd register new, then unreg old.
But, do you need to do anything on CHANGENAME at all?

Device is the same, so maybe its enough to update the name
in nft_hooks structure?
