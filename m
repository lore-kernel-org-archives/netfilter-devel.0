Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA25303A04;
	Sat, 19 Sep 2026 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829847; cv=none; b=ubyvF9RvU+ho3Xb0/eO56akWj8icL6m8HRNPcfpHCAD+zM3/e2wZIgyZ8GiB3MCnUajOJCxxhBs9zekaQxXyp8Z3qsvHE+cLykxZti4hKF9RlOk8Gv61TA0GFYS/OrWzjcM5l07Mc7QlrPWwINjLn+iE+4hexkmsv2s5nfWuqeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829847; c=relaxed/simple;
	bh=zGw4/GQyB0BvC/r8wxMX56dY/5wBm7rSVFZ78cps40I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svyJDU/LFbq9KAHrPpqQJCQHTSpOnRABNoXThnD1ZZH7YIQrV4fQ6ctEh2fwRCFL8c9+DUSoN10xCNBHwiDvcpuizvJwBRRXcAcl0HoPdi5ZnMBM8p04XtWA9tnRPAQQJM9lmHMq7AYw3sNeYeJZxT5jZcx8mm+aofGdWpZTJNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=isHYP5JK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="isHYP5JK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789829842;
	bh=bVw1liNHg8dgZkUyHaFRFX/LoRQkrWnHOmvA5rzLjcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=isHYP5JKlmfWd3fwsLj3uSIHXddmoL+ULL2xHHuIoGgWWorZwk/wNrXROG+cso3y0
	 RxIIzZ3rPDyn+/H9CT9WG6LN0L0agroIpn4K1Ag2/IXBVn8owg7rO5NhK1UNj9GcMJ
	 qM9E7+4+Qr8g42MPo7MUVKYiS214kh6HsLkzyV3rLmipCjnm6weF6y8HuFiPA7LJWa
	 DBG6yhmTnoM3NhvGQ6qh25ZpBT9Vl/YlYG/1e4/2BxzrergbhhNjkrTJXmPgW7092C
	 bgNIFTHHzx9X+472kfWS8jbvk+5fR1bHhoMzVR2r1TmmBi/huPbJI2YXDVq1kgU3l8
	 hkBtef0dE315Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DEF8C60074;
	Sat, 19 Sep 2026 16:57:21 +0200 (CEST)
Date: Sat, 19 Sep 2026 16:57:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: kuba@kernel.org
Cc: netdev-bot+sashiko@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 8/8] netfilter: nf_tables: skip expired catchall
 elements on insert and delete
Message-ID: <aq6iznIv5wHnIhDg@chamomile>
References: <20260918112844.194503-9-pablo@netfilter.org>
 <178982489117.22033.1574367831667981015@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178982489117.22033.1574367831667981015@kernel.org>

Hi Jakub,

This comments below look like brainstorming, nothing really that
should prevent this patch from being merged.

