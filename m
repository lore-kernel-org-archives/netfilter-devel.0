Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6B7331A49
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 20:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774557002; cv=none; b=eUqVOKUznpeliHzomluDXdoGIqpeYmJZ565ML0WH0uUMeFSgwBfhPMg6rypp4E2rNMSGQNKYrPerywVrqyxRRMI1IyMkAERisrPkKFBb+UiDBWQqAyefXSnzG048RnFyJVRU0rfuiWcbqr4l7vJ2V/KZkJjCT5aPb70pE6SwsYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774557002; c=relaxed/simple;
	bh=tiMJKbiYfwmiVXF+PyVICpSg4h2BG0Vp0LzFlM6/Ghk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cl3hFyVv+SzIPtru9ZaQcYVQfss4foKfUqC09TQJkUTUx7Pxsa7nt1aipXpfr2dOcMibk6OIuEJ60G064FEDGvgeyKkJjCHhu/EIJB3BWSRFhKVqNK9SARnzuubq4f/YxEKZQr9YiiKiv7h67y/jPmmTKkkFA3iDif9r7rYSYtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eoknFNyf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eoknFNyf"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8AA51600B9;
	Thu, 26 Mar 2026 21:29:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774556998;
	bh=feqeap2k/pMNwxTUKpXqnHAIUTfEzV3N5xr8F58o4Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eoknFNyfzGfUlEiHdu6gT4NjCc1Kq+9kuwTXuDZf18bjV6I42NKGb7YuIhgXkUpGI
	 89g6vyP49a0/YFxNy2vZPg6aNosXituKTNQHtDfmQqG7+G6G4V81UKL3rIweRExsFO
	 9Bfwe1DVHxAWm8iZTnecMaNZPWHpWgqB8krTpeg2UCs0hOs8PL/z4P00rvRQlZU8fG
	 gQkkyW806g4A/MceqFy1eof+pnzx0G+tmCWb0WNrCgJbc+OFPgIaSckZ2qfGj9f/Pb
	 rRrdypt3nFV6qWipJkVmVYMKFn5ldC0/HtYvkJ6eXW2y5Shvezv6szrFqufWGjXV/O
	 4gHQQb/T8gZdQ==
Date: Thu, 26 Mar 2026 21:29:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chris Arges <carges@cloudflare.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v4] netfilter: nft_set_rbtree: revisit array resize
 logic
Message-ID: <acWXQ1JOmB6Qqdjj@chamomile>
References: <20260317170721.12396-1-pablo@netfilter.org>
 <abrI8CZV3c8fi9x3@20HS2G4>
 <abrZkrarLXbZzXEO@chamomile>
 <acF4eJn_ZSdHe635@20HS2G4>
 <acSBDEog6wFw7Khp@20HS2G4>
 <acSBdDCsD5KAiU-2@20HS2G4>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acSBdDCsD5KAiU-2@20HS2G4>

On Wed, Mar 25, 2026 at 07:44:36PM -0500, Chris Arges wrote:
> On 2026-03-25 19:42:54, Chris Arges wrote:
> > On 2026-03-23 12:29:30, Chris Arges wrote:
> > > On 2026-03-18 17:57:54, Pablo Neira Ayuso wrote:
> > > > On Wed, Mar 18, 2026 at 10:46:56AM -0500, Chris Arges wrote:
> > > > > On 2026-03-17 18:07:21, Pablo Neira Ayuso wrote:
> > > > > > Chris Arges reports high memory consumption with thousands of
> > > > > > containers, this patch revisits the array allocation logic.
> > > > > > 
> > > > > > For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
> > > > > > Expand it by x2 until threshold of 512 slots is reached, over that
> > > > > > threshold, expand it by x1.5.
> > > > > > 
> > > > > > For non-anonymous set, start by 1024 slots in the array (which takes 16
> > > > > > Kbytes initially on x86_64). Expand it by x1.5.
> > > > > > 
> > > > > > Use set->ndeact to subtract deactivated elements when calculating the
> > > > > > number of the slots in the array, otherwise the array size array gets
> > > > > > increased artifically. Add special case shrink logic to deal with flush
> > > > > > set too.
> > > > > > 
> > > > > > The shrink logic is skipped by anonymous sets.
> > > > > > 
> > > > > > Use check_add_overflow() to calculate the new array size.
> > > > > > 
> > > > > > Add a WARN_ON_ONCE check to make sure elements fit into the new array
> > > > > > size.
> > > > > > 
> > > > > > Reported-by: Chris Arges <carges@cloudflare.com>
> > > > > > Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> > > > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > > ---
> > > > > > v4: use maybe_grow: goto tag instead of grow:
> > > > > >     Add note in commit description: "The shrink logic is skipped by anonymous sets."
> > > > > > 
> > > > > 
> > > > > I will be able to testing this more in depth early next week. Just to confirm,
> > > > > this patch requires this to be applied first?
> > > > > https://lore.kernel.org/netfilter-devel/20260307001124.2897063-1-pablo@netfilter.org/
> > > > 
> > > > Yes, it requires that fix to be applied first.
> > > 
> > > Thanks, these two patches applied on 6.18 stable show slab unreclaimable memory
> > > leveling out at 1.5GB for my local reproducer. I'll be deploying this to a
> > > wider set of machines for more real-world testing this week.
> > > 
> > > So far seems good.
> > > --chris
> > 
> > We have deployed this successfully and memory usage looks good in production.
> > 
> > Tested-by: Chris Arges <carges@cloudflare.com>
> > 
> > --chris
> 
> Oh I see it's queued up here:
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260325222615.637793-8-pablo@netfilter.org/
> Thanks for fixing this!

Yes, I did not get in time to add your Tested-by: tag.

Thanks for testing in any case!
