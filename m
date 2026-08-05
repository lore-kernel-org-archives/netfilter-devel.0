Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E0235E1C1;
	Wed,  5 Aug 2026 00:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888936; cv=none; b=WvUd8sREKp29dQAz9r1qxzYmWW106qgo2lwp9FUWQTfEDp7kWLXDXhI98VDiX1wFrADYUHBBqziSfo29GSduM5zsSGjKekBfohi7E0vGsgqrqZP23yLrfr0a3KpsGM/t2ol1otlbpHYqRfVMMBy5/jo5Nz5BiqJo3GsDCGAl5t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888936; c=relaxed/simple;
	bh=k4q2mmco9ihX1tTV50TuAPTm4Sio8vNUsgXtqIFiy1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFajflaBv+rKGD4rI2Df+M1OSiQnjXmj/pBSA0/YUPgDIQhTd4XK0KMg/FkzWmwsQ7jmG2lb3dWuU2mWlQQ/4Wqpmfe3X5O4loUCt3uyVFNY4GnM1J8RW0iBjVCpMRFHnHu6ihNkOtTy1ftJIpH27BTAc6rC999SHSmR/IrXH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWpJBr7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWpJBr7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26921F00A3A;
	Wed,  5 Aug 2026 00:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785888933;
	bh=EAN4aNYHlNF7+D/zI83EUYIfuujrMg5UnF81B7Y3t8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWpJBr7agqqb2eib8zdepXcOz3fP4WGqMnZvn8jgPYh0hx7eebcFLPoufE1+5f6BU
	 8Thq9zHSonj+AaLX2eBS8HKJhcL7Gm+ZjD/NyAcJHLRw4wOjUsB3ygJwkfVFXYXdM5
	 uXTsE8qsKs3/f+bi1KkEHRBQGlG0A2FWAzpqGgclbrXu/m2qUG7wmESq7+iYmeku8A
	 3G60xQh9HH0acqTXSWYyMoiU62A6POcJM3IJ5jPLabzuhHpZwoWOEyhihT5tfvWQ6a
	 IK7AY8EmNmQb5mkH4/aiC2QIyv1yFUpIHNKsxB/KwXErAZja2lVw3SixuBaAoPfk6B
	 BUhXmWCYJ9FSA==
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
Subject: Re: [PATCH net 06/10] netfilter: ipset: add and use mtype_del_cidr_all helper
Date: Tue,  4 Aug 2026 17:15:33 -0700
Message-ID: <20260805001533.3978816-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731151806.849724-7-pablo@netfilter.org>
References: <20260731151806.849724-7-pablo@netfilter.org>
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
netfilter: ipset: add and use mtype_del_cidr_all helper

This adds a mtype_del_cidr_all() helper that wraps the per-net-dimension
loop calling mtype_del_cidr(), and converts the three open-coded loops in
mtype_gc_do(), mtype_add() and mtype_del() to use it.  No functional
change is intended.

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index ef586b486f519..f00c82acd7f05 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h

[ ... ]

> @@ -410,6 +412,17 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
>  }
>  #endif
>  
> +static void
> +mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem *data)
> +{
> +#ifdef IP_SET_HASH_WITH_NETS
> +	int k;
> +
> +	for (k = 0; k < IPSET_NET_COUNT; k++)
> +		mtype_del_cidr(set, h, DCIDR_GET(data->cidr, k), k);
> +#endif
> +}

[Severity: Critical]

This helper makes mtype_del_cidr() the single delete-side writer of
h->rnets[], so it may be worth asking about the locking of that array.
The problem does not originate in this patch but in the earlier commit of
this series, "netfilter: ipset: rework cidr bookkeeping", which turned the
fixed-size h->nets[] into an RCU-published, reallocated struct
net_prefixes; this patch routes all three delete sites into one of the
racing writers.

mtype_add_cidr() and mtype_del_cidr() both serialize on set->lock:

	spin_lock_bh(&set->lock);
	nets = __ipset_dereference(h->rnets[n]);
	...
	rcu_assign_pointer(h->rnets[n], tmp);
	kfree_rcu(nets, rcu);
unlock:
	spin_unlock_bh(&set->lock);

mtype_flush() does the same read-allocate-publish-free sequence with no
set->lock held:

	for (i = 0; i < IPSET_NET_COUNT; i++) {
		nets = ipset_dereference_nfnl(h->rnets[i]);
		tmp = kzalloc_obj(*tmp, GFP_ATOMIC);
		if (!tmp) {
			u8 j;

			for (j = 0; j < nets->len; j++)
				nets->nets[j].count = 0;
		} else {
			rcu_assign_pointer(h->rnets[i], tmp);
			kfree_rcu(nets, rcu);
		}
	}

