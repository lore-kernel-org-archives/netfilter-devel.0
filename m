Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795123658;
	b=Fi/2U1xhlXLJBkMauCugC17U8ooiOGkFezHcsHLbLR4FJvxUGlHi9b8wR6isER+HgCzz
	 vq8LwPUHbwk5GXUd19fS/Vvs0yzhlAVbCguT3tJj8n7mpFfSA2cwH9dK08a5dyi27v1Wc
	 mMqJIfq/8QT8/DM4Tu3TP0/uzswg3yCfLL3VH+bASfAjvefflV0CD+s5ZhXJxO9gwNu3z
	 B6ide7uLficpKmNe1I7XCPM2o9RVb3S+DX13rkNCeTdrW0SoNVKCg8NJQ8hqtdLhCgYgD
	 1Mg9TOW0yQ1SckvB28R4Ghc0OTAsyoGO8M2dyT52bhgrih1SNASu10LRhK6sgCdpNHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795123658;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=FI9vWdua1Ky4pzSvEMEUUts+rWwX6FGvwGpLJLvDzhs=;
	b=PH1t5vSu8WVbiu/bLmug061H1ACL7DZ4XOr9+Tb0rdmNusmdlWrHD8lEJk2lmr9kpwSG
	 JP6UXJLmY48e+Ew4ZGujZ50/hWHJHLOulNYv6854BW6Ojzq0i5gAmdMNmzCuWRyrEcznW
	 9iUKbIYxThfJd1g78OXCfyMnQ1tJrO15saVQc/gxuoCe/r3w/8S2nXEthyvS4BcY3NRjK
	 kSFg0AInW41e+Vyf5u3ySKuLL+trs3Ax5jAifpzuUo2m5FqLEmcLPnmy7y/JznsmltSMM
	 mtGDdtLmFCTg7S/REYAFy4xBerKK+KXVbW/HzE45QnGy8zoTcgG/vDqDxg3aCsMUEOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N5oh2KSP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BF5606A320;
	Thu, 19 Nov 2026 21:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N5oh2KSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E02B1F000C4;
	Thu, 19 Nov 2026 21:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795123658;
	bh=FI9vWdua1Ky4pzSvEMEUUts+rWwX6FGvwGpLJLvDzhs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=N5oh2KSPBuNpDFr7xrQyBWbEBYBE+mP27Yec7/RVAcz2gcwbxTLkwqT9e1SAlOfXd
	 IRhC/NZT0Kr9bveewyxi3UWWb/AOYbyqpcxL/l6hGPAiA6OXwSgWo9ZX1hn5R1NW+r
	 1D8pi47FJCyAaQ2mzGKr1r9jjklUj4IWDj6F3RJcZiGaO8jnOBAH0ZW+H/Enb2I1N9
	 47kqZXfoCSkY06rcJ/YVpKW7E4wJl9myAOB+ySpZt4IrMj5mPfSn286ImUxZkRRSEp
	 NsLVPb1zNGoOpJbN9QnUyVKC7TpLqY01mMBfj0x25DDuhlesrVblxdPJNOg8Wk8PMe
	 a4x8kTnmhljLg==
Subject: Re: [PATCH net] netfilter: ipset: exclude add-path GC during resize
From: netdev-bot+sashiko@kernel.org
To: onleaf322@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, kadlec@netfilter.org,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 19 Nov 2026 21:27:37 +0000
Message-ID: <179512365704.3136.7898068439962970821@kernel.org>
In-Reply-To: <20261117092731.14656-1-onleaf322@gmail.com>
References: <20261117092731.14656-1-onleaf322@gmail.com>
X-sashiko-severity: Critical
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 1 · High: 0 (1) · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] The fix is incomplete.
- [Low] The commit carries `Cc: stable@vger.kernel.org` and `Fixes:
  f66ee0410b1c`, a 2020 commit, so stable maintainers will try to apply…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but a successful
  resize leaks the comment extensions of elements that had already…

--

netfilter: ipset: exclude add-path GC during resize

This patch takes h->gc.lock around the direct mtype_gc_do() call in
mtype_add() and skips the collection when the pinned table has resizing
set. The goal is to keep the packet-side add path from freeing extensions
of old-table elements that mtype_resize() has already copied into the new
table.

> Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
> Cc: stable@vger.kernel.org

[Severity: Low]
The new code uses h->gc.lock and t->resizing. Both were added by
cffcf57bf03c ("netfilter: ipset: exclude gc when resize is in progress"),
which has no Fixes: or Cc: stable tag. The commit message mentions it only
as background.

Stable trees that have f66ee0410b1c but not cffcf57bf03c won't build this
patch. A hand-adapted backport could also add the add-path check without
the matching resize-side flag and lock.

