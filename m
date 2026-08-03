Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CC03815DF
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Aug 2026 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785775442; cv=none; b=BHB7AOf51DQx8zzEHKvpMbEmyAiscYfXNf2MTVxqBeN9rFHh6T64iZAPSVYlaqXN0x61J6lJFZlh8rBt2ow2FpgTxORp2UOg/nTXhSMsQ+D1JFSpaqvRAj+Nx2cZVHyXTx1eBOkPFD2LWbrUN6im5aSozyNMe3530mJyHgIWKFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785775442; c=relaxed/simple;
	bh=s/JTLMAMhS5Ny0LX7XldRMcMRoySjpMAuOc372msQmU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bkcu3MdsTxVjXi9QAskCxnyXbXqZkAMd+CT+HEnccbck9pjkK5oDr+gkQF/JLDBkAj0ckTwaF0q5VBTNyWDuJCERESposmyCj53uJxOz0v4L64G5WcgMd2JrfVqYz2PUVN0q1grLvnINUWh3ax4+hsPs7XalPhfHln2CihdhInI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 31B686059E; Mon, 03 Aug 2026 18:43:58 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add packetpath test for nft ct expectation support
Date: Mon,  3 Aug 2026 18:43:45 +0200
Message-ID: <20260803164351.5377-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will fail on kernels that lack
6fb421bd07f1 ("netfilter: nft_ct: expectation timeouts are passed in milliseconds").

On kernels that lack NAT support the test will indicate SKIP.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/packetpath/ct_expect    | 261 ++++++++++++++++++
 .../packetpath/dumps/ct_expect.nodump         |   0
 2 files changed, 261 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/ct_expect
 create mode 100644 tests/shell/testcases/packetpath/dumps/ct_expect.nodump

