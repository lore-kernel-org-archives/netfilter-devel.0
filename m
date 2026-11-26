Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795678516;
	b=GioLt+IEq2eJhqjDE4tx3yVTsn/gUT8nwy1rN9FQ7sy4M2zU2b6FYRUqN72t0C5QJJ+l
	 sEgAbK1fsUP0XMwyaT0Gkg1RufUvHkgQpsJwmwTd+BPCPY3b8S9vgfgGl6heTq+mcxV1U
	 z0Nw6uRB4lTGCY3MfryKcV6WdTq1y1pnmP5TZHbX63aMs+ZwCuMm4hq0gellEaRXbwFCv
	 Ms/3Bf7gJnPCcy30a+HwC6hhw3qalPYjBm11YusuVFlS3/f6KHnhG+tFB9eUK4Gti6jue
	 zatUupreoiOBpBardWlIwqyn53v1VEoaOEpKHpLVxK3eep0mUw4KQz4iKTOcaO/60JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795678516;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=M0Flsf6nylnvXa67j+kFp5pfohgWPoECa8mwzAsasWc=;
	b=bC/OTz2b2YgXAvvDh6qUMNplW2aJJYGJdJZ45IQlINhRCOebJ2cNO96iQ+32YR1k05Rl
	 4gdB97Hre6r7Xl9gZPq66uKuC4GcwlTuOMGCh9rkEyjimsf2J0kURxhkkYYeJdrvJVjFe
	 ybPBXYrQ4pm1wy4V34VEz13GaD9hSEqg1lTRKvcIp2wcafQo2fx0EDBSNtXwbSos9J8Ak
	 nEReGCcUrI4MfP3LpTtxUArCFGP6Gb0GsoTRcXqlXLCDkN3QPtgzshAlqjoeNUCgTDRiC
	 62AtzkOtl4aU3tA44OODte6/5d+GwpiK3j7HQrm7klcAgy5FlftpmTzcBMESHgl3GQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUNdrgXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ED5606A31C;
	Thu, 26 Nov 2026 07:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUNdrgXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E091F000C4;
	Thu, 26 Nov 2026 07:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795678515;
	bh=M0Flsf6nylnvXa67j+kFp5pfohgWPoECa8mwzAsasWc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=LUNdrgXNn7BVHOiBmBTsGBnFmHtKaelTndLNt7lUFtoV+BgHc4WOEtnQ1hYYNBiuf
	 BKmD0qbDqTG/MDLDr4GymzseFD9D06bFtOzYOuTtCiChyUL757153bBECr4WmKQk7v
	 +GTLfV/WX3foH/fQC+1jk4jHgS2W7oRopuVY/OjGbo5VQ8sYxMjvGFOv/s3yuLjBMg
	 WPY1fDYuzpGp8uuuEIQgUsDt+ekqVH0bfy6cjHw75DSHNESIJILZb38PlW/fVG6zX+
	 novYDdrCqf9+JLHM/byzDILWz/0Yr8/w1wwoHu4JvHDWFSGstUfWP1XdmzCFq9zFlH
	 3bB4jOhtiJh3g==
Subject: Re: [PATCH net v3 1/2] netfilter: nf_dup: do not duplicate packets
 from br_netfilter
From: netdev-bot+sashiko@kernel.org
To: theodorlarionov@gmail.com
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Date: Thu, 26 Nov 2026 07:35:14 +0000
Message-ID: <179567851468.3135.1445286719198754408@kernel.org>
In-Reply-To: <20261124163358.755345-2-theodorlarionov@gmail.com>
References: <20261124163358.755345-2-theodorlarionov@gmail.com>
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

- [Medium] nf_dup_ipv4() and nf_dup_ipv6() now return early, doing
  nothing, for every skb that carries SKB_EXT_BRIDGE_NF.

--

netfilter: nf_dup: do not duplicate packets from br_netfilter

This commit makes nf_dup_ipv4() and nf_dup_ipv6() return early when the
skb carries bridge netfilter info. It does this to avoid a KMSAN infoleak.
The leak happens when a tcp reset reject of the pskb_copy() duplicate takes
the bridge path in nf_send_reset() or nf_send_reset6() and builds the
Ethernet header from uninitialised headroom.

> diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
> index 9a773502f10ac..a4ad26a564a46 100644
> --- a/net/ipv4/netfilter/nf_dup_ipv4.c
> +++ b/net/ipv4/netfilter/nf_dup_ipv4.c

[ ... ]

> @@ -53,6 +54,11 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
>  {
>  	struct iphdr *iph;
>  
> +#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +	if (nf_bridge_info_exists(skb))
> +		return;
> +#endif
> +

[Severity: Medium]
Does this turn off TEE and nft dup completely for any packet that has
passed through br_netfilter?

The check runs on the original skb before pskb_copy(). With
bridge-nf-call-iptables or bridge-nf-call-ip6tables enabled, a rule like
this one no longer sends any copy:

  iptables -t mangle -A PREROUTING -m physdev --physdev-in X \
           -j TEE --gateway G

The same applies to packets that enter on a bridge port and are then routed
or delivered locally. That is common on container and VM hosts.

Nothing reports the skip. Both functions return void, and the xt_TEE
callers always continue:

net/netfilter/xt_TEE.c:tee_tg4() {
	...
	nf_dup_ipv4(xt_net(par), skb, xt_hooknum(par), &info->gw.in, oif);

	return XT_CONTINUE;
}

So the rule still matches and its counters still go up, but no copy is
sent. Because of Cc: stable, this change would also reach stable trees.

The commit message mentions the routed and local delivery side effect. It
does not say that mirroring of bridged traffic stops completely.

Would it work to remove the extension from the copy instead? For example,
call skb_ext_del() with SKB_EXT_BRIDGE_NF on the new skb right after
pskb_copy().

nf_dup_ipv4_route() gives the duplicate its own dst and dev, and
ip_local_out() sends it, so the bridge info it inherits is stale. Both
reject paths choose the bridge path only by checking for the extension:

net/ipv4/netfilter/nf_reject_ipv4.c:nf_send_reset() {
	...
	if (nf_bridge_info_exists(oldskb)) {
		struct ethhdr *oeth = eth_hdr(oldskb);
	...
}

nf_send_reset6() has the same check.

Without the extension, a reject of the copy would go down the normal
ip_local_out() or ip6_local_out() path. Physdev and other bridge info users
would also stop seeing the original's ports on the copy. Dup would keep
working for bridged traffic.

The later patch in this series, "net: unset the mac header of a pskb copy
that points into headroom", relies on this skip to avoid an out-of-bounds
eth_hdr() read in the reject bridge path. Would removing the extension from
the copy also meet that need?

The same question applies to the identical check added to nf_dup_ipv6().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124163358.755345-1-theodorlarionov%40gmail.com
