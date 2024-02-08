Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA01F6E2B9;
	Thu,  8 Feb 2024 09:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707384061; cv=none; b=AxE14At3VQO+I3Ch+YHXYEA7zwBEqtSaFvaGmlj8fs57KqCKuCalUmGFScPdFTBrRBUS2UH11A0eliKGVTi8RtFipWVI4rxN1Eyk54HPxV6893Ym2W6HrIPx/LiPSeWY6tEXRjLjglsfJO5eBBsI9mEoeJlC/7pbblJg/ZxqLIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707384061; c=relaxed/simple;
	bh=B/HKn+CrCkg62+tnugbIGxmQwdsYdT1rFcR2OMqEXpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3/8sadnS0KXX4kn0aIQDjh1a4XVMo+XDNtNJOjWi5kMXT1CbuTlHr0cb1cwRRx2vAyiJMNSOJISttIbjkhe0549LjPw5a2/1rEuz9c6aUigh21S7J3w0YtK82X6tWeY+QxNO1uExCK4oaoBnpdfA2ht50AH4ROd7BfOC5r1Y4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=41052 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rY0aS-009yn1-E4; Thu, 08 Feb 2024 10:20:54 +0100
Date: Thu, 8 Feb 2024 10:20:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@google.com, fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 05/13] netfilter: ipset: Missing gc cancellations
 fixed
Message-ID: <ZcSc86Sipo0atl/L@calendula>
References: <20240207233726.331592-1-pablo@netfilter.org>
 <20240207233726.331592-6-pablo@netfilter.org>
 <9fb4e908-832c-44ae-8049-f6e9092f9b10@leemhuis.info>
 <b40f03126ec8380704d7ff1b7364a977196ef083.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b40f03126ec8380704d7ff1b7364a977196ef083.camel@redhat.com>
X-Spam-Score: -1.8 (-)

Hi Paolo,

Working on v2 series, it should be ready in before noon.

On Thu, Feb 08, 2024 at 09:50:55AM +0100, Paolo Abeni wrote:
> Hi,
> 
> On Thu, 2024-02-08 at 06:48 +0100, Thorsten Leemhuis wrote:
> > On 08.02.24 00:37, Pablo Neira Ayuso wrote:
> > > From: Jozsef Kadlecsik <kadlec@netfilter.org>
> > > 
> > > The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
> > > in swap operation") missed to add the calls to gc cancellations
> > > at the error path of create operations and at module unload. Also,
> > > because the half of the destroy operations now executed by a
> > > function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
> > > or rcu read lock is held and therefore the checking of them results
> > > false warnings.
> > > 
> > > Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
> > > Reported-by: Brad Spengler <spender@grsecurity.net>
> > > Reported-by: Стас Ничипорович <stasn77@gmail.com>
> > > Fixes: fdb8e12cc2cc ("netfilter: ipset: fix performance regression in swap operation")
> > 
> > FWIW, in case anyone cares: that afaics should be
> > 
> >  Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")
> > 
> > instead, as noted yesterday elsewhere[1].
> > 
> > Ciao, Thorsten
> > 
> > [1] https://lore.kernel.org/all/07cf1cf8-825e-47b9-9837-f91ae958dd6b@leemhuis.info/
> 
> I think it would be better to update the commit message, to help stable
> teams. 
> 
> Unless you absolutely need series in today PR, could you please send
> out a v2? Note that if v2 comes soon enough it can still land into the
> mentioned PR.
> 
> Thanks,
> 
> Paolo
> 
