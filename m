Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C943B42C7;
	Fri,  4 Sep 2026 04:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788496107; cv=none; b=UyuAfsKHazcDBSSdg/UciIJpuSy5GAiqZnrGlGpvgC/0+f4KgmpgRJyG0xY4rSspOuF3Q328OsZoUH9JcQdjVNCMjof776n18xRVO34l7+ix+0hYyvch3osOSaxjf/EMmXHLGfDWWj96v0KVpVDeeFPQtfkBv7ad9OgeCgRabOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788496107; c=relaxed/simple;
	bh=fUkMzxr5cvb9Yhx4tSc8tYYbmu8KznfA5Vz5qpftacM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=blMflmEYZB2ZhMg2KPcV481hpP7mRRfhgD/OSTkMFyAWvphIMsANIULqxrq/OtkRBGAbo3Dyzxn5L30hxYui2K7FqP0jaXqE9273ZCtrVnC1opk4aa8YTPYOb13+wWGrGVuflF2AKpstWbKhV0KVfYkoFbQij5ntEUqPgglxPYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=fQFM0rJR; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="fQFM0rJR"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id A211D21CCB;
	Fri, 04 Sep 2026 07:20:33 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=TP/MZEULkbRg9iK8Y1OIo3Ouhxoe2b1CK2DMF3NgQHY=; b=fQFM0rJRWO7a
	KGW+PzhsXHTQBnmRcAyueQOXrNAx+KUak2dj0TwV0hFhTsEWMwu6PGpQJbJJ13Fj
	v6u7KHzxzH0QO5w/LK2q4no1yr5f7wUIONNK0RnxadGMgYrwINexJmVp5a8vQuQj
	WJ+LpjPKJrXdvbohRG5OhzY5TC10AFol/qq0fthuUJfKg0mIOW4h3Q3i9OmJH1OQ
	+nHIk7MZoQHw8uEs4iMp+WcaClePCvSuuU79iJjaUnrx5jRDG3l8mbkV/wX491b5
	jnsx8IkPvJ7A9Qty/2tJheLCJ6cuA3NPPEYCN7DXjk3+TrfIXnOnC7jo7m9z/Ikm
	qqHzW3ZW2UqJNOSPm1sxkBX1USO892qsTWJ/aUX9fUg9v+8ihxK9dVwH9Y+MMRfA
	VNSBUFMe6uu9Z+u5X/U1xVY2iJNgdHhURm3n83xL0kPEqb7Z7mlORt62ocnKOMvg
	bxLiGV88vT9m86MBkclXSECf8P4//tYoQd5xx6vSsKBt2O7oMfhkFM2jYdl8pevZ
	epufD/pIadO04Bdg7fQKYT9vUAF41aKLC0KhqiNlGNrBKZecSJhDtr18hBbp7uCt
	VIylm9SmVRDayh/89yQlQKF64QJb+vLeTtOEKw4oRJY9j/+aTyT6H2epk53G2x00
	T8r4Tmd1BOzRa/AwVoML/ZlmLhyFqWw=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri, 04 Sep 2026 07:20:33 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 833A361D2B;
	Fri,  4 Sep 2026 07:20:34 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6844KVH4009235;
	Fri, 4 Sep 2026 07:20:31 +0300
Date: Fri, 4 Sep 2026 07:20:31 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 06/12] ipvs: bound LBLCR and LBLC cache growth
In-Reply-To: <20260904020140.3549818-1-kuba@kernel.org>
Message-ID: <0afb3b53-f4b5-7cb8-0f06-7582a50ef83b@ssi.bg>
References: <20260903004149.1037028-7-pablo@netfilter.org> <20260904020140.3549818-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Thu, 3 Sep 2026, Jakub Kicinski wrote:

> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> ipvs: bound LBLCR and LBLC cache growth
> 
> This adds a hard admission limit to ip_vs_lblc_new() and
> ip_vs_lblcr_new(), rejecting new cache entries once atomic_read(&tbl->entries)
> reaches max_size * 3 / 2.  The stated intent is to leave headroom so the
> periodic collector can catch up while the scheduler fallback keeps serving
> traffic.
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
> > index 693bcc82ccb7..8180a7ba9f53 100644
> > --- a/net/netfilter/ipvs/ip_vs_lblc.c
> > +++ b/net/netfilter/ipvs/ip_vs_lblc.c
> > @@ -204,6 +204,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
> >  			return en;
> >  		ip_vs_lblc_del(en);
> >  	}
> > +	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
> > +		return NULL;
> > +
> >  	en = kmalloc_obj(*en, GFP_ATOMIC);
> >  	if (!en)
> >  		return NULL;
> 
> [Severity: High]
> Can tbl->entries be trusted as a bound on the number of live entries in
> ip_vs_lblc_new()?  The replacement path just above the new test is the only
> ip_vs_lblc_del() call site that does not decrement the counter:
> 
> net/netfilter/ipvs/ip_vs_lblc.c:ip_vs_lblc_new() {
> 	en = ip_vs_lblc_get(af, tbl, daddr);
> 	if (en) {
> 		if (en->dest == dest)
> 			return en;
> 		ip_vs_lblc_del(en);	/* no atomic_dec(&tbl->entries) */

	Yes, we remember this place from the previous Sashiko
review but the new change depends on the current patch to
apply gracefully.

> 	}
> 	...
> }
> 
> The helper itself does not touch the counter:
> 
> static inline void ip_vs_lblc_del(struct ip_vs_lblc_entry *en)
> {
> 	hlist_del_rcu(&en->list);
> 	call_rcu(&en->rcu_head, ip_vs_lblc_rcu_free);
> }
> 
> while every other caller pairs it with an explicit decrement, e.g. in
> ip_vs_lblc_flush(), ip_vs_lblc_full_check() and ip_vs_lblc_check_expire():
> 
> 			ip_vs_lblc_del(en);
> 			atomic_dec(&tbl->entries);
> 
> Does that mean each dest change for an already cached daddr adds +1 to
> tbl->entries while the live entry count stays the same, since
> ip_vs_lblc_hash() is the only place that increments?
> 
> 	hlist_add_head_rcu(&en->list, &tbl->bucket[hash]);
> 	atomic_inc(&tbl->entries);
> 
> If so, does the drift ever get corrected?  The collector decrements only when
> it removes a real entry, so it lowers both the counter and the live count
> equally, and tbl->entries otherwise seems to be reset only in
> ip_vs_lblc_init_svc().
> 
> There also looks to be a second effect from the placement of the new test
> after ip_vs_lblc_del(): when the limit fires, the old entry has already been
> unlinked and NULL is returned without a decrement and without a replacement,
> so the table shrinks while the counter stays where it is.
> 
> The replacement path appears to be driven by remote packets, since
> ip_vs_lblc_schedule() calls __ip_vs_lblc_schedule() and then
> ip_vs_lblc_new() with a different dest whenever the cached dest is not
> available, has zero weight, or is_overloaded():
> 
> 	dest = __ip_vs_lblc_schedule(svc);
> 	...
> 	spin_lock_bh(&svc->sched_lock);
> 	if (!tbl->dead)
> 		ip_vs_lblc_new(tbl, &iph->daddr, svc->af, dest);
> 
> Once the accumulated drift alone reaches max_size * 3 / 2 (24576 with the
> default 16384), does ip_vs_lblc_new() return NULL permanently for that
> service, even with an empty table?  That would leave LBLC locality caching
> disabled for the lifetime of the service, with every packet taking the full
> __ip_vs_lblc_schedule() dest walk and ip_vs_lblc_check_expire() still
> scanning all 1024 buckets under svc->sched_lock looking for entries that are
> no longer there.
> 
> That also seems to conflict with the commit message text:
> 
>     The extra headroom lets the periodic collector catch up while the
>     existing scheduler fallback continues to use the selected destination
>     when cache creation fails.
> 
> Would adding the missing atomic_dec(&tbl->entries) next to the
> ip_vs_lblc_del(en) in ip_vs_lblc_new(), or moving the new test ahead of the
> lookup and delete, make the limit match the live entry count?
> 
> Note that ip_vs_lblcr_new() below places the identical test inside
> if (!en), before any removal, and has no unbalanced delete, so the two
> schedulers' counters do not appear to satisfy the same invariant even though
> the same expression is applied to both.
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
> > index f53f05ceea36..858393b1d2d1 100644
> > --- a/net/netfilter/ipvs/ip_vs_lblcr.c
> > +++ b/net/netfilter/ipvs/ip_vs_lblcr.c
> > @@ -363,6 +363,9 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
> >  
> >  	en = ip_vs_lblcr_get(af, tbl, daddr);
> >  	if (!en) {
> > +		if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
> > +			return NULL;
> > +
> >  		en = kmalloc_obj(*en, GFP_ATOMIC);
> >  		if (!en)
> >  			return NULL;
> 
> [Severity: Medium]
> This isn't a bug introduced by this patch, but does the new limit still leave
> the per-bucket chain length unbounded?  ip_vs_lblc_hashkey() and
> ip_vs_lblcr_hashkey() hash the destination address with no per-table random
> seed:
> 
> 	return hash_32(ntohl(addr_fold), IP_VS_LBLC_TAB_BITS);
> 
> so bucket selection for a chosen address is predictable offline, and
> ip_vs_lblc_get() / ip_vs_lblcr_get() walk the chain linearly on every
> scheduled packet:
> 
> 	hlist_for_each_entry_rcu(en, &tbl->bucket[hash], list)
> 		if (ip_vs_addr_equal(af, &en->addr, addr))
> 			return en;
> 
> Since the new test caps only the total entry count and not the chain length,
> can all 24576 permitted entries be steered into a single one of the 1024
> buckets, leaving the lookup in softirq context (and again under
> spin_lock_bh(&svc->sched_lock) from ip_vs_lblc_new()) walking a ~24k element
> list per packet?  The patch does reduce the worst case compared to the
> unbounded chain before it, so this is a pre-existing exposure rather than
> something the patch adds, but would seeding the hash or bounding chain length
> be worth doing on top?

	Yes, adding random seed and changing the hash function
can be useful improvement. Added to TODO.

Regards

--
Julian Anastasov <ja@ssi.bg>

