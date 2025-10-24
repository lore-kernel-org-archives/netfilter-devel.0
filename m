Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897C71D6AA
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 11:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761303764; cv=none; b=cojl3GsX9S9Lm/NakFDcVbOvFpWzNhyzYPtOuDlFzY9amY/0IUFVWxNWQJKRTyaEmpH1LuZXmnc8UYSJnUrXLhrh+Y8rv1ucuoGqzgDQA7bTQ8y+LhdVPdnB8A9EsZo0BqmYjXyONLS+VYxoRvWeqXFJ4xDUw5xnxKEliSLbeRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761303764; c=relaxed/simple;
	bh=Q3qFETzOwNsxQMU7nZRLlPhFu0gqPia4voXCLpQNhEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+nt/hCQPbowN4Bkeg6/9nfjUxQEILjc7ZwtJ51jqicHQ5SBDZnp06CZJGI048WGAyq5g66mccxfAKggfxHr8Kts1LwvymVpf2Od1C2SCE2WOvRMS7yJpLLR3+mdqdN9f9WkmA/+/e+DrDjGRsJv45J1fWJRRoA3+0w7jGz48i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3CB0A60308; Fri, 24 Oct 2025 13:02:39 +0200 (CEST)
Date: Fri, 24 Oct 2025 13:02:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix stale read of
 connection count
Message-ID: <aPtctiRlb9Pg9sNQ@strlen.de>
References: <20251023232037.3777-1-fmancera@suse.de>
 <6b0de8f3-d03a-4f12-b2f8-c87aeeef4847@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b0de8f3-d03a-4f12-b2f8-c87aeeef4847@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/24/25 1:20 AM, Fernando Fernandez Mancera wrote:
> > nft_connlimit_eval() reads priv->list->count to check if the connection
> > limit has been exceeded. This value can be cached by the CPU while it
> > can be decremented by a different CPU when a connection is closed. This
> > causes a data race as the value cached might be outdated.
> > 
> > When a new connection is established and evaluated by the connlimit
> > expression, priv->list->count is incremented by nf_conncount_add(),
> > triggering the CPU's cache coherency protocol and therefore refreshing
> > the cached value before updating it.
> > 
> > Solve this situation by reading the value using READ_ONCE().
> > 
> > Fixes: df4a90250976 ("netfilter: nf_conncount: merge lookup and add functions")
> > Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
> > Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > ---
> 
> While at this, I have found another problem with connlimit although with 
> this fix, it is partially mitigated. Since d265929930e2 ("netfilter: 
> nf_conncount: reduce unnecessary GC"), if __nf_conncount_add() is called 
> more than once during the same jiffy, the function won't check if the 
> connection is already tracked and will be added right away incrementing 
> the count. This can cause a situation where the count is greater than it 
> should and can cause nft_connlimit to match wrongly for a few jiffies.
> 
> I am open to suggestions on how to fix this.. as currently I don't have 
> a different one other than reverting the commit..

People are not supposed to use it in this way.

This is very expensive, there is a reason why iptables-extensions
examples all use iptables --syn.

This needs a documentation fix.

Or, we could revert df4a90250976 and then only _add for ctinfo NEW.
