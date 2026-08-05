Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EFE358388;
	Wed,  5 Aug 2026 00:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888935; cv=none; b=WlwAQ86EnD6iG/RgFXdjez8X8VhoiIPEOw272YZVs74f9yEOIk/EiUI+a3ufDbe/6cHEdUJ7I1NpvYBmu/Cf2L7HOeSXE+o3EhY8BsmauDs4uLlgJ1UGl6sFAyTWZTR8vq73/HqHaJZM7WRRLeUG7V052vyClj9EXaykHxM5FfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888935; c=relaxed/simple;
	bh=XlI+IjUmXRgIPI9qS1Bwp0dUYtr7dZ+T7WIfMmZmtUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBn8vZ916H4gZNXUqX1s65NvZ3oyvFA23azj1jQKbfVzPpitJ3fwbPSACQIs+WrX/xCRhDAyxwBYzCdnJY4Nih++GsA1paq0+j/NEFLLVi9GiLsxBRZ7bo0Js6ojdSYUJBn/UegCptdhRAfF4EB0ctv+4m+5ElqhJ4InxmuRNHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YdHGblsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdHGblsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2F01F00A3D;
	Wed,  5 Aug 2026 00:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785888932;
	bh=eAyO+SlOOo49YezSZ2EE77ml1h/aOIQHjSuEIALfdDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdHGblsu9Q6fwspMjzMwumGuPuzb5FeR87I9i6mwGeayeqYJ1ZC3YC6WcJfr9jNyy
	 46jrwnfJ8IDme/4AVKnvsJq1iJAwAdmgKOCiiicJJHtaUWahswi0Hvmhhqc1D9QyT1
	 1TPX3t78stQxHmzyoca46IYXgR/ZWZn0/4K3/GylWAbT7BMPHM3jarWmsY5m4YKP97
	 FyoZaL+Kk016PyF+NdkJ6DDhUQJ3yBntaDQ0RukxRKUMUVSQs/Ychi6AC0Ut3X8Boq
	 pVWXtD7fTtiBF/i2Hxr4rrlXO+kVQnddftBqUj1ctYnkMH5srpPMMRZ6DJZhuNxq5O
	 mf3MZKaq+28lQ==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 03/10] netfilter: ipset: rework cidr bookkeeping
Date: Tue,  4 Aug 2026 17:15:31 -0700
Message-ID: <20260805001531.3978750-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731151806.849724-4-pablo@netfilter.org>
References: <20260731151806.849724-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: ipset: rework cidr bookkeeping

The prefix bookkeeping of the hash:net* set types is moved out of struct
htype into separately allocated, RCU published struct net_prefixes arrays.
The in-place shifting of the cidr array is replaced by allocate-copy-publish,
with a documented fallback to leaving holes when the allocation fails.

