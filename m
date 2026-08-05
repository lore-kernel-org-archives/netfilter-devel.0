Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D49B3603EF;
	Wed,  5 Aug 2026 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785889149; cv=none; b=WS1s5zKITy1nn/XJAeSmxXvLHcuFWu7tZ6t0kw9OxGusBwzlQcLOs2XgvZwlQ8grCCBl4P3KiDDIKpnYP3uElJ2GeUaVGUJwjWH/uWyhPZNZV4uR+R8bN6Xp7gJN2oSdEbN4QPOE6lUlwIyb6hO8FR2xztZNZzeu1t07DrxtGJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785889149; c=relaxed/simple;
	bh=0b1d+0/0eScVDrxhtvsJObYuvU8VsFpEOXeNvpsgPDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYjIgppTDRza41cR8ZFwImK38/p2lq8j7rvE89b5+IvhaOHUHm39j8eJGrn7COnPyfM4uJWhuPx5LwS7VldCyvzuBjpxtYCQsptdLxEvEdLZS9/ZL1Btl4bcZnh558VYce9yXXhrV/R70z8pfJJHAv5XBz7hhxK41hAVt5q+g1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ew4Ll1pQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ew4Ll1pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E22B1F000E9;
	Wed,  5 Aug 2026 00:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785889147;
	bh=M01c61g3la9+F8Tt+Jf/iP30fvUSw/0ZpSHAVKfvyBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ew4Ll1pQnagaLo77zAQBT7quGJ9kAQw2kWI+oY01KIs2PE2noa/WggeCiID8NGr4s
	 V2YjpHRoRATskdatRXFX4zfTXBbp7Kl+OJfHH/HflXPjcj0FtFUUlmwehcjfqwsXZ3
	 DkhjWV3PqLW8xVNHBoHowSF1unV3Y+9149sYc+X5dQyai7UMjkmAGHXv44uDt9LE6j
	 +UAuU+K1BJibXsAUXXhUFi/axQS8JmJsB6+jqVD3ERwm63kHQi+jeSwoTb1byc0a+P
	 Fcz72P4jVjbnS0RiJmitGenJF7kvDM74lhoxdtrZTVEYHyQ70YvxjslQX+w/FV2+6s
	 w/rPj9/CGbIyA==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net-next 7/9] netfilter: flowtable: release tunnel route on error when building forward path
Date: Tue,  4 Aug 2026 17:19:06 -0700
Message-ID: <20260805001906.3985830-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731153402.851224-8-pablo@netfilter.org>
References: <20260731153402.851224-8-pablo@netfilter.org>
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
netfilter: flowtable: release tunnel route on error when building forward path

This drops the second route lookup in nft_flow_tunnel_update_route() and
instead passes the dst_entry obtained by dev_fill_forward_path() through
the tunnel forward path information, so ipip and ip6ip6 no longer release
it.  On failure while building the forward path the tunnel dst is released
via dev_fill_forward_path_release().

> diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> index 0831f6b81717c..fb7d96f99b06b 100644
> --- a/net/ipv4/ipip.c
> +++ b/net/ipv4/ipip.c
> @@ -376,10 +376,10 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
>  	path->tun.src_v4.s_addr = tiph->saddr;
>  	path->tun.dst_v4.s_addr = tiph->daddr;
>  	path->tun.l3_proto = IPPROTO_IPIP;
> +	path->tun.dst = &rt->dst;
>  	path->dev = ctx->dev;
>  
>  	ctx->dev = rt->dst.dev;
> -	ip_rt_put(rt);
>  
>  	return 0;
>  }
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 97c3f61d627bb..d80020bc2620e 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1870,12 +1870,14 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
>  		path->tun.src_v6 = fl6.saddr;
>  		path->tun.dst_v6 = fl6.daddr;
>  		path->tun.l3_proto = IPPROTO_IPV6;
> +		path->tun.dst = dst;
>  		path->dev = ctx->dev;
>  		ctx->dev = dst->dev;
>  	}
>  
>  	err = dst->error;
> -	dst_release(dst);
> +	if (err)
> +		dst_release(dst);
>  
>  	return err;
>  }
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index 004dc75ac357a..56219b02e1227 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c

[ ... ]

