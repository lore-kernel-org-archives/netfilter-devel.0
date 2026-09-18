Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6B930216D;
	Fri, 18 Sep 2026 02:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697059; cv=none; b=rR0EkJSFhTLxMWUV81br/Dp5wIcv3++RC7Y1CwdQ8i7fbylnVZFo/yf8x3XZ4XN7yYnqfoj7briqjWrPfW1k87xYcZQdxRUlnF3cuP2Kv3cpc9E5GvalD9fF0XXgJFLnElKsiCjdLRhr2FiowSx//CmC1O3uhRYHdknTUWnznxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697059; c=relaxed/simple;
	bh=U+0sobSclJ74aAPwiiKFQD79HdoFWY1KLf7BtUAEs/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9I4jUBtYb6etlwd9pIgWEP7gKjB9hTpVNhIkeBo2JsGS9hW8HUlUT84KwbjqIW8WrYqsLnbpR8V2atqkOYFGFhiVziUIkKwwplfuXvjBSOsWlMzbqsuSfxDQB1nkaJJiJf/08MEMWn470sRNaBzBZ4G0f/GstzXEkKdvDRRIW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmoYemAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmoYemAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D641F0089A;
	Fri, 18 Sep 2026 02:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789697053;
	bh=Kh/HPddNj8sLFK/f2Uyb3aZF6yC/GUMZx8hmgmmWDNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmoYemAJFjZg518I2B5Zn8AOUC5oxRZwjaKmgWoYBoZXASOz8IoR994MInq98ufP9
	 1wr7+vUAoFHMJp4wywx9vUKxQ17wa8Av/ut4Ndqzai8c8H1jdqckFB8JZUqCixYFP0
	 oHH7oRvU9ZYB78BRTTtuzsHiOVzaYBNpcF4bFyViS9ahxeH9lYAZdxE4X9DR/YG52h
	 YUuAuhgxc/ILMptdkuBlk3A/C2rTaQ4f02JEz4szYW50n55hA5UYA8h3KbZ5DTPSjX
	 gTWztPFFhC0sTpRAHNcSAa9UVI3A4N3xJ5Ftj3wN8DOX4mQwdtJVqALZXhsQWTsZAk
	 0k5iyYVweNwsw==
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
Subject: Re: [PATCH net 10/10] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Thu, 17 Sep 2026 19:04:12 -0700
Message-ID: <20260918020412.3513453-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231652.127456-11-pablo@netfilter.org>
References: <20260916231652.127456-11-pablo@netfilter.org>
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
netfilter: nf_tables: skip expired catchall elements on insert and delete

This adds an expiry test to the catchall duplicate walk in
nft_setelem_catchall_insert() and to the delete-candidate walk in
nft_setelem_catchall_deactivate(), using the per-netns transaction
timestamp.  The stated goal is to make both control-plane walks agree with
the lookup and dump predicates.

A couple of questions on the new predicates and on the commit message.

> The delete path shows the same drift: nft_setelem_catchall_deactivate()
> picks the first active-next entry in the catchall list, so with an
> expired entry still pending GC it retires the stale entry instead of
> the fresh one, and it deactivates an element that userspace no longer
> sees instead of failing with -ENOENT.

[Severity: Low]
Is the first half of this paragraph reachable before this patch?  The
"expired entry still pending GC ... instead of the fresh one" wording
implies a stale active-next entry and a fresh active-next entry can coexist
in catchall_list.

Pre-patch nft_setelem_catchall_insert() rejected every entry that was
active in the next generation, expired or not:

	list_for_each_entry(catchall, &set->catchall_list, list) {
		ext = nft_set_elem_ext(set, catchall->elem);
		if (nft_set_elem_active(ext, genmask)) {
			*priv = catchall->elem;
			return -EEXIST;
		}
	}

The other ways an entry leaves active-next all unlink it from
catchall_list (nft_trans_gc_catchall_sync(), the async GC completion) or
happen on an explicit delete, and the non-EXCL add refreshed the existing
element through nft_trans_elem_update() rather than linking a second one.
So the "wrong entry retired" state seems to first become reachable because
of the insert hunk in this same patch.

The second half (deactivating an element userspace no longer sees instead of
returning -ENOENT) does look pre-existing.

Since the two hunks are interdependent, could the message say so explicitly
so the stable backport is not split?

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c0b754a2d45b0..800efb4d91ebe 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6995,11 +6995,13 @@ static int nft_setelem_catchall_insert(const struct net *net,
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
> +		    !__nft_set_elem_expired(ext, tstamp)) {
>  			*priv = catchall->elem;
>  			return -EEXIST;
>  		}

[Severity: High]
Should this predicate also test nft_set_elem_is_dead()?

