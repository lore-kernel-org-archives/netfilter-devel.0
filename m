Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B1835972
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742304274; cv=none; b=JRJc9iB0ViS3e2XT/XfbIASsdq+mAprDXCDRAcJRLRSeEVQXCBTdRnPuibUePUQOyB7hZOYZCQLzcRqhX+D05JshXT165js2Yfbgz4+pIR07776eImPPbhUhCScMqMmOV/MUgBcTrlmlttCIH8qk/3eNny2k9cSZ0o+5xo6ycHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742304274; c=relaxed/simple;
	bh=hnMHgcN/6Frw1zQRFq8xVym1l3HoB0JQqkOhLvi18QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hr9vqHeTc7rp6CEOM9bwB0Eue9llTlASqskHHk69Gn1HPvXnLDJZoDUrNETbeoiUUUhmLbc+y5w5nFNF0BpbRgq2bmRru17PdopkC2ObGdCE2/cP3hTy5VbC6lvljfulHq/RhRBALN7a9jmGFFozxOVqwXCfF87++IQ+lPNRcbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tuWvi-0005TP-7S; Tue, 18 Mar 2025 14:24:26 +0100
Date: Tue, 18 Mar 2025 14:24:26 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink: fix stack buffer overrun when emitting
 ranged expressions
Message-ID: <20250318132426.GB20865@breakpoint.cc>
References: <20250314124159.2131-1-fw@strlen.de>
 <Z9lmBhYELKyJHHOk@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9lmBhYELKyJHHOk@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Fri, Mar 14, 2025 at 01:41:49PM +0100, Florian Westphal wrote:
> > Included bogon input generates following Sanitizer splat:
> > 
> > AddressSanitizer: dynamic-stack-buffer-overflow on address 0x7...
> > WRITE of size 2 at 0x7fffffffcbe4 thread T0
> >     #0 0x0000003a68b8 in __asan_memset (src/nft+0x3a68b8) (BuildId: 3678ff51a5405c77e3e0492b9a985910efee73b8)
> >     #1 0x0000004eb603 in __mpz_export_data src/gmputil.c:108:2
> >     #2 0x0000004eb603 in netlink_export_pad src/netlink.c:256:2
> >     #3 0x0000004eb603 in netlink_gen_range src/netlink.c:471:2
> >     #4 0x0000004ea250 in __netlink_gen_data src/netlink.c:523:10
> >     #5 0x0000004e8ee3 in alloc_nftnl_setelem src/netlink.c:205:3
> >     #6 0x0000004d4541 in mnl_nft_setelem_batch src/mnl.c:1816:11
> > 
> > Problem is that the range end is emitted to the buffer at the *padded*
> > location (rounded up to next register size), but buffer sizing is
> > based of the expression length, not the padded length.
> > 
> > Also extend the test script: Capture stderr and if we see
> > AddressSanitizer warning, make it fail.
> > 
> > Same bug as the one fixed in 600b84631410 ("netlink: fix stack buffer overflow with sub-reg sized prefixes"),
> > just in a different function.
> > 
> > Apply same fix: no dynamic array + add a length check.
> 
> While at it, extend it for similar code too until there is a way to
> consolidate this? See attachment.

Sure, I can merge your snippet and push it out, is that okay?
