Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4E536D4E1;
	Mon, 12 Oct 2026 06:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791785620; cv=none; b=bwjumjz19hSPb3u2W9hzNqQtkIADgio5jBTh0tAmpK1n//hKYTPJFhlWBiBDONddi0Bd0UM6DGVOrnapuHlzYc62s8Ez5+hnD6VSlvvHa7A+KQyszacxBuEFfUH20F8wYpWLGmSNox3GFNkyLtiVsjM+oNiUKSD8AIF9bluer2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791785620; c=relaxed/simple;
	bh=iZz2bPV5WngNL4geLGJqviGwHKnnjxqhaqh2GRbUE8g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nXlxCrELxjp9TtMMSdqDQwlXo+1bIUuGSa79wdU+2bwKS+8KjIUWdmK0Gkvipusf3uL3qCqkmPGvwolmlaea5c1wFPGxkkim2vkNUz0wkXvWcZ+FPFsECtHPWCXR1UXPrzKGfhRzByf7TxyiGsnZji5FJ4tc004Qe4hA7O0zd+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKnEcbYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKnEcbYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EED1F0089B;
	Mon, 12 Oct 2026 06:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791785619;
	bh=8A2NzWuDCmn36ZsBruaeSIAejcK/P07F4bleLBGcRAw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DKnEcbYCans0dbdiRQycIAOcS2Cmk+bCGqJ9+p5VwUIhl2xN1PU0Wm2rWh3v4vv6e
	 mChJeglL2GamZ+1n+e8h6peMFq/uxjpatWFB5vHxgzhUtW92A9j1h9o6pKmeO3OOHf
	 ETyR6aAPQvyFJZedRIB1gNl9YJerdHUcyCBI3zKFOXsYGoSPlzY3CiiCbhrnq773Uc
	 HT3VEc0RqEyRvHAmW8FfIWhOJg/wjfpnd0lyJkUAITJ6eMlI+eIDs9NYjoFmFZmkz9
	 qIvP4MV7Y/TjxFuk7OdkoKFG15StlJ8WMc1xKPVQdUHYjmCIS07t9hh6RcIARN0A02
	 K7yIYCkku1eHw==
Subject: Re: [PATCH v3] netfilter: nf_nat: Fix stale outer UDP checksum on
 VXLAN encapsulated packets
From: netdev-bot+sashiko@kernel.org
To: lvjunyu@cmss.chinamobile.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Mon, 12 Oct 2026 06:13:38 +0000
Message-ID: <179178561828.434549.9529684167778428667@kernel.org>
In-Reply-To: <20261008054228.752274-1-lvjunyu@cmss.chinamobile.com>
References: <20261008054228.752274-1-lvjunyu@cmss.chinamobile.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix covers only one caller, __udp_manip_pkt() in
  net/netfilter/nf_nat_proto.c.

--

netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets

This commit changes __udp_manip_pkt() to detect the LCO state of a
CHECKSUM_PARTIAL non-GSO skb. That state is when csum_start + csum_offset
does not point at the outer udphdr check field. In that state the patch
switches ip_summed to CHECKSUM_NONE for a moment, so the address and port
deltas are applied to the complete checksum through csum_replace*().

> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index 64b9bac228eae..6779e9f2812d9 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -54,9 +54,39 @@ __udp_manip_pkt(struct sk_buff *skb,
>  		portptr = &hdr->dest;
>  	}
>  	if (do_csum) {

[ ... ]

> +		bool lco = skb->ip_summed == CHECKSUM_PARTIAL &&
> +			   !skb_is_gso(skb) &&
> +			   (skb->head + skb->csum_start + skb->csum_offset) !=
> +			   (unsigned char *)&hdr->check;
> +
> +		if (lco)
> +			skb->ip_summed = CHECKSUM_NONE;
> +
>  		nf_csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
>  		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
>  					 false);
> +
> +		if (lco)
> +			skb->ip_summed = CHECKSUM_PARTIAL;
> +

[Severity: High]
This change only covers the nf_nat path. Can the software flowtable fast
path still corrupt the outer UDP checksum for the same LCO packets?

Once the conntrack entry is offloaded (for example with "flow add @ft" plus
MASQUERADE), later packets of the outer VXLAN/Geneve flow take this path:

nf_flow_offload_ip_hook()
  nf_flow_nat_ip()
    nf_flow_snat_port() -> nf_flow_nat_port_udp()
    nf_flow_nat_ip_l4proto() -> nf_flow_nat_ip_udp()

They never reach __udp_manip_pkt().

In net/netfilter/nf_flow_table_ip.c:nf_flow_nat_ip_udp():

	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
		inet_proto_csum_replace4(&udph->check, skb, addr,
					 new_addr, true);

There is no check here on whether csum_start + csum_offset points at this
outer udph->check. Because of that, inet_proto_csum_replace4() takes the
seed branch:

net/core/utils.c:inet_proto_csum_replace4() {
	...
	} else if (pseudohdr)
		*sum = ~csum_fold(csum_add(csum_sub(csum_unfold(*sum),
						    (__force __wsum)from),
					   (__force __wsum)to));
}

For an LCO complete checksum, this applies the address delta with the
wrong sign.

In net/netfilter/nf_flow_table_core.c:nf_flow_nat_port_udp():

	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
		inet_proto_csum_replace2(&udph->check, skb, port,
					 new_port, false);

With pseudohdr=false under CHECKSUM_PARTIAL, this is a no-op. That is the
same lost port delta this patch fixes in __udp_manip_pkt().

nf_flow_nat_ipv6_udp() has the same pattern with
inet_proto_csum_replace16(..., true). IPv6 VXLAN computes the outer
checksum by default, so udp6_set_csum() takes the LCO branch there too.

If so, the first packets of the flow would be fixed by this patch. Would
packets after offload still be dropped by the receiver with
UdpInCsumErrors, which is the symptom the commit message describes?

Other callers make the same assumption. tcf_nat_act() in
net/sched/act_nat.c calls inet_proto_csum_replace4(&udph->check, skb,
addr, new_addr, true) under the same condition. In
net/netfilter/ipvs/ip_vs_proto_udp.c, udp_partial_csum_update() treats
every CHECKSUM_PARTIAL uh->check as a seed, though it does its own
arithmetic.

The shared helpers (inet_proto_csum_replace4/16/_by_diff) seem to be where
the assumption lives. Would a helper-level fix work better than a
per-caller ip_summed flip? For example, the helpers could take the seed
path only when:

	skb_checksum_start(skb) + skb->csum_offset == (u8 *)sum

and use csum_replace*() otherwise.

The commit message also doesn't mention these other call sites.

>  		if (!hdr->check)
>  			hdr->check = CSUM_MANGLED_0;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008054228.752274-1-lvjunyu%40cmss.chinamobile.com
