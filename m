Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6851A2D6638
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 16:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753893332; cv=none; b=sDECamtxuLsv18FHSZ/7c+KMA4si9aQAr0HIIZU9t6nBuaq6Bk15JfDRohDIJNHPeeErdopp7vrqH/TuNJugiL9sXWag5iy4kTNqW/R4XrOAu9A2/kUbeLuD6jBsqk/xyWxbjXffDlayugI9UsRTi0X2XJXpzO+tlOJvQW+GnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753893332; c=relaxed/simple;
	bh=6Rx5bCk0GBzKv3jiGxdoUSJNJ+IcX+VKB4kqJbtSBCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUIzNqgsAZnqmgLc7NJuy23BPcYWsRr54RQujYHochIz6LjRjSeNy6NHJniEU4D7v354/aN5+Gu6T1jIz6ReB/Vh7UEIFnBqbaGJlgl9QuoA/jZ2nDfrnRPDFznPnZhvKLmTOAHI096nhXWbRK0H7PMIMj0e7DVemUV9f7CZYCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3CD016035A; Wed, 30 Jul 2025 18:35:21 +0200 (CEST)
Date: Wed, 30 Jul 2025 18:35:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIpJur3wIzswyaAe@strlen.de>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
 <aIfrktUYzla8f9dw@strlen.de>
 <aIikwxU686KFto35@calendula>
 <aIiyVnDlbDTMRqB-@strlen.de>
 <aIpFWePr6BfCuKgo@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIpFWePr6BfCuKgo@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Yes, that part works, but we still need to kfree the elements after unlink.
> > 
> > When commit phase does the unlink, the element becomes unreachable from
> > the set.  At this time, the DELSETELEM object keeps a pointer to the
> > unlinked elements, and that allows us to kfree after synchronize_rcu
> > from the worker.  If we don't want DELSETELEM for flush, we need to
> > provide the address to free by other means, e.g. stick a pointer into
> > struct nft_set_ext.
> 
> For the commit phase, I suggest to add a list of dying elements to the
> transaction object. After unlinking the element from the (internal)
> set data structure, add it to this transaction dying list so it
> remains reachable to be released after the rcu grace period.

Thats what I meant by 'stick a pointer into struct nft_set_ext'.
Its awkward but I should be able to get the priv pointer back
by doing the inverse of nft_set_elem_ext().

The cleaner solution would be to turn nft_elem_priv into a
'nft_elem_common', place a hlist_node into that and then
use container_of().  But its too much code churn for my
liking.

So I'll extend each set element with a pointer and
add a removed_elements hlist_head to struct nft_trans_elem.

The transacion id isn't needed I think once that list exist:
it provides the needed info to undo previous operations
without the need to walk the set again.

We can probably even rework struct nft_trans_elem to always use
this pointer, even for inserts, and only use the 

struct nft_trans_one_elem       elems[]

member for elements that we update (no add or removal).
But thats something for a later time.
