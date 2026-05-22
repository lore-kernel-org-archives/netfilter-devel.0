Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D043A6B92;
	Fri, 22 May 2026 10:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446625; cv=none; b=ilUeNDLqTZFg7e5iWAeb3pvpPSitd266NxOyqdidFYGFsPXGwn3ufAfygRJUW8ncS8Pjoc8XqzKZuwzNQk6bU8X3syFHUfSi82cA02VKpmTEz3NzMqThGnCq3lAbTGaQEjwq/22uk/M1JbdmTs6sCc4YLi0A76Fi8falR9Wls3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446625; c=relaxed/simple;
	bh=qoJvHscpD3RO09YnHHO0l1cpqgPuJIZZ1GH8ae6YT90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/301rF0s0zALrS/cTg+1St7q0HQIpHWDXMjJqOUHumwP/e/AAW3oqxFm9okIvfVE8vlgplYAdhqG4kUl0aRms3MzTiZcgtnJTMMx/9/nlclqAO7g43U45cDjkRTrmGFd1bCzT35Dnl2Y17WRvNKjSqBCl+lE31lmivZ2qPhadc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4237B60634; Fri, 22 May 2026 12:43:42 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 09/10] selftests: netfilter: add nft_fib_nexthop test
Date: Fri, 22 May 2026 12:42:56 +0200
Message-ID: <20260522104257.2008-10-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522104257.2008-1-fw@strlen.de>
References: <20260522104257.2008-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

Functional coverage of nft_fib6_eval()'s nexthop enumeration over
three route shapes:

  1) single external nexthop (nhid)
  2) external nexthop group (nhid -> group)
  3) old-style multipath (nexthop ... nexthop ...)

Each scenario places one nexthop on the input device (veth0). For
(2) and (3) the matching nexthop is the second member, so the walk
has to traverse beyond the primary nh. Two nft counters on prerouting
verify the data path: one increments only when fib reports veth0 as
the oif, the other counts "missing" results and must stay at zero.

  ./nft_fib_nexthop.sh
  PASS: single external nexthop (nhid -> veth0)
  PASS: nexthop group (dummy0 + veth0)
  PASS: old-style multipath (sibling on veth0)

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_fib_nexthop.sh          | 152 ++++++++++++++++++
 2 files changed, 153 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_fib_nexthop.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index ee2d1a5254f8..d953ee218c0f 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -26,6 +26,7 @@ TEST_PROGS := \
 	nft_concat_range.sh \
 	nft_conntrack_helper.sh \
 	nft_fib.sh \
+	nft_fib_nexthop.sh \
 	nft_flowtable.sh \
 	nft_interface_stress.sh \
 	nft_meta.sh \