diff --git a/tests/shell/testcases/packetpath/ct_expect b/tests/shell/testcases/packetpath/ct_expect
new file mode 100755
index 000000000000..d9824ca3cdaf
--- /dev/null
+++ b/tests/shell/testcases/packetpath/ct_expect
@@ -0,0 +1,261 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+
+. $NFT_TEST_LIBRARY_FILE
+
+set -x
+
+rc=1
+
+cleanup()
+{
+	for i in $R $C $S;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+
+	exit $rc
+}
+trap cleanup EXIT
+
+dump_expect_table() {
+	ip netns exec "$R" conntrack --family ipv6 -L expect
+	ip netns exec "$R" conntrack --family ipv4 -L expect
+}
+
+assert_failout()
+{
+	ip netns exec $R $NFT list ruleset
+	ip netns exec $R conntrack -L
+	dump_expect_table
+}
+
+do_connect() {
+	local ns="$1"
+	local addr="$2"
+	local port="$3"
+
+	ip netns exec "$ns" socat -u STDIN TCP-CONNECT:$addr:$port,connect-timeout=1 < /dev/null
+}
+
+connect_fail() {
+	local ns="$1"
+	local addr="$2"
+	local port="$3"
+	local msg="$4"
+
+	do_connect "$ns" "$addr" "$port"
+	assert_fail "connect from $ns to $addr:$port $msg"
+}
+
+connect_ok() {
+	local ns="$1"
+	local addr="$2"
+	local port="$3"
+	local msg="$4"
+
+	do_connect "$ns" "$addr" "$port"
+	assert_pass "connect from $ns to $addr:$port $msg"
+}
+
+test_expect() {
+	local ip_cr="$1"
+	local ip_sr="$2"
+	local msg="$3"
+
+	echo check port is closed from outside.
+	connect_fail "$S" "$ip_cr" 1234
+
+	echo "Test: expectation via ruleset$msg"
+
+	echo control port should be open.
+	connect_ok "$C" "$ip_sr" 2222 "$msg"
+
+	dump_expect_table
+
+	echo expected port. Should now pass.
+	connect_ok "$S" "$ip_cr" 1234 "$msg"
+
+	echo one expectation max, expect fail.
+	connect_fail "$S" "$ip_cr" 1234 "$msg"
+}
+
+test_timeout() {
+	echo "Test: expectation auto-timeout"
+	# control port - this should be open.
+	connect_ok "$C" "$ip4_sr" 2222
+	connect_ok "$C" "[$ip6_sr]" 2222
+
+	dump_expect_table
+
+	# timeout. We 'bundle' ipv4 and ipv6 test here.
+	sleep 6
+
+	dump_expect_table
+
+	echo "expect failures"
+	connect_fail "$S" "$ip4_cr" 1234
+	connect_fail "$S" "[$ip6_cr]" 1234
+}
+
+rnd=$(mktemp -u XXXXXXXX)
+R="ns-router-$rnd"
+C="ns-client-$rnd"
+S="ns-server-$rnd"
+
+ip6_sr=dead:d8:ff:22::1
+ip6_cr=dead:d8:ff:21::2
+ip6_rs=dead:d8:ff:22::fffe
+ip6_rc=dead:d8:ff:21::fffe
+
+ip4_sr=10.1.22.1
+ip4_cr=10.1.21.2
+ip4_rs=10.1.22.99
+ip4_rc=10.1.21.99
+
+set -e
+ip netns add $R
+ip netns add $S
+ip netns add $C
+ip -net $S link set lo up
+ip -net $R link set lo up
+ip -net $C link set lo up
+ip netns exec $R sysctl -wq net.ipv4.ip_forward=1
+ip netns exec $R sysctl -wq net.ipv6.conf.all.forwarding=1
+
+ip link add s_r netns $S type veth peer name r_s netns $R
+ip link add c_r netns $C type veth peer name r_c netns $R
+ip -net $S link set s_r up
+ip -net $R link set r_s up
+ip -net $R link set r_c up
+ip -net $C link set c_r up
+
+ip -net $S addr add ${ip6_sr}/64 dev s_r nodad
+ip -net $C addr add ${ip6_cr}/64 dev c_r nodad
+ip -net $R addr add ${ip6_rs}/64 dev r_s nodad
+ip -net $R addr add ${ip6_rc}/64 dev r_c nodad
+ip -net $C route add ${ip6_rs}/64 via ${ip6_rc} dev c_r
+ip -net $S route add ${ip6_rc}/64 via ${ip6_rs} dev s_r
+assert_pass "topo initialization"
+
+ip -net $S addr add ${ip4_sr}/24 dev s_r
+ip -net $C addr add ${ip4_cr}/24 dev c_r
+ip -net $R addr add ${ip4_rs}/24 dev r_s
+ip -net $R addr add ${ip4_rc}/24 dev r_c
+
+ip -net $C route add 10.1.22.0/24 via ${ip4_rc} dev c_r
+ip -net $S route add 10.1.21.0/24 via ${ip4_rs} dev s_r
+
+ip netns exec "$C" ping -q -c 1 "$ip4_sr"
+ip netns exec "$C" ping -q -c 1 "$ip6_sr"
+
+timeout 20 ip netns exec "$S" socat TCP6-LISTEN:2222,ipv6only=1,fork,reuseaddr PIPE &
+timeout 20 ip netns exec "$S" socat TCP4-LISTEN:2222,fork,reuseaddr PIPE &
+timeout 20 ip netns exec "$C" socat TCP6-LISTEN:1234,ipv6only=1,fork,reuseaddr PIPE &
+timeout 20 ip netns exec "$C" socat TCP4-LISTEN:1234,fork,reuseaddr PIPE &
+wait_local_port_listen $S 2222 tcp
+wait_local_port_listen $C 1234 tcp
+
+ip netns exec $R $NFT -f - <<-EOF
+flush ruleset
+table inet t {
+	ct expectation ctexpect4 {
+		protocol tcp
+		dport 1234
+		timeout 5s
+		size 1
+		l3proto ip
+	}
+
+	ct expectation ctexpect6 {
+		protocol tcp
+		dport 1234
+		timeout 5s
+		size 1
+		l3proto ip6
+	}
+
+	chain c {
+		type filter hook forward priority filter; policy drop;
+		ct state established accept
+		meta l4proto tcp ct state related counter accept
+		meta iifname r_c ct state new jump {
+			tcp dport 2222 counter ct expectation set meta nfproto map { ipv4 : ctexpect4, ipv6 : ctexpect6 } counter accept
+			counter accept
+		}
+		meta l4proto tcp counter reject with tcp reset
+		meta l4proto { icmp, icmpv6 } accept
+	}
+}
+EOF
+
+ip netns exec "$C" ping -q -c 1 "$ip4_sr"
+ip netns exec "$C" ping -q -c 1 "$ip6_sr"
+
+set +e
+echo check port is closed from outside.
+connect_fail "$S" "$ip4_cr" 1234
+connect_fail "$S" "[$ip6_cr]" 1234
+
+test_expect "$ip4_cr" "$ip4_sr"	""
+test_expect "[$ip6_cr]" "[$ip6_sr]" ""
+
+ip netns exec $R conntrack -F
+test_timeout
+
+set -e
+ip netns exec $R $NFT -f - <<-EOF
+flush ruleset
+table inet t {
+	ct expectation ctexpect4 {
+		protocol tcp
+		dport 1234
+		timeout 5s
+		size 1
+		l3proto ip
+	}
+
+	ct expectation ctexpect6 {
+		protocol tcp
+		dport 1234
+		timeout 5s
+		size 1
+		l3proto ip6
+	}
+	chain c {
+		type filter hook forward priority filter; policy drop;
+		ct state established accept
+		meta l4proto tcp ct state related counter accept
+		meta iifname r_c ct state new accept
+		meta l4proto tcp counter reject with tcp reset
+		meta l4proto { icmp, icmpv6 } accept
+	}
+
+	chain masq {
+		type nat hook postrouting priority srcnat; policy accept;
+		meta oifname "r_s" counter masquerade
+	}
+
+	chain e {
+		type filter hook postrouting priority 50000 ; policy accept;
+		meta iifname r_c ct state new jump {
+			tcp dport 2222 counter ct expectation set meta nfproto map { ipv4 : ctexpect4, ipv6 : ctexpect6 } counter accept
+			counter accept
+		}
+	}
+}
+EOF
+
+ip netns exec $R conntrack -F
+echo "Test: conntrack expectation with masquerade"
+set +e
+
+# Skip here, this is a kernel bug / missing feature we can't
+# test for.
+rc=77
+test_expect "$ip4_rs" "$ip4_sr" " with masquerade"
+test_expect "[$ip6_rs]" "[$ip6_sr]" " with masquerade"
+
+ip netns exec "$R" conntrack -L
+rc=0
diff --git a/tests/shell/testcases/packetpath/dumps/ct_expect.nodump b/tests/shell/testcases/packetpath/dumps/ct_expect.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.54.0

