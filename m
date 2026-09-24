Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4B2397694;
	Thu, 24 Sep 2026 07:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233457; cv=none; b=gdu+tgs5x34ZiAEOYm83Z7K9KvxW12URGJeA8tEp8qFOH/XViP092KoSEzc4OwKNrmtTL1FCu+95AIw2nEMgVDzm16kkY6GYLdQdxaw7XNSB0Dl0HbLAci0t08vCGxBJ3GZP3HZETthjiMM0LZL68+vRAe8t+MkRAHtdheHCfM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233457; c=relaxed/simple;
	bh=qZXJ8iPMdYafbKxwCfIqAvVTIKu4lrCumhrIj+yDDqE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=go8ERgO4q25espovPKRdTjcUPZcWKszHsCGc431pHvYjj+YezWDmYtNgVEdROfUGhfOvGEu0H0Vo6+qhnBnb+SHptWdeEHjrk7MAqby3SUQVyOMJNhktylDBeKlbsDRirLQJ1J0L8y+1te+jUP4dAj6/QcvDzda30M78n77mFyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oz7gcmLH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oz7gcmLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC411F000FF;
	Thu, 24 Sep 2026 07:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790233442;
	bh=Y7nx2EMqQRZ9Wz7KPD5xqHppiSa83rusVgJwcIYKlS4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Oz7gcmLH8sbKRQLBNmNgSsa5d1b0jXGx1Lz9MxiMIx3OIjHPUbw1X6UiKXI0fgY1x
	 tTlX7n6EosE+lkdfbzyO6E1Rw9AKoU2nPoG7iUqoybUXjpjJcKudGTrZu56EoBCunX
	 WWjRGYtbdCIDzQ3qNqi5dousrUK/vocipfuBDqjN+oMdr/wnuhpVPj11hmIiZTvgig
	 8o7YSR+fL+LX8csG7aNRrHeU64N9Lqd2Wgun8EjT8PtdTWS/W9SII1vP0R3NBSO/Rs
	 nVDLZvkE8ah7Pi4VPLD3+3W0U+sbpFth6ZZRo6s3xYgDWVoRv7S3umHKk1Do2nrY3f
	 N9JjSCEAhuphg==
Subject: Re: [PATCH v2] netfilter: nf_nat: Fix stale outer UDP checksum on
 VXLAN encapsulated packets
From: netdev-bot+sashiko@kernel.org
To: lvjunyu@cmss.chinamobile.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Thu, 24 Sep 2026 07:04:01 +0000
Message-ID: <179023344134.2160803.7539693493883109970@kernel.org>
In-Reply-To: <20260921130312.686493-1-lvjunyu@cmss.chinamobile.com>
References: <20260921130312.686493-1-lvjunyu@cmss.chinamobile.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Peer call-site divergence: after this patch nf_nat's
  __udp_manip_pkt() treats a CHECKSUM_PARTIAL skb whose offload target…
- [Low] The new comment in __udp_manip_pkt() states that both the address
  and the port delta are "applying the address and port deltas with the…

Pre-existing issues:
- [Medium] Incomplete/asymmetric fix inside net/netfilter/nf_nat_proto.c:
  the new "offload target is not this header" discriminator was added…

--

netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets

This patch makes __udp_manip_pkt() detect the state left behind by the LCO
branch of udp_set_csum(), where uh->check holds a complete checksum but
csum_start still points at the inner transport header.  It does so by
comparing the skb's csum offload target against the udphdr being mangled,
and temporarily setting ip_summed to CHECKSUM_NONE across the address and
port fixups so the complete-checksum helpers are used.

A few questions below.

> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index 64b9bac228eae..cb70d85716bd3 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -54,9 +54,35 @@ __udp_manip_pkt(struct sk_buff *skb,
>  		portptr = &hdr->dest;
>  	}
>  	if (do_csum) {
> +		/* When udp_set_csum() takes the LCO branch (encapsulated
> +		 * CHECKSUM_PARTIAL, non-GSO), uh->check holds a complete
> +		 * (folded and complemented) checksum while csum_start
> +		 * points at the inner transport header, not at this outer
> +		 * udphdr.  In that state, inet_proto_csum_replace*() and
> +		 * nf_csum_update() take the pseudo-header branch which
> +		 * operates on an uncomplemented seed, applying the address
> +		 * and port deltas with the wrong sign.  Temporarily flip

[Severity: Low]
This isn't a bug in the code change itself, but does the comment describe
the port delta correctly?  The port fixup just below passes pseudohdr =
false:

	inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
				 false);

and inet_proto_csum_replace4() in net/core/utils.c only has a
CHECKSUM_PARTIAL path guarded by pseudohdr:

	if (skb->ip_summed != CHECKSUM_PARTIAL) {
		csum_replace4(sum, from, to);
		...
	} else if (pseudohdr)
		*sum = ~csum_fold(csum_add(csum_sub(csum_unfold(*sum),
						    (__force __wsum)from),
					   (__force __wsum)to));

So with pseudohdr = false and CHECKSUM_PARTIAL the port delta is not
applied at all, rather than applied with the wrong sign.  The changelog
already says this ("inet_proto_csum_replace2() is a no-op (pseudohdr=false,
CHECKSUM_PARTIAL)"), so could the comment be reworded to keep the two cases
distinct?

> +		 * ip_summed so they use csum_replace*() instead.
> +		 *
> +		 * The seed/offload branch of udp_set_csum() sets csum_start
> +		 * to the outer UDP header, so the offload-target test
> +		 * below distinguishes the two states.
> +		 */
> +		bool lco = skb->ip_summed == CHECKSUM_PARTIAL &&
> +			   !skb_is_gso(skb) &&
> +			   (skb->head + skb->csum_start + skb->csum_offset) !=
> +			   (unsigned char *)&hdr->check;
> +
> +		if (lco)
> +			skb->ip_summed = CHECKSUM_NONE;
> +

[Severity: Medium]
Does the same fixup need to happen in the flowtable software fast path?
nf_flow_nat_ip_udp() in net/netfilter/nf_flow_table_ip.c rewrites the same
outer UDP header for a NATed, offloaded conntrack entry and keeps the
pseudo-header form:

net/netfilter/nf_flow_table_ip.c:nf_flow_nat_ip_udp() {
	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
		inet_proto_csum_replace4(&udph->check, skb, addr,
					 new_addr, true);
		if (!udph->check)
			udph->check = CSUM_MANGLED_0;
	}
}

nf_flow_nat_ipv6_udp() does the same with inet_proto_csum_replace16(...,
true).  For an LCO-state skb (ip_summed == CHECKSUM_PARTIAL, csum_start at
the inner transport header) that reaches nf_flow_offload_ip_hook() ->
nf_flow_snat_ip() -> nf_flow_nat_ip_l4proto() -> nf_flow_nat_ip_udp(),
isn't uh->check still treated as an uncomplemented seed there, leaving the
outer UDP checksum wrong in exactly the way the changelog describes?

After this patch the two in-tree implementations disagree about the meaning
of uh->check for an identical packet state.

There is also a smaller difference in the zero-checksum gate: udp_manip_pkt()
passes do_csum = !!hdr->check, so an outer UDP header that deliberately
carries no checksum is left alone, while the flowtable condition above also
fires when udph->check == 0 as long as ip_summed == CHECKSUM_PARTIAL, and
then writes a checksum or CSUM_MANGLED_0 into a header that had none.  Is
that difference intentional?

>  		nf_csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
>  		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
>  					 false);

[Severity: Medium]
This isn't a bug introduced by this patch, but the same unguarded
nf_csum_update() pattern exists at three sibling sites in this file, and
they are left untouched.  Were they considered?

tcp_manip_pkt() ends with:

	nf_csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
	inet_proto_csum_replace2(&hdr->check, skb, oldport, newport, false);

icmpv6_manip_pkt() does:

	nf_csum_update(skb, iphdroff, &hdr->icmp6_cksum, tuple, maniptype);

and the CHECKSUM_PARTIAL branches of nf_nat_ipv4_csum_recalc() and
nf_nat_ipv6_csum_recalc() do:

	} else {
		inet_proto_csum_replace2(check, skb,
					 htons(oldlen), htons(datalen), true);
	}

For tcp_manip_pkt() and icmpv6_manip_pkt() the header being mangled can be
the one embedded in an ICMP error, reached via nf_nat_ipv4_fn() ->
nf_nat_icmp_reply_translation() -> nf_nat_ipv4_manip_pkt(), and that caller
already has an explicit "if (skb->ip_summed != CHECKSUM_PARTIAL)" path for
the outer ICMP checksum, so CHECKSUM_PARTIAL skbs are an expected input
there.  In that case the offload target is the outer ICMP checksum rather
than the embedded TCP/ICMPv6 checksum, which looks like the same
precondition this patch guards against for UDP.

Since all three manip_pkt callers funnel through nf_csum_update() and always
pass pseudohdr = true, would putting the offload-target test in
nf_csum_update() (or a small shared helper) cover every caller instead of
only the UDP one?

> +
> +		if (lco)
> +			skb->ip_summed = CHECKSUM_PARTIAL;
> +
>  		if (!hdr->check)
>  			hdr->check = CSUM_MANGLED_0;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921130312.686493-1-lvjunyu%40cmss.chinamobile.com
