Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795260282;
	b=Czc76hVUEEfFQq4Cwir0t0Hb0Q9jmB5YMBvIX4/vO2sb8jDMguHvQ13UiqALomTxjN6n
	 9nhlJm7hsUCGvEydzWleX6iOTsadTuP3DCDmbeXmpEZVW78engEkXyOv90VTyeDpMmTH1
	 SLAsCYVozvTd/eVlApkxTNz6hKjH+HnwQJ8xcfYYkDHsVksRbCMnN+noCZe8CK7hFOksD
	 ZrlhM/mxHXFb4tkD3/CwG0BDGw7eHfQPJaZMZ+oQh7JoEB2czQ/wtDIs0XN8SxwmlqW18
	 F9DgmFvBXN9lJnQU5ayNLiykxEOaUOQlfHlp23/0VAfp7XZXEmcAgrhxMEaQLRrtZ5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795260282;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=LbixzkneRqLhhpaWwV4gyxp4t0JBzGNMSQT5/n1d4Jo=;
	b=bQF0WK6B4hybLm23EjO4DhBTun5oITSRfb6dxbM1b4ohfOel/2GOMa+/F3Wi14HEDCkl
	 S4FaJgbHpgX3fMZgvUgTVF/ARpqy8+USaTs/zHH4QqpiRiUzufmi79RGovrmCB5OUWnkg
	 yFElfdUCng1N2PjecWEmEcApDh3b+4oM6U/q8fmqozhrAIynu09XynLgMQg/hpqc4dHTT
	 M7190ZHeEn3ajH2W72i74pDJCbo+Qzo9ljrb3nlqL+a6BOGCfQ+DkhPLN/BPWVMw84aXk
	 b/bSPzJyQ+jNS23gHJyR6RmgCP+QBJ4X8n2DM7XbV1u4RX0+nIzBxM6JtM8L+oAlfAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BHLkPSte;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD01606A320;
	Sat, 21 Nov 2026 11:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BHLkPSte
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD58C1F000C4;
	Sat, 21 Nov 2026 11:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795260281;
	bh=LbixzkneRqLhhpaWwV4gyxp4t0JBzGNMSQT5/n1d4Jo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BHLkPSteByQ7hIb7bMzVMXtYfsmpoibtfzKf4G45RltojxNBinYeSHBhkh7RVsgeu
	 9wLsrixCGCxwS0QvFG5MK95G+LkhoIsrf329mxoQZQezByXG+L3ueLSnPoI/Sxcy7n
	 OsHh3CLuvGvvduYChm6vThI4fyCLZuDUwMPJlU1QQDgCnT1AJjWYpsDs/11mNKXEaz
	 yd4aoDJ5nAxJSlfN5I+7BzI51I4rnTlRA2xtJdEsoNvkYDVwqFlCidN4zwJ6oBS2oO
	 D7mV1HTttgdgJN3RV25XgK7cL6UgDdZ187QbDQk146E8c7EeHQPyqu9Wlla0Kx+q6b
	 Lia00LXMg/UhQ==
Subject: Re: [PATCH net] netfilter: ipset: skip inline gc during hash resize
From: netdev-bot+sashiko@kernel.org
To: juny24602@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 kadlec@netfilter.org, echaudro@redhat.com, aconole@redhat.com,
 david.lee@trailofbits.com, manizada@pm.me, yifanwucs@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, junvyyang@tencent.com, corvus@tencent.com,
 stable@kernel.org
Date: Sat, 21 Nov 2026 11:24:40 +0000
Message-ID: <179526028037.3135.6082902394676287459@kernel.org>
In-Reply-To: <20261117110619.46590-1-juny24602@gmail.com>
References: <20261117110619.46590-1-juny24602@gmail.com>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 (1) · Low: 1 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Low] Undocumented behaviour change.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is a double
  free of the same kind.
- [Medium] Memory leak (pre-existing).
- [Low] Stale comments (pre-existing).

--

netfilter: ipset: skip inline gc during hash resize

This patch takes h->gc.lock and checks t->resizing before mtype_add()
runs inline garbage collection on a full hash region. The goal is to
avoid freeing a comment extension in the old table after mtype_resize()
has shallow-copied it into the new table, since the new table would
later free it again.

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 80ca523f304bb..70f768ba7b443 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1009,8 +1009,12 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	maxelem = t->maxelem;
>  	if (elements >= maxelem) {
>  		u32 e;
> -		if (SET_WITH_TIMEOUT(set))
> -			mtype_gc_do(set, h, t, r);
> +		if (SET_WITH_TIMEOUT(set)) {
> +			spin_lock_bh(&h->gc.lock);
> +			if (!t->resizing)
> +				mtype_gc_do(set, h, t, r);
> +			spin_unlock_bh(&h->gc.lock);
> +		}

[Severity: High]
Does this fully close the double free described in the commit message?

Skipping mtype_gc_do() leaves the expired element in the old table. The
same mtype_add() call can then free its extensions a few lines later
through the reuse branch:

net/netfilter/ipset/ip_set_hash_gen.h:mtype_add() {
    ...
		/* Reuse first timed out entry */
		if (SET_ELEM_EXPIRED(set, data) && j == -1) {
			j = i;
			reuse = true;
		}
	}
	if (reuse || forceadd) {
		if (j == -1)
			j = 0;
		data = ahash_data(n, j, set->dsize);
		if (!deleted) {
			mtype_del_cidr_all(set, h, data);
			ip_set_ext_destroy(set, data);
			t->hregion[r].elements--;
		}
		goto copy_data;
	}
    ...
}

