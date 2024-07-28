Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66C9A35;
	Sun, 28 Jul 2024 02:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722133853; cv=none; b=RiKVmLTCJeq3BhV+UZ29Vzz2IxVUfptBDubKxFz4qTkKU4Ekck0n2apfdzOE0n+w1Nj3Cz/PNWUHbKLz76HXvCDlkmPQNqbDtNGLkABQyBXCQzQi4OCRjg3RS1CQZCqNHSphDX9kCYfJ9yrxYI+JYpZKrqsWqQdO4hg6KJKHp/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722133853; c=relaxed/simple;
	bh=Vw64+sDaBjrL18hyEYdJh4B8xCQlPvZgkjM+2GzjsJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nj9OeadTasN7+PxP74ApuJda/YO4e7q7dKSAX0czXSkm66v6TP6VdIHDTvV/Yn4PKip605FAn8yzhQv6TiLUvbZMVK8CWjCVk6hVOqTGiofDfdy5i+E9PeRjWAv227iAiWsLeVJP+OkSmnevDpiSn0W27acXHNK/Cax4BSSBasI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sXtgG-0000TG-D4; Sun, 28 Jul 2024 04:30:40 +0200
Date: Sun, 28 Jul 2024 04:30:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, gnault@redhat.com,
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Subject: Re: [RFC PATCH net-next 2/3] netfilter: nft_fib: Mask upper DSCP
 bits before FIB lookup
Message-ID: <20240728023040.GA996@breakpoint.cc>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-3-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725131729.1729103-3-idosch@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Ido Schimmel <idosch@nvidia.com> wrote:
>  void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
>  			const struct nft_pktinfo *pkt)
>  {
> @@ -110,7 +108,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	if (priv->flags & NFTA_FIB_F_MARK)
>  		fl4.flowi4_mark = pkt->skb->mark;
>  
> -	fl4.flowi4_tos = iph->tos & DSCP_BITS;
> +	fl4.flowi4_tos = iph->tos & IPTOS_RT_MASK;

I was confused because cover letter talks about allowing both tos or dscp depending on
new nlattr for ipv4, but then this patch makes that impossible because dscp bits get masked.

patch 3 says:
----
A prerequisite for allowing FIB rules to match on DSCP is to adjust all
the call sites to initialize the high order DSCP bits and remove their
masking along the path to the core where the field is matched on.
----

But nft_fib_ipv4.c already does that.

So I would suggest to just drop this patch and then get rid of '&
DSCP_BITS' once everything is in place.

But feel free to handle this as you prefer.
