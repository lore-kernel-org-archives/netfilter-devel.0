Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531188;
	b=iZBey5Y21nlLHDPZttiVL/N+ORLf1voiEfcWy53ghpqx9zK5MarlBBzQHgnxz6Nce7Wh
	 etR/UdIqpmNd8YyySSYcLktwkJqdIyDPqV31LVNJnfkOKQIK9c3XmkVdaE0uJCQJqe7jd
	 soKu6geMlSiRvaHVwbPdnK+VdYrhVKBb+FuVs/H4uCal1jiVfrguoYVoLwDtBEs1wgckv
	 iGSyBJk/x/pIhvSlkJXOqAF9N+PlB120aI6+sT5Bjm8xyV+Ran0DBM0k6zHA7LVBv7tsx
	 YzVaIwiY7iPYe9I+MIZGsC08lzmAlLC0hFv6I6kdY+U7MaELj+D4QDqvRiG/j9TiezA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531188;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=AE/ZMRJm1vER60qJmgDTOQ8c0clB4v20aDU6EMVQxYg=;
	b=hpgFmI9u6wgR7ZWwBBiEdjfr2VB1jJKU7SlszP1sD8qJxxR/LzK5ceX3Sm6lEQ2SRdXi
	 YFAk0OT1+qInJ78yMeQu6uUQ+9D9nz9edmLoSlySMx1cmJU0MinWeIDuPfC5tQZNfX4bv
	 ft4PK2zwhBoA58R/9fHNJ/XPzRvYfsAUTBFFvBe8M8gpR6X5Pnx6pX72u0S4wyRSVCV/T
	 a3WoL2h5eY/rcMsx8uABeV17hFJg7wwNhk1mtqu8QFUaF12Al2IqU3FvBRKyBfI8XnwqT
	 RZuQIJSsYwP2FHNPDSXAdbuMyCee1OZfykA8wRGLONhlxfGnD3PxFAqy+8Dvm770L9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5qdWybp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76C3606A331;
	Tue, 24 Nov 2026 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5qdWybp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F261F000ED;
	Tue, 24 Nov 2026 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531188;
	bh=AE/ZMRJm1vER60qJmgDTOQ8c0clB4v20aDU6EMVQxYg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=V5qdWybpHrc/peSxrqGtmYwmpK8dhXFYEHy7Y9bFLb7WMBw7ZwpC4ccJUPRklTtPC
	 kEZP8anBDBN887s76PWMDpv0VNHydW2F9KpzQmjuF7G9giGtaGNCCv5k7OTf+kL8YJ
	 +KQg3lhGDPfHJ4vLhoOCwdndABqQEe8Q5NpbqxSaSRS/U+6Mo/6f23zXI/NcS3d9eM
	 yyIOo8CxE86jFty1rodtSfqUplNmYBM+B4Ut+IMw5pbGa+9UWX4GuGOx3H4ipWfUfy
	 vfpxw693QZeFmtTRCKaHgn7lr0jfxqVvvjnm4C7qHZGa+RJNPtKHL/rK3u/hVzj4IG
	 zMwpsN+zV+DaA==
Subject: Re: [PATCH net-next 15/15] netfilter: ipset: re-add forceadd support
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:47 +0000
Message-ID: <179553118759.3135.6585926513331590703@kernel.org>
In-Reply-To: <20261123135726.3940688-16-pablo@netfilter.org>
References: <20261123135726.3940688-16-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] On CONFIG_SMP=n kernels without CONFIG_DEBUG_SPINLOCK,
  mtype_remove_random() in the hash:net,iface (IP_SET_HASH_WITH_MULTI)…
- [Medium] Forceadd on a full set now fails a large fraction of the time,
  which does not match the commit message's claim that the add is…
- [Low] mtype_new_elem() evicts a random element through
  mtype_remove_random() before steps that can still fail, and nothing…

--

netfilter: ipset: re-add forceadd support

This patch brings back forceadd eviction for the ipset hash types, which
the rhashtable conversion dropped. It adds mtype_remove_random(). That
helper looks up one random bucket using an always-matching compare
function, then evicts the element it finds. For IP_SET_HASH_WITH_MULTI
sets it evicts the first element of the group it finds. mtype_new_elem()
calls the helper when a forceadd set has reached maxelem.

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 39ef51c44df87..eab1e2bd85ff2 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h

[ ... ]

> @@ -950,6 +954,93 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)

[ ... ]

