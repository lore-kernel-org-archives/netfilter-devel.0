Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826096;
	b=Bk29V73yVNpI2QZNv8hjJPJTVEkY/K69Adf7k1V6YC5kgicntWbif9NsfTF8P3gKKYMS
	 ks9gjAfnhVtCp9yVZypQoshEsV23CRBG8ozO9eh74DxJaGRGjtvhciYqIkVNhiqhZBL2s
	 JU24vmMerZEC1wdAS2MoNNtZJe9/OB6K544cSD8406e3WkhrMF5mXyExkxYyJ3r7MZVyW
	 Rb/pTGtR6L/l954UjGOEtj28Efvq834RXurOY5pf5/H3vGNe1bLwd8cAl+CYdAy2jwSmb
	 kDkVIX8XgOtgVMLbyuOVhhePeosL2pxEoNiKFAil/ittYAgciGf9HNP84wGD9Q8vH5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826096;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ie9yyPZ8NoCIdw93B1/vSPVtdv42jR0l99PvlwpZ28g=;
	b=pNkI6ehcKMxr3lvoJgo9JM61SVvcbnU1Fl8mYu9GeIs3Z4BpSQLnFpuodRZ+SMngX50e
	 Xusttb0ZYf3OEMyfamv7yNdvuB8qH3UqG5nsJqw2anQOyu3CKxIfZ8nNhBym9mtaMDiM5
	 QQ6gGFBaAygZf/gzGgzBuOUioBttDbYbHvgdPbpzD08GKkVaMqA/mIlPsMIIwtSDk9/KH
	 1G+lzCkDq+dTU/4Nno2r90JQg14xTm3U8bfahi2sd6J/WRSaWdPv0t8aLOs/TQTBK6YL/
	 jtv1wdtA/uUhaktUfRP86pd4BtR/45GRb/rVNJVIphilWvfWWMrbQHum2zBLbu+4yhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TuAWGlFG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C456606A31C;
	Mon, 16 Nov 2026 10:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TuAWGlFG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055211F000C4;
	Mon, 16 Nov 2026 10:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826095;
	bh=Ie9yyPZ8NoCIdw93B1/vSPVtdv42jR0l99PvlwpZ28g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TuAWGlFGIw6/bGm1/Fd52X5bl2kr4RXwGzwADDT/m02LBZtAP4aD8YhjeGZ11KgCi
	 0eW0rtNH7ABiEvMkrsIrYWBbrTySAU6HFhlpd4KvlIOXp//I9lxSsOolAd9FXUnxNt
	 9uY/VystpZY2Jn7KtA2fd3JXzAQzlwciThFKzdx1VaLsReZodYSmGCPXKI03jd8vLd
	 67ir2zc0KvJqIyWysTzJZ286A3GCc1mKnXn67bO8oHFaYmr1ea0PA63OnceAhjDdgR
	 l4pq2S6fFLcw6+J/bZ3aCunrBZENg9/vg21l+/o8c20wbYGRMteEc68NUMjqoWdgLB
	 B3+oBsu9hpYUQ==
Subject: Re: [PATCH net-next v3 2/4] net: dst: keep the LWT metadata of a
 dropped route
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 jiri@resnulli.us, victor@mojatatu.com, sashiko-bot@kernel.org
Date: Mon, 16 Nov 2026 10:48:14 +0000
Message-ID: <179482609455.3136.1654206746484449957@kernel.org>
In-Reply-To: <CORE-9NOG.v3.r0.20261115050625-2@mojatatu.com>
References: <CORE-9NOG.v3.r0.20261115050625-2@mojatatu.com>
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

- [Low] The commit message presents this patch as a bug fix, with a "The
  Fix:" section, a "Conditions to recreate the bug" section and the…
- [Low] The Return: section of the kernel-doc for
  skb_dst_drop_keep_metadata() (net/core/dst.c:370-373) does not match…

--

net: dst: keep the LWT metadata of a dropped route

