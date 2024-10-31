Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23B519CC1D
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 23:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416932; cv=none; b=up7jNpKG8rQZTT7kcG4bMWwF4Zq1cxx2PADBHHChhs5tr8uQNwuXW0y/x4eSrW/l67+OTzDQJXadV3sWJ6TNkfMAHlQr8FSlpRc7iwpXkeoiT+63H/6xC2rK63qbde1A6sNz0b0kEneL0hM1OpGrICmM5xeOdH4ovqQqbDbIE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416932; c=relaxed/simple;
	bh=iyopvaA7YmmsMYAe/TFp09GMzSWfZaK3CpaRxCeG/HY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6lfr8Xzbobmbm6GYIfy8G5Cbr+mAmpv1Kj7cRQ1od0itgcss/CcbGUHiWqmHzUT8yLpR7gkcpVAKkZwiUOO9xpI+pQcTT6idhFi0Wqa//r9IVbP8HLj6YLQltCRRi48KmjWLTHh19Czm9nFbuuezMggPJPlLTFCwQzHWBjNBeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6eUL-0001pu-KA; Fri, 01 Nov 2024 00:22:01 +0100
Date: Fri, 1 Nov 2024 00:22:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <20241031232201.GB6345@breakpoint.cc>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
 <ZyQHv5lxlCrciEiq@calendula>
 <20241031230214.GA6345@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031230214.GA6345@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > # nft -f test.nft
> > test.nft:3:32-45: Error: Could not process rule: Operation not supported
> >                 udp dport 4789 vxlan ip saddr 1.2.3.4
> >                                ^^^^^^^^^^^^^^
> > 
> > Reverting "netfilter: nf_tables: must hold rcu read lock while iterating expression type list"
> > makes it work for me again.
> > 
> > Are you compiling nf_tables built-in there? I make as a module, the
> > type->owner is THIS_MODULE which refers to nf_tables.ko?
> 
> Indeed, this doesn't work.
> 
> But I cannot remove this test, this code looks broken to me in case
> inner type is its own module.
> 
> No idea yet how to fix this.

Can you apply the series with out patch 6?
Someone else should look at it, i can't find a
good solution, this would need a rewrite to obtain
a reference on the type AFAICS.

I could cmp for nft_payload_type/nft_meta_type instead
but I feel its cheating and fragile too.
