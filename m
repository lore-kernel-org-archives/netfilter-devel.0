Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826099;
	b=rcwuYxslq+kjs/Sqa8DXA2MSrJMJI/vbuv/OjGK3I/gG5+ZnP7B5HJ3hvadQn87Z9RyV
	 mAC4CQgY1hqjJM+EM9aMSPuFEH8eyEZgm1tLPj+HjUyBei+18BH3obEN8DbZ/25o4WvNM
	 rsJNgVvSxCjk1MaBQnOWUmo2uzui4ed/FHdpg68f2/ISUGDL1cvszG9ZP7m6TnCbOgUeb
	 BHdpCEOy25Z15a6+435pGUdenRH8D8fNA61hTDcUXYp+agMMZNEpiuK+GDTW491Kl1sNo
	 uiviNfGqrikqEdDcrSGNz6Bc+VaEWHSGbh1pLVWdcQCACLtqJ8m0OJNKDUejWvpHQrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826099;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=RBr7T08CDXyEh5Mk2Quq/4B5EMCAxfNNg9PgBZ+5htE=;
	b=Cdg486dnG3I4T93hA+5wCIBH5AKVn7q14dfb7E0AqIUs7q45sNamARkrmYwWUYoRRpOL
	 gCt0ZtGOzs6iDmNZcVKyz75PBdanDEatxF8OG5Z/sdc/dmWfJF/QRpg+WSl7Ufead9BMB
	 Yqk+7zC/yS5CaIkAGAdGwhqo7PU5495eihYYW0ANEfjvZNdt0fByKEC7HS34lqt9Thcpl
	 VdLhu4t165FgXtsYbpnidARNfb2qHT8DjVsULBgReyLxer8CwYure0im5HSmP66BhC/Z+
	 dYc9UkQmKzLJ61o/mIPiRN/KZfPAdKX7NSLv9iIULNCvoef7uexziT12Sq41IwPHdKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e8CjlPNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E58606A329;
	Mon, 16 Nov 2026 10:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e8CjlPNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B681F000C8;
	Mon, 16 Nov 2026 10:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826098;
	bh=RBr7T08CDXyEh5Mk2Quq/4B5EMCAxfNNg9PgBZ+5htE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e8CjlPNhE7F22ngOM2+QLr64fLVsvNQzUplJBn7/HbcpZqTd7s7Gl0dWdKUJ6aF9c
	 BETF2ZGYPoHLQuMG7UZzuvRd4ngWKppHXB+L52n0SjehLREKGp53qRJIiQhn7VQVui
	 Pd0EUEiC01mOz96C1D9Wnlpx5Im/LIJ9tHvPIH+ZQELBl9WXpzEFpB1W8XmYvRhV1/
	 QVYUFScNXwdwIirAAGqikWKzvTZEtd+oqOQaQif/rudcbSl3VF5xY8OboQLUjXE5GC
	 2pFn5ECuRhcJoo6tAvE8RV2jSJFr8sf0hGiG/ho88tmHDhABs5H5xjABwAumwSpBww
	 HlFRc8GlpmweA==
Subject: Re: [PATCH net-next v3 4/4] bpf: drop the stale dst when redirecting
 to an explicit nexthop
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 jiri@resnulli.us, victor@mojatatu.com, sashiko-bot@kernel.org
Date: Mon, 16 Nov 2026 10:48:17 +0000
Message-ID: <179482609749.3136.1445693542374471720@kernel.org>
In-Reply-To: <CORE-9NOG.v3.r0.20261115050625-4@mojatatu.com>
References: <CORE-9NOG.v3.r0.20261115050625-4@mojatatu.com>
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

- [Medium] The commit message says the explicit-nexthop branch "never
  consults the route dst, so nothing that describes the route is lost".
- [Low] The patch fixes a user-visible bug but has no Fixes: tag, and its
  commit message does not say which earlier patches it needs.

--

bpf: drop the stale dst when redirecting to an explicit nexthop

The patch changes __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6().
When the BPF program supplies the nexthop, they now release the dst the
packet arrived with, using skb_dst_drop_keep_metadata(). This stops a frame
parked on the target device's arp_queue from being rebuilt later from the
original route.

Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/
Link: https://lore.kernel.org/netdev/avTfQjFQYR2NNdRg@chamomile/

> diff --git a/net/core/filter.c b/net/core/filter.c
> index bd98d29ed7f8f..ae5346d6abd23 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2318,6 +2318,8 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
>  		skb_dst_set(skb, dst);
>  	} else if (nh->nh_family != AF_INET6) {
>  		goto out_drop;
> +	} else if (!skb_dst_drop_keep_metadata(skb)) {
> +		goto out_drop;
>  	}

