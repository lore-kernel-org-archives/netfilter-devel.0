Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531184;
	b=dZjeVs3j6so47TLJ95E4MWLoZE7x6jJjZLYSicWmbpGaU+k9Mhwxi1P9H+F2q4mOiOI5
	 lyqlf53yLgz+ed92GW+ACuVTxCNZaL0S2RJRg98f94SFGFR+Jc0X4ZmQQdIFgD3iqv46Y
	 e9jQ6yjw+8ZVgjxgecJp5YVrvuHQ3NQm708apuDtQTOb7k1aHbH/05xWZQE5vVaZ9X11i
	 IwE350/T24gwQCeARKjcBNZU9DZKv75GDkAYnUtlHykJCUYYTcw9HSk2mshjeH74LJEpL
	 gihaeKf6aWJO+rkEl6TCuLYtMrefNsJnnNIl5zP2YYNNgipwe4Jqzqi5AtVoxV1eENw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531184;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=gcSdmcz9XzR+80h/m2twr+ub9HSrXV71H6xKGJw4yio=;
	b=niqiyqo48Z6bMsjMVApqR3dsRDNnPzExSA7EcKu3R58B9M+Z8hq8wexFJBFhz36QjfI/
	 6ACI4C6ustgoMmLvcvo12c4ljZhH9ybq1SWHs/XbQaEl7T2V45o+9TdfznEJ2kSK+pME9
	 yqTeBg15VnQ4Oxo3RCrEz4BHNIpLRDXF0X3twhADf4Xeok/a3y1TO26e6dvkXnF6EdE2E
	 Na1GlJzVHud1SzsK3HOayLciCp+RpMO33NisClVf6EckN3SzQoMdCdZMLxBZCr17xJGcL
	 VqBU3yHugr2jzSjlF9mLa03rbo0JBODQo2sRnzjhyMR6qLZzLeSMrZG7nJhMvEeI6Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bFtfEWC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DF1606A686;
	Tue, 24 Nov 2026 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bFtfEWC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534C01F000D2;
	Tue, 24 Nov 2026 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531183;
	bh=gcSdmcz9XzR+80h/m2twr+ub9HSrXV71H6xKGJw4yio=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bFtfEWC4kb7+VNsCAnOBw0OBFce3e0AiFK/fu1AiiXkjqnS2I9cr2ORxePG8Zj3G+
	 CDfKnAYomurJKtoL2Z+LcSMHSHZeh5n21iP+zVdODrYTkhiyN/kI8ENN6XeSIvD9LN
	 BVY/ghf925NrI7Vt/pmoET67htFmzTgODQJ9OrD8wWcq/ksWfBDxl1GOL5CeKBc9m/
	 JaFcyeezlypLlkmH8dYpYav9Fm5a7OPwOc8afXz6+E/GuHQfcHUFYIeC8TTtLtTc3J
	 IZ1x+B4FFT69Bn48CGWdkzeBJwZ1+zWbH7gBs0cKliPXBWv/G6QCgVsNimrJS4R4WA
	 zrJPOzAAEVfYw==
Subject: Re: [PATCH net-next 12/15] netfilter: ipset: replace internal hash
 table with rhashtable
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:42 +0000
Message-ID: <179553118289.3135.2457599706568750663@kernel.org>
In-Reply-To: <20261123135726.3940688-13-pablo@netfilter.org>
References: <20261123135726.3940688-13-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 4 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Set dumps can now emit duplicate elements when the rhashtable
  grows while a LIST/SAVE dump is running, and nothing tells userspace.
- [Medium] On the replace path (an existing, non-expired element
  refreshed with IPSET_FLAG_EXIST), `mtype_new_elem()` always calls…
- [Medium] This patch drops memcg accounting for the per-set hash index.
- [Medium] `mtype_list()` runs each dump chunk inside one RCU read-side
  section (`rhashtable_walk_start(hti)` ... `rhashtable_walk_stop(hti)`)…
