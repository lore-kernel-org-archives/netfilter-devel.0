Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19A509F0D;
	Mon, 28 Sep 2026 23:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639706; cv=none; b=nCic1/+iZbEtuI67SSUrA8lnTbysUUezEBKLnY0AZ5XO+e4NdESu1z6AmGru8T/kBV1C/2Gqs2oLtSOiewJu4ZRHTs1cilEQhnhtoTgqygFpmBFVIq/M2ys/9rtxo7ZOIIiXLkVV0Q2uILUhn7V7TksZIfbvIhyqKEZ5/29EoEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639706; c=relaxed/simple;
	bh=JOCeyUeBaUNSzsxLFNFPvygt9s3owBnVY8LM8GrHiu4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sLyfpVdLdM9sKnY2lSN9tf3XRrFdvin4B5KMM2j2WqpafB3MOdvDC5SnurSWVfU79Me7R9huCRYeNHKEYY9xD82OLUX9ziEAMizOgcv6Gaf06eLxzkzo/ZM2dUfCSKnb6/rWHmwWXny8qfO6HoC+FrUnHHkRgPrOgDcG0u/htzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSB0ZCak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSB0ZCak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5B71F00893;
	Mon, 28 Sep 2026 23:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790639704;
	bh=F50qz/vLjDVBH+lZEu5P4jYKRWmcSwlF5qV7TrTySMo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kSB0ZCakmyIb+pG5al12BKm3uU7Uk21epicWshRrYFTSW+q5MLFb8lKp7wgAzc6o7
	 o9mRULQw6G711WlP4pIKcaC+AMOTf7rTf9dae6bYKUoq/HigIRR8dIa00e7EMuQLoD
	 FTLl0IR9V5qwPmJ9BhzOWrQGRj/UIooNp99Mv9VJNJRUDFHkSVcGxEBiqdM9tNhsbe
	 Wz9wRw7d4K2muEqm4viX6xGYOw1ZlPXV9VR/8TK2ZUQZcQphE6wF1WiRrheGBLWUr+
	 lALz3jEZILNf1IpKHFAlfnhX/eKw5ehWd+t+uGOaVNi5pnG8gAV+ArenoT+8sfCek5
	 kTk6C1lGoxCFQ==
Subject: Re: [PATCH net 08/11] netfilter: nft_set_rbtree: skip transaction
 elements during GC
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 28 Sep 2026 23:55:03 +0000
Message-ID: <179063970372.3145.17414936987144600093@kernel.org>
In-Reply-To: <20260927220816.268206-9-pablo@netfilter.org>
References: <20260927220816.268206-9-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch does not fix the stale end pairing in
  nft_rbtree_gc_scan() (net/netfilter/nft_set_rbtree.c).

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the insertion-
  time GC path has the same wrong-end pairing, and this commit leaves it…

--

netfilter: nft_set_rbtree: skip transaction elements during GC

This patch makes nft_rbtree_gc_scan() skip any element that is not fully
active in both generations. The goal is to keep elements added by the
transaction being committed out of the scan. Without that, a new end
element could be paired with an unrelated expired start and freed before
it is activated.

> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 9894832281c4b..12431b55752fb 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -900,6 +900,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
>  		next = rb_next(node);
>  
>  		rbe = rb_entry(node, struct nft_rbtree_elem, node);
> +		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
> +			continue;

[Severity: High]
The commit message says this change "preserves interval pairing across
skipped elements". Is that the case in nft_rbtree_gc_scan()?

rbe_end is only cleared after a GC move. When the scan reaches a fully
active start that has not expired, rbe_end still points at that start's
own end:

	if (nft_rbtree_interval_end(rbe)) {
		rbe_end = rbe;
		continue;
	}
	if (!__nft_set_elem_expired(&rbe->ext, tstamp))
		continue;

The new skip also leaves rbe_end unchanged. Suppose the scan then reaches
an expired start with no end directly above it. This code then moves the
other interval's live end to priv->expired, and nft_rbtree_gc_queue()
frees it later:

	if (rbe_end) {
		nft_rbtree_gc_elem_move(net, set, priv, rbe_end);
		rbe_end = NULL;
	}

Take the reported trigger shape: a live interval above, the new elements
skipped, then an expired start without an end. Here the patch seems to
change only which end gets taken. Before, the new end element was taken,
which caused the UAF. Now it is the older, fully active end of the
interval above.

Can an orphaned expired start like this be created with the stock nft
tool? Running nft destroy element on an interval whose start has expired
seems to be enough:

nf_tables_delsetelem()
  nft_rbtree_deactivate() on the start
    -> returns NULL for the expired start, and start_rbe_cookie is
       reset to 0
    -> the -ENOENT is ignored for NFT_MSG_DESTROYSETELEM
  nft_rbtree_deactivate() on the end
    -> nft_rbtree_deactivate_same_interval() returns true because
       start_rbe_cookie is 0, so the end is deactivated

nft_set_commit_update() then removes the end from the tree with
nft_trans_elems_remove(). That happens before set->ops->commit() runs
nft_rbtree_gc_scan(). A crafted start-only NEWSETELEM placed in a gap is
also accepted by __nft_rbtree_insert() and gives the same shape.

In that case the higher interval [S_hi, E_hi) loses E_hi.
nft_rbtree_commit() then rebuilds it as [S_hi, next start). If it is the
topmost interval, it becomes open-ended (to == NULL).

Once S_hi expires, the next scan takes the end of the next live interval
above it. A later nft delete element on [S_hi, E_hi) also fails with
ENOENT because E_hi is gone.

Would it make sense to also clear rbe_end when a fully active start has
not expired?

	if (!__nft_set_elem_expired(&rbe->ext, tstamp)) {
		rbe_end = NULL;
		continue;
	}

[ ... ]

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. The
insertion-time GC path appears to have the same wrong-end pairing, and
this patch leaves it unchanged.

__nft_rbtree_insert() calls nft_rbtree_gc_elem() when it finds an
expired start that is active in the current generation. The rb_prev()
walk stops at the first fully active end, whatever interval that end
belongs to:

net/netfilter/nft_set_rbtree.c:nft_rbtree_gc_elem() {
    ...
	while (prev) {
		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
		if (nft_rbtree_interval_end(rbe_prev) &&
		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
			break;

		prev = rb_prev(prev);
	}

	rbe_prev = NULL;
	if (prev) {
		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
		nft_rbtree_gc_elem_move(net, set, priv, rbe_prev);
	}
    ...
}

The comment says end intervals "are coupled with the interval start
element", but nothing checks that coupling.

Consider a tree that, walked from high to low keys, holds:

  E_w (active), S_w (live), E_x, S_x (expired)

E_x is either pending deletion in the same batch or already removed by an
earlier nft destroy element. When an insertion walk reaches S_x, can the
rb_prev() walk skip E_x and S_w and pick E_w?

If so, nft_rbtree_gc_elem_move() erases E_w, the live end of
[S_w, E_w), and queues it on priv->expired. The next commit frees it and
rebuilds S_w as a wider or open-ended interval.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-2-pablo%40netfilter.org
