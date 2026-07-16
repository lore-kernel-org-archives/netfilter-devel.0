Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2797D3161AD
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210799; cv=none; b=pPZO8CWTMwaJbdDQA/jwDGxzvcfIcfT81yTzAUQEuqJUEH1ngtvQgYpc6goBmIVPcXOf8Fbzg4cx55ncJOLqtMNrIRW29bdsqjkGJ0KEX3kdCqtCa1xvEHrMSG/63RkSTH2xeOLlUX2wwfKiI2NCWho+6ikIlSakn3ETlQ/ZsOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210799; c=relaxed/simple;
	bh=3jlu7lSTQV+Ua4nM06U8iLtRK3zrAcHFWo4Zp472jzk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WmJcL2+PkIagl256N9n3+5uAFOpQjKdzZPztYy/f8WAfDbekdCTiIjWvJ/OhoglOR07+dKSpSF41c2UKBXg0DNJuqg6YCGqtmtGZyIy0CbgMTfhy6TEZxbHv89kVZh++s61ghuraJi533cM1lLeYqsOjZ7OL9Ih/wF8++2cpafE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=XQ4BIudy; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="XQ4BIudy"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4h1FG26vvpz3sb0L;
	Thu, 16 Jul 2026 16:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1784210793; x=1786025194; bh=Kt2gCzDPLs
	Mm2CFziLZHYEJcU3sJfbeYscV863lsyzE=; b=XQ4BIudy0dzM9MrpNjRA6CZ9Bj
	uFysha6hO40287LMUcup1Kec3tEPxQawbKfBvVQN39TZfvshkLZ44yXv0V/BJy5S
	yBbCQKyQZD9s2ZFzr130TVJ0MrttiVZE6FKmIN6nMrZ7QUqrIi04fKN1vdV9ZmCd
	Rx7pp4jwL8nV7+vQY=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id Js-iXM3qT1wc; Thu, 16 Jul 2026 16:06:33 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4h1FG102sVz3sb0K;
	Thu, 16 Jul 2026 16:06:32 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id E5B2034316E; Thu, 16 Jul 2026 16:06:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id E4F1534316D;
	Thu, 16 Jul 2026 16:06:32 +0200 (CEST)
Date: Thu, 16 Jul 2026 16:06:32 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 12/12] netfilter: ipset: re-add forceadd
 support for rhashtable
In-Reply-To: <20260714131828.10685-13-fw@strlen.de>
Message-ID: <2dd4a9a8-1667-7374-d934-15dc6c28035b@blackhole.kfki.hu>
References: <20260714131828.10685-1-fw@strlen.de> <20260714131828.10685-13-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Tue, 14 Jul 2026, Florian Westphal wrote:

> The rhashtable conversion removed the SET_WITH_FORCEADD eviction logic.
> Sets created with the forceadd flag got IPSET_ERR_HASH_FULL instead of
> evicting an existing element to make room.
>
> Add mtype_remove_random() helper that walks the rhashtable to pick an
> element to evict, and call it from mtype_add() when the set is full and
> forceadd is enabled.

I like it! This is a worst case scenario when we want to add a new entry 
by all means, so deleting a random entry is quite good. However, shouldn't 
mtype_remove_random() return success/failure? mtype_add() should add the 
new entry only if mtype_remove_random() succeeded.

Best regards,
Jozsef

> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/netfilter/ipset/ip_set_hash_gen.h | 43 +++++++++++++++++++++++----
> 1 file changed, 38 insertions(+), 5 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 12d3bc5acc81..df73c1ebb3f0 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -116,6 +116,7 @@ static const union nf_inet_addr zeromask = {};
> #undef mtype_bucket_size
> #undef mtype_hash_size
>
> +#undef mtype_remove_random
> #undef mtype_add
> #undef mtype_del
> #undef mtype_test_cidrs
> @@ -165,6 +166,7 @@ static const union nf_inet_addr zeromask = {};
> #define mtype_bucket_size	IPSET_TOKEN(MTYPE, _bucket_size)
> #define mtype_hash_size		IPSET_TOKEN(MTYPE, _hash_size)
>
> +#define mtype_remove_random	IPSET_TOKEN(MTYPE, _remove_random)
> #define mtype_add		IPSET_TOKEN(MTYPE, _add)
> #define mtype_del		IPSET_TOKEN(MTYPE, _del)
> #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
> @@ -511,6 +513,33 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
> 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
> }
>
> +/* Evict one element from the set to make room for a new one (forceadd) */
> +static void __maybe_unused
> +mtype_remove_random(struct ip_set *set, struct htype *h)
> +{
> +	struct rhashtable_iter hti;
> +	struct mtype_rht_elem *e;
> +	bool removed = false;
> +
> +	rhashtable_walk_enter(&h->ht, &hti);
> +	rhashtable_walk_start(&hti);
> +	e = rhashtable_walk_next(&hti);
> +	if (IS_ERR(e))
> +		e = NULL;
> +
> +	if (e && !rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params))
> +		removed = true;
> +
> +	rhashtable_walk_stop(&hti);
> +	rhashtable_walk_exit(&hti);
> +
> +	if (removed) {
> +		mtype_del_cidr_all(set, h, &e->elem);
> +		ip_set_ext_destroy_slow(set, &e->elem);
> +		kfree_rcu(e, rcu);
> +	}
> +}
> +
> /* Add an element to a hash and update the internal counters when succeeded,
>  * otherwise report the proper error code.
>  */
> @@ -573,11 +602,15 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	rcu_read_unlock();
>
> 	if (atomic_read(&h->ht.nelems) >= h->maxelem) {
> -		if (net_ratelimit())
> -			pr_warn("Set %s is full, maxelem %u reached\n",
> -				set->name, h->maxelem);
> -		mtype_data_next(&h->next, d);
> -		return -IPSET_ERR_HASH_FULL;
> +		if (SET_WITH_FORCEADD(set)) {
> +			mtype_remove_random(set, h);
> +		} else {
> +			if (net_ratelimit())
> +				pr_warn("Set %s is full, maxelem %u reached\n",
> +					set->name, h->maxelem);
> +			mtype_data_next(&h->next, d);
> +			return -IPSET_ERR_HASH_FULL;
> +		}
> 	}
>
> 	e = kzalloc(offsetof(struct mtype_rht_elem, elem) + set->dsize,
> -- 
> 2.54.0
>
>
>