- [Low] The commit message credits a co-author with free text ('Joint
  work with Jozsef Kadlecisk.') and has no `Co-developed-by:` tag or…
- [Low] The commit message's guidance for the removed forced GC is
  backwards.
- [Low] The kernel-doc for `mtype_new_elem()` says 'Return: the new
  element, or PTR_ERR on failure.' Every failure path actually returns…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch
  rewrites the lookup inside this function and carries the bug forward…

--

netfilter: ipset: replace internal hash table with rhashtable

This patch moves the ipset hash set types from the private bucket array
to rhashtable. Table resizing, region locks and the forced gc on full
sets are removed. Forceadd and the multi (netiface) type are dropped
here and come back later in the series. Hashsize, initval and
bucketsize are kept only for backwards compatibility, and dumps now use
an rhashtable walker stored in the netlink callback.

> Forced GC when set is full is removed: It is too expensive to do from
> packet path insertions.  Users can either enable FORCEADD or decrease GC
> frequency.

[Severity: Low]
Is "decrease GC frequency" the intended advice? With a lower gc
frequency, a full timeout set reclaims expired entries later.

The comment added in mtype_new_elem() says the opposite:

    * its pretty much pointless, userspace can just retry once
    * gc has fired, resp. decrease the gc interval.

There is also no direct knob for the gc interval. mtype_gc() derives it
from the set timeout:

    next_run = IPSET_GC_PERIOD(set->timeout) * HZ;
    if (next_run < HZ)
        next_run = HZ;

So it can only be changed indirectly, by choosing a smaller default
timeout, and it can be as long as IPSET_GC_TIME (180 seconds). Until gc
runs, a timeout set at maxelem rejects every add with
IPSET_ERR_HASH_FULL.

Forceadd is also not available as a workaround at this commit. It only
comes back later in the series, with "netfilter: ipset: re-add forceadd
support".

> Joint work with Jozsef Kadlecisk.

[Severity: Low]
This isn't a bug, but should this be Co-developed-by: and Signed-off-by:
tags for the co-author, as described in
Documentation/process/submitting-patches.rst?

The name is also misspelled. MODULE_AUTHOR in ip_set_core.c spells it
"Jozsef Kadlecsik".

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index a3f6c0aa47f75..8ac1b0f048560 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h

[ ... ]

> @@ -825,248 +601,151 @@ mtype_cancel_gc(struct ip_set *set)

[ ... ]

> +/**
> + * mtype_new_elem() - allocate and initialize a replacement/new element

[ ... ]

> + * Return: the new element, or PTR_ERR on failure.
>   */

[Severity: Low]
This isn't a bug, but the failure paths return ERR_PTR() values
(ERR_PTR(-EEXIST), ERR_PTR(-EMFILE), ERR_PTR(-ENOMEM), ERR_PTR(ret)).
mtype_add() decodes them with IS_ERR() and PTR_ERR().

Should this say "or an ERR_PTR() on failure"? The text is the same at
the end of the series.

[ ... ]

> +#ifdef IP_SET_HASH_WITH_NETS
> +	for (i = 0; i < IPSET_NET_COUNT; i++) {
> +		ret = mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
> +		if (ret) {
> +			while (i > 0) {
> +				--i;
> +				mtype_del_cidr(set, h, DCIDR_GET(d->cidr, i), i);
> +			}
> +			kfree(e);
> +			return ERR_PTR(ret);
>  		}

[Severity: Medium]
On the replace path (old != NULL, refreshing an existing element with
IPSET_FLAG_EXIST), can this loop fail even though the number of
elements with this prefix does not change?

The new element's cidr count is added before the old element's count
is dropped:

mtype_add()
  mtype_new_elem()
    mtype_add_cidr()          /* count + 1 */
  rhashtable_replace_fast()
  mtype_add_replace_old()
    mtype_del_cidr_all()      /* count - 1 */

mtype_add_cidr() will not go past CIDR_MAX_COUNT:

    if (np.count < CIDR_MAX_COUNT) {
        np.count++;
        WRITE_ONCE(nets->nets[i], np);
    } else {
        ret = -EOVERFLOW;
    }

Suppose a prefix length already holds CIDR_MAX_COUNT ((1 << 24) - 1)
elements, which is possible because maxelem is user controlled. Then
every refresh of one of those elements returns -EOVERFLOW. mtype_add()
passes this through untranslated, and the old element keeps its old
timeout, counters and comment.

On the SET target path with --exist the error is silent. An element
that keeps seeing traffic would therefore still expire.

The old code jumped to overwrite_extensions on a refresh and never
touched the cidr counts. Would it make sense to skip the add/del cidr
pair when old is set? The same code is still there at the end of the
series.

[ ... ]

> @@ -1391,30 +867,26 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,

[ ... ]

>  	pr_debug("test by nets\n");
> -	rcu_read_lock_bh();
>  retry:
>  	multi = 0;
> -	nets0 = rcu_dereference_bh(h->rnets[0]);
> +	nets0 = ipset_dereference_bh_nfnl(h->rnets[0]);
>  	seq0 = read_seqcount_begin(&nets0->seq);

[ ... ]

> @@ -1434,38 +906,25 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  #else
>  		mtype_data_netmask(d, p0.cidr);
>  #endif

[ ... ]

> +		e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
> +		if (e) {
> +			ret = mtype_data_match(&e->elem, ext, mext, set, flags);
>  			if (ret != 0)

[ ... ]

> +				goto check_retry;
> +			multi = false;
>  		}
>  #if IPSET_NET_COUNT == 2
>  		}
>  #endif
>  	}
>  	ret = 0;
> -unlock:
> +check_retry:
>  	if (read_seqcount_retry(&nets0->seq, seq0))
>  		goto retry;

