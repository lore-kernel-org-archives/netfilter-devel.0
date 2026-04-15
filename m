Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ADA328B5E
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 10:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776249223; cv=none; b=oXFY/L6PSaQXtHb85QOqDxiiMQL0CIddGBwLQNlrkC2Ya8LiP3BeHj6N2Lr6iwAo5cHtuvn0/0sdNnnOi7mUcpStZtm2IUpzf6+vV7LodhUNSjgQ4uFy6iFmXo1RCreOtnLKFvJ3TOu+StoDlQUXRX7fIF/OaehjpmBVk4WKFj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776249223; c=relaxed/simple;
	bh=GEztm2x3YJlz7eFkN2ag2hM5gd04XoP7eVga1xtupJU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DS1bKOg3pm+3GHId1scy9hR4UURk/sPJFOjnWE+IdPBnXA6rkkD1m+Al0kG/MZ2Zxpp7Svde6QiO1ZMmU16Weaw+6Wj/XglhUIjnJhL1OLM42YyLI27oybIyOackHtat/pV313cuQYpyzB4E+owu9Fps5gunID1tgvcIr1Cq16k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=o9gWWUjy; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="o9gWWUjy"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4fwctp51CpzGFDMM;
	Wed, 15 Apr 2026 12:33:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1776249216; x=1778063617; bh=24m1BNrb0V
	10LOtLF8eYd7yYZKEWgrXt9M3fhqFO2aQ=; b=o9gWWUjyCNq4DPJ7hsFW1BV+JS
	Za4xTbrof0jysuQgXjvh7DcxfX45fxsXe0sjkWWQop4xna6ioXp5YDlc1SZ7Af17
	AT+9YbFvWc5ysGiJQmw34cUQI3f1/lyBg+c8sYpo5QelIhNMhcxkbaO05IOz/8zQ
	mvDuIS72599Z+APCY=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id RToBENkFv7JE; Wed, 15 Apr 2026 12:33:36 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4fwctm5XqBzGFDM6;
	Wed, 15 Apr 2026 12:33:36 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id AEEC334316A; Wed, 15 Apr 2026 12:33:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id AD1A5340D75;
	Wed, 15 Apr 2026 12:33:36 +0200 (CEST)
Date: Wed, 15 Apr 2026 12:33:36 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org, 
    Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: ipset: Fix data race between add and dump
 in all hash types
In-Reply-To: <ad9mzYNk5JpDfklg@strlen.de>
Message-ID: <93dd963e-7577-83a5-244f-f19f49ddcd78@blackhole.kfki.hu>
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

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>> When adding a new entry to the next position in the existing hash bucket,
>> the position index was incremented too early and parallel dump could
>> read it before the entry was populated with the value. Move the setting
>> of the position index after populating the entry.
>>
>> Reported-by: syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com
>> Reported-by: syzbot+1da17e4b41d795df059e@syzkaller.appspotmail.com
>> Reported-by: syzbot+421c5f3ff8e9493084d9@syzkaller.appspotmail.com
>> Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
>> ---
>>  net/netfilter/ipset/ip_set_hash_gen.h | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
>> index b79e5dd2af03..0da02a8dfbae 100644
>> --- a/net/netfilter/ipset/ip_set_hash_gen.h
>> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
>> @@ -844,7 +844,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>>  	const struct mtype_elem *d = value;
>>  	struct mtype_elem *data;
>>  	struct hbucket *n, *old = ERR_PTR(-ENOENT);
>> -	int i, j = -1, ret;
>> +	int i, j = -1, npos = 0, ret;
>>  	bool flag_exist = flags & IPSET_FLAG_EXIST;
>>  	bool deleted = false, forceadd = false, reuse = false;
>>  	u32 r, key, multi = 0, elements, maxelem;
>> @@ -889,6 +889,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>>  			ext_size(AHASH_INIT_SIZE, set->dsize);
>>  		goto copy_elem;
>>  	}
>> +	npos = n->pos;
>>  	for (i = 0; i < n->pos; i++) {
>>  		if (!test_bit(i, n->used)) {
>>  			/* Reuse first deleted entry */
>> @@ -962,7 +963,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>>  	}
>>
>>  copy_elem:
>> -	j = n->pos++;
>> +	j = npos = n->pos + 1;
>
> Hmm. Should that be:
> +	j = npos;
> +	npos = n->pos + 1;
>
> As-is j is advanced by 1 compared to old code.
>
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

Your comments are sharp, thanks! I'd better resend the batch in a new 
version.

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
