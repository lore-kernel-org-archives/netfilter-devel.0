Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99D437BE9F;
	Fri,  4 Sep 2026 02:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487310; cv=none; b=UlZRu0Oubugp6bZvUm4bwqBsO04MqfH/W6erV6iePiuLPrkxTW1/VxIjljTKaK/1kLy8EJmWDdIpLGKVpq7tCY4XOxxe5waAaH45d8EhyKucuFV3+YoSjjkRREOovX3tvTETMgB3BhxcQrxzW/1DCUKfUuHsU/bqsRF/VAcE3RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487310; c=relaxed/simple;
	bh=hi1dzW28asLaA45TMukwaGQCsiuqSEEuyVQIzem+0Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plb10qSJTuBgoejzehTuU0+9xtJp41mHo+LNFk6n6q3+qB1/WKf0NJXpLIWcWxYwo5yXIJe/SntK8fMWNH4eLHcyyc4zP32fD6wyDvM5yVkPeEJnxbtqxik3DpLZovSB29pSP+EJa2hGpIL48V4i60OXlA6XT9aAWgTpr6ULbPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gatZT6FL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gatZT6FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A9E1F000E9;
	Fri,  4 Sep 2026 02:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487308;
	bh=SjzWGTs/gThMP0YOXrb9dBIISNJJz2x+tIcCydeFXyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gatZT6FLWVSHRkb4YT8PXUM87mBhjY+IXaPjD7gb6YuOnUGQdGBKWS8r7QaMjgWur
	 gq6Riovb7wONBAYPbLtbqvgeRpuPZvdiMzOCk7+vBpgrn8z2vGnEJBzWx650liFxlC
	 8qHcjXyQlTJqjpLmfqqeSTgFTKqK6Yp4mNavAWof9OYWVlb0x4fTBB0cGcVZrnXROt
	 wT3wxwexiObfh+KWbCwPTkonmDq98xEf49tZDyQUOaS28f/hVqAxQNPZXPuDwzg0fM
	 n9CHTatKgWlIMNRhjL1ypyuiJyLkwqn8F8zQKPudH+YkNlOA3kwjOjp/GFsCI7wCYF
	 aKOyaCY5+KOzA==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 06/12] ipvs: bound LBLCR and LBLC cache growth
Date: Thu,  3 Sep 2026 19:01:40 -0700
Message-ID: <20260904020140.3549818-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903004149.1037028-7-pablo@netfilter.org>
References: <20260903004149.1037028-7-pablo@netfilter.org>
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
ipvs: bound LBLCR and LBLC cache growth

This adds a hard admission limit to ip_vs_lblc_new() and
ip_vs_lblcr_new(), rejecting new cache entries once atomic_read(&tbl->entries)
reaches max_size * 3 / 2.  The stated intent is to leave headroom so the
periodic collector can catch up while the scheduler fallback keeps serving
traffic.

> diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
> index 693bcc82ccb7..8180a7ba9f53 100644
> --- a/net/netfilter/ipvs/ip_vs_lblc.c
> +++ b/net/netfilter/ipvs/ip_vs_lblc.c
> @@ -204,6 +204,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
>  			return en;
>  		ip_vs_lblc_del(en);
>  	}
> +	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
> +		return NULL;
> +
>  	en = kmalloc_obj(*en, GFP_ATOMIC);
>  	if (!en)
>  		return NULL;

[Severity: High]
Can tbl->entries be trusted as a bound on the number of live entries in
ip_vs_lblc_new()?  The replacement path just above the new test is the only
ip_vs_lblc_del() call site that does not decrement the counter:

net/netfilter/ipvs/ip_vs_lblc.c:ip_vs_lblc_new() {
	en = ip_vs_lblc_get(af, tbl, daddr);
	if (en) {
		if (en->dest == dest)
			return en;
		ip_vs_lblc_del(en);	/* no atomic_dec(&tbl->entries) */
	}
	...
}

The helper itself does not touch the counter:

static inline void ip_vs_lblc_del(struct ip_vs_lblc_entry *en)
{
	hlist_del_rcu(&en->list);
	call_rcu(&en->rcu_head, ip_vs_lblc_rcu_free);
}

