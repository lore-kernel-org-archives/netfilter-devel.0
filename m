Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792746248;
	b=YchPv1F7A4KMPIJyRvWzHcvswYV+pMD+oWzKchWuP4DECvAN+EXR+s+3zK52sZSgxKMo
	 9bAVcddrj+A48b0uFqFH1y6O4ONu4D03ghf5xVRhyes3ZoZLH0DL1BVwNH1ClKhqF1duC
	 x2jEHd9jr8QNZKYGoLraEDA788aLaiajXH3PkP324qfNuUP+vRcaIBMci5ja0ZOMwPGco
	 Lvh/8JbVFEvQI5zYyDtJcwLhrfM+7KsVVCIuBmD8+XMAcGsFtUUc9af78gd4jc22OeKXH
	 d3DQ6jwGvXOQdMEmdTbY2vvgX+WY9NxJIRAQ33nRtQeG5NJGp74f+hAG9o2pEs/Ht5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792746248;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Qm6mggyFBa11YEU0QCjD5Fk5lL6IMH1f7dPerchKVUE=;
	b=XTACjF06l6RKrFZdzi6ASefNNSTPnoNfR/hbJA9TDiBYbfqWCA+AYugA5KHjikI7e60C
	 Xo7j5y2wc9db58MWPhTF/rldOHTfsQTeRzdj6VbtlBoQGonDKiwW4r7sORJ5HiaIL1hFu
	 UJ2566UfUHEPwbpOUQbqiZE0Lhnvi49m3wFa/5upB8gb4oUlVfHGZMlWz4tJ0gR7SYFRb
	 6ZbXTbTx9q/lFHsMAtG+5HDp3mc8ah6X6bn0RkZB4FDhekMvo+CpXd0V8hK8abkQLuMX0
	 b77zPfNTiPDs82mWifgWOPrbNK5YQyQefdmfFBgyO31QPYqvi787WzPetZN0eNgxk8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnBCsOTz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEE5606A31D;
	Fri, 23 Oct 2026 09:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnBCsOTz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDE01F01828;
	Fri, 23 Oct 2026 09:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792746247;
	bh=Qm6mggyFBa11YEU0QCjD5Fk5lL6IMH1f7dPerchKVUE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DnBCsOTzNMdKB2pJNE+2E9UYRrUzuWSaMMO2PcVdng+vd51zPEqpt0wkUygiGSy/l
	 WdQQQB2NR0cgCYC5+SQoPrF+URpMM14WbtDZ1m4vNvRiwoNDkESM3fAoZ+785wF9tp
	 ki67AFL8hFo+NICacOUVQlcxyt8T4i+M4rXpJBIdxq/GzCJZHoqOaOCSFazZ7rz4uj
	 XyIO63lHQficXvPmvg6gw21JIhmUjsp/voXzrYf8Tfh30ifmXNtvGL9EFWnR1fBZAr
	 Z6XYnYikEpl2YleZZKodx0CzAb2++yE1040ZQYQCy9yS4vh06rZy+xefBm1BDOfs7c
	 p3+/9wJXgAkEA==
Subject: Re: [PATCH 2/2] selftests: netfilter: add bridge conntrack test for
 vlan protocol mismatch
From: netdev-bot+sashiko@kernel.org
To: laveeshb@laveeshbansal.com
Cc: pablo@netfilter.org, fw@strlen.de, razor@blackwall.org, idosch@nvidia.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, kuba@kernel.org
Date: Fri, 23 Oct 2026 09:04:07 +0000
Message-ID: <179274624702.3134.15694473086180736851@kernel.org>
In-Reply-To: <20261020005642.39494-1-laveeshb@laveeshbansal.com>
References: <20261020005642.39494-1-laveeshb@laveeshbansal.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In bridge_ct_vlan_proto.sh, the check "FAIL: conntrack did not
  reassemble the packets" cannot detect missing reassembly in the vlan…
- [Low] In bridge_ct_vlan_proto.sh, run_all() returns ksft_skip as soon
  as any run_case() returns ksft_skip, even after earlier cases have run.

--

selftests: netfilter: add bridge conntrack test for vlan protocol mismatch

This adds a selftest that sends fragmented IPv4 and IPv6 pings through a
vlan filtering bridge with bridge conntrack, using vlan tags whose
protocol differs from (or matches) the bridge's vlan_protocol. It checks
that the pings get through, that conntrack reassembled the packets, and
that the kernel did not warn.

