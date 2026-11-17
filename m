Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874974;
	b=AC4zdHGZXJ1b+evKEt0iIijgf6gFdac7Vvtwkb/RQl4rEVgew1lfKTVOfsfNWBMbpkwn
	 sh1Wc+n3GehjFduwE/6LKoFoyG3aDISaDGKEAL2/Rgi+sVLrYViPbaJQLhjIpmOexP6Ro
	 hG2nC4wAWMS1yw8Q1m7COHRk49ORFY5AWo2DqUmBEt2sdBoCAkp1HBjs4999F6sj/aoL1
	 8PhYiuii0a9WSDU33/O3n4zPLi9YTHnvHrXP4ElmvKMKHQTtJ9jGdbbtMQDS/VEhbq0D5
	 rFph01U+3i8h+OiTPpOgbPkWznJynTSdjIMeegPyD0xoEILomDxNu3ltpBCQ6MsfV/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874974;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=FEO3yHzJHKgQjAgSN+6e2SLhIFTlfGb0cW9aEGkhl08=;
	b=ivjRO0+1sAbAvvGG3n103QxJN1zJVof7kTnAd3ZIwCUzJzQ9XPFiPz/CEanQyiLFRUrX
	 rD/B6oTbxvews5+BpXr5lQmRD11rguqex7HAKlJrJfmE/6DbqQTjXKduFtMmguBRIEVfV
	 /RPWgwoaE/pA+tp4J8eX5z4Zm4GQMG28CxDaFXofUI4mqY0Q+id+NMRv24p22+Z8vSihC
	 rgSNlsWv6Mem/nG8rMYRHmMI6/vOl6nOwkiR4w95yC0WjhOQUQ2BXrXjNzb5OtLl/jAED
	 6zVjypHSJPtMKJBmzxm6IUtaQ+jgZ+JwFtzcSaC4Et63vsZcQk9MjnkGm8K+LKtn05g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dDo3++Wd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693EF606A332;
	Tue, 17 Nov 2026 00:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dDo3++Wd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC91F000C4;
	Tue, 17 Nov 2026 00:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874974;
	bh=FEO3yHzJHKgQjAgSN+6e2SLhIFTlfGb0cW9aEGkhl08=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dDo3++Wdo1VgXmTBCWFzBNrgEzSFETb8jX6EkSoXU4btk/V2/xsLPxnmtUZsKVKeA
	 d84sK5StA72OHMRNximbYt4F9FM0S2fvcIREsihpFJcDomIM1ZdAPQnoYtOLz3BKQA
	 Qh8G3Yt0JMpwgsNSdPaRrkCIH/Htn04HsjgQ3qFfTEKpG6bXiHXeGht8yYYqJmbFzq
	 lsIWJxBgk610k4R4hWA7oXDldea5zfJtKa3FNGR1J5a2aZp1skT4Z7BUzad7IbP0NN
	 gDUIjGSIs1HhDI22jh5zXkrIaviIfSBUuL1kpj2x0qfRepY6dASd3QQ7MVUvHMolfV
	 zWOZ8lsSmKaaQ==
Subject: Re: [PATCH net-next 13/13] selftests: netfilter: add UDP flowtable
 offload test
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:53 +0000
Message-ID: <179487497337.3136.6527591002750060287@kernel.org>
In-Reply-To: <20261116001612.2806263-14-pablo@netfilter.org>
References: <20261116001612.2806263-14-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] listener_ready() in nft_flowtable_udp.sh (line 111) runs `ss
  -N "$ns2" -uln -H "sport = :$port" | grep -q "$port"`.
- [Low] The test cannot detect a broken UDP checksum rewrite in the
  flowtable NAT path, although the commit message and file header…
- [Low] The header comment of nft_flowtable_udp.sh lists
  nf_flow_dnat_ipv6 and flow_offload_fixup_ct among the paths this UDP…

--

selftests: netfilter: add UDP flowtable offload test

This adds nft_flowtable_udp.sh, which sends a burst of UDP echoes through
an ingress flowtable for IPv4 and IPv6, with and without masquerade. It
checks that the payload comes back, that the forward chain sees only the
first packets of the flow, and that conntrack marks the entry OFFLOAD and
accounts every datagram.

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
Does this test actually exercise nf_flow_dnat_ipv6() and
flow_offload_fixup_ct()?

