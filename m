Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794784778;
	b=CjDTleJxlCe8BFOOzZI+KHnQPO5qrS3t9QhYW3RKojIEb4p0ZQKmTNm93oqVSgES3ucV
	 Q97w/nWWvd+ZapedgiqbpXYCFdWhXE/yCEwVxq37LEePticBmmf/DVfWtotmxOmf47Gyd
	 qlFKVpMIfh+tjUVHOJhKUJgyk9VofIeyBalQITVsJ18aquNNGV/Uw3DvazZNBhvJ5Aupw
	 +s2TNduejGoh7zw6YEDKLgqhCvagPCs7vsAjTcswKJXkmSVAbNHjd7GvbpGoG9c/AerhH
	 /Q6CRmI8LQZlvz+bFYDLmCQDoJVmBj85oZr/EznvhBiEL8K7uiQVTkJPPre3ro2YltQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794784778;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=uc8P1WN0oEBzoMuAmpqfg6VE+HcJ5yFiYx/c04QtQw0=;
	b=ol54fk3kabxQ611OkZOhdNWFqUK/M3bUACxn1OWnnCajfdiCWyCmFrw9xpxybCkwjMIx
	 a0YFwub8+bvPv/zw4XI1oRIg5NKNn9KPQz4rct1KEXgubwLlo7qp+Mkm+/pifaz6xzC4u
	 up2FTiWQneeMmJb8cDzzsU2Uo+1VhAmCs+LucW9UIec8MKdORARHwOYyH6jsh/YlsYKPA
	 585bZiPe0Gf/p3hRU81BDbrd0mOYy6XXFbKBwQD0ONjcb/s51RoAPa6Nr731QX2Qvay8X
	 5Ax65Ah80SUo6cdlP1uJ2ydkQ5izF0ToIca8BjMFoYfbGuGFQXnELLpKsV3dbmTUdPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="qg/n64oF";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EC9F8606A323;
	Sun, 15 Nov 2026 23:19:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC9F8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=qg/n64oF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794784775;
	bh=uc8P1WN0oEBzoMuAmpqfg6VE+HcJ5yFiYx/c04QtQw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qg/n64oF33SygJZZEq0M85D66dWNulr+xnQiwJFkwNvACxz5XSSy+nVR4uNuPE+9e
	 zzEpk9LtA3jRs7Zr8PEtxnq+COeVD9ekDkcveLFVWeXzQ6l2yx4kNHlf5VC0y2RU+U
	 dO6YVk8vAVrVv651W/3GlJ+iTzfXyGsVeH/R/AQZyWvYDF3kSkf781DuOWLTUMedMz
	 SokmjY/+0dgQFi3OIHWplms2AHz5Q50JkeqNRSp5gi9IHeA75W38hRgkNOT19FpOD+
	 180y/OF4rmHWU6dLmMr1lLfavbnRuomIZw5ARgcw7yMb0eX17nGV9yDeMcXpYDa2IP
	 35nFOoWktmhjQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4A1A0601C9;
	Mon, 16 Nov 2026 00:19:35 +0100 (CET)
Date: Mon, 16 Nov 2026 00:19:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 02/15] netfilter: flowtable: fix pmtu discovery
 in nf_flow_tunnel_ip6ip6_push()
Message-ID: <avo-BLBOzttTrGLi@chamomile>
References: <20261113031251.2437074-3-pablo@netfilter.org>
 <179462661985.2199510.8150694515960866760@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179462661985.2199510.8150694515960866760@kernel.org>