The commit message says the walk is aligned "with the lookup and dump
predicates" and is "in line with the set backend .insert/.deactivate", but
both of those references carry a dead test that is missing here.
nft_set_catchall_lookup() in the same file:

	if (nft_set_elem_active(ext, genmask) &&
	    !nft_set_elem_expired(ext) &&
	    !nft_set_elem_is_dead(ext))
		return ext;

and nft_rhash_cmp() in nft_set_hash.c, which is what the rhash
.insert/.deactivate comparisons go through:

	if (nft_set_elem_is_dead(&he->ext))
		return 1;
	if (__nft_set_elem_expired(&he->ext, x->tstamp))
		return 1;

The two predicates can disagree because the DEAD bit is set from the async
GC worker against real jiffies, while the control plane compares against
nft_net->tstamp, latched once per netlink batch in nf_tables_valid_genid():

	nft_net->tstamp = get_jiffies_64();

An element created inside the current batch always has
expiration = get_jiffies_64() + timeout, i.e. later than tstamp.  If its
timeout (which may be as small as 1 ms) elapses while the same batch is
still being processed, nft_trans_gc_catchall_async() marks it DEAD, yet
__nft_set_elem_expired(ext, tstamp) is still false here.

Does that leave the element in a state where nft_set_catchall_lookup()
skips it for every packet, but this walk still returns -EEXIST?  With
NLM_F_EXCL the re-add then fails for an element that no longer matches
anything.

Without NLM_F_EXCL, the -EEXIST path in nft_add_set_elem() queues
NFT_TRANS_UPD_TIMEOUT/EXPIRATION and nft_trans_elem_update() rewrites the
expiration:

	if (update->flags & NFT_TRANS_UPD_EXPIRATION)
		WRITE_ONCE(nft_set_ext_timeout(ext)->expiration, get_jiffies_64() + update->expiration);

Nothing clears NFT_SET_ELEM_DEAD_BIT anywhere (the only sites are set_bit()
in nft_trans_gc_catchall_async() and in nft_set_hash.c), and
nft_trans_gc_catchall_async() starts with

		if (!nft_set_elem_expired(ext))
			continue;

so after the refresh the element is neither matched by the datapath nor
reclaimed by GC.  A userspace loop that keeps refreshing the timeout would
keep it in that state indefinitely.  Is that not the same "catchall rule may
silently stop matching for an arbitrarily long time" symptom the patch sets
out to remove?  nft_set_catchall_dump() and nft_setelem_catchall_get() also
lack the dead test, so the element is still listed to userspace while never
matching traffic.

>  	}
>  
>  	catchall = kmalloc_obj(*catchall, GFP_KERNEL_ACCOUNT);
>  	if (!catchall)
>  		return -ENOMEM;
>  
>  	catchall->elem = elem->priv;
>  	list_add_tail_rcu(&catchall->list, &set->catchall_list);

[Severity: High]
Can this grow set->catchall_list without bound?

The skipped stale entry is neither unlinked nor reused, so the function
falls through to kmalloc_obj() + list_add_tail_rcu() and appends a new
entry while the expired one stays linked.  Repeating "wait for the element
timeout to elapse, then NFT_MSG_NEWSETELEM with NFT_SET_ELEM_CATCHALL"
appends one entry per cycle.

Nothing appears to cap that, since catchall elements are excluded from the
set size accounting in nft_add_set_elem():

	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
		unsigned int max = nft_set_maxsize(set), nelems;

		nelems = atomic_inc_return(&set->nelems);
		if (nelems > max)
			set_full = true;
	}

and the decrement side skips them too, in nft_trans_gc_trans_free():

		if (!nft_setelem_is_catchall(trans->set, elem_priv))
			atomic_dec(&trans->set->nelems);

so nft_set_maxsize() and -ENFILE never apply here.  For timeout-capable
hash sets the only reaper is the delayed nft_rhash_gc() work:

	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
			   nft_set_gc_interval(set));

and gc_int comes straight from NFTA_SET_GC_INTERVAL in nf_tables_newset()
with no upper bound, so the same requester controls both how fast entries
accumulate (1 ms element timeout) and how long they stay linked.  The GC
batch is additionally dropped when gc_seq moves, so a stream of small
batches can keep starving reclamation.

Besides the memory, does this not also make the data path scale with the
number of retained entries?  nft_set_catchall_lookup() walks the whole list
under rcu_read_lock() for every packet, and
nft_setelem_catchall_get()/nft_set_catchall_dump() walk it as well.

Would retiring or reusing the skipped element in this walk, rather than
just skipping it, avoid both problems?

>  
>  	return 0;
>  }

[ ... ]

> @@ -7092,11 +7094,13 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
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
> +		    __nft_set_elem_expired(ext, tstamp))
>  			continue;

[Severity: High]
Same question for the delete side: should this skip condition also include
nft_set_elem_is_dead(ext)?  A DEAD element that the datapath already ignores
in nft_set_catchall_lookup() is still selected here and deactivated, where
-ENOENT looks like the expected result.

>  
>  		kfree(elem->priv);