Should the stable tag record the dependency, for example
"Cc: stable@vger.kernel.org # depends on cffcf57bf03c", or ask for
cffcf57bf03c to be backported as well?

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 80ca523f304bb..70f768ba7b443 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1009,8 +1009,12 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	maxelem = t->maxelem;
>  	if (elements >= maxelem) {
>  		u32 e;
> -		if (SET_WITH_TIMEOUT(set))
> -			mtype_gc_do(set, h, t, r);
> +		if (SET_WITH_TIMEOUT(set)) {
> +			spin_lock_bh(&h->gc.lock);
> +			if (!t->resizing)
> +				mtype_gc_do(set, h, t, r);
> +			spin_unlock_bh(&h->gc.lock);
> +		}
>  		maxelem = h->maxelem;
>  		elements = 0;
>  		for (e = 0; e < ahash_numof_locks(t->htable_bits); e++)

[Severity: Critical]
Does this fully close the double free? Only the direct mtype_gc_do() call
is guarded. Other packet-path sites still call ip_set_ext_destroy() on
elements of the pinned old table while mtype_resize() runs.

mtype_resize() makes a shallow copy of each live element. It holds only
rcu_read_lock_bh() and no hregion locks:

    d = ahash_data(m, m->pos, dsize);
    memcpy(d, data, dsize);

After the copy, both tables point to the same ip_set_comment_rcu. Hash
types set region_lock, so packet-side ip_set_add() and ip_set_del() can
run at the same time as this copy.

The first site is the reuse/forceadd branch later in mtype_add():

    if (reuse || forceadd) {
        if (j == -1)
            j = 0;
        data = ahash_data(n, j, set->dsize);
        if (!deleted) {
            mtype_del_cidr_all(set, h, data);
            ip_set_ext_destroy(set, data);
            t->hregion[r].elements--;
        }
        goto copy_data;
    }

This branch can free the comment of an element that was live when copied
and has expired since. That is the same timing as the race in the commit
message. With forceadd it evicts slot 0, a live element that has already
been copied, so no expiry timing is needed.

GC is now skipped on a resizing table. When expired entries are present,
the recomputed elements stays >= maxelem. Doesn't that make forceadd more
likely to take this eviction path?

The second site is mtype_del():

    mtype_del_cidr_all(set, h, d);
    ip_set_ext_destroy(set, data);

    if (t->resizing && ext && ext->target) {
        ...
            x->ad = IPSET_DEL;

This frees the comment in the old table and queues an IPSET_DEL record.
After the new table is published, mtype_resize() replays the record:

    mtype_del(set, &x->d, NULL, NULL, 0);

The replay finds the copied element in the new table and calls
ip_set_ext_destroy() again on the same comment pointer.

ip_set_comment_free() clears only the slot it is given:

    atomic64_sub(sizeof(*c) + strlen(c->str) + 1, &set->ext_size);
    rcu_assign_pointer(comment->c, NULL);
    kfree_rcu(c, rcu);

In each case the new table keeps a dangling pointer. The next GC, delete,
flush/destroy or backlog replay on it then calls strlen() on freed memory
and does a second kfree_rcu(). A dump would also read freed memory
through ip_set_put_comment().

Would it be better to stop or defer all extension destruction on the old
table while t->resizing is set? Another option is to have the new table
take ownership of the extensions during resize, by transfer or deep copy.

[Severity: High]
This is a pre-existing issue, but does a successful resize leak the
comment extensions of elements that had already expired but had not been
collected yet?

mtype_resize() skips those elements during the copy:

    if (SET_ELEM_EXPIRED(set, data))
        continue;

It then frees the old table without extension cleanup:

    if (atomic_dec_and_test(&orig->uref)) {
        pr_debug("Table destroy by resize %p\n", orig);
        mtype_ahash_destroy(set, orig, false);
    }

With ext_destroy set to false, mtype_ahash_destroy() skips
mtype_ext_cleanup(). orig->resizing stays true after a successful resize,
so mtype_gc() never runs mtype_gc_do() on orig. With this patch the add
path doesn't either:

    if (!t->resizing)
        mtype_gc_do(set, h, t, r);

So the ip_set_comment_rcu objects that ip_set_init_comment() allocated
for those elements are never freed. set->ext_size is never reduced for
them either.

Before this patch, the add-path GC could still free some of those
uncopied expired comments while running on orig. This check closes that
window as well.

ipset netlink commands need only CAP_NET_ADMIN in the caller's own user
and network namespace, and these allocations are not memcg accounted. Can
a user repeat create, expire, resize and destroy to use up host memory?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117092731.14656-1-onleaf322%40gmail.com
