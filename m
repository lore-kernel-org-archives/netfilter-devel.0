Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659F2207A3B
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729089387; cv=none; b=O3ceFlvLgp3JI5oHMc0IC51f55CWz7o8dvKfcw3K93/bG0wqeO5mmYiHzuHRGdYI+ID3cNEUWdNGtrnPSdFouGjEV742tBMnFOvV3SkY/0c32LGqM/FZ0nWy6yZFw0/4Q3H40T/af7flM43kPFhMeGqYypxHA+Ig+lm/JZcSOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729089387; c=relaxed/simple;
	bh=Qc6ITKsZ7ChUtIRjQ0VfthnlZ4aVFZjvzs1ho0XkzxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCFZl4SC7pDgMgreiTv9eCwy1K3Ca7FwXbiUSVyS3m7zjF14ZdnuBhLAezb6xFuddDZr67qA+qmWf233CjmnTziBlx/EoGNnrCpwLq8c6REHgkNG+OLbpOwCAhjqWr9NKueZeX7jxPXEsRpFm9kAmcrtmqIdYPV/dLB7IIjFBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44432 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t158O-00CFMe-Bm; Wed, 16 Oct 2024 16:36:22 +0200
Date: Wed, 16 Oct 2024 16:36:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <Zw_PY7MXqNDOWE71@calendula>
References: <20241016131917.17193-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241016131917.17193-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Oct 16, 2024 at 03:19:07PM +0200, Florian Westphal wrote:
> v3:
> I failed to realize that nft_audit leaks one implementation detail
> to userspace: the length of the transaction log.
> 
> This is bad, but I do not know if we can change things to make
> nft_audit NOT do that.  Hence add a new workaround patch that
> inflates the length based on the number of set elements in the
> container structure.

It actually shows the number of entries that have been updated, right?

Before this series, there was a 1:1 mapping between transaction and
objects so it was easier to infer it from the number of transaction
objects.

> Also fix up notifications, for update case, notifications were
> skipped but currently newsetelem notifications are done even if
> existing set element is updated.
> 
> Most patches are unchanged.
> "prefer nft_trans_elem_alloc helper" is already upstreamed so
> its dropped from this batch.
> 
> 
> v2: only change is in patch 3, and by extension, the last one:
> During transaction abort, we need to handle an aggregate container to
> contain both new set elements and updates.  The latter must be
> skipped, else we remove element that already existed at start of the
> transaction.
> 
> original cover letter:
> 
> When doing a flush on a set or mass adding/removing elements from a
> set, each element needs to allocate 96 bytes to hold the transactional
> state.
> 
> In such cases, virtually all the information in struct nft_trans_elem
> is the same.
> 
> Change nft_trans_elem to a flex-array, i.e. a single nft_trans_elem
> can hold multiple set element pointers.
> 
> The number of elements that can be stored in one nft_trans_elem is limited
> by the slab allocator, this series limits the compaction to at most 62
> elements as it caps the reallocation to 2048 bytes of memory.
> 
> 
> 
> Florian Westphal (5):
>   netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
>   netfilter: nf_tables: prepare for multiple elements in nft_trans_elem
>     structure
>   netfiler: nf_tables: preemitve fix for audit failure
>   netfilter: nf_tables: switch trans_elem to real flex array
>   netfilter: nf_tables: allocate element update information dynamically
> 
>  include/net/netfilter/nf_tables.h |  25 +-
>  net/netfilter/nf_tables_api.c     | 368 +++++++++++++++++++++++-------
>  2 files changed, 304 insertions(+), 89 deletions(-)
> 
> -- 
> 2.45.2
> 
> 
