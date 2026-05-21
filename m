Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D8C332EA2
	for <netfilter-devel@vger.kernel.org>; Thu, 21 May 2026 08:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779351549; cv=none; b=KrEkSnQEDjQ3mSHHl7p4MyCSHgY14Kh8erSEZv3r1GaRlfaFTwZybCCrp6lr7XTSXfLEbjTYeUy0KrKegCzLxniYVqYS/6x0WeS+qL2gVN1d1dCEvTmJozSncAgOqBVG0d2uzhlkBcn03qwwY4RrMAjONcckbMPfITphIu8hJ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779351549; c=relaxed/simple;
	bh=llkvuhlfLJ6+Q3x0kl2CS3LaiV+TlnTW9fXls7Uq4Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hJYKTSx21zRi+cDGAmis2s0VuAkpcGSS/3RagTlBAvTkSWptKrkS7H6EnR9re6f4WE9vOCqgpYWp7JfyrfupkzNUCK4g+uWW5ddzJBuXO9Jibdi975uNDN6WihIBzd0grHTQBdiFUjYOXASRqU3OjW+lUzD9SjTBC7dtiCxW4ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1C5C160293; Thu, 21 May 2026 10:19:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add stateless nat test case
Date: Thu, 21 May 2026 10:18:43 +0200
Message-ID: <20260521081847.123717-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../packetpath/dumps/stateless_nat.nodump     |   0
 .../shell/testcases/packetpath/stateless_nat  | 206 ++++++++++++++++++
 2 files changed, 206 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/stateless_nat.nodump
 create mode 100755 tests/shell/testcases/packetpath/stateless_nat

