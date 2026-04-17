Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EF23BA237
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2026 10:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776422353; cv=none; b=cO+ZLtMeSgNRROsZt39OkevF+Qhg8sIqIpPBLHH4XCZYPwOGA/MVKBZmTBcuWb7YRRujBw5xMAaSKcciXQvhelREL4nv/AMHMpApky0+kFyaJri7a2EpVgoh07UMcjimxCEaaDMsdviLYyvSsWJtQI+zI2V8iwCeBAzgTf6cBNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776422353; c=relaxed/simple;
	bh=R7dmQ/gr32LtrGidvVl2x1Tsue9kBQSlwMDPgZKJK6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=INehip1N6gv9XjsPjLUEGhePy22f99bCIuPxRYocEmeA8USYv3p2co26nfVgNT9KAcbTkO3lsKI5SSMujc2DviFABi3Hj2EejYSRWsmNOm/DWYcq2uVzjmQalhVwELgrnkyeTIVKeTdS9IWZFggRvrzsFx+W0DUDq6gfEQyy6FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ADF4C606C8; Fri, 17 Apr 2026 12:38:59 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add fwd to/fwd ip to test cases
Date: Fri, 17 Apr 2026 12:38:50 +0200
Message-ID: <20260417103854.4727-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tests 'fwd to <dev>' and 'fwd ip ip <addr> device <dev>' expression in
both ingress and egress hooks.

'fwd to' is raw frame forward.
'fwd ip to' uses 'neigh' layer to update mac address.

Assisted-by: Claude:claude-opus-4-5
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: I'm not found of these AI tags, I don't think they
 provide value.  Adding only because kernel asks to do it and
 I'd like to hear your thoughts on what nf userspace should do.

 If you see no value, I'll no longer add it for userspace work.

 .../testcases/packetpath/dumps/fwd.nodump     |   0
 .../testcases/packetpath/dumps/fwd_ip.nodump  |   0
 tests/shell/testcases/packetpath/fwd          | 168 ++++++++++++++++++
 tests/shell/testcases/packetpath/fwd_ip       | 156 ++++++++++++++++
 4 files changed, 324 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/fwd.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/fwd_ip.nodump
 create mode 100755 tests/shell/testcases/packetpath/fwd
 create mode 100755 tests/shell/testcases/packetpath/fwd_ip

