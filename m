Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E0C1A23B1
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 21:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753738141; cv=none; b=HMk7g+aoq4VtyWa1f3iHxoEkG8XbGDBSTdeg6cL/x+RLXV3IPHXY8Ebs1rCFf4zJpnQ+xtZxfhoFmO5yc12VOSCATIbCbjl6TtstugnENAr7OCtnwhudtywe6d62np0/8YrLdvUEku1dwQysk2PdfhhlEOWjfdoVK1RbhwFXV2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753738141; c=relaxed/simple;
	bh=xkUDyEAknglelpWx562Dol/FTwX1PnBo+/Y0HGchmVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcDE8yf/Q6s05SwQzT51okBxbf9FfQFZDOX7zjgYcrHlVG5ApdCFQyXtL/pDCJJx+4Cd8XLmEnLJcYn2oL8GQIBoceZggEdeNwje45i82hHs5GaqDO5WiANv6Ic8lnSyKxoBpYI8CPAAxksTsNUiT22NquKqSUstVzP4T9vfOMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 43A93605E6; Mon, 28 Jul 2025 23:28:51 +0200 (CEST)
Date: Mon, 28 Jul 2025 23:28:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIfrktUYzla8f9dw@strlen.de>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIOcq2sdP17aYgAE@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Yes, u32 flush_id (or trans_id) needs to be added, then set
> transaction id incrementally.

Not enough, unfortunately.

The key difference between flush (delete all elements) and delset
(remove the set and all elements) is that the set itself gets detached
from the dataplane.  Then, when elements get free'd, we can just iterate
the set and free all elements, they are all unreachable from the
dataplane.

But in case of a flush, thats not the case, releasing the elements will
cause use-after-free.  Current DELSETELEM method unlinks the elements
from the set, links them to the DELSETELEM transactional container.

Then, on abort they get re-linked to the set, or, in case of commit,
they can be free'd after the final synchronize_rcu().

That leaves two options:
1.  Use the first patchset, that makes delsetelem allocations sleepable.
2.  Add a pointer + and id to nft_set_ext.

The drawback of 2) is the added mem cost for every set eleemnt (first
patch series only forces it for rhashtable).

The major upside however is that DELSETELEM transaction objects are
simplified a lot, the to-be-deleted elements could be linked to it by
the then-always-available nft_set_ext pointer, i.e., each DELSETELEM
transaction object can take an arbitrary number of elements.

Unless you disagree, I will go for 2).
This will also allow to remove the krealloc() compaction for DELSETELEM,
so it should be a net code-removal patch.

Another option might be to replace a flush with delset+newset
internally, but this will get tricky because the set/map still being
referenced by other rules, we'd have to fixup the ruleset internally to
use the new/empty set while still being able to roll back.

Proably too tricky / hard to get right, but I'll check it anyway.
