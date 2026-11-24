Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531187;
	b=M26T7SCo+IZdxtjDGq21MGjWPYKJOYNQU9QTbQ463txMTt6SaFYawVXtw3O+mGkbGjDJ
	 nqqVM3QrWMI7TjXL6KXngdAXsNEQDQI3E2MfnzDek3tPn4ZXiHz41qGaT4tiQr7dawuon
	 ZkWBh/lZpxfFA+MaXubDp/ZnHUtmI7Io+uLSJ3MuAvqLVossAvg/XIOGZ5y9WcwXRGhdB
	 ZZ7m5vdW27/cvay90YmGh+EScaNt6vTAoogcjw3Dxd9uFDVlD86XsQMrDMXcKrqN8nmYm
	 FiykMpT8jGIcJ6y5u4zS7uIVOJqgXTGMTck6U4eRbCoWHkagNUYsP+ldc8rDXYux10w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531187;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=u9h6h9Khj9lXZfCN0/yBUtpeb17FBYHy8YuOgjtgFjo=;
	b=sqk7tWr21Z6fmOJTX/VsEc4b18TIBkh2Ne/bAr5FTbfII87ysV+k2OvFlW7dlUtW4IBW
	 1D5AgRJYKaYEvm8l8Rb+RTbQn/P0Au8uCB+oFOWN2FUsXBrxSM4VgrpW39Y+2QfjQdVb6
	 N7uV7SAeqs1V+dQgD5Fq0IVRhbVHL0m1AQcz/sHxnrAaFYX+spU7fnHkRLBBo69wdZ/YQ
	 HbPiWGU5dWVJMrZ/NfyFskQaIyqfKxayoMLgDW7pmrCFFGab07uUNJe5LzprTa2Iap8v6
	 vCcZJ/4EnTXDFBJti2/UHxOoxNKtxFr2lHDNdshe54u6gR78gMhvOUCRMxYwpctAi1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="m5oBTfU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E79606A69B;
	Tue, 24 Nov 2026 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5oBTfU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C351F000E0;
	Tue, 24 Nov 2026 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531187;
	bh=u9h6h9Khj9lXZfCN0/yBUtpeb17FBYHy8YuOgjtgFjo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=m5oBTfU/Gecr1HzQlCHA5us8LCB7KvT3oHx+zAM5M+FE52JmibSJ3EHoYG5WdeL5c
	 llE8hdm6aFqqSA6bIiMZ6VjM/eBwgOw8/wOa5gpXEKPuC55mXMVo2NZp0eBIxyXire
	 hHpveVgN28dFy50PYTESKwWVuJwYVvBakAnQIq8wQ1XvAJozmzJjE4qetS92gDx3Z5
	 v4RgWm7Wan2RkK++Q+5kPny4ne7JoXKcBonlPf/pobVceFnuxsIi1eDWVrPX8u2g/i
	 Ny2t1VJ2Cyq/oe0klqu4maSemzDaAZ9b+JGZzMBAeVJI6SqwaPw2Xpi39Wo8UB1YUY
	 iSfFtCSzZKIlw==
Subject: Re: [PATCH net-next 14/15] netfilter: ipset: re-add
 IP_SET_HASH_WITH_MULTI support
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:46 +0000
Message-ID: <179553118607.3135.12377785999784372927@kernel.org>
In-Reply-To: <20261123135726.3940688-15-pablo@netfilter.org>
References: <20261123135726.3940688-15-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 3 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In net/netfilter/ipset/ip_set_hash_gen.h, mtype_group_find()
  (used by mtype_del()) and mtype_group_test() choose the wrong element…
- [Medium] The commit message does not disclose a user-visible change to
  hash:net,iface add semantics compared with released kernels, and the…
- [Medium] mtype_group_list() resumes a paused group by element identity
  in two separate lockless RCU passes over grp->iface_list.