On Sat, Sep 19, 2026 at 01:34:51PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> - [Medium] The relaxed duplicate predicate in
>   nft_setelem_catchall_insert() (nf_tables_api.c:7003-7016) removes the…
> 
> --
> 
> netfilter: nf_tables: skip expired catchall elements on insert and delete
> 
> This aligns nft_setelem_catchall_insert() and
> nft_setelem_catchall_deactivate() with the lookup and dump predicates, so
> an expired catchall element no longer counts as a duplicate and no longer
> gets picked as the delete candidate. Both walks now also test
> __nft_set_elem_expired() with the per-netns transaction timestamp and
> nft_set_elem_is_dead().
> 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index c0b754a2d45b..b59628e6240c 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -6995,11 +6995,14 @@ static int nft_setelem_catchall_insert(const struct net *net,
> >  {
> >  	struct nft_set_elem_catchall *catchall;
> >  	u8 genmask = nft_genmask_next(net);
> > +	u64 tstamp = nft_net_tstamp(net);
> >  	struct nft_set_ext *ext;
> >  
> >  	list_for_each_entry(catchall, &set->catchall_list, list) {
> >  		ext = nft_set_elem_ext(set, catchall->elem);
> > -		if (nft_set_elem_active(ext, genmask)) {
> > +		if (nft_set_elem_active(ext, genmask) &&
> > +		    !__nft_set_elem_expired(ext, tstamp) &&
> > +		    !nft_set_elem_is_dead(ext)) {
> >  			*priv = catchall->elem;
> >  			return -EEXIST;
> >  		}
> >  	}
> 
> [Severity: Medium]
> Can repeated expire-then-readd cycles grow set->catchall_list without
> bound here?
> 
> With the relaxed predicate, the expired entry is skipped but stays linked
> and genmask-active until GC runs, so the tail of
> nft_setelem_catchall_insert() appends a second entry alongside it:
> 
> 	catchall = kmalloc_obj(*catchall, GFP_KERNEL_ACCOUNT);
> 	if (!catchall)
> 		return -ENOMEM;
> 
> 	catchall->elem = elem->priv;
> 	list_add_tail_rcu(&catchall->list, &set->catchall_list);
> 
> Unlike ordinary elements, catchall elements are excluded from the size
> accounting in nft_add_set_elem():

Set size is specified by user... User can create a set without a set
size... This comment makes no sense.

> 	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
> 		unsigned int max = nft_set_maxsize(set), nelems;
> 
> 		nelems = atomic_inc_return(&set->nelems);
> 		if (nelems > max)
> 			set_full = true;
> 	}
> 
> so the "return set_full ? -ENFILE : 0;" limiter that caps accumulation of
> ordinary elements does not apply to this path. Is there anything else that
> bounds the number of stale catchall entries a set can hold?

We could sets a cap for maximum number of items in a transaction, but
noone requested this so far. There is also memcg which should provide
a cap.

> Reclamation looks like it depends entirely on GC, and the interval is
> user-tunable with no upper bound (NFTA_SET_GC_INTERVAL is accepted as a u32
> in milliseconds and nft_set_gc_interval() just converts it):
> 
> include/net/netfilter/nf_tables.h:nft_set_gc_interval() {
> 	u32 gc_int = READ_ONCE(set->gc_int);
> 
> 	return gc_int ? msecs_to_jiffies(gc_int) : HZ;
> }
> 
> For nft_set_rhash and nft_set_rbtree the catchall reclaim runs only from
> the delayed gc work requeued with that value, so with a large gc-interval
> the window for accumulation is correspondingly large.
>
> There is also a packet-path effect: nft_set_catchall_lookup() walks the
> whole list, and new elements are appended at the tail, so every accumulated
> stale entry is dereferenced before the live one is found:
> 
> 	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
> 		ext = nft_set_elem_ext(set, catchall->elem);
> 		if (nft_set_elem_active(ext, genmask) &&
> 		    !nft_set_elem_expired(ext) &&
> 		    !nft_set_elem_is_dead(ext))
> 			return ext;
> 	}
> 
> Would it be preferable to reuse or force-reclaim the stale catchall element
> on insert, rather than only ignoring it?

Maybe, but that is unrelated to this patch.

> > @@ -7092,11 +7095,14 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
> >  					   struct nft_set_elem *elem)
> >  {
> >  	struct nft_set_elem_catchall *catchall;
> > +	u64 tstamp = nft_net_tstamp(net);
> >  	struct nft_set_ext *ext;
> >  
> >  	list_for_each_entry(catchall, &set->catchall_list, list) {
> >  		ext = nft_set_elem_ext(set, catchall->elem);
> > -		if (!nft_is_active_next(net, ext))
> > +		if (!nft_is_active_next(net, ext) ||
> > +		    __nft_set_elem_expired(ext, tstamp) ||
> > +		    nft_set_elem_is_dead(ext))
> >  			continue;
> >  
> >  		kfree(elem->priv);
> 
> [Severity: Medium]
> Related to the above: with stale entries now skipped and -ENOENT returned,
> per-element DELSETELEM can no longer retire the accumulated entries, so a
> full set flush or set deletion appears to be the only way to drop them
> before GC fires. Is that the intended behaviour?
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260918112844.194503-2-pablo%40netfilter.org
