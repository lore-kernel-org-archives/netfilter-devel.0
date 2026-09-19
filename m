Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5096433C195;
	Sat, 19 Sep 2026 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789824893; cv=none; b=UETQOeB3XBNHAP4j4D8JMzLw1e3kq+tU6JupK3FfrCYlHk9DgyzrBavmQ4iaHDdBe/rCPI7mkdXz8dgxICqhqwHvLNuBiEwEXpqby+gkNunmph7O2qK2PZAs9iD2WvbkZ3IoLNYXEhjuv42d1sUBOdWGnYGUmQSoo0QBe9+XbmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789824893; c=relaxed/simple;
	bh=/x7Bii4UWQIZtRjHvZYE9R1XuP8UemCNMwqZufE7QRc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yn3dpZCMMbtusLjsrZvDhb2DiSjwIdwYXpprCYlRB/CnsPdbS+UAKvBrXA/8rK6yThIhUiWy+G4jYwA7tKiTPejKBOFGVIqttGlJwLNhawJNBk0LwEuf0nv5ZEJpfvIAskNLWqZ8oxPXqUkFf/3UeGeDmPXtX8RiaY1+gkpFqFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCBearYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCBearYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E2C1F00898;
	Sat, 19 Sep 2026 13:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789824892;
	bh=Bbe7YnppLJoDT1UF+JlYMGeorH++IAnA/Vm//9dsWWI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lCBearYSKud+xDlMfhmHAiGfR8xZKu2CSdhJWXqre0VEB5dpeDZXSJcGFA6FVIefl
	 epHETPQdcDL3pZ4ERY1cGHgT0dcTv4Kyt5zrPf1BShj8flvMA9/ay6yfODhAkvcs3O
	 6nMR1yq7EtNGm1m7IJ/HswAzfx7GdaFsDAsiH6VG1hjpqZL6eDDD9NDrz4JGCqxAaP
	 1NkfqoOLMLemKUMwKPYUlf0SLcqqoMGUMJqxYH88t4OorRUOyJkXWQhM/Bipi1Ed0/
	 5Ut8lXjzDrSIYH+qdilrYwoGZcy9cIw7xfAEJlPhIh1NS3kGBEeqQX7/uStVaEAOtK
	 /WP5iAmqUUinw==
Subject: Re: [PATCH net 8/8] netfilter: nf_tables: skip expired catchall
 elements on insert and delete
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 19 Sep 2026 13:34:51 +0000
Message-ID: <178982489117.22033.1574367831667981015@kernel.org>
In-Reply-To: <20260918112844.194503-9-pablo@netfilter.org>
References: <20260918112844.194503-9-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] The relaxed duplicate predicate in
  nft_setelem_catchall_insert() (nf_tables_api.c:7003-7016) removes the…

--

netfilter: nf_tables: skip expired catchall elements on insert and delete

This aligns nft_setelem_catchall_insert() and
nft_setelem_catchall_deactivate() with the lookup and dump predicates, so
an expired catchall element no longer counts as a duplicate and no longer
gets picked as the delete candidate. Both walks now also test
__nft_set_elem_expired() with the per-netns transaction timestamp and
nft_set_elem_is_dead().

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c0b754a2d45b..b59628e6240c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6995,11 +6995,14 @@ static int nft_setelem_catchall_insert(const struct net *net,
>  {
>  	struct nft_set_elem_catchall *catchall;
>  	u8 genmask = nft_genmask_next(net);
> +	u64 tstamp = nft_net_tstamp(net);
>  	struct nft_set_ext *ext;
>  
>  	list_for_each_entry(catchall, &set->catchall_list, list) {
>  		ext = nft_set_elem_ext(set, catchall->elem);
> -		if (nft_set_elem_active(ext, genmask)) {
> +		if (nft_set_elem_active(ext, genmask) &&
> +		    !__nft_set_elem_expired(ext, tstamp) &&
> +		    !nft_set_elem_is_dead(ext)) {
>  			*priv = catchall->elem;
>  			return -EEXIST;
>  		}
>  	}

[Severity: Medium]
Can repeated expire-then-readd cycles grow set->catchall_list without
bound here?

With the relaxed predicate, the expired entry is skipped but stays linked
and genmask-active until GC runs, so the tail of
nft_setelem_catchall_insert() appends a second entry alongside it:

	catchall = kmalloc_obj(*catchall, GFP_KERNEL_ACCOUNT);
	if (!catchall)
		return -ENOMEM;

	catchall->elem = elem->priv;
	list_add_tail_rcu(&catchall->list, &set->catchall_list);

Unlike ordinary elements, catchall elements are excluded from the size
accounting in nft_add_set_elem():

	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
		unsigned int max = nft_set_maxsize(set), nelems;

		nelems = atomic_inc_return(&set->nelems);
		if (nelems > max)
			set_full = true;
	}

so the "return set_full ? -ENFILE : 0;" limiter that caps accumulation of
ordinary elements does not apply to this path. Is there anything else that
bounds the number of stale catchall entries a set can hold?

Reclamation looks like it depends entirely on GC, and the interval is
user-tunable with no upper bound (NFTA_SET_GC_INTERVAL is accepted as a u32
in milliseconds and nft_set_gc_interval() just converts it):

include/net/netfilter/nf_tables.h:nft_set_gc_interval() {
	u32 gc_int = READ_ONCE(set->gc_int);

	return gc_int ? msecs_to_jiffies(gc_int) : HZ;
}

For nft_set_rhash and nft_set_rbtree the catchall reclaim runs only from
the delayed gc work requeued with that value, so with a large gc-interval
the window for accumulation is correspondingly large.

There is also a packet-path effect: nft_set_catchall_lookup() walks the
whole list, and new elements are appended at the tail, so every accumulated
stale entry is dereferenced before the live one is found:

	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
		ext = nft_set_elem_ext(set, catchall->elem);
		if (nft_set_elem_active(ext, genmask) &&
		    !nft_set_elem_expired(ext) &&
		    !nft_set_elem_is_dead(ext))
			return ext;
	}

Would it be preferable to reuse or force-reclaim the stale catchall element
on insert, rather than only ignoring it?

> @@ -7092,11 +7095,14 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
>  					   struct nft_set_elem *elem)
>  {
>  	struct nft_set_elem_catchall *catchall;
> +	u64 tstamp = nft_net_tstamp(net);
>  	struct nft_set_ext *ext;
>  
>  	list_for_each_entry(catchall, &set->catchall_list, list) {
>  		ext = nft_set_elem_ext(set, catchall->elem);
> -		if (!nft_is_active_next(net, ext))
> +		if (!nft_is_active_next(net, ext) ||
> +		    __nft_set_elem_expired(ext, tstamp) ||
> +		    nft_set_elem_is_dead(ext))
>  			continue;
>  
>  		kfree(elem->priv);

[Severity: Medium]
Related to the above: with stale entries now skipped and -ENOENT returned,
per-element DELSETELEM can no longer retire the accumulated entries, so a
full set flush or set deletion appears to be the only way to drop them
before GC fires. Is that the intended behaviour?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260918112844.194503-2-pablo%40netfilter.org
