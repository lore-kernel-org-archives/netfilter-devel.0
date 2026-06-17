Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2F23CB2D2
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781683353; cv=none; b=MEjGCPEB4+S2lf3IaZMc3N5cuwxCDa74kNC5CNoRIjkEQTARHYd/QfhJDY6eWMqdmnWM1fvsziicJJ63p6l+lMZ3lrTSylvUbvtoMJFf44mmMxDRoTFYR4oocPvzeoXYF4h3hsS2rQIZ5mCxKLVIbMdRyfI4kSkPRU94q2O3eHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781683353; c=relaxed/simple;
	bh=5hibnmy70TK0tZft022sAHe6duAUfAXHBjvYKucqqxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqDNJNCoTRNBRICJt+CR/c4Ok3B916cs9CmL3bc+1ZWDP42h+khZovCZ90O2f0zu653XNzJBBDQRHqhLFAupO6AWeYVfE4VD0afS+TB7bZrAs+f5HBj8Q05y+ebs9NiiwJgC5pT3zxpF+LXhU433JTSVJfNaZ3nhLcJ4tD6a5xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 95CDD602C8; Wed, 17 Jun 2026 10:02:26 +0200 (CEST)
Date: Wed, 17 Jun 2026 10:02:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Seesee <cjc000013@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: don't leak bad clone into
 future transaction
Message-ID: <ajJUklUUmvafRVi9@strlen.de>
References: <20260616191938.2875-1-fw@strlen.de>
 <20260617075123.7a62e22c@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617075123.7a62e22c@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> On Tue, 16 Jun 2026 21:19:34 +0200
> Florian Westphal <fw@strlen.de> wrote:
> 
> > On memory allocation failure the cloned nft_pipapo_match can enter a bad
> > state:
> >  - some fields can have their lookup tables resized while others did
> >    not
> >  - bits might have been toggled
> >  - scratch map can be undersized which also means m->bsize_max can be
> >    lower than what is required
> 
> If I understand it correctly, this is about pipapo_realloc_scratch()
> failing to allocate memory for per-CPU scratch maps but
> pipapo_maybe_clone() succeeding, right?

Yes.

> I don't see anything wrong with this approach, but I guess there might
> be a more obvious alternative, even though I didn't really think this
> through: undo what we did in nft_pipapo_insert() up to that point
> (perhaps calling nft_pipapo_delete() with a particular argument).

Yes, that is the laternative, return the cloned copy to a state where it
is identical to the state it had at function start.

> I can try to get to this in the next few days (I would have some ideas
> about testing, see below), but I suppose we want a fix quickly if that's
> really the case so I'm actually fine with this, with one nit, also
> reported below.

I don't mind, this can wait if you prefer to undo the state.