- [Medium] In the IP_SET_HASH_WITH_MULTI path of mtype_add(), the group
  is allocated and hashed before the maxelem limit is checked.
- [Low] The comment at the mtype_group_test() call site in
  mtype_test_cidrs() does not match the implementation.

--

netfilter: ipset: re-add IP_SET_HASH_WITH_MULTI support

This commit reimplements the hash:net,iface set type on top of
rhashtable. Each net/cidr/physdev key maps to a struct mtype_group, which
owns an RCU-protected list of elements that differ by interface name.
Exact elements get priority over wildcard elements in del and test, and
each group is capped at IPSET_GROUP_MAX_ENTRIES elements.

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index e7f2e584a7a50..39ef51c44df87 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h

[ ... ]

> @@ -454,6 +567,164 @@ mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem
>  #endif
>  }
>  
> +#ifdef IP_SET_HASH_WITH_MULTI

[ ... ]

> +static struct mtype_group *
> +mtype_group_get_or_create(struct htype *h, const struct mtype_elem *d, int *errp)
> +{

[ ... ]

> +	grp = kzalloc(sizeof(*grp), GFP_ATOMIC);
> +	if (!grp) {
> +		*errp = -ENOMEM;
> +		return NULL;
> +	}
> +	INIT_HLIST_HEAD(&grp->iface_list);
> +	spin_lock_init(&grp->lock);
> +	memcpy(&grp->key, d, sizeof(grp->key));
> +
> +	spin_lock_bh(&grp->lock);
> +	err = rhashtable_lookup_insert_key(&h->ht, d, &grp->node, mtype_group_rht_params);

[Severity: Medium]
Once the set has reached maxelem, does every add for a new key still
allocate and hash a group here before it gets rejected?

The maxelem check only runs later, in mtype_new_elem():

mtype_add()
  mtype_group_get_or_create()    kzalloc(GFP_ATOMIC), rhashtable insert
  mtype_new_elem()               returns -EMFILE
  mtype_group_unlock()           rhashtable_remove_fast(), kfree_rcu(grp)

Take a full hash:net,iface set and a rule using the SET target with
--add-set. Each packet with a new source address would then cost a
GFP_ATOMIC allocation in softirq, an insert/remove pair on h->ht and an
RCU callback.

The non-multi path returns -EMFILE from mtype_new_elem() before any
kzalloc().

Could the maxelem check run before a new group is created?

[ ... ]

> +/**
> + * mtype_group_find() - pick the element a non-wildcard request affects
> + * @set: Pointer to the ip_set.
> + * @grp: Group to search, with @grp->lock held
> + * @d: Lookup key (net/cidr/physdev and interface)
> + *
> + * An exact (non-wildcard) element always takes priority over a wildcard
> + * element, independent of @grp's list order. Must be called with
> + * @grp->lock held: the result is only valid as long as the lock prevents
> + * a concurrent mtype_add() from linking a higher-priority element into
> + * @grp after this scan but before the caller acts on its result.
> + *
> + * Intentionally does not use mtype_data_isequal() (strict identity,
> + * including @d's wildcard flag): "ipset del" must be able to remove a
> + * wildcard element even if @d->wildcard is false.
> + *
> + * Return: the matching element, or NULL.
> + */
> +static struct mtype_rht_elem *
> +mtype_group_find(struct ip_set *set, struct mtype_group *grp, const struct mtype_elem *d)
> +{
> +	struct mtype_rht_elem *e, *best = NULL;
> +
> +	lockdep_assert_held(&grp->lock);
> +
> +	hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
> +		if (!mtype_data_equal(&e->elem, d) ||
> +		    SET_ELEM_EXPIRED(set, &e->elem))
> +			continue;
> +		if (mtype_data_isexact(&e->elem))
> +			return e;
> +		if (!best)
> +			best = e;
> +	}
> +	return best;
> +}

