Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B81399019
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690692; cv=none; b=pf7UUjH9MsjXunV9dNeS5FAQCeCaWqUkMgnnhF/lGo60C6YSpQ5ksn0W66h6maMRfQQsmUWjsAevnnzunrXoIDdWveMb0DunjHOU1MzqzvawiMCZCj/38zVU5wImS8xOuDkqYrDaVOKsLKOAeJmxwv7IpEx7R1CAkXmxOrj6KF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690692; c=relaxed/simple;
	bh=6X9w+a1doJSDKdQBjPF0L27atXhSk1iynvIRjrh6O7o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EgBD9fC1NVFD6JKygSddq/DYbPuSO6mGbH0uw+HDf6BGZUATDTB4u951/tJkMcf/8D0bZAVhiC2yG38gcQ2gjV84eA63PVTSP6WLJu280F2SidmvjW7qmB3XnrdnISXpWCV9/yRE7O45DcFmRyXOmkXbxMPIkSzi2NCv5vlX6A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=oM/3mySC; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="oM/3mySC"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fzm8V25yYz7s85C;
	Mon, 20 Apr 2026 15:11:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1776690680; x=1778505081; bh=aVfqHj2Jyw
	BWpt+gfxLGgQSvAZL4GsZ86QxpWgIr+yo=; b=oM/3mySCUgVhjLdBkL5S9MCcHO
	l5g7ZLdEzm2sbwtsyk7VU/JIRe+cRMThHfAi9EqlIYFO9sxXPo49JGeDAfojW/F0
	8SRDuyqs62Q5GjmCu52a/fohkcwnzb+xMRpsykPP8y78CkpjR7RkySfB6vsxq7I0
	62mVKxzNb1F08/3W8=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id AaIniT8gAok0; Mon, 20 Apr 2026 15:11:20 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fzm8S17fBz7s856;
	Mon, 20 Apr 2026 15:11:20 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 1B75334316A; Mon, 20 Apr 2026 15:11:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 1976F340D75;
	Mon, 20 Apr 2026 15:11:20 +0200 (CEST)
Date: Mon, 20 Apr 2026 15:11:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org, 
    Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: ipset: Fix data race between add and dump
 in all hash types
In-Reply-To: <ad9mzYNk5JpDfklg@strlen.de>
Message-ID: <4e01c555-2f4c-81b7-e6c4-d1f7b3e2e99f@blackhole.kfki.hu>
References: <20260415082039.4133308-1-kadlec@netfilter.org> <20260415082039.4133308-3-kadlec@netfilter.org> <ad9mzYNk5JpDfklg@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Wed, 15 Apr 2026, Florian Westphal wrote:

>>  	data = ahash_data(n, j, set->dsize);
>>  copy_data:
>>  	t->hregion[r].elements++;
>> @@ -985,6 +986,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>>  	if (SET_WITH_TIMEOUT(set))
>>  		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
>>  	smp_mb__before_atomic();
>> +	n->pos = npos;
>>  	set_bit(j, n->used);
>
> I think this needs a followup-patch to switch this to smp_store_release
> and readers to smp_load_acquire helpers.

I'm pondering over the helpers and unsure. The hash bucket structure is as 
follows:

/* A hash bucket */
struct hbucket {
         struct rcu_head rcu;    /* for call_rcu */
         /* Which positions are used in the array */
         DECLARE_BITMAP(used, AHASH_MAX_TUNED);
         u8 size;                /* size of the array */
         u8 pos;                 /* position of the first free entry */
         unsigned char value[]   /* the array of the values */
                 __aligned(__alignof__(u64));
};

The elements in "value" are filled up successively, "pos" is there to 
limit the searching range for existing elements (which might be timed out 
as well). So until the "size" is unchanged (no growing/shrinking), the 
worst things which can happen if it's not "correct":

- new element added but dump/test don't "find" it
- element deleted but dump/test find it

The critical part is when "size" changes. But "size" never updated 
directly: a completely new bucket is created when growing/shrinking and 
the new bucket is assigned via RCU mechanism.

So why do you thing the helpers are required to read/update the "pos" 
element of the hash bucket? I might not see the wood for the trees.

Best regards,
Jozsef

