Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785448;
	b=Quhu2rTIHZineD8HMEalR1Nb4VgRU2pfoFug13Gz7sxqyFgkwZ6M8iFBrNsEvHxWiOWv
	 dVYf/wFvQYgyaqDwNbTQxfV8+Fo31rI9eYHHZ1PIwJQ+5gfQIUqOTl2Df/zEaEUiV2xX8
	 gq4lzSMv1zraV8tPVuEnEIz5TwPhgXpeiJgknR3LuOHLw4Km+7VksAuQLvdnOPuToTAui
	 hWVhiyu8YoGAmqf2uXCf9zyOp7viGG2gKwQQtFkK+Zk14cL7pL2QtiIFcDDiZsmvzfQGn
	 cd8Pim4injNAhNaTdiVWlNhYENH9VR/UjYm8yHmGKQyRXnEthjwFpQ2FqljhFiY4jFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785448;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=ShhRgujdkNsVq2xgPM4poz73OE/1tQPvjHxEt8yBHNc=;
	b=E96+RiVJ3ri5uVxAWG1PX8FA3ZFjUaIA5qrhdsle8ucIP6yRQGm2tSKoLDX4vbUgKvQl
	 GRh006czLLkgyhfxM1NWRjauXc4BbEFdxIz4RTpGsgeBlfIur4xM9uGmwpi9x6l6Hb5OB
	 hulhsAiW4WCLTvDCr/VoXPl81RqHRop3hIWnAEXuwiqiDSam5GOh3edPFi3svSNzKkJcF
	 b3z99TpZsmT1dRbgxsXJNYDn70UbiveTx3rGLu67spx2XVWAmMUwxtUTWs649TnwlEWRs
	 TCWGLNblgtBV8ZBO6MxZbIzxpFU1TjkayUFXoIxhmLGGHPj96Ry2i2carTAXGQcZwdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=t9Prntq5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1907B606A32F;
	Sun, 15 Nov 2026 23:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1907B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=t9Prntq5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794785445;
	bh=ShhRgujdkNsVq2xgPM4poz73OE/1tQPvjHxEt8yBHNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t9Prntq5PX9k7YAimpwwZ6JgQXh5te71THubY224+t7LCxoUfDeWdpinNh9g7RNQC
	 Bu4kK+KzzX/cSJJxCcB80MoYzl38b35if+/5cqpY6rRQhcDn949mK7aMjOVaXYyWa2
	 iao69Yc6PSvM4cQDek9+FBGHtvpzwROREjRXM+lJfcKyJgRkNWeA8YBKcH0EQ86OU4
	 o6dbdYwxpOjld8hpIrf/s8XKF9XeWx7jhO1hywo3KFHWuiiuwY/u/JkV1X/hJDWEcI
	 hNOyN1g453QbC1tD3JUx0IcCHkegifmOBJaEnd5Yh1OxQXgnuIxJ2sN3Qrshhmxf5N
	 zZPKojsXMVUtQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B6D58602A8;
	Mon, 16 Nov 2026 00:30:45 +0100 (CET)
Date: Mon, 16 Nov 2026 00:30:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 11/15] netfilter: flowtable: do not scrub as
 crossing netns
Message-ID: <avpAomzTPmMItRAg@chamomile>
References: <20261113031251.2437074-12-pablo@netfilter.org>
 <179462662909.2199510.3682917191750887644@kernel.org>
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
In-Reply-To: <179462662909.2199510.3682917191750887644@kernel.org>

