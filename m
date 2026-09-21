Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137C7442376;
	Mon, 21 Sep 2026 07:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789976945; cv=none; b=acSg95huYu+kNqbxW2ss6LYJfqX+muJfC8hUEGp9Pq+HN83qqUz6ZOKAopBXdx+0jzclTB2bUn9Pvvl3qbGJPvE/anWKPS29xZg+6zUTrVwLCS92yIzrxBakjEojAJmVTNMxJfdFOkIO5X9q7pQ34+0KRTornWsFrH/6Y/JaoE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789976945; c=relaxed/simple;
	bh=ctLbt7E8aHd2KyZYKdrr0U0k+vd82N4deQeffUNWc9Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JYbghbUpcuiu2IWSbYbvQSo6J0eSREUk3d3ozEArhSrnO48sw3W6B3Jy8tZ2PS0RUrfcm2aLcbNemYfLEeoF8zYj0PTKgg1kEY6Gk25xn0A6uda+yEROq8G8uIxm97Dd8WNvmt+JYP4pQ61I7Nql80qZrRpxqg3ovRp8wxiyVvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwGeybxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwGeybxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDDC1F000FF;
	Mon, 21 Sep 2026 07:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789976943;
	bh=NVIq4N6vDgskO7KzshGLhKNg+pTHDDIJdDhKJcjU99s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QwGeybxN3vbV+/HEgDTX1O99nYK8byC1rPflQNRA/cGW5zbto18p3zQ7Lzac9dQu7
	 P7swAxdflUCwDo8dtybroKExKVR3HES3C6xNpQrg49rRnGURBAhgJjhC8ENjESHOQO
	 rA2h9L20KIf+VFfJh5IXFVrgb75hgPYaMnAS2sbFaWMkjhbLfPsz97UANkJH5nswi/
	 g6u7Sbe0UYy0yHJTdklc9008JBN+FUq7gfupCUpO/c7FT302erVOT8yrtKqsL26q7g
	 6jzE4iN+7FN1dfaWOBOc022owGiOuQ+ridpfzLNVAxznwS975vLm3uscxmCeKM9XgB
	 2qre1pq9mlinA==
Subject: Re: [PATCH] netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN
 encapsulated packets
From: netdev-bot+sashiko@kernel.org
To: lvjunyu@cmss.chinamobile.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Mon, 21 Sep 2026 07:49:02 +0000
Message-ID: <178997694260.2160803.768338135360205258@kernel.org>
In-Reply-To: <20260920074543.525572-1-lvjunyu@cmss.chinamobile.com>
References: <20260920074543.525572-1-lvjunyu@cmss.chinamobile.com>
X-sashiko-severity: High
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

