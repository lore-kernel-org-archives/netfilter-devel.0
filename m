Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E23E3B8406
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027737; cv=none; b=Xq7Pds/R0wSwYQdn1BT/69YAkLePU+xpx4GReyYkwJK9rzsQR6qQabzCrPcmk2l1Lq+0czNkxUxvvszeczEJRCI9XqSReeVt3Sz37ceUkT25U/Q3rVRmfpJyEofJ8bogr2TJzG1wxkDFfkVfVvBoLnpMJBfNa2s+COS2YVQdExM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027737; c=relaxed/simple;
	bh=HR1Sm5Iz9++AKSdxg1E2Y0djmVgMydgoyHsjMIP+JYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxkAENDbfAmIHKqezOFuiKeVhZx9bOuWFIh+m/jM/pH9d0Q0O3x07RZD5L6pUPrg+sG4Y4xvEMsCTgSf3GgDGJF9p6VUJiNzjPewXnt/wHS/SZxXtTELfG/gr5p8fmVF6v44s2R4GxnYwZGQ/14vve5Aut9PKXqY0Q/mqOug5LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YIB6jiv5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YIB6jiv5"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 336D0601A7;
	Thu,  6 Aug 2026 16:48:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786027732;
	bh=Lzxl7uDa5FFRNXsx8+2XiQ9rXVIPZAxPySwbDoxI6pc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YIB6jiv5JI3tULP6Bhbl247S4zuoSAfCpgdmwlVFyBJv/uK8xOn1HWBiQ8Gr0xFCj
	 L5gJa+ZBeAMI4hDrqyXIwoF94wsQ0fm+mfIB9h6U7kZRlze4ZxDhdjZrfgDW6jDCND
	 XolFUhPQ0V4riBmcnot2M3pUzUe7d4IX2gsx2vyXAeV8wryqNQtRI/IFllDL4TpOfK
	 bXZ2c7eTYtZ5S0alfOd0FzLnDE9YX9Vi98hc8VLtRrH615HDmrwIjk3QNumsz3fw8Y
	 2fCGRtZcUY5yxRyrIDygO+GK063W2ITLEkXdIcN3tZgyJGAm4xMLJQ9Zhk059y3HrD
	 PIfTkH2dDKfvA==
Date: Thu, 6 Aug 2026 16:48:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit
 when building new ruleset
Message-ID: <anSe0eK9dl1d2J7-@chamomile>
References: <20260805171115.250749-1-pablo@netfilter.org>
 <20260805171115.250749-2-pablo@netfilter.org>
 <anRrLtZvlPXtqJAA@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <anRrLtZvlPXtqJAA@strlen.de>

On Thu, Aug 06, 2026 at 01:08:30PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The rbtree set only builds the b-search array after the new ruleset has
> > been exposed through set ops .commit.
> > 
> > This is currently needed by pipapo because it purges the elements from
> > the clone after the transactions are handled, therefore, pipapo still
> > needs the delayed set ops .commit call after the transaction handling.
> > 
> > Allow the rbtree to call .commit before the transaction handling which
> > purges the stale elements from the frontend rbtree datastructure.
> > 
> > Update rbtree .commit to skip deactivated and expired elements when
> > building the new b-search array.
> 
> I'm not following, sorry.  What's the difference between pipapo and rbtree?

pipapo needs to call nft_setelem_remove() to purge the deactivated
elements from priv->clone, then the new version of the pipapo lookup
table datastructure can be published.

The rbtree does not need to wait to call nft_setelem_remove() since it
updates the rbtree frontend datastructure that is only exposed to
control plane.

> static void nft_pipapo_commit(struct nft_set *set)
> {
> [..]
>         if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
>                 pipapo_gc_scan(set, priv->clone);
> 
>         old = rcu_replace_pointer(priv->match, priv->clone,
>                                   nft_pipapo_transaction_mutex_held(set));
> 
> [..] after this, new incarnation is live.
> 
> static void nft_rbtree_commit(struct nft_set *set)
> {
> [..]
>         if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
>                 nft_rbtree_gc_scan(set);
> 
> [ ... build the new blob ... ]
> 
> err_out:
>         priv->array_next->num_intervals = num_intervals;
>         old = rcu_replace_pointer(priv->array, priv->array_next,
>                                   lockdep_is_held(&nft_pernet(read_pnet(&set->net))->commit_mutex));
> 
> 
> [..] after this, new incarnation is live.
> 
> What is the problem? These two functions do the same thing, no?

Apparently yes, but...

> Why must the blob be rebuilt before stale node purge in rbtree case?

... there is a gap between the ruleset blob is built and published and
the set .commit interface is called to publish the new version of the
rbtree/pipapo datastructure.

See:
https://lore.kernel.org/netfilter-devel/589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com/