> +#ifdef IP_SET_HASH_WITH_MULTI
> +	{

[ ... ]

> +		grp = rhashtable_lookup(&h->ht, k, ip_set_hash_grp_rnd_params);
> +		if (!grp)
> +			return false;
> +
> +		/* mtype_add() can call us while already holding this exact
> +		 * group's lock (maxelem reached while inserting into it);
> +		 * trylock to avoid self-deadlock. Best-effort: no linear
> +		 * scan, 'return false' is fine either way.
> +		 */
> +		if (!spin_trylock_bh(&grp->lock))
> +			return false;
> +		e = hlist_entry_safe(grp->iface_list.first,
> +				     struct mtype_rht_elem, node);
> +		if (!e) {
> +			spin_unlock_bh(&grp->lock);
> +			return false;
> +		}
> +		mtype_group_remove_elem(set, h, grp, e);
> +		mtype_group_unlock(h, grp);
> +		return true;

[Severity: High]
Does this trylock ever fail on CONFIG_SMP=n kernels without
CONFIG_DEBUG_SPINLOCK? On those builds, include/linux/spinlock_api_up.h
has:

static __always_inline int _raw_spin_trylock_bh(raw_spinlock_t *lock)
	__cond_acquires(true, lock)
{
	__LOCK_BH(lock);
	return 1;
}

If the random probe lands on the group that mtype_add() already holds,
the trylock succeeds instead of returning false.

If that group has exactly one element, this sequence looks possible:

mtype_add()
  mtype_group_get_or_create()        /* grp locked */
  mtype_new_elem(..., old == NULL)
    mtype_remove_random()
      spin_trylock_bh(&grp->lock)    /* succeeds on UP */
      mtype_group_remove_elem()
      mtype_group_unlock()
        rhashtable_remove_fast(&h->ht, &grp->node, ...)
        grp->dead = true;
        kfree_rcu(grp, rcu);

Back in mtype_add(), the new element is then linked in without any
grp->dead check:

		} else {
			hlist_add_tail_rcu(&e->node, &grp->iface_list);
			atomic_inc(&h->nelems);
		}
		spin_unlock_bh(&grp->lock);

Would the new element end up in a group that is no longer in h->ht and
is freed after the grace period?

If so, test, del, gc and flush could not reach that element, so the
element and its comment extension would leak. h->nelems and the cidr
prefix counts would never be decremented, not even by flush, because
mtype_flush_group() only accounts for elements it can reach. The add
would also be reported as success.

mtype_group_get_or_create() already refuses to insert into dead groups
to avoid this state.

This is reachable from the SET target on the packet path. Could repeated
hits keep reducing the set's usable capacity until it stays full?

> +	}
> +#else
> +	{

[ ... ]

> +		e = rhashtable_lookup(&h->ht, &k, ip_set_hash_rnd_params);
> +		if (!e || rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params))
> +			return false;

[Severity: Medium]
How often does this single probe find an element once the set is full?

mtype_create() sets params.max_size = maxelem, and rhashtable_init()
rounds it down to a power of two:

	ht->p.max_size = rounddown_pow_of_two(params->max_size);

That gives a full set a load factor between 1 and 2. With the default
maxelem of 65536 there are 65536 buckets for 65536 elements, so roughly
e^-1, about 37%, of the buckets are empty.

Each probe that hits an empty bucket makes mtype_new_elem() return
-EMFILE (-IPSET_ERR_HASH_FULL) and log "Set %s is full", even though the
set was created with forceadd.

For hash:net,iface (IP_SET_HASH_WITH_MULTI) the table holds groups, not
elements. The load factor there is lower, so the MULTI probe above would
miss roughly 47-69% of the time.

The commit message says:

    If there is one, try to evict it and allow add of the new element
    just like before the rhashtable conversion.

The old code only failed when the new key's own bucket was empty, and
its buckets were dense (up to bucketsize entries each), so forceadd
almost always succeeded.

Would a bounded number of extra random probes, or falling back to
evicting from the new key's own bucket, get closer to the old behaviour?

> +
> +		ipset_hash_elem_destroy_free(set, e);
> +		return true;
> +	}
> +#endif
> +}

[ ... ]

> @@ -993,7 +1084,7 @@ mtype_new_elem(struct ip_set *set, struct htype *h, const struct mtype_elem *d,
>  		 * its pretty much pointless, userspace can just retry once
>  		 * gc has fired, resp. decrease the gc interval.
>  		 */
> -		if (1) {
> +		if (!SET_WITH_FORCEADD(set) || !mtype_remove_random(set)) {
>  			if (net_ratelimit())
>  				pr_warn("Set %s is full, maxelem %u reached\n",
>  					set->name, h->maxelem);

[Severity: Low]
The eviction happens here, before steps that can still fail. What
happens to the evicted entry if the add fails after that?

Once mtype_remove_random() has returned true, mtype_new_elem() can still
fail here:

	e = kzalloc(offsetof(struct mtype_rht_elem, elem) + set->dsize,
		    GFP_ATOMIC);
	if (!e)
		return ERR_PTR(-ENOMEM);

It can also fail in mtype_add_cidr() with -ENOMEM or -EOVERFLOW. In the
non-MULTI path of mtype_add(), rhashtable_lookup_insert_key() can return
-EEXIST, -ENOMEM, -E2BIG or -EBUSY.

The error path in mtype_add() only destroys the new element and undoes
its cidr accounting:

	if (ret) {
		ip_set_ext_destroy(set, &e->elem);
		kfree_rcu(e, rcu);
		/* error: Undo mtype_add_cidr(). */
		mtype_del_cidr_all(set, h, d);
	}

So the set loses a random entry even though the add fails.

Hash types use region_lock = true, so ip_set_lock() does not serialize
adds. Two CPUs adding the same new key to a full forceadd set (for
example via the SET target) could each evict an element while only one
insert succeeds. The other CPU gets -EEXIST, which is reported as
success with IPSET_FLAG_EXIST.

The pre-rhashtable code reused the slot in place and had no failure
point after dropping the old entry.

Could the eviction be moved after the allocation and cidr steps, or is
losing an extra entry acceptable for forceadd sets?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
