Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826097;
	b=xdd/i3LmVjY5VvDpW7mj8Yk/F/ozMIZyiAXx1qqTlxixHSEz4sAXiN/ez+PHxZE0P5Rr
	 LcYaO4uoWGosUFpwOza2CMuymc5tXMfVGY1HETWPPZaRCawTUUGBG7+hY98Ujhyix3ilo
	 LimrocKOUbIdwJg3Xioul05iFiza1uC91Jv1/SIyn5SmdTbfH+r0LWhJVBDq4Ttnxj8GF
	 Nx4KrJODxPOecahrBP6Y8goT2yZ0azLqaxnp/XHt3hm466qvcWU7QVOCo95w8p+db2ydW
	 WvSO5F2xIg6v5gaqzU8gdMpebY1MZ6+3Bvy6ldAyM7Nc6Q7VttX6l5sGdEvE0xpnLzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826097;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=mWsvyE4HmDPFOLNh72qbLxdcM0gLomTxyxmojJhynR4=;
	b=jTbdcTBzUKWEmUEW0j/J3Epq8pxbu6ZeRTUg98wpkH/ollgo4ocjTgu6rIYbCKUemUfJ
	 B1Xis9mimzqBMFeYhiN/JzNuuvL0XDY8lC7g/e1yFoss5tMh/n/JzCJ1xqHN8Mct3RaB/
	 X5Bz2mJIZnm+QiimadDy7Ysi7SwulvkirMQQ8D61QKHdP2v/Da92QLjj1mL0VD5QOF6qG
	 BiXYopjbQ/tOz5qtRYlpuLJVaSYraqBBFIiYwRIeO0BpvAcDcHpVgkr6SLsBz9ys6+cI8
	 Ur4keemFTnfapw54snl8+Tnt+J2enRn5AFksFB0SCqfLdRTazWEVXio8mxmHJ0ejaug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TBSq4Fkd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E03606A334;
	Mon, 16 Nov 2026 10:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TBSq4Fkd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E151F000C4;
	Mon, 16 Nov 2026 10:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826097;
	bh=mWsvyE4HmDPFOLNh72qbLxdcM0gLomTxyxmojJhynR4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TBSq4Fkd0HUYRDI0o+j8rL5XTl/PlJ3ZpRG/f8fvGMWTvC2STnKBqazv2UhEBtYpu
	 lMUZAAqkzG2ijOAB8Vk2k5Uen1vzoaTlwpSa65L0sa31B5p01bsx1xlRyjJXHJaPbs
	 1JyDeUc/uj0ZEEwyRyHPsShRGc1lKsylYlvu8lh1bkT3twAeOKPKZ9jvZMD3Rk8UCv
	 XzpVCy7I1mK2OE3QOEgzNcvECJVYGRqoDNhi6IHlPUeCUmFbNEu3Ag+M4A8M6FdtUg
	 NXjuqXT3DAoCEM9TbvOdQ8ZJS0VO+U4NIbVyDQC94iQXrB2cC6wvVL5SISLMg1M6LH
	 aULa1T5laQQdg==
Subject: Re: [PATCH net-next v3 3/4] netfilter: nft_fwd_netdev: drop the stale
 dst when steering to a device
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 jiri@resnulli.us, victor@mojatatu.com, sashiko-bot@kernel.org
Date: Mon, 16 Nov 2026 10:48:16 +0000
Message-ID: <179482609603.3136.17659916489453837940@kernel.org>
In-Reply-To: <CORE-9NOG.v3.r0.20261115050625-3@mojatatu.com>
References: <CORE-9NOG.v3.r0.20261115050625-3@mojatatu.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message justifies the change by saying "the route
  dst is never consulted", but that only holds for the neighbour lookup.
- [Low] This patch fixes a user-visible bug but has no Fixes: tag.

--

netfilter: nft_fwd_netdev: drop the stale dst when steering to a device

This patch makes the neighbour variant of the nft fwd expression release
the skb's dst before switching skb->dev to the configured device. Without
this, a packet parked on an incomplete neighbour's arp_queue could later
be sent with the link-layer header of the device it was originally routed
through. The release goes through skb_dst_drop_keep_metadata(), so
LWT/tunnel metadata is kept, and the packet is dropped if that copy fails.

Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/
Link: https://lore.kernel.org/netdev/avTfQjFQYR2NNdRg@chamomile/

> diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> index 7447da931a957..f486c7be385cf 100644
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c

[ ... ]

> @@ -160,6 +161,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
>  		goto out;
>  	}
>  
> +	if (!skb_dst_drop_keep_metadata(skb)) {
> +		verdict = NF_DROP;
> +		goto out;
> +	}
> +

[Severity: Low]
Should this have a Fixes: tag? The skb->dev = dev switch and the
neigh_xmit() call in nft_fwd_neigh_eval() both come from:

  d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")

That commit changed the device without releasing the dst, which is the
behaviour fixed here. Something like this would help stable pick it up:

  Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")

This patch also needs skb_dst_drop_keep_metadata(), which is added by the
earlier patch in this series, "net: dst: keep the LWT metadata of a
dropped route". Could that dependency be stated for backporters?

[Severity: Medium]
The commit message says:

  Both lookup inputs the neighbour transmission needs, the device and the
  nexthop, are supplied by the rule, so the route dst is never consulted.

Is that true beyond the neighbour lookup? This call runs for every packet
the neighbour variant of fwd handles, not only for packets that end up on
an incomplete neighbour's arp_queue. For a plain route,
skb_dst_drop_keep_metadata() ends up in skb_dst_drop(). After that, code on
the configured device's transmit path sees skb_dst(skb) == NULL.

One example is an NBMA ipip/gre device (tnl_params->daddr == 0) used as
the fwd target:

nft_fwd_neigh_eval()
  skb_dst_drop_keep_metadata()
  neigh_xmit()
    ... dev_queue_xmit()
      ip_tunnel_xmit()

net/ipv4/ip_tunnel.c:ip_tunnel_xmit() {
    ...
	dst = tnl_params->daddr;
	if (dst == 0) {
		/* NBMA tunnel */

		if (!skb_dst(skb)) {
			DEV_STATS_INC(dev, tx_fifo_errors);
			goto tx_error;
		}
    ...
			rt = skb_rtable(skb);
			dst = rt_nexthop(rt, inner_iph->daddr);
    ...
}

Before this patch, "fwd ip to X device tunX" on such a tunnel picked the
destination with rt_nexthop() of the old route. Now the packet would be
dropped and counted in tx_fifo_errors.

The ip6_tnl/sit NBMA paths that call dst_neigh_lookup(skb_dst(skb), ...)
look like they are affected the same way. So does route realm (tclassid)
classification on the target device's qdisc.

The change may well be correct overall. Could the commit message describe
this effect on the resolved-neighbour path too, and not only the arp_queue
drain?

>  	local_bh_disable();
>  	if (nf_dev_xmit_recursion()) {
>  		local_bh_enable();

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/CORE-9NOG.v3.r0.20261115050625%40mojatatu.com