A few questions about the new bookkeeping below.

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index b2d77973272d2..dd31992c915ca 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -99,9 +99,15 @@ struct htable {
>  #endif
>  
>  /* Book-keeping of the prefixes added to the set */
> +struct net_prefix {
> +	u8 cidr;			/* the cidr value */
> +	u32 count;			/* number of elements of this cidr */
> +};
> +
>  struct net_prefixes {
> -	u32 nets[IPSET_NET_COUNT]; /* number of elements for this cidr */
> -	u8 cidr[IPSET_NET_COUNT];  /* the cidr value */
> +	struct rcu_head rcu;
> +	u8 len;
> +	struct net_prefix nets[] __counted_by(len);
>  };
>  
>  /* Compute the hash table size */
> @@ -127,11 +133,6 @@ htable_size(u8 hbits)
>  #else
>  #define __CIDR(cidr, i)		(cidr)
>  #endif
> -
> -/* cidr + 1 is stored in net_prefixes to support /0 */
> -#define NCIDR_PUT(cidr)		((cidr) + 1)
> -#define NCIDR_GET(cidr)		((cidr) - 1)
> -
>  #ifdef IP_SET_HASH_WITH_NETS_PACKED
>  /* When cidr is packed with nomatch, cidr - 1 is stored in the data entry */
>  #define DCIDR_PUT(cidr)		((cidr) - 1)
> @@ -141,21 +142,11 @@ htable_size(u8 hbits)
>  #define DCIDR_GET(cidr, i)	__CIDR(cidr, i)
>  #endif
>  
> -#define INIT_CIDR(cidr, host_mask)	\
> -	DCIDR_PUT(((cidr) ? NCIDR_GET(cidr) : host_mask))
> -
> -#ifdef IP_SET_HASH_WITH_NET0
> -/* cidr from 0 to HOST_MASK value and c = cidr + 1 */
> -#define NLEN			(HOST_MASK + 1)
> -#define CIDR_POS(c)		((c) - 1)
> -#else
> -/* cidr from 1 to HOST_MASK value and c = cidr + 1 */
> -#define NLEN			HOST_MASK
> -#define CIDR_POS(c)		((c) - 2)
> -#endif

[Severity: Low]
This isn't a bug, but these were the only readers of
IP_SET_HASH_WITH_NET0, and the flag is still defined by
ip_set_hash_netiface.c and ip_set_hash_netportnet.c:

  #define IP_SET_HASH_WITH_NET0

After this change nothing in ip_set_hash_gen.h consumes it, so /0 support
is now implicit (cidr 0 with count != 0).  Should those two defines be
dropped as well?  Grepping net/netfilter/ipset/ at the end of the series
still shows the two define lines and no consumers.

> +#define INIT_CIDR(n, host_mask) ({				\
> +	const struct net_prefixes *__n = rcu_dereference(n);		\
> +	DCIDR_PUT((__n)->len ? (__n)->nets[0].cidr : host_mask);\
> +})

[Severity: Medium]
Should INIT_CIDR() also look at nets[0].count?

