Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E4E169397
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 12:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724069429; cv=none; b=g0WDyzkw1Ulpp7rsQiqfcA7yTdw2WkB4im/HgjRPrHI1MpXsjVfTNN9JSF8A4t7Ia9ZarL7EGF476LexoGCN09O/K7g5u8VlZ9uOl2SmZKVYqZwfRiZEtlu9D5e/+ZRty6wmHkDbm/ua4xpwc4tRF3uZG9L/qhWoERNU4MWTSX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724069429; c=relaxed/simple;
	bh=+EdtJVQXPLqx9z6gD86kmpz/lTsjV84u3q9+T8gzfBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqDikcWYAA3M2RJlZU1TqL6gJiX4EP+0m7blQjNxNdkR2+aSKKrYMLQEp8AMFWpvg3f3BR8GRVUjTSQuXdONxQSIgMNvqYBJkfirILJxS1I6BAQqS1sJIZGcMWcYXmMBBCNX5mWov5n/90yksIQCRZ3z/xiSxB+y3eTh/Jxu3y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sg1DG-0001Hs-TL; Mon, 19 Aug 2024 14:10:18 +0200
Date: Mon, 19 Aug 2024 14:10:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <20240819121018.GA4328@breakpoint.cc>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
 <ZqbR0yOY87wI0VoS@calendula>
 <20240728233736.GA31560@breakpoint.cc>
 <ZqbgmMzuOQShJWXK@calendula>
 <20240729153211.GA26048@breakpoint.cc>
 <Zrs-STpwUN2rqnl2@orbyte.nwl.cc>
 <ZsMkwTdIp1hYWBXt@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsMkwTdIp1hYWBXt@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Phil, Florian,
> 
> @Florian, could you push out what you have to flush your queue in this front?

OK, I pushed the patches to nftables.git.

> > > 1. nft list hooks
> > >   dump everything EXCEPT netdev families/devices
> > 
> > Include netdev here, make it really list *all* hooks. Iterating over
> > the list of currently existing NICs in this netns is no big deal, is
> > it?
> 
> I like this suggestion.

Fail enough, I will send a patch for this later this week.

> > > 2. nft list hooks netdev device foo
> > >    dump ingress/egress netdev hooks,
> > >    INCLUDING inet ingress (its scoped to the device).
> > 
> > Drop 'netdev' from the syntax here. The output really is "all hooks
> > specific to that NIC", not necessarily only netdev ones. (And "device"
> > is a distinct identifier for network interfaces in nftables syntax.)
> 
> I think allowing 'device foo' without family would be good.

OK,  I'm still unclear however because internally only netdev
families exist at the device level, so I'm not sure how to represent
this.

But dumping the existing network devices and querying them all is not
and issue so I will make a patch for this.
