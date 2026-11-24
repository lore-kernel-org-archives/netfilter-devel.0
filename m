Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531186;
	b=uAPi8hgwv5kxJzo1w8b1qxU8tBEKxVKfvzQUYe/gk/TV+UrAQKmTG9qdp6OX/jrF7tV7
	 At5k6PzdBLO26nff23hTCFU792ZeeP1ojT+sE9iZR9d9XLpIyblxlvDE68Zfj5IgCCm3A
	 pE615eWltgnsZ4OBGpTDZJ2KiqEHPXPIzxNjf4iLxEiMGJwX+NWVzXm4SRfM1dvO8m9cw
	 x94R6L3gul7WbV5LE8oEcl/JTMtun8lS5lnqb2fWqfhl5XuULnI2+Ily9R51Wz7FHJqiP
	 WIiB2OXDbAdB1D2u5A5BvDFLFSVcEUHbYdg6h25r8iBHxi/VIgh9mevI/Lz5GRjwHrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531186;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Pc+nKV8j+HMFJVuzSfYPNMwp9+aUKEG5lmf4DY8ejKo=;
	b=CxXaFeZruu3u7rT0yUV1ywStQDsp820cbOED3hgWdyBUG+SIrxLUdqr/u+wXcoV7AvOU
	 mrBKvZq6t/IvfGtoP0Mgz1Q+FQ62j9sal71fWQGlZHt2SqUWgJAmPOFbGwyWlBFZ/NyJV
	 mwUyCLH5AEIQOrGyUT9B6bp/MaVYQxDTmp1SJvYbOCbGIMmvB1bHZqNW4RDzbFIBkL0bP
	 lr7xNH5Ho2VIGSe1Y9lgbS9F7ODUA0V59M3idKoNWiJMoWVLGe6ehGwAwr/kjGDcs25SO
	 +shWLioLgUAclHekXXBCzUANAMF306YXOMQzL5lBTruZHuNhN1V3n7FG1nFaDU2DzLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mEkRupPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D050606A332;
	Tue, 24 Nov 2026 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mEkRupPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A431F000C0;
	Tue, 24 Nov 2026 14:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531185;
	bh=Pc+nKV8j+HMFJVuzSfYPNMwp9+aUKEG5lmf4DY8ejKo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mEkRupPomOgcu4TzcZQe2kf646uR2eMP3JI0yikA7u6EBA8R5Q+3oq45jsGwCV8Fx
	 mFKTyeENRAl2X99TCiFuGepEdnlRmnBIaLwYmAxqq0puupCjcXdStXGb6wL3Sob4Ge
	 qAndLP5+BF96zLzygWB9MNsUVOzUdgts03EFSm3F7/6vzzY4BHU58epGXwNdkSbmdW
	 dinTIbjrvf+Zoo7xrR37pGTyy5m0vUPoMilItmCBqEKrN1D8co/AYUqghWMP2ubKuL
	 dFBqtvEriV+0zyP2nRDt4o82d2wJVsC1dfuYs93JXMCOeR2KtuJ9ymAup8ONlVkTBh
	 qd1/Fon5cn9WA==
Subject: Re: [PATCH net-next 13/15] netfilter: ipset: also report mem size for
 cidr storage to userspace
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:44 +0000
Message-ID: <179553118436.3135.12549536301575412131@kernel.org>
In-Reply-To: <20261123135726.3940688-14-pablo@netfilter.org>
References: <20261123135726.3940688-14-pablo@netfilter.org>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The comment above mtype_rht_size() in
  net/netfilter/ipset/ip_set_hash_gen.h says it returns 'the current…
- [Low] In mtype_rht_size(), the new cidr accounting uses ksize(nets),
  which returns the slab-rounded size of the allocation.
- [Low] The new ksize(nets) call in mtype_rht_size() is used only to
  report memory usage, but ksize() has a side effect.

--

netfilter: ipset: also report mem size for cidr storage to userspace

This patch changes mtype_rht_size() so the ext_size it reports also
includes the dynamically allocated net_prefixes arrays in h->rnets[].
That way the cidr storage added by commit 8e5fd2a55e24 ("netfilter: ipset:
rework cidr bookkeeping") shows up in the memsize reported to userspace.

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 8ac1b0f048560..e7f2e584a7a50 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -616,6 +616,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
>  	*elements = ipset_hash_nelems(h);
>  	*ext_size = *elements *
>  		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
> +
> +#ifdef IP_SET_HASH_WITH_NETS
> +	{
> +		const struct net_prefixes *nets;
> +		int i;
> +
> +		rcu_read_lock();
> +
> +		for (i = 0; i < IPSET_NET_COUNT; i++) {
> +			nets = rcu_dereference(h->rnets[i]);
> +			if (nets)
> +				*ext_size += ksize(nets);

[Severity: Low]
This isn't a bug, but the comment above mtype_rht_size() still says:

/* Get the current number of elements and per-element memory in the set */

After this change *ext_size also includes the h->rnets[] arrays. That
storage belongs to the whole set and is sized by the number of distinct
cidr values. It is also non-zero for an empty set.

Should the comment say that ext_size now covers the per-set cidr storage
as well?

[Severity: Low]
Should this count the requested size instead of ksize()?

Every other term in IPSET_ATTR_MEMSIZE uses the exact requested size:
sizeof(*h), the per-element term just above, and
sizeof(*c) + strlen(c->str) + 1 in ip_set_init_comment().

The nets arrays are allocated with kzalloc_obj(*nets) at create time, and
in mtype_add_cidr() with:

	tmp = kzalloc_flex(*tmp, nets, len, GFP_ATOMIC);

ksize() rounds these up to the kmalloc bucket size. If KFENCE served the
object, ksize() returns kfence_ksize() instead, which is the requested
size. So two identical sets can report different memsize values,
depending on the config and on which allocator served the object.

Would struct_size(nets, nets, nets->len) match how the other terms are
counted?

[Severity: Low]
Is ksize() a good fit for a call that only reports memory usage? Under
CONFIG_SLUB_DEBUG it has a side effect:

mm/slub.c:__ksize() {
    ...
#ifdef CONFIG_SLUB_DEBUG
	skip_orig_size_check(slab->slab_cache, object);
#endif
    ...
}

and skip_orig_size_check() does:

	set_orig_size(s, (void *)object, s->object_size);

On kmalloc caches that record the original size (slub_debug with
store-user/redzone), this replaces the recorded request size of the
net_prefixes object with the full object size. The object is long-lived
and RCU-published. For the rest of its life, the kmalloc redzone check no
longer covers the slack after the flex array.

Any user with CAP_NET_ADMIN in the netns can reach this on every ipset
list or header dump:

mtype_head()->mtype_rht_size()->ksize()->__ksize()->skip_orig_size_check()

The ksize() kernel-doc also says it is meant for internal use and points
callers to kmalloc_size_roundup().

Would struct_size(nets, nets, nets->len), read under the same RCU
protection, avoid this side effect?

> +		}
> +
> +		rcu_read_unlock();
> +	}
> +#endif

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
