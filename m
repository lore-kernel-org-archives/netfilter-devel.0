Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94760811E9
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 11:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712660835; cv=none; b=PdGwuIaC9ZPQg6Hen6V6QKaYVBd9gutRUvwNXjXiMJmNytJB4hd5xaLjIojacM2GScllYqHh43nuuPPxCKzKfxHH/IbvSqH7fLzmxUO+WV+ckJvsF109yrD7ZdjN5aya7fwrWPs9J+b5CU/K15gVgRWAR6sbp6dVyaBY0IpSylU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712660835; c=relaxed/simple;
	bh=6jvlmJmVmiuMrxCQ434eBFqquEtJc++higOKOM0uEnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8azG+zF1umgpurArG2uytExviRplZDtSlQHI4T2saZaVwK/VT4fnAoBwxqAYlbxo1mvxfXqZA1OMWCy05ITJ3GKVnQKz5My4ErF+aY7ukKQSFj/rQBJcjG8Roe9I82Y1Wsx9SO3FERqsINCkQ0dZifhLXdhgxQbFXIDLQyS91w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1ru9Jg-0004wO-QK; Tue, 09 Apr 2024 13:07:04 +0200
Date: Tue, 9 Apr 2024 13:07:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/9] netfilter: nft_set_pipapo: prepare destroy
 function for on-demand clone
Message-ID: <20240409110704.GA15445@breakpoint.cc>
References: <20240403084113.18823-1-fw@strlen.de>
 <20240403084113.18823-4-fw@strlen.de>
 <20240408174503.0792a92e@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408174503.0792a92e@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> > The rcu_barrier() is removed, its not needed: old call_rcu instances
> > for pipapo_reclaim_match do not access struct nft_set.
> 
> True, pipapo_reclaim_match() won't, but nft_set_pipapo_match_destroy()
> will, right? That is:
> 
> > -	if (m) {
> > -		rcu_barrier();
> 
> ...before b0e256f3dd2b ("netfilter: nft_set_pipapo: release elements in
> clone only from destroy path"), this rcu_barrier() was needed because we'd
> call nft_set_pipapo_match_destroy() on 'm'.
> 
> That call is now gone, and we could have dropped it at that point, but:

I do not follow.  nft_pipapo_destroy() is not invoked asynchronously via
call_rcu, its invoked from either abort path or the gc work queue at at
time where there must be no references to nft_set anymore.

What do we wait for, i.e., which outstanding rcu callback could
reference a data structure that nft_pipapo_destroy() will free?

> > +	} else {
> > +		nft_set_pipapo_match_destroy(ctx, set, m);
> 
> now it's back, so we should actually move rcu_barrier() before this
> call? I think it's needed because nft_set_pipapo_match_destroy() does
> access nft_set data.

See above, what do we need to wait for?