[Severity: High]
Does mtype_group_find() pick the right element when a group holds
overlapping entries?

mtype_add() now deduplicates with mtype_data_isequal(). One group can
therefore hold an exact "eth" together with a wildcard "eth+", or two
overlapping wildcards such as "et+" and "eth+". The array code rejected
both combinations with IPSET_ERR_EXIST.

For "ipset del S NET,eth+", hash_netiface4_uadt() sets e.wildcard = 1
and iface = "eth", and mtype_del() passes that request here unchanged.
The stored exact "eth" passes mtype_data_equal() (strcmp("eth", "eth")
== 0) and mtype_data_isexact(), so it is returned and removed. The "eth+"
the user named stays in the set.

If "et+" was added before "eth+", the same del matches "et+" first
(strncmp("et", "eth", 2) == 0). "et+" becomes best and is removed
instead of "eth+".

mtype_group_test() depends on list order in the same way. For a packet
on eth0 with no exact element, its second loop returns the first
wildcard in insertion order:

	hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
		if (e == exact || SET_ELEM_EXPIRED(set, &e->elem) ||
		    !mtype_data_equal(&e->elem, d))
			continue;
		ret = mtype_data_match(&e->elem, ext, mext, set, flags);
		if (ret)
			return ret;
	}

So an "eth+ nomatch" added after "et+" never applies, but it does apply
when it is added first.

The commit message says:

    mtype_del() must not remove a wildcard element instead of
    the specific element named in the request.

It also says the precedence is "independent of list order". The
kernel-doc above says the helper picks "the element a non-wildcard
request affects", yet mtype_del() also calls it for wildcard requests.

Should mtype_group_find() check for an mtype_data_isequal() match before
falling back to pattern matching? Should wildcard-vs-wildcard precedence
in mtype_group_test() also be independent of insertion order?

[ ... ]

> @@ -779,6 +1095,61 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	int ret = 0;
>  
>  	rcu_read_lock_bh();
> +#ifdef IP_SET_HASH_WITH_MULTI
> +	{
> +		struct mtype_group *grp;
> +		unsigned int seen = 0;
> +
> +		grp = mtype_group_get_or_create(h, d, &ret);
> +		if (!grp)
> +			goto out_rcu_unlock;
> +
> +		old = NULL;
> +		hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
> +			if (SET_ELEM_EXPIRED(set, &e->elem)) {
> +				mtype_group_remove_elem(set, h, grp, e);
> +				continue;
> +			}

[ ... ]

> +			if (mtype_data_isequal(&e->elem, d)) {
> +				old = e;
> +				break;
> +			}

[Severity: Medium]
Is this change in add semantics intended? The array-based implementation
did this in mtype_add():

		if (mtype_data_equal(data, d, &multi)) {
			if (flag_exist || SET_ELEM_EXPIRED(set, data)) {
				/* Just the extensions could be overwritten */
				j = i;
				goto overwrite_extensions;
			}
			ret = -IPSET_ERR_EXIST;
			goto unlock;
		}

With "X,eth+" stored, "ipset add S X,eth0" failed with IPSET_ERR_EXIST.
With -exist, it refreshed the wildcard element's extensions instead.

With mtype_data_isequal(), the same request now silently creates a
second element. That changes element counts, maxelem accounting and
ipset save output for existing rule sets.

mtype_del() still matches by prefix through mtype_group_find(), so add
and del now disagree about identity. "add X,eth0" treats eth0 as absent,
but "del X,eth0" with no exact eth0 present removes the unrelated
"X,eth+".

The subject "re-add IP_SET_HASH_WITH_MULTI support" suggests the
original semantics come back. Should the commit message describe this
change, or should add keep the old behaviour?

> +			++seen;
> +		}

[ ... ]

