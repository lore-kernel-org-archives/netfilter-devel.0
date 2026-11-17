Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911433;
	b=c8YNzuvCFIFzfMhuqLUL12+v/C0MN2jtDSFv703bwrEbxFnSEXOUk/B/YsT6mPGt4FKb
	 ctqLPaGKqZTKKn/KPWiq8JwiSTb7wyYfXs9C/7tb3W5rWU7jDm4dgXKyr0vu0VvTP6JQR
	 4VEhHPLfYMvmGmsQV7Me4fp6/IanM8wOoGRJrAQO3KtNqRkKAHGVif05gy2T2hQBYBht+
	 C5PG3eav//Bz2gD4whUvGIZcTwdaLwRgTLMG0Khc97CJhJvCclL8rNZOdC7F2lBbFXx+J
	 nL37idet/On6aw9BZmHL2uRafN0JYghfS8UoYDDSA4DCBbqeG30Cy9MCZe3+2tPGt2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911433;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=k48PnQTSeezd88Pq7pB7i75rxvt4E2xyTdUkunFqMNQ=;
	b=HHqb5RioRjwqq/47nF20/jfKLIsg9VsES/kT5U/MiisZIENaZqGrK2jyKS5UiMeOPlYx
	 sUjN+udq7LjDrYaIJfq88ISP6suRWpUUB9YNQsVDnw+bfiyoV0vJQ5EmxKM2hWYr8+TLG
	 wZOvNTrRZuy8qdaju8ibBq1O0OjpvbUjz3s9ZO/5L95AOZxIDP0h5EvY3Z3JBNaUYlCfi
	 fxJWQL0UI17RfMx0j5XCH6Tqnrwrl5kmqnR/AEQcP6YaofEOQeG7jbLqrKIC+yae1419O
	 XZ2GZLYNomXZ7ld5Qg9hLD7LJJnBsQhMeHSZbJ0yn3nTRXVm8972B4PwFc7f6PP6XGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=LfbUBhKf;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 31991606A31C;
	Tue, 17 Nov 2026 10:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31991606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=LfbUBhKf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794911428;
	bh=k48PnQTSeezd88Pq7pB7i75rxvt4E2xyTdUkunFqMNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LfbUBhKfI1LcIg6sJSzB5egUNeu2wO7u/Vu4UCdxd6/gEEzcbmL5X6RF3BpbWOAIn
	 mJw0F72KIyG867u+fIQoUNEwCvCibbII2mMcu7ZIqw37V17hrfbsqVoPGbUc1V4mHT
	 6S603YGcP9xQ38UDWzhxQGPQCM5OqYOR4x/bQi9I0LEKoRmO71mq8SBIgKVWmaxCav
	 qIoeVMI9F9Oj0e0fI4iAMU1aJNLKd+aev4hzR02qIQiZv96EGTBFdaAsum0oIfhnTW
	 nW08jZgUFcc/Ts1dyNmSthjz1wciV+XJ3CDBzGoDtSubb588I37/5mSLFwMWtBqNjB
	 ehCexmnuE/Ymw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7F5BB6005B;
	Tue, 17 Nov 2026 11:30:28 +0100 (CET)
Date: Tue, 17 Nov 2026 11:30:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xue Boyang <fuchen.dust@gmail.com>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, phil@nwl.cc, sunyiqixm@gmail.com,
	bsdhenrymartin@gmail.com
Subject: Re: [PATCH nf v4] netfilter: ipset: fix double free on kernel-side
 delete during resize
Message-ID: <avwswXiJh8HUPa5T@chamomile>
References: <20261117101018.523826-1-fuchen.dust@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261117101018.523826-1-fuchen.dust@gmail.com>

On Tue, Nov 17, 2026 at 04:10:18AM -0600, Xue Boyang wrote:
> A kernel-side delete, i.e. one triggered by the SET target while the set
> is being resized, can free an element extension that the resize copy
> still references. The resize copies elements to the new table keeping
> the pointers to the extension data, e.g. to the comment. The delete
> removes the element from the current table and calls
> ip_set_ext_destroy(), releasing the shared extension; when the copy in
> the new table is later deleted or reclaimed by the garbage collector,
> the same rcu_head is queued twice. With CONFIG_DEBUG_OBJECTS_RCU_HEAD
> (and slub_debug=F, which keeps kfree_rcu() off the sheaf fast path):

Did you take a look at this more complete series?

https://lore.kernel.org/netfilter-devel/avn3d1TtvftVLoDc@strlen.de/T/

