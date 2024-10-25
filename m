Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEFC1C9B62
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 11:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729856613; cv=none; b=R2tp+BAgTLLOgikEepjtjpuNXm3Mygzt3vcgElmqhimcH2rhFlGbNwyTH7DdVWlCj1fCqdviSnZgZDMk4D2PFdDdXBuk74wEhVdhnjsaxrpro49HxKq63wzVhsOt8P6EM63eB6MVgH6TRGkSQ2y6RRfslTknc9HcHjJuq7Uvt3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729856613; c=relaxed/simple;
	bh=/cxHjOPy5bsYoXY4TtgtMlaygkn8CuK9SmxqI6fH0YE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcwKQXGMbxYjgA1XZJuYW6UlflI73PicpxSrlBqog5MR7eV13TrK7qMnDc5oENia7tSVkfWlILZ+HOxwCBhuGfMJ56lER0Sq0ucFyOeKp+oaLrHmJh6Az/EVVTLPIre/32qNQlfeJHwcPxAzt8RfrtW2z2J/ScjmO4DceBfcUh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35310 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t4Ij0-007ZAY-Id; Fri, 25 Oct 2024 13:43:28 +0200
Date: Fri, 25 Oct 2024 13:43:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Matthieu Baerts <matttbe@kernel.org>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <ZxuEXQe3j8rH_3c5@calendula>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
 <ZxqQAIlQx8C1E6FK@calendula>
 <20241024232230.GA23717@breakpoint.cc>
 <40d071e1-4c13-49c9-8cac-14c1377eaf86@kernel.org>
 <20241025092356.GA11843@breakpoint.cc>
 <Zxto-TvgUAa1p9N9@orbyte.nwl.cc>
 <ZxtyZ8-jVGuGCU2K@calendula>
 <Zxt5Q16q1M3idZV3@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zxt5Q16q1M3idZV3@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Fri, Oct 25, 2024 at 12:56:03PM +0200, Phil Sutter wrote:
> On Fri, Oct 25, 2024 at 12:26:47PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Oct 25, 2024 at 11:46:33AM +0200, Phil Sutter wrote:
> > > On Fri, Oct 25, 2024 at 11:23:56AM +0200, Florian Westphal wrote:
> > > > Matthieu Baerts <matttbe@kernel.org> wrote:
> > > > > While at it, I had a question related to the rules' list: in
> > > > > __nft_release_basechain() from the same nf_tables_api.c file, list's
> > > > > entries are not removed with the _rcu variant → is it OK to do that
> > > > > because this function is only called last at the cleanup time, when no
> > > > > other readers can iterate over the list? So similar to what is done in
> > > > > __nft_release_table()?
> > > > 
> > > > Looks like __nft_release_basechain() is broken from start, I don't see
> > > > how it can work, it doesn't call synchronize_rcu or anything like that
> > > > afaics.
> > > > 
> > > > No idea what to do here.
> > > 
> > > It will vanish with my name-based netdev hooks series (the second part).
> > > I could prepare a patch for nf/stable which merely kills that function -
> > > dropping netdev-family chains upon removal of last interface is
> > > inconsistent wrt. flowtables which remain in place.
> > 
> > I like the idea of keeping the basechain in place. With chain update
> > support, it makes sense to add a basechain then update it with the
> > devices to hook in.
> > 
> > But chain device updates are only recently supported:
> > 
> > b9703ed44ffbfba85c103b9de01886a225e14b38
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Fri Apr 21 00:34:31 2023 +0200
> > 
> >     netfilter: nf_tables: support for adding new devices to an existing netdev chain
> > 
> > that is, in older kernels, this chain would remain unused because
> > updates are not be possible.
> 
> No idea how many nftables "service" scripts out there actually do it,
> but I keep considering the hypothetical case of SAVE_RULESET_ON_STOP=1
> which does 'nft list ruleset >/etc/nftables/nftables.conf'. If it runs
> after the "network" service shuts down and removes all virtual
> interfaces, it would drop any hooked chains from user's config.

I'm afraid if the chain remains in place with no device it won't be
any better once the system boots up again, because chains cannot
updated in old kernels.

I think chain updates go hand in hand with your proposed approach to
leave the basechain in place.

> > > Another alternative might be to call synchronize_rcu() in there, but it
> > > slows down interface teardown AIUI.
> > 
> > Else unregister objects from lists under mutex then call_rcu() to
> > release them.
> 
> This requires to add an rcu_head to nft_chain or nft_base_chain, right?
> Or is it possible to allocate a new object just for the purpose, like:
> 
> | struct nft_chain_rcu_call {
> | 	struct rcu_head		rcu;
> | 	struct nft_chain	*chain;
> | };
> 
> And free both base chain and this temporary object in the callback?
> 
> > Then, take you patch so new kernel don't remove the basechain.
> 
> We would not change behaviour in stable this way, also not the worst
> thing to do. Your call!

I am still exploring how ugly this fix looks, you will see get to know.
