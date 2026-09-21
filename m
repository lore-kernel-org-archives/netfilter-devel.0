Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3602472F8C
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993775; cv=none; b=MDaSiuQ6ZCTNwIdi2k512IjCBfIqd+bHvE+rNxWNMJJWe2zdPztzC1CKLN/txgVGZIPw7l0GQT/B7kZFYiGtCi/9tIc1dfBYyhaSzZRXz0gXMqBGorKG6kncoz3E8o90BQCkOf71x5mE2oiGcWDVQpEGPYpc8HpjY1K0UP6RCMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993775; c=relaxed/simple;
	bh=rGymVVekDKx+EfkGFAyTKJyvfTycKyQ4OTOVqR2kP4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnapHRkmlTqR6rxNGDpfNB9tNEhTP8SLn4xxqioD+RygQJC9Ni3SRXRaVA1Ry+9o4C4lRb+nxo9Z45fUU6N2rLgKXeXwbIQEWxjdScXod8C8wC8Kbrv9IEdvL/ix1VTsl69NbGjgpSBIyoc1Ck7gCux4XqiAobBP/wu4amkNGxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aUQgzzbs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aUQgzzbs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789993770;
	bh=a4OSSFnA1F7YavqFduhVcxtQ41QW7astHH7FNNIbgVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUQgzzbstMGGJPX+QsDoUE2LesCKnP3Ar9tGIyAQNsqKiftGY6xtZq9LS3DUZG0cU
	 ns8ZIo4DW0nMlSs7KVtcLHHMQdopkKMpGQlj4uZgLLdMziwnJqnCSoM1vDRhacfb8w
	 D1kH6oF3octnE1/d6gjuppRi5f6iNHCwCp8aLKqub/LGe+32cWYhteiXSQ1MWq8eJ2
	 shAJO1vuF6cMiE5OZbphKl7t6UpMcWIqrWqgMEmg5T71xXWuHDTkQxWZLiLLTpUlSq
	 fdPYtOyZ4vtEB9cdQkkmDwEVzl3AIwX8ac7O0YrsbH/CpkoDTcd+S8kuhez4sBADic
	 2IpLam/qsREUA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CE33E60076;
	Mon, 21 Sep 2026 14:29:29 +0200 (CEST)
Date: Mon, 21 Sep 2026 14:29:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: bestswngs@gmail.com
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	phil@nwl.cc, xmei5@asu.edu, co+ee5e50ef2670e5f4@bugs.sh
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: skip transaction elements
 during GC
Message-ID: <arEjJkGYX4Q-EbhK@chamomile>
References: <20260921020821.2587086-2-bestswngs@gmail.com>
 <arEeRLnELoQYlEur@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <arEeRLnELoQYlEur@chamomile>

On Mon, Sep 21, 2026 at 02:08:40PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 21, 2026 at 10:08:22AM +0800, bestswngs@gmail.com wrote:
> > From: Weiming Shi <bestswngs@gmail.com>
> > 
> > Since nft_set_commit_update() runs set commit callbacks before processing
> > NEWSETELEM transactions, nft_rbtree_gc_scan() can observe elements added by
> > the transaction being committed.
> > 
> > The scan records an interval end in rbe_end without checking the element's
> > transaction state. A later, unrelated expired start then moves both
> > elements to the expired list.
> >
> > The synchronous GC queue can free the new end
> > element before the transaction subsequently activates it, causing a
> > use-after-free.
> > 
> > Only consider elements that are fully active in both generations. This
> > keeps transaction-state elements out of the GC scan and preserves interval
> > pairing across skipped elements.
> >
> > KASAN reports:
> > 
> >   BUG: KASAN: slab-use-after-free in nft_setelem_activate
> >   nft_setelem_activate net/netfilter/nf_tables_api.c:7047
> >   nf_tables_commit net/netfilter/nf_tables_api.c:11137
> > 
> >   Allocated by task 130:
> >   nft_set_elem_init net/netfilter/nf_tables_api.c:6794
> >   nft_add_set_elem net/netfilter/nf_tables_api.c:7523
> > 
> >   Freed by task 130:
> >   nft_trans_gc_trans_free net/netfilter/nf_tables_api.c:10506
> >   rcu_core kernel/rcu/tree.c:2919
> >
> > Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
> > Reported-by: <co+ee5e50ef2670e5f4@bugs.sh>
> > Assisted-by: LLM
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  net/netfilter/nft_set_rbtree.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> > index 9894832281c4b..12431b55752fb 100644
> > --- a/net/netfilter/nft_set_rbtree.c
> > +++ b/net/netfilter/nft_set_rbtree.c
> > @@ -900,6 +900,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
> >  		next = rb_next(node);
> >  
> >  		rbe = rb_entry(node, struct nft_rbtree_elem, node);
> > +		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
> > +			continue;
> >  
> >  		/* elements are reversed in the rbtree for historical reasons,
> >  		 * from highest to lowest value, that is why end element is
> 
> Maybe simply set rbe_end to NULL when rbe is found and is not
> expired?
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 9894832281c4..a9f2ae3c91cf 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -909,8 +909,10 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
>                         rbe_end = rbe;
>                         continue;
>                 }
> -               if (!__nft_set_elem_expired(&rbe->ext, tstamp))
> +               if (!__nft_set_elem_expired(&rbe->ext, tstamp)) {
> +                       rbe_end = NULL;
>                         continue;
> +               }
>  
>                 /* end element needs to be removed first, it has
>                  * no timeout extension.

My proposed chunk is not correct, it still allows for the problem to
happen.

Maybe restrict this to:

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9894832281c4..bc331c6ae339 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -905,7 +905,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
                 * from highest to lowest value, that is why end element is
                 * always visited before the start element.
                 */
-               if (nft_rbtree_interval_end(rbe)) {
+               if (nft_rbtree_interval_end(rbe) &&
+                   nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY)) {
                        rbe_end = rbe;
                        continue;
                }

for symmetry with:

commit 60c0c230c6f046da536d3df8b39a20b9a9fd6af0
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Wed Feb 7 18:49:51 2024 +0100
 
    netfilter: nft_set_rbtree: skip end interval element from gc


But I suspect this is leaving stale (expired) overlapping intervals in
the set when building it from nft_rbtree_commit(), so the fix still
looks incomplete me.

I want to have a close look and make a test case for this, this is not
well covered by tests.