diff --git a/tests/shell/testcases/packetpath/dumps/stateless_nat.nodump b/tests/shell/testcases/packetpath/dumps/stateless_nat.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/stateless_nat b/tests/shell/testcases/packetpath/stateless_nat
new file mode 100755
index 000000000000..949c564c7a3d
--- /dev/null
+++ b/tests/shell/testcases/packetpath/stateless_nat
@@ -0,0 +1,206 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_chain_binding)
+
+
+# Stateless NAT test: router rewrites client->server2 traffic to server1
+# and server1->client replies to appear as coming from server2.
+# Uses type filter chains (no conntrack). Tests ipv4/ipv6 x tcp/udp.
+#
+# Topology:
+#   ns_client <--(veth_cr/veth_rc)--> ns_router <--(veth_rs1/veth_s1r)--> ns_server1
+#                                                <--(veth_rs2/veth_s2r)--> ns_server2
+
+. $NFT_TEST_LIBRARY_FILE
+
+PORT=20123
+
+rnd=$(mktemp -u XXXXXXXX)
+ns_client="slnat-c-$rnd"
+ns_router="slnat-r-$rnd"
+ns_server1="slnat-s1-$rnd"
+ns_server2="slnat-s2-$rnd"
+
+server_pids=""
+
+cleanup()
+{
+	[ -n "$server_pids" ] && kill $server_pids 2>/dev/null
+	ip netns del "$ns_client" 2>/dev/null
+	ip netns del "$ns_router" 2>/dev/null
+	ip netns del "$ns_server1" 2>/dev/null
+	ip netns del "$ns_server2" 2>/dev/null
+}
+trap cleanup EXIT
+
+assert_failout()
+{
+	ip netns exec "$ns_router" $NFT list ruleset
+}
+
+# IPv4 addresses
+c_ip4=10.0.1.2
+r_c_ip4=10.0.1.1
+r_s1_ip4=10.0.2.1
+r_s2_ip4=10.0.3.1
+s1_ip4=10.0.2.2
+s2_ip4=10.0.3.2
+
+# IPv6 addresses
+c_ip6=fd00:1::2
+r_c_ip6=fd00:1::1
+r_s1_ip6=fd00:2::1
+r_s2_ip6=fd00:3::1
+s1_ip6=fd00:2::2
+s2_ip6=fd00:3::2
+
+for ns in "$ns_client" "$ns_router" "$ns_server1" "$ns_server2"; do
+	ip netns add "$ns"
+	ip -net "$ns" link set lo up
+done
+
+ip netns exec "$ns_router" sysctl -wq net.ipv4.conf.all.forwarding=1
+ip netns exec "$ns_router" sysctl -wq net.ipv6.conf.all.forwarding=1
+
+ip link add veth_cr  netns "$ns_client"  type veth peer name veth_rc  netns "$ns_router"
+ip link add veth_s1r netns "$ns_server1" type veth peer name veth_rs1 netns "$ns_router"
+ip link add veth_s2r netns "$ns_server2" type veth peer name veth_rs2 netns "$ns_router"
+
+# Client
+ip -net "$ns_client" link set veth_cr up
+ip -net "$ns_client" addr add $c_ip4/24 dev veth_cr
+ip -net "$ns_client" addr add $c_ip6/64 dev veth_cr nodad
+ip -net "$ns_client" route add default via $r_c_ip4 dev veth_cr
+ip -net "$ns_client" -6 route add default via $r_c_ip6 dev veth_cr
+
+# Router client-facing
+ip -net "$ns_router" link set veth_rc up
+ip -net "$ns_router" addr add $r_c_ip4/24 dev veth_rc
+ip -net "$ns_router" addr add $r_c_ip6/64 dev veth_rc nodad
+
+# Router server1-facing
+ip -net "$ns_router" link set veth_rs1 up
+ip -net "$ns_router" addr add $r_s1_ip4/24 dev veth_rs1
+ip -net "$ns_router" addr add $r_s1_ip6/64 dev veth_rs1 nodad
+
+# Router server2-facing
+ip -net "$ns_router" link set veth_rs2 up
+ip -net "$ns_router" addr add $r_s2_ip4/24 dev veth_rs2
+ip -net "$ns_router" addr add $r_s2_ip6/64 dev veth_rs2 nodad
+
+# Server1
+ip -net "$ns_server1" link set veth_s1r up
+ip -net "$ns_server1" addr add $s1_ip4/24 dev veth_s1r
+ip -net "$ns_server1" addr add $s1_ip6/64 dev veth_s1r nodad
+ip -net "$ns_server1" route add default via $r_s1_ip4 dev veth_s1r
+ip -net "$ns_server1" -6 route add default via $r_s1_ip6 dev veth_s1r
+
+# Server2
+ip -net "$ns_server2" link set veth_s2r up
+ip -net "$ns_server2" addr add $s2_ip4/24 dev veth_s2r
+ip -net "$ns_server2" addr add $s2_ip6/64 dev veth_s2r nodad
+ip -net "$ns_server2" route add default via $r_s2_ip4 dev veth_s2r
+ip -net "$ns_server2" -6 route add default via $r_s2_ip6 dev veth_s2r
+
+ip netns exec "$ns_client" ping -q -c 1 -W 2 $s1_ip4 > /dev/null
+assert_pass "ipv4 topology: client can reach server1"
+ip netns exec "$ns_client" ping -q -c 1 -W 2 $s2_ip4 > /dev/null
+assert_pass "ipv4 topology: client can reach server2"
+ip netns exec "$ns_client" ping -q -c 2 -W 2 -6 $s1_ip6 > /dev/null
+assert_pass "ipv6 topology: client can reach server1"
+ip netns exec "$ns_client" ping -q -c 2 -W 2 -6 $s2_ip6 > /dev/null
+assert_pass "ipv6 topology: client can reach server2"
+
+# Start socat servers (IPv4 and IPv6, TCP and UDP)
+ip netns exec "$ns_server1" socat -6 TCP6-LISTEN:$PORT,fork,reuseaddr,ipv6only=1 SYSTEM:"echo server 1" &
+server_pids="$server_pids $!"
+ip netns exec "$ns_server1" socat -4 TCP4-LISTEN:$PORT,fork,reuseaddr SYSTEM:"echo server 1" &
+server_pids="$server_pids $!"
+ip netns exec "$ns_server1" socat UDP4-LISTEN:$PORT,fork SYSTEM:"echo server 1" &
+server_pids="$server_pids $!"
+ip netns exec "$ns_server1" socat UDP6-LISTEN:$PORT,fork,ipv6only=1 SYSTEM:"echo server 1" &
+server_pids="$server_pids $!"
+
+ip netns exec "$ns_server2" socat TCP6-LISTEN:$PORT,fork,reuseaddr,ipv6only=1 SYSTEM:"echo server 2" &
+server_pids="$server_pids $!"
+ip netns exec "$ns_server2" socat TCP4-LISTEN:$PORT,fork,reuseaddr SYSTEM:"echo server 2" &
+server_pids="$server_pids $!"
+ip netns exec "$ns_server2" socat UDP4-LISTEN:$PORT,fork SYSTEM:"echo server 2" &
+server_pids="$server_pids $!"
+ip netns exec "$ns_server2" socat UDP6-LISTEN:$PORT,fork,ipv6only=1 SYSTEM:"echo server 2" &
+server_pids="$server_pids $!"
+
+wait_local_port_listen "$ns_server1" $PORT tcp
+wait_local_port_listen "$ns_server2" $PORT tcp
+wait_local_port_listen "$ns_server1" $PORT udp
+wait_local_port_listen "$ns_server2" $PORT udp
+
+# check_server_response <socat-proto> <addr> <expected> <description>
+# socat-proto: TCP4, TCP6, UDP4, UDP6
+check_server_response()
+{
+	local proto="$1"
+	local addr="$2"
+	local expected="$3"
+	local desc="$4"
+	local socat_addr result
+
+	if echo "$addr" | grep -q ":"; then
+		socat_addr="${proto}:[${addr}]:${PORT}"
+	else
+		socat_addr="${proto}:${addr}:${PORT}"
+	fi
+
+	if echo "$proto" | grep -qi "UDP"; then
+		result=$(echo "client 1" | ip netns exec "$ns_client" \
+			timeout 5 socat -t 2 - "${socat_addr}")
+	else
+		result=$(echo "client 1" | ip netns exec "$ns_client" \
+			timeout 10 socat - "${socat_addr}")
+	fi
+
+	if echo "$result" | grep -q "$expected"; then
+		echo "PASS: $desc"
+	else
+		echo "FAIL: $desc (got '$(echo "$result" | tr -d '\n')', expected '$expected')"
+		exit 1
+	fi
+}
+
+echo "=== Phase 1: no NAT, client contacts server2 and gets server2 response ==="
+check_server_response TCP4 $s2_ip4 "server 2" "ipv4 tcp no-nat: client gets server 2"
+check_server_response UDP4 $s2_ip4 "server 2" "ipv4 udp no-nat: client gets server 2"
+check_server_response TCP6 $s2_ip6 "server 2" "ipv6 tcp no-nat: client gets server 2"
+check_server_response UDP6 $s2_ip6 "server 2" "ipv6 udp no-nat: client gets server 2"
+
+echo "=== Phase 2: load stateless NAT ruleset on router ==="
+ip netns exec "$ns_router" $NFT -f - <<EOF
+table ip stateless_nat_test {
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+		meta l4proto { tcp, udp } jump {
+			meta iifname "veth_rc"  ip daddr set $s1_ip4
+			meta iifname "veth_rs1" ip saddr set $s2_ip4
+		}
+	}
+}
+table ip6 stateless_nat_test {
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+		meta l4proto { tcp, udp } jump {
+			meta iifname "veth_rc"  ip6 daddr set $s1_ip6
+			meta iifname "veth_rs1" ip6 saddr set $s2_ip6
+		}
+	}
+}
+EOF
+assert_pass "load stateless NAT ruleset"
+
+echo "=== Phase 3: with NAT, client contacts server2 but server1 responds ==="
+check_server_response TCP4 $s2_ip4 "server 1" "ipv4 tcp nat: client gets server 1 via server2 addr"
+check_server_response UDP4 $s2_ip4 "server 1" "ipv4 udp nat: client gets server 1 via server2 addr"
+check_server_response TCP6 $s2_ip6 "server 1" "ipv6 tcp nat: client gets server 1 via server2 addr"
+check_server_response UDP6 $s2_ip6 "server 1" "ipv6 udp nat: client gets server 1 via server2 addr"
+
+exit 0
-- 
2.54.0

