Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802566;
	b=od66h8V5IxJcXC4Psbwc7Il9AXDdExQr20SUVPeC3rG8BjQdumNPcBPQgmwKfCHHFG1K
	 C3Vsj3SS60pezy9CdhLrLdiu8Usb8I9kcQAk9qkXCwirpLewnJave04Av//hCje+x4Hlg
	 8LiPGQHDgpGjLjDSgSW90hMGY8T1d75IzOLe1rIcnr10aeZg5RaqA3ek/4DnMGIOBKpni
	 4dez3IhBvDiMtkL7QbinObt2e+x97LZuGEQ5ZahY6wXOLbR3QB1e84CUWhGm169JlimXh
	 gEaasMZ5FYfYSD7F8PGICTjGWjhKV7PWx2LKV3TYWR4cMuAFuDCJcldoLHWvrVZ0l0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802566;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=z3YCQFJFWGrmSKahPQO8CiOfaeEGUDYud9eigNpfAnY=;
	b=rCCj2YuKhNF7/7eWbKFz8qxQ+yoXn7ZtSIij89tbiYNt/uJRSu5iWRUGVJp0whZsZDrs
	 RWKfxLoQtCMonqNF1u8nnhFlG3lL3P+05KCQKVr42vGZ0pPIC57T8ve/kKDa2FKoDHtAq
	 oZCILmqMG+upBes3A28+N7O6jGjUq8ns2jXGK6XWHRDgKbBA3hV9GVHTlkrZlkeoq+bHM
	 GwgsOhjOgA8E0nuvpINEqOC/B/Ea3tocrvgC38btlXsdqzF3UyVrSE6wtgK2xZk9AKshQ
	 sXx+Us38QJxSfyJmGWypzMJj4Vs0o9UC9DedpJHFMNyBTk++5AJ+VGuX+LnR4xb11Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wz8axLqu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97DE606A32E;
	Wed,  4 Nov 2026 14:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wz8axLqu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF761F00A02;
	Wed,  4 Nov 2026 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802565;
	bh=z3YCQFJFWGrmSKahPQO8CiOfaeEGUDYud9eigNpfAnY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Wz8axLquisUvBrqO/qlAphPlBIBt3lk4/ZmPWu2ObWlP4XZpTrFMYMEbQCcYmgsU3
	 jy/yEir9gy2CaXgav/JLAkKtVqnOIILTfTy9Rx5Lfbkw+cW6VEAqVbR3dHvT2w2yPQ
	 ffC/5j6SOsBAREq0fI2fkweSzAd2pw2gYijEYWNaBDFvUP0g1Yl3UfPkQDuuCZXU1j
	 MIFPX3tGYjVMaHjqxDTymhh07p6kWQr+GeG3vSiRoYF0ciV69rwZkTcheg4QZYuBup
	 1GphqF2W1A9vZDRXQMoMFlt/lBBew4anBvydol6cQ59ysZC4b31SYBnw0NKVHa5pge
	 DY6LkDaYozvUw==
Subject: Re: [PATCH net 06/15] netfilter: nf_conntrack: limit expectation
 master chain depth
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Wed, 04 Nov 2026 14:29:24 +0000
Message-ID: <179380256479.488856.1820572025839621863@kernel.org>
In-Reply-To: <20261103140308.591690-8-pablo@netfilter.org>
References: <20261103140308.591690-8-pablo@netfilter.org>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new global limit NF_CT_MAX_EXPECT_CHAIN_LEN = 2, enforced by
  nf_ct_master_acceptable() inside nf_ct_expect_alloc(), is lower than…
- [Low] The commit message says only that the patch 'prevents unbounded
  ct->master->master->... chains'.
- [Low] The commit message describes ctnetlink_find_get_master() as
  making 'ctnetlink create paths return -EMLINK instead of falling…

--

netfilter: nf_conntrack: limit expectation master chain depth

This commit adds nf_ct_master_acceptable(), which walks the ct->master
chain. It is called from nf_ct_expect_alloc() so that no expectation can
be created once the chain reaches NF_CT_MAX_EXPECT_CHAIN_LEN (2). The
commit also adds ctnetlink_find_get_master(), so the ctnetlink create
paths reject such masters with -EMLINK.

> Also add ctnetlink_find_get_master and use it so that ctnetlink create
> paths return -EMLINK instead of falling through to nf_ct_expect_alloc()
> and returning a misleading -ENOMEM.

[Severity: Low]
Is this description accurate for ctnetlink_create_conntrack()? That path
never reaches nf_ct_expect_alloc(). For CTA_TUPLE_MASTER it assigns the
master directly:

net/netfilter/nf_conntrack_netlink.c:ctnetlink_create_conntrack() {
    ...
		__set_bit(IPS_EXPECTED_BIT, &ct->status);
		ct->master = master_ct;
    ...
}