On Sat, Nov 14, 2026 at 03:23:39AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The fix does nothing.
> - [Low] The commit subject and body name nf_flow_tunnel_ip6ip6_push(),
>   which does not exist in the tree being patched.
> 
> --
> 
> netfilter: flowtable: fix pmtu discovery in nf_flow_tunnel_ip6ip6_push()
> 
> This commit moves skb_dst_update_pmtu_no_confirm() ahead of
> skb_scrub_packet() in nf_flow_tunnel_ip6_push(). The aim is to run the
> PMTU update before skb_scrub_packet() drops the skb dst. The inner route
> would then get the tunnel MTU, as it does in ip6_tnl_xmit().
> 
> > netfilter: flowtable: fix pmtu discovery in nf_flow_tunnel_ip6ip6_push()
> >
> > nf_flow_tunnel_ip6ip6_push() invokes skb_scrub_packet() before updating
> > the PMTU.
> 
> [Severity: Low]
> This isn't a bug, but there is no nf_flow_tunnel_ip6ip6_push() in this
> tree. Commit 93cf357fa797 added it under that name, and it was later
> renamed to nf_flow_tunnel_ip6_push(). It now also takes a dst argument and
> handles an IPPROTO_IPIP inner protocol.
> 
> Could the subject and body use the current name? It could also say that
> the change touches 4in6 encapsulation (e.g. DS-Lite) as well as IP6IP6.
> 
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > index 19cafae748abe..644e70fd6773b 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -699,10 +699,10 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
> >  	if (err)
> >  		return err;
> >  
> > -	skb_scrub_packet(skb, true);
> >  	mtu = dst_mtu(dst) - sizeof(*ip6h);
> >  	mtu = max(mtu, IPV6_MIN_MTU);
> >  	skb_dst_update_pmtu_no_confirm(skb, mtu);
> > +	skb_scrub_packet(skb, true);
> 
> [Severity: High]
> On the flowtable fast path, is there a dst on the skb at this point?

This should call:

  dst->ops->update_pmtu(dst, NULL, skb, mtu, false);

instead given that skb_dst() is attached later.

The scrub ordering is wrong, but the dst is not attached to the
skbuff.

> Flowtable hooks can only be registered at netdev ingress:
> 
> net/netfilter/nf_tables_api.c:nft_flowtable_parse_hook() {
>     ...
> 	if (hooknum != NF_NETDEV_INGRESS)
> 		return -EOPNOTSUPP;
>     ...
> }
> 
> This means nf_flow_offload_ipv6_hook() runs before ip6_route_input(), so
> no routing dst is attached yet.
>
> The outer tunnel dst only comes in as the
> dst argument:
> 
> nf_flow_offload_ipv6_hook()
>   nf_flow_queue_xmit6()
>     nf_flow_tunnel_push(state->net, skb, other_tuple,
>                         tuplehash->tuple.dst_cache, &ip_addr)
>       nf_flow_tunnel_ip6_push()
> 
> The skb only gets that dst after the push returns, and only for
> FLOW_OFFLOAD_XMIT_NEIGH:
> 
> net/netfilter/nf_flow_table_ip.c:nf_flow_queue_xmit6() {
>     ...
> 		xmit.dest = neigh->ha;
> 		skb_dst_drop(skb);
> 		skb_dst_set_noref(skb, &rt->dst);
> 		break;
> 	case FLOW_OFFLOAD_XMIT_DIRECT:
>     ...
> }
> 
> skb_dst_update_pmtu_no_confirm() does nothing when skb_dst(skb) is NULL:
> 
> include/net/dst.h:skb_dst_update_pmtu_no_confirm() {
> 	struct dst_entry *dst = skb_dst(skb);
> 
> 	if (dst && dst->ops->update_pmtu)
> 		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
> }
> 
> So the mtu computed from dst_mtu(dst) looks like it is thrown away both
> before and after this change.
> 
> Ingress sometimes attaches a metadata dst (collect_md or tunnel_key).
> That dst uses dst_blackhole_ops, and dst_blackhole_update_pmtu() is
> empty. It is also not the flow's inner route.
> 
> There also doesn't seem to be an inner route left to update, because
> nft_dev_forward_path() replaces it with the tunnel dst:
> 
> net/netfilter/nf_flow_table_path.c:nft_dev_forward_path() {
>     ...
> 	dst_release(route->tuple[dir].dst);
> 	route->tuple[dir].dst = info.tun_dst;
>     ...
> }
> 
> The ip6_tnl_xmit() comparison depends on ip6_forward() having already put
> the inner route on the skb. The flowtable fast path skips that step.
> 
> If that reading is right, the patch reorders a call that never has any
> effect. The PMTU update described as "silently lost" would still be lost
> on every fast-path packet.
> 
> Would one of these work better: dropping the call, updating an
> explicitly stored inner dst, or relying on (and documenting) the
> nf_flow_exceeds_mtu() check in nf_flow_offload_ipv6_forward()? That check
> already sends oversized packets to the slow path, and ip6_tnl_xmit()
> handles PMTU there.
> 
> At the end of the series the code still does the skb_dst(skb) based
> PMTU update, followed by skb_scrub_packet(skb, false), so later patches
> don't seem to fix this either.
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
