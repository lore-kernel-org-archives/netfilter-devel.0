Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CDC388E62
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791480311; cv=none; b=GdLouLQyJPQJOdNhjwKrT1OxgNqoBsBIvxZ9+GXKLKPuwNq5RElpc2Q3bKIqPmV+F/WCLCN5DpcaFABTyQV/qruTSPzB25j6NYxnf4wWnqa5EmZMBNU0cKuomDe4wqjjaFoUQj89b1+3WpSD4JEqOGvAc+xFY/DObfxfLqO2bVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791480311; c=relaxed/simple;
	bh=/V/6vMzZ1fhGS2QiYEc2BaHoi5X/GC9+Wlwks8zqcSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzMLmNDZvAGuT3Fz2KkZzVm05ZI/anJvj8iuay/VVD73BdLFUSxWUo4v3+j7H/H8LoBFJqkv7yJe3aMtJg3kIZBjXLpTnKRrOFwpkM3PReozqmWUqv+zyQz/c4PWjXEjJaqa084nm9/lORgx4vMnKYqpuebgOF7FanCutqn/UCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 950236059E; Thu, 08 Oct 2026 19:25:00 +0200 (CEST)
Date: Thu, 8 Oct 2026 19:24:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Zixuan Chai <petalzu987@gmail.com>
Cc: Ren Wei <weir@nebusec.ai>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, vega@nebusec.ai
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum
 offset
Message-ID: <asfR13j04mKUELMQ@strlen.de>
References: <cover.1789660425.git.petalzu987@gmail.com>
 <aq0UpHHbvxjR2jLb@strlen.de>
 <aq1HaYS96SNn7HJY@strlen.de>
 <CADTzadLvrvqbnUipgw4YG+ssa78vm5aUpDSoFZCnwQoOoeMYog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADTzadLvrvqbnUipgw4YG+ssa78vm5aUpDSoFZCnwQoOoeMYog@mail.gmail.com>

Zixuan Chai <petalzu987@gmail.com> wrote:
> On Fri, 18 Sept 2026 at 22:15, Florian Westphal <fw@strlen.de> wrote:
> >
> > Florian Westphal <fw@strlen.de> wrote:
> > > > We will provide detailed information about the bug in this email,
> > > > along with a PoC to trigger it.
> > >
> > > patch is fine, but could you make another patch that either fixes
> > > ipv6_find_hdr() or ip6_packet_match() / nft_set_pktinfo_ipv6() as well?

FTR, ipv6_find_hdr() gained this check in
ee319bd3a0e9 ("ipv6: do not let ipv6_find_hdr() return an offset past the packet end")

> > To clarify, I agree with this patch, I don't mean that the other
> > patch should replace this one. I see them as separate issues, so:
> 
> When you have a moment, could you please let me know if any further
> changes would be helpful for this patch? I would be happy to send a
> revised version if needed.

netfilter patchwork is clogged up/backlogged, unfortunately.

> > ipv6_skip_exthdr() may have the same issue.
> 
> I have also been looking into the ipv6_skip_exthdr() issue you
> mentioned. I think it needs further evaluation, but so far I have
> not been able to construct a PoC similar to the one for the
> checksum issue.

> One attempt is this series:
> https://lore.kernel.org/all/cover.1790082243.git.petalzu987@gmail.com/
> 
> I am not sure whether this issue warrants a fix, so I would
> appreciate your thoughts on whether it is worth pursuing.

Wrt 2/2 Eric is right, I never reported an issue with i40e.
The ipv6_skip_exthdr() change in patch 1/2 looks good to me.

The other changes in 1/2 should probably be in a different patch;
I feel its doing too many different things at the same time.
