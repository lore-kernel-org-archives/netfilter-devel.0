Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626632;
	b=3YX4q7DK1YYOC0uMfQJFQDqyggq6FUFoLWoGyPPSbZfxA9nopWj1vFWyFaiCPoITxvuc
	 ijZ2rmfvpmyde/npvYz8LP/Ml6dPAeLMMx0ObNrW2cwuExazNcscyVf4vLy/+6CM9yNYl
	 JskPdyRZG4viHwv+/3V5QqHU6gy/L8wxT+jyI4WoKJjQSG6mldUx3nFXtyXaG3c8Y7kAd
	 mahLx7IWciV1QQ9164REc6VWkjeLXr6zbIbnfDeig9EZ69DVCOdXcnwxnZ3dqFK8kkSHu
	 6qrdgmLFLyzSKAy3CWC6NJkTMz52SD6FOp0j0bde7sUbgzqP3F/j+w2kZ8nXfIy+jFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626632;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=RDsm/q1T9xStnUWpUU9lxQl0hScJur67DeHA8vz0UOc=;
	b=oFQC3w0CHNPHfu03vZ/vT+cP0kpdtrzdO636rrnHwWGPtrtr2teRYDQ/dwWjJcxXTIzr
	 wo+3dynhLBPt1TOC3UFT0bKfGcLymY8Kx6OIOgjWD4ljSgKR++tbDbSaYM+qtmw6pZJX/
	 v0YfL7gO3eDZG6rODNOPGkzyX1bQDBnvZhGQnOka5h+9RJX2dvX9P39S/YpFxCdM9aq/w
	 OHZPkBxJ4DfrS6R6QfcnEESkXRq4nR6xoQoBcim2xfSsgTHo7Erm9lO54FXaBLHsywxL4
	 ZyQWpgj5t0WzfCNAVmifsklwJiimJ8XaA/HIrshnp5Vbz+SvyIbqamDi8NPLig50Cbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pobg8Yht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A610D60A2620;
	Sat, 14 Nov 2026 03:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pobg8Yht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99EE1F000C5;
	Sat, 14 Nov 2026 03:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626632;
	bh=RDsm/q1T9xStnUWpUU9lxQl0hScJur67DeHA8vz0UOc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Pobg8YhtoqMIXh4WGFwfTE98DokYUWIn7S12qOpGrQVU5mkrHFmE1ugPQ9TIuoswx
	 NbGPGVSxqCbZRwc5GQnd/y4h+W+sRqmKVqw6WoWoFesSdEbKWmpB4HKq85CMe3LW9h
	 +i+zMH38SJASXV1tz6rAInrgMehGAViuSwOpmwiX2QC86i1fpCweo5ALJL4ECxoVF5
	 Da0tWkg0fAUjQSmT8akYkq3tCc5yL02oEaBOvgO8rEIO4lmgWh2ooI9+14bm0UGuwU
	 7LQ4wTFS5Jm9D4Fiv7OAxnJJCgr4I0z4gwWeW6QgogD0r8I6mBLzHZl5vx0ynUUeuB
	 4N2RdVU7bfbyw==
Subject: Re: [PATCH net-next 15/15] selftests: netfilter: add UDP flowtable
 offload test
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:51 +0000
Message-ID: <179462663134.2199510.11490120367774907266@kernel.org>
In-Reply-To: <20261113031251.2437074-16-pablo@netfilter.org>
References: <20261113031251.2437074-16-pablo@netfilter.org>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The test runs the UDP flowtable checksum code but cannot
  detect a bug in it.
- [Low] The header comment in nft_flowtable_udp.sh claims coverage the
  test does not provide.
- [Low] The "IPv4 UDP masquerade" and "IPv6 UDP masquerade" cases (lines
  235-236) never check that NAT actually happened.
- [Low] listener_ready() is supposed to wait for both UDP listeners but
  passes as soon as either one is bound.

--

selftests: netfilter: add UDP flowtable offload test

This adds nft_flowtable_udp.sh, which sends a burst of UDP echoes through
an ingress flowtable for IPv4 and IPv6, with and without masquerade. It
checks that the payload comes back intact, that the forward chain sees
only the handshake, and that conntrack marks the flow OFFLOAD and counts
every datagram.

> diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh b/tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh
> new file mode 100755
> index 0000000000000..e0f05c76bd8ec
> --- /dev/null
> +++ b/tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh
> @@ -0,0 +1,238 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# nft_flowtable.sh offloads TCP only. These UDP paths therefore stay at
> +# zero coverage in that run:
> +#
> +#   nf_flow_tuple_ip / nf_flow_tuple_ipv6          IPPROTO_UDP
> +#   nf_flow_nat_ip_udp / nf_flow_nat_port_udp      IPv4 NAT checksum
> +#   nf_flow_snat_ipv6 / nf_flow_dnat_ipv6          IPv6 NAT, including UDP
> +#   flow_offload_get_timeout / flow_offload_fixup_ct for UDP

[Severity: Low]
Is this list accurate for nf_flow_dnat_ipv6 and flow_offload_fixup_ct?

The only NAT rule the test adds is a postrouting masquerade, which is
source NAT only. flow_offload_alloc() sets NF_FLOW_DNAT only when the
conntrack has IPS_DST_NAT:

net/netfilter/nf_flow_table_core.c:flow_offload_alloc() {
    ...
	if (ct->status & IPS_DST_NAT)
		__set_bit(NF_FLOW_DNAT, &flow->flags);
    ...
}

