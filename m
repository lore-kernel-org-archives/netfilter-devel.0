Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E69733BBBD;
	Mon, 19 Oct 2026 01:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372890; cv=none; b=ewHXK3kGAjL9BcXRoypkE9sOB2HPdIOspgQ2rcj29rlUEi+1XHQtXT07p6zGtI+rfQRHOFyTHFG0kZJvnGUukxPm0+vjwoKALKcTlRDhxbmF8GJsP4VRX9fv/R63MwLme/ypvIwSI6qKyZVhZU4YGC+5rliXkyKHPwWVeflq48A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372890; c=relaxed/simple;
	bh=5VP3KjHjX35tgk8ZqGg9DJe2uryoUTB/XPZM5LkyR7E=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mGuzq778xSFkFqNHidFhf4o1iQMjXVn1EiXHPWMLkqOAuFKSc0iijkJTY1LuaM4ykFaZ+zL+BlQuHS99oq3vfSIFM8JWrNpC/w+bmz81Lwwu/mJICcFhRGFAvIKaubwK0wOtbOCyjcd4k2VHGZjAwnsAZWV9MsRJ2lo6kEE/TEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jH3UJMbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jH3UJMbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93041F000C4;
	Mon, 19 Oct 2026 01:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792372889;
	bh=dqaAmcNck6BRcT4GbIsdemYT5tbOyjyylL2Bd+Ftnb4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jH3UJMbAvNlLqN/WadYwiXUu8Ro5js/sTCvQjaN31/08R1k6F+sUuVUE5UNXXiyg2
	 8q7no/ThMG1O8wODOJq+7uLvuz3mC1Sg6Y3NKXaljD74LjpjRk+9BRsfytYVyuZvbG
	 5f6e1qFf/hgyfEXX3efY91ErENQZy6IVDmVnjjFvyG+UNBn0Lxeum9ByiQLRWa8946
	 xFb9QbyPJKEBrxsygDFQUXRdNo4TahKybb/MGXeDo2q7eX44yl2n2m0aQOFEo+QA53
	 oezQBMFTofhUAZKuVlC5va9E5fbzUjzJJGiV+dFDT2QlzeCn8pow8PZ23gE2DEJvJI
	 LertEX20LnPPQ==
Subject: Re: [PATCH net-next 12/15] netfilter: flowtable: set inner protocol
 when popping tunnel header
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 19 Oct 2026 01:21:28 +0000
Message-ID: <179237288830.3135.1355021906814917621@kernel.org>
In-Reply-To: <20261018005638.1776148-13-pablo@netfilter.org>
References: <20261018005638.1776148-13-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says the patch makes nf_flow_ip_tunnel_pop()
  pop the outer header and set skb->protocol "instead of bailing out…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but
  nf_flow_ip_tunnel_pop() strips the outer tunnel header with plain…

--

netfilter: flowtable: set inner protocol when popping tunnel header

This commit makes nf_flow_ip_tunnel_pop() set skb->protocol from
ctx->tun.inner_proto after it pulls the outer tunnel header. The commit
message calls it a preliminary patch for IPv4 over IPv6 and SIT tunnel
flowtable offload.

> Pop the outer tunnel header and set skb->protocol to the inner protocol
> derived from ctx->tun.inner_proto in nf_flow_ip_tunnel_pop(), instead of
> bailing out unless the tunnel carries IP-in-IP or IPv6-in-IPv6.

[Severity: Low]
Is this description accurate? The early return at the top of
nf_flow_ip_tunnel_pop() is unchanged by this patch:

	if (ctx->tun.inner_proto != IPPROTO_IPIP &&
	    ctx->tun.inner_proto != IPPROTO_IPV6)
		return;

The only change is the new skb->protocol assignment.

With the current parsers, that assignment also looks like a no-op:

- nf_flow_ip4_tunnel_proto() sets inner_proto to IPPROTO_IPIP only when
  the outer header is IPv4.
- nf_flow_ip6_tunnel_proto() sets IPPROTO_IPV6 only when the outer header
  is IPv6.
- nf_flow_encap_pop() calls the pop only when skb->protocol is already
  the outer family:

	if (skb->protocol == htons(ETH_P_IP) ||
	    skb->protocol == htons(ETH_P_IPV6))
		nf_flow_ip_tunnel_pop(ctx, skb);

So the value written always matches what skb->protocol already holds.
The rest of the series, up to "netfilter: flowtable: unify tunnel push for
IPv4 and IPv6", does not change the parsers or this guard.

Could the commit message say that the guard is kept? It could also say
that the assignment only has an effect once cross-family parsing
(IPv4-over-IPv6/SIT) is added.

Removing the guard, as the message describes, would not be correct.
Non-tunnel flows have inner_proto == 0, so they would get skb->protocol
set to ETH_P_IPV6.

> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index c8c29a9a16844..29d1a9f4a362b 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -372,6 +372,11 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
>  
>  	skb_pull(skb, ctx->tun.hdr_size);
>  	skb_reset_network_header(skb);
> +
> +	if (ctx->tun.inner_proto == IPPROTO_IPIP)
> +		skb->protocol = htons(ETH_P_IP);
> +	else
> +		skb->protocol = htons(ETH_P_IPV6);

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch. Should
the skb_pull() above be skb_pull_rcsum()?

The VLAN and PPPoE cases in nf_flow_encap_pop() in the same file use
skb_pull_rcsum(). __iptunnel_pull_header() also adjusts the checksum
before it sets the inner protocol:

net/ipv4/ip_tunnel_core.c:__iptunnel_pull_header() {
    ...
	skb_pull_rcsum(skb, hdr_len);
    ...
		skb->protocol = inner_proto;
    ...
}

This patch adds the skb->protocol step from that pattern, but not the
checksum adjustment.

Take a CHECKSUM_COMPLETE skb with an outer IPv6 header (ip6ip6 today,
IPv4-over-IPv6 later). After the pull, skb->csum still includes the 40
bytes of the removed header. An outer IPv4 header does not cause this,
because its valid header checksum makes the header's ones'-complement
sum effectively zero.

Suppose such a forwarded skb is looped back into a receive path. One
example is veth into another netns, where __dev_forward_skb2() keeps
CHECKSUM_COMPLETE. Would the L4 checksum check then fail on the stale
skb->csum? The stack would recompute the checksum in software and call
netdev_rx_csum_fault(), which prints a rate-limited warning.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
