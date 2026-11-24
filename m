Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531181;
	b=ywvF2f3E7U3Bt28s3SGqUIwl3c7J8Cs2aC12xm5n9cXvTz0i17z5XlBrLkZjyadIXREv
	 lGVEHXQbZIBPsbQQHgZXTN5QaJBNOOSy6OoYcdg3QkUCcrF99TAakY95VLiVaNJDNZrS0
	 UcvI+NBvQeeDTWiffA988/gnvjg3+hDHKG2TzWN4V8ep+ESzWPGW8k5asqzW2r0hUPCJn
	 YA935veoTDCq3wRRtSCnDsX8Vux2x/b2o609uC5ZEmdWg7ciuly+K3ce4cFwul74AZ/Ty
	 d3Q7wTYRnoVBLkmC4pSb9yB8QCcgdeYGaaXgx7y4K+LIxvRqkHhf2LtL2Qo+xHNPyng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531181;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=y/YwJv+gXI6fpEcbWhqqW6ovhW7wwFrXf6WmrynW4fs=;
	b=BPOhAce+ENUzpxOvUAE4UPTz5mHUOC5gCQL4UT+emIlJw5vTJVdXrGjgFSp7RIL/Bkr0
	 Q/r9LAJ85TQhRqKMqd+EQpub+KF98WJIcaLMvWbsg+A8I0jd4+TEjAw3tsegyC9THO+GD
	 KptHGWsunyR8QsxVve2Doho8NPZvudLyBJKr28LkwCs0QjPO4FEZYY2hOFtUr7ojrR7gz
	 rTAt/HKDrcg3E1mzpkLWulJCvglYtxqIrd3wnFrPqHXt0ZynYV2wwnwQgid4IDw2wAw5B
	 RGR0nkQnSAoZL+PLIkg6q8/VkAIym65KlkS53Wr+zVrwetOCXd4Lr5Sgi3Rb0TMM4Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXjqjylr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F8E606A336;
	Tue, 24 Nov 2026 14:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXjqjylr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39321F000D2;
	Tue, 24 Nov 2026 14:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531181;
	bh=y/YwJv+gXI6fpEcbWhqqW6ovhW7wwFrXf6WmrynW4fs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MXjqjylrHM6Q0bzi8NKUwXbMj1QdWPSM/7yEy99OVOaHUuieeW+nWb+1+EsrxSVry
	 bACBDJMK7IuUiJUPT2gQ9SVz9OUP1olQTt/PY2l0G/BCFA7qpRVQz62v5ARMysAZhV
	 n0LQSVTImLdlhxwAHK8KIkTnAAyeVUzR2DfOphd3BcYxz9G8s88peslux7+AVyN7/R
	 Pvf7rXwa3FiZow1IWcAzmZRbd0ptWAJLgjbJAkrNIRsSzMfUe7MKyR0tJBN9olm+R5
	 2P2kFg175Ge+IEjTEe8Pzl0ztbqp0M00t5Y6ZOrEXZld4VwsUHFL8Lh1+Z2LpFNcT4
	 btbZNW624fI5g==
Subject:
 Re: [PATCH net-next 10/15] rhashtable: Add rhashtable_flush_and_free helper
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:40 +0000
Message-ID: <179553118024.3135.15522891902677497463@kernel.org>
In-Reply-To: <20261123135726.3940688-11-pablo@netfilter.org>
References: <20261123135726.3940688-11-pablo@netfilter.org>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] When rhashtable_free_and_destroy() is split into the new
  rhashtable_free() helper in lib/rhashtable.c, the patch deletes the…
- [Low] The kernel-doc for the new flush helpers is wrong in places and
  leaves out the new error behaviour.
- [Low] rhashtable_next_key() (lib/rhashtable.c:775) is documented as
  returning ERR_PTR(-ENOENT) "if prev_key was concurrently deleted and…
- [Low] rhashtable_flush_and_free() handles a walker differently
  depending on whether it is parked or active, and the rhashtable_walk_*…
- [Low] bucket_table_alloc() still calls rcu_head_init(&tbl->rcu)
  (lib/rhashtable.c:215).

--

rhashtable: Add rhashtable_flush_and_free helper

This adds rhashtable_flush_and_free() and rhltable_flush_and_free(). They
swap in a new empty bucket table, briefly leaving ht->tbl NULL, and then
free the elements of the old table. The rest of rhashtable is updated to
handle a NULL ht->tbl, and rhashtable_walk_stop() now checks a new
tbl->dying flag instead of calling rcu_head_after_call_rcu().

> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 500c45cd13048..7b33dd046f677 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c

[ ... ]

> @@ -779,6 +781,8 @@ void *rhashtable_next_key(struct rhashtable *ht, const void *prev_key)
>  		return ERR_PTR(-EOPNOTSUPP);
>  
>  	tbl = rht_dereference_rcu(ht->tbl, ht);
> +	if (!tbl)
> +		return NULL;

[Severity: Low]
Is NULL the right return value here when prev_key is non-NULL?

The kernel-doc for rhashtable_next_key() says:

 *   - If prev_key was concurrently deleted and is not present in any
 *     in-flight table, returns ERR_PTR(-ENOENT).
 *
 * Returns entry of the next element, or NULL when iteration is exhausted,

While rhashtable_flush_and_free() has ht->tbl set to NULL, a caller in the
middle of an iteration is told the iteration finished normally. If the same
call runs just after the new table is installed, it returns
ERR_PTR(-ENOENT), because the new table doesn't contain prev_key.

A caller that restarts on -ENOENT, as kernel/bpf/hashtab.c does, would stop
instead. None of the current next_key users call the flush helper, so for
now this only conflicts with the documented contract.

Should this return ERR_PTR(-ENOENT) when prev_key is set?

>  	do {
>  		he = __rhashtable_next_in_table(ht, tbl, prev_key);
>  		if (!IS_ERR_OR_NULL(he))

[ ... ]

> @@ -1091,7 +1100,7 @@ void rhashtable_walk_stop(struct rhashtable_iter *iter)
>  	ht = iter->ht;
>  
>  	spin_lock(&ht->lock);
> -	if (rcu_head_after_call_rcu(&tbl->rcu, bucket_table_free_rcu))
> +	if (tbl->dying)

[Severity: Low]
This isn't a bug, but this removes the last rcu_head_after_call_rcu() user
in lib/rhashtable.c. bucket_table_alloc() still does:

	rcu_head_init(&tbl->rcu);

rcu_head_init() only exists to support rcu_head_after_call_rcu(), so that
call now looks dead.

Also, tbl->dying is never explicitly initialized. It is only false because
both bucket_table_alloc() and nested_bucket_table_alloc() pass
__GFP_ZERO.

Could the rcu_head_init() be dropped, or replaced with an explicit
tbl->dying = false?

>  		/* This bucket table is being freed, don't re-link it. */
>  		iter->walker.tbl = NULL;
>  	else

[ ... ]

> @@ -1223,45 +1232,12 @@ static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
>  	} while (list);
>  }
>  
> -/**
> - * rhashtable_free_and_destroy - free elements and destroy hash table

[ ... ]

> -void rhashtable_free_and_destroy(struct rhashtable *ht,
> -				 void (*free_fn)(void *ptr, void *arg),
> -				 void *arg)
> +static void rhashtable_free(struct rhashtable *ht, struct bucket_table *tbl,
> +			    void (*free_fn)(void *ptr, void *arg), void *arg)
>  {
> -	struct bucket_table *tbl, *next_tbl;
> +	struct bucket_table *next_tbl;
>  	unsigned int i;
>  
> -	irq_work_sync(&ht->run_irq_work);
> -	cancel_work_sync(&ht->run_work);
> -
> -	/*
> -	 * Do NOT take ht->mutex here. The rehash worker establishes
> -	 * ht->mutex -> fs_reclaim via GFP_KERNEL bucket allocation under
> -	 * the mutex; callers on the reclaim path (e.g. simple_xattr_ht_free()
> -	 * from evict() under the dcache shrinker for shmem/kernfs/pidfs
> -	 * inodes) would otherwise close a circular dependency
> -	 * fs_reclaim -> ht->mutex.
> -	 */

[Severity: Low]
Was dropping this comment intentional?

Commit 09ae540e1d5c added it as part of a lockdep fix. The commit message
explains why the "Re-arm via @run_work" comment in rht_deferred_worker()
goes away, but it doesn't mention this one.

The remaining kernel-doc only says the tables "can be walked without
ht->mutex held". It no longer says that taking the mutex here would create
a lock cycle with reclaim.

The new rhashtable_flush_and_free() does take ht->mutex, and its kernel-doc
only says it "may sleep".

