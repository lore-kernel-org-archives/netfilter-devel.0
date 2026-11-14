Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626621;
	b=eqvVPH4U96PzGmLEVAPNRuC539WYL66FStNET5hG9Bf1SfaO0l4DJCx3bPcBBlORJbkD
	 zoIO6noGTmjgnAbNrQ96G1SjqN3jaiS3VaNYXFZK1W8ycHXiwiahTw46A7KL+E93MYIH3
	 RN97xR2/d9sJ5zCjV++d93XTO9p9eQ56lAocO0xxyuG6RQ0EJN41kd9xk6KXlK0C8C8o3
	 LMXOhQY5zBL9qPQjKdeRag0CzCPO8/+7ZGAIjadNHVJ7tdKIsTo2qAu4aXRuyxvIitDf8
	 xjm7ZucjjDMr+Jqk89ELQoArabvKuYTBGJIF33WYKJuLDG3FkaY8d35dXVYiQ/aoMPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626621;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=R5z+Zu2KwpyHx5FJM0sdOZwAch8rq5B9StB8kRHeq+k=;
	b=h7S0jy0kj6cMYq0FxY0M9zdnyp/Rsr1P6ciJxvvBdL7rNI+d4DXMFmV2YyWNAvql4LzM
	 Ot+Did2ypnBUp4onl7a8LBqRn1svBQ7l/vU+RDjBdbCjPaZcxWY1MUoKr0f0xz7I6B9cM
	 OC/pU8/yreNbSnMHv+ZJ84H2GaoU9SiYDqJMYf9WeCKvLDRvdpTyqMdS5cqaUbxICzoEO
	 ZL1/K9sQp1sjrDLr5lp/3AI5Aek6cwzeZ900b71GqIT/EIyeuJ3wqaKkBwRK6nr86AJXw
	 Oq85zd5qZ3NoYxntHHzDFgg8UoQDfF3pv5pbMTaPn3+tVcb1aIPyBnyNu21DOwsJP9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2HTWLUs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1A8606A882;
	Sat, 14 Nov 2026 03:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2HTWLUs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537081F000C4;
	Sat, 14 Nov 2026 03:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626620;
	bh=R5z+Zu2KwpyHx5FJM0sdOZwAch8rq5B9StB8kRHeq+k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e2HTWLUszIRuA5PO/oRb63LJVXvxQWqZ9VY+5Ol0yK8IqglEEO86zhh4n/9RJdvfk
	 wb4fmQbmarKCc638MHeNfh60ygGTAyJJ1xthQcnyhnF1Iz2NHO4hjCfvxKy1l46GvD
	 J+LdGeFeV4WjvvB21CIyEyTU9Pp/uHWfOBFe00SF58EHmMB/P3h7wqrTbvZckLzYMg
	 XPGONrjShUkVG30eexbckDsqeoNwvrTu5w7CiFbYpg/UmDPqTpAfOb/rSY2Aa3necw
	 wbkysEHyB3aNhyEAlH/XeA+d75NwRz6FhMVqJEuOmqcyApSVGSFmIGwIHBHIIo2goz
	 V0AqpWf1UhzMg==
Subject: Re: [PATCH net-next 02/15] netfilter: flowtable: fix pmtu discovery
 in nf_flow_tunnel_ip6ip6_push()
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:39 +0000
Message-ID: <179462661985.2199510.8150694515960866760@kernel.org>
In-Reply-To: <20261113031251.2437074-3-pablo@netfilter.org>
References: <20261113031251.2437074-3-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix does nothing.
- [Low] The commit subject and body name nf_flow_tunnel_ip6ip6_push(),
  which does not exist in the tree being patched.

--

netfilter: flowtable: fix pmtu discovery in nf_flow_tunnel_ip6ip6_push()

This commit moves skb_dst_update_pmtu_no_confirm() ahead of
skb_scrub_packet() in nf_flow_tunnel_ip6_push(). The aim is to run the
PMTU update before skb_scrub_packet() drops the skb dst. The inner route
would then get the tunnel MTU, as it does in ip6_tnl_xmit().