>   ODEBUG: activate active (active state 1) object type: rcu_head
>   WARNING: lib/debugobjects.c:629 at debug_print_object+0x7b/0x100
>   kvfree_call_rcu(): Double-freed call. rcu_head ffff88810474ce40
>   WARNING: mm/slab_common.c:2041 at kvfree_call_rcu+0x10b/0x140
>   Call Trace:
>    <TASK>
>    debug_object_activate (lib/debugobjects.c:905)
>    kvfree_call_rcu (mm/slab_common.c:2039)
>    hash_ip4_del (net/netfilter/ipset/ip_set_hash_gen.h:1226)
>    hash_ip4_kadt (net/netfilter/ipset/ip_set_hash_ip.c:96)
>    ip_set_del (net/netfilter/ipset/ip_set_core.c:820)
>    set_target_v3 (net/netfilter/xt_set.c:411)
>    ipt_do_table (net/ipv4/netfilter/ip_tables.c:345)
>    nf_hook_slow (net/netfilter/core.c:619)
>    raw_sendmsg (net/ipv4/raw.c:652)
>    __sys_sendto (net/socket.c:2281)
> 
> The double free is reachable from an unprivileged user namespace and
> permits local privilege escalation.
> 
> The existing deferral of kernel-side adds into the per-table backlog
> cannot be extended to deletes soundly: the deferral decision reads
> t->resizing without a common lock with the copy loop, so a destructive
> writer can still pass the check before the copier reaches its bucket;
> the arrival order of deferred operations against operations executed
> directly cannot be reconstructed once the flag is cleared; and the
> forced garbage collection of a full set, the forceadd and the reuse of
> a live entry walk the same check-then-destroy pattern. Previous
> versions of this fix (v1-v3) tried to defer deletes into the backlog;
> review showed those windows cannot be closed within that design, so
> this version removes the backlog altogether.
> 
> Packet-side writers now run directly and synchronize with the resize
> explicitly. Every writer (ADD/DEL/GC) holds a per-set rwlock for
> reading from table selection through its last modification and records
> completion in a per-set sequence counter. The resize copies each
> source region under the source region lock and publishes the new table
> under the write lock only if the sequence counter is unchanged: any
> writer that modified a region after it was copied invalidates the whole
> snapshot. A rejected or incomplete snapshot is discarded wholesale; it
> never owns an extension shared with the current table.
> 
> The two tables no longer share destroyable extension objects: comments
> are cloned privately under the source region lock, and the destination
> slot is marked used only after the clone succeeds.
> 
> Upstream resize shallow-copies comment pointers between the old and new
> tables, while a multi-message dump pins the old table across netlink
> messages without holding RCU continuously between them. After a
> new-table DEL or GC schedules the shared comment for reclamation, a
> later dump message using the pinned old table may access the same
> comment after it has been freed.
> 
> Private cloning removes this shared ownership. This pre-existing UAF
> scenario follows from code analysis; the targeted control test did not
> force the shared comment through the lazy kfree_rcu reclamation
> pipeline, so the upstream UAF itself has not yet been reproduced at
> runtime.
> 
> Expired-but-still-used entries are copied as well, so the new table
> owns every used entry's extension and the regular garbage collector
> reclaims them; this also fixes the pre-existing leak of comment
> extensions of entries dropped by the old copy loop.
> 
> Global prefix bookkeeping (rnets) belongs to the set, not to any single
> table, and is now released only at set destruction. If a future
> destroyable extension is enabled for a set without a private-clone
> rule, the resize fails with -EOPNOTSUPP instead of silently reverting
> to shared ownership. After three consecutive snapshot conflicts the
> resize returns -EBUSY with the current table and all completed
> operations intact: under a sustained packet rate the triggering add
> fails visibly to userspace instead of deferring work unboundedly. This
> is an intentional behavior change.
> 
> Tested on a KASAN + lockdep kernel in a VM. The SET --del-set
> reproducer completed 294 resize-race shots with err=0 and no ODEBUG,
> double-free, KASAN or ipset-related WARNING/BUG report in the post-run
> dmesg scan. The ordering regression test (packet del+add / add+del
> pairs racing continuous resizes) passed 12 rounds with 37 resize
> windows and zero lost or resurrected elements. Bounded fault injection
> at the snapshot bucket allocation, at the comment clone allocation and
> at the second clone (partial-clone cleanup), 30 failures each: every
> failed resize left the hashsize, the memsize accounting and the current
> table untouched, injection-free resizes afterwards converged, and no
> BUG, lockdep warning, ODEBUG or double-free report appeared in dmesg.
> A candidate-side multi-message dump test paused the dump after its
> first batch, published a resized table, deleted 75 of 150 commented
> entries from the new table, waited five seconds, and resumed the
> old-table dump: all 150 entries returned with byte-identical comments
> and no KASAN report. A scoped A/B benchmark in a 2-vCPU KASAN VM using
> netlink operations observed no material throughput regression; peak
> memsize during comment resize was about 4% higher. Under a sustained
> packet writer, 33 resizes returned -EBUSY with the current table
> remaining queryable and no missing final elements; after the writer
> stopped, all 33 operations succeeded on retry, the longest add taking
> 13.5 ms. Compatibility smoke tests passed 34/34 on each of two
> candidate kernel configurations, covering IPv4/IPv6, hash:net
> multi-CIDR resize, forceadd, restore-style bursts, timeout/GC
> accounting, repeated create/destroy, and full dumps.
> 
> Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/netfilter-devel/20261105045210.1179991-1-sunyiqixm@gmail.com/
> Signed-off-by: Xue Boyang <fuchen.dust@gmail.com>
> ---
> 
> Changes in v4, prompted by Yiqi Sun's review of v3
> (https://lore.kernel.org/netfilter-devel/20261105045210.1179991-1-sunyiqixm@gmail.com/)
> and by a self-review of the same family of paths:
> 
> The review and the self-review confirmed that check-then-destroy
> patterns around the resizing flag leave double-free windows that the
> backlog cannot close (a writer passing the flag check before the copier
> reaches its bucket, the forced GC of a full set, forceadd/reuse of a
> live entry) and that the ordering of deferred operations cannot be
> preserved once the flag is cleared. Rather than patching each path, v4
> removes the backlog and the resizing flag entirely and replaces them
> with the validated-snapshot protocol described in the commit message:
> writers run directly under a per-set read lock plus a sequence counter,
> resize publishes only a snapshot whose sequence is unchanged, failed
> snapshots are discarded wholesale, and comment extensions are cloned so
> the two tables never share a destroyable object.
> 
> Consequences worth reviewers' attention:
> 
> - Kernel-side DEL/ADD and GC now execute immediately during resizes;
>   there is no backlog or replay, so the resize protocol does not
>   discard operations from a deferred-operation queue.
> 
> - Resize returns -EBUSY to the triggering userspace add after three
>   consecutive snapshot conflicts under a sustained packet rate. The
>   operation fails visibly instead of being deferred unboundedly;
>   userspace can retry once the rate drops. Under a sustained packet
>   writer, 33 resizes returned -EBUSY with the current table remaining
>   queryable and no missing final elements. After the writer stopped,
>   all 33 operations succeeded on retry; the longest add took 13.5 ms.
> 
> - The resize briefly duplicates every comment extension (GFP_ATOMIC
>   clone) and adds a per-set rwlock plus sequence counter to the packet
>   path. A scoped A/B benchmark in a 2-vCPU KASAN VM using netlink
>   operations observed no material throughput regression. The
>   comment-resize case ranged from 3% slower to 12% faster, while an
>   unaffected TEST control was 14-21% faster, indicating substantial
>   code-layout or VM noise rather than an established speedup. Peak
>   memsize during comment resize was about 4% higher. Production
>   packet-path throughput has not been measured.
> 
>   Compatibility smoke tests passed 34/34 on each of two candidate
>   kernel configurations, covering IPv4/IPv6, hash:net multi-CIDR
>   resize, forceadd, restore-style bursts, timeout/GC accounting,
>   repeated create/destroy, and full dumps.
> 
> - Henry Martin tested v3 (Tested-by, msgid
>   <20261111105833.2060684-1-bsdhenrymartin@gmail.com>): the fix has
>   been reworked since, so his tag is not carried over. Henry, a retest
>   of v4 would be much appreciated.
> 
> Changes in v3
> (https://lore.kernel.org/netfilter-devel/20261026102957.5530-1-fuchen.dust@gmail.com/):
> drop the non-standard "Assisted-by:" trailer which fails checkpatch;
> the AI assistance is documented here instead.
> 
> Changes in v2, addressing the review of v1: defer the kernel-side add
> of an element still present in the current table; replay the backlog on
> all resize failure exits; queue deferred deletes FIFO to preserve the
> arrival order; report -ENOMEM when a deferred delete cannot allocate
> its backlog entry.
> 
> The reproducer and the regression/fault-injection/dump tests are
> available on request. AI coding assistants, including Codex and GLM,
> were used for code analysis, protocol review, test-tool development,
> and test execution. The author reviewed the resulting patch and
> archived test results and takes responsibility for the submission.
> 
>  net/netfilter/ipset/ip_set_hash_gen.h | 309 +++++++++++++-------------
>  1 file changed, 150 insertions(+), 159 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 80ca523f304bb..30f7c0523d911 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -6,6 +6,7 @@
>  
>  #include <linux/rcupdate.h>
>  #include <linux/rcupdate_wait.h>
> +#include <linux/rwlock.h>
>  #include <linux/jhash.h>
>  #include <linux/types.h>
>  #include <linux/seqlock.h>
> @@ -33,9 +34,14 @@
>   * Readers and resizing
>   *
>   * Resizing can be triggered by userspace command only, and those
> - * are serialized by the nfnl mutex. During resizing the set is
> - * read-locked, so the only possible concurrent operations are
> - * the kernel side readers. Those must be protected by proper RCU locking.
> + * are serialized by the nfnl mutex. Packet-path writers and garbage
> + * collection hold resize_lock for reading from table selection through
> + * their last modification. They advance resize_seq before dropping it.
> + * Resize copies each source region under its lock, then takes resize_lock
> + * for writing and publishes only if resize_seq has not changed. A failed
> + * snapshot owns only private extension clones and can be discarded
> + * without replay or touching the source table.
> + * Lockless lookups continue to use RCU.
>   */
>  
>  /* Number of elements to store in an initial array block */
> @@ -45,6 +51,8 @@
>  /* Max muber of elements in the array block when tuned */
>  #define AHASH_MAX_TUNED			64
>  #define AHASH_MAX(h)			((h)->bucketsize)
> +/* Limit snapshot retries under sustained packet-path writes. */
> +#define AHASH_RESIZE_RETRIES		3
>  
>  /* A hash bucket */
>  struct hbucket {
> @@ -76,17 +84,14 @@ struct hbucket {
>  struct htable_gc {
>  	struct delayed_work dwork;
>  	struct ip_set *set;	/* Set the gc belongs to */
> -	spinlock_t lock;	/* Lock to exclude gc and resize */
>  	u32 region;		/* Last gc run position */
>  };
>  
>  /* The hash table: the table size stored here in order to make resizing easy */
>  struct htable {
> -	bool resizing;		/* Mark ongoing resize */
> -	atomic_t uref;		/* References for dumping and gc */
> +	atomic_t uref;		/* Current-table ownership and dump references */
>  	u8 htable_bits;		/* size of hash table == 2^htable_bits */
>  	u32 maxelem;		/* Maxelem per region */
> -	struct list_head ad;	/* Resize add|del backlist */
>  	struct ip_set_region *hregion;	/* Region locks and ext sizes */
>  	struct hbucket __rcu *bucket[]; /* hashtable buckets */
>  };
> @@ -217,6 +222,8 @@ static const union nf_inet_addr zeromask = {};
>  
>  #undef mtype_ahash_destroy
>  #undef mtype_ext_cleanup
> +#undef mtype_ext_clone
> +#undef mtype_ext_clone_supported
>  #undef mtype_add_cidr
>  #undef mtype_del_cidr
>  #undef mtype_del_cidr_all
> @@ -236,7 +243,6 @@ static const union nf_inet_addr zeromask = {};
>  #undef mtype_uref
>  #undef mtype_resize
>  #undef mtype_ext_size
> -#undef mtype_resize_ad
>  #undef mtype_head
>  #undef mtype_list
>  #undef mtype_gc_do
> @@ -265,6 +271,8 @@ static const union nf_inet_addr zeromask = {};
>  
>  #define mtype_ahash_destroy	IPSET_TOKEN(MTYPE, _ahash_destroy)
>  #define mtype_ext_cleanup	IPSET_TOKEN(MTYPE, _ext_cleanup)
> +#define mtype_ext_clone	IPSET_TOKEN(MTYPE, _ext_clone)
> +#define mtype_ext_clone_supported IPSET_TOKEN(MTYPE, _ext_clone_supported)
>  #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
>  #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
>  #define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
> @@ -284,7 +292,6 @@ static const union nf_inet_addr zeromask = {};
>  #define mtype_uref		IPSET_TOKEN(MTYPE, _uref)
>  #define mtype_resize		IPSET_TOKEN(MTYPE, _resize)
>  #define mtype_ext_size		IPSET_TOKEN(MTYPE, _ext_size)
> -#define mtype_resize_ad		IPSET_TOKEN(MTYPE, _resize_ad)
>  #define mtype_head		IPSET_TOKEN(MTYPE, _head)
>  #define mtype_list		IPSET_TOKEN(MTYPE, _list)
>  #define mtype_gc_do		IPSET_TOKEN(MTYPE, _gc_do)
> @@ -315,6 +322,8 @@ struct htype {
>  	struct htable __rcu *table; /* the hash table */
>  	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
>  	struct htable_gc gc;	/* gc workqueue */
> +	rwlock_t resize_lock;	/* Exclude writers while publishing a snapshot */
> +	atomic64_t resize_seq;	/* Completed writer operations */
>  	u32 maxelem;		/* max elements in the hash */
>  	u32 initval;		/* random jhash init value */
>  #ifdef IP_SET_HASH_WITH_MARKMASK
> @@ -331,16 +340,6 @@ struct htype {
>  	struct mtype_elem next; /* temporary storage for uadd */
>  };
>  
> -/* ADD|DEL entries saved during resize */
> -struct mtype_resize_ad {
> -	struct list_head list;
> -	enum ipset_adt ad;	/* ADD|DEL element */
> -	struct mtype_elem d;	/* Element value */
> -	struct ip_set_ext ext;	/* Extensions for ADD */
> -	struct ip_set_ext mext;	/* Target extensions for ADD */
> -	u32 flags;		/* Flags for ADD */
> -};
> -
>  #ifdef IP_SET_HASH_WITH_NETS
>  /**
>   * mtype_add_cidr - Add a CIDR entry to hash table bookkeeping
> @@ -504,6 +503,62 @@ mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
>  			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
>  }
>  
> +/* Fail closed if a future extension adds private allocations without teaching
> + * the resize snapshot how to acquire independent ownership of them.
> + */
> +static bool
> +mtype_ext_clone_supported(const struct ip_set *set)
> +{
> +	enum ip_set_ext_id id;
> +
> +	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
> +		const struct ip_set_ext_type *ext = &ip_set_extensions[id];
> +		u8 type = ext->type & ~IPSET_EXT_DESTROY;
> +
> +		if (!ext->destroy || !(set->extensions & type))
> +			continue;
> +		if (id != IPSET_EXT_ID_COMMENT)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +/* Clone extension allocations so retired tables and the published table do
> + * not share destroyable objects. The caller holds the source region lock.
> + */
> +static int
> +mtype_ext_clone(struct ip_set *set, void *dst, const void *src,
> +		spinlock_t *region_lock)
> +{
> +	const struct ip_set_comment *src_comment;
> +	struct ip_set_comment *dst_comment;
> +	struct ip_set_comment_rcu *comment, *clone;
> +	size_t len;
> +
> +	lockdep_assert_held(region_lock);
> +	if (!SET_WITH_COMMENT(set))
> +		return 0;
> +
> +	src_comment = ext_comment(src, set);
> +	dst_comment = ext_comment(dst, set);
> +	RCU_INIT_POINTER(dst_comment->c, NULL);
> +	comment = rcu_dereference_protected(src_comment->c,
> +					    lockdep_is_held(region_lock));
> +	if (!comment)
> +		return 0;
> +
> +	len = strlen(comment->str) + 1;
> +	clone = kmalloc(sizeof(*clone) + len, GFP_ATOMIC);
> +	if (!clone)
> +		return -ENOMEM;
> +	memcpy(clone->str, comment->str, len);
> +	atomic64_add(sizeof(*clone) + len, &set->ext_size);
> +	RCU_INIT_POINTER(dst_comment->c, clone);
> +
> +	return 0;
> +}
> +
>  /* Flush a hash type of set: destroy all elements */
>  static void
>  mtype_flush(struct ip_set *set)
> @@ -553,9 +608,6 @@ mtype_flush(struct ip_set *set)
>  static void
>  mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
>  {
> -#ifdef IP_SET_HASH_WITH_NETS
> -	struct htype *h = set->data;
> -#endif
>  	struct hbucket *n;
>  	u32 i;
>  
> @@ -569,11 +621,6 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
>  		kfree(n);
>  	}
>  
> -#ifdef IP_SET_HASH_WITH_NETS
> -	if (ext_destroy)
> -		for (i = 0; i < IPSET_NET_COUNT; i++)
> -			kfree(rcu_dereference_raw(h->rnets[i]));
> -#endif
>  	ip_set_free(t->hregion);
>  	ip_set_free(t);
>  }
> @@ -584,13 +631,15 @@ mtype_destroy(struct ip_set *set)
>  {
>  	struct htype *h = set->data;
>  	struct htable *t = (__force struct htable *)h->table;
> -	struct list_head *l, *lt;
> +#ifdef IP_SET_HASH_WITH_NETS
> +	int i;
> +#endif
>  
> -	list_for_each_safe(l, lt, &t->ad) {
> -		list_del(l);
> -		kfree(l);
> -	}
>  	mtype_ahash_destroy(set, t, true);
> +#ifdef IP_SET_HASH_WITH_NETS
> +	for (i = 0; i < IPSET_NET_COUNT; i++)
> +		kfree(rcu_dereference_raw(h->rnets[i]));
> +#endif
>  	kfree(h);
>  
>  	set->data = NULL;
> @@ -694,9 +743,9 @@ mtype_gc(struct work_struct *work)
>  	set = gc->set;
>  	h = set->data;
>  
> +	read_lock_bh(&h->resize_lock);
>  	rcu_read_lock_bh();
>  	t = rcu_dereference_bh(h->table);
> -	atomic_inc(&t->uref);
>  	rcu_read_unlock_bh();
>  	numof_locks = ahash_numof_locks(t->htable_bits);
>  	r = gc->region++;
> @@ -707,15 +756,9 @@ mtype_gc(struct work_struct *work)
>  	if (next_run < HZ/10)
>  		next_run = HZ/10;
>  
> -	spin_lock_bh(&gc->lock);
> -	if (!t->resizing)
> -		mtype_gc_do(set, h, t, r);
> -	spin_unlock_bh(&gc->lock);
> -
> -	if (atomic_dec_and_test(&t->uref) && t->resizing) {
> -		pr_debug("Table destroy after resize by expire: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> -	}
> +	mtype_gc_do(set, h, t, r);
> +	atomic64_inc(&h->resize_seq);
> +	read_unlock_bh(&h->resize_lock);
>  
>  	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
>  
> @@ -737,16 +780,9 @@ mtype_cancel_gc(struct ip_set *set)
>  		disable_delayed_work_sync(&h->gc.dwork);
>  }
>  
> -static int
> -mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> -	  struct ip_set_ext *mext, u32 flags);
> -static int
> -mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> -	  struct ip_set_ext *mext, u32 flags);
> -
>  /* Resize a hash: create a new hash table with doubling the hashsize
> - * and inserting the elements to it. Repeat until we succeed or
> - * fail due to memory pressures.
> + * and inserting the elements to it. Failed snapshots own only private
> + * extension clones. Bound conflicts instead of draining an unbounded queue.
>   */
>  static int
>  mtype_resize(struct ip_set *set, bool retried)
> @@ -762,11 +798,14 @@ mtype_resize(struct ip_set *set, bool retried)
>  	struct mtype_elem *data;
>  	struct mtype_elem *d;
>  	struct hbucket *n, *m;
> -	struct list_head *l, *lt;
> -	struct mtype_resize_ad *x;
>  	u32 i, j, r, nr, key;
> +	u64 seq;
> +	unsigned int conflicts = 0;
>  	int ret;
>  
> +	if (unlikely(!mtype_ext_clone_supported(set)))
> +		return -EOPNOTSUPP;
> +
>  #ifdef IP_SET_HASH_WITH_NETS
>  	tmp = kmalloc(dsize, GFP_KERNEL);
>  	if (!tmp)
> @@ -775,14 +814,15 @@ mtype_resize(struct ip_set *set, bool retried)
>  	orig = ipset_dereference_bh_nfnl(h->table);
>  	htable_bits = orig->htable_bits;
>  
> -retry:
> -	ret = 0;
> +grow:
>  	htable_bits++;
>  	if (!htable_bits)
>  		goto hbwarn;
>  	hsize = htable_size(htable_bits);
>  	if (!hsize)
>  		goto hbwarn;
> +retry:
> +	ret = 0;
>  	t = ip_set_alloc(hsize);
>  	if (!t) {
>  		ret = -ENOMEM;
> @@ -796,23 +836,19 @@ mtype_resize(struct ip_set *set, bool retried)
>  	}
>  	t->htable_bits = htable_bits;
>  	t->maxelem = h->maxelem / ahash_numof_locks(htable_bits);
> -	INIT_LIST_HEAD(&t->ad);
> +	atomic_set(&t->uref, 1);
>  	for (i = 0; i < ahash_numof_locks(htable_bits); i++)
>  		spin_lock_init(&t->hregion[i].lock);
>  
> -	/* There can't be another parallel resizing,
> -	 * but dumping and kernel side add/del are possible
> +	/* A writer records completion before releasing resize_lock. The
> +	 * final write lock waits for in-flight writers, including ones
> +	 * which selected the source table before the first region copy.
>  	 */
> -	orig = ipset_dereference_bh_nfnl(h->table);
> -	atomic_inc(&orig->uref);
> -	spin_lock_bh(&h->gc.lock);
> -	orig->resizing = true;
> -	spin_unlock_bh(&h->gc.lock);
> +	seq = atomic64_read_acquire(&h->resize_seq);
>  	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
>  		 set->name, orig->htable_bits, htable_bits, orig);
>  	for (r = 0; r < ahash_numof_locks(orig->htable_bits); r++) {
> -		/* Expire may replace a hbucket with another one */
> -		rcu_read_lock_bh();
> +		spin_lock_bh(&orig->hregion[r].lock);
>  		for (i = ahash_bucket_start(r, orig->htable_bits);
>  		     i < ahash_bucket_end(r, orig->htable_bits); i++) {
>  			n = __ipset_dereference(hbucket(orig, i));
> @@ -823,8 +859,10 @@ mtype_resize(struct ip_set *set, bool retried)
>  				if (!test_bit_acquire(j, n->used))
>  					continue;
>  				data = ahash_data(n, j, dsize);
> -				if (SET_ELEM_EXPIRED(set, data))
> -					continue;
> +				/* Keep expired entries too: the new table takes
> +				 * ownership of every used entry's extensions.
> +				 * GC can reclaim them after publication.
> +				 */
>  #ifdef IP_SET_HASH_WITH_NETS
>  				/* We have readers running parallel with us,
>  				 * so the live data cannot be modified.
> @@ -877,6 +915,10 @@ mtype_resize(struct ip_set *set, bool retried)
>  				}
>  				d = ahash_data(m, m->pos, dsize);
>  				memcpy(d, data, dsize);
> +				ret = mtype_ext_clone(set, d, data,
> +						      &orig->hregion[r].lock);
> +				if (ret < 0)
> +					goto cleanup;
>  				set_bit(m->pos++, m->used);
>  				t->hregion[nr].elements++;
>  #ifdef IP_SET_HASH_WITH_NETS
> @@ -884,36 +926,35 @@ mtype_resize(struct ip_set *set, bool retried)
>  #endif
>  			}
>  		}
> -		rcu_read_unlock_bh();
> +		spin_unlock_bh(&orig->hregion[r].lock);
> +		cond_resched();
>  	}
>  
> -	/* There can't be any other writer. */
> -	rcu_assign_pointer(h->table, t);
> -
> -	/* Give time to other readers of the set */
> -	synchronize_rcu();
> -
> -	pr_debug("set %s resized from %u (%p) to %u (%p)\n", set->name,
> -		 orig->htable_bits, orig, t->htable_bits, t);
> -	/* Add/delete elements processed by the SET target during resize.
> -	 * Kernel-side add cannot trigger a resize and userspace actions
> -	 * are serialized by the mutex.
> +	/* No source writer may finish between validation and publication.
> +	 * Writers selecting a table after this point select the new one.
>  	 */
> -	list_for_each_safe(l, lt, &orig->ad) {
> -		x = list_entry(l, struct mtype_resize_ad, list);
> -		if (x->ad == IPSET_ADD) {
> -			mtype_add(set, &x->d, &x->ext, &x->mext, x->flags);
> -		} else {
> -			mtype_del(set, &x->d, NULL, NULL, 0);
> +	write_lock_bh(&h->resize_lock);
> +	if (atomic64_read(&h->resize_seq) != seq) {
> +		write_unlock_bh(&h->resize_lock);
> +		mtype_ahash_destroy(set, t, true);
> +		if (++conflicts < AHASH_RESIZE_RETRIES) {
> +			cond_resched();
> +			goto retry;
>  		}
> -		list_del(l);
> -		kfree(l);
> -	}
> -	/* If there's nobody else using the table, destroy it */
> -	if (atomic_dec_and_test(&orig->uref)) {
> -		pr_debug("Table destroy by resize %p\n", orig);
> -		mtype_ahash_destroy(set, orig, false);
> +		ret = -EBUSY;
> +		goto out;
>  	}
> +	rcu_assign_pointer(h->table, t);
> +	write_unlock_bh(&h->resize_lock);
> +
> +	/* Readers may still be using the old buckets. Drop its current-table
> +	 * ownership only after they finish; dumps hold separate references.
> +	 * Extensions are private to each table, so the last reference destroys
> +	 * both retired buckets and their original extension allocations.
> +	 */
> +	synchronize_rcu();
> +	if (atomic_dec_and_test(&orig->uref))
> +		mtype_ahash_destroy(set, orig, true);
>  
>  out:
>  #ifdef IP_SET_HASH_WITH_NETS
> @@ -922,25 +963,13 @@ mtype_resize(struct ip_set *set, bool retried)
>  	return ret;
>  
>  cleanup:
> -	rcu_read_unlock_bh();
> -	spin_lock_bh(&h->gc.lock);
> -	orig->resizing = false;
> -	spin_unlock_bh(&h->gc.lock);
> -	/* Make sure parallel readers see that orig->resizing is false
> -	 * before we decrement uref */
> -	synchronize_rcu();
> -	atomic_dec(&orig->uref);
> -	mtype_ahash_destroy(set, t, false);
> -	if (ret == -EAGAIN)
> -		goto retry;
> -
> -	/* Cleanup the backlog of ADD/DEL elements */
> -	spin_lock_bh(&set->lock);
> -	list_for_each_safe(l, lt, &orig->ad) {
> -		list_del(l);
> -		kfree(l);
> +	spin_unlock_bh(&orig->hregion[r].lock);
> +	/* The draft owns only its cloned extensions. */
> +	mtype_ahash_destroy(set, t, true);
> +	if (ret == -EAGAIN) {
> +		cond_resched();
> +		goto grow;
>  	}
> -	spin_unlock_bh(&set->lock);
>  	goto out;
>  
>  hbwarn:
> @@ -999,11 +1028,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	u32 r, key, multi = 0, elements, maxelem;
>  	u8 npos = 0;
>  
> +	read_lock_bh(&h->resize_lock);
>  	rcu_read_lock_bh();
>  	t = rcu_dereference_bh(h->table);
>  	key = HKEY(value, h->initval, t->htable_bits);
>  	r = ahash_region(key);
> -	atomic_inc(&t->uref);
>  	rcu_read_unlock_bh();
>  	elements = t->hregion[r].elements;
>  	maxelem = t->maxelem;
> @@ -1139,23 +1168,6 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	ret = 0;
>  resize:
>  	spin_unlock_bh(&t->hregion[r].lock);
> -	if (t->resizing && ext && ext->target) {
> -		/* Resize is in process and kernel side add, save values */
> -		struct mtype_resize_ad *x;
> -
> -		x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
> -		if (!x)
> -			/* Don't bother */
> -			goto out;
> -		x->ad = IPSET_ADD;
> -		memcpy(&x->d, value, sizeof(struct mtype_elem));
> -		memcpy(&x->ext, ext, sizeof(struct ip_set_ext));
> -		memcpy(&x->mext, mext, sizeof(struct ip_set_ext));
> -		x->flags = flags;
> -		spin_lock_bh(&set->lock);
> -		list_add_tail(&x->list, &t->ad);
> -		spin_unlock_bh(&set->lock);
> -	}
>  	goto out;
>  
>  set_full:
> @@ -1166,10 +1178,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  unlock:
>  	spin_unlock_bh(&t->hregion[r].lock);
>  out:
> -	if (atomic_dec_and_test(&t->uref) && t->resizing) {
> -		pr_debug("Table destroy after resize by add: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> -	}
> +	atomic64_inc(&h->resize_seq);
> +	read_unlock_bh(&h->resize_lock);
>  	return ret;
>  }
>  
> @@ -1184,7 +1194,6 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	const struct mtype_elem *d = value;
>  	struct mtype_elem *data;
>  	struct hbucket *n;
> -	struct mtype_resize_ad *x = NULL;
>  	int i, j, k, r, ret = -IPSET_ERR_EXIST;
>  	u32 key, multi = 0;
>  	size_t dsize = set->dsize;
> @@ -1193,11 +1202,11 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	/* Userspace add and resize is excluded by the mutex.
>  	 * Kernespace add does not trigger resize.
>  	 */
> +	read_lock_bh(&h->resize_lock);
>  	rcu_read_lock_bh();
>  	t = rcu_dereference_bh(h->table);
>  	key = HKEY(value, h->initval, t->htable_bits);
>  	r = ahash_region(key);
> -	atomic_inc(&t->uref);
>  	rcu_read_unlock_bh();
>  
>  	spin_lock_bh(&t->hregion[r].lock);
> @@ -1225,18 +1234,6 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  		mtype_del_cidr_all(set, h, d);
>  		ip_set_ext_destroy(set, data);
>  
> -		if (t->resizing && ext && ext->target) {
> -			/* Resize is in process and kernel side del,
> -			 * save values
> -			 */
> -			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
> -			if (x) {
> -				x->ad = IPSET_DEL;
> -				memcpy(&x->d, value,
> -				       sizeof(struct mtype_elem));
> -				x->flags = flags;
> -			}
> -		}
>  		for (; i < pos; i++) {
>  			if (!test_bit(i, n->used))
>  				k++;
> @@ -1271,15 +1268,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  
>  out:
>  	spin_unlock_bh(&t->hregion[r].lock);
> -	if (x) {
> -		spin_lock_bh(&set->lock);
> -		list_add(&x->list, &t->ad);
> -		spin_unlock_bh(&set->lock);
> -	}
> -	if (atomic_dec_and_test(&t->uref) && t->resizing) {
> -		pr_debug("Table destroy after resize by del: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> -	}
> +	atomic64_inc(&h->resize_seq);
> +	read_unlock_bh(&h->resize_lock);
>  	return ret;
>  }
>  
> @@ -1531,10 +1521,10 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
>  		rcu_read_unlock_bh();
>  	} else if (cb->args[IPSET_CB_PRIVATE]) {
>  		t = (struct htable *)cb->args[IPSET_CB_PRIVATE];
> -		if (atomic_dec_and_test(&t->uref) && t->resizing) {
> +		if (atomic_dec_and_test(&t->uref)) {
>  			pr_debug("Table destroy after resize "
>  				 " by dump: %p\n", t);
> -			mtype_ahash_destroy(set, t, false);
> +			mtype_ahash_destroy(set, t, true);
>  		}
>  		cb->args[IPSET_CB_PRIVATE] = 0;
>  	}
> @@ -1785,7 +1775,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>  	}
>  #endif
>  	h->gc.set = set;
> -	spin_lock_init(&h->gc.lock);
> +	rwlock_init(&h->resize_lock);
> +	atomic64_set(&h->resize_seq, 0);
>  	for (i = 0; i < ahash_numof_locks(hbits); i++)
>  		spin_lock_init(&t->hregion[i].lock);
>  	h->maxelem = maxelem;
> @@ -1812,7 +1803,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>  	}
>  	t->htable_bits = hbits;
>  	t->maxelem = h->maxelem / ahash_numof_locks(hbits);
> -	INIT_LIST_HEAD(&t->ad);
> +	atomic_set(&t->uref, 1);
>  	RCU_INIT_POINTER(h->table, t);
>  	set->data = h;
>  
> -- 
> 2.53.0
> 
