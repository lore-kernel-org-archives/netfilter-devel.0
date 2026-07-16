Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BD43F54B6
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210211; cv=none; b=DpxvSgUPUTPdO7omY8/4RfvA2Szu6KloStBQZPN34KmhJOqyKI0zfP8qYuyaKHAHexZXcKIuWdam71hzIYjzEtloU2nnaNSfKW6GO+neFQd+AOBTiY2+KgK1srYwZT0STlShEOiqezdMcgpZxcysYfqT/PQi+v5OhK8OcyzSu4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210211; c=relaxed/simple;
	bh=VqK2+K4/2md1ROaa2IXI3vZT7FQP5XZlYaqoqht3guA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RdgAnrGv3tW50Jk6IPefDnHSOkId0pVhuvxK8ryy146ECOVBqi40Bm/sI2k+XUBJltH1YT0Gjr4nn/CqcTT4JGrGnDg24Sjl4fZexP4Eh5rrLlMrEli1fSbMKa+IFLp9TwCCHEKCqwK2ebKVML/CmocgG6OsvmQBAVL/0iRwTXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=fZbg+sCS; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="fZbg+sCS"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h1F2l2HGVzGFDCH;
	Thu, 16 Jul 2026 15:56:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1784210205; x=1786024606; bh=I5l2r6Ni27
	aJaJPL7VQv3DBkAp/GgS3HozzviZWDhC4=; b=fZbg+sCS3l7R1eDE6dmx+HVmC4
	qyKt25lo0uVRJQ5wNRs5NOiSBWHxLnyqyElymFKMNeDCOnRzaMZsSfYdCcAP8SDu
	TQsmTYv1fNJsSiVs2gQKwCPs+0sZpUOwvu9bvTbfd1GqiHBj+Ppv6BGrZ7y8OASG
	R3UOzYcfgpca2A/Ko=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id jJDexNkZvLuu; Thu, 16 Jul 2026 15:56:45 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4h1F2j2Ld3zGFDCG;
	Thu, 16 Jul 2026 15:56:45 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 4213D34316E; Thu, 16 Jul 2026 15:56:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 3F41634316D;
	Thu, 16 Jul 2026 15:56:45 +0200 (CEST)
Date: Thu, 16 Jul 2026 15:56:45 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 10/12] netfilter: ipset: use correct lockdep
 annotation in ipset_dereference
In-Reply-To: <20260714131828.10685-11-fw@strlen.de>
Message-ID: <dd822f91-400e-418a-d148-46c9b489af36@blackhole.kfki.hu>
References: <20260714131828.10685-1-fw@strlen.de> <20260714131828.10685-11-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Tue, 14 Jul 2026, Florian Westphal wrote:

> Avoid always-true arguments where possible, they defeat lockdep.
>
> ip_set_comment_free() is problematic: called from different contexts,
> some hold set->lock spinlock (safe), some do not hold a lock but have other
> means of mutual exclusion (e.g., entire set torn down).

Wouldn't something like the following be sufficient?

- Add a bool "deleted" element to struct ip_set.
- The set-specific destroy function would set it true before
   doing anything else.
- Then it'd be safe to use

#define ipset_dereference_locked(p, set)	\
 	rcu_dereference_protected(p, lockdep_is_held(&set->lock) || \
 				     set->deleted))

> Other callers need investigation: ip_set_comment_free() alters
> set->ext_size in a non-atomic way.  I don't see how this is safe except
> for "entire set is destroyed" case: parallel usage would be a bug.

Maybe we should convert ext_size to atomic64_t?

Best regards,
Jozsef
> Add a few lockdep assertions to ip_set_init_comment() callpaths to have
> more confidence in the correctness of the
> "Called from uadd only, protected by the set spinlock." comment at the
> start of ip_set_init_comment().
>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> include/linux/netfilter/ipset/ip_set.h | 3 +++
> net/netfilter/ipset/ip_set_core.c      | 3 +--
> net/netfilter/ipset/ip_set_hash_gen.h  | 6 ++----
> net/netfilter/ipset/ip_set_list_set.c  | 2 ++
> 4 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> index f9003ec21259..99bc997914f4 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -282,6 +282,9 @@ struct ip_set {
> 	void *data;
> };
>
> +#define ipset_dereference_locked(p, set)		\
> +	rcu_dereference_protected(p, lockdep_is_held(&set->lock))
> +
> static inline void
> __ip_set_destroy_comment(struct ip_set *set, void *data)
> {
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 6ece5cf305fe..a5f77f639d2a 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -346,8 +346,7 @@ void
> ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
> 		    const struct ip_set_ext *ext)
> {
> -	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c,
> -								 lockdep_is_held(&set->lock));
> +	struct ip_set_comment_rcu *c = ipset_dereference_locked(comment->c, set);
> 	size_t len = ext->comment ? strlen(ext->comment) : 0;
>
> 	if (unlikely(c)) {
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index a0f2cd481b82..e615de2e616b 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -11,8 +11,6 @@
> #include <linux/netfilter/nfnetlink.h>
> #include <linux/netfilter/ipset/ip_set.h>
>
> -#define __ipset_dereference(p)		\
> -	rcu_dereference_protected(p, 1)
> #define ipset_dereference_nfnl(p)	\
> 	rcu_dereference_protected(p,	\
> 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
> @@ -271,7 +269,7 @@ mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
> 	int i, j, found, len = 0, ret = 0;
>
> 	spin_lock_bh(&set->lock);
> -	nets = __ipset_dereference(h->rnets[n]);
> +	nets = ipset_dereference_locked(h->rnets[n], set);
> 	/* Add in increasing prefix order, so larger cidr first */
> 	for (i = 0, found = -1; i < nets->len; i++) {
> 		if (nets->nets[i].count)
> @@ -323,7 +321,7 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
> 	int found;
>
> 	spin_lock_bh(&set->lock);
> -	nets = __ipset_dereference(h->rnets[n]);
> +	nets = ipset_dereference_locked(h->rnets[n], set);
> 	for (i = 0, found = -1; i < nets->len; i++) {
> 		if (nets->nets[i].count)
> 			len++;
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> index d7ddc57a4eca..27bc96458e13 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -326,6 +326,8 @@ list_set_udel(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	struct set_adt_elem *d = value;
> 	struct set_elem *e, *n, *next, *prev = NULL;
>
> +	lockdep_assert_held(&set->lock);
> +
> 	list_for_each_entry_safe(e, n, &map->members, list) {
> 		if (SET_WITH_TIMEOUT(set) &&
> 		    ip_set_timeout_expired(ext_timeout(e, set)))
> -- 
> 2.54.0
>
>
>
