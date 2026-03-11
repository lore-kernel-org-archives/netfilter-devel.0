Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A5C1E8320
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773247414; cv=none; b=LHdXMv6xX/lDdkAu3WNXklHyiVlOZpjNLPzCETr89y+bq0S8htKjk3ylrXHBmEHUGttJAtkQFVH3e4JffSw1wNYPubKjD3gqyuyyQjyqA+jMbd40UtdQAlHD+OhhA09fyI1D2QIhJfftOllzJrBr690qRLzInVM+ynMOgzAaVQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773247414; c=relaxed/simple;
	bh=1d2oN85vzxvJCIr+pAmI9u8T2DB9cK7CmLzpTuycfaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rr70TuiZYUT2r6FEicKHj4UnwG5CB193Mbdt2dO6evPVGycXj0V4s530Ax1ALBFWW+utkoksgHFVbfErwsvQu6ILWhyScU6J4hnJ8zRvk6iLn3S7UY55hxlU3Etaz3ftuBppctGaP/TUCxnv7r3wYGomj3vUyXNKJDjWt3ut8CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t94E2Gzd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t94E2Gzd"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4965E60269;
	Wed, 11 Mar 2026 17:43:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773247410;
	bh=YW3sXbsEoO8mtpzd5os3CcB99RpWPSmGXGwwLr1QbJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t94E2Gzd2iB1LeCZINXK16Yq2fURg+hgtwPr5DJYbuUWcYyijSt+LGHygA5jcSr4n
	 D8r/4kTGElFqApL206aU+gXwtDdkxfss3QcGAPiIWjiKiKOCDqLB4Q6vqvKhfEtbsu
	 Tp4vb0hfTxgkAXi90cw0KEYQ6oUq5U/1SWOxb1LWXMYxma03uWuO085Vt53sBhgb/B
	 bQO4sXw/dK/GRQ0dOwLodwefhlGVhy9SItCX5H4384aXdQNfTbrrD8TPK01T2qBRVj
	 mx9fMO+ZPkYQC4OWV3ygnkSQYI7M2PBD7Z7Cd02nXs4+Zg0empH9aXlNXlVNTEtgvC
	 sD5M+ghTS+Ryg==
Date: Wed, 11 Mar 2026 17:43:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chris Arges <carges@cloudflare.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array
 size on updates
Message-ID: <abGbr0xbcAvRDMUZ@chamomile>
References: <20260307001124.2897063-1-pablo@netfilter.org>
 <abGYhwlvCWKoKNmm@20HS2G4>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abGYhwlvCWKoKNmm@20HS2G4>

On Wed, Mar 11, 2026 at 11:29:59AM -0500, Chris Arges wrote:
> On 2026-03-07 01:11:24, Pablo Neira Ayuso wrote:
> > The array resize function increments the size of the array in
> > NFT_ARRAY_EXTRA_SIZE slots for each update, this is unnecesarily
> > increasing the array size.
> > 
> > To determine the number of array slots:
> > 
> > - Use NFT_ARRAY_EXTRA_SIZE for new sets.
> > - Use the current maximum number of intervals in the live array.
> > 
> > Reported-by: Chris Arges <carges@cloudflare.com>
> > Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: fix crash with new sets, reported by Florian.
> > 
> >  net/netfilter/nft_set_rbtree.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> 
> Pablo,

Chris,

> I was able to test with this patch applied on top of v6.18.16; however the
> memory consumption remained high and similar to v6.18.16 without this patch.

Makes no sense to me.

> My VM reproducer runs the services and checks for slab memory increases. In a
> passing test case, the unreclaimable slab memory reaches about 1.4G and
> stabilizes. In a failure test case unreclaimable slab memory goes beyond 4.4G
> then the process gets OOM killed due to cgroup memory limits.

I have to review again what I posted. You mean, memory keeps for each
dynamic update, increasing until it reaches OOM?

> Also, using this reproducer I re-verified that this patch is what changes
> slab memory.stat characteristics from within the cgroup:
> - 7e43e0a1141d netfilter: nft_set_rbtree: translate rbtree to array for binary search
> 
> Finally, I reverted the following patches from v6.18.16 and re-tested using my
> reproducer:
> - 648946966a08 netfilter: nft_set_rbtree: validate open interval overlap
> - 782f2688128e netfilter: nft_set_rbtree: validate element belonging to interval
> - 35f83a75529a netfilter: nft_set_rbtree: don't gc elements on insert

Are you using timeout in your set?

> - 5599fa810b50 netfilter: nft_set_rbtree: remove seqcount_rwlock_t
> - 2aa34191f06f netfilter: nft_set_rbtree: use binary search array in get command
> - 7e43e0a1141d netfilter: nft_set_rbtree: translate rbtree to array for binary search
> In this instance memory allocations were again around 1.4G.
> 
> Any suggestions for other tests, I can rebuild with memory debugging config as
> well.
> 
> Also, could there be an option here to opt-out of this performance optimization
> in favor of retaining existing memory characteristics?

This series is fixing a real bug, now you may experience possible
false negatives in lookups with what you have reverted.

I am going to collect memory numbers and post them here, I will try to
mimic a script from your description.
