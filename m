Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9968E423E94
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 13:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208182; cv=none; b=D13ZMw32VLeqjJWHr6p1sghNLvlwkXZGVeH2P0wHxai0H8yx+gbyTyBI0iJrjAIdaUB+OXA13GGTfiKKYFglK8DkOd8FIbNVJxB3/RqyF6HUvEa3jSIXDHBSXoGSsZMT0qVVZ5Nbsohxv8aCH3tPBm5hALNJyJyRBlsm3bQU5Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208182; c=relaxed/simple;
	bh=70WzE6HXxX8gA9AnMsAiGlgjWqynHImJY38KTC4kuq8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dybWsMyqQkopB/0ocDpzBwZ14j8lycivnh0B8nkBI3E7G4S+UQKdHWg6UVYHobVh5Pzzp9iuRF/YaY7Rs7hHweJ62ES3cebK0ieU2tf3vW5ieGoMvDYzlBS40MJ5grr8ePtlVQcVy+q84ODOVJ2Cp/bcPUIDLkHKYPkM1zq5OWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=nEpm7GPY; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="nEpm7GPY"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h1DHY65KNzGFDCH;
	Thu, 16 Jul 2026 15:22:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1784208167; x=1786022568; bh=H8XCR+POZf
	4Q62pbvWNgfmpq0GXI4wZeLcOJLwiSmkg=; b=nEpm7GPYdHOurijTwNoWUdizlu
	xiHOLAd6uNNvQbyPg1X2YzBotohwuH+RgCcTUivbILerlFTMMgu/7EROdezRsCWA
	VR3A/25KmyEkx6DYwCTnUGRMvroj3DnYRB9d/1jkAP3UoePm3CkE4s9hDBlMS9Ok
	WidJwn3OlEc7K6mq8=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id lLt7Fit1LYY3; Thu, 16 Jul 2026 15:22:47 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h1DHW6BgXzGFDCG;
	Thu, 16 Jul 2026 15:22:47 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id C66B934316E; Thu, 16 Jul 2026 15:22:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id C41B934316D;
	Thu, 16 Jul 2026 15:22:47 +0200 (CEST)
Date: Thu, 16 Jul 2026 15:22:47 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 08/12] netfilter: ipset: replace internal
 hash table with rhashtable
In-Reply-To: <20260714131828.10685-9-fw@strlen.de>
Message-ID: <2d64a463-286c-f640-b57c-97eb5a650143@blackhole.kfki.hu>
References: <20260714131828.10685-1-fw@strlen.de> <20260714131828.10685-9-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Tue, 14 Jul 2026, Florian Westphal wrote:

> Not yet ready, too many tests in ipset fail with this,
> its possible those are false-positives.
>
> - existing ip_set_init_comment() alters set->ext_size, I don't
>   see how region locking protects this.

That was forgotten so it is not protected...

>   This adds full set->lock serialization, meaning no parallel
>   insertion for elements with comment extension.

The comment extension is restricted to add from userspace which is 
serialized by the mutex anyway.

