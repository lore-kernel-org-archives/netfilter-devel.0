Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED58844C8F
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726155682; cv=none; b=Tv2NWzKov7J+YIsMmn6EqXEQJo0kWWKXoBKWkhX4W6rY5sGHYMPnaDT3e8sTniffshd+vNL9nurBosdu/uTL0R4L0hXVGu42G1/iFnROt8HhNlxherSwtDD2YrjzRLtvnk9IgKFTDtnv4xVCRZ7diY7RWgbsLjfloBenbnL231U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726155682; c=relaxed/simple;
	bh=Nq87hxrDo1Mhjf3Iq1syUVJ9c/CaUK4pP9LDdjcFYJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rad663tPtcEuotxGY3T6LaQPx3y57zk0L2ua5EExYxCr20gKnTaJF1z5dCkH3tnu1jM0MqBRhLxi1YzO07ef9vaosDa+MtRUxQXy9MDqb0HMrNfa1qO/nva0c5HSaRa5k9DUz2H7Mgz+1f60wmLlJF06SCEAHSSE6LBA9Yep4FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SRZb7gqd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SRZb7gqd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=S7itZACmN3t0VeGyYQohGt5eEbJUQ1ekzSP9X/Brwcg=; b=SRZb7gqdyA46sDO1nkF2aKPK0x
	SnDsX800NGslfebgt2obvO3v3G9XnLVvNiuLNMi+6NtFcbDzixehSWxGdKfLW1FWYHB1IYfpdrunu
	K9zMKDZ+Hz/vLUZYlubruQOSCldSvaTWjpBrblsqhG9utnZTyDUkvdFBGDI10rJmgIKfGl3cBh0Wk
	nAuLUUyzyobxL1JGqcJAYNVr4HNI+MBqXRkqwcMaFb2f9E2PnQiiRxc5bIcNtQVC/UwVLsh/swiD8
	M5fqj3RFtjndd7/zEXQ8jyNRYVKqVSF5A3DMm6zF5U12SvIKNMond9Lo0+I/FR9uBc/t5EjMKtEG0
	mX2Npj2w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1solwb-000000007EV-41Ca;
	Thu, 12 Sep 2024 17:41:17 +0200
Date: Thu, 12 Sep 2024 17:41:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <ZuMLnfwhTdyqp90C@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
 <20240912144041.GE2892@breakpoint.cc>
 <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
 <20240912151203.GA32404@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912151203.GA32404@breakpoint.cc>

On Thu, Sep 12, 2024 at 05:12:03PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > Or is this guaranteed by UNREGISTER event already?
> > > If so, please add a comment.
> > 
> > Are packets relevant here? The question should be whether another CPU
> > traverses hook->ops_list at the same time, no?
> 
> Yes, but also if anyone else can look at the structure in parallel.

So it is possible that ops are still used somewhere after
nf_unregister_net_hook() returns? I don't quite get that code, with all
the RCU-bells and ONCE-whistles.

> > Looking at
> > nft_flowtable_find_dev() mentioned in your other mail, there seems to be
> > a case which doesn't synchronize on commit_mutex. So same rules apply to
> > ops_list as for hook_list and thus I need to add an rcu_head to
> > nf_hook_ops as well?
> 
> I will need to apply your series locally first to get the full picture,
> sorry.

No sorry, thanks for your review so far!

> > > > +			if (ops) {
> > > > +				memcpy(ops, &basechain->ops, sizeof(*ops));
> > > > +				ops->dev = dev;
> > > > +			}
> > > > +			if (ops &&
> > > > +			    (ctx->chain->table->flags & NFT_TABLE_F_DORMANT ||
> > > > +			     !nf_register_net_hook(dev_net(dev), ops))) {
> > > > +				list_add_tail(&ops->list, &hook->ops_list);
> > > > +				break;
> > > > +			}
> > > > +			printk(KERN_ERR "chain %s: Can't hook into device %s\n",
> > > > +			       ctx->chain->name, dev->name);
> > > 
> > > I think its better to -ENOMEM and veto the netdevice register request in this case.
> > 
> > Ah, I wasn't aware we may influence netdev registration from a notifier.
> > So I'll change the callbacks to return NOTIFY_BAD in error case.
> > 
> > > I also think this needs extra handling for NETDEV_CHANGENAME rather than
> > > the 'treat as UNREG+REG' trick.
> > > 
> > > Else we may unregister and then fail to re-register which leaves the
> > > device without the registered hook op.
> > 
> > So search for another flowtable/chain with a hook matching the new name
> > first, then unregister, try to register in the new spot and undo on
> > failure? Sounds doable. :)
> 
> If possible i'd register new, then unreg old.
> But, do you need to do anything on CHANGENAME at all?
> 
> Device is the same, so maybe its enough to update the name
> in nft_hooks structure?

You're putting the cart before the horse here: The user sets
hook->ifname and we bind to whatever device matches that.

Now with a device being renamed, there are two options:

A) Unbind if the name doesn't match hook->ifname anymore and search for
   another, matching hook. This is what I had (tried to) implement.

B) Just leave the interface in place as long as it exists. This is how
   the old code behaves.

For users, I find (A) more intuitive. Also, consider netdevs being
renamed by udev: Users may have a flowtable which matches the initial
name by accident. If it doesn't unbind them upon being renamed, they all
remain in there and may block the right flowtable from binding to them.

Cheers, Phil