while every other caller pairs it with an explicit decrement, e.g. in
ip_vs_lblc_flush(), ip_vs_lblc_full_check() and ip_vs_lblc_check_expire():

			ip_vs_lblc_del(en);
			atomic_dec(&tbl->entries);

Does that mean each dest change for an already cached daddr adds +1 to
tbl->entries while the live entry count stays the same, since
ip_vs_lblc_hash() is the only place that increments?

	hlist_add_head_rcu(&en->list, &tbl->bucket[hash]);
	atomic_inc(&tbl->entries);

If so, does the drift ever get corrected?  The collector decrements only when
it removes a real entry, so it lowers both the counter and the live count
equally, and tbl->entries otherwise seems to be reset only in
ip_vs_lblc_init_svc().

There also looks to be a second effect from the placement of the new test
after ip_vs_lblc_del(): when the limit fires, the old entry has already been
unlinked and NULL is returned without a decrement and without a replacement,
so the table shrinks while the counter stays where it is.

The replacement path appears to be driven by remote packets, since
ip_vs_lblc_schedule() calls __ip_vs_lblc_schedule() and then
ip_vs_lblc_new() with a different dest whenever the cached dest is not
available, has zero weight, or is_overloaded():

	dest = __ip_vs_lblc_schedule(svc);
	...
	spin_lock_bh(&svc->sched_lock);
	if (!tbl->dead)
		ip_vs_lblc_new(tbl, &iph->daddr, svc->af, dest);

Once the accumulated drift alone reaches max_size * 3 / 2 (24576 with the
default 16384), does ip_vs_lblc_new() return NULL permanently for that
service, even with an empty table?  That would leave LBLC locality caching
disabled for the lifetime of the service, with every packet taking the full
__ip_vs_lblc_schedule() dest walk and ip_vs_lblc_check_expire() still
scanning all 1024 buckets under svc->sched_lock looking for entries that are
no longer there.

That also seems to conflict with the commit message text:

    The extra headroom lets the periodic collector catch up while the
    existing scheduler fallback continues to use the selected destination
    when cache creation fails.

Would adding the missing atomic_dec(&tbl->entries) next to the
ip_vs_lblc_del(en) in ip_vs_lblc_new(), or moving the new test ahead of the
lookup and delete, make the limit match the live entry count?

Note that ip_vs_lblcr_new() below places the identical test inside
if (!en), before any removal, and has no unbalanced delete, so the two
schedulers' counters do not appear to satisfy the same invariant even though
the same expression is applied to both.

> diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
> index f53f05ceea36..858393b1d2d1 100644
> --- a/net/netfilter/ipvs/ip_vs_lblcr.c
> +++ b/net/netfilter/ipvs/ip_vs_lblcr.c
> @@ -363,6 +363,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
>  
>  	en = ip_vs_lblcr_get(af, tbl, daddr);
>  	if (!en) {
> +		if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
> +			return NULL;
> +
>  		en = kmalloc_obj(*en, GFP_ATOMIC);
>  		if (!en)
>  			return NULL;

[Severity: Medium]
This isn't a bug introduced by this patch, but does the new limit still leave
the per-bucket chain length unbounded?  ip_vs_lblc_hashkey() and
ip_vs_lblcr_hashkey() hash the destination address with no per-table random
seed:

	return hash_32(ntohl(addr_fold), IP_VS_LBLC_TAB_BITS);

so bucket selection for a chosen address is predictable offline, and
ip_vs_lblc_get() / ip_vs_lblcr_get() walk the chain linearly on every
scheduled packet:

	hlist_for_each_entry_rcu(en, &tbl->bucket[hash], list)
		if (ip_vs_addr_equal(af, &en->addr, addr))
			return en;

Since the new test caps only the total entry count and not the chain length,
can all 24576 permitted entries be steered into a single one of the 1024
buckets, leaving the lookup in softirq context (and again under
spin_lock_bh(&svc->sched_lock) from ip_vs_lblc_new()) walking a ~24k element
list per packet?  The patch does reduce the worst case compared to the
unbounded chain before it, so this is a pre-existing exposure rather than
something the patch adds, but would seeding the hash or bounding chain length
be worth doing on top?