> - FORCEADD is removed to reduce diff size, its added back later
>   in the series.
>
> Sending this early to gather more feedback.
>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/netfilter/ipset/ip_set_hash_gen.h | 1252 +++++--------------------
> 1 file changed, 259 insertions(+), 993 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 8f5f15fdf61b..e4d26f064c48 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -5,7 +5,6 @@
> #define _IP_SET_HASH_GEN_H
>
> #include <linux/rcupdate.h>
> -#include <linux/rcupdate_wait.h>
> #include <linux/jhash.h>
> #include <linux/types.h>
> #include <linux/rhashtable.h>
> @@ -17,84 +16,15 @@
> #define ipset_dereference_nfnl(p)	\
> 	rcu_dereference_protected(p,	\
> 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
> -#define ipset_dereference_set(p, set) 	\
> -	rcu_dereference_protected(p,	\
> -		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET) || \
> -		lockdep_is_held(&(set)->lock))
> #define ipset_dereference_bh_nfnl(p)	\
> 	rcu_dereference_bh_check(p, 	\
> 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
>
> -/* Hashing which uses arrays to resolve clashing. The hash table is resized
> - * (doubled) when searching becomes too long.
> - * Internally jhash is used with the assumption that the size of the
> - * stored data is a multiple of sizeof(u32).
> - *
> - * Readers and resizing
> - *
> - * Resizing can be triggered by userspace command only, and those
> - * are serialized by the nfnl mutex. During resizing the set is
> - * read-locked, so the only possible concurrent operations are
> - * the kernel side readers. Those must be protected by proper RCU locking.
> - */
> -
> -/* Number of elements to store in an initial array block */
> -#define AHASH_INIT_SIZE			2
> -/* Max number of elements to store in an array block */
> -#define AHASH_MAX_SIZE			(6 * AHASH_INIT_SIZE)
> -/* Max muber of elements in the array block when tuned */
> -#define AHASH_MAX_TUNED			64
> -#define AHASH_MAX(h)			((h)->bucketsize)
> -
> -/* A hash bucket */
> -struct hbucket {
> -	struct rcu_head rcu;	/* for call_rcu */
> -	/* Which positions are used in the array */
> -	DECLARE_BITMAP(used, AHASH_MAX_TUNED);
> -	u8 size;		/* size of the array */
> -	u8 pos;			/* position of the first free entry */
> -	unsigned char value[]	/* the array of the values */
> -		__aligned(__alignof__(u64));
> -};
> -
> -/* Region size for locking == 2^HTABLE_REGION_BITS */
> -#define HTABLE_REGION_BITS	10
> -#define ahash_numof_locks(htable_bits)		\
> -	((htable_bits) < HTABLE_REGION_BITS ? 1	\
> -		: jhash_size((htable_bits) - HTABLE_REGION_BITS))
> -#define ahash_sizeof_regions(htable_bits)		\
> -	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
> -#define ahash_region(n)		\
> -	((n) / jhash_size(HTABLE_REGION_BITS))
> -#define ahash_bucket_start(h,  htable_bits)	\
> -	((htable_bits) < HTABLE_REGION_BITS ? 0	\
> -		: (h) * jhash_size(HTABLE_REGION_BITS))
> -#define ahash_bucket_end(h,  htable_bits)	\
> -	((htable_bits) < HTABLE_REGION_BITS ? jhash_size(htable_bits)	\
> -		: ((h) + 1) * jhash_size(HTABLE_REGION_BITS))
> -
> struct htable_gc {
> 	struct delayed_work dwork;
> 	struct ip_set *set;	/* Set the gc belongs to */
> -	spinlock_t lock;	/* Lock to exclude gc and resize */
> -	u32 region;		/* Last gc run position */
> -};
> -
> -/* The hash table: the table size stored here in order to make resizing easy */
> -struct htable {
> -	bool resizing;		/* Mark ongoing resize */
> -	atomic_t uref;		/* References for dumping and gc */
> -	u8 htable_bits;		/* size of hash table == 2^htable_bits */
> -	u32 maxelem;		/* Maxelem per region */
> -	struct list_head ad;	/* Resize add|del backlist */
> -	struct ip_set_region *hregion;	/* Region locks and ext sizes */
> -	struct hbucket __rcu *bucket[]; /* hashtable buckets */
> };
>
> -#define hbucket(h, i)		((h)->bucket[i])
> -#define ext_size(n, dsize)	\
> -	(sizeof(struct hbucket) + (n) * (dsize))
> -
> #ifndef IPSET_NET_COUNT
> #define IPSET_NET_COUNT		1
> #endif
> @@ -112,23 +42,6 @@ struct net_prefixes {
> 		__aligned(__alignof__(u64));
> };
>
> -/* Compute the hash table size */
> -static size_t
> -htable_size(u8 hbits)
> -{
> -	size_t hsize;
> -
> -	/* We must fit both into u32 in jhash and INT_MAX in kvmalloc_node() */
> -	if (hbits > 31)
> -		return 0;
> -	hsize = jhash_size(hbits);
> -	if ((INT_MAX - sizeof(struct htable)) / sizeof(struct hbucket *)
> -	    < hsize)
> -		return 0;
> -
> -	return hsize * sizeof(struct hbucket *) + sizeof(struct htable);
> -}
> -
> #ifdef IP_SET_HASH_WITH_NETS
> #if IPSET_NET_COUNT > 1
> #define __CIDR(cidr, i)		(cidr[i])
> @@ -180,7 +93,6 @@ static const union nf_inet_addr zeromask = {};
>
> /* Family dependent templates */
>
> -#undef ahash_data
> #undef mtype_data_equal
> #undef mtype_do_data_match
> #undef mtype_data_set_flags
> @@ -191,8 +103,6 @@ static const union nf_inet_addr zeromask = {};
> #undef mtype_data_next
> #undef mtype_elem
>
> -#undef mtype_ahash_destroy
> -#undef mtype_ext_cleanup
> #undef mtype_rht_elem
> #undef mtype_rht_hashfn
> #undef mtype_rht_obj_hashfn
> @@ -203,7 +113,6 @@ static const union nf_inet_addr zeromask = {};
> #undef mtype_del_cidr
> #undef mtype_del_cidr_all
> #undef mtype_flush_elem
> -#undef mtype_ahash_memsize
> #undef mtype_flush
> #undef mtype_destroy
> #undef mtype_same_set
> @@ -217,12 +126,9 @@ static const union nf_inet_addr zeromask = {};
> #undef mtype_test_cidrs
> #undef mtype_test
> #undef mtype_uref
> -#undef mtype_resize
> #undef mtype_ext_size
> -#undef mtype_resize_ad
> #undef mtype_head
> #undef mtype_list
> -#undef mtype_gc_do
> #undef mtype_gc
> #undef mtype_gc_init
> #undef mtype_cancel_gc
> @@ -230,7 +136,7 @@ static const union nf_inet_addr zeromask = {};
> #undef mtype_data_match
>
> #undef htype
> -#undef HKEY
> +#undef HKEY_DATALEN
>
> #define mtype_data_equal	IPSET_TOKEN(MTYPE, _data_equal)
> #ifdef IP_SET_HASH_WITH_NETS
> @@ -246,9 +152,6 @@ static const union nf_inet_addr zeromask = {};
> #define mtype_data_next		IPSET_TOKEN(MTYPE, _data_next)
> #define mtype_elem		IPSET_TOKEN(MTYPE, _elem)
>
> -#define mtype_ahash_destroy	IPSET_TOKEN(MTYPE, _ahash_destroy)
> -#define mtype_ext_cleanup	IPSET_TOKEN(MTYPE, _ext_cleanup)
> -
> #define mtype_rht_elem		IPSET_TOKEN(MTYPE, _rht_elem)
> #define mtype_rht_hashfn	IPSET_TOKEN(MTYPE, _rht_hashfn)
> #define mtype_rht_obj_hashfn	IPSET_TOKEN(MTYPE, _rht_obj_hashfn)
> @@ -259,7 +162,6 @@ static const union nf_inet_addr zeromask = {};
> #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
> #define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
> #define mtype_flush_elem	IPSET_TOKEN(MTYPE, _flush_elem)
> -#define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
> #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
> #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
> #define mtype_same_set		IPSET_TOKEN(MTYPE, _same_set)
> @@ -273,12 +175,9 @@ static const union nf_inet_addr zeromask = {};
> #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
> #define mtype_test		IPSET_TOKEN(MTYPE, _test)
> #define mtype_uref		IPSET_TOKEN(MTYPE, _uref)
> -#define mtype_resize		IPSET_TOKEN(MTYPE, _resize)
> #define mtype_ext_size		IPSET_TOKEN(MTYPE, _ext_size)
> -#define mtype_resize_ad		IPSET_TOKEN(MTYPE, _resize_ad)
> #define mtype_head		IPSET_TOKEN(MTYPE, _head)
> #define mtype_list		IPSET_TOKEN(MTYPE, _list)
> -#define mtype_gc_do		IPSET_TOKEN(MTYPE, _gc_do)
> #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
> #define mtype_gc_init		IPSET_TOKEN(MTYPE, _gc_init)
> #define mtype_cancel_gc		IPSET_TOKEN(MTYPE, _cancel_gc)
> @@ -345,28 +244,15 @@ static const struct rhashtable_params mtype_rht_params = {
> 	.automatic_shrinking = true,
> };
>
> -#define HKEY(data, initval, htable_bits)			\
> -({								\
> -	const u32 *__k = (const u32 *)data;			\
> -	u32 __l = HKEY_DATALEN / sizeof(u32);			\
> -								\
> -	BUILD_BUG_ON(HKEY_DATALEN % sizeof(u32) != 0);		\
> -								\
> -	jhash2(__k, __l, initval) & jhash_mask(htable_bits);	\
> -})
> -
> -/* The generic hash structure */
> +/* The hash set type */
> struct htype {
> -	struct htable __rcu *table; /* the hash table */
> 	struct rhashtable ht;	/* the hash table */
> +	u32 maxelem;		/* max element limit (user-requested) */
> 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
> 	struct htable_gc gc;	/* gc workqueue */
> -	u32 maxelem;		/* max elements in the hash */
> -	u32 initval;		/* random jhash init value */

Please do not remove initval: the sole reason to keep it is to maintain 
full userspace compatibility. The "ipset" tool supports to specify initval 
and when listing/saving a set, initval is included in the output. Already
existing setups may specify the value and we must be able to return it.

> #ifdef IP_SET_HASH_WITH_MARKMASK
> 	u32 markmask;		/* markmask value for mark mask to store */
> #endif
> -	u8 bucketsize;		/* max elements in an array block */
> #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
> 	u8 netmask;		/* netmask value for subnets to store */
> 	union nf_inet_addr bitmask;	/* stores bitmask */
> @@ -377,16 +263,6 @@ struct htype {
> 	struct mtype_elem next; /* temporary storage for uadd */
> };
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
> #ifdef IP_SET_HASH_WITH_NETS
> /* Network cidr size book keeping when the hash stores different
>  * sized networks. cidr == real cidr + 1 to support /0.
> @@ -505,105 +381,34 @@ mtype_flush_elem(void *ptr, void *arg)
> 	ip_set_ext_destroy(set, &e->elem);
> 	kfree_rcu(e, rcu);
> }
> -/* Calculate the actual memory size of the set data */
> -static size_t
> -mtype_ahash_memsize(const struct htype *h, const struct htable *t)
> -{
> -	return sizeof(*h) + sizeof(*t) + ahash_sizeof_regions(t->htable_bits);
> -}
> -
> -/* Get the ith element from the array block n */
> -#define ahash_data(n, i, dsize)	\
> -	((struct mtype_elem *)((n)->value + ((i) * (dsize))))
> -
> -static void
> -mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
> -{
> -	int i;
> -	u8 pos = smp_load_acquire(&n->pos);
> -
> -	for (i = 0; i < pos; i++)
> -		if (test_bit(i, n->used))
> -			ip_set_ext_destroy_slow(set, ahash_data(n, i, set->dsize));
> -}
>
> /* Flush a hash type of set: destroy all elements */
> static void
> mtype_flush(struct ip_set *set)
> {
> 	struct htype *h = set->data;
> -#ifdef IP_SET_HASH_WITH_NETS
> -	struct net_prefixes *nets, *tmp;
> -#endif
> -	struct htable *t;
> -	struct hbucket *n;
> -	u32 r, i;
> +	struct rhashtable_iter hti;
> +	struct mtype_rht_elem *e;
>
> -	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
> -	rhashtable_init(&h->ht, &mtype_rht_params);
> -
> -	t = ipset_dereference_nfnl(h->table);
> -	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
> -		spin_lock_bh(&t->hregion[r].lock);
> -		for (i = ahash_bucket_start(r, t->htable_bits);
> -		     i < ahash_bucket_end(r, t->htable_bits); i++) {
> -			n = __ipset_dereference(hbucket(t, i));
> -			if (!n)
> +	rhashtable_walk_enter(&h->ht, &hti);
> +	rhashtable_walk_start(&hti);
> +
> +	while ((e = rhashtable_walk_next(&hti))) {
> +		if (IS_ERR(e)) {
> +			if (PTR_ERR(e) == -EAGAIN)
> 				continue;
> -			if (set->extensions & IPSET_EXT_DESTROY)
> -				mtype_ext_cleanup(set, n);
> -			/* FIXME: use slab cache */
> -			rcu_assign_pointer(hbucket(t, i), NULL);
> -			kfree_rcu(n, rcu);
> -		}
> -		t->hregion[r].ext_size = 0;
> -		t->hregion[r].elements = 0;
> -		spin_unlock_bh(&t->hregion[r].lock);
> -	}
> -#ifdef IP_SET_HASH_WITH_NETS
> -	for (i = 0; i < IPSET_NET_COUNT; i++) {
> -		nets = ipset_dereference_nfnl(h->rnets[i]);
> -		tmp = kzalloc(sizeof(struct net_prefixes), GFP_ATOMIC);
> -		if (!tmp) {
> -			u8 j;
> -
> -			for (j = 0; j < nets->len; j++)
> -				nets->nets[j].count = 0;
> -		} else {
> -			rcu_assign_pointer(h->rnets[i], tmp);
> -			kfree_rcu(nets, rcu);
> +			break;
> 		}
> -	}
> -#endif
> -}
>
> -/* Destroy the hashtable part of the set */
> -static void
> -mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
> -{
> -#ifdef IP_SET_HASH_WITH_NETS
> -	struct htype *h = set->data;
> -#endif
> -	struct hbucket *n;
> -	u32 i;
> +		if (rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params))
> +			continue; /* Concurrent delete? skip */
>
> -	for (i = 0; i < jhash_size(t->htable_bits); i++) {
> -		n = (__force struct hbucket *)hbucket(t, i);
> -		if (!n)
> -			continue;
> -		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
> -			mtype_ext_cleanup(set, n);
> -		/* FIXME: use slab cache */
> -		kfree(n);
> +		mtype_del_cidr_all(set, h, &e->elem);
> +		ip_set_ext_destroy_slow(set, &e->elem);
> +		kfree_rcu(e, rcu);
> 	}
> -
> -#ifdef IP_SET_HASH_WITH_NETS
> -	if (ext_destroy)
> -		for (i = 0; i < IPSET_NET_COUNT; i++)
> -			kfree(h->rnets[i]);
> -#endif
> -	ip_set_free(t->hregion);
> -	ip_set_free(t);
> +	rhashtable_walk_stop(&hti);
> +	rhashtable_walk_exit(&hti);
> }
>
> /* Destroy a hash type of set */
> @@ -611,16 +416,16 @@ static void
> mtype_destroy(struct ip_set *set)
> {
> 	struct htype *h = set->data;
> -	struct htable *t = (__force struct htable *)h->table;
> -	struct list_head *l, *lt;
> +#ifdef IP_SET_HASH_WITH_NETS
> +	u32 i;
> +#endif
>
> 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
>
> -	list_for_each_safe(l, lt, &t->ad) {
> -		list_del(l);
> -		kfree(l);
> -	}
> -	mtype_ahash_destroy(set, t, true);
> +#ifdef IP_SET_HASH_WITH_NETS
> +	for (i = 0; i < IPSET_NET_COUNT; i++)
> +		kfree(h->rnets[i]);
> +#endif
> 	kfree(h);
>
> 	set->data = NULL;
> @@ -632,7 +437,6 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
> 	const struct htype *x = a->data;
> 	const struct htype *y = b->data;
>
> -	/* Resizing changes htable_bits, so we ignore it */
> 	return x->maxelem == y->maxelem &&
> 	       a->timeout == b->timeout &&
> #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
> @@ -644,111 +448,45 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
> 	       a->extensions == b->extensions;
> }
>
> -static void
> -mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
> -{
> -	struct hbucket *n, *tmp;
> -	struct mtype_elem *data;
> -	u32 i, j, d;
> -	size_t dsize = set->dsize;
> -	u8 pos, htable_bits = t->htable_bits;
> -
> -	spin_lock_bh(&t->hregion[r].lock);
> -	for (i = ahash_bucket_start(r, htable_bits);
> -	     i < ahash_bucket_end(r, htable_bits); i++) {
> -		n = __ipset_dereference(hbucket(t, i));
> -		if (!n)
> -			continue;
> -		pos = smp_load_acquire(&n->pos);
> -		for (j = 0, d = 0; j < pos; j++) {
> -			if (!test_bit(j, n->used)) {
> -				d++;
> -				continue;
> -			}
> -			data = ahash_data(n, j, dsize);
> -			if (!ip_set_timeout_expired(ext_timeout(data, set)))
> -				continue;
> -			pr_debug("expired %u/%u\n", i, j);
> -			clear_bit(j, n->used);
> -			smp_mb__after_atomic();
> -			mtype_del_cidr_all(set, h, data);
> -			t->hregion[r].elements--;
> -			ip_set_ext_destroy_slow(set, data);
> -			d++;
> -		}
> -		if (d >= AHASH_INIT_SIZE) {
> -			if (d >= n->size) {
> -				t->hregion[r].ext_size -=
> -					ext_size(n->size, dsize);
> -				rcu_assign_pointer(hbucket(t, i), NULL);
> -				kfree_rcu(n, rcu);
> -				continue;
> -			}
> -			tmp = kzalloc(sizeof(*tmp) +
> -				(n->size - AHASH_INIT_SIZE) * dsize,
> -				GFP_ATOMIC);
> -			if (!tmp)
> -				/* Still try to delete expired elements. */
> -				continue;
> -			tmp->size = n->size - AHASH_INIT_SIZE;
> -			for (j = 0, d = 0; j < pos; j++) {
> -				if (!test_bit(j, n->used))
> -					continue;
> -				data = ahash_data(n, j, dsize);
> -				memcpy(tmp->value + d * dsize,
> -				       data, dsize);
> -				set_bit(d, tmp->used);
> -				d++;
> -			}
> -			tmp->pos = d;
> -			t->hregion[r].ext_size -=
> -				ext_size(AHASH_INIT_SIZE, dsize);
> -			rcu_assign_pointer(hbucket(t, i), tmp);
> -			kfree_rcu(n, rcu);
> -		}
> -	}
> -	spin_unlock_bh(&t->hregion[r].lock);
> -}
> -
> static void
> mtype_gc(struct work_struct *work)
> {
> 	struct htable_gc *gc;
> 	struct ip_set *set;
> 	struct htype *h;
> -	struct htable *t;
> -	u32 r, numof_locks;
> +	struct rhashtable_iter hti;
> +	struct mtype_rht_elem *e;
> 	unsigned int next_run;
>
> 	gc = container_of(work, struct htable_gc, dwork.work);
> 	set = gc->set;
> 	h = set->data;
>
> -	rcu_read_lock_bh();
> -	t = rcu_dereference_bh(h->table);
> -	atomic_inc(&t->uref);
> -	rcu_read_unlock_bh();
> -	numof_locks = ahash_numof_locks(t->htable_bits);
> -	r = gc->region++;
> -	if (r >= numof_locks) {
> -		r = gc->region = 0;
> -	}
> -	next_run = (IPSET_GC_PERIOD(set->timeout) * HZ) / numof_locks;
> -	if (next_run < HZ/10)
> -		next_run = HZ/10;
> -
> -	spin_lock_bh(&gc->lock);
> -	if (!t->resizing)
> -		mtype_gc_do(set, h, t, r);
> -	spin_unlock_bh(&gc->lock);
> -
> -	if (atomic_dec_and_test(&t->uref) && t->resizing) {
> -		pr_debug("Table destroy after resize by expire: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> +	next_run = IPSET_GC_PERIOD(set->timeout) * HZ;
> +	if (next_run < HZ)
> +		next_run = HZ;
> +
> +	rhashtable_walk_enter(&h->ht, &hti);
> +	rhashtable_walk_start(&hti);
> +	while ((e = rhashtable_walk_next(&hti))) {
> +		if (IS_ERR(e)) {
> +			if (PTR_ERR(e) == -EAGAIN)
> +				continue;
> +			break;
> +		}
> +		if (!ip_set_timeout_expired(ext_timeout(&e->elem, set)))
> +			continue;
> +		if (rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params))
> +			continue; /* Concurrent delete? skip */
> +
> +		mtype_del_cidr_all(set, h, &e->elem);
> +		ip_set_ext_destroy_slow(set, &e->elem);
> +		kfree_rcu(e, rcu);
> 	}
> +	rhashtable_walk_stop(&hti);
> +	rhashtable_walk_exit(&hti);
>
> 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
> -
> }
>
> static void
> @@ -767,248 +505,15 @@ mtype_cancel_gc(struct ip_set *set)
> 		disable_delayed_work_sync(&h->gc.dwork);
> }
>
> -static int
> -mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> -	  struct ip_set_ext *mext, u32 flags);
> -static int
> -mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> -	  struct ip_set_ext *mext, u32 flags);
> -
> -/* Resize a hash: create a new hash table with doubling the hashsize
> - * and inserting the elements to it. Repeat until we succeed or
> - * fail due to memory pressures.
> - */
> -static int
> -mtype_resize(struct ip_set *set, bool retried)
> -{
> -	struct htype *h = set->data;
> -	struct htable *t, *orig;
> -	u8 pos, htable_bits;
> -	size_t hsize, dsize = set->dsize;
> -#ifdef IP_SET_HASH_WITH_NETS
> -	u8 flags;
> -	struct mtype_elem *tmp;
> -#endif
> -	struct mtype_elem *data;
> -	struct mtype_elem *d;
> -	struct hbucket *n, *m;
> -	struct list_head *l, *lt;
> -	struct mtype_resize_ad *x;
> -	u32 i, j, r, nr, key;
> -	int ret;
> -
> -#ifdef IP_SET_HASH_WITH_NETS
> -	tmp = kmalloc(dsize, GFP_KERNEL);
> -	if (!tmp)
> -		return -ENOMEM;
> -#endif
> -	orig = ipset_dereference_bh_nfnl(h->table);
> -	htable_bits = orig->htable_bits;
> -
> -retry:
> -	ret = 0;
> -	htable_bits++;
> -	if (!htable_bits)
> -		goto hbwarn;
> -	hsize = htable_size(htable_bits);
> -	if (!hsize)
> -		goto hbwarn;
> -	t = ip_set_alloc(hsize);
> -	if (!t) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
> -	if (!t->hregion) {
> -		ip_set_free(t);
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	t->htable_bits = htable_bits;
> -	t->maxelem = h->maxelem / ahash_numof_locks(htable_bits);
> -	INIT_LIST_HEAD(&t->ad);
> -	for (i = 0; i < ahash_numof_locks(htable_bits); i++)
> -		spin_lock_init(&t->hregion[i].lock);
> -
> -	/* There can't be another parallel resizing,
> -	 * but dumping and kernel side add/del are possible
> -	 */
> -	orig = ipset_dereference_bh_nfnl(h->table);
> -	atomic_inc(&orig->uref);
> -	spin_lock_bh(&h->gc.lock);
> -	orig->resizing = true;
> -	spin_unlock_bh(&h->gc.lock);
> -	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
> -		 set->name, orig->htable_bits, htable_bits, orig);
> -	for (r = 0; r < ahash_numof_locks(orig->htable_bits); r++) {
> -		/* Expire may replace a hbucket with another one */
> -		rcu_read_lock_bh();
> -		for (i = ahash_bucket_start(r, orig->htable_bits);
> -		     i < ahash_bucket_end(r, orig->htable_bits); i++) {
> -			n = __ipset_dereference(hbucket(orig, i));
> -			if (!n)
> -				continue;
> -			pos = smp_load_acquire(&n->pos);
> -			for (j = 0; j < pos; j++) {
> -				if (!test_bit_acquire(j, n->used))
> -					continue;
> -				data = ahash_data(n, j, dsize);
> -				if (SET_ELEM_EXPIRED(set, data))
> -					continue;
> -#ifdef IP_SET_HASH_WITH_NETS
> -				/* We have readers running parallel with us,
> -				 * so the live data cannot be modified.
> -				 */
> -				flags = 0;
> -				memcpy(tmp, data, dsize);
> -				data = tmp;
> -				mtype_data_reset_flags(data, &flags);
> -#endif
> -				key = HKEY(data, h->initval, htable_bits);
> -				m = __ipset_dereference(hbucket(t, key));
> -				nr = ahash_region(key);
> -				if (!m) {
> -					m = kzalloc(sizeof(*m) +
> -					    AHASH_INIT_SIZE * dsize,
> -					    GFP_ATOMIC);
> -					if (!m) {
> -						ret = -ENOMEM;
> -						goto cleanup;
> -					}
> -					m->size = AHASH_INIT_SIZE;
> -					t->hregion[nr].ext_size +=
> -						ext_size(AHASH_INIT_SIZE,
> -							 dsize);
> -					RCU_INIT_POINTER(hbucket(t, key), m);
> -				} else if (m->pos >= m->size) {
> -					struct hbucket *ht;
> -
> -					if (m->size >= AHASH_MAX(h)) {
> -						ret = -EAGAIN;
> -					} else {
> -						ht = kzalloc(sizeof(*ht) +
> -						(m->size + AHASH_INIT_SIZE)
> -						* dsize,
> -						GFP_ATOMIC);
> -						if (!ht)
> -							ret = -ENOMEM;
> -					}
> -					if (ret < 0)
> -						goto cleanup;
> -					memcpy(ht, m, sizeof(struct hbucket) +
> -					       m->size * dsize);
> -					ht->size = m->size + AHASH_INIT_SIZE;
> -					t->hregion[nr].ext_size +=
> -						ext_size(AHASH_INIT_SIZE,
> -							 dsize);
> -					kfree(m);
> -					m = ht;
> -					RCU_INIT_POINTER(hbucket(t, key), ht);
> -				}
> -				d = ahash_data(m, m->pos, dsize);
> -				memcpy(d, data, dsize);
> -				set_bit(m->pos++, m->used);
> -				t->hregion[nr].elements++;
> -#ifdef IP_SET_HASH_WITH_NETS
> -				mtype_data_reset_flags(d, &flags);
> -#endif
> -			}
> -		}
> -		rcu_read_unlock_bh();
> -	}
> -
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
> -	 */
> -	list_for_each_safe(l, lt, &orig->ad) {
> -		x = list_entry(l, struct mtype_resize_ad, list);
> -		if (x->ad == IPSET_ADD) {
> -			mtype_add(set, &x->d, &x->ext, &x->mext, x->flags);
> -		} else {
> -			mtype_del(set, &x->d, NULL, NULL, 0);
> -		}
> -		list_del(l);
> -		kfree(l);
> -	}
> -	/* If there's nobody else using the table, destroy it */
> -	if (atomic_dec_and_test(&orig->uref)) {
> -		pr_debug("Table destroy by resize %p\n", orig);
> -		mtype_ahash_destroy(set, orig, false);
> -	}
> -
> -out:
> -#ifdef IP_SET_HASH_WITH_NETS
> -	kfree(tmp);
> -#endif
> -	return ret;
> -
> -cleanup:
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
> -	}
> -	spin_unlock_bh(&set->lock);
> -	goto out;
> -
> -hbwarn:
> -	/* In case we have plenty of memory :-) */
> -	pr_warn("Cannot increase the hashsize of set %s further\n", set->name);
> -	ret = -IPSET_ERR_HASH_FULL;
> -	goto out;
> -}
> -
> -/* Get the current number of elements and ext_size in the set  */
> +/* Get the current number of elements and per-element memory in the set */
> static void
> mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
> {
> -	struct htype *h = set->data;
> -	const struct htable *t;
> -	struct hbucket *n;
> -	struct mtype_elem *data;
> -	u32 i, j, r;
> -	u8 pos;
> -
> -	t = rcu_dereference_bh(h->table);
> -	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
> -		for (i = ahash_bucket_start(r, t->htable_bits);
> -		     i < ahash_bucket_end(r, t->htable_bits); i++) {
> -			n = rcu_dereference_bh(hbucket(t, i));
> -			if (!n)
> -				continue;
> -			pos = smp_load_acquire(&n->pos);
> -			for (j = 0; j < pos; j++) {
> -				if (!test_bit_acquire(j, n->used))
> -					continue;
> -				data = ahash_data(n, j, set->dsize);
> -				if (!SET_ELEM_EXPIRED(set, data))
> -					(*elements)++;
> -			}
> -		}
> -		*ext_size += t->hregion[r].ext_size;
> -	}
> +	const struct htype *h = set->data;
> +
> +	*elements = atomic_read(&h->ht.nelems);
> +	*ext_size = *elements *
> +		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
> }
>
> /* Add an element to a hash and update the internal counters when succeeded,
> @@ -1019,298 +524,127 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	  struct ip_set_ext *mext, u32 flags)
> {
> 	struct htype *h = set->data;
> -	struct htable *t;
> 	const struct mtype_elem *d = value;
> -	struct mtype_elem *data;
> -	struct hbucket *n, *old = ERR_PTR(-ENOENT);
> -	int i, j = -1, ret;
> +	struct mtype_rht_elem *e, *old;
> 	bool flag_exist = flags & IPSET_FLAG_EXIST;
> -	bool deleted = false, forceadd = false, reuse = false;
> -	u32 r, key, multi = 0, elements, maxelem;
> -	u8 npos = 0;
> +	int ret = 0;
> +#ifdef IP_SET_HASH_WITH_NETS
> +	int i;
> +#endif
>
> +	/* Check for an existing entry with the same key */
> 	rcu_read_lock_bh();
> -	t = rcu_dereference_bh(h->table);
> -	key = HKEY(value, h->initval, t->htable_bits);
> -	r = ahash_region(key);
> -	atomic_inc(&t->uref);
> -	rcu_read_unlock_bh();
> -	elements = t->hregion[r].elements;
> -	maxelem = t->maxelem;
> -	if (elements >= maxelem) {
> -		u32 e;
> -		if (SET_WITH_TIMEOUT(set))
> -			mtype_gc_do(set, h, t, r);
> -		maxelem = h->maxelem;
> -		elements = 0;
> -		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)
> -			elements += t->hregion[e].elements;
> -		if (elements >= maxelem && SET_WITH_FORCEADD(set))
> -			forceadd = true;
> -	}
> -
> -	spin_lock_bh(&t->hregion[r].lock);
> -	n = rcu_dereference_bh(hbucket(t, key));
> -	if (!n) {
> -		if (forceadd || elements >= maxelem)
> -			goto set_full;
> -		old = NULL;
> -		n = kzalloc(sizeof(*n) + AHASH_INIT_SIZE * set->dsize,
> -			    GFP_ATOMIC);
> -		if (!n) {
> -			ret = -ENOMEM;
> -			goto unlock;
> -		}
> -		n->size = AHASH_INIT_SIZE;
> -		t->hregion[r].ext_size +=
> -			ext_size(AHASH_INIT_SIZE, set->dsize);
> -		goto copy_elem;
> -	}
> -	npos = smp_load_acquire(&n->pos);
> -	for (i = 0; i < npos; i++) {
> -		if (!test_bit(i, n->used)) {
> -			/* Reuse first deleted entry */
> -			if (j == -1) {
> -				deleted = reuse = true;
> -				j = i;
> -			}
> -			continue;
> -		}
> -		data = ahash_data(n, i, set->dsize);
> -		if (mtype_data_equal(data, d, &multi)) {
> -			if (flag_exist || SET_ELEM_EXPIRED(set, data)) {
> -				/* Just the extensions could be overwritten */
> -				j = i;
> -				goto overwrite_extensions;
> +	old = rhashtable_lookup(&h->ht, d, mtype_rht_params);
> +	if (old) {
> +		if (!SET_ELEM_EXPIRED(set, &old->elem)) {
> +			if (!flag_exist) {
> +				rcu_read_unlock_bh();
> +				return -IPSET_ERR_EXIST;
> 			}
> -			ret = -IPSET_ERR_EXIST;
> -			goto unlock;
> -		}
> -		/* Reuse first timed out entry */
> -		if (SET_ELEM_EXPIRED(set, data) && j == -1) {
> -			j = i;
> -			reuse = true;
> -		}
> -	}
> -	if (reuse || forceadd) {
> -		if (j == -1)
> -			j = 0;
> -		data = ahash_data(n, j, set->dsize);
> -		if (!deleted) {
> -			mtype_del_cidr_all(set, h, data);
> -			ip_set_ext_destroy_slow(set, data);
> -			t->hregion[r].elements--;
> -		}
> -		goto copy_data;
> -	}
> -	if (elements >= maxelem)
> -		goto set_full;
> -	/* Create a new slot */
> -	if (npos >= n->size) {
> -#ifdef IP_SET_HASH_WITH_MULTI
> -		if (h->bucketsize >= AHASH_MAX_TUNED)
> -			goto set_full;
> -		else if (h->bucketsize <= multi)
> -			h->bucketsize += AHASH_INIT_SIZE;
> +			/* flag_exist: overwrite extensions in-place.
> +			 * Hold set->lock to serialize ext_size accounting in
> +			 * ip_set_init_comment against concurrent kernel-side adds.
> +			 * rcu_read_lock_bh() must remain held to keep old alive.
> +			 */
> +			spin_lock_bh(&set->lock);
> +#ifdef IP_SET_HASH_WITH_NETS
> +			mtype_data_set_flags(&old->elem, flags);
> #endif
> -		if (n->size >= AHASH_MAX(h)) {
> -			/* Trigger rehashing */
> -			mtype_data_next(&h->next, d);
> -			ret = -EAGAIN;
> -			goto resize;
> +			if (SET_WITH_COUNTER(set))
> +				ip_set_init_counter(ext_counter(&old->elem, set),
> +						    ext);
> +			if (SET_WITH_COMMENT(set))
> +				ip_set_init_comment(set,
> +						    ext_comment(&old->elem, set),
> +						    ext);
> +			if (SET_WITH_SKBINFO(set))
> +				ip_set_init_skbinfo(ext_skbinfo(&old->elem, set),
> +						    ext);
> +			if (SET_WITH_TIMEOUT(set))
> +				ip_set_timeout_set(ext_timeout(&old->elem, set),
> +						   ext->timeout);
> +			spin_unlock_bh(&set->lock);
> +			rcu_read_unlock_bh();
> +			return 0;
> 		}
> -		old = n;
> -		n = kzalloc(sizeof(*n) +
> -			    (old->size + AHASH_INIT_SIZE) * set->dsize,
> -			    GFP_ATOMIC);
> -		if (!n) {
> -			ret = -ENOMEM;
> -			goto unlock;
> +		/* Expired entry: remove it to make room */
> +		if (rhashtable_remove_fast(&h->ht, &old->node,
> +					   mtype_rht_params) == 0) {
> +			mtype_del_cidr_all(set, h, &old->elem);
> +			ip_set_ext_destroy_slow(set, &old->elem);
> +			kfree_rcu(old, rcu);
> 		}
> -		memcpy(n, old, sizeof(struct hbucket) +
> -		       old->size * set->dsize);
> -		n->size = old->size + AHASH_INIT_SIZE;
> -		t->hregion[r].ext_size +=
> -			ext_size(AHASH_INIT_SIZE, set->dsize);
> 	}
> +	rcu_read_unlock_bh();
> +
> +	if (atomic_read(&h->ht.nelems) >= h->maxelem) {
> +		if (net_ratelimit())
> +			pr_warn("Set %s is full, maxelem %u reached\n",
> +				set->name, h->maxelem);
> +		mtype_data_next(&h->next, d);

Why the mtype_data_next() call is needed here?

> +		return -IPSET_ERR_HASH_FULL;
> +	}
> +
> +	e = kzalloc(offsetof(struct mtype_rht_elem, elem) + set->dsize,
> +		    GFP_ATOMIC);
> +	if (!e)
> +		return -ENOMEM;
> +
> +	memcpy(&e->elem, d, sizeof(struct mtype_elem));
>
> -copy_elem:
> -	j = npos++;
> -	data = ahash_data(n, j, set->dsize);
> -copy_data:
> -	t->hregion[r].elements++;
> #ifdef IP_SET_HASH_WITH_NETS
> 	for (i = 0; i < IPSET_NET_COUNT; i++)
> 		mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
> -#endif
> -	memcpy(data, d, sizeof(struct mtype_elem));
> -overwrite_extensions:
> -#ifdef IP_SET_HASH_WITH_NETS
> -	mtype_data_set_flags(data, flags);
> +
> +	mtype_data_set_flags(&e->elem, flags);
> #endif
> 	if (SET_WITH_COUNTER(set))
> -		ip_set_init_counter(ext_counter(data, set), ext);
> +		ip_set_init_counter(ext_counter(&e->elem, set), ext);
> 	if (SET_WITH_COMMENT(set))
> -		ip_set_init_comment_slow(set, ext_comment(data, set), ext);
> +		ip_set_init_comment_slow(set, ext_comment(&e->elem, set), ext);
> 	if (SET_WITH_SKBINFO(set))
> -		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
> +		ip_set_init_skbinfo(ext_skbinfo(&e->elem, set), ext);
> 	/* Must come last for the case when timed out entry is reused */
> 	if (SET_WITH_TIMEOUT(set))
> -		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
> -	smp_mb__before_atomic();
> -	/* Ensure all data writes are visible before updating position */
> -	smp_store_release(&n->pos, npos);
> -	set_bit(j, n->used);
> -	if (old != ERR_PTR(-ENOENT)) {
> -		rcu_assign_pointer(hbucket(t, key), n);
> -		if (old)
> -			kfree_rcu(old, rcu);
> -	}
> -	ret = 0;
> -resize:
> -	spin_unlock_bh(&t->hregion[r].lock);
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
> -	goto out;
> +		ip_set_timeout_set(ext_timeout(&e->elem, set), ext->timeout);
>
> -set_full:
> -	if (net_ratelimit())
> -		pr_warn("Set %s is full, maxelem %u reached\n",
> -			set->name, maxelem);
> -	ret = -IPSET_ERR_HASH_FULL;
> -unlock:
> -	spin_unlock_bh(&t->hregion[r].lock);
> -out:
> -	if (atomic_dec_and_test(&t->uref) && t->resizing) {
> -		pr_debug("Table destroy after resize by add: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> +	ret = rhashtable_insert_fast(&h->ht, &e->node, mtype_rht_params);
> +	if (ret) {
> +		mtype_del_cidr_all(set, h, d);
> +		ip_set_ext_destroy_slow(set, &e->elem);
> +		kfree(e);
> +		if (ret == -EEXIST)
> +			ret = flag_exist ? 0 : -IPSET_ERR_EXIST;
> 	}
> 	return ret;
> }
>
> -/* Delete an element from the hash and free up space if possible.
> - */
> +/* Delete an element from the hash */
> static int
> mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	  struct ip_set_ext *mext, u32 flags)
> {
> 	struct htype *h = set->data;
> -	struct htable *t;
> 	const struct mtype_elem *d = value;
> -	struct mtype_elem *data;
> -	struct hbucket *n;
> -	struct mtype_resize_ad *x = NULL;
> -	int i, j, k, r, ret = -IPSET_ERR_EXIST;
> -	u32 key, multi = 0;
> -	size_t dsize = set->dsize;
> -	u8 pos;
> -
> -	/* Userspace add and resize is excluded by the mutex.
> -	 * Kernespace add does not trigger resize.
> -	 */
> +	struct mtype_rht_elem *e;
> +	int ret = -IPSET_ERR_EXIST;
> +
> 	rcu_read_lock_bh();
> -	t = rcu_dereference_bh(h->table);
> -	key = HKEY(value, h->initval, t->htable_bits);
> -	r = ahash_region(key);
> -	atomic_inc(&t->uref);
> +	e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
> +	if (!e) {
> +		rcu_read_unlock_bh();
> +		return -IPSET_ERR_EXIST;
> +	}
> +	ret = rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params);
> 	rcu_read_unlock_bh();
>
> -	spin_lock_bh(&t->hregion[r].lock);
> -	n = rcu_dereference_bh(hbucket(t, key));
> -	if (!n)
> -		goto out;
> -	pos = smp_load_acquire(&n->pos);
> -	for (i = 0, k = 0; i < pos; i++) {
> -		if (!test_bit(i, n->used)) {
> -			k++;
> -			continue;
> -		}
> -		data = ahash_data(n, i, dsize);
> -		if (!mtype_data_equal(data, d, &multi))
> -			continue;
> -		if (SET_ELEM_EXPIRED(set, data))
> -			goto out;
> -
> -		ret = 0;
> -		clear_bit(i, n->used);
> -		smp_mb__after_atomic();
> -		if (i + 1 == pos)
> -			smp_store_release(&n->pos, --pos);
> -		t->hregion[r].elements--;
> -		mtype_del_cidr_all(set, h, d);
> -		ip_set_ext_destroy_slow(set, data);
> -
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
> -		for (; i < pos; i++) {
> -			if (!test_bit(i, n->used))
> -				k++;
> -		}
> -		if (k == pos) {
> -			t->hregion[r].ext_size -= ext_size(n->size, dsize);
> -			rcu_assign_pointer(hbucket(t, key), NULL);
> -			kfree_rcu(n, rcu);
> -		} else if (k >= AHASH_INIT_SIZE) {
> -			struct hbucket *tmp = kzalloc(sizeof(*tmp) +
> -					(n->size - AHASH_INIT_SIZE) * dsize,
> -					GFP_ATOMIC);
> -			if (!tmp)
> -				goto out;
> -			tmp->size = n->size - AHASH_INIT_SIZE;
> -			for (j = 0, k = 0; j < pos; j++) {
> -				if (!test_bit(j, n->used))
> -					continue;
> -				data = ahash_data(n, j, dsize);
> -				memcpy(tmp->value + k * dsize, data, dsize);
> -				set_bit(k, tmp->used);
> -				k++;
> -			}
> -			tmp->pos = k;
> -			t->hregion[r].ext_size -=
> -				ext_size(AHASH_INIT_SIZE, dsize);
> -			rcu_assign_pointer(hbucket(t, key), tmp);
> -			kfree_rcu(n, rcu);
> -		}
> -		goto out;
> -	}
> +	if (ret)
> +		return -IPSET_ERR_EXIST;
>
> -out:
> -	spin_unlock_bh(&t->hregion[r].lock);
> -	if (x) {
> -		spin_lock_bh(&set->lock);
> -		list_add(&x->list, &t->ad);
> -		spin_unlock_bh(&set->lock);
> -	}
> -	if (atomic_dec_and_test(&t->uref) && t->resizing) {
> -		pr_debug("Table destroy after resize by del: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> -	}
> -	return ret;
> +	mtype_del_cidr_all(set, h, d);
> +	ip_set_ext_destroy_slow(set, &e->elem);
> +	kfree_rcu(e, rcu);
> +	return 0;
> }
>
> static int
> @@ -1333,25 +667,21 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
> 		 struct ip_set_ext *mext, u32 flags)
> {
> 	struct htype *h = set->data;
> -	struct htable *t = rcu_dereference_bh(h->table);
> 	struct net_prefixes *nets0;
> -	struct hbucket *n;
> -	struct mtype_elem *data;
> +	struct mtype_rht_elem *e;
> #if IPSET_NET_COUNT == 2
> 	struct net_prefixes *nets1;
> 	struct mtype_elem orig = *d;
> -	int ret, i, j, k;
> +	int ret, j, k;
> #else
> -	int ret, i, j;
> +	int ret, j;
> #endif
> -	u32 key, multi = 0;
> -	u8 pos;
> +	u32 multi = 0;
>
> 	pr_debug("test by nets\n");
> -	rcu_read_lock_bh();
> -	nets0 = rcu_dereference_bh(h->rnets[0]);
> +	nets0 = ipset_dereference_bh_nfnl(h->rnets[0]);
> #if IPSET_NET_COUNT == 2
> -	nets1 = rcu_dereference_bh(h->rnets[1]);
> +	nets1 = ipset_dereference_bh_nfnl(h->rnets[1]);
> #endif
> 	for (j = 0; j < nets0->len && !multi; j++) {
> 		if (!nets0->nets[j].count)
> @@ -1366,20 +696,11 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
> #else
> 		mtype_data_netmask(d, nets0->nets[j].cidr);
> #endif
> -		key = HKEY(d, h->initval, t->htable_bits);
> -		n = rcu_dereference_bh(hbucket(t, key));
> -		if (!n)
> -			continue;
> -		pos = smp_load_acquire(&n->pos);
> -		for (i = 0; i < pos; i++) {
> -			if (!test_bit_acquire(i, n->used))
> -				continue;
> -			data = ahash_data(n, i, set->dsize);
> -			if (!mtype_data_equal(data, d, &multi))
> -				continue;
> -			ret = mtype_data_match(data, ext, mext, set, flags);
> +		e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
> +		if (e) {
> +			ret = mtype_data_match(&e->elem, ext, mext, set, flags);

The code now works as if in the case of the netiface type the interfaces 
were included and matched at element level.

> 			if (ret != 0)
> -				goto unlock;
> +				return ret;
> #ifdef IP_SET_HASH_WITH_MULTI
> 			/* No match, reset multiple match flag */
> 			multi = 0;
> @@ -1389,10 +710,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
> 		}
> #endif
> 	}
> -	ret = 0;
> -unlock:
> -	rcu_read_unlock_bh();
> -	return ret;
> +	return 0;
> }
> #endif
>
> @@ -1402,16 +720,14 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	   struct ip_set_ext *mext, u32 flags)
> {
> 	struct htype *h = set->data;
> -	struct htable *t;
> 	struct mtype_elem *d = value;
> -	struct hbucket *n;
> -	struct mtype_elem *data;
> -	int i, ret = 0;
> -	u32 key, multi = 0;
> -	u8 pos;
> +	struct mtype_rht_elem *e;
> +	int ret = 0;
> +#ifdef IP_SET_HASH_WITH_NETS
> +	int i;
> +#endif
>
> 	rcu_read_lock_bh();
> -	t = rcu_dereference_bh(h->table);
> #ifdef IP_SET_HASH_WITH_NETS
> 	/* If we test an IP address and not a network address,
> 	 * try all possible network sizes
> @@ -1425,23 +741,13 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	}
> #endif
>
> -	key = HKEY(d, h->initval, t->htable_bits);
> -	n = rcu_dereference_bh(hbucket(t, key));
> -	if (!n) {
> +	e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
> +	if (!e || SET_ELEM_EXPIRED(set, &e->elem)) {
> 		ret = 0;
> 		goto out;
> 	}
> -	pos = smp_load_acquire(&n->pos);
> -	for (i = 0; i < pos; i++) {
> -		if (!test_bit_acquire(i, n->used))
> -			continue;
> -		data = ahash_data(n, i, set->dsize);
> -		if (!mtype_data_equal(data, d, &multi))
> -			continue;
> -		ret = mtype_data_match(data, ext, mext, set, flags);
> -		if (ret != 0)
> -			goto out;
> -	}
> +
> +	ret = mtype_data_match(&e->elem, ext, mext, set, flags);
> out:
> 	rcu_read_unlock_bh();
> 	return ret;
> @@ -1449,20 +755,24 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>
> static u32 mtype_hash_size(const struct htype *h)
> {
> -	const struct htable *t;
> -	u8 htable_bits;
> +	const struct bucket_table *tbl;
> +	u32 size = 0;
>
> 	rcu_read_lock();
> -	t = rcu_dereference(h->table);
> -	htable_bits = t->htable_bits;
> +	tbl = rcu_dereference(h->ht.tbl);
> +	if (tbl)
> +		size = tbl->size;
> 	rcu_read_unlock();
>
> -	return jhash_size(htable_bits);
> +	return size;
> }
>
> static u32 mtype_bucket_size(const struct htype *h)
> {
> -	return h->bucketsize;
> +	unsigned int nelems = atomic_read(&h->ht.nelems);
> +	u32 size = mtype_hash_size(h);
> +
> +	return nelems / size;
> }
>
> /* Reply a HEADER request: fill out the header part of the set */
> @@ -1470,17 +780,13 @@ static int
> mtype_head(struct ip_set *set, struct sk_buff *skb)
> {
> 	struct htype *h = set->data;
> -	const struct htable *t;
> 	struct nlattr *nested;
> 	size_t memsize;
> 	u32 elements = 0;
> 	size_t ext_size = 0;
>
> -	rcu_read_lock_bh();
> -	t = rcu_dereference_bh(h->table);
> 	mtype_ext_size(set, &elements, &ext_size);
> -	memsize = mtype_ahash_memsize(h, t) + ext_size + set->ext_size;
> -	rcu_read_unlock_bh();
> +	memsize = sizeof(*h) + ext_size + set->ext_size;
>
> 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
> 	if (!nested)
> @@ -1514,7 +820,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
> 	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE) {
> 		if (nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, mtype_bucket_size(h)))
> 			goto nla_put_failure;
> -		if (nla_put_net32(skb, IPSET_ATTR_INITVAL, htonl(h->initval)))
> +		if (nla_put_u32(skb, IPSET_ATTR_INITVAL, 0))

I know it is just garbage now, but h->initval should be returned.

> 			goto nla_put_failure;
> 	}
> 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
> @@ -1530,25 +836,23 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
> 	return -EMSGSIZE;
> }
>
> -/* Make possible to run dumping parallel with resizing */
> +/* Manage the rhashtable_iter lifetime for dump operations */
> static void
> mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
> {
> 	struct htype *h = set->data;
> -	struct htable *t;
> +	struct rhashtable_iter *hti;
>
> 	if (start) {
> -		rcu_read_lock_bh();
> -		t = ipset_dereference_bh_nfnl(h->table);
> -		atomic_inc(&t->uref);

We don't need uref anymore. Cool!

> -		cb->args[IPSET_CB_PRIVATE] = (unsigned long)t;
> -		rcu_read_unlock_bh();
> -	} else if (cb->args[IPSET_CB_PRIVATE]) {
> -		t = (struct htable *)cb->args[IPSET_CB_PRIVATE];
> -		if (atomic_dec_and_test(&t->uref) && t->resizing) {
> -			pr_debug("Table destroy after resize "
> -				 " by dump: %p\n", t);
> -			mtype_ahash_destroy(set, t, false);
> +		hti = kmalloc(sizeof(*hti), GFP_ATOMIC);
> +		if (hti)
> +			rhashtable_walk_enter(&h->ht, hti);
> +		cb->args[IPSET_CB_PRIVATE] = (unsigned long)hti;
> +	} else {
> +		hti = (struct rhashtable_iter *)cb->args[IPSET_CB_PRIVATE];
> +		if (hti) {
> +			rhashtable_walk_exit(hti);
> +			kfree(hti);
> 		}
> 		cb->args[IPSET_CB_PRIVATE] = 0;
> 	}
> @@ -1559,77 +863,77 @@ static int
> mtype_list(const struct ip_set *set,
> 	   struct sk_buff *skb, struct netlink_callback *cb)
> {
> -	const struct htable *t;
> +	struct rhashtable_iter *hti =
> +		(struct rhashtable_iter *)cb->args[IPSET_CB_PRIVATE];
> +	struct mtype_rht_elem *e, *peeked;
> 	struct nlattr *atd, *nested;
> -	const struct hbucket *n;
> -	const struct mtype_elem *e;
> -	u32 first = cb->args[IPSET_CB_ARG0];
> -	/* We assume that one hash bucket fills into one page */
> 	void *incomplete;
> -	int i, ret = 0;
> -	u8 pos;
> +	u32 emitted = 0;
> +	int ret = 0;
> +
> +	if (!hti)
> +		return -EMSGSIZE;
>
> 	atd = nla_nest_start(skb, IPSET_ATTR_ADT);
> 	if (!atd)
> 		return -EMSGSIZE;
>
> -	pr_debug("list hash set %s\n", set->name);
> -	t = (const struct htable *)cb->args[IPSET_CB_PRIVATE];
> -	/* Expire may replace a hbucket with another one */
> -	rcu_read_lock();
> -	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
> -	     cb->args[IPSET_CB_ARG0]++) {
> -		cond_resched_rcu();
> -		incomplete = skb_tail_pointer(skb);
> -		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
> -		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
> -			 cb->args[IPSET_CB_ARG0], t, n);
> -		if (!n)
> -			continue;
> -		pos = smp_load_acquire(&n->pos);
> -		for (i = 0; i < pos; i++) {
> -			if (!test_bit_acquire(i, n->used))
> +	rhashtable_walk_start(hti);
> +	while ((e = rhashtable_walk_peek(hti))) {
> +		if (IS_ERR(e)) {
> +			if (PTR_ERR(e) == -EAGAIN)
> 				continue;
> -			e = ahash_data(n, i, set->dsize);
> -			if (SET_ELEM_EXPIRED(set, e))
> -				continue;
> -			pr_debug("list hash %lu hbucket %p i %u, data %p\n",
> -				 cb->args[IPSET_CB_ARG0], n, i, e);
> -			nested = nla_nest_start(skb, IPSET_ATTR_DATA);
> -			if (!nested) {
> -				if (cb->args[IPSET_CB_ARG0] == first) {
> -					nla_nest_cancel(skb, atd);
> -					ret = -EMSGSIZE;
> -					goto out;
> -				}
> -				goto nla_put_failure;
> -			}
> -			if (mtype_data_list(skb, e))
> -				goto nla_put_failure;
> -			if (ip_set_put_extensions(skb, set, e, true))
> -				goto nla_put_failure;
> -			nla_nest_end(skb, nested);
> +			ret = PTR_ERR(e);
> +			break;
> +		}
> +		peeked = e;
> +next_dump:
> +		if (SET_ELEM_EXPIRED(set, &e->elem))
> +			goto next_entry;
> +
> +		incomplete = skb_tail_pointer(skb);
> +		nested = nla_nest_start(skb, IPSET_ATTR_DATA);
> +		if (!nested) {
> +			nlmsg_trim(skb, incomplete);
> +			goto paused;
> +		}
> +		if (mtype_data_list(skb, &e->elem) ||
> +		    ip_set_put_extensions(skb, set, &e->elem, true)) {
> +			nla_nest_cancel(skb, nested);
> +			nlmsg_trim(skb, incomplete);
> +			goto paused;
> +		}
> +		nla_nest_end(skb, nested);
> +		emitted++;
> +next_entry:
> +		e = rhashtable_walk_next(hti);
> +		if (IS_ERR(e)) {
> +			ret = PTR_ERR(e);
> +			if (ret != -EAGAIN)
> +				break;
> +			ret = 0;
> +		} else if (peeked && e != peeked) {
> +			peeked = NULL;
> +			if (e)
> +				goto next_dump;
> 		}
> 	}
> +	/* Walk exhausted: listing done */
> 	nla_nest_end(skb, atd);
> -	/* Set listing finished */
> +	rhashtable_walk_stop(hti);
> 	cb->args[IPSET_CB_ARG0] = 0;
> +	return ret;
>
> -	goto out;
> -
> -nla_put_failure:
> -	nlmsg_trim(skb, incomplete);
> -	if (unlikely(first == cb->args[IPSET_CB_ARG0])) {
> -		pr_warn("Can't list set %s: one bucket does not fit into a message. Please report it!\n",
> -			set->name);
> -		cb->args[IPSET_CB_ARG0] = 0;
> -		ret = -EMSGSIZE;
> -	} else {
> -		nla_nest_end(skb, atd);
> +paused:
> +	if (emitted == 0) {
> +		nla_nest_cancel(skb, atd);
> +		rhashtable_walk_stop(hti);
> +		return -EMSGSIZE;
> 	}
> -out:
> -	rcu_read_unlock();
> -	return ret;
> +	cb->args[IPSET_CB_ARG0] = 1;
> +	nla_nest_end(skb, atd);
> +	rhashtable_walk_stop(hti);
> +	return 0;
> }
>
> static int
> @@ -1655,7 +959,7 @@ static const struct ip_set_type_variant mtype_variant = {
> 	.head	= mtype_head,
> 	.list	= mtype_list,
> 	.uref	= mtype_uref,
> -	.resize	= mtype_resize,
> +	.resize	= NULL,
> 	.same_set = mtype_same_set,
> 	.cancel_gc = mtype_cancel_gc,
> 	.region_lock = true,
> @@ -1671,7 +975,6 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
> #ifdef IP_SET_HASH_WITH_MARKMASK
> 	u32 markmask;
> #endif
> -	u8 hbits;
> #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
> 	int ret __attribute__((unused)) = 0;
> 	u8 netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
> @@ -1679,12 +982,11 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
> #endif
> #ifdef IP_SET_HASH_WITH_NETS
> 	struct net_prefixes *nets;
> +	int i;
> #endif
> 	size_t hsize;
> 	struct htype *h;
> -	struct htable *t;
> 	int err;
> -	u32 i;
>
> 	pr_debug("Create set %s with family %s\n",
> 		 set->name, set->family == NFPROTO_IPV4 ? "inet" : "inet6");
> @@ -1765,17 +1067,21 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>
> #ifdef IP_SET_PROTO_UNDEF
> 	hsize = sizeof(struct htype);
> +	params = mtype_rht_params;
> #else
> -	hsize = set->family == NFPROTO_IPV6 ?
> -		sizeof(struct IPSET_TOKEN(HTYPE, 6)) :
> -		sizeof(struct IPSET_TOKEN(HTYPE, 4));
> +	if (set->family == NFPROTO_IPV6) {
> +		hsize = sizeof(struct IPSET_TOKEN(HTYPE, 6));
> +		params = IPSET_TOKEN(HTYPE, 6_rht_params);
> +	} else {
> +		hsize = sizeof(struct IPSET_TOKEN(HTYPE, 4));
> +		params = IPSET_TOKEN(HTYPE, 4_rht_params);
> +	}
> #endif
> 	h = kzalloc(hsize, GFP_KERNEL);
> 	if (!h)
> 		return -ENOMEM;
>
> 	/* Initialize rhashtable with the user-requested size as hint */
> -	params = mtype_rht_params;
> 	params.nelem_hint = hashsize;
> 	/* maxsize: maximum bucket table size to expand to */
> 	params.max_size = maxelem;
> @@ -1784,36 +1090,19 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
> 	if (err)
> 		goto free_h;
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
> #ifdef IP_SET_HASH_WITH_NETS
> 	for (i = 0; i < IPSET_NET_COUNT; i++) {
> 		nets = kzalloc(sizeof(struct net_prefixes), GFP_KERNEL);
> 		if (!nets) {
> 			while (i > 0)
> 				kfree(h->rnets[--i]);
> -			goto free_hregion;
> +			goto free_rht;
> 		}
> 		RCU_INIT_POINTER(h->rnets[i], nets);
> 	}
> #endif
> -	h->gc.set = set;
> -	spin_lock_init(&h->gc.lock);
> -	for (i = 0; i < ahash_numof_locks(hbits); i++)
> -		spin_lock_init(&t->hregion[i].lock);
> 	h->maxelem = maxelem;
> +	h->gc.set = set;
> #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
> 	h->bitmask = bitmask;
> 	h->netmask = netmask;
> @@ -1821,24 +1110,6 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
> #ifdef IP_SET_HASH_WITH_MARKMASK
> 	h->markmask = markmask;
> #endif
> -	if (tb[IPSET_ATTR_INITVAL])
> -		h->initval = ntohl(nla_get_be32(tb[IPSET_ATTR_INITVAL]));
> -	else
> -		get_random_bytes(&h->initval, sizeof(h->initval));

When initval restored, the else branch is still not needed anymore.

Best regards,
Jozsef


> -	h->bucketsize = AHASH_MAX_SIZE;
> -	if (tb[IPSET_ATTR_BUCKETSIZE]) {
> -		h->bucketsize = nla_get_u8(tb[IPSET_ATTR_BUCKETSIZE]);
> -		if (h->bucketsize < AHASH_INIT_SIZE)
> -			h->bucketsize = AHASH_INIT_SIZE;
> -		else if (h->bucketsize > AHASH_MAX_SIZE)
> -			h->bucketsize = AHASH_MAX_SIZE;
> -		else if (h->bucketsize % 2)
> -			h->bucketsize += 1;
> -	}
> -	t->htable_bits = hbits;
> -	t->maxelem = h->maxelem / ahash_numof_locks(hbits);
> -	INIT_LIST_HEAD(&t->ad);
> -	RCU_INIT_POINTER(h->table, t);
> 	set->data = h;
>
> #ifndef IP_SET_PROTO_UNDEF
> @@ -1868,23 +1139,18 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
> 			IPSET_TOKEN(HTYPE, 6_gc_init)(&h->gc);
> #endif
> 	}
> -	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
> -		 set->name, mtype_hash_size(h),
> -		 t->htable_bits, h->maxelem, set->data, t);
> +	pr_debug("create %s hashsize %u maxelem %u\n",
> +		 set->name, mtype_hash_size(h), h->maxelem);
>
> 	return 0;
>
> #ifdef IP_SET_HASH_WITH_NETS
> -free_hregion:
> -	ip_set_free(t->hregion);
> -#endif
> -free_t:
> -	ip_set_free(t);
> free_rht:
> 	rhashtable_free_and_destroy(&h->ht, mtype_flush_elem, set);
> +#endif
> free_h:
> 	kfree(h);
> -	return -ENOMEM;
> +	return err ? err : -ENOMEM;
> }
> #endif /* IP_SET_EMIT_CREATE */
>
> -- 
> 2.54.0
>
>
>