> netfilter: flowtable: fix pmtu discovery in nf_flow_tunnel_ip6ip6_push()
>
> nf_flow_tunnel_ip6ip6_push() invokes skb_scrub_packet() before updating
> the PMTU.

[Severity: Low]
This isn't a bug, but there is no nf_flow_tunnel_ip6ip6_push() in this
tree. Commit 93cf357fa797 added it under that name, and it was later
renamed to nf_flow_tunnel_ip6_push(). It now also takes a dst argument and
handles an IPPROTO_IPIP inner protocol.

Could the subject and body use the current name? It could also say that
the change touches 4in6 encapsulation (e.g. DS-Lite) as well as IP6IP6.

> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 19cafae748abe..644e70fd6773b 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -699,10 +699,10 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
>  	if (err)
>  		return err;
>  
> -	skb_scrub_packet(skb, true);
>  	mtu = dst_mtu(dst) - sizeof(*ip6h);
>  	mtu = max(mtu, IPV6_MIN_MTU);
>  	skb_dst_update_pmtu_no_confirm(skb, mtu);
> +	skb_scrub_packet(skb, true);

[Severity: High]
On the flowtable fast path, is there a dst on the skb at this point?

Flowtable hooks can only be registered at netdev ingress:

net/netfilter/nf_tables_api.c:nft_flowtable_parse_hook() {
    ...
	if (hooknum != NF_NETDEV_INGRESS)
		return -EOPNOTSUPP;
    ...
}

This means nf_flow_offload_ipv6_hook() runs before ip6_route_input(), so
no routing dst is attached yet. The outer tunnel dst only comes in as the
dst argument:

nf_flow_offload_ipv6_hook()
  nf_flow_queue_xmit6()
    nf_flow_tunnel_push(state->net, skb, other_tuple,
                        tuplehash->tuple.dst_cache, &ip_addr)
      nf_flow_tunnel_ip6_push()

The skb only gets that dst after the push returns, and only for
FLOW_OFFLOAD_XMIT_NEIGH:

net/netfilter/nf_flow_table_ip.c:nf_flow_queue_xmit6() {
    ...
		xmit.dest = neigh->ha;
		skb_dst_drop(skb);
		skb_dst_set_noref(skb, &rt->dst);
		break;
	case FLOW_OFFLOAD_XMIT_DIRECT:
    ...
}

skb_dst_update_pmtu_no_confirm() does nothing when skb_dst(skb) is NULL:

include/net/dst.h:skb_dst_update_pmtu_no_confirm() {
	struct dst_entry *dst = skb_dst(skb);

	if (dst && dst->ops->update_pmtu)
		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
}

So the mtu computed from dst_mtu(dst) looks like it is thrown away both
before and after this change.

Ingress sometimes attaches a metadata dst (collect_md or tunnel_key).
That dst uses dst_blackhole_ops, and dst_blackhole_update_pmtu() is
empty. It is also not the flow's inner route.

There also doesn't seem to be an inner route left to update, because
nft_dev_forward_path() replaces it with the tunnel dst:

net/netfilter/nf_flow_table_path.c:nft_dev_forward_path() {
    ...
	dst_release(route->tuple[dir].dst);
	route->tuple[dir].dst = info.tun_dst;
    ...
}

The ip6_tnl_xmit() comparison depends on ip6_forward() having already put
the inner route on the skb. The flowtable fast path skips that step.

If that reading is right, the patch reorders a call that never has any
effect. The PMTU update described as "silently lost" would still be lost
on every fast-path packet.

Would one of these work better: dropping the call, updating an
explicitly stored inner dst, or relying on (and documenting) the
nf_flow_exceeds_mtu() check in nf_flow_offload_ipv6_forward()? That check
already sends oversized packets to the slow path, and ip6_tnl_xmit()
handles PMTU there.

At the end of the series the code still does the skb_dst(skb) based
PMTU update, followed by skb_scrub_packet(skb, false), so later patches
don't seem to fix this either.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
