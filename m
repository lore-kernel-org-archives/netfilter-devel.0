Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788230;
	b=bZdI9gosqX8eI8Mq7uXOiT31rGLQlVL1W9hQ6WW9yImUkONn9kfZjYPQ4KptaUc347Sq
	 CrZXy5dQayTNv6XCIFB9cEW+aQp2DemQIuqGX7lq/lHOtBXTRO48bAI3XVXaqH2/1VX3J
	 w5UBmamRMemo7GyJ0QIOD3fsFUtp8RxtdrKOPduaJcVgcFAMHuEQmHKSthLBmZtfgryGP
	 fziN4rlx3/UH+TRBKQnUv40ZB8R2IA7quJxLLjLAJN651spFmSFyaYqBy14UUWwtt9YJA
	 +ky9CgMUPks0MAY3ZF7vRMT5QFCG0tCw9V2/eHIOSwLCsxI69qgLKTDW2L/lUmoY4Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788230;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=b5pBV+amcEF0j59Jv2h+1XljXCUkURoM7iEY69fU64w=;
	b=gl+24PUnG3dNclX8uh5XpIy+pi0hS7YxRQHYfcdwG9zRt8GmK1sThDSHal372V8BM32y
	 LMEOvNOpYXUU9jccL9bs8BlNB0Woiiei00wCDgV3nH04Ab9iSydhEpIXvQ+AsltNdANHy
	 JafKHnhx5CylJC12IPwRpNyy4iG3E43x/AxGZ6L7xw3kLbE2ABUys5OSefCNOBAvgXP3S
	 DRaSswG6zLNHSioFypO/rMxawrr88VSo5RDVNPGMvHZzg8UDqdvePpBjowI7ZZl+USqi4
	 mmxx99LNVUoI3+vsBqWddwAGJ+HIPErwJPdK3JG7e/dtaaGL1WMbiqDRxeJiKFt5jTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=qvZzBxPg;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA2A606A337;
	Mon, 16 Nov 2026 00:17:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CA2A606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=qvZzBxPg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788226;
	bh=b5pBV+amcEF0j59Jv2h+1XljXCUkURoM7iEY69fU64w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvZzBxPgIGSy+1QkvvASNd1EfkG1IjPCpRMMAr9JmSuTEjVJpNJRUy8TEmnpljz65
	 4WJqoJlPPdu3AFlVLPL/UEdr/PngL8mcV/lcLw3jCpOKLkEYLVeJ2P0clQr+IyqsK6
	 jYowtFdu2NjKlnVELBGLGqk91814IV/f9w4bNVy234Fe1tKGphW7Xt3NcdneCobd5/
	 stOycq63H+lmh+VYwDeOilhNFZCsXYQuV1hILNwxNgpMs3fQv6e6FNpiORIva22dDA
	 bqSWL32GZF7UFy5Giqsc36Sj4urjjDMHZNZdUANmUjf9cECx+wr/d5SUkfg2/uCNa6
	 9jjVCA7cyDYog==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1C9D6008B;
	Mon, 16 Nov 2026 01:17:05 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 13/13] selftests: netfilter: add UDP flowtable offload test
Date: Mon, 16 Nov 2026 01:16:12 +0100
Message-ID: <20261116001612.2806263-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Peska <jpeska@redhat.com>

nft_flowtable.sh offloads only TCP, so the UDP flowtable paths never
run: the UDP tuple lookup, the UDP checksum update, IPv6 source NAT,
and nf_ct_acct_update behind the flowtable counter flag.

Add an echo test for IPv4 and IPv6, with and without masquerade. The
payload must come back intact, the forward chain must see only the
handshake, and conntrack must mark the flow OFFLOAD and account every
datagram.

Signed-off-by: Jiri Peska <jpeska@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_flowtable_udp.sh        | 238 ++++++++++++++++++
 2 files changed, 239 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index df3c20c90f5d..1bc7f7a75f1e 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -30,6 +30,7 @@ TEST_PROGS := \
 	nft_fib.sh \
 	nft_fib_nexthop.sh \
 	nft_flowtable.sh \
+	nft_flowtable_udp.sh \
 	nft_interface_stress.sh \
 	nft_meta.sh \
 	nft_nat.sh \
diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh b/tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh
new file mode 100755
index 000000000000..e0f05c76bd8e
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable_udp.sh
@@ -0,0 +1,238 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# nft_flowtable.sh offloads TCP only. These UDP paths therefore stay at
+# zero coverage in that run:
+#
+#   nf_flow_tuple_ip / nf_flow_tuple_ipv6          IPPROTO_UDP
+#   nf_flow_nat_ip_udp / nf_flow_nat_port_udp      IPv4 NAT checksum
+#   nf_flow_snat_ipv6 / nf_flow_dnat_ipv6          IPv6 NAT, including UDP
+#   flow_offload_get_timeout / flow_offload_fixup_ct for UDP
+#   nf_ct_acct_update when the flowtable counter flag is set
+#
+# Forward a burst of UDP echoes, with and without masquerade. The forward
+# hook must see only the handshake: the rest is carried by the ingress
+# flowtable, and conntrack accounting must include those packets.
+
+source lib.sh
+
+ret=0
+port=12345
+count=32
+
+checktool "nft --version" "run test without nft"
+checktool "socat -h" "run test without socat"
+
+setup_ns ns1 nsr ns2
+
+cleanup() {
+	cleanup_all_ns
+}
+trap cleanup EXIT
+
+# Disable DAD before the devices exist. A link-local still running DAD
+# delays the first IPv6 packet by about two seconds.
+for ns in "$ns1" "$ns2" "$nsr"; do
+	ip netns exec "$ns" sysctl -wq net.ipv6.conf.default.accept_dad=0
+	ip netns exec "$ns" sysctl -wq net.ipv6.conf.default.dad_transmits=0
+	ip netns exec "$ns" sysctl -wq net.ipv6.conf.all.accept_dad=0
+done
+
+ip link add veth0 netns "$nsr" type veth peer name eth0 netns "$ns1"
+ip link add veth1 netns "$nsr" type veth peer name eth0 netns "$ns2"
+
+ip -net "$nsr" link set veth0 up
+ip -net "$nsr" link set veth1 up
+ip -net "$ns1" link set eth0 up
+ip -net "$ns2" link set eth0 up
+
+ip netns exec "$nsr" sysctl -wq net.ipv4.ip_forward=1
+ip netns exec "$nsr" sysctl -wq net.ipv6.conf.all.forwarding=1
+
+ip -net "$nsr" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsr" addr add 10.0.2.1/24 dev veth1
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
+ip -net "$ns2" addr add 10.0.2.99/24 dev eth0
+
+ip -net "$nsr" addr add dead:1::1/64 dev veth0 nodad
+ip -net "$nsr" addr add dead:2::1/64 dev veth1 nodad
+ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
+ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
+
+ip -net "$ns1" route add default via 10.0.1.1
+ip -net "$ns2" route add default via 10.0.2.1
+ip -6 -net "$ns1" route add default via dead:1::1
+ip -6 -net "$ns2" route add default via dead:2::1
+
+if ! ip netns exec "$nsr" nft -f - <<EOF
+table inet filter {
+	flowtable f1 {
+		hook ingress priority 0
+		devices = { veth0, veth1 }
+		counter
+	}
+
+	counter slow {}
+
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+
+		# Installing the flow does not stop this packet. Later
+		# packets of the same flow are taken at ingress and never
+		# reach this chain, so "slow" counts only the handshake.
+		meta l4proto udp ct state established,related flow add @f1
+		meta l4proto udp counter name slow
+	}
+}
+
+table inet nat {
+	chain postrouting {
+		type nat hook postrouting priority 100; policy accept;
+	}
+}
+EOF
+then
+	echo "SKIP: Could not load nft ruleset"
+	exit "$ksft_skip"
+fi
+
+ip netns exec "$nsr" sysctl -wq net.netfilter.nf_conntrack_acct=1
+
+if ! ip netns exec "$ns1" ping -c 1 -W 2 -q 10.0.2.99 >/dev/null; then
+	echo "FAIL: IPv4 connectivity" >&2
+	exit 1
+fi
+if ! ip netns exec "$ns1" ping -6 -c 1 -W 2 -q dead:2::99 >/dev/null; then
+	echo "FAIL: IPv6 connectivity" >&2
+	exit 1
+fi
+
+listener_ready() {
+	ss -N "$ns2" -uln -H "sport = :$port" | grep -q "$port"
+}
+
+ip netns exec "$ns2" socat -T 60 \
+	UDP4-LISTEN:"$port",reuseaddr,fork EXEC:cat >/dev/null 2>&1 &
+ip netns exec "$ns2" socat -T 60 \
+	UDP6-LISTEN:"$port",reuseaddr,ipv6only=1,fork EXEC:cat >/dev/null 2>&1 &
+
+if ! busywait 3000 listener_ready; then
+	echo "FAIL: UDP listener did not start" >&2
+	exit 1
+fi
+
+udp_exchange() {
+	local fam=$1
+	local dst=$2
+	local sport=$3
+	local i msg got target
+
+	if [ "$fam" = 6 ]; then
+		target="UDP6:[${dst}]:${port},bind=[dead:1::99]:${sport}"
+	else
+		target="UDP4:${dst}:${port},bind=10.0.1.99:${sport}"
+	fi
+
+	# One socat for the whole burst. Closing it after every datagram
+	# makes socat emit an extra empty packet.
+	coproc SO { ip netns exec "$ns1" socat -T 5 - \
+		"$target,reuseaddr,shut-none" 2>/dev/null; }
+	i=0
+	while [ "$i" -lt "$count" ]; do
+		msg=$(printf '%04d' "$i")
+		printf '%s' "$msg" >&"${SO[1]}"
+		if ! IFS= read -r -n 4 -t 2 got <&"${SO[0]}"; then
+			echo "FAIL: packet $i timeout" >&2
+			kill "$SO_PID" 2>/dev/null || true
+			wait "$SO_PID" 2>/dev/null || true
+			return 1
+		fi
+		if [ "$got" != "$msg" ]; then
+			echo "FAIL: packet $i mismatch" >&2
+			kill "$SO_PID" 2>/dev/null || true
+			wait "$SO_PID" 2>/dev/null || true
+			return 1
+		fi
+		i=$((i + 1))
+	done
+	kill "$SO_PID" 2>/dev/null || true
+	wait "$SO_PID" 2>/dev/null || true
+}
+
+ct_line() {
+	local sport=$1
+
+	ip netns exec "$nsr" cat /proc/net/nf_conntrack \
+		| grep -F "sport=${sport} dport=${port}" | head -n 1
+}
+
+slow_packets() {
+	ip netns exec "$nsr" nft list counter inet filter slow \
+		| sed -n 's/.*packets \([0-9][0-9]*\).*/\1/p' | head -n 1
+}
+
+run_case() {
+	local what=$1
+	local fam=$2
+	local dst=$3
+	local sport=$4
+	local line orig repl slow
+
+	ip netns exec "$nsr" nft reset counter inet filter slow >/dev/null
+
+	if ! udp_exchange "$fam" "$dst" "$sport"; then
+		echo "FAIL: $what: payload was not forwarded" >&2
+		ret=1
+		return
+	fi
+
+	slow=$(slow_packets)
+	line=$(ct_line "$sport")
+
+	if ! printf '%s\n' "$line" | grep -Fq '[OFFLOAD]'; then
+		echo "FAIL: $what: conntrack entry is not offloaded" >&2
+		printf '%s\n' "$line" >&2
+		echo "forward counter packets=${slow:-none}" >&2
+		ret=1
+		return
+	fi
+
+	# Forward hook sees the handshake only. A full burst means the
+	# ingress flowtable did not take over.
+	if [ "${slow:-999}" -gt 8 ]; then
+		echo "FAIL: $what: forward hook saw ${slow} UDP packets" >&2
+		printf '%s\n' "$line" >&2
+		ret=1
+		return
+	fi
+
+	orig=$(printf '%s\n' "$line" | grep -o 'packets=[0-9]*' | head -n 1)
+	repl=$(printf '%s\n' "$line" | grep -o 'packets=[0-9]*' | sed -n '2p')
+	orig=${orig#packets=}
+	repl=${repl#packets=}
+
+	# nf_ct_acct_update is what the flowtable counter flag does. Without
+	# it, only the handshake is accounted.
+	if [ "${orig:-0}" -lt "$count" ] || [ "${repl:-0}" -lt "$count" ]; then
+		echo "FAIL: $what: got ${orig:-0}/${repl:-0}, need $count" >&2
+		printf '%s\n' "$line" >&2
+		ret=1
+		return
+	fi
+
+	echo "PASS: $what (forward=${slow}, orig=${orig}, reply=${repl})"
+}
+
+run_case "IPv4 UDP" 4 10.0.2.99 5401
+run_case "IPv6 UDP" 6 dead:2::99 5402
+
+if ! ip netns exec "$nsr" nft add rule inet nat postrouting \
+		oifname "veth1" masquerade; then
+	echo "FAIL: could not add masquerade rule" >&2
+	exit 1
+fi
+
+run_case "IPv4 UDP masquerade" 4 10.0.2.99 5403
+run_case "IPv6 UDP masquerade" 6 dead:2::99 5404
+
+exit $ret
-- 
2.47.3

