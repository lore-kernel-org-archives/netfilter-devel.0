Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A5FDF76
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504334; cv=none; b=SM3FMk9OPP6opfpB3+eyJkFR7j0zaJw1Fpmy9bVA8Eeh6JUIcHO5eAqiXAkOjdO4YIoEhoCrdHC/W42IDnX8vC3pPUMup5nU/JNO/0ZXKeHey33seTLgq0YJHP9ic5r2TN8TsgfSDFSXfW923gBVLLhdAizhpxqF+L3afS1BxEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504334; c=relaxed/simple;
	bh=/IusKY2nVHjtJqghyfLbcwPPB4hvvjGG2Own33nQGdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ac5IFopjPnqcHAfY4L6Hm4mFDH8FmGIZSH2h6esx7OzeYDzW3UA6dsbTHr0Hw00mpgQy3p5YbvcrMohnK/fmoIArXPZOzsjECsR8M32/NMAII6L3uQlcCdj3nrMjBgzA05EqUJXPZLfYHdP1ZHoPMKVdjc1EGQjhunSEtpOwKKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AD3786058A; Fri, 09 Oct 2026 02:05:29 +0200 (CEST)
Date: Fri, 9 Oct 2026 02:05:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Zixuan Chai <petalzu987@gmail.com>, Ren Wei <weir@nebusec.ai>,
	netfilter-devel@vger.kernel.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, vega@nebusec.ai
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum
 offset
Message-ID: <asgvwg6IpZfqcKYg@strlen.de>
References: <cover.1789660425.git.petalzu987@gmail.com>
 <aq0UpHHbvxjR2jLb@strlen.de>
 <aq1HaYS96SNn7HJY@strlen.de>
 <CADTzadLvrvqbnUipgw4YG+ssa78vm5aUpDSoFZCnwQoOoeMYog@mail.gmail.com>
 <asfR13j04mKUELMQ@strlen.de>
 <asgnV5XFaS3V8g4W@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asgnV5XFaS3V8g4W@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 08, 2026 at 07:24:59PM +0200, Florian Westphal wrote:
> > Zixuan Chai <petalzu987@gmail.com> wrote:
> > > On Fri, 18 Sept 2026 at 22:15, Florian Westphal <fw@strlen.de> wrote:
> > > >
> > > > Florian Westphal <fw@strlen.de> wrote:
> > > > > > We will provide detailed information about the bug in this email,
> > > > > > along with a PoC to trigger it.
> > > > >
> > > > > patch is fine, but could you make another patch that either fixes
> > > > > ipv6_find_hdr() or ip6_packet_match() / nft_set_pktinfo_ipv6() as well?
> > 
> > FTR, ipv6_find_hdr() gained this check in
> > ee319bd3a0e9 ("ipv6: do not let ipv6_find_hdr() return an offset past the packet end")
> 
> Then this is fixed upstream in the core, now it validates that the
> offset provides enough room for the announced header.
> 
> This patch is now hardening that can follow up to nf-next using 
> DEBUG_NET_WARN_ON_ONCE?

Yes, I think this should get a v2, targetting nf-next.  It would also be
good to be consistent here: We have multiple interfaces:
nf_ip6_checksum, nf_checksum_partial, nf_ip6_checksum_partialm, nf_ip_checksum, ...

So I think there should be consistency there too, either none should
have checks or all of them should have DEBUG_NET_WARN_ON_ONCE() +
return where applicable.
