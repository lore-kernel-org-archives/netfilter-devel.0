Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20453E5A36;
	Wed,  5 Aug 2026 08:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785917224; cv=none; b=iyp9oMm4xpP15ZsdHTJNMeEj9DYctBgq2y1ejodfe/pkqFLC68eYypP4H5Ta3ZfEzg6AtHiSxcRacVpeyIXS3+/Dx3a7SiwvSFw+a08VzR9B3RY4+X+AfhfaHUk7hunC974wD1DAlb4jk2zlRQw1rtMneRdaginjE6ghUjL+cjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785917224; c=relaxed/simple;
	bh=nR9YQ/mw9S7ArxXAWGF/Lv9Og94U/74hmkJBYajrtMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MI0VOKCfdbN6mbFsabADJOQbimCWDxEii1pCebXPaHiA0sZ9kgT5On13nOK0HMJX009rrCltEFY7echz2z5bW18LVS747wkJ2R9zJzDSIqbuEHjX9jo2I2WviYGPe+iUmn2F+ONrLXVAjf5RC9qFVRyzzvKHSfof0K4subNJGpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y3BAl8I1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y3BAl8I1"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A3EB060193;
	Wed,  5 Aug 2026 10:06:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785917210;
	bh=lMtahZnJoW9GcFogemqpgeE41rU2kjsDzcWc1CWPHRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y3BAl8I1t/oAgzpwmniv+lZo1Yw9IWsw7qGUDXPyshGBIVq1SEx84ERJVdcrnbB+e
	 ITeO9TTeGIJLi46GsVQiGXomsncQT8fxGDig14zTlureNz9KhLYMbVkZnBvsXHiwfH
	 rDVTepwjmczabDlQT8+CNlP0UnCAxZSbPJ+zKU5Y20fW03fJ0kgX/HF2PZ4zVFpz9Q
	 Qz+g9DDEXYUg5hSHWLGb98pxntXZIDafw6SrcHr51YqjcHj/xiiMKwBblQ1pgThzyt
	 VIP1atm5YmZAyyHZwboA8srQ5zzxilVkoiAD1ClZ6Xm7jo/WSf7WBo3NNt2Zp1R6xM
	 ubexa4wUFMrRw==
Date: Wed, 5 Aug 2026 10:06:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 7/9] netfilter: flowtable: release tunnel route
 on error when building forward path
Message-ID: <anLvGOGM_442ffej@chamomile>
References: <20260731153402.851224-8-pablo@netfilter.org>
 <20260805001906.3985830-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260805001906.3985830-1-kuba@kernel.org>

Hi,

On Tue, Aug 04, 2026 at 05:19:06PM -0700, Jakub Kicinski wrote:
[...]
> [Severity: High]
> Can the dst installed here end up belonging to a different address family
> than the flow it is attached to?

Yes, the extra check to ensure IPv4 over IPv6 does not end up with the
wrong route is really required, LLM is right here.

But such check will last not long because Lorenzo's Bianconi has been
working on ip over ipv6 series for the tunneling.

I think this is not a reason to stall this net-next series, and
I think this can be done it a follow up?

Reading the two comments on patches in this net-next PR, this is the
only one that is really an issue and I think it can be addressed in a
follow up.