> Here is a diff for this (generated by LLM and only compile tested).
> I think this can be a separate patch to not make this change too big and
> to not mix different fixes.
>
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 0da02a8dfbae..2ca674e51699 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -682,10 +682,13 @@ mtype_resize(struct ip_set *set, bool retried)
> 		rcu_read_lock_bh();
> 		for (i = ahash_bucket_start(r, orig->htable_bits);
> 		     i < ahash_bucket_end(r, orig->htable_bits); i++) {
> +			u8 pos;
> +
> 			n = __ipset_dereference(hbucket(orig, i));
> 			if (!n)
> 				continue;
> -			for (j = 0; j < n->pos; j++) {
> +			pos = smp_load_acquire(&n->pos);
> +			for (j = 0; j < pos; j++) {
> 				if (!test_bit(j, n->used))
> 					continue;
> 				data = ahash_data(n, j, dsize);
> @@ -817,10 +820,13 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
> 	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
> 		for (i = ahash_bucket_start(r, t->htable_bits);
> 		     i < ahash_bucket_end(r, t->htable_bits); i++) {
> +			u8 pos;
> +
> 			n = rcu_dereference_bh(hbucket(t, i));
> 			if (!n)
> 				continue;
> -			for (j = 0; j < n->pos; j++) {
> +			pos = smp_load_acquire(&n->pos);
> +			for (j = 0; j < pos; j++) {
> 				if (!test_bit(j, n->used))
> 					continue;
> 				data = ahash_data(n, j, set->dsize);
> @@ -963,7 +969,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	}
>
> copy_elem:
> -	j = npos = n->pos + 1;
> +	j = npos;
> +	npos = n->pos + 1;
> 	data = ahash_data(n, j, set->dsize);
> copy_data:
> 	t->hregion[r].elements++;
> @@ -985,8 +992,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	/* Must come last for the case when timed out entry is reused */
> 	if (SET_WITH_TIMEOUT(set))
> 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
> -	smp_mb__before_atomic();
> -	n->pos = npos;
> +	/* Ensure all data writes are visible before updating position */
> +	smp_store_release(&n->pos, npos);
> 	set_bit(j, n->used);
> 	if (old != ERR_PTR(-ENOENT)) {
> 		rcu_assign_pointer(hbucket(t, key), n);
> @@ -1172,6 +1179,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
> 	int ret, i, j = 0;
> #endif
> 	u32 key, multi = 0;
> +	u8 pos;
>
> 	pr_debug("test by nets\n");
> 	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
> @@ -1189,7 +1197,8 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
> 		n = rcu_dereference_bh(hbucket(t, key));
> 		if (!n)
> 			continue;
> -		for (i = 0; i < n->pos; i++) {
> +		pos = smp_load_acquire(&n->pos);
> +		for (i = 0; i < pos; i++) {
> 			if (!test_bit(i, n->used))
> 				continue;
> 			data = ahash_data(n, i, set->dsize);
> @@ -1223,6 +1232,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	struct mtype_elem *data;
> 	int i, ret = 0;
> 	u32 key, multi = 0;
> +	u8 pos;
>
> 	rcu_read_lock_bh();
> 	t = rcu_dereference_bh(h->table);
> @@ -1245,7 +1255,8 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 		ret = 0;
> 		goto out;
> 	}
> -	for (i = 0; i < n->pos; i++) {
> +	pos = smp_load_acquire(&n->pos);
> +	for (i = 0; i < pos; i++) {
> 		if (!test_bit(i, n->used))
> 			continue;
> 		data = ahash_data(n, i, set->dsize);
> @@ -1373,6 +1384,8 @@ mtype_list(const struct ip_set *set,
> 	rcu_read_lock();
> 	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
> 	     cb->args[IPSET_CB_ARG0]++) {
> +		u8 pos;
> +
> 		cond_resched_rcu();
> 		incomplete = skb_tail_pointer(skb);
> 		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
> @@ -1380,7 +1393,9 @@ mtype_list(const struct ip_set *set,
> 			 cb->args[IPSET_CB_ARG0], t, n);
> 		if (!n)
> 			continue;
> -		for (i = 0; i < n->pos; i++) {
> +		/* Acquire ordering with smp_store_release in mtype_add */
> +		pos = smp_load_acquire(&n->pos);
> +		for (i = 0; i < pos; i++) {
> 			if (!test_bit(i, n->used))
> 				continue;
> 			e = ahash_data(n, i, set->dsize);
>
>
>