> diff --git a/tools/testing/selftests/net/netfilter/bridge_ct_vlan_proto.sh b/tools/testing/selftests/net/netfilter/bridge_ct_vlan_proto.sh
> new file mode 100755
> index 000000000000..19f842e17060
> --- /dev/null
> +++ b/tools/testing/selftests/net/netfilter/bridge_ct_vlan_proto.sh
> @@ -0,0 +1,182 @@

[ ... ]

> +	# Loading a ct rule in the bridge family enables bridge conntrack. The
> +	# postrouting counter sees the packets reassembled by conntrack.
> +	ip netns exec "$ns0" nft -f - <<EOF || return "$ksft_skip"
> +table bridge t {
> +	chain pre {
> +		type filter hook prerouting priority 0; policy accept;
> +		ct state new counter
> +	}
> +	chain post {
> +		type filter hook postrouting priority 0; policy accept;
> +		meta length > 1400 counter
> +	}
> +}
> +EOF

[Severity: Medium]
Can this counter go up in the mismatch cases even when nothing was
reassembled?

In the 802.1ad/802.1q, 802.1q/802.1ad and clone cases, __allowed_ingress()
moves the tag into the packet after prerouting:

net/bridge/br_vlan.c:__allowed_ingress() {
    ...
		if (skb->vlan_proto != br->vlan_proto) {
			/* Protocol-mismatch, empty out vlan_tci for new tag */
			skb_push(skb, ETH_HLEN);
			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
							skb_vlan_tag_get(skb));
    ...
}

After that, skb->data sits at the 4 byte in-band vlan header. meta length
is skb->len, so the post chain sees the IP length plus 4.

With the 1400 byte mtu on eth0.100, each IPv6 fragment is
40 + 8 + 1352 = 1400 bytes. A fragment that was never reassembled shows up
in the post chain as 1404 bytes and matches "meta length > 1400". IPv4
fragments come out at exactly 1400 and don't match.

If bridge conntrack stopped defragmenting, nf_ct_bridge_refrag() would
return early:

net/bridge/netfilter/nf_conntrack_bridge.c:nf_ct_bridge_refrag() {
    ...
	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
		return NF_ACCEPT;
    ...
}

The fragments would still be forwarded, both pings would succeed, and the
"packets [1-9]" check in run_case() would still pass. The refragmentation
path this test targets would then go untested and nothing would flag it.

Also, run_case() checks this one shared counter only once, after both the
IPv4 and IPv6 pings. So the check can't tell which family was reassembled.

For the mismatch cases, the comment "The postrouting counter sees the
packets reassembled by conntrack" doesn't look accurate either.

Would one of these work instead: put the counter in prerouting, where the
tag is still hwaccel; use a threshold above any fragment size (for example
> 1500); or keep separate "meta nfproto ipv4" and "meta nfproto ipv6"
counters and check each one after its own ping?

[ ... ]

> +run_all()
> +{
> +	local rc
> +
> +	# bridge protocol, protocol of the vlan devices
> +	for case in "802.1q 802.1q" "802.1ad 802.1q" "802.1q 802.1ad" "802.1ad 802.1q clone"; do
> +		# shellcheck disable=SC2086
> +		run_case $case
> +		rc=$?
> +		if [ "$rc" -eq "$ksft_skip" ]; then
> +			return "$ksft_skip"
> +		fi
> +		[ "$rc" -ne 0 ] && ret=1
> +	done
> +
> +	return 0
> +}
> +
> +run_all
> +rc=$?
> +if [ "$rc" -eq "$ksft_skip" ] && [ "$ret" -eq 0 ]; then
> +	exit "$ksft_skip"
> +fi
> +
> +read -r t < /proc/sys/kernel/tainted
> +if [ $((t & taint_warn)) -ne 0 ]; then
> +	echo "FAIL: kernel warned"
> +	ret=1
> +fi

[Severity: Low]
Is it possible for a warning from an earlier case to get lost here?

run_all() returns ksft_skip as soon as any run_case() returns ksft_skip,
even when earlier cases have already run. The top level then exits with
ksft_skip before it reads /proc/sys/kernel/tainted.

Say an earlier case triggered a WARN but its pings still passed. ping -c 3
exits 0 if any reply arrives, so ret stays 0. If setup then fails in a
later case, for example because the 802.1ad bridge or vlan device can't
be created, the test reports SKIP and the WARN never gets reported.

The commit message says the test checks "that the kernel did not warn".
Could the taint check run before the skip decision, or could the test
fail whenever TAINT_WARN appears during the run?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261020000308.37362-1-laveeshb%40laveeshbansal.com