Hash types set region_lock, so ip_set_add() from the SET target takes
no set->lock. mtype_resize() copies elements under rcu_read_lock_bh()
only. That seems to allow this sequence:

1. mtype_resize() memcpy()s a live element E, including its comment
   pointer C, into the new table.
2. E expires.
3. A SET target add of a different value hashes to E's bucket in the
   old table. It finds E expired and sets reuse, with deleted still
   false.
4. ip_set_ext_destroy()->ip_set_comment_free() calls kfree_rcu(C) and
   clears only the old table's pointer.
5. The new table's copy still holds C. Periodic GC, mtype_flush(), or
   mtype_destroy()->mtype_ahash_destroy(set, t, true)->
   mtype_ext_cleanup() then frees C again, after reading strlen(c->str)
   from freed memory.

The forceadd case also looks easier to reach now. With GC skipped,
elements stays at or above maxelem, so SET_WITH_FORCEADD sets get:

		if (elements >= maxelem && SET_WITH_FORCEADD(set))
			forceadd = true;

The reuse/forceadd branch then evicts slot 0. That slot may hold a live
element that resize has already copied.

Guarding only mtype_gc_do() doesn't seem to be enough. Would the fix
need to block every old table extension free while t->resizing is set
(this branch and mtype_del() too), or transfer ownership of the
comment instead?

>  		maxelem = h->maxelem;
>  		elements = 0;
>  		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)

[Severity: Low]
Is this behavior change intended, and should the commit message mention
it? While t->resizing is set, inline GC is skipped, so the elements
total recomputed here still counts expired entries.

Suppose that total is >= h->maxelem, forceadd is not set, and the
target bucket has no expired or deleted slot to reuse. mtype_add() now
reaches:

	if (elements >= maxelem)
		goto set_full;

or the set_full path for an empty bucket. The set_full path skips the
resize: block, which is where kernel side adds get queued for replay:

	if (t->resizing && ext && ext->target) {
		/* Resize is in process and kernel side add, save values */

The add returns -IPSET_ERR_HASH_FULL and may log the ratelimited
"Set %s is full" warning. It is never replayed into the new table,
which would have had room because resize does not copy expired entries.

Before this patch, inline GC lowered the counts, so the add succeeded
and was queued.

[Severity: High]
This isn't a bug introduced by this patch, but a SET target delete
(--del-set) that runs during mtype_resize() causes a similar double
free.

mtype_del() destroys the extension on the old table element and then
queues the delete for replay:

net/netfilter/ipset/ip_set_hash_gen.h:mtype_del() {
    ...
		t->hregion[r].elements--;
		mtype_del_cidr_all(set, h, d);
		ip_set_ext_destroy(set, data);

		if (t->resizing && ext && ext->target) {
			/* Resize is in process and kernel side del,
			 * save values
			 */
			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
    ...
}

After the table switch and synchronize_rcu(), mtype_resize() replays
the delete on the new table:

		} else {
			mtype_del(set, &x->d, NULL, NULL, 0);
		}

Suppose element E was already copied into the new table as E'. The
replay finds E' and calls ip_set_ext_destroy() on the same comment C a
second time. ip_set_comment_free() then reads strlen(c->str) from freed
memory and calls kfree_rcu(c) again.

If E' has expired by the time of the replay, the replay skips it. A
later GC, flush or destroy of the new table still frees C again. No
expiry is needed: the delete only has to land after the element's
region was copied and before the table switch.

Could this be fixed together with the add side?

[Severity: Low]
This is a pre-existing issue, but the file header comment in
ip_set_hash_gen.h says:

 * are serialized by the nfnl mutex. During resizing the set is
 * read-locked, so the only possible concurrent operations are
 * the kernel side readers. Those must be protected by proper RCU locking.

That contradicts the comment in mtype_resize():

	/* There can't be another parallel resizing,
	 * but dumping and kernel side add/del are possible
	 */

It also contradicts the t->resizing replay handling in mtype_add() and
mtype_del().

The comment above ip_set_comment_free() in ip_set_core.c says:

/* Called from uadd/udel, flush or the garbage collectors protected
 * by the set spinlock.

However, mtype_gc_do() never holds set->lock, including at the call
site changed here. It holds only the region lock, plus h->gc.lock after
this patch.

Both comments state locking assumptions that the double free cases
above show to be wrong. Could they be updated?

[Severity: Medium]
This is a pre-existing issue, but does mtype_resize() leak the comment
of each expired element it skips? The copy loop does:

				if (SET_ELEM_EXPIRED(set, data))
					continue;

It never calls ip_set_ext_destroy() on these elements. The old table is
then released with:

		mtype_ahash_destroy(set, orig, false);

With ext_destroy false, mtype_ahash_destroy() skips
mtype_ext_cleanup():

		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
			mtype_ext_cleanup(set, n);

So each skipped element's ip_set_comment_rcu is never freed, and
set->ext_size is never decremented for it. The last uref paths in
mtype_add(), mtype_del() and mtype_gc() release the old table the same
way.

This patch skips inline GC while resizing, so it can leave a few more
expired entries in the old table for resize to drop.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117110619.46590-1-juny24602%40gmail.com
