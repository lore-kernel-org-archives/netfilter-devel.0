Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DC03EC82D;
	Mon,  5 Oct 2026 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236543; cv=none; b=eaiQow/tHIZAKjBNEccY7PLIbt4wJ/uHreh6R/WQVVxPOithbuPCDPGLeqZUqQQ8iQdVntPTMWkoGDN95+0X1CjytGVJnt+lQUhgmqTkO5M0oza/jUjF3juSejoL6ESpqlEqC2s9Xi9NSenkM6MOUZZjQqdjTEr41zNwjZODuHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236543; c=relaxed/simple;
	bh=5ufy/bfmVzzplXqdx7/75xm5HaujQZ4TcWt4llsdZPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZtFjX6Hnvk8BOX3PGTWYBJ9559CPgiOTYV44fVfcFryPpInzc4sVn7bFInLwglSxoxe2+ir+PRTKRhkCR77oisEP7VVpqHEv0PHEohgjdf7ouT/9gKg5WzMHKabgMwq++p+lmGtRLc5AfFH5QOCxDhWI5/H6f0kC+XlFOH/vdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BgCng0/4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BgCng0/4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791236539;
	bh=tAtcUUT2qjyAeZ31TLI3ERcF0M8NpLZuPpj95AkTDEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BgCng0/4d0s8qaTZYdigR7Tb9b8Td9/91DqaxH9v8UPASQIJ7RKxYncG3uaM5tYd4
	 1vjryNzNP9gC8GwbIVqVp+r8nYrE48dG7k3sOfmvZEMhz1xmRqLxZ42tzphgShyDDY
	 1eKnrYMzaxt72lz1uC6MaQX+AGudYVlnl0LZYH1saQPt79vnb4lxP+bdFM+eBiVBkD
	 cnAQQV7WC1snlrq1at34Kg0P/a/aS5ZlKiq5MWY6d0OBJ/BHTFSiUnkzp0/AZmGDIX
	 CaOiVkk4BwjlgBWm6c0RBxMACSU/fdjJmRcXcG+kI+SWUI8a7NSbEy9D4CsKVrhDGC
	 3naOjiClxOjWw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 13C4D60052;
	Mon,  5 Oct 2026 23:42:19 +0200 (CEST)
Date: Mon, 5 Oct 2026 23:42:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: reject expired interval
 ends
Message-ID: <asQZuEvEURF_Uqq-@chamomile>
References: <20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <asQUte0AcCGaTZcS@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asQUte0AcCGaTZcS@chamomile>

On Mon, Oct 05, 2026 at 11:20:57PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 05, 2026 at 08:04:05PM +0000, Jérémy Jean wrote:
> > Consider two ranges in a netfilter verdict map:
> > * keys 10-19 accept packets, and
> > * keys 30-39 jump to chain 'victim'.
> > Now, delete the end marker at 20. The lookup array now uses element 30
> > as the first range's end, so an INTERVAL_END query for key 15 returns
> > element 30, including its jump verdict and chain pointer. This can make
> > KASAN reports a UAF after the GC releases reference chain for 30 that
> > has expired:
> > 
> >   BUG: KASAN: slab-use-after-free in nft_verdict_dump+0xdd/0x110
> >   Read of size 8 at addr ff110000009dfb58 by task repro/50
> >   ...
> >   Call Trace:
> >   ...
> >    nft_verdict_dump+0xdd/0x110
> >    nft_data_dump+0x4d/0x80
> >    nf_tables_fill_setelem+0x30b/0x8a0
> >    ? __asan_memcpy+0x3c/0x60
> >    nf_tables_fill_setelem_info+0x1b0/0x200
> >    nft_get_set_elem+0x3fd/0x4b0
> >   ...
> >   Freed by task 24:
> >   ...
> >    kfree+0x1a5/0x280
> >    nf_tables_trans_destroy_work+0x2cb/0x520
> > 
> > Reject expired endpoints in nft_rbtree_get() before returning them.
> > 
> > Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> > ---
> >  net/netfilter/nft_set_rbtree.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> > index 9894832..1fd9cbe 100644
> > --- a/net/netfilter/nft_set_rbtree.c
> > +++ b/net/netfilter/nft_set_rbtree.c
> > @@ -187,6 +187,8 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
> >  	if (flags & NFT_SET_ELEM_INTERVAL_END) {
> >  		if (!interval->to)
> >  			return NULL;
> > +		if (nft_set_elem_expired(interval->to))
> > +			return ERR_PTR(-ENOENT);
> 
> End elements carry no timeout set extension.

And nf_tables_getsetelem() is called under RCU read side lock, and
elements are released after RCU grace period.

This patch is papering the problem.

> >  		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
> >  	} else {
> > -- 
> > 2.47.3
> > 
