Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25C5384CE5;
	Fri,  9 Oct 2026 03:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791516076; cv=none; b=uGajJw8NrZvZklQgenhso31hf4dKhkWJfujvjIWISTI02HTtwwqGkf0zqCnIbAUbRwep0m3ZfUx9Xvbyjs4VHd2meU4GVdQAMoBGiAj4fbcYB071gYn4y/sAPdm5kZTKnhZy3ecziT8yZLx8+Lk64AZzocb7MmLlXC2Dx9jqklk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791516076; c=relaxed/simple;
	bh=wcqHV2Wg3FXBYYmg1vUHmOb3Xq5jc8STEKB0J+8XZ5A=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OKKn60g5OjS80oyoGJeM5ZFTJZRy04Hz13wLm3iNdcFz48MXUWum+sst9hOI99YsA+6CvYZMiwPu4LViaL/KeABmeLtHtmdBInW2qrSsdvcexu+r2iXd/RpyCLXCvnx7vY83ayuNm7+M6IeuJRseTcZc1dKAVdWMAhg8TqoFxyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZiCeaWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZiCeaWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7982D1F00899;
	Fri,  9 Oct 2026 03:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791516063;
	bh=JXfCHG31Bc/gSZjaK8k9wksl9IuXvNCzPnYy9hoGaWo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SZiCeaWykiCNamdBlxa2XXBIE7gHvyKIOn3LN9Z24cQoLXU1mgA+E4KHeFYXnfA8w
	 nqIAdtQM2bUAlDeqLfi8ov47ZQsL1z0gyDQt3j3saygu6WtBAm21eNfuexjr/pGN6Q
	 t4AkxHMvpWPEBN9PJKOmuxrBsKYq4/i0GcvolU+G3xbJk9ht9dV2KmZ3bYResU1deR
	 TYj7BjSjB0vD6D/mfDOYA5RtgrHYodZ8MQY7Yim4b73YyIKDn7KIylPvIPh9Ahiigy
	 XG4dPmJibsR6eKsD54zdUO7qufshIQBGq1l9gQ7j4D6bG8QIlhllADGadEtXMFF4QG
	 Qpvto6oN0so+g==
Subject: Re: [PATCH v3] netfilter: nf_nat: Fix stale outer UDP checksum on
 VXLAN encapsulated packets
From: netdev-bot+sashiko@kernel.org
To: lvjunyu@cmss.chinamobile.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Fri, 09 Oct 2026 03:21:03 +0000
Message-ID: <179151606303.434549.9146029208323443792@kernel.org>
In-Reply-To: <20260922062305.752147-1-lvjunyu@cmss.chinamobile.com>
References: <20260922062305.752147-1-lvjunyu@cmss.chinamobile.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 (1) · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Low] The commit message describes the trigger more narrowly than the
  code shows.
- [Low] The new comment in __udp_manip_pkt() presents the offload-target
  test as a way to tell apart only the two states that udp_set_csum()…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but the IPVS UDP
  NAT handlers have the same bug.

--

netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets

This patch changes __udp_manip_pkt() to detect the local checksum offload
(LCO) state. In that state the outer UDP header holds a complete checksum
while csum_start points at the inner transport header. When it sees this
state, it sets ip_summed to CHECKSUM_NONE for the duration of the update,
so the address and port deltas are applied through csum_replace*().

> When MASQUERADE --random-fully rewrites the outer UDP source port and
> address of a VXLAN-encapsulated packet whose inner header has
> CHECKSUM_PARTIAL, the outer UDP checksum is not updated correctly.

[Severity: Low]
Is the trigger described here narrower than the real one?

Any SNAT, DNAT or MASQUERADE that changes the address of an LCO-state
outer UDP header hits the wrong-sign delta in
nf_csum_update()->inet_proto_csum_replace4/16(pseudohdr=true), even if no
port changes. Any port rewrite hits the no-op inet_proto_csum_replace2().

The LCO branch lives in udp_set_csum(). Its callers are
udp_tunnel_xmit_skb() (VXLAN, GENEVE, bareudp and others),
l2tp_xmit_core(), fou_build_udp() and ip_vs_tunnel_xmit().
udp6_set_csum() has the same branch for IPv6, and the patch also changes
IPv6 behaviour through nf_nat_ipv6_csum_update().

The reproducer may have needed --random-fully only because MASQUERADE in a
single netns keeps the same source address. That leaves the port as the
only field that changes.

Could the changelog state the general trigger, so stable triage can judge
the impact correctly?

> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index 64b9bac228eae..6779e9f2812d9 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -54,9 +54,39 @@ __udp_manip_pkt(struct sk_buff *skb,
>  		portptr = &hdr->dest;
>  	}
>  	if (do_csum) {
> +		/* When udp_set_csum() takes the LCO branch (encapsulated

[ ... ]

> +		 * The seed/offload branch of udp_set_csum() sets csum_start
> +		 * to the outer UDP header, so the offload-target test
> +		 * below distinguishes the two states.
> +		 */

[Severity: Low]
This isn't a bug, but is this comment complete? It describes the test as
telling apart only the two states that udp_set_csum() creates. The
predicate below is true for any CHECKSUM_PARTIAL non-GSO skb whose
csum_start + csum_offset is not &hdr->check.

One such case is the UDP header embedded in an ICMP or ICMPv6 error. In
nf_nat_icmp_reply_translation() and nf_nat_icmpv6_reply_translation(), it
is rewritten through:

  nf_nat_ipv{4,6}_manip_pkt()
    udp_manip_pkt()
      __udp_manip_pkt()

On that path the offload target is the outer ICMP checksum.

The embedded UDP checksum there is a complete checksum, so switching to
csum_replace*() gives the right result. The only gap is that neither the
comment nor the lco name covers this case.

The comment also names only the IPv4 helpers. This code covers
udp6_set_csum() and inet_proto_csum_replace16() too.

> +		bool lco = skb->ip_summed == CHECKSUM_PARTIAL &&
> +			   !skb_is_gso(skb) &&
> +			   (skb->head + skb->csum_start + skb->csum_offset) !=
> +			   (unsigned char *)&hdr->check;

[Severity: High]
Is this fix complete for flows that are offloaded to an nft flowtable?

The flowtable fast path applies the same conntrack NAT with the old
helpers:

net/netfilter/nf_flow_table_ip.c:nf_flow_nat_ip_udp() {
    ...
	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
		inet_proto_csum_replace4(&udph->check, skb, addr,
					 new_addr, true);
    ...
}

net/netfilter/nf_flow_table_core.c:nf_flow_nat_port_udp() {
    ...
	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
		inet_proto_csum_replace2(&udph->check, skb, port,
					 new_port, false);
    ...
}

nf_flow_nat_ipv6_udp() follows the same pattern with
inet_proto_csum_replace16().

For an LCO-state outer UDP header, these functions hit the same two
failures this patch fixes in __udp_manip_pkt(): the address delta gets the
wrong sign, and the port update does nothing. Nothing in the flowtable
path filters out CHECKSUM_PARTIAL or encapsulated skbs.

Take a MASQUERADE or SNAT rule plus a flowtable. The first packets of a
UDP tunnel flow get correct checksums through nf_nat. Once the conntrack
is offloaded, the rest of the flow goes through:

  nf_flow_offload_ip_hook()
    nf_flow_offload_forward()
      nf_flow_snat_ip() / nf_flow_dnat_ip()
        nf_flow_nat_ip_l4proto()
          nf_flow_nat_ip_udp()
      nf_flow_snat_port() / nf_flow_dnat_port()
        nf_flow_nat_port_udp()

Would the receiver then drop those packets with UdpInCsumErrors?

tcf_nat_act() in net/sched/act_nat.c uses the same pattern on outer UDP
headers.

All of these callers rely on one assumption in inet_proto_csum_replace*():
under CHECKSUM_PARTIAL, the field being patched is taken to be the
offload target.

net/core/utils.c:inet_proto_csum_replace4() {
    ...
	} else if (pseudohdr)
		*sum = ~csum_fold(csum_add(csum_sub(csum_unfold(*sum),
						    (__force __wsum)from),
					   (__force __wsum)to));
}

Would it work better to compare sum against skb->head + csum_start +
csum_offset inside those shared helpers? That would cover nf_nat, the
flowtable and act_nat in one place, instead of a local workaround in
__udp_manip_pkt().

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

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch, but the
IPVS UDP NAT handlers look like they have the same problem.

udp_snat_handler() and udp_dnat_handler() in
net/netfilter/ipvs/ip_vs_proto_udp.c check only ip_summed:

	if (skb->ip_summed == CHECKSUM_PARTIAL) {
		udp_partial_csum_update(cp->af, udph, &cp->daddr, &cp->vaddr,
					htons(oldlen),
					htons(skb->len - udphoff));

udp_partial_csum_update() always treats the field as a seed:

	uhdr->check =
		~csum_fold(ip_vs_check_diff4(oldip->ip, newip->ip,
				ip_vs_check_diff2(oldlen, newlen,
						csum_unfold(uhdr->check))));

It never applies the port change.

For an LCO outer UDP header built by udp_set_csum() or udp6_set_csum(),
won't IPVS also apply the address delta with the wrong sign and skip the
port delta?

After this patch, nf_nat and IPVS would also handle the same skb state
differently.

>  		if (!hdr->check)
>  			hdr->check = CSUM_MANGLED_0;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922062305.752147-1-lvjunyu%40cmss.chinamobile.com
