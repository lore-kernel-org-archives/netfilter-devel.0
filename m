Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626631;
	b=N1aOOCV2rg4s64E0UJ58sTERclgKOn4XL3Rnzihle2CMGI9ROIxntc2VgPYkSXaalX4J
	 U78YITyLcTALuO9G5+hoV7OTHQ1YLwa/orucF5xJxd78BjBHDiMSHKawWEQdRXoYkvr4V
	 vCYD+O9SGB6cf1AgUHH+gurd+m+H79yRISBqrNLCPO96KnT8KDSwfoVAC4JCehMgoxMbC
	 X93LCSxiDMnvxhRrApSAncrcbuD3YFv/gld3n7DzVzIoyOwtI9cx3GWgDl57/ZBAU/A0b
	 kPH9cvU0zR5hpAv+eTwLcCgptgGrEj5UyA1GDtjMzeAgoX3EWx51WgtZ4lhFtEKFctg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626631;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vOrw1y8m+9NBltBknIKtJtVKStAg1SQPVgtsudklyYI=;
	b=U764lOoac6ork7oEvi6Hs5cbb21kL7zRmFXRZA7Pvo5SEO+mA0N6gJx2cxp4nvmuTaCE
	 YLQ+8wBe1HlY2JPgkNsOorx0Ql3Jh60ncQ8t18hzSlwm+eLT1G9deEVXrDgfiZBxS13Bt
	 wDnNRRWgkYCDq4kZk3H3+xbwnXpyx7jd7P27gmwv/TCTQTiyhr/GhxT224Jj5KW/lo0Bd
	 HO2FOPUsb2nVTvTpIGhQYWtMbKQVTNho8ylRnCk9mWtNXeF/ikNiVkVbdLxClxstSufef
	 Rdj2JSB7dfylZdmBoRUWmMLGUsGhEdX6oCdUOrEL9j/JyyVB/0sKkKH+fsSIVBIi/kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GwWGXRx/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D79860A262F;
	Sat, 14 Nov 2026 03:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GwWGXRx/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F8C1F000C5;
	Sat, 14 Nov 2026 03:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626631;
	bh=vOrw1y8m+9NBltBknIKtJtVKStAg1SQPVgtsudklyYI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GwWGXRx/O/jsDouSZjxag2nP3y6G4U5KyKsm200a31+nqxxetL2IEYX75gMyLv8to
	 qM1UPIdgaRDfJZcMlS4PdCFwO0d3z+lELvENiHyFiAPnPetC2p+uPhTrtvEyr6x1FZ
	 Nax+Z+KYNUThwNTNKfMK2ZSNhsth5uxNSDdGcrFOTMPNEYA4hUMoCpU6LIPWnzsUV4
	 LEkJA8se37RhIKrm8UT0jSZTpgviyVNV8qsKbJKzDZoLNPR08PHR81V55tGaKshKcA
	 /6JD+g93nNT3gLHCUSQelRdeeT2pJj6fviBOammk7yKif8+Io2nHHGzHGX2uvZqH6m
	 3QglMcXx9uQHg==
Subject: Re: [PATCH net-next 12/15] netfilter: flowtable: tunnel device
 poisons h_source of fast-path frames
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:50 +0000
Message-ID: <179462663016.2199510.13278925196473487911@kernel.org>
In-Reply-To: <20261113031251.2437074-13-pablo@netfilter.org>
References: <20261113031251.2437074-13-pablo@netfilter.org>
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

- [Low] The commit message's only reproduction cannot happen on the tree
  this patch targets.

--

netfilter: flowtable: tunnel device poisons h_source of fast-path frames

This commit stops nft_dev_path_info() from copying the dev_addr of a
DEV_PATH_TUN device into info->h_source. On a tunnel device, dev_addr is
the local tunnel IP address and not an Ethernet address. Before this
change, those bytes became the source MAC of fast-path frames.

> Seen on a DS-Lite setup, LAN -> ip6tnl (IPv4 inside IPv6) -> PPPoE ->
> 802.1Q VLAN -> Ethernet, with conntrack flows offloaded through an
> nftables flowtable ('flow add @ft'). The first packets of a flow, still
> on the slow path, and the fast-path packets of the same flow differ only
> in the Ethernet source address:
>
>   slow path:  d8:58:d7:00:2e:bd > 80:ac:ac:39:ef:c2, 802.1Q vlan 35,
>               PPPoE [ses 0x454] IP6 2a01:110f:4328:c400::1 >
>               2a01:1000:0:1::2216 next-header IPIP, 192.0.0.2.40010 >
>               1.1.1.1.53
>   fast path:  2a:01:11:0f:43:28 > 80:ac:ac:39:ef:c2, same frame otherwise

[Severity: Low]
Can this DS-Lite setup reach the flowtable fast path on this tree?

ip6_tnl_fill_forward_path() starts by rejecting any inner flow that is not
IPv6:

net/ipv6/ip6_tunnel.c:ip6_tnl_fill_forward_path() {
    ...
	if (ctx->ether_type != cpu_to_be16(ETH_P_IPV6))
		return -EOPNOTSUPP;
    ...
	path->tun.inner_proto = IPPROTO_IPV6;
    ...
}

For a forwarded IPv4 flow, ctx->ether_type comes from pkt->ethertype.
nft_set_pktinfo() sets that to skb->protocol, which is ETH_P_IP here:

include/net/netfilter/nf_tables.h:nft_set_pktinfo() {
    ...
	pkt->ethertype = pkt->skb->protocol;
    ...
}

So dev_fill_forward_path() fails and nft_flow_route() returns -ENOENT. No
flow entry is created, and nft_dev_path_info() never sees a DEV_PATH_TUN
entry for this topology.

inner_proto is also hard-coded to IPPROTO_IPV6. Given that, could the
offload path on this tree produce the "next-header IPIP" fast-path frame
quoted above?

The check came from commit 5592223f3d4e45 ("net: netfilter: add
ether_type to net_device_path_ctx and use it"). That commit says IPv4
over IPv6 is "currently not support[ed]". Was the capture taken on an
older kernel, or on one with local changes?

> The PPPoE endpoint binds the session to the
> subscriber MAC and silently drops the frames, the effect is that every
> TCP/UDP flow dies the moment it is offloaded, while ICMP, which is never
> offloaded, keeps working.

The code change itself looks correct. On this tree, the h_source
poisoning still seems reachable in two ways:

  - ipip_fill_forward_path(), which accepts ETH_P_IP inner flows and
    emits DEV_PATH_TUN with dev_addr set to the local IPv4 address

  - ip6tnl carrying an IPv6 inner flow

Either one needs a PPPoE entry later on the path, or a hw-offload
flowtable on an Ethernet device. Then xmit_type is
FLOW_OFFLOAD_XMIT_DIRECT, and info.h_source is copied into
route->tuple[dir].out.h_source.

Could the commit message describe one of those reproducible cases
instead? Alternatively, it could note that the DS-Lite observation came
from a kernel without commit 5592223f3d4e45.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