diff --git a/tools/testing/selftests/net/netfilter/nft_fib_nexthop.sh b/tools/testing/selftests/net/netfilter/nft_fib_nexthop.sh
new file mode 100755
index 000000000000..c4f203057382
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_fib_nexthop.sh
@@ -0,0 +1,152 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# shellcheck disable=SC2154
+#
+# Exercise nft_fib6_eval()'s sibling/nh enumeration on three route shapes:
+#   1) route via a single external nexthop (nhid)
+#   2) route via an external nexthop group (nhid -> group, two members)
+#   3) route via old-style multipath (nexthop ... nexthop ...)
+#
+# In each scenario the route's nexthop set contains veth0 (the iif of the
+# test packet). nft_fib6_info_nh_uses_dev() must walk the set and report
+# veth0 as a valid oif. For (2) and (3) the matching nexthop is the second
+# member, so the walk has to traverse beyond the primary nh.
+#
+# After sending $PKTS ICMPv6 echo requests from ns1, check two counters on
+# nsrouter:
+#   nf_ok  -- `fib daddr . iif oif eq "veth0"`  must equal $PKTS
+#   nf_bad -- `fib daddr . iif oif missing`     must stay at 0
+# Both rules also match on iif veth0 and ip6 daddr dead:dead::/64 so that
+# kernel-generated ND/MLD/RA traffic cannot pollute the counters.
+#
+# Topology similar to nft_fib.sh, without ns2; two dummy interfaces on
+# nsrouter host extra nh devices:
+#
+#   dead:1::99             dead:1::1
+#       ns1 <----veth----> nsrouter --- dummy0 dead:2::1
+#                                   \-- dummy1 dead:9::1
+
+source lib.sh
+
+ret=0
+PKTS=3
+
+checktool "nft --version" "run test without nft"
+checktool "ip -V"         "run test without iproute2"
+
+setup_ns nsrouter ns1
+trap cleanup_all_ns EXIT
+
+if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" \
+	> /dev/null 2>&1; then
+	echo "SKIP: No virtual ethernet pair device support in kernel"
+	exit $ksft_skip
+fi
+
+ip -net "$ns1" link set lo up
+ip -net "$ns1" link set eth0 up
+ip -net "$ns1" -6 addr add dead:1::99/64 dev eth0 nodad
+ip -net "$ns1" -6 route add default via dead:1::1
+
+ip -net "$nsrouter" link set lo up
+ip -net "$nsrouter" link set veth0 up
+ip -net "$nsrouter" -6 addr add dead:1::1/64 dev veth0 nodad
+
+if ! ip -net "$nsrouter" link add dummy0 type dummy 2>/dev/null; then
+	echo "SKIP: dummy netdev not available"
+	exit $ksft_skip
+fi
+ip -net "$nsrouter" link set dummy0 up
+ip -net "$nsrouter" -6 addr add dead:2::1/64 dev dummy0 nodad
+
+ip -net "$nsrouter" link add dummy1 type dummy
+ip -net "$nsrouter" link set dummy1 up
+ip -net "$nsrouter" -6 addr add dead:9::1/64 dev dummy1 nodad
+
+ip netns exec "$nsrouter" sysctl -q net.ipv6.conf.all.forwarding=1
+
+load_fib_rule() {
+	# filter on iif + daddr so the counters only see our test packets
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table ip6 t {
+	counter nf_ok  { }
+	counter nf_bad { }
+	chain c {
+		type filter hook prerouting priority 0; policy accept;
+		iif "veth0" ip6 daddr dead:dead::/64 fib daddr . iif oif eq "veth0" counter name nf_ok
+		iif "veth0" ip6 daddr dead:dead::/64 fib daddr . iif oif missing    counter name nf_bad
+	}
+}
+EOF
+}
+
+bad_counter() {
+	local counter=$1
+	local expect=$2
+	local tag=$3
+
+	echo "FAIL ($tag): counter $counter has unexpected value (expected \"$expect\")" 1>&2
+	ip netns exec "$nsrouter" nft list counter ip6 t "$counter" 1>&2
+}
+
+run_scenario() {
+	local what="$1"; shift
+	# counter output format is "packets PACKET_NUM bytes BYTES_NUM";
+	# we only care about the packet count
+	local expect_ok="packets $PKTS bytes"
+	local expect_bad="packets 0 bytes"
+	local lret=0
+
+	# reset route + nexthop state between scenarios
+	ip -net "$nsrouter" -6 route del dead:dead::/64 > /dev/null 2>&1 || true
+	ip -net "$nsrouter" nexthop flush               > /dev/null 2>&1 || true
+
+	# run the scenario function passed by the caller
+	"$@" || echo "WARN ($what): scenario setup returned non-zero"
+
+	load_fib_rule || { echo "FAIL ($what): nft load"; ret=1; return; }
+
+	# ping a daddr inside dead:dead::/64 so fib has to walk the nh set
+	ip netns exec "$ns1" ping -6 -c "$PKTS" -i 0.1 -W 1 dead:dead::1 \
+		> /dev/null 2>&1 || true
+
+	# verify the packets went through the expected fib path
+	if ! ip netns exec "$nsrouter" nft list counter ip6 t nf_ok | grep -q "$expect_ok"; then
+		bad_counter nf_ok "$expect_ok" "$what"
+		lret=1
+	fi
+	if ! ip netns exec "$nsrouter" nft list counter ip6 t nf_bad | grep -q "$expect_bad"; then
+		bad_counter nf_bad "$expect_bad" "$what"
+		lret=1
+	fi
+
+	if [ $lret -eq 0 ]; then
+		echo "PASS: $what"
+	else
+		ret=1
+	fi
+}
+
+scenario_single_nh() {
+	ip -net "$nsrouter" nexthop add id 1 via dead:1::99 dev veth0
+	ip -net "$nsrouter" -6 route add dead:dead::/64 nhid 1
+}
+run_scenario "single external nexthop (nhid -> veth0)" scenario_single_nh
+
+scenario_nh_group() {
+	ip -net "$nsrouter" nexthop add id 1   via dead:2::2  dev dummy0
+	ip -net "$nsrouter" nexthop add id 2   via dead:1::99 dev veth0
+	ip -net "$nsrouter" nexthop add id 100 group 1/2
+	ip -net "$nsrouter" -6 route   add dead:dead::/64 nhid 100
+}
+run_scenario "nexthop group (dummy0 + veth0)" scenario_nh_group
+
+scenario_old_multipath() {
+	ip -net "$nsrouter" -6 route add dead:dead::/64 \
+		nexthop via dead:2::2  dev dummy0 \
+		nexthop via dead:1::99 dev veth0
+}
+run_scenario "old-style multipath (sibling on veth0)" scenario_old_multipath
+
+exit $ret
-- 
2.53.0