> @@ -205,44 +211,6 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
>  	return found;
>  }
>  
> -static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
> -					struct flow_offload_tunnel *tun,
> -					struct nf_flow_route *route,
> -					enum ip_conntrack_dir dir)
> -{
> -	struct dst_entry *cur_dst = route->tuple[dir].dst;
> -	struct dst_entry *tun_dst = NULL;
> -	struct flowi fl = {};
> -
> -	switch (nft_pf(pkt)) {

[ ... ]

> -	nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt));
> -	if (!tun_dst)
> -		return -ENOENT;
> -
> -	route->tuple[dir].dst = tun_dst;
> -	dst_release(cur_dst);
> -
> -	return 0;
> -}
> -
>  static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  				struct nf_flow_route *route,
>  				const struct nf_conn *ct,
> @@ -267,12 +235,13 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
>  	}
>  
> -	if (info.num_tuns &&
> -	    !nft_flow_tunnel_update_route(pkt, &info.tun, route, dir)) {
> +	if (info.num_tuns) {
>  		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
>  		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
>  		route->tuple[!dir].in.tun.l3_proto = info.tun.l3_proto;
>  		route->tuple[!dir].in.num_tuns = info.num_tuns;
> +		dst_release(route->tuple[dir].dst);
> +		route->tuple[dir].dst = info.tun_dst;
>  	}

[Severity: High]
Can the dst installed here end up belonging to a different address family
than the flow it is attached to?

The removed nft_flow_tunnel_update_route() derived the replacement dst from
nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt)), so the dst family
always matched the flow's l3proto.  The dst that now arrives in
info.tun_dst follows the tunnel underlay instead:

net/ipv4/ipip.c:ipip_fill_forward_path() always stores an IPv4 rtable:

	path->tun.l3_proto = IPPROTO_IPIP;
	path->tun.dst = &rt->dst;

net/ipv6/ip6_tunnel.c:ip6_tnl_fill_forward_path() always stores an IPv6
rt6_info:

	path->tun.l3_proto = IPPROTO_IPV6;
	path->tun.dst = dst;

Neither handler consults the tunnel payload proto, and neither
nft_dev_path_info() nor nft_dev_forward_path() checks the family before
storing it in route->tuple[dir].dst.

The consumers cast that dst according to the inner flow family.  In
net/netfilter/nf_flow_table_ip.c:nf_flow_offload_ipv6_hook():

	rt = dst_rt6_info(tuplehash->tuple.dst_cache);
	...
	neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, ip6_daddr));

and in nf_flow_offload_ip_hook():

	rt = dst_rtable(tuplehash->tuple.dst_cache);
	... rt_nexthop(rt, ip_daddr) ...

net/netfilter/nf_flow_table_core.c:flow_offload_dst_cookie() does the same:

	if (flow_tuple->l3proto == NFPROTO_IPV6)
		return rt6_get_cookie(dst_rt6_info(flow_tuple->dst_cache));

For an ip6_tunnel in ip4ip6 mode (t->parms.proto == IPPROTO_IPIP) carrying
IPv4 flows, ip6_tnl_fill_forward_path() still reports l3_proto =
IPPROTO_IPV6 and hands out an rt6_info, which nf_flow_offload_ip_hook()
then reads through dst_rtable() and rt_nexthop()/ip_mtu_locked().  That
configuration needs no misconfiguration to reach.

The mirror case is an IPv6 flow routed out an ipip device: an ipip device
with mtu 1480 gets an inet6_dev at NETDEV_REGISTER, so fib6_nh_init()
accepts "ip -6 route add ... dev tunlX", and nft_dev_fill_forward_path()
deliberately skips the ether-device requirement for tunnels, so
ipip_fill_forward_path() hands back an rtable that becomes the dst_cache of
an IPv6 flow.  rt6_nexthop() then reads rt6i_flags and rt6i_gateway past
the end of a struct rtable allocated from the ip_dst_cache slab, and the
result is used as the IPv6 next hop passed to ip_neigh_gw6().

nf_flow_dst_check() does not catch this either: dst->ops->check() for the
stored rtable is ipv4_dst_check(), which only tests rt_is_expired().

Would it make sense to validate info.tun.l3_proto (or the dst's
ops->family) against the flow's l3proto before installing info.tun_dst?

[Severity: Low]
Should this carry a Fixes: tag?

Before this change the tunnel information was only installed when the
second lookup succeeded:

	if (info.num_tuns &&
	    !nft_flow_tunnel_update_route(pkt, &info.tun, route, dir)) {

while route->tuple[!dir].in.ifindex, route->tuple[dir].out.ifindex, the
encaps, h_source/h_dest and xmit_type had already been written and
nft_dev_forward_path() still returned 0.  On nf_route() failure the flow was
offloaded with the underlay device as output but num_tuns == 0, so inner
packets left the underlay without IPIP/IP6IP6 encapsulation, which matches
the "incomplete forward path" described in the commit message.

git blame points that construct at d30301ba4b07ac ("netfilter: flowtable:
tunnel route update"), with the tunnel forward path support itself from
ab427db1788581, so the bug is in released kernels rather than in-flight
code from this series.  A Fixes: d30301ba4b07ac tag would help stable
tracking.

It may also be worth noting in the changelog that this is not standalone
backportable: neither dev_fill_forward_path_release() nor the
net_device_path tun.dst field exist before the earlier "net: pass dst via
net_device_path in dev_fill_forward_path()" commit in this series.