ip_set_flush_set() does call ip_set_lock(set), but for the hash variants
(.region_lock = true) that is a no-op:

net/netfilter/ipset/ip_set_core.c:
	static inline void
	ip_set_lock(struct ip_set *set)
	{
		if (!set->variant->region_lock)
			spin_lock_bh(&set->lock);
	}

The hregion locks flush does take are all released before the rnets loop
runs, and mtype_add_cidr()/mtype_del_cidr() do not take hregion locks.

Can this interleaving happen?

CPU0 (ipset flush, process context, nfnl mutex only)
	nets_old = ipset_dereference_nfnl(h->rnets[i]);

CPU1 (SET target kadt in softirq -> mtype_add() -> mtype_add_cidr(),
      or gc worker -> mtype_gc_do() -> mtype_del_cidr_all())
	spin_lock_bh(&set->lock);
	nets_old = __ipset_dereference(h->rnets[n]);
	rcu_assign_pointer(h->rnets[n], tmp1);
	kfree_rcu(nets_old, rcu);
	spin_unlock_bh(&set->lock);

CPU0
	rcu_assign_pointer(h->rnets[i], tmp0);	/* tmp1 leaked */
	kfree_rcu(nets_old, rcu);		/* rcu_head reused */

Does the second kfree_rcu() on an object whose rcu_head is already queued
corrupt the callback list and double free the net_prefixes?  And does the
tmp0 publish also drop the accounting update CPU1 just made in tmp1?

On the flush allocation-failure path, flush writes nets->nets[j].count = 0
in place while mtype_del_cidr() may be doing nets->nets[found].count-- and
mtype_add_cidr() nets->nets[i].count++ on the same object.  Can that tear
the counts and the __counted_by(len) contents?

[ ... ]

> @@ -1004,11 +1010,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  			j = 0;
>  		data = ahash_data(n, j, set->dsize);
>  		if (!deleted) {
> -#ifdef IP_SET_HASH_WITH_NETS
> -			for (i = 0; i < IPSET_NET_COUNT; i++)
> -				mtype_del_cidr(set, h,
> -					DCIDR_GET(data->cidr, i), i);
> -#endif
> +			mtype_del_cidr_all(set, h, data);
>  			ip_set_ext_destroy(set, data);
>  			t->hregion[r].elements--;
>  		}

[Severity: High]

Related to the decrement side this patch factors out: the matching
increment in mtype_add() ignores the new error return of
mtype_add_cidr().  As with the previous comment, this comes from
"netfilter: ipset: rework cidr bookkeeping" earlier in the series, which
changed mtype_add_cidr() from a void in-place update into an int that
allocates a replacement net_prefixes with GFP_ATOMIC and can return
-ENOMEM.

The insert path in mtype_add() still reads:

	#ifdef IP_SET_HASH_WITH_NETS
		for (i = 0; i < IPSET_NET_COUNT; i++)
			mtype_add_cidr(set, h, DCIDR_GET(d->cidr, i), i);
	#endif
		memcpy(data, d, sizeof(struct mtype_elem));

while mtype_add_cidr() can fail:

	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);
	if (!tmp) {
		ret = -ENOMEM;
		goto unlock;
	}

ret in mtype_add() stays 0, so ipset add reports success and the element
shows up in ipset list.  But mtype_test_cidrs() only builds lookup keys
from prefixes recorded in h->rnets[]:

	for (j = 0; j < nets0->len && !multi; j++) {
		if (!nets0->nets[j].count)
			continue;
		...
		key = HKEY(d, h->initval, t->htable_bits);

Can this leave an element that never matches a packet, even though
userspace was told the add succeeded?

There also seems to be a follow-on effect on unrelated members.  Since
mtype_add_cidr() only allocates when the cidr is absent, a failure means
that cidr is not registered at all.  If another element later registers
the same cidr (count = 1) and the unregistered element is then deleted,
mtype_del_cidr_all() -> mtype_del_cidr() finds that shared entry and does:

	nets->nets[found].count--;

Does that drop the count to 0 and remove a prefix that live elements still
use, so those elements stop matching too?

And in the case where mtype_del_cidr()'s own kzalloc_flex() previously
failed and left a hole (a count == 0 entry that keeps its cidr), deleting
the unregistered element decrements a count of 0.  Does that underflow the
u32 to 0xFFFFFFFF and pin the prefix in the lookup list permanently?

Would propagating the mtype_add_cidr() return value (and undoing the
already-successful increments) be preferable here?