[Severity: Low]
This isn't a runtime bug, but should this patch carry a Fixes: tag?

In both __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6(), the
if (!nh) { ... skb_dst_drop(); skb_dst_set(); } block with no else branch
for an explicit nexthop came from:

  ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support supplying nexthop")

So the stale dst has been reachable since that commit. Something like this
would get the fix into stable:

  Fixes: ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support supplying nexthop")

The baseline tree also has no skb_dst_drop_keep_metadata(). It is added
earlier in this series by "net: dst: keep the LWT metadata of a dropped
route".

The METADATA_XFRM dst it can install also depends on "net: xfrm: interface:
restore dst_orig on every xfrm interface". Without that commit, xfrmi_xmit2()
hits the skb_dst_set() warning, which panics under panic_on_warn.

Could the commit message name these prerequisites? A backport of this patch
alone will not build. A backport with only the helper would bring back the
xfrmi warning.

>  
>  	err = bpf_out_neigh_v6(net, skb, dev, nh);
> @@ -2433,6 +2435,8 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
>  
>  		skb_dst_drop(skb);
>  		skb_dst_set(skb, &rt->dst);
> +	} else if (!skb_dst_drop_keep_metadata(skb)) {
> +		goto out_drop;
>  	}

[Severity: Medium]
The commit message says:

  That branch never consults the route dst, so nothing that describes the
  route is lost

That holds for bpf_out_neigh_v4() and bpf_out_neigh_v6(). Does it also hold
for the target device's xmit path when the target is an NBMA tunnel (ipip,
gre, sit or ip6tnl with no remote address)?

On those devices the neighbour is NOARP with direct output, so the BPF
nexthop has no effect. The tunnel picks its outer endpoint from skb_dst():

tc egress prog
  bpf_redirect_neigh(nbma_ifindex, &nh, ...)
    __bpf_redirect_neigh_v4()
      skb_dst_drop_keep_metadata()
      bpf_out_neigh_v4()
        neigh_output() -> dev_queue_xmit()
          ipip_tunnel_xmit() / ipgre_xmit()
            ip_tunnel_xmit()

If the incoming route has no LWT state, skb_dst_drop_keep_metadata() leaves
the skb with no dst. ip_tunnel_xmit() then always drops the packet:

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
}

ip6_tnl_xmit() goes to tx_err_link_failure in the same situation, and sit's
ipip6_tunnel_dst_find() returns false. Before this patch these
configurations transmitted, using rt_nexthop() of the original route.

If the incoming route has LWTUNNEL_ENCAP_IP or LWTUNNEL_ENCAP_IP6, the skb
gets a METADATA_IP_TUNNEL metadata_dst instead. When that tun_info is not a
usable IPv4 endpoint (encap ip6, or encap ip with no dst), ip_tunnel_xmit()
falls through to:

		} else if (payload_protocol == htons(ETH_P_IP)) {
			rt = skb_rtable(skb);
			dst = rt_nexthop(rt, inner_iph->daddr);
		}

and ip6_tnl_xmit() does:

		} else if (payload_protocol == htons(ETH_P_IP)) {
			const struct rtable *rt = skb_rtable(skb);
			...
			if (rt->rt_gw_family == AF_INET6)
				memcpy(&fl6->daddr, &rt->rt_gw6, sizeof(fl6->daddr));
		}

skb_rtable() is a plain cast. Doesn't that mean rt_gw_family and
rt_gw4/rt_gw6 are read from the metadata_dst's tun_info key bytes?

The reads stay inside the metadata_dst allocation, and rt is not used as
the output route. The outer endpoint would still come from unrelated bytes,
though.

>From the struct layouts, rt_gw_family appears to overlay the first byte of
key.u.ipv4.src. If so, a 10.x.x.x source address would look like AF_INET6
to ip6_tnl_xmit() and produce a bogus fl6->daddr.

The tunnel drivers calling skb_rtable() without skb_valid_dst() is not new.
bpf_skb_set_tunnel_key() plus bpf_redirect() can already reach it. This
patch adds another way to get there, though, and turns a configuration that
used to transmit into one that always drops.

The same applies to __bpf_redirect_neigh_v6() when it hands packets to sit
and ip6tnl NBMA devices.

Is this change in behaviour intended? Could the commit message mention it?

>  
>  	err = bpf_out_neigh_v4(net, skb, dev, nh);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/CORE-9NOG.v3.r0.20261115050625%40mojatatu.com
