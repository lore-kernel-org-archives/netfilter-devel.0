Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6285D3A8724
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 11:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817487; cv=none; b=XR0+WYyIFqXeiwW8hmBCd4NCisVe17EsekVWR/DMgJulWzW+91kSZUdVANgC1QiVaKTOlCHMBrnUvvTYlWTZqt/XH3zd8H3g/F/rkQkSYqEOSe6EkEqXxfkhjnJYm+LoIEhiC2SfHicDuEegL1eZzrdQslSO9UDX6vOzr82C5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817487; c=relaxed/simple;
	bh=Bv+XyTVB7NxH7w0dwcgKJIjQnrpIfmv7AJh4wAxFoaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZrLxLNSL6Gt0GWhA2RQfo2CFvYYxjFj3OZyoZXep4cezE3dfW66CcqawGPxU7Lw0Z22/4W8UvXZiVwOi+tPvxpBpsAJFlolKogBVsXfGfyjYeb6HqJp79rsLcaRlSYTLIMxJgC54AY+mwSaR7VHfYMo7MzUOiNPduCQiifmSO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D28560543; Tue, 30 Jun 2026 13:04:43 +0200 (CEST)
Date: Tue, 30 Jun 2026 13:04:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: nft_ct: support expectation
 creation for natted flows
Message-ID: <akOitclorHvJsREK@strlen.de>
References: <20260630060311.2504-1-fw@strlen.de>
 <akOVqk9WOTpIKCss@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akOVqk9WOTpIKCss@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +#if IS_ENABLED(CONFIG_NF_NAT)
> > +	nf_ct_expect_iterate_destroy(expect_iter_nat, NULL);
> > +	synchronize_rcu();
> > +#endif
> 
> Not sure sashiko is signalling a real issue here.

I could use the nf_nat_helper_register/unregister interface which would
support dump/restore via ctnetlink / conntrackd. 
Not sure its worth it.

This isn't using nat-follow-master directly to avoid a module dependency
on the nat core.

> static void __exit nf_nat_cleanup(void) 
> {
>         struct nf_nat_proto_clean clean = {}; 
>             
>         nf_ct_iterate_destroy(nf_nat_proto_clean, &clean);
> 
> all NATted master conntracks are destroyed here, including their
> expectations, which might have the expectations using
> nat_follow_master.

Yes, but users can remove nft_ct and leave nf nat core loaded,
so above function won't run.  The expect_iter_nat cb will zap
expectations that are still in the table that point to the
internal expectfn (i.e. into the module thats going away).

The alternative to the manual nf_ct_iterate_destroy() is to use
nf_ct_helper_expectfn_destroy() and a real struct nf_ct_helper_expectfn.

> And nf_nat_cleanup() can only be called if all there is no more nat
> chains in place, correct?

Yes, but I don't think thats related to the sashiko comment at
https://sashiko.dev/#/patchset/20260630060311.2504-1-fw%40strlen.de