On Sat, Nov 14, 2026 at 03:23:49AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The Fixes: tag and the commit message cover only one of the two
>   changed call sites.
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch.
> 
> --
> 
> netfilter: flowtable: do not scrub as crossing netns
> 
> This commit changes the flowtable tunnel push helpers from
> skb_scrub_packet(skb, true) to skb_scrub_packet(skb, false). The skb mark
> is now kept on encapsulated packets. The commit message says the IPIP
> tunneling fast path does not cross a netns.
> 
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > index 644e70fd6773b..001abfae5a1ff 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -630,7 +630,7 @@ static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
> >  	if (err)
> >  		return err;
> >  
> > -	skb_scrub_packet(skb, true);
> > +	skb_scrub_packet(skb, false);
> 
> [Severity: Medium]
> This is a pre-existing issue and was not introduced by this patch. Is
> the hard-coded xnet = false in nf_flow_tunnel_ip_push() and
> nf_flow_tunnel_ip6_push() correct only because the fast path routes in
> dev_net(dev) and not in the tunnel's link netns?
> 
> The slow path routes in tunnel->net or t->net, and it decides xnet per
> device:
> 
> net/ipv4/ip_tunnel.c:ip_tunnel_xmit() {
>     ...
> 	iptunnel_xmit(NULL, rt, skb, fl4.saddr, fl4.daddr, proto, tos, ttl,
> 		      df, !net_eq(tunnel->net, dev_net(dev)), 0);
>     ...
> }
> 
> net/ipv6/ip6_tunnel.c:ip6_tnl_xmit() {
>     ...
> 	skb_scrub_packet(skb, !net_eq(t->net, dev_net(dev)));
>     ...
> }
> 
> The forward path helpers that admit the flow look up the outer route in
> the device netns instead:
> 
> net/ipv4/ipip.c:ipip_fill_forward_path() {
>     ...
> 	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, tiph->saddr,
> 			     inet_dsfield_to_dscp(tiph->tos),
> 			     tunnel->parms.link, RT_SCOPE_UNIVERSE);
>     ...
> }
> 
> net/ipv6/ip6_tunnel.c:ip6_tnl_fill_forward_path() {
>     ...
> 	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
>     ...
> }
> 
> Neither helper rejects a tunnel whose link netns differs from
> dev_net(dev). nft_dev_path_info() does not reject it either, because it
> only checks nft_flowtable_find_dev(info->dev, ft).

Not sure this is correct, if you move a netdevice in a flowtable to
another netns, it gets removed from the flowtable.

> Take an ipip or ip6tnl device whose link netns is A but which lives in
> netns B. Could the offloaded packets of a flow be routed with B's routing
> table, while the slow-path packets of the same flow leave through A's
> underlay?
> 
> With this patch the two paths would also handle skb->mark differently.
> The slow path clears it and the fast path keeps it.
> 
> Could ipip_fill_forward_path() and ip6_tnl_fill_forward_path() return
> -EOPNOTSUPP when the tunnel's link netns differs from dev_net(dev)? That
> would also keep xnet = false correct. Another option is to route in
> tunnel->net and carry the real xnet value through flow_offload_tunnel.
> 
> > @@ -702,7 +702,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
> >  	mtu = dst_mtu(dst) - sizeof(*ip6h);
> >  	mtu = max(mtu, IPV6_MIN_MTU);
> >  	skb_dst_update_pmtu_no_confirm(skb, mtu);
> > -	skb_scrub_packet(skb, true);
> > +	skb_scrub_packet(skb, false);
> 
> [Severity: Low]
> This isn't a bug, but the skb_scrub_packet() call in
> nf_flow_tunnel_ip6_push() came from 93cf357fa797 ("netfilter: flowtable:
> Add IP6IP6 tx sw acceleration"). It did not come from the commit named
> in the tag:
> 
>   Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")
> 
> The commit message also only talks about "IPIP tunneling support".
> However, this hunk changes the IPv6-outer encapsulation path too, so
> skb->mark is now kept on those packets as well.
> 
> Earlier in the same series, "netfilter: flowtable: fix pmtu discovery in
> nf_flow_tunnel_ip6ip6_push()" uses Fixes: 93cf357fa797 for this same
> function.
> 
> Should a Fixes: tag for 93cf357fa797 be added, and should the commit
> message mention the IPv6-outer path?
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