Every other user of the array treats count == 0 as a stale hole.
mtype_test_cidrs() skips them:

	for (j = 0; j < nets0->len && !multi; j++) {
		if (!nets0->nets[j].count)
			continue;

and mtype_add_cidr()/mtype_del_cidr() only count entries with
nets->nets[i].count when computing the new length.  INIT_CIDR() tests len
only, and len is the number of allocated slots rather than the number of
live prefixes.

Two states created by this patch leave len non-zero with count == 0 at
index 0:

  - mtype_del_cidr() on allocation failure:

	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
	if (!tmp)
		/* Leave a hole */
		goto unlock;

  - mtype_flush() on allocation failure, which zeroes the counts but keeps
    len and the stored cidr values.

In both cases INIT_CIDR() returns a prefix that is no longer in the set,
where the previous memset(h->nets, 0, sizeof(h->nets)) guaranteed the
host_mask fallback.  The value is then used for real work on the kadt
path, for example in hash_net4_kadt():

	struct hash_net4_elem e = {
		.cidr = INIT_CIDR(h->rnets[0], HOST_MASK),
	};
	...
	if (e.cidr == 0)
		return -EINVAL;
	...
	e.ip &= ip_set_netmask(e.cidr);

so an add or del driven by the SET target can end up operating on a
broader network than intended.  The same pattern applies to the
hash_netiface*, hash_netport*, hash_ipportnet*, hash_netnet* and
hash_netportnet* kadt functions.

The commit message says the hole possibility "is taken into account at
evaluation time" - that holds for mtype_test_cidrs(), but does it hold for
INIT_CIDR()?  This is unchanged at the end of the series (3a0d9fd64b67).

>  
> -#else
> -#define NLEN			0
>  #endif /* IP_SET_HASH_WITH_NETS */
>  
>  #define SET_ELEM_EXPIRED(set, d)	\
> @@ -292,6 +283,7 @@ static const union nf_inet_addr zeromask = {};
>  /* The generic hash structure */
>  struct htype {
>  	struct htable __rcu *table; /* the hash table */
> +	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
>  	struct htable_gc gc;	/* gc workqueue */
>  	u32 maxelem;		/* max elements in the hash */
>  	u32 initval;		/* random jhash init value */
> @@ -302,9 +294,6 @@ struct htype {
>  #if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
>  	u8 netmask;		/* netmask value for subnets to store */
>  	union nf_inet_addr bitmask;	/* stores bitmask */
> -#endif
> -#ifdef IP_SET_HASH_WITH_NETS
> -	struct net_prefixes nets[NLEN]; /* book-keeping of prefixes */
>  #endif

[Severity: Low]
Does the memsize reported to userspace need updating too?  The bookkeeping
is no longer part of struct htype, but mtype_ahash_memsize() still only
accounts for sizeof(*h):

	return sizeof(*h) + sizeof(*t) + ahash_sizeof_regions(t->htable_bits);

So the h->rnets[] allocations (up to HOST_MASK + 1 entries times
IPSET_NET_COUNT, and note struct net_prefix is 8 bytes after padding) are
no longer visible in IPSET_ATTR_MEMSIZE, and the reported value drops for
existing set types.  The commit message does not mention this user visible
change.  Still the case at the end of the series (3a0d9fd64b67).

>  	/* Because 'next' is IPv4/IPv6 dependent, no elements of this
>  	 * structure and referred in create() may come after 'next'.
> @@ -326,50 +315,92 @@ struct mtype_resize_ad {
>  /* Network cidr size book keeping when the hash stores different
>   * sized networks. cidr == real cidr + 1 to support /0.
>   */

[Severity: Low]
This isn't a bug, but the comment still describes the encoding this patch
removes.  NCIDR_PUT()/NCIDR_GET() are gone and all call sites now pass the
raw value, for example:

	mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);

Could the comment be updated to describe the new invariants instead
(descending cidr order, count == 0 marks a hole, len is the number of
allocated slots, /0 distinguished by count)?  The stale text is still
present at the end of the series (3a0d9fd64b67).

> -static void
> +static int
>  mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
>  {
> -	int i, j;
> +	struct net_prefixes *nets, *tmp;
> +	int i, j, found, len = 0, ret = 0;
>  
>  	spin_lock_bh(&set->lock);
> +	nets = __ipset_dereference(h->rnets[n]);
>  	/* Add in increasing prefix order, so larger cidr first */
> -	for (i = 0, j = -1; i < NLEN && h->nets[i].cidr[n]; i++) {
> -		if (j != -1) {
> +	for (i = 0, found = -1; i < nets->len; i++) {
> +		if (nets->nets[i].count)
> +			len++;
> +		if (found != -1) {
>  			continue;
> -		} else if (h->nets[i].cidr[n] < cidr) {
> -			j = i;
> -		} else if (h->nets[i].cidr[n] == cidr) {
> -			h->nets[CIDR_POS(cidr)].nets[n]++;
> +		} else if (nets->nets[i].cidr < cidr) {
> +			found = i;
> +		} else if (nets->nets[i].cidr == cidr) {
> +			nets->nets[i].count++;

[Severity: Low]
This isn't a bug on any supported architecture, but this increment (and
the matching decrement in mtype_del_cidr(), plus the bulk zeroing in the
mtype_flush() fallback) still mutates the already published object in
place, with plain stores and no WRITE_ONCE().

The lockless readers use plain loads of the same field:

	if (!nets0->nets[j].count)
		continue;

Since count now decides whether an entry is a live prefix or a hole, is it
worth annotating these accesses?  The commit message says the in-place
updating is replaced by an RCU based method, but that only covers the array
shape and ordering; the count field is still updated in place on the
published structure without going through rcu_assign_pointer().
Unchanged at the end of the series (3a0d9fd64b67).

>  			goto unlock;
>  		}
>  	}
> -	if (j != -1) {
> -		for (; i > j; i--)
> -			h->nets[i].cidr[n] = h->nets[i - 1].cidr[n];
> +	len++;
> +	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
> +	if (!tmp) {
> +		ret = -ENOMEM;
> +		goto unlock;
>  	}
> -	h->nets[i].cidr[n] = cidr;
> -	h->nets[CIDR_POS(cidr)].nets[n] = 1;
> +
> +	tmp->len = len;
> +	for (i = 0, j = 0; i < nets->len; i++) {
> +		if (i == found) {
> +			tmp->nets[j].cidr = cidr;
> +			tmp->nets[j++].count = 1;
> +		}
> +		if (!nets->nets[i].count)
> +			continue;
> +		tmp->nets[j].cidr = nets->nets[i].cidr;
> +		tmp->nets[j++].count = nets->nets[i].count;
> +	}
> +	if (found == -1) {
> +		tmp->nets[j].cidr = cidr;
> +		tmp->nets[j].count = 1;
> +	}
> +	rcu_assign_pointer(h->rnets[n], tmp);
> +	kfree_rcu(nets, rcu);
>  unlock:
>  	spin_unlock_bh(&set->lock);
> +	return ret;
>  }
>  
>  static void
>  mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
>  {
> -	u8 i, j, net_end = NLEN - 1;
> +	struct net_prefixes *nets, *tmp;
> +	u8 i, j, len = 0;
> +	int found;
>  
>  	spin_lock_bh(&set->lock);
> -	for (i = 0; i < NLEN; i++) {
> -		if (h->nets[i].cidr[n] != cidr)
> -			continue;
> -		h->nets[CIDR_POS(cidr)].nets[n]--;
> -		if (h->nets[CIDR_POS(cidr)].nets[n] > 0)
> -			goto unlock;
> -		for (j = i; j < net_end && h->nets[j].cidr[n]; j++)
> -			h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
> -		h->nets[j].cidr[n] = 0;
> +	nets = __ipset_dereference(h->rnets[n]);
> +	for (i = 0, found = -1; i < nets->len; i++) {
> +		if (nets->nets[i].count)
> +			len++;
> +		if (nets->nets[i].cidr == cidr)
> +			found = i;
> +	}
> +	if (unlikely(found == -1))
> +		goto unlock;
> +
> +	nets->nets[found].count--;
> +	if (nets->nets[found].count)

[Severity: Medium]
Can nets->nets[found].count be zero here, making this decrement underflow?

The match loop selects an entry by cidr only and ignores count, but the new
design deliberately keeps count == 0 entries around: the "Leave a hole"
fallback just below, and the mtype_flush() fallback which zeroes all counts
while keeping len and the stored cidr values.

If found points at such a hole, count is a u32 and becomes 0xffffffff, and
the following test:

	if (nets->nets[found].count)
		goto unlock;

then keeps the entry forever.  mtype_test_cidrs() probes it on every packet
and INIT_CIDR() can hand it out as the most specific prefix.

One way to reach the decrement of a zero count: mtype_flush() clears the
buckets first, a concurrent SET target add registers a cidr and inserts an
element, the flush fallback afterwards zeroes that count, and the later
delete of the still present element decrements zero.  The skew caused by the
ignored -ENOMEM of mtype_add_cidr() (see below) gets there as well.

Before this patch the flush path used memset(h->nets, 0, sizeof(h->nets)),
which also cleared the stored cidr values, so a stale cidr could not be
matched.  Would guarding the decrement with a count check, or matching on
count && cidr, be preferable?  Still present at the end of the series
(3a0d9fd64b67).

>  		goto unlock;
> +	len--;
> +	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
> +	if (!tmp)
> +		/* Leave a hole */
> +		goto unlock;
> +
> +	tmp->len = len;
> +	for (i = 0, j = 0; i < nets->len; i++) {
> +		if (!nets->nets[i].count || i == found)
> +			continue;
> +		tmp->nets[j].cidr = nets->nets[i].cidr;
> +		tmp->nets[j++].count = nets->nets[i].count;
>  	}
> +	rcu_assign_pointer(h->rnets[n], tmp);
> +	kfree_rcu(nets, rcu);
>  unlock:
>  	spin_unlock_bh(&set->lock);
>  }
> @@ -402,6 +433,9 @@ static void
>  mtype_flush(struct ip_set *set)
>  {
>  	struct htype *h = set->data;
> +#ifdef IP_SET_HASH_WITH_NETS
> +	struct net_prefixes *nets, *tmp;
> +#endif
>  	struct htable *t;
>  	struct hbucket *n;
>  	u32 r, i;
> @@ -425,7 +459,19 @@ mtype_flush(struct ip_set *set)
>  		spin_unlock_bh(&t->hregion[r].lock);
>  	}
>  #ifdef IP_SET_HASH_WITH_NETS
> -	memset(h->nets, 0, sizeof(h->nets));
> +	for (i = 0; i < IPSET_NET_COUNT; i++) {
> +		nets = ipset_dereference_nfnl(h->rnets[i]);
> +		tmp = kzalloc_obj(*tmp, GFP_ATOMIC);
> +		if (!tmp) {
> +			u8 j;
> +
> +			for (j = 0; j < nets->len; j++)
> +				nets->nets[j].count = 0;
> +		} else {
> +			rcu_assign_pointer(h->rnets[i], tmp);
> +			kfree_rcu(nets, rcu);
> +		}
> +	}
>  #endif
>  }

[Severity: Critical]
Does this replacement need set->lock?

mtype_add_cidr() and mtype_del_cidr() do the same read, publish and free
sequence under spin_lock_bh(&set->lock), but here only the nfnetlink mutex
is held.  For the hash types set->variant->region_lock is true, and
ip_set_lock() is then a no-op:

net/netfilter/ipset/ip_set_core.c:
static inline void
ip_set_lock(struct ip_set *set)
{
	if (!set->variant->region_lock)
		spin_lock_bh(&set->lock);
}

so ip_set_flush_set() -> mtype_flush() gets no serialization against the
cidr writers.  Those writers do not take the nfnl mutex either:

  SET target -> ip_set_add()/ip_set_del() -> kadt -> mtype_add()/mtype_del()
    -> mtype_add_cidr()/mtype_del_cidr()
  gc worker -> mtype_gc_do() -> mtype_del_cidr_all() -> mtype_del_cidr()

Can both sides then observe the same old pointer and each queue it?

CPU0 (ipset flush)                  CPU1 (SET target, softirq)
nets = ipset_dereference_nfnl(...)
                                    spin_lock_bh(&set->lock);
                                    nets = __ipset_dereference(h->rnets[n]);
rcu_assign_pointer(h->rnets[i], tmp)
kfree_rcu(nets, rcu);
                                    rcu_assign_pointer(h->rnets[n], tmp);
                                    kfree_rcu(nets, rcu);   /* same object */

That queues the same rcu_head twice, and the concurrent update is lost as
well.  The !tmp fallback above also writes nets->nets[j].count = 0 into an
object the other side may already have unpublished and passed to
kfree_rcu().

The pre-patch code did only memset(h->nets, 0, sizeof(h->nets)) in this
same unsynchronized spot, with no allocation and no freeing, so the memory
safety aspect looks new here.  The ipset_dereference_nfnl() annotation
suggests the nfnl mutex is sufficient; should this be set->lock based
instead?  This code is unchanged at the end of the series (3a0d9fd64b67).

[ ... ]

> @@ -996,7 +1048,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	t->hregion[r].elements++;
>  #ifdef IP_SET_HASH_WITH_NETS
>  	for (i = 0; i < IPSET_NET_COUNT; i++)
> -		mtype_add_cidr(set, h, NCIDR_PUT(DCIDR_GET(d->cidr, i)), i);
> +		mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
>  #endif
>  	memcpy(data, d, sizeof(struct mtype_elem));

[Severity: High]
mtype_add_cidr() changed from void to int and can now fail:

	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
	if (!tmp) {
		ret = -ENOMEM;
		goto unlock;
	}

Should this caller check the return value?  The memcpy() commits the
element unconditionally, so on allocation failure the element sits in the
bucket with no prefix registered in h->rnets[].

mtype_test_cidrs() only probes cidrs that are present with count != 0:

	for (j = 0; j < nets0->len && !multi; j++) {
		if (!nets0->nets[j].count)
			continue;

so does such an element become permanently unmatchable, while still being
listable and deletable?

A later delete of that element runs mtype_del_cidr() for the unregistered
cidr, and if other live elements share the same cidr their count is
decremented without a matching increment.  Can that count reach zero while
elements using the prefix remain, dropping the prefix out of the array and
stopping those elements from matching too?  mtype_resize() copies elements
only and does not rebuild the bookkeeping, so the skew looks permanent.

The add path is reachable from the packet path via the SET target
(ip_set_add() in softirq, hence GFP_ATOMIC), and unlike the delete path
there is no "leave a hole" style fallback and no rollback of the
per-dimension registrations that already succeeded.  This is unchanged at
the end of the series (3a0d9fd64b67).

[ ... ]
