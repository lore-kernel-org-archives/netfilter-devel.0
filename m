Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CD23B0594
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 07:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335063; cv=none; b=YzvLisWBBpVEoYYVAlXPC6iaCdUAbXXlJ2bptTsbFGLaXpqFhQFUtxwaEl9AMCfwNheodtzWBOQigOLTErSSFNMl7NKVCVPYwk6Wxtq18eRHGNEqyRTBwR54V4g4Kl/+ONhF9GYO0VkSZ8mIGAIDgURQIc70N2mv0tk3Ia1/UFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335063; c=relaxed/simple;
	bh=lUEXN/cNnins6NCxbN6mJ0lPlyW/2bgCO+2TQmEP8uQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=A2FcuX1zlR+89CqaPEitNeI/rYKxmgX0BV1WmFCGU8oNxlQhJU7vooFLErkRFUxTBIUTPKRCFYAYIn1U9/BfSbmebNbl6k800E4BEl1NmeHcGgB2MKp0mFl1rWmRBfs+NzTUXEBp2seVpOdRos695Q0keyC7YspVH8CPG1tfTCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=NP6/E/Dn; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="NP6/E/Dn"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4hZZJv3brKzGFDCb;
	Wed, 02 Sep 2026 09:35:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1788334541; x=1790148942; bh=PjaPzGBA47
	GRcaJkFrJFDciCt6ozUVCqpBmydIZNOT8=; b=NP6/E/Dnk1WLocRhhtbKdq0Msb
	FHnf7eEtOWgyTAiA7k277U4kgMoesmvMoDPwP5V/L2vwVQO0xMdE8CfBdmO4HlN0
	xJssg/2kJiy7B5GlVcNkciswMDEm+Hq3fMfSgPUlWvW8f06qTKXhtHgA4pm8KJq0
	34+66uhsBpQNeQshc=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 3b-tOX7i7BP8; Wed,  2 Sep 2026 09:35:41 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4hZZJs3Sk8zGFDCN;
	Wed, 02 Sep 2026 09:35:41 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 63806340CFD; Wed, 02 Sep 2026 09:35:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 6111B340CFC;
	Wed, 02 Sep 2026 09:35:41 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:35:41 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH nf v3 3/5] netfilter: ipset: replace internal hash table
 with rhashtable
In-Reply-To: <apem1I-sJWVSfMT8@strlen.de>
Message-ID: <5d837288-85be-4c12-1889-44d193793f5c@blackhole.kfki.hu>
References: <20260828152256.8759-1-fw@strlen.de> <20260828152256.8759-4-fw@strlen.de> <apem1I-sJWVSfMT8@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Wed, 2 Sep 2026, Florian Westphal wrote:

> Florian Westphal <fw@strlen.de> wrote:
>> Assisted-by: Claude:claude-opus-4-6
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> ---
>>  v3:
>>  serialize rhltable insertion with set->lock, else we can inject identical elements.
>>  nit: also rename mtype_rht_size toke-replace
>>  add kdoc comment to say that mtype_flush cannot guarantee set is empty
>>  after flush (parallel re-add).
>>  I ignored the LLM review wrt 'skipped elements' on set walks, with
>>  parallel mutations (internal resizes, deletes) a stable walk would
>>  require significantly more work, such as keeping elements on a
>>  dedicated list.  It should be ok as-is.
>
> [..]
>
>> -/* Flush a hash type of set: destroy all elements */
>> +/**
>> + * mtype_flush() - Flush a hash set type by destroying all elements.
>> + * @set: Pointer to the ip_set.
>> + *
>> + * Because other CPUs may concurrently insert new entries into the table
>> + * while flush is in progress, there is no guarantee that the table will
>> + * be empty upon return.
>> + */
>>  static void
>>  mtype_flush(struct ip_set *set)
>>  {
>>  	struct htype *h = set->data;
>> -#ifdef IP_SET_HASH_WITH_NETS
>> -	struct net_prefixes *nets;
>> -#endif
>> -	struct htable *t;
>> -	struct hbucket *n;
>> -	u32 r, i;
>> -
>> -	t = ipset_dereference_nfnl(h->table);
>> -	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
>> -		spin_lock_bh(&t->hregion[r].lock);
>> -		for (i = ahash_bucket_start(r, t->htable_bits);
>> -		     i < ahash_bucket_end(r, t->htable_bits); i++) {
>> -			n = __ipset_dereference(hbucket(t, i));
>> -			if (!n)
>> +	struct rhashtable_iter hti;
>> +	struct mtype_rht_elem *e;
>> +	unsigned int dropped;
>> +
>> +	ipset_hash_walk_enter(h, &hti);
>> +restart:
>> +	dropped = 0;
>> +	rhashtable_walk_start(&hti);
>> +
>> +	while ((e = rhashtable_walk_next(&hti))) {
>> +		if (IS_ERR(e)) {
>> +			if (PTR_ERR(e) == -EAGAIN)
>>  				continue;
>> -			if (set->extensions & IPSET_EXT_DESTROY)
>> -				mtype_ext_cleanup(set, n);
>> -			/* FIXME: use slab cache */
>> -			rcu_assign_pointer(hbucket(t, i), NULL);
>> -			kfree_rcu(n, rcu);
>> +			break;
>> +		}
>> +		if (ipset_hash_remove(h, e))
>> +			continue; /* Concurrent delete? skip */
>> +		mtype_del_cidr_all(set, h, &e->elem);
>> +		ip_set_ext_destroy(set, &e->elem);
>> +		kfree_rcu(e, rcu);
>> +
>> +		if (dropped++ > 128 && need_resched()) {
>> +			rhashtable_walk_stop(&hti);
>> +			cond_resched();
>> +			goto restart;
>
> As expected this triggers reject patterns in LLM.
>
> I can go back to v1, which had no restart, which in turn triggered
> 'softirq lockup with large sets' reject patterns, but doesn't have
> the "may skip elements" "problem".
>
> Or we delay this while I work on an rhashtable_flush() that can
> detach internal hash memory from the rhashtable set to avoid this.
>
> I have no idea what the best course of action is here, but adding
> an extra data structure (list for instance) is something I want to
> avoid.

What do you think about swapping? Create a new empty set, swap with the 
one to be flushed and after the RCU grace period delete the swapped out 
set. As far as I see the only downside is that it requires successful 
memory allocation.

> All other LLM comments were, as far as I could tell, hallucinations.

Best regards,
Jozsef
