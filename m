Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDC4509F07;
	Thu, 15 Oct 2026 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792059529; cv=none; b=GMMeYBVYfS+0aBuFR534FVB53BBlkusiLfj1eOx7GUmkdaDUPVeU077LhA9fbl+pjJjWFIL52qAlW+0Nk7b6b6zW6LlxpMhcf2GRGEtbzEqAV4lbCTuSKczWwItmcOgSm3ljPvHWIDLhh6MmLgCQq0eNVGW6M4pr0i2DxzJ1fE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792059529; c=relaxed/simple;
	bh=w6+oEsqpvhl9XS9dYOzM3rDSQdpihAlD4bYiXOl5b2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=do9GvXVHJ5HZlXKCfVZXFS7HHZlJ27nLKFxN+Dt11HIInWSLjWb+ukMRHXVaIoQmmFa5LtlF5aMK+F3O2f+b06XQLRPAe75cIybU0r0Nm+LVnNAcq5sG/PrqyxzSR3oJ9Nuy/heKZiZqK++Pezs1vT/fqFKxrOW6/iWy7YdDlHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OdGLo44F; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OdGLo44F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792059523;
	bh=kOpn0t+1OIM+cNSDkTgSrnahRd+omhH3QhXv8mIfdVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OdGLo44FOArVKeoNSyi0TrSB8uQL00siqCx1D9PVyg28hdeM5hl43CQrsvd7fnC04
	 6kuKcFrHGtrAZusVnRrqJ7kWQuoreBclnrFJDhvwmrBWWCLfDWM71e6hhFEImXDljP
	 WRGyixy3AnQKDwmco6XVKgLKpjhtZuevVQOlpEaOOLEcQMkqhMVlQFR8OAdRwQi489
	 rVvMxFyCrejt3p3Xx0LP7vdC3RMcEK5DY/+mWt9piC3U4P2ddYVlnw9BnQfgBuGWIZ
	 G0U9GTGDKf7+7vQte6xKcLcHdaKg3MTi7pOviSVs22D6eHyYWAlpNKd/wYk6QtNhp5
	 5UPG9MiG+xKcQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4C90A6005A;
	Thu, 15 Oct 2026 12:18:43 +0200 (CEST)
Date: Thu, 15 Oct 2026 12:18:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg,
	lorenzo@kernel.org
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Message-ID: <atCogI3gNxxPjKxo@chamomile>
References: <20261011215953.1334630-1-pablo@netfilter.org>
 <as66prsWCk1qlQpm@chamomile>
 <21b46e85-49db-4c7f-9fd7-f32528f2dc4d@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21b46e85-49db-4c7f-9fd7-f32528f2dc4d@suse.de>

On Thu, Oct 15, 2026 at 11:48:39AM +0200, Fernando Fernandez Mancera wrote:
> On 10/14/26 1:11 AM, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > +Cc: lorenzo@kernel.org
> > 
> > This is a report on sashiko's findings:
> > 
> > https://sashiko.dev/#/patchset/20261011215953.1334630-1-pablo%40netfilter.org
> > 
> > On Sun, Oct 11, 2026 at 11:59:38PM +0200, Pablo Neira Ayuso wrote:
> > > Hi,
> > > 
> > > The following patchset contains Netfilter/IPVS updates for net-next:
> > > 
> > > 1) Disable br_netfilter in userns and schedule it for removal in 2027,
> > >     from Florian Westphal.
> > > 
> > > 2) Prepare the flowtable to support for IPv4 over IPv6 tunneling and
> > >     vice-versa, this includes 5 patches from Lorenzo Bianconi.
> > 
> > I am afraid this preparation series is enabling more than it should,
> > sashiko reports type confusion is possible, for example:
> > 
> >    1/5 netfilter: flowtable: recognize IPv4/IPv6 in tunnel proto matching
> > 
> > this adds the initial pre-processing of IPv6-over-IPv4.
> > 
> > But then, nf_flow_offload_lookup() expects to handle IPv4, not an IPv6
> > packet.
> > 
> > I will repost this PR keeping them back.
> > 
> > > 3) Update selftest nft_queue.sh to make it more stable on debug
> > >     kernels, from Jakub Kicinski.
> > > 
> > > 4) Fix a overflow in IPVS sync messages which can only happen in very
> > >     old 2.6 kernels, from Julian Anastasov.
> > > 
> > > 5) Flush conntrack gc worker when existing netns to address a unlikely
> > >     UaF, from Florian Westphal.
> > > 
> > > 6) Switch nf_tables chain types to use rcu, otherwise module removal
> > >     can trigger UaF, also from Florian.
> > > 
> > > 7) Add two new helper functions to validate that socket is of inet type,
> > >     coming in 2 patches from Florian Westphal.
> > 
> > sashiko reports:
> > 
> > "If an IPv4 packet from an AF_INET socket is encapsulated by an IPv6 tunnel,
> > the tunnel preserves the AF_INET socket in skb->sk while transmitting the
> > outer IPv6 packet on the LOCAL_OUT path."
> > 
> > This sounds like an unrelated issue, I don't know yet how that can
> > happen TBH.
> > 
> > > 8) Remove redundant parsing in nft_exthdr for the tcp options case,
> > >     from Fernando F. Mancera.
> > > 
> > > 9) Remove redundant skb_header_pointer() calls in nft_exthdr for tcp
> > >     options, from Fernando F. Mancera.
> > 
> > Sashiko here reports this now drops malformed packets instead of
> > NFT_BREAK, which is fine, maybe just extend it to tell about this in
> > the patch description.
> 
> Hi Pablo,
> 
> Should I re-post a v2 of this patch or will you ammend the commit message to
> add this bit?

I will amend the commit message here, no problem.