[Severity: High]
This isn't a bug introduced by this patch, but this loop's lookup is
rewritten here. Is the retry safe for the IPSET_NET_COUNT == 1 types?

mtype_data_netmask() masks the caller's element in place. For example,
hash_net4_data_netmask() does:

    elem->ip &= ip_set_netmask(cidr);

Only the IPSET_NET_COUNT == 2 variant restores d from orig. For
hash:net, hash:net,port, hash:ip,port,net and hash:net,iface, d is
still masked to the shortest prefix when goto retry runs. The loop then
starts again at the longest prefix.

For a set holding {10.0.0.0/24, 11.0.0.0/8}, testing 10.1.2.3 would go
like this:

first pass:  10.1.2.0/24 no match, 10.0.0.0/8 no match, ret = 0
             read_seqcount_retry() sees a change
retry:       10.0.0.0/24 matches

Can this make a firewall rule match an address that is not in the set?

The seqcount writer is mtype_del_cidr(), which bumps nets->seq when a
prefix count drops to zero. That can happen during a userspace del, gc
expiry of the last element with a given prefix, or SET --del-set. The
packet path tests meanwhile hold only rcu_read_lock_bh().

A related question: mtype_data_match() calls
ip_set_match_extensions()->ip_set_update_counter(), which updates the
matched element's packet and byte counters inside the read section.
Does a retry after a match count the packet twice?

The baseline code already has this problem, and it is still present at
the end of the series.

[ ... ]

