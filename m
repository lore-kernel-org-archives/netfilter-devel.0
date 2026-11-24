Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531182;
	b=4kJwDjpt6IlgeTKr+GyzyRgpB0qpDyKhHxDpgRaPaFLa6NVF+s1M5GXOZm9pkhUJbIHs
	 WH08G3mBihYS2Vx6J9wgg5gje+3cNPU8qWQKaUxkZsmB8b/5eMVpbCHEFftqie05LZ665
	 8lh3lQpBtW1sikHwMH2i8RqBhYJ75SJQENIL0EHH8AdM13k3dKd0UyQiV9W/pUrGADCP+
	 xMUsPrN99c3TGW+40dZYNWplWINCJ/M+6PN9Xgd8JL/DjsQYE2SgWSdMkL2l6q3K1iU3o
	 krGE56eGlB46VyM9FuGMEmiIiwqRs7MoKm650hoatYHbjIuc0Vv+az+4GqjbQNwTByg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531182;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=VNdDnhf500mD95BaD7BgSNWIwBGFB/jE5mQlB/oBIi0=;
	b=VZdvyq9QisFWChBU/mNdLKU6UrqEXXz9PwOel8e2q8xDUZjhMqFERbaxamA5PPgcyB8V
	 ngVktWBkqVP8A56Ph3LoU4lDYOpGSHc0Yg50Q4CoL4cXqqYkWLJ3Km4qtrT44gTBSTo/A
	 tTQtE64rZUTkqSwvsDGdQXeHJ+O/x8jCRZezweAikPE0/NHv/6q/Hh3wOcF8wU1J+FQed
	 uedgtdXgZy+owAQQINiIEbKF3yGOUvroSnG4CtjLP/0L1I3MmvomVMHVXUVJeYVNYKL7t
	 MzxCK5pEwkY4INZK4C/OF8pncXMy6GB0k/NRg2kVWYMeC/YuxLunHkf7ufBPDyvVGiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hchDhxun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9388606A32E;
	Tue, 24 Nov 2026 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hchDhxun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153441F000D2;
	Tue, 24 Nov 2026 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531182;
	bh=VNdDnhf500mD95BaD7BgSNWIwBGFB/jE5mQlB/oBIi0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hchDhxun03sLc1NNwg9zlanFlwy9Us5ZagFDR6C7sUzFVaMToLAw4gww/766Yjr/d
	 CjzIjePGfD08RvzC7UQO5N5biLhTHLi7NCRgEKHI4o1PR7OwEPC8Chr1GKxefLFZr4
	 STvXkfZPK1upRVGIJhllwbukADqwnrqmSzIEhgRy5xO+tPtG5/UO1pZNUvI47vZhtG
	 w+J1FodJ/H/BbgUYliUt4v+tyrcwevGjILYm+YKoDISnwQGJez2V4sWlCL2uD8U20T
	 lbKbcDktmzEecBEBWDMFO1lKhWF8dIpXnCCaNzrLzch2pf6SJvm90UL9nYifU00ZRk
	 c5cpD4+mKD65g==
Subject:
 Re: [PATCH net-next 11/15] netfilter: ipset: add rhashtable boilerplate stubs
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:41 +0000
Message-ID: <179553118161.3135.18226469983779759073@kernel.org>
In-Reply-To: <20261123135726.3940688-12-pablo@netfilter.org>
References: <20261123135726.3940688-12-pablo@netfilter.org>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] ipset hash sets lose memcg accounting for their bucket
  storage.

--

netfilter: ipset: add rhashtable boilerplate stubs

This preparation patch adds a struct rhashtable to the generic ipset hash
type. It initialises the table in the create path and destroys it in
mtype_destroy(). No elements are added yet; the conversion itself is done
in a follow-up patch.

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 80ca523f304bb..a3f6c0aa47f75 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h

[ ... ]

> @@ -1749,15 +1839,27 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>  
>  #ifdef IP_SET_PROTO_UNDEF
>  	hsize = sizeof(struct htype);
> +	params = mtype_rht_params;
>  #else

[ ... ]

>  #endif
>  	h = kzalloc(hsize, GFP_KERNEL);
>  	if (!h)
>  		return -ENOMEM;
>  
> +	/* maxsize: maximum bucket table size to expand to */
> +	params.max_size = maxelem;
> +
> +	err = rhashtable_init(&h->ht, &params);

[Severity: Medium]
Does this drop memcg accounting for the hash bucket storage?

Until now, ipset hash table storage (the htable with its bucket array, and
hregion) has been allocated through ip_set_alloc(), which charges the
memcg:

net/netfilter/ipset/ip_set_core.c:ip_set_alloc() {
	return kvzalloc(size, GFP_KERNEL_ACCOUNT);
}

rhashtable_init() leads to an allocation that is not accounted. Also,
struct rhashtable_params has no way to ask for __GFP_ACCOUNT:

rhashtable_init()
  __rhashtable_init_noprof()
    bucket_table_alloc(ht, size, GFP_KERNEL)
      kvmalloc_node_align_noprof(..., gfp|__GFP_ZERO, NUMA_NO_NODE)

With only this patch applied, every ipset create of a hash:* type makes
one extra uncharged allocation. It is a struct bucket_table with the
default 64 bucket pointers, because no nelem_hint or min_size is set.

That seems to conflict with this statement in the commit message:

    This change is supposed to be devoid of side effects

The larger effect comes with the follow-up commit "netfilter: ipset:
replace internal hash table with rhashtable". That commit removes the
accounted htable entirely, so all bucket array memory lives in rhashtable
bucket tables. Growth also goes through the unaccounted path:

rht_deferred_worker()
  rhashtable_rehash_alloc()
    bucket_table_alloc(ht, size, GFP_KERNEL)

These tables can grow up to params.max_size = maxelem buckets.
IPSET_CMD_CREATE only needs CAP_NET_ADMIN in the user namespace that owns
the netns. That means a container could use this memory beyond its memcg
limit.

Element objects were already allocated with GFP_ATOMIC and no accounting
before the series. The difference here is only the bucket arrays, which
used to be charged.

Nothing later in the series appears to restore the accounting for the
bucket tables. Should the rhashtable bucket allocations be charged to the
memcg, as the htable storage was before?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
