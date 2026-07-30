Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0462C3A168B
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785441356; cv=none; b=GdlhxV9TWnIr42CZT6VJCZuYkCIYhe7IgAZQNAesd7MgfqKm7NGDUBGl34OoVtizntkmm+zVUe8FSwqjF23hlhzsV1iof0x/9K/4I1fsBg5MIUYJr5k/9CeSTWbuoHM6m1wxruyVFWTGGuOKAh0O5UiLM2i/bBChTCF0OEL09yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785441356; c=relaxed/simple;
	bh=doccRQ8u2EPhVB5mZ84ItTljLjFnthfEV6d//P8h76s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BAEpOzwqLehyjj6zcUBW2orpYmhgJlW7PD+LN/kLr4aiPS2M4bgmEIXVVfZeYX1mQIrxRF/ilS8uwnvkrSILhUJGAO08nhpdXXgbKU6FdD4JdFlyBoLWgYFl0WhWAEUIQcmL60FP9R3a8m9J8vbQR/zAC5TyCDP1zKmS479wmto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 265A360380; Thu, 30 Jul 2026 21:55:51 +0200 (CEST)
Date: Thu, 30 Jul 2026 21:55:50 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org
Subject: Re: [PATCH nf 0/5] netfilter: ipset fixes and rhastable prep work
Message-ID: <amusRhSn19YQzmQe@strlen.de>
References: <20260730183853.21868-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730183853.21868-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> This series contains a few fixes and prepation work for the
> ipset rhashtable conversion.  The rhashtable conversion patch set is
> too large to post in one pile and has one external dependency that is not
> yet in nf (queued in crypto tree).
> 
> I discussed this with Jozsef and we think that targeting the rhashtable
> conversion to nf tree is preferrable to nf-next due to the volume of LLM
> reports.
> 
> 1) Rework ipset CIDR bookkeeping with an RCU-based method to ensure
> safety on weakly-ordered architectures. Replace in-place updates with
> structure replacement. From Jozsef Kadlecsik.

1 & 2 two trigger sashiko reports, but I ask that those are ignored:
https://sashiko.dev/#/patchset/20260730183853.21868-1-fw%40strlen.de

'Is it safe to modify h->rnets[i] and call kfree_rcu() here without holding
set->lock?'

No.  This is resolved in the rhashtable conversion, which introduces
synchronization between delete and flush: only one thread can detach the
element from the rhashtable, those observing the -ENOENT will skip the
element.

>  #ifdef IP_SET_HASH_WITH_NETS
>  	for (i = 0; i < IPSET_NET_COUNT; i++)
> -		mtype_add_cidr(set, h, NCIDR_PUT(DCIDR_GET(d->cidr, i)), i);
> +		mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);

'Does this code correctly handle memory allocation failures?'

No.  I added this handling in the rhashtable conversion, as that has to
rewrite most of that function anyway.

> 2) Switch ext_size to atomic64_t in ipset to prevent races during parallel
> updates.  Also from Jozsef.

'This isn't a bug introduced by this patch, but can a race condition during hash
table resizing and concurrent element updates lead to a double free of comment
extensions here?'

Yes, this is also resolved when converting to rhashtable, the resize
callback is removed.

'This is a pre-existing issue, but does asynchronous element destruction in
list_set_flush() race with this synchronous zeroing of set->ext_size, causing
an integer underflow?

If a user flushes a list:set ipset, list_set_flush() forces the counter to 0
here. The elements are queued for asynchronous deletion via call_rcu() inside
list_set_del().'

I will have another look at this to see if thats correct, in any case
this should be handled in a different change.