nf_flow_nat_ipv6() calls the DNAT helpers only when that bit is set:

	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
		nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir);
		nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir);

So nf_flow_dnat_ipv6() never seems to run in this test.

The only caller of flow_offload_fixup_ct() is flow_offload_teardown().
The UDP offload timeout is 30 seconds, the test finishes in a few seconds,
and no route or device changes. Teardown only happens when cleanup_all_ns
runs from the EXIT trap, after PASS/FAIL has been printed. Nothing checks
the conntrack state or timeout after that point.

A minor point: tools/testing/selftests/bpf/prog_tests/xdp_flowtable.c
already adds UDP flows to a flowtable. The comment does limit its "zero
coverage" claim to the nft_flowtable.sh run, though.

Could the comment be corrected, or could a DNAT case and a teardown/fixup
check be added?

[ ... ]

> +listener_ready() {
> +	ss -N "$ns2" -uln -H "sport = :$port" | grep -q "$port"
> +}
> +
> +ip netns exec "$ns2" socat -T 60 \
> +	UDP4-LISTEN:"$port",reuseaddr,fork EXEC:cat >/dev/null 2>&1 &
> +ip netns exec "$ns2" socat -T 60 \
> +	UDP6-LISTEN:"$port",reuseaddr,ipv6only=1,fork EXEC:cat >/dev/null 2>&1 &
> +
> +if ! busywait 3000 listener_ready; then

[Severity: Low]
Can listener_ready() succeed when only one of the two listeners is bound?

The two socat processes start in parallel, and grep -q succeeds on the
first matching socket line. So busywait can return once 0.0.0.0:12345 is
bound, before the UDP6 socat has bound [::]:12345.

On a heavily loaded machine, the "IPv6 UDP" case could then send its
first datagram before the IPv6 listener exists. It would get ICMPv6 port
unreachable and fail with "FAIL: packet 0 timeout", which has nothing to
do with the flowtable. The 32 IPv4 round trips that run first make this
unlikely in practice.

Would counting the matching sockets (at least two), or checking ss -4 and
ss -6 separately, close this gap?

> +
> +udp_exchange() {

[ ... ]

> +	i=0
> +	while [ "$i" -lt "$count" ]; do
> +		msg=$(printf '%04d' "$i")
> +		printf '%s' "$msg" >&"${SO[1]}"
> +		if ! IFS= read -r -n 4 -t 2 got <&"${SO[0]}"; then
> +			echo "FAIL: packet $i timeout" >&2
> +			kill "$SO_PID" 2>/dev/null || true
> +			wait "$SO_PID" 2>/dev/null || true
> +			return 1
> +		fi
> +		if [ "$got" != "$msg" ]; then

[Severity: Medium]
Can this payload comparison catch a broken UDP checksum update in the
flowtable NAT code?

The commit message lists "the UDP checksum update" as newly covered. The
header comment labels nf_flow_nat_ip_udp / nf_flow_nat_port_udp as "IPv4
NAT checksum".

All links are veth pairs with default features, and VETH_FEATURES
includes NETIF_F_HW_CSUM. So the datagrams socat sends stay
CHECKSUM_PARTIAL from end to end.

On the router, nf_flow_nat_ip_udp() takes this branch, which only adjusts
the pseudo-header seed:

net/netfilter/nf_flow_table_ip.c:nf_flow_nat_ip_udp() {
	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
		inet_proto_csum_replace4(&udph->check, skb, addr,
					 new_addr, true);
    ...
}

nf_flow_nat_port_udp() calls inet_proto_csum_replace2(..., false). For
CHECKSUM_PARTIAL skbs, that leaves uh->check untouched.

The receiver in ns2 (or ns1 for replies) treats CHECKSUM_PARTIAL as
already valid in skb_csum_unnecessary():

	(skb->ip_summed == CHECKSUM_PARTIAL &&
	 skb_checksum_start_offset(skb) >= 0));

A wrong udph->check written by the flowtable would still be delivered.
The 4-byte payload would still match, and the test would still print
PASS. The CHECKSUM_NONE full-checksum branch never runs at all.

Would turning off tx checksum offload on the eth0 devices in ns1 and ns2
(for example ethtool -K eth0 tx off) force a real checksum that the
receiver verifies after the flowtable rewrites it?

[ ... ]

> +if ! ip netns exec "$nsr" nft add rule inet nat postrouting \
> +		oifname "veth1" masquerade; then
> +	echo "FAIL: could not add masquerade rule" >&2
> +	exit 1
> +fi
> +
> +run_case "IPv4 UDP masquerade" 4 10.0.2.99 5403
> +run_case "IPv6 UDP masquerade" 6 dead:2::99 5404

[Severity: Low]
Do these masquerade cases check that NAT actually happened?

run_case() checks three things: [OFFLOAD] in the conntrack line, the slow
counter, and the orig/reply packet counts. None of these differ between a
NATed flow and a plain one. ns2 has a default route back through nsr, so
the echo works with or without SNAT.

If the conntrack entry were not NATed, these cases would pass just like
the plain ones, without ever reaching nf_flow_snat_ip() or
nf_flow_snat_ipv6().

There is one partial safeguard. If the flowtable failed to apply an
existing SNAT binding, the slow counter would probably go over 8. A
missing binding would still go unnoticed.

Could run_case() check the conntrack line for a reply tuple that points
at the router, such as dst=10.0.2.1 or dst=dead:2::1?

> +
> +exit $ret

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