The only NAT rule the script adds is a source NAT:

    nft add rule inet nat postrouting oifname "veth1" masquerade

flow_offload_alloc() sets NF_FLOW_DNAT only from IPS_DST_NAT:

net/netfilter/nf_flow_table_core.c:flow_offload_alloc() {
    ...
	if (ct->status & IPS_DST_NAT)
		__set_bit(NF_FLOW_DNAT, &flow->flags);
    ...
}

nf_flow_nat_ipv6() calls nf_flow_dnat_ipv6() only when that bit is set:

	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
		nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir);
		nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir);

So it looks like the DNAT path never runs.

flow_offload_fixup_ct() has one caller, flow_offload_teardown(). Teardown
happens through gc expiry, ct dying, dst/MTU failures, or flowtable/netdev
cleanup. None of these happen during the four run_case() checks.
Teardown only happens when the EXIT trap deletes the namespaces, which is
after every check has finished. A regression in the UDP fixup_ct path
would therefore not fail this test.

Also, tools/testing/selftests/bpf/prog_tests/xdp_flowtable.c already
sends UDP through a flowtable. The "zero coverage" wording only holds
because of the "in that run" qualifier.

Could these entries be removed from the header? The other option is to
add a DNAT case (for example a prerouting dnat rule) and an explicit
teardown/fixup check.

[ ... ]

> +ip link add veth0 netns "$nsr" type veth peer name eth0 netns "$ns1"
> +ip link add veth1 netns "$nsr" type veth peer name eth0 netns "$ns2"
> +
> +ip -net "$nsr" link set veth0 up
> +ip -net "$nsr" link set veth1 up
> +ip -net "$ns1" link set eth0 up
> +ip -net "$ns2" link set eth0 up

[Severity: Low]
Can this test detect a broken UDP checksum rewrite in the masquerade
cases?

The veth pairs keep their default features. VETH_FEATURES includes
NETIF_F_HW_CSUM, so the datagrams socat sends from ns1 and ns2 are
CHECKSUM_PARTIAL.

For those skbs, nf_flow_nat_ip_udp() and the IPv6 equivalent,
nf_flow_nat_ipv6_l4proto(), only patch the pseudo-header partial sum:

	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
		inet_proto_csum_replace4(&udph->check, skb, addr,
					 new_addr, true);

The skb is still CHECKSUM_PARTIAL when it reaches the peer namespace.
skb_csum_unnecessary() returns true for it, so the receiving UDP stack
never verifies the checksum.

The only correctness check is the payload echo in udp_exchange():

	if ! IFS= read -r -n 4 -t 2 got <&"${SO[0]}"; then

That check passes whether the rewrite is right or wrong. The
full-checksum (non-PARTIAL) branch of the rewrite never runs either.

Would it make sense to run "ethtool -K eth0 tx off" in ns1 and ns2, so
the datagrams carry full checksums that the receiver verifies? If not,
the header and commit message could say that checksum correctness is not
verified.

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
> +	echo "FAIL: UDP listener did not start" >&2
> +	exit 1
> +fi

[Severity: Medium]
Can listener_ready() succeed when only one of the two listeners has
bound?

The ss query covers both address families. The grep matches as soon as
either the UDP4-LISTEN or the UDP6-LISTEN socat has bound port 12345.
busywait() returns on the first success via loopy_wait() in lib.sh:

	if out=$("$@"); then
		echo -n "$out"

The two socat processes start in the background at the same time.
Nothing orders their binds.

If the IPv6 listener binds first, the script goes straight to
run_case "IPv4 UDP". udp_exchange() can then send datagram 0 to
10.0.2.99:12345 before the UDP4 socat is listening. ns2 drops it with an
ICMP port unreachable, and the read times out. The run then reports
"FAIL: packet 0 timeout" and "IPv4 UDP: payload was not forwarded" for a
reason that has nothing to do with the flowtable.

Could the check wait for both sockets? For example, it could query
ss -4 and ss -6 separately, or require two matching lines.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