Could this comment stay next to rhashtable_free_and_destroy()? Could the
rhashtable_flush_and_free() kernel-doc also say that it must not be called
from reclaim paths?

> -	tbl = rcu_dereference_raw(ht->tbl);
>  restart:
>  	if (free_fn) {
>  		for (i = 0; i < tbl->size; i++) {

[ ... ]

> @@ -1362,3 +1368,79 @@ struct rhash_lock_head __rcu **rht_bucket_nested_insert(
>  
>  }
>  EXPORT_SYMBOL_GPL(rht_bucket_nested_insert);
> +
> +/**
> + * rhashtable_flush_and_free - detach and discard all current elements
> + * @ht:		the hash table to flush
> + * @free_fn:	callback to release resources of an element, may be %NULL
> + * @arg:	pointer passed to free_fn
> + *
> + * Swaps the bucket table backing @ht for a new, empty table.
> + *
> + * The detached table is then walked and every element found is
> + * unlinked, and, if @free_fn is given, handed to it for release.
> + *
> + * Unlike rhashtable_destroy(), @ht is left fully initialized and may
> + * continue to be used for lookups, insertions, and removals.

[Severity: Low]
Is this kernel-doc accurate?

rhashtable_free() doesn't unlink anything. It walks each bucket, passes
each element to free_fn while it is still chained, and then calls
bucket_table_free().

The rhltable_flush_and_free() kernel-doc in include/linux/rhashtable.h
also describes @hlt as:

 * @hlt:	the hash list table to destroy

That text appears to be copied from rhltable_free_and_destroy(), but this
function keeps the table alive.

As for "may continue to be used", this is what happens while ht->tbl is
NULL:

- __rhashtable_insert_fast() and rhashtable_try_insert() return
  ERR_PTR(-ESTALE). This new errno propagates through
  rhashtable_insert_fast(), rhashtable_lookup_insert_fast(),
  rhashtable_lookup_get_insert_*() and rhltable_insert*(). None of their
  kernel-docs mention it.
- __rhashtable_remove_fast() and rhashtable_replace_fast() return -ENOENT
  for an object that is still linked in the detached table and will later
  be passed to free_fn.
- Lookups return NULL for every key.

Could the doc list which operations fail during the flush and with which
errno? Could it also say that elements are passed to free_fn while they
are still linked?

> + *
> + * This function may sleep, it cannot be called from atomic context or
> + * RCU read-side critical sections.

[ ... ]

> +	/* Detach walkers from the old hash table. */
> +	tbl = old_tbl;
> +	spin_lock(&ht->lock);
> +	do {
> +		tbl->dying = true;
> +		list_for_each_entry(walker, &tbl->walkers, list) {
> +			struct rhashtable_iter *iter = container_of(
> +				walker, struct rhashtable_iter, walker);
> +
> +			walker->tbl = NULL;
> +			iter->end_of_table = true;
> +			iter->p = NULL;
> +		}

[Severity: Low]
Should parked and active walkers get the same result here?

A parked walker is one on tbl->walkers, for example between
rhashtable_walk_stop() and the next start. This loop sets its
end_of_table, so the next rhashtable_walk_start_check() returns 0 and
rhashtable_walk_next() returns NULL. The walk ends without any error and
never visits the new table.

An active walker is one between start and stop.
rhashtable_walk_start_check() already removed it from the list, so this
loop doesn't see it. When it reaches rhashtable_walk_stop(), tbl->dying is
set and only walker.tbl is cleared:

	if (tbl->dying)
		/* This bucket table is being freed, don't re-link it. */
		iter->walker.tbl = NULL;

The next rhashtable_walk_start_check() then reloads ht->tbl and returns
-EAGAIN, as documented for resizes.

A walker entered while ht->tbl is NULL stays at end of table for good,
because rhashtable_walk_enter() does:

	iter->end_of_table = !iter->walker.tbl;

So whether a walk that overlaps a flush ends or rewinds depends on whether
its rhashtable_walk_stop() runs before or after dying is set. A
multi-callback netlink dump, such as the ipset list dump that parks its
walker between callbacks, would end with no -EAGAIN to signal that it was
interrupted.

Could this behavior be made consistent, or documented in the
rhashtable_walk_*() kernel-docs?

> +
> +		tbl = rcu_dereference_raw(tbl->future_tbl);
> +	} while (tbl);
> +	spin_unlock(&ht->lock);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
