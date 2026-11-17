Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874971;
	b=rBJHBNL2MjOPZWrpGSg5Y37AdIBQU6ng2yve1VtJvsSKhJcXn6TwJgsWCb9SdHWXVAtW
	 xO4qY0v6FkcbG3m4ZWFYFwfbpyRVHu7myjDrjMclQyGmFUnlVCsLtZsDGEoL+tEW+LOdS
	 y7pj46p27tXBPDkDIlxkYbbnLo2dCAon2qne5umJmfVm/dZBfzvhaRheW18MrgjOIhT6G
	 M+B0NCZh6GTIh27S2IBatydvkYOPH/qlGvWZfw/aAKcorFHQoir91zhKWq18P9xGyr+t0
	 aAs1iv7GI6HImAwe6kD3EQr42QiQI+qK7KOo/UfwCrz/LoFv0bSnGsxqhios8mea5Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874971;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=FFAS5+hpUFu+HDChumdbi3A/27UEosuxEmjc8s6XUxg=;
	b=RMyYTkNlITLFprnBBu5Oe+9SpI1FmIHiFVqUU7xzkmBlQJo1gmNdoycYKJkAn4OFZ6VG
	 aVK3w7eJ2jD881cJH4nqLUJ/fxjmb6qYqbUwiwy1ImAjFFY87Ea5+XG1qFA0lga/i3jGh
	 zACsk3tE3Wlvajbzw68eiJrgCZANpr4UF7IsLgomTUdoRbv9i9innOPFJ+CtbxQElWd3K
	 BcwkfWBPpi1vL/c/ZUYhdArnjB32XyvKRpbGdo306sfx0eNc3qdMZx94CthuzsvfjQJno
	 g07EXQnj21Cs2kqdkClOTG5/Il5sumQqVqjSB1vACaOD41J+Bh05Hxkw65bN7LnXpuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="INp1/cuB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DC6606A334;
	Tue, 17 Nov 2026 00:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INp1/cuB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5517E1F000CA;
	Tue, 17 Nov 2026 00:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874970;
	bh=FFAS5+hpUFu+HDChumdbi3A/27UEosuxEmjc8s6XUxg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=INp1/cuBh4rlvJkQgV0ctiXe0vzaZYHkrAF0cEhq91WhUhRPETCYKJXF8SgRB7462
	 J3Q89lXBpuI6eDOcfVg2IeO2Lb23Zb/ghkwtAbylAMRpDlQsOX0Ecr9HruDAfHAmJz
	 RB+dZFssmW1nEvsFX7xwTW9kqxd6UNEtBkTVfnFnMJric7iALr3CCiepgxlFP5+3CF
	 TT9nXAyKpxJ1yGLct42H+LWXIOd7g30HYInenEmmh0QjltgDF+Anv+/OzOKt82GnSr
	 cFpX1qV6R2glApEv823T6Au6ukYZtT6+QGc5zp6kB6+/5VX5LtVTWnFrSr+Ye6ai8K
	 Nmhxld/rAI14A==
Subject: Re: [PATCH net-next 06/13] netfilter: nft_flow_offload: do not
 offload multicast
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:49 +0000
Message-ID: <179487496989.3136.17890972366589039395@kernel.org>
In-Reply-To: <20261116001612.2806263-7-pablo@netfilter.org>
References: <20261116001612.2806263-7-pablo@netfilter.org>
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

- [Low] Commit "netfilter: nft_flow_offload: do not offload multicast"
  fixes a long-standing bug that users can see, but it has no Fixes: tag.

--

netfilter: nft_flow_offload: do not offload multicast

This commit makes nft_flow_offload_skip() skip packets with a multicast
destination address for both IPv4 and IPv6. Before this, IPv4 multicast
stayed out of the flowtable only because the reverse route lookup failed.
IPv6 multicast forwarded by ip6mr could be offloaded and then keep
sending to a stale output.

> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index d3c5651dd6997..530e20c7fd457 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c

[ ... ]

> @@ -33,6 +34,10 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
>  
>  		if (unlikely(opt->optlen))
>  			return true;
> +
> +		return ipv4_is_multicast(ip_hdr(skb)->daddr);
> +	} else if (family == NFPROTO_IPV6) {
> +		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);

[Severity: Low]
This isn't a bug, but should this patch carry a Fixes: tag?

Before this change, nft_flow_offload_skip() returned false for IPv6.
Nothing else in nft_flow_offload_eval() rejected a multicast destination,
so IPv6 multicast forwarded by ip6mr reached the flow offload expression
through the FORWARD hook:

net/ipv6/ip6mr.c:ip6mr_forward2() {
    ...
	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD,
		       net, NULL, skb, indev, skb->dev,
		       ip6mr_forward2_finish);
    ...
}

A flowtable entry could then be created for it. That entry keeps sending
to the output it resolved when it was added, even after the last listener
leaves, and the mroute counters stop.

The IPv6 path seems to have been offloadable since the flow offload
expression was added, so the likely target would be:

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")

Most of the other fixes in the same pull request carry Fixes: tags, for
example "netfilter: flowtable: purge entries immediately when destroying
the flowtable" and "netfilter: flowtable: do not clear the offload bit
twice". Without a tag here, stable maintainers have no way to tell which
trees need this fix.

>  	}
>  
>  	return false;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