So on that path, the check in ctnetlink_find_get_master() is the only
depth enforcement. It does more than fix an errno.

Could the commit message say this, so the hunk isn't read as cosmetic?

The misleading -ENOMEM also remains for the other nf_ct_expect_alloc()
callers, because a NULL return now means either OOM or depth rejection:

- ctnetlink_alloc_expect() still maps NULL to ERR_PTR(-ENOMEM). It is
  also reached from ctnetlink_glue_attach_expect() (nfqueue NFQA_EXP),
  which has no -EMLINK pre-check. nfqnl_ct_parse() ignores that return
  value, though.
- The ftp, irc, sane, tftp, amanda and sip helpers log "cannot alloc
  expectation" and return NF_DROP.
- nft_ct_expect_obj_eval() returns NF_DROP.

> This prevents unbounded ct->master->master->... chains.

[Severity: Low]
Should the commit message say what an unbounded chain leads to?
nf_ct_destroy() releases the master before it frees the ct, so the
release is not a tail call:

net/netfilter/nf_conntrack_core.c:nf_ct_destroy() {
    ...
	if (ct->master)
		nf_ct_put(ct->master);

	nf_conntrack_free(ct);
}

Suppose the masters have already left the hash table and each child
holds the last reference to its master. Freeing the leaf then recurses
nf_ct_put()->nf_ct_destroy()->nf_ct_put()... once per level.

Before this patch, only nf_conntrack_max bounded the depth. There are
two ways to build a long chain:

- ctnetlink CTA_TUPLE_MASTER, which needs CAP_NET_ADMIN (available
  inside a user namespace).
- Q.931 call forwarding from the network. expect_callforwarding() has
  no loop guard, unlike process_gcf().

This looks like a fix for kernel stack exhaustion, and it has a
Reported-by. Should it also carry a Fixes: tag and Cc: stable? The other
netfilter fixes in this batch carry Fixes: tags. Backporters would also
want to know about the H.323 behaviour change described below.

> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 335b8c43694f8..617178fd4d8bc 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -29,6 +29,8 @@ enum nf_ct_helper_flags {
>  
>  #define NF_CT_HELPER_NAME_LEN	16
>  
> +#define NF_CT_MAX_EXPECT_CHAIN_LEN	2
> +
>  /* Must be kept in sync with the classes defined by helpers */
>  #define NF_CT_MAX_EXPECT_CLASSES	4
>  
> @@ -159,6 +161,19 @@ static inline void nf_ct_help_put(const struct nf_conn *ct)
>  		kfree_rcu(helper, rcu);
>  }
>  
> +static inline bool nf_ct_master_acceptable(const struct nf_conn *m)
> +{
> +	unsigned int depth = 0;
> +
> +	while (m->master) {
> +		if (++depth >= NF_CT_MAX_EXPECT_CHAIN_LEN)
> +			return false;
> +		m = m->master;
> +	}
> +
> +	return true;
> +}

[Severity: High]
Is a limit of 2 enough for the in-tree H.323 helper? With this check, a
ct that has a grandmaster can no longer create expectations. Normal
gatekeeper operation builds a deeper chain than that:

RAS ct
  expect_q931() / process_acf() / process_lcf()  (assign_helper = q931)
Q.931 ct (master = RAS, set by init_conntrack())
  expect_h245()  (assign_helper = h245)
H.245 ct (master = Q.931, grandmaster = RAS)

Now suppose the H.245 ct sees an OpenLogicalChannel:

h245_help()
  process_h245()
    process_olc()
      process_h245_channel()
        expect_rtp_rtcp() / expect_t120()
          nf_ct_expect_alloc(H.245 ct)
            nf_ct_master_acceptable() -> false

expect_rtp_rtcp() then fails:

	if ((rtp_exp = nf_ct_expect_alloc(ct)) == NULL)
		return -1;

and h245_help() drops the packet:

      drop:
	spin_unlock_bh(&nf_h323_lock);
	nf_ct_helper_log(skb, ct, "cannot process H.245 message");
	return NF_DROP;

Wouldn't this drop the H.245 OLC packets of gatekeeper-admitted calls?
RTP, RTCP and T.120 would then never get expectations.

The GCF case fails one level earlier. In process_gcf(), a discovery RAS
ct expects a registration RAS ct. The helper already bounds this
recursion itself ("Avoid RAS expectation loops").

If the registration RAS then expects Q.931, that Q.931 ct already has
two ancestors. Its expect_h245() and fastStart process_olc() calls fail,
and q931_help() returns NF_DROP with "cannot process Q.931 message".

Does the bound need to be at least 3, or 4 for the GCF plus H.245 plus
RTP case? Or could the limit apply only to the self-recursive cases,
such as Q.931 to Q.931 call forwarding via expect_callforwarding()?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org