> The removed nft_flow_tunnel_update_route() derived the replacement dst from
> nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt)), so the dst family
> always matched the flow's l3proto.  The dst that now arrives in
> info.tun_dst follows the tunnel underlay instead:
> 
> net/ipv4/ipip.c:ipip_fill_forward_path() always stores an IPv4 rtable:
> 
> 	path->tun.l3_proto = IPPROTO_IPIP;
> 	path->tun.dst = &rt->dst;
> 
> net/ipv6/ip6_tunnel.c:ip6_tnl_fill_forward_path() always stores an IPv6
> rt6_info:
> 
> 	path->tun.l3_proto = IPPROTO_IPV6;
> 	path->tun.dst = dst;
> 
> Neither handler consults the tunnel payload proto, and neither
> nft_dev_path_info() nor nft_dev_forward_path() checks the family before
> storing it in route->tuple[dir].dst.
> 
> The consumers cast that dst according to the inner flow family.  In
> net/netfilter/nf_flow_table_ip.c:nf_flow_offload_ipv6_hook():
> 
> 	rt = dst_rt6_info(tuplehash->tuple.dst_cache);
> 	...
> 	neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, ip6_daddr));
> 
> and in nf_flow_offload_ip_hook():
> 
> 	rt = dst_rtable(tuplehash->tuple.dst_cache);
> 	... rt_nexthop(rt, ip_daddr) ...
> 
> net/netfilter/nf_flow_table_core.c:flow_offload_dst_cookie() does the same:
> 
> 	if (flow_tuple->l3proto == NFPROTO_IPV6)
> 		return rt6_get_cookie(dst_rt6_info(flow_tuple->dst_cache));
> 
> For an ip6_tunnel in ip4ip6 mode (t->parms.proto == IPPROTO_IPIP) carrying
> IPv4 flows, ip6_tnl_fill_forward_path() still reports l3_proto =
> IPPROTO_IPV6 and hands out an rt6_info, which nf_flow_offload_ip_hook()
> then reads through dst_rtable() and rt_nexthop()/ip_mtu_locked().  That
> configuration needs no misconfiguration to reach.
> 
> The mirror case is an IPv6 flow routed out an ipip device: an ipip device
> with mtu 1480 gets an inet6_dev at NETDEV_REGISTER, so fib6_nh_init()
> accepts "ip -6 route add ... dev tunlX", and nft_dev_fill_forward_path()
> deliberately skips the ether-device requirement for tunnels, so
> ipip_fill_forward_path() hands back an rtable that becomes the dst_cache of
> an IPv6 flow.  rt6_nexthop() then reads rt6i_flags and rt6i_gateway past
> the end of a struct rtable allocated from the ip_dst_cache slab, and the
> result is used as the IPv6 next hop passed to ip_neigh_gw6().
> 
> nf_flow_dst_check() does not catch this either: dst->ops->check() for the
> stored rtable is ipv4_dst_check(), which only tests rt_is_expired().
> 
> Would it make sense to validate info.tun.l3_proto (or the dst's
> ops->family) against the flow's l3proto before installing info.tun_dst?
> 
> [Severity: Low]
> Should this carry a Fixes: tag?

No, and it is intentional.

I already noted this rare bug while working on this series which
results in an incorrect fastpath in case route goes away while flow
offload entry is being set up, but these tunneling support is recent,
and I really preferred to go for net-next.

That was a deliberate decision. Patches with Fixes: are picked more
quickly into -stable and I did not deem this to be urgent.

> Before this change the tunnel information was only installed when the
> second lookup succeeded:
> 
> 	if (info.num_tuns &&
> 	    !nft_flow_tunnel_update_route(pkt, &info.tun, route, dir)) {
> 
> while route->tuple[!dir].in.ifindex, route->tuple[dir].out.ifindex, the
> encaps, h_source/h_dest and xmit_type had already been written and
> nft_dev_forward_path() still returned 0.  On nf_route() failure the flow was
> offloaded with the underlay device as output but num_tuns == 0, so inner
> packets left the underlay without IPIP/IP6IP6 encapsulation, which matches
> the "incomplete forward path" described in the commit message.
> 
> git blame points that construct at d30301ba4b07ac ("netfilter: flowtable:
> tunnel route update"), with the tunnel forward path support itself from
> ab427db1788581, so the bug is in released kernels rather than in-flight
> code from this series.  A Fixes: d30301ba4b07ac tag would help stable
> tracking.
> 
> It may also be worth noting in the changelog that this is not standalone
> backportable: neither dev_fill_forward_path_release() nor the
> net_device_path tun.dst field exist before the earlier "net: pass dst via
> net_device_path in dev_fill_forward_path()" commit in this series.
