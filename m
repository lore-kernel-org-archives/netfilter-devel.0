Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421E47EF03
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 13:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712667849; cv=none; b=H2NZo6TLQ+iWh2447ky5L2ajhfGa6N9nSJcS+l0iRP4d1HqdLzXcmqJqPNJfRvsUH90Fu8wNbbMJcERyyid9l6zXsqXO7x5zuZivtfWs9aMnjPIgJqS1I+M73mKixVVCg/PMioEtU9qcBbaLLVFaEQURxM9DVKMJVIlC6FDyMgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712667849; c=relaxed/simple;
	bh=ewI9k085dZU4IVU9UJTZVkjKFqJmOQkB9GTd6/UeC7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6LmYWfxZtyQbfkxHGTjgwJgFmjfVro4La3LMiouBasH7q9i8OAglQwb6vSzCTwwza5xwm2IcpboEhQnREVN8ZBEc6KBmYFSgfYOnsbDtkrwFUWfcSNGs3gR36TtH849Qb1Scmu/fdC4MuY8JXjkiepCBmKJ8SXnSlPY5jUtwrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1ruB8s-0005gg-3o; Tue, 09 Apr 2024 15:04:02 +0200
Date: Tue, 9 Apr 2024 15:04:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/9] netfilter: nft_set_pipapo: prepare destroy
 function for on-demand clone
Message-ID: <20240409130402.GA20876@breakpoint.cc>
References: <20240403084113.18823-1-fw@strlen.de>
 <20240403084113.18823-4-fw@strlen.de>
 <20240408174503.0792a92e@elisabeth>
 <20240409110704.GA15445@breakpoint.cc>
 <20240409145440.5b72df13@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409145440.5b72df13@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> > I do not follow.  nft_pipapo_destroy() is not invoked asynchronously via
> > call_rcu, its invoked from either abort path or the gc work queue at at
> > time where there must be no references to nft_set anymore.
> 
> Hmm, sorry, I was all focused on nft_set_pipapo_match_destroy()
> accessing nft_set, but that has nothing to do with
> pipapo_reclaim_match(). However:
> 
> > What do we wait for, i.e., which outstanding rcu callback could
> > reference a data structure that nft_pipapo_destroy() will free?
> 
> ...we still have pipapo_free_match(), called by pipapo_reclaim_match(),
> referencing the per-CPU scratch areas, and nft_pipapo_destroy() freeing
> them (using pipapo_free_match() since this patch).

But those scratchmaps are anchored in struct nft_pipapo_match.

So, if we have a call_rcu() for struct nft_pipapo_match $m, and then
get into nft_pipapo_destroy() where priv->match == $m or
priv->clone == $m we are already in trouble ($m is free'd twice).

If not, then I don't see why ordering would matter.

Can you sketch a race where pipapo_reclaim_match, running from a
(severely delayed) call_rcu, will access something that has been
released already?

I can't spot anything.
