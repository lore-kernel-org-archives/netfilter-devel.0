Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405D9456E19
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 11:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786014518; cv=none; b=FxUPcx0hkMGBBV7BJKCDHbTSEx1ABS8yzgLNsSOs3Fnt8Qu65WS+48k1qaKgSjuT5G9V2kB0WhVDw7JdmJm/FUuqZWy+dsYXkoT1TGFMmNZJPyOE7AZXNIMjY4YDMjE+3QV6zJZD6pcyq9tsvYrMp5t4Oy7hefxAsGVKW20rioE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786014518; c=relaxed/simple;
	bh=of24dEXo6LxPsYLpZiZ15RXbkQ2h76vnK9FTynRFcGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmUzlRVo73I8Mg0Ecy6PQVSrS/G73kdEX9KxbtT9926EEjXFf7i3AA76wM35/HK2s42Us80E1TciRHw7UlCd7qg0gsZc0gs5dhmxx3nEwafp70ZQVGoqVgt3Y/JAng9vflHddaqq5WuJ+8jmtm21WdV0nCy9JfgnvQoe0UshU7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EB38460833; Thu, 06 Aug 2026 13:08:30 +0200 (CEST)
Date: Thu, 6 Aug 2026 13:08:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit
 when building new ruleset
Message-ID: <anRrLtZvlPXtqJAA@strlen.de>
References: <20260805171115.250749-1-pablo@netfilter.org>
 <20260805171115.250749-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805171115.250749-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The rbtree set only builds the b-search array after the new ruleset has
> been exposed through set ops .commit.
> 
> This is currently needed by pipapo because it purges the elements from
> the clone after the transactions are handled, therefore, pipapo still
> needs the delayed set ops .commit call after the transaction handling.
> 
> Allow the rbtree to call .commit before the transaction handling which
> purges the stale elements from the frontend rbtree datastructure.
> 
> Update rbtree .commit to skip deactivated and expired elements when
> building the new b-search array.

I'm not following, sorry.  What's the difference between pipapo and rbtree?

static void nft_pipapo_commit(struct nft_set *set)
{
[..]
        if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
                pipapo_gc_scan(set, priv->clone);

        old = rcu_replace_pointer(priv->match, priv->clone,
                                  nft_pipapo_transaction_mutex_held(set));

[..] after this, new incarnation is live.

static void nft_rbtree_commit(struct nft_set *set)
{
[..]
        if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
                nft_rbtree_gc_scan(set);

[ ... build the new blob ... ]

err_out:
        priv->array_next->num_intervals = num_intervals;
        old = rcu_replace_pointer(priv->array, priv->array_next,
                                  lockdep_is_held(&nft_pernet(read_pnet(&set->net))->commit_mutex));


[..] after this, new incarnation is live.

What is the problem?  These two functions do the same thing, no?
Why must the blob be rebuilt before stale node purge in rbtree case?
