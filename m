Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904EE14F12F
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724086483; cv=none; b=dXt+xq3jBY8ESxNav9Rp1iIGjunNsvyx0EiM+BrpvMJjZzsgpOBkxB7sKUK5maLKcll3m3hgcndeovEaH19NcMGPNDoy5rnC7dVKRkC1arfxnOUzd9IlK4dzAn+D3yMQmkJbfdz5ZAIZdsqydzQOyjUgk5tYf9BlAkr95T9T724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724086483; c=relaxed/simple;
	bh=LkZYPWPlLSydbO3Mr6giS+fEW+dp8qhgyMf+ZB9p/eY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eu8wUT8FeSKCn04Ak7E96POsHaE99Mtnfj04ir4dUPvdFmvQx82zZnVvxZ7WpfqSQ1xQK9JL53tM0MxfoD/4+hnjZSyDE4lGyfh8flwdLGIVIQYvIC1vZ81uWDS0FB+THHWj0cmcDzyl9qJ8BDpjDD9uzSMOfMh9h2Ji6ljoAOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=54084 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg5eO-005bKh-EQ
	for netfilter-devel@vger.kernel.org; Mon, 19 Aug 2024 18:54:38 +0200
Date: Mon, 19 Aug 2024 18:54:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: do not remove elements if
 set backend implements .abort
Message-ID: <ZsN4y1B-STHtyawo@calendula>
References: <20240715141556.44047-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240715141556.44047-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

On Mon, Jul 15, 2024 at 04:15:56PM +0200, Pablo Neira Ayuso wrote:
> pipapo set backend maintains two copies of the datastructure, removing
> the elements from the copy that is going to be discarded slows down
> the abort path significantly, from several minutes to few seconds after
> this patch.
> 
> This patch was previously reverted by
> 
>   f86fb94011ae ("netfilter: nf_tables: revert do not remove elements if set backend implements .abort")
> 
> but it is now possible since recent work by Florian Westphal to perform
> on-demand clone from insert/remove path:
> 
>   532aec7e878b ("netfilter: nft_set_pipapo: remove dirty flag")
>   3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
>   a238106703ab ("netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone")
>   c5444786d0ea ("netfilter: nft_set_pipapo: merge deactivate helper into caller")
>   6c108d9bee44 ("netfilter: nft_set_pipapo: prepare walk function for on-demand clone")
>   8b8a2417558c ("netfilter: nft_set_pipapo: prepare destroy function for on-demand clone")
>   80efd2997fb9 ("netfilter: nft_set_pipapo: make pipapo_clone helper return NULL")
>   a590f4760922 ("netfilter: nft_set_pipapo: move prove_locking helper around")
> 
> after this series, the clone is fully released once aborted, no need to
> take it back to previous state. Thus, no stale reference to elements can
> occur.

I have now rescued this patch and place it in nf-next.
