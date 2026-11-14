Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626630;
	b=BbWkOqV84vqFNCTp37uE9wR66mU+dpDUPIZKAchgfZ1FyGEufusjXMmHTNTCriTzFWWy
	 SsamghdLIZWZDahqe9Gzy0EWW6ZCFcapFL+qdp8Xwb87WhLkw/DzpHE3yGU/1VxIXtd6j
	 5IHG8X6Du9oMOIqOyNsqokpaLDVQJ/CaT7+VJBfdaQytsm13jHXa5GdPG0qwYl6+DrYo/
	 zyxjSJ1YQbyfu0irxjMzBRgJQALYbJowDugLUR34Y4/seQpfog6fxvakH+OZ+2lj8SFp9
	 V+ZIEF8geAlNuQAlIK4gwkxgehg5rGSP8rsvfXakFrgUPCPisD523Qgezo52yUa72Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626630;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=XK6PHYI086f0nZLFGr1/Sq6jz5XGoz0jkX+dxYMn0Mg=;
	b=ZLr2LS7j5u9K5XXEVVua6ahYy615eS0Ky2q5WRNxPL7QomgZQJvnb0mbfWLSBYKe4njb
	 0OqhCVorGX4auRrVLMTroOuKY99mSMfEe3kc2A4kfQKT/20rZT2AmYiEcQfbLs9djs7IW
	 gf4nMt4BwpRzt6btasNlwndLl7Q789DpVCf/fVDbmp8yX7yAV5W+vLDNq5/9i0Dgpxen2
	 9wFZKT8MRObPqlsIzhyF4rxc8fdkEl7e2IvXYJayWA0Gop09j4l3a6us/iYV56YEtgkq7
	 mJHqs0n5LCXJ0hU1JCCN1MU2UC9hy+2IXJKPg96Bkx8wRsf2X5r745/MTe5wK7Lc7cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNjvakiB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2446960A2620;
	Sat, 14 Nov 2026 03:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNjvakiB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6A51F000C4;
	Sat, 14 Nov 2026 03:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626630;
	bh=XK6PHYI086f0nZLFGr1/Sq6jz5XGoz0jkX+dxYMn0Mg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hNjvakiBDcf/EPRUdFHR0T8K1E9mjJXljyYq/awcTRBwo9jnQ3pdab9BuericAX/R
	 YQqxDkcIdLEXSEF4zCVh/9R/ICdprt+16Kjyfy1nP8EG5W1PWma4sss7QIrcW4EWPP
	 BMEO5/V4Bq8qIA4oQVTBHuAWpTXQzPy1roLzT+92Ws39H0BuPm/oXZjmuxG3xWDAz4
	 mFu3bpljInOtPXMWdoodI3EjxXBcGg9m5BeMR7j01csf5LVmvm3Eiv2P0clRE4dVI4
	 6UtPXNq1esVmNY7Sm1hWpSQt3roShIZ7pLH9pgFX468Jd3Rh/HptJpvBwzKUmcKZOH
	 P2t8wRZVgDr+Q==
Subject: Re: [PATCH net-next 11/15] netfilter: flowtable: do not scrub as
 crossing netns
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:49 +0000
Message-ID: <179462662909.2199510.3682917191750887644@kernel.org>
In-Reply-To: <20261113031251.2437074-12-pablo@netfilter.org>
References: <20261113031251.2437074-12-pablo@netfilter.org>
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

- [Low] The Fixes: tag and the commit message cover only one of the two
  changed call sites.

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch.

--

netfilter: flowtable: do not scrub as crossing netns

This commit changes the flowtable tunnel push helpers from
skb_scrub_packet(skb, true) to skb_scrub_packet(skb, false). The skb mark
is now kept on encapsulated packets. The commit message says the IPIP
tunneling fast path does not cross a netns.

> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 644e70fd6773b..001abfae5a1ff 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -630,7 +630,7 @@ static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
>  	if (err)
>  		return err;
>  
> -	skb_scrub_packet(skb, true);
> +	skb_scrub_packet(skb, false);

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch. Is
the hard-coded xnet = false in nf_flow_tunnel_ip_push() and
nf_flow_tunnel_ip6_push() correct only because the fast path routes in
dev_net(dev) and not in the tunnel's link netns?

The slow path routes in tunnel->net or t->net, and it decides xnet per
device:

net/ipv4/ip_tunnel.c:ip_tunnel_xmit() {
    ...
	iptunnel_xmit(NULL, rt, skb, fl4.saddr, fl4.daddr, proto, tos, ttl,
		      df, !net_eq(tunnel->net, dev_net(dev)), 0);
    ...
}

net/ipv6/ip6_tunnel.c:ip6_tnl_xmit() {
    ...
	skb_scrub_packet(skb, !net_eq(t->net, dev_net(dev)));
    ...
}

The forward path helpers that admit the flow look up the outer route in
the device netns instead:

net/ipv4/ipip.c:ipip_fill_forward_path() {
    ...
	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, tiph->saddr,
			     inet_dsfield_to_dscp(tiph->tos),
			     tunnel->parms.link, RT_SCOPE_UNIVERSE);
    ...
}

net/ipv6/ip6_tunnel.c:ip6_tnl_fill_forward_path() {
    ...
	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
    ...
}

Neither helper rejects a tunnel whose link netns differs from
dev_net(dev). nft_dev_path_info() does not reject it either, because it
only checks nft_flowtable_find_dev(info->dev, ft).

Take an ipip or ip6tnl device whose link netns is A but which lives in
netns B. Could the offloaded packets of a flow be routed with B's routing
table, while the slow-path packets of the same flow leave through A's
underlay?

With this patch the two paths would also handle skb->mark differently.
The slow path clears it and the fast path keeps it.

Could ipip_fill_forward_path() and ip6_tnl_fill_forward_path() return
-EOPNOTSUPP when the tunnel's link netns differs from dev_net(dev)? That
would also keep xnet = false correct. Another option is to route in
tunnel->net and carry the real xnet value through flow_offload_tunnel.

> @@ -702,7 +702,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
>  	mtu = dst_mtu(dst) - sizeof(*ip6h);
>  	mtu = max(mtu, IPV6_MIN_MTU);
>  	skb_dst_update_pmtu_no_confirm(skb, mtu);
> -	skb_scrub_packet(skb, true);
> +	skb_scrub_packet(skb, false);

[Severity: Low]
This isn't a bug, but the skb_scrub_packet() call in
nf_flow_tunnel_ip6_push() came from 93cf357fa797 ("netfilter: flowtable:
Add IP6IP6 tx sw acceleration"). It did not come from the commit named
in the tag:

  Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")

The commit message also only talks about "IPIP tunneling support".
However, this hunk changes the IPv6-outer encapsulation path too, so
skb->mark is now kept on those packets as well.

Earlier in the same series, "netfilter: flowtable: fix pmtu discovery in
nf_flow_tunnel_ip6ip6_push()" uses Fixes: 93cf357fa797 for this same
function.

Should a Fixes: tag for 93cf357fa797 be added, and should the commit
message mention the IPv6-outer path?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
