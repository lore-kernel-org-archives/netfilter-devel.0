Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3DB22B65A
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 10:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729853770; cv=none; b=bfv/wDhj/GBKg5l/tN6Vgf3o55jLwyTqPcUtJZLkbWnC2KqFWU7MldydWevrw6FPS0eLBDWHZuOavkUtx9hSNaILiuro7Dfj6u5JJ52OXgg6yI8KT5nKePN5E1se4ClTZzgZ/WLsqyk0L3vJPNQwaNWrBFBdTyo2goUlqDlrdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729853770; c=relaxed/simple;
	bh=2IHkMo3vy/PfgNra3tyPr3IdHhKHqtamKTjNmW9RlIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkP5zWsFwd0q9/+7GKmnXoQsJiPTD2bVfXp+U8FlJGb6ZoPjddR/YcC8qag4yN87XWRFPNL9NPaJGiqwSeqYGrdZNir3TvE5N/8oq5ZY6WCWCDDfOiG/GW81roRBLaCOOKtz1NGOEnmhRQde6fjImKXw3hkUPipI68xcvchGj84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=A5d+S5ew; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A5d+S5ew"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PxKXlkvHh0KrlyusdP/HAS0peH/cjMbOoqrsodPLh4A=; b=A5d+S5ewfOZYsMbNN88pc4ix4G
	0Z13u6diYppIlwf+9j2wvN+ejyIFvUkIOHVKS3Np3eEy8qUA/sRBzlwXQkvWPIvOcWwxMMh9Jj1vZ
	a2xd/PFFj1i5YILZWTLHgHIr1qpHO8vciKytXu1O+k4gpni7CTKjrmsiJfSskYfKwN7vU9XQjwBgS
	TPLjib3t963y5PaTp3tkS3zKY0KOS+WFGLX6BNUy6KbgvopDRAw+NYL+Sd0qD7S1TZwtIJx5WxXta
	lmzckZk89AmmpbqzryZoepyASqqn33MXIOzF94G0XqFrtP8sjxqbhily2ZyxI1VmdDmNcwZZgspEp
	Jt/wbQDw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t4Hz9-000000001bp-3QZG;
	Fri, 25 Oct 2024 12:56:03 +0200
Date: Fri, 25 Oct 2024 12:56:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Matthieu Baerts <matttbe@kernel.org>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <Zxt5Q16q1M3idZV3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Matthieu Baerts <matttbe@kernel.org>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
 <ZxqQAIlQx8C1E6FK@calendula>
 <20241024232230.GA23717@breakpoint.cc>
 <40d071e1-4c13-49c9-8cac-14c1377eaf86@kernel.org>
 <20241025092356.GA11843@breakpoint.cc>
 <Zxto-TvgUAa1p9N9@orbyte.nwl.cc>
 <ZxtyZ8-jVGuGCU2K@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZxtyZ8-jVGuGCU2K@calendula>

On Fri, Oct 25, 2024 at 12:26:47PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 25, 2024 at 11:46:33AM +0200, Phil Sutter wrote:
> > On Fri, Oct 25, 2024 at 11:23:56AM +0200, Florian Westphal wrote:
> > > Matthieu Baerts <matttbe@kernel.org> wrote:
> > > > While at it, I had a question related to the rules' list: in
> > > > __nft_release_basechain() from the same nf_tables_api.c file, list's
> > > > entries are not removed with the _rcu variant → is it OK to do that
> > > > because this function is only called last at the cleanup time, when no
> > > > other readers can iterate over the list? So similar to what is done in
> > > > __nft_release_table()?
> > > 
> > > Looks like __nft_release_basechain() is broken from start, I don't see
> > > how it can work, it doesn't call synchronize_rcu or anything like that
> > > afaics.
> > > 
> > > No idea what to do here.
> > 
> > It will vanish with my name-based netdev hooks series (the second part).
> > I could prepare a patch for nf/stable which merely kills that function -
> > dropping netdev-family chains upon removal of last interface is
> > inconsistent wrt. flowtables which remain in place.
> 
> I like the idea of keeping the basechain in place. With chain update
> support, it makes sense to add a basechain then update it with the
> devices to hook in.
> 
> But chain device updates are only recently supported:
> 
> b9703ed44ffbfba85c103b9de01886a225e14b38
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Fri Apr 21 00:34:31 2023 +0200
> 
>     netfilter: nf_tables: support for adding new devices to an existing netdev chain
> 
> that is, in older kernels, this chain would remain unused because
> updates are not be possible.

No idea how many nftables "service" scripts out there actually do it,
but I keep considering the hypothetical case of SAVE_RULESET_ON_STOP=1
which does 'nft list ruleset >/etc/nftables/nftables.conf'. If it runs
after the "network" service shuts down and removes all virtual
interfaces, it would drop any hooked chains from user's config.

> > Another alternative might be to call synchronize_rcu() in there, but it
> > slows down interface teardown AIUI.
> 
> Else unregister objects from lists under mutex then call_rcu() to
> release them.

This requires to add an rcu_head to nft_chain or nft_base_chain, right?
Or is it possible to allocate a new object just for the purpose, like:

| struct nft_chain_rcu_call {
| 	struct rcu_head		rcu;
| 	struct nft_chain	*chain;
| };

And free both base chain and this temporary object in the callback?

> Then, take you patch so new kernel don't remove the basechain.

We would not change behaviour in stable this way, also not the worst
thing to do. Your call!

Thanks, Phil