> @@ -923,13 +1401,25 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  #else
>  		mtype_data_netmask(d, p0.cidr);
>  #endif
> +#ifdef IP_SET_HASH_WITH_MULTI
> +		/* mtype_group_test() sets @stop itself: the outer loop
> +		 * stops here when some other interface's entry is
> +		 * registered at this netmask, but still falls through if
> +		 * nothing here matches our interface at all, or if it did
> +		 * but got filtered by its extensions (e.g. timed out).
> +		 */
> +		ret = mtype_group_test(h, d, &stop, ext, mext, set, flags);

[Severity: Low]
This isn't a bug, but does this comment match mtype_group_test()? It
skips expired elements before it sets any_live or iface_live:

	if (SET_ELEM_EXPIRED(set, &e->elem))
		continue;
	any_live = true;
	if (!mtype_data_equal(&e->elem, d))
		continue;
	iface_live = true;

A timed-out element for our interface therefore never sets iface_live.
If a live element for another interface exists at the same prefix, stop
is set and broader prefixes are not tried. The "e.g. timed out" case
described here does not fall through.

[ ... ]

> @@ -1074,6 +1580,84 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)

[ ... ]

> + * Resuming by element identity (mtype_data_isequal(), rather than a
> + * plain position count) keeps the resume point correct even if a
> + * concurrent mtype_del() removes an earlier, already dumped element
> + * from @grp's iface_list while the dump was paused: entries are only
> + * ever appended at the tail, so no concurrent insert can land before
> + * the resume point either. If the previously emitted element itself
> + * was removed in the meantime, there is no reliable resume point left,
> + * so this group is instead dumped again from the start, i.e. userspace
> + * will see duplicates rather than skipping entries.
> + *
> + * Return: 0 once @grp is fully dumped, -EMSGSIZE if an element didn't fit.
> + */
> +static int
> +mtype_group_list(const struct ip_set *set, struct mtype_group *grp,
> +		 struct sk_buff *skb, u32 *emitted, struct mtype_list_iter *iter)
> +{
> +	struct mtype_rht_elem *e;
> +	struct nlattr *nested;
> +	bool skipping = false;
> +	void *incomplete;
> +
> +	if (iter->have_last) {
> +		hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
> +			if (mtype_data_isequal(&e->elem, &iter->last)) {
> +				skipping = true;
> +				break;
> +			}
> +		}
> +	}
> +
> +	hlist_for_each_entry_rcu(e, &grp->iface_list, node) {
> +		if (skipping) {
> +			if (mtype_data_isequal(&e->elem, &iter->last))
> +				skipping = false;
> +			continue;
> +		}

[Severity: Medium]
Can this leave live elements out of the dump?

The two passes over grp->iface_list are lockless RCU walks. There is no
grp->lock, generation counter or NLM_F_DUMP_INTR between them.

iter->last can be unlinked between pass 1 and pass 2, by gc, a del, a
kernel-side --del-set, or mtype_add() reaping an expired entry. Pass 2
then never finds it, so skipping stays true for the rest of the list.
Nothing is emitted and 0 is returned. mtype_list() then moves past the
group:

	if (mtype_group_list(set, grp, skb, &emitted, iter))
		goto paused;
	...
	grp = rhashtable_walk_next(hti);

so the remaining elements of this group are never dumped.

There is also a case that needs no tight race. Take a group [A, B, C, D]
with the dump paused after B. If B expires and is re-added from the
packet path between two recvmsg calls, mtype_add() removes the expired
B and appends the new copy at the tail:

	[A, C, D, B']

On resume, pass 1 finds B' through mtype_data_isequal(), and pass 2 then
skips A, C, D and B'. C and D were present for the whole dump but are
never emitted.

This contradicts the kernel-doc above ("no concurrent insert can land
before the resume point", "userspace will see duplicates rather than
skipping entries"). Would holding grp->lock across both passes, or a
generation counter with NLM_F_DUMP_INTR, address this?

> +
> +		if (SET_ELEM_EXPIRED(set, &e->elem))
> +			continue;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
