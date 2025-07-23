Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686D825A34F
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753273250; cv=none; b=qX3+Ul1SLWut45jEaqUgLGnYIGhqv/uUzmXpvjvlyCAZuCB3/lOtVo24VHkib7iAwJ+9b9qeqpdgvo/1UhSF70l1mFt+pdrF+iDF8Q9nPecb5H/0WBtT8MTS9UtosW2ipCoZ08Iqm1scOgXIADCkZHF5oa050rIZjV6ZU+CqIow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753273250; c=relaxed/simple;
	bh=GLyZvqCMD3m4w4ScDKsstgDO8dgG2rIUXKu4icuebkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phG7w2lNnuE6wEmCme1b7qJfsNu9AzK/34aHmYHvVBIcy6DOESuyNg8fkCvl8IUlCqqoc99nsZ4QWl8WqdBJjHc7RNbsM/6EYonMaSd1wJ11MZHbwYAH04Wsa62tJKEFqfONI2wqzX8nymZuSBb3QZbPFTuTF5WkD0wvi6zhf4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CC0C06048A; Wed, 23 Jul 2025 14:20:45 +0200 (CEST)
Date: Wed, 23 Jul 2025 14:20:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/5] netfilter: nft_set updates
Message-ID: <aIDTnU0QY0QdWzio@strlen.de>
References: <20250709170521.11778-1-fw@strlen.de>
 <aIA3Y3OjzhZ_hQVD@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIA3Y3OjzhZ_hQVD@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The fourth patch is the main change, it removes the control-plane
> > only C implementation of the pipapo lookup algorithm.
> > 
> > The last patch allows the scratch maps to be backed by vmalloc.
> 
> This clashes with:
> 
>   netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=463248
>
> It seems you and Sebastian have been working on the same area at the
> same time.
> 
> Do you have a preference on how to proceed with this clash?

If the clash is only in last patch, then how about this:
You apply the first few patches plus Sebastians work, push this out
(main or testing branch is fine too) and I will rebase + resend?

Or, we can defer to 6.18, your call.