diff --git a/tests/shell/testcases/packetpath/dumps/fwd.nodump b/tests/shell/testcases/packetpath/dumps/fwd.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/dumps/fwd_ip.nodump b/tests/shell/testcases/packetpath/dumps/fwd_ip.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/fwd b/tests/shell/testcases/packetpath/fwd
new file mode 100755
index 000000000000..2c0c1e38d4ef
--- /dev/null
+++ b/tests/shell/testcases/packetpath/fwd
@@ -0,0 +1,168 @@
+#!/bin/bash
+
+# Test case for nftables fwd expression with bridge
+# Tests that packets are forwarded to the correct device using "fwd to"
+# Setup: ns1 (sender) -> ns2 (bridge) -> ns3/ns4 (receivers)
+
+rnd=$(mktemp -u XXXXXXXX)
+ns1="nft1fwdbr-$rnd"
+ns2="nft2fwdbr-$rnd"
+ns3="nft3fwdbr-$rnd"
+ns4="nft4fwdbr-$rnd"
+
+cleanup() {
+	ip netns del "$ns1" 2>/dev/null
+	ip netns del "$ns2" 2>/dev/null
+	ip netns del "$ns3" 2>/dev/null
+	ip netns del "$ns4" 2>/dev/null
+}
+
+die() {
+	local n="$1"
+
+	ip netns exec "$n" $NFT list ruleset
+
+	echo "ns2 (router)"
+	ip netns exec "$ns2" $NFT list ruleset
+	exit 1
+}
+
+ping_and_check() {
+	ip netns exec "$ns1" ping -c 1 -W 1 10.0.1.3 >/dev/null
+	ip netns exec "$ns1" ping -c 1 -W 1 10.0.1.4 >/dev/null
+
+	# Check that packets arrived at ns3
+	ip netns exec "$ns3" $NFT "list counter netdev rxt rxc" | grep -q 'packets 2 '
+	if [ $? -ne 0 ]; then
+		echo "ERROR: counter not incremented in $ns3"
+		die "$ns3"
+	fi
+
+	ip netns exec "$ns4" $NFT "list counter netdev rxt rxc" | grep -q 'packets 0 '
+	if [ $? -ne 0 ]; then
+		echo "ERROR: counter incremented in $ns4"
+		die "$ns4"
+	fi
+}
+
+trap cleanup EXIT
+
+set -e
+
+# Create network namespaces
+for n in "$ns1" "$ns2" "$ns3" "$ns4"; do
+	ip netns add "$n"
+	ip -net "$n" link set lo up
+done
+
+# Create veth pairs:
+# ns1(veth0) <-> (veth1)ns2 bridge port
+# ns3(veth0) <-> (veth3)ns2 bridge port
+# ns4(veth0) <-> (veth4)ns2 bridge port
+ip link add veth0 netns "$ns1" type veth peer name veth1 netns "$ns2"
+ip link add veth0 netns "$ns3" type veth peer name veth3 netns "$ns2"
+ip link add veth0 netns "$ns4" type veth peer name veth4 netns "$ns2"
+
+# Create bridge in ns2
+ip -net "$ns2" link add br0 type bridge
+
+# Add veth devices to bridge in ns2
+ip -net "$ns2" link set veth1 master br0
+ip -net "$ns2" link set veth3 master br0
+ip -net "$ns2" link set veth4 master br0
+
+# Set up IP addresses
+ip -net "$ns1" addr add 10.0.1.1/24 dev veth0
+ip -net "$ns2" addr add 10.0.1.2/24 dev br0
+ip -net "$ns3" addr add 10.0.1.3/24 dev veth0
+ip -net "$ns4" addr add 10.0.1.4/24 dev veth0
+
+# Bring up interfaces
+ip -net "$ns1" link set veth0 up
+ip -net "$ns3" link set veth0 up
+ip -net "$ns4" link set veth0 up
+
+ip -net "$ns2" link set veth1 up
+ip -net "$ns2" link set veth3 up
+ip -net "$ns2" link set veth4 up
+ip -net "$ns2" link set br0 up
+
+# Validate setup:
+ip netns exec "$ns1" ping -q -c 1 10.0.1.3
+ip netns exec "$ns1" ping -q -c 1 10.0.1.4
+
+# Add nftables rule in ns2 to forward packets from veth1 to veth4
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+table netdev fwd_bridge_test {
+	chain ingress_veth1 {
+		type filter hook ingress device veth1 priority 0; policy accept;
+
+		# Forward ICMP packets destined for ns4 to veth3 (ns3) instead
+		ip daddr 10.0.1.4 ip protocol icmp counter fwd to "veth3"
+	}
+}
+EOF
+
+[ $? -ne 0 ] && exit 1
+
+# so ingress hook in ns3 picks up packet for ns4 mac
+ip -net "$ns3" link set veth0 promisc on
+
+for n in "$ns3" "$ns4"; do
+ip netns exec "$n" $NFT -f /dev/stdin <<"EOF"
+table netdev rxt {
+	counter rxc { }
+
+	chain in_veth0 {
+		type filter hook ingress device veth0 priority 0; policy accept;
+		ip protocol icmp counter name "rxc"
+	}
+}
+EOF
+done
+
+# Verify normal bridge forwarding still works for non-ICMP traffic
+# Test that ns3/ns4 are reachable from ns1 without fwd interference.
+ip netns exec "$ns1" arping -c 1 -I veth0 10.0.1.3 >/dev/null
+ip netns exec "$ns1" arping -c 1 -I veth0 10.0.1.4 >/dev/null
+
+set +e
+ping_and_check
+
+# again, but use egress hook.
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+flush ruleset
+table netdev fwd_test {
+	chain egress_veth4 {
+		type filter hook egress device veth4 priority 0; policy accept;
+		ip protocol icmp counter fwd to "veth3"
+	}
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+echo "Egress ruleset loaded"
+ip netns exec "$ns3" $NFT "reset counter netdev rxt rxc"
+ping_and_check
+
+ip netns exec "$ns3" $NFT "reset counter netdev rxt rxc"
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+flush ruleset
+table netdev fwd_test {
+	chain egress_veth4 {
+		type filter hook egress device veth4 priority 0; policy accept;
+		ip protocol icmp counter fwd to "veth4"
+	}
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+# assert this doesn't crash.
+ip netns exec "$ns1" ping -c 1 -W 1 10.0.1.4
+
+set -e
+ip netns exec "$ns2" $NFT list ruleset | grep counter
+ip netns exec "$ns3" $NFT "list counter netdev rxt rxc" | grep -q 'packets 0 '
+ip netns exec "$ns4" $NFT "list counter netdev rxt rxc" | grep -q 'packets 0 '
+
+exit 0
diff --git a/tests/shell/testcases/packetpath/fwd_ip b/tests/shell/testcases/packetpath/fwd_ip
new file mode 100755
index 000000000000..f390ad6060ce
--- /dev/null
+++ b/tests/shell/testcases/packetpath/fwd_ip
@@ -0,0 +1,156 @@
+#!/bin/bash
+
+# Test case for nftables 'fwd to ip' in ingress hook.
+# both ingress and egress hooks.
+
+# ns1 tx to n3, ns4 via ns2 (routing)
+# if ok:
+#    add rules to ns2 to fwd ip to ns3
+#    add ns4 ip to ns3
+#    send packet to ns3 and ns4 ip address
+#    check both arrived at ns3
+#    check no packet arrived at ns4
+#
+# Then repeat with ns2 having 'egress' ruleset.
+
+rnd=$(mktemp -u XXXXXXXX)
+ns1="nft1in-$rnd"	# tx
+ns2="nft2in-$rnd"	# fwd (nft rules)
+ns3="nft3in-$rnd"	# rx
+ns4="nft4in-$rnd"	# rx
+
+cleanup() {
+	ip netns del "$ns1" 2>/dev/null
+	ip netns del "$ns2" 2>/dev/null
+	ip netns del "$ns3" 2>/dev/null
+	ip netns del "$ns4" 2>/dev/null
+}
+
+die() {
+	local n="$1"
+
+	ip netns exec "$n" $NFT list ruleset
+
+	echo "ns2 (router)"
+	ip netns exec "$ns2" $NFT list ruleset
+	exit 1
+}
+
+trap cleanup EXIT
+
+ping_and_check() {
+	ip netns exec "$ns1" ping -c 1 -W 1 10.0.3.1 >/dev/null
+	ip netns exec "$ns1" ping -c 1 -W 1 10.0.4.1 >/dev/null
+
+	# Check that packets arrived at ns3
+	ip netns exec "$ns3" $NFT "list counter inet rxt rxc" | grep -q 'packets 2 '
+	if [ $? -ne 0 ]; then
+		echo "ERROR: counter not incremented in $ns3"
+		die "$ns3"
+	fi
+
+	ip netns exec "$ns4" $NFT "list counter inet rxt rxc" | grep -q 'packets 0 '
+	if [ $? -ne 0 ]; then
+		echo "ERROR: counter incremented in $ns4"
+		die "$ns4"
+	fi
+}
+
+set -e
+set -x
+
+for n in "$ns1" "$ns2" "$ns3" "$ns4"; do
+	ip netns add "$n"
+	ip -net "$n" link set lo up
+done
+
+
+# Create veth pairs: ns1(veth0) <-> (veth1)ns2
+#                    ns2(veth3) <-> (veth0)ns3
+#                    ns2(veth4) <-> (veth0)ns4
+ip link add veth0 netns "$ns1" type veth peer name veth1 netns "$ns2"
+ip link add veth3 netns "$ns2" type veth peer name veth0 netns "$ns3"
+ip link add veth4 netns "$ns2" type veth peer name veth0 netns "$ns4"
+
+# Set up addresses
+ip -net "$ns1" addr add 10.0.1.1/24 dev veth0
+
+ip -net "$ns2" addr add 10.0.1.2/24 dev veth1
+ip -net "$ns2" addr add 10.0.3.2/24 dev veth3
+ip -net "$ns2" addr add 10.0.4.2/24 dev veth4
+
+ip -net "$ns3" addr add 10.0.3.1/24 dev veth0
+ip -net "$ns4" addr add 10.0.4.1/24 dev veth0
+
+# Bring up interfaces
+ip -net "$ns1" link set veth0 up
+
+ip -net "$ns2" link set veth1 up
+ip -net "$ns2" link set veth3 up
+ip -net "$ns2" link set veth4 up
+
+ip -net "$ns3" link set veth0 up
+ip -net "$ns4" link set veth0 up
+
+ip netns exec "$ns2" sysctl -q net.ipv4.ip_forward=1
+
+ip -net "$ns1" route add default via 10.0.1.2
+
+ip -net "$ns3" route add default via 10.0.3.2 dev veth0
+ip -net "$ns4" route add default via 10.0.4.2 dev veth0
+
+# Validate setup:
+ip netns exec "$ns1" ping -q -c 1 10.0.3.1
+ip netns exec "$ns1" ping -q -c 1 10.0.4.1
+
+# Add nftables rule in ns2 to forward packets from veth1 to veth3
+# Packets arriving on veth1 (10.0.1.x) will be forwarded to veth3
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+table netdev fwd_test {
+	chain ingress_veth1 {
+		type filter hook ingress device veth1 priority 0; policy accept;
+		# Forward ICMP packets to 10.0.3.1 via neigh
+		ip protocol icmp counter fwd ip to 10.0.3.1 device "veth3"
+	}
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+for n in "$ns3" "$ns4"; do
+ip netns exec "$n" $NFT -f /dev/stdin <<"EOF"
+table inet rxt {
+	counter rxc { }
+
+	chain input {
+		type filter hook input priority 0; policy accept;
+		ip protocol icmp counter name "rxc"
+	}
+}
+EOF
+done
+
+# duplicate address so stack accepts .4.1 too
+ip -net "$ns3" addr add 10.0.4.1/32 dev veth0
+
+set +e
+ping_and_check
+
+# Add nftables rule in ns2 to forward packets from veth1 to veth3
+# Packets arriving on veth1 (10.0.1.x) will be forwarded to veth3
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+flush ruleset
+table netdev fwd_test {
+	chain egress_veth4 {
+		type filter hook egress device veth4 priority 0; policy accept;
+		# Forward ICMP packets to 10.0.3.1 via neigh
+		ip protocol icmp counter fwd ip to 10.0.3.1 device "veth3"
+	}
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+echo "Egress ruleset loaded"
+ip netns exec "$ns3" $NFT "reset counter inet rxt rxc"
+ping_and_check
+
+exit 0
-- 
2.52.0