Critical: 0 · High: 2 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Incomplete fix: in the exact state the new code selects (outer
  UDP checksum produced by udp_set_csum()'s LCO branch, i.e. a…
- [High] Wrong discriminator: `skb->encapsulation` does not tell whether
  the outer UDP checksum field holds a *final* (LCO) value or a *pseudo-…

--

netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets

This adds an explicit csum_replace2() in __udp_manip_pkt() to fix up the
outer UDP checksum when a NAT port rewrite happens on an encapsulated,
CHECKSUM_PARTIAL, non-GSO skb.  The goal is to stop remote VTEPs from
dropping the first packet of a connection with UdpInCsumErrors.

(No Link: tags present in the commit header.)

> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index 64b9bac228ea..35cc6e10b5bb 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -57,6 +57,20 @@ __udp_manip_pkt(struct sk_buff *skb,
>  		nf_csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);

[Severity: High]
Does the address half of the rewrite still leave the outer checksum wrong
here?

In the state this patch targets, udp_set_csum() took the LCO branch, so
uh->check holds a complete (folded and complemented) checksum while
ip_summed stays CHECKSUM_PARTIAL:

net/ipv4/udp.c:udp_set_csum() {
	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
		uh->check = 0;
		uh->check = udp_v4_check(len, saddr, daddr, lco_csum(skb));

But nf_csum_update() above, which touches the very same hdr->check, goes
through nf_nat_ipv4_csum_update() -> inet_proto_csum_replace4(..., true)
and takes the pseudo-header branch for CHECKSUM_PARTIAL skbs:

net/core/utils.c:inet_proto_csum_replace4() {
	if (skb->ip_summed != CHECKSUM_PARTIAL) {
		csum_replace4(sum, from, to);
		...
	} else if (pseudohdr)
		*sum = ~csum_fold(csum_add(csum_sub(csum_unfold(*sum),
						    (__force __wsum)from),
					   (__force __wsum)to));
}

Since csum_fold() already complements, ~csum_fold(X) is the uncomplemented
fold, so the field becomes C + (newip - oldip), whereas a complete checksum
needs C - (newip - oldip) as csum_replace4() computes.  Is the address delta
applied with the wrong sign in this state, leaving an error of 2*delta?

MASQUERADE normally rewrites the source address too:

net/netfilter/nf_nat_masquerade.c:nf_nat_masquerade_ipv4()
	newrange.min_addr.ip = newsrc; /* outgoing interface address */

In the single-netns vxlan + veth topology described in the changelog the
masqueraded address equals the original one, so delta is zero and only the
port fixup is exercised.  With a real outgoing interface address change, does
the remote VTEP still drop the packet with UdpInCsumErrors after this patch?

The same applies on IPv6 via nf_nat_ipv6_csum_update() ->
inet_proto_csum_replace16(..., pseudohdr=true), which has the identical
uncomplemented-seed branch.

Would treating the field as a complete checksum for both the address and the
port update in this state (bypassing the pseudo-header branch of
nf_csum_update() and using csum_replace4()/csum_replace2()) be the more
complete fix?

> +		/* For CHECKSUM_PARTIAL encapsulated non-GSO packets,
> +		 * inet_proto_csum_replace2() above is a no-op because the
> +		 * port field is data, not pseudo-header. The outer uh->check
> +		 * was computed by udp_set_csum() with a temporary sport, and
> +		 * the subsequent NAT sport rewrite leaves it stale. On devices
> +		 * without hw_enc_features, the software fallback
> +		 * skb_checksum_help() honors csum_start which points at the
> +		 * inner transport header and only recomputes the inner
> +		 * checksum. The stale outer checksum goes out and the
> +		 * receiver drops the packet with UdpInCsumErrors.
> +		 */
> +		if (skb->ip_summed == CHECKSUM_PARTIAL &&
> +		    skb->encapsulation && !skb_is_gso(skb))
> +			csum_replace2(&hdr->check, *portptr, newport);

[Severity: High]
Is skb->encapsulation the right discriminator here?

udp_set_csum() has two non-GSO CHECKSUM_PARTIAL states with opposite
meanings.  The LCO branch writes a final checksum, but the last else branch
requests offload of this very header and leaves only a seed in the field:

net/ipv4/udp.c:udp_set_csum() {
	} else {
		skb->ip_summed = CHECKSUM_PARTIAL;
		skb->csum_start = skb_transport_header(skb) - skb->head;
		skb->csum_offset = offsetof(struct udphdr, check);
		uh->check = ~udp_v4_check(len, saddr, daddr, 0);
	}
}

For vxlan/geneve/fou the second state is hidden only because
iptunnel_handle_offloads() clears the flag:

net/ipv4/ip_tunnel_core.c:iptunnel_handle_offloads() {
	if (skb->ip_summed != CHECKSUM_PARTIAL) {
		skb->ip_summed = CHECKSUM_NONE;
		/* We clear encapsulation here to prevent badly-written drivers ... */
		skb->encapsulation = 0;
	}
}

Producers that set encapsulation themselves and do not call that helper stay
in the seed state with encapsulation == 1.  SCTP over UDP is one:

net/sctp/output.c:sctp_packet_pack()
	/* with tp->encap_port set, the CRC is computed in software and
	 * ip_summed is left alone */

net/sctp/protocol.c:sctp_v4_xmit()
	skb->encapsulation = 1;
	...
	udp_tunnel_xmit_skb(dst_rtable(dst), sk, skb, fl4->saddr, ...);

That packet reaches __udp_manip_pkt() with ip_summed == CHECKSUM_PARTIAL,
encapsulation == 1, non-zero uh->check (so do_csum is true) and csum_start
pointing at the outer UDP header.  Does the new csum_replace2() then mutate a
pseudo-header seed that the NIC or skb_checksum_help() will re-sum over the
already-rewritten port bytes, making the emitted checksum off by the port
delta?  The same applies to sctp_v6_xmit() via udp6_set_csum(), where
uh->check is always non-zero.

In the other direction, does the condition miss LCO packets that are not
flagged encapsulated?  l2tp_xmit_core() calls udp_set_csum() without ever
calling iptunnel_handle_offloads() and without setting skb->encapsulation:

net/l2tp/l2tp_core.c:l2tp_xmit_core()
	udp_set_csum(sk->sk_no_check_tx, skb, inet->inet_saddr,
		     inet->inet_daddr, udp_len);

so an L2TP/UDP packet in the LCO state would keep its stale outer checksum
after a NAT port rewrite.

Would testing the offload target itself be more robust, for example only
fixing up the field when skb_checksum_start(skb) + skb->csum_offset is not
&hdr->check?

[Severity: Medium]
The comment states the outer checksum "was computed by udp_set_csum()" and
that skb_checksum_help() "honors csum_start which points at the inner
transport header".  Is that unconditionally true for the states the new
predicate accepts?  In the udp_set_csum() else branch above, csum_start
points at the outer UDP header, so the comment describes only one of the two
CHECKSUM_PARTIAL cases the condition matches.

>  		if (!hdr->check)
>  			hdr->check = CSUM_MANGLED_0;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260920074543.525572-1-lvjunyu%40cmss.chinamobile.com
