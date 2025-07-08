Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F733215075
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 19:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752001356; cv=none; b=um8HclaVzvSCeUe2hP1fHma9mBXO0x0z9qyEPsdIg9ilIW8vuD59QTUgQ2dY2M/+DO0+KA41DaYh+SsNPXbbAvVxlUEtBEsqk9mfjr/MzzsYxZGcepqPaFx7zL1Y3ohx54dnv2M8EskiSpZThWK1VqkyBAQHHRQOOnNMuFI1oWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752001356; c=relaxed/simple;
	bh=MHIYzVfili3KcK3gVbySpDqxT5MP+M5VRfiZJAPR9B4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPRl4SHQeZVaKwdYFaBs1DdonphXV6bmeSJizJRLJ+M0zTFQlyfyocFu4r6HB2mgfzKJTDqmtVR6u0VScQOt4JsoatkUMyBFChzMPWEv1JYX46muwICc6+Xh1oTMgBETofcnuzv4ICmFKjkrCowETEY/aKFDVuReJ04KJ9mf/Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 618D8604A5; Tue,  8 Jul 2025 21:02:29 +0200 (CEST)
Date: Tue, 8 Jul 2025 21:02:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 4/5] netfilter: nft_set_pipapo: merge
 pipapo_get/lookup
Message-ID: <aG1rRX4PPd6XDlzy@strlen.de>
References: <20250701185245.31370-1-fw@strlen.de>
 <20250701185245.31370-5-fw@strlen.de>
 <20250708080917.41f4b693@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708080917.41f4b693@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> > -	if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
> > +	/* XXX: fix this, prealloc and remove this check */
> > +	if (unlikely(!raw_cpu_ptr(m->scratch)))
> 
> The check should be cheap, but sure, why not. I'm just asking if you
> accidentally left the XXX: here in this version or if you meant it as a
> TODO: for the future.

I can remove the XXX.  I already have a follow patch that axes this
conditional (m->scratch will always be allocated).

> >  /**
> > @@ -605,6 +536,11 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
> >   * @set:	nftables API set representation
> >   * @elem:	nftables API element representation containing key data
> >   * @flags:	Unused
> > + *
> > + * This function is called from the control plane path under
> > + * RCU read lock.
> > + *
> > + * Return: set element private pointer; ERR_PTR if no match.
> 
> Conceptually, we rather return -ENOENT, I'd mention that instead.

Hmm, maybe?

 * Return: set element private pointer or ERR_PTR(-ENOENT).

(Compiler should warn in case someone compares -ENOENT to return value
without the ERR macros, so maybe i am overthinking this...).

Thanks for reviewing!