This adds skb_dst_drop_keep_metadata(). It releases an skb's route dst
and moves any LWT encapsulation metadata onto a newly allocated metadata
dst: ip_tunnel_info for ip/ip6 encaps, xfrm_md_info for xfrm. The helper
is meant for the nft fwd and bpf_redirect_neigh() producers changed later
in the series.

> Found while working on the two producers that steer a packet to another
> device's neighbour, fixed later in this series. Both release the route
> dst on the way, and a route installed with an encapsulation carries the

[Severity: Low]
Is this description accurate for the tree at this commit?

nft_fwd_neigh_eval() in net/netfilter/nft_fwd_netdev.c goes straight to
neigh_xmit() and never calls skb_dst_drop():

	skb->dev = dev;
	skb_clear_tstamp(skb);

	nf_dev_xmit_recursion_inc();
	neigh_xmit(neigh_table, dev, addr, skb);

The nh != NULL path of __bpf_redirect_neigh_v4() and
__bpf_redirect_neigh_v6() in net/core/filter.c also leaves the original
route attached to the skb.

This commit adds no callers of skb_dst_drop_keep_metadata(). The route
release only appears in the later patches "netfilter: nft_fwd_netdev:
drop the stale dst when steering to a device" and "bpf: drop the stale
dst when redirecting to an explicit nexthop". The commit messages of
those patches say the producers currently leave the dst untouched.

> The Fix:
> Add skb_dst_drop_keep_metadata(), which moves those parameters onto a
> metadata dst of its own before the route is released.

[ ... ]

> Conditions to recreate the bug:
> Install a route with an encapsulation (ip route add ... encap ip id <id>
> dst <remote>, or encap xfrm if_id <id>), steer a packet to another
> device's neighbour with a netdev egress fwd rule or
> bpf_redirect_neigh(), and release the route dst before neigh_xmit() hands
> the packet on.

To reproduce, the reader has to release the route dst before
neigh_xmit(). Current code does not do that.

Could the message present this patch as a prerequisite helper for the
later producer changes, rather than as a fix with "The Fix:" and
"Conditions to recreate the bug:" sections?

> diff --git a/net/core/dst.c b/net/core/dst.c
> index 092861133023c..9c80c225cbfdd 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -353,3 +353,79 @@ void metadata_dst_free_percpu(struct metadata_dst __percpu *md_dst)

[ ... ]

> + * A dst that is metadata is left in place.
> + *
> + * Return: true if the skb is left free to be sent, either because its dst is
> + * metadata already or because the LWT metadata was moved onto a new dst;
> + * false if no copy could be allocated, in which case the caller must drop the
> + * skb.
> + */

[Severity: Low]
Does this Return: section match what skb_dst_drop_keep_metadata() does?

The doc says false only means no copy could be allocated. The XFRM
branch also returns false when skb_dst_force() fails:

		if (!skb_dst_force(skb)) {
			metadata_dst_free(md_dst);
			return false;
		}

This happens when a noref route's refcount has already reached zero, for
example during a concurrent route removal. By that point skb_dst_force()
has set skb->_skb_refdst to 0, so the skb comes back with no dst. The
commit message's "the skb is left untouched for its owner to drop" does
not hold here either.

The doc says true only means the dst was already metadata or the metadata
was moved. True is also returned when the skb has no dst at all, because
skb_valid_dst() is false for a NULL dst:

	if (!skb_valid_dst(skb))
		return true;

True is also returned when the route has no lwtstate, or an lwtstate type
other than IP, IP6 or XFRM (MPLS, SEG6, BPF and so on). In that case the
route is dropped and the skb is left without a dst:

	skb_dst_drop(skb);
	if (md_dst)
		skb_dst_set(skb, &md_dst->dst);
	return true;

The callers added later in the series drop the skb on false. Since this
helper is exported, could the kernel-doc spell out these cases?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/CORE-9NOG.v3.r0.20261115050625%40mojatatu.com
