Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156421F8755
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 14:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786285455; cv=none; b=MQEdy5XcwxtVuo8aIFpz3DdYpBOUS5xweEh/gFl6+xvtFHsiV3gdAKASVowR5O5onrZVeexBRXqV7m+H8/+qy9fqZa+OATT1CtLhYsuAnXnmYu35WcsIEh6upvKAmoTdOGBQNROHMrkU+2E5ryn7ghU913nOgztLGR2xUbSNWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786285455; c=relaxed/simple;
	bh=qVZtYuE8Z9A1yQM9R2KdpvWRegazb/4E1pQuexMP4FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8xtYw9BmjBvuVrBp5zyqZEIi0hZIjxuqhAVhhVxHOgRaXdn79ZbWePI8yb7ulUrazv7f8QIZ3aLym8yANlvEtNw6YeVex6rgkd2ev7tymS1nRdLoeyUVlyP3KQYhpDrVniYQshldtw1sfNS/90LjI+5GLnwRjVGvg6a2qX2tTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5E9FC6051B; Sun, 09 Aug 2026 16:24:12 +0200 (CEST)
Date: Sun, 9 Aug 2026 16:24:12 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: remove need to allocate memory on
 delete operations
Message-ID: <aniNjO71_0Bv2UMI@strlen.de>
References: <20260804170214.27237-1-fw@strlen.de>
 <abb4fda6-444f-2c79-573a-740529e468c9@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abb4fda6-444f-2c79-573a-740529e468c9@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> >  /* Book-keeping of the prefixes added to the set */
> >  struct net_prefix {
> > -	u8 cidr;			/* the cidr value */
> > -	u32 count;			/* number of elements of this cidr */
> > +	u32 cidr:8;
> > +	u32 count:24;
> >  };
> > +#define CIDR_MAX_COUNT ((1 << 24) - 1)
> 
> Could it be changed to
> 
> struct net_prefix {
>      u64 cidr:8;
>      u64 count:24;
> };
> #define CIDR_MAX_COUNT ((1 << 56) - 1)
> 
> (and the other required changes below)?

Only for 64bit builds, because WRITE_ONCE() is not atomic on 32bit.
If we do it for 32 bit builds, all read side paths would need to
switch to write seqcount use (including the normal case, i.e.
nets[i]->count++ / count.  ATM only the "it became 0 and has
to be moved) uses  the sequence write lock, so read side never
retries for typical updates.

> 2**24 is a lot but still a reachable limit.

Hmm. 16m entries...  I guess its possible for very small prefix
lengths?  We could use BITS_PER_LONG == 64 but it gets more ugly then.

> > +	if (np.count) {
> > +		WRITE_ONCE(nets->nets[found], np);
> >  		goto unlock;

This should be the typical case, which doesn't change the
write seq side, hence no retry on reader side.

This would have to be changed if we no longer rely
on READ/WRITE_ONCE.
