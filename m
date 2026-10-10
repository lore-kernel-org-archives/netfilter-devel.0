Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6076393DDC
	for <netfilter-devel@vger.kernel.org>; Sat, 10 Oct 2026 08:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791622030; cv=none; b=l7r4698Ge3uMjSxl3oCO8ytorDmlrFduZvcjOeSw4g1IGg0yaRAf9s7NdXGizhYIVM0KilknHSILYlFvSetJeVprfkRdl6rcUrpwXnUf9CwlSFHvJZuNpTYbl7eOaaPXdo972z0M1UAfMrd3o4VpGfNKuspvFOFXLB3llZhNfqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791622030; c=relaxed/simple;
	bh=BosFRCJopyDMi4EOFanGMuMnL8GsHaX4HY/FVpY2zB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dLFdnhrW0jarc0CPblvDBzjucYeof/NUxVEupN0uiO3VQ54fHXfAiyWl+bFd4NV6RR+/fECmoky24bKQyEARpJV4hZsI1YBIDBBJu0WV7NSHbkZJW6dESZXOSvkGMOlQovH5KPuJlbbbLxtlX7WHJHe5PfAl2c3h3S3bGC1ga8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 909966028B; Sat, 10 Oct 2026 10:46:59 +0200 (CEST)
Date: Sat, 10 Oct 2026 10:46:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Jeremy.Jean@oss.cyber.gouv.fr
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: narrow down range
 completion to anonymous sets
Message-ID: <asn7d2tlQpi6Zcix@strlen.de>
References: <20261007220358.1140284-1-pablo@netfilter.org>
 <asc5Bsrgv_w7lVOq@strlen.de>
 <asd18Ow3-mYwVQMS@chamomile>
 <asd2AaXSM9oDeich@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asd2AaXSM9oDeich@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 08, 2026 at 12:52:35PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 08, 2026 at 08:32:54AM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > For anonymous sets, when adjacent ranges are found, the end element is
> > > > not added to the set to pack the set representation. Use next start
> > > > element to complete this interval.
> > > > 
> > > > Jérémy Jean says:
> > > > 
> > > > Consider two ranges in a netfilter verdict map:
> > > > * keys 10-19 accept packets, and
> > > > * keys 30-39 jump to chain 'victim'.
> > > > Now, delete the end marker at 20. The lookup array now uses element 30
> > > > as the first range's end, so an INTERVAL_END query for key 15 returns
> > > > element 30, including its jump verdict and chain pointer. This can make
> > > > KASAN reports a UAF after the GC releases reference chain for 30 that
> > > > has expired:
> > > 
> > > Dumb question: How is it possible to remove an element if the map is
> > > anonymous?
> > 
> > I suspect this is a strange combination which cannot be reached from
> > userspace.
> 
> I mean, via nft.

Even with netlink API: DELSETELEM has:

        if (nft_set_is_anonymous(set))
                return -EOPNOTSUPP;

Jérémy, can you share what your reproducer is doing to get the rbtree
map into the bad state?

Thanks!

Just to be clear: this patch is fine, but I a) wonder if there is
some other bug elsewhere, and b) if we can make a test case for
this for either nftables.git or knft so that this is covered.