> @@ -1633,77 +1062,82 @@ static int
>  mtype_list(const struct ip_set *set,
>  	   struct sk_buff *skb, struct netlink_callback *cb)
>  {

[ ... ]

> -	rcu_read_lock();
> -	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
> -	     cb->args[IPSET_CB_ARG0]++) {
> -		cond_resched_rcu();

[ ... ]

> +	rhashtable_walk_start(hti);
> +	{
> +		struct mtype_rht_elem *e, *peeked;
> +		struct nlattr *nested;
> +		void *incomplete;
> +
> +		while ((e = rhashtable_walk_peek(hti))) {
> +			if (IS_ERR(e)) {
> +				if (PTR_ERR(e) == -EAGAIN)
> +					continue;
> +				ret = PTR_ERR(e);
> +				break;
> +			}
> +			peeked = e;
> +next_dump:
> +			if (SET_ELEM_EXPIRED(set, &e->elem))
> +				goto next_entry;

[Severity: Medium]
Each dump chunk now runs inside a single RCU read-side section, from
rhashtable_walk_start() to rhashtable_walk_stop(). The
cond_resched_rcu() that the old per-bucket loop had is gone.

Expired elements are skipped here without using any skb space. The only
limit on how long one chunk runs is therefore the number of expired
entries that gc has not yet collected, plus empty buckets.

mtype_gc_do() gets mtype_gc_resched() in this patch, but mtype_list()
does not. The gc before listing only runs from
mtype_head()->mtype_rht_size() on the first chunk. Entries that expire
during a multi-chunk dump are still walked by later chunks.

Take a large timeout set (gc period up to 180 seconds) full of
short-lived entries. Can a later chunk hold rcu_read_lock long enough
to trigger RCU stall or soft lockup warnings on non-preemptible
kernels? The non-multi mtype_list() loop still has no resched point at
the end of the series.

[ ... ]

> +next_entry:
> +			e = rhashtable_walk_next(hti);
> +			if (IS_ERR(e)) {
> +				ret = PTR_ERR(e);
> +				if (ret != -EAGAIN)
> +					break;
> +				ret = 0;
> +			} else if (peeked && e != peeked) {
> +				peeked = NULL;
> +				if (e)
> +					goto next_dump;
> +			}

[Severity: Medium]
Can a dump now emit duplicate elements when the table grows during a
multi-message list or save?

The commit message ties this only to automatic shrinking:

    With automatic_shrinking enabled, that can cause the dump walker to
    hit -EAGAIN during resize which may results in duplicate or omitted
    elements.

Growth happens regardless of that setting. rht_deferred_worker() in
lib/rhashtable.c does:

    if (rht_grow_above_75(ht, tbl))
        err = rhashtable_rehash_alloc(ht, tbl, tbl->size * 2);
    else if (ht->p.automatic_shrinking && rht_shrink_below_30(ht, tbl))

After the rehash, rhashtable_rehash_table() sets walker->tbl = NULL for
the walkers on the old table. The next rhashtable_walk_start() in
mtype_list() then starts over at the beginning of the new table:

    if (!iter->walker.tbl) {
        iter->walker.tbl = rht_dereference_rcu(ht->tbl, ht);
        iter->slot = 0;
        iter->skip = 0;

The void rhashtable_walk_start() wrapper drops the -EAGAIN. Inside a
chunk, -EAGAIN from rhashtable_walk_peek() and rhashtable_walk_next()
is also treated as continue.

Elements that were already sent, in earlier messages or earlier in the
current one, would be sent again. NLM_F_DUMP_INTR is never set.

The old mtype_uref() pinned the dumped table through t->uref ("Make
possible to run dumping parallel with resizing"), so a resize never
affected a dump in progress.

Now hashsize is ignored, no nelem_hint is set, and every set starts at
the default rhashtable size, so growth is routine. Concurrent SET
target adds, or adds from another process during ipset list or ipset
save, would be enough to trigger it.

Could this make "ipset save | ipset restore" fail with "already added"
errors? This is still present at the end of the series.

[ ... ]

> @@ -1860,36 +1297,19 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>  	if (err)
>  		goto free_h;
>  
> -	/* Compute htable_bits from the user input parameter hashsize.
> -	 * Assume that hashsize == 2^htable_bits,
> -	 * otherwise round up to the first 2^n value.
> -	 */
> -	hbits = fls(hashsize - 1);
> -	hsize = htable_size(hbits);
> -	if (hsize == 0)
> -		goto free_rht;
> -	t = ip_set_alloc(hsize);
> -	if (!t)
> -		goto free_rht;
> -	t->hregion = ip_set_alloc(ahash_sizeof_regions(hbits));
> -	if (!t->hregion)
> -		goto free_t;

[Severity: Medium]
With ip_set_alloc() gone, is the hash index still charged to the
creator's memcg?

ip_set_alloc() is kvzalloc(size, GFP_KERNEL_ACCOUNT). It was used for
both the bucket array and hregion, here and in mtype_resize().

The rhashtable bucket tables come from bucket_table_alloc() without
__GFP_ACCOUNT:

    rhashtable_init()           GFP_KERNEL
    rhashtable_rehash_alloc()   GFP_KERNEL, from the ht->run_work kworker
    insert slow path            GFP_ATOMIC | __GFP_NOWARN

params.max_size = maxelem is a user-controlled u32, so the uncharged
bucket table grows with the element count. Creating such a set only
needs CAP_NET_ADMIN in a netns.

The element objects from mtype_new_elem() are allocated with
kzalloc(..., GFP_ATOMIC) and no accounting, even on the sleepable
userspace add path. Element storage was already uncharged before this
patch, so what is newly lost here is the charge for the index. The dump
iterator in mtype_uref() does use GFP_KERNEL_ACCOUNT.

No later patch in the series restores the accounting.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
