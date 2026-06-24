Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124FB20E023
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317564; cv=none; b=OPBMrgvMYryfc9/pBBIlfc4cueKse8fMI3LrP99P0R6yMn/xVtykDtcoBhqUzlh+zmw0OH1/VOXBP5/J5vxYFKL6EGxNeM6mvuObeyySEI99KKrvzUx8CtpZmXBeA//VAJ+3BNJPHQBn3sLq1wgcrijgtjEOkZJEYr95aE+PAbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317564; c=relaxed/simple;
	bh=nPf2ok3K1jjbveGrjKyag27RzyGZQoVMxSHaxT+S6Us=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fzcgyDezacfB60bpbrs0StVwRBSRcIt8IUtZEF2w8AAzZ0tHtpxBakJ2WkqzGO7OFxP34qYlH71yGsSEDOWKx9ZU4iP6F0fkWr4hTXeoSTIQ5Kx4NL71KGyiVpnhLeQQQ69Oa9LPWmMjrS6542bKJhioKrW0upmK+1TK2AgovTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2337560491; Wed, 24 Jun 2026 18:12:35 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add tunnel vxlan test
Date: Wed, 24 Jun 2026 18:12:23 +0200
Message-ID: <20260624161227.1167740-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

based off a script from Fernando Fernandez Mancera.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/packetpath/tunnel-vxlan | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/tunnel-vxlan

diff --git a/tests/shell/testcases/packetpath/tunnel-vxlan b/tests/shell/testcases/packetpath/tunnel-vxlan
new file mode 100755
index 000000000000..59f9516a8f28
--- /dev/null
+++ b/tests/shell/testcases/packetpath/tunnel-vxlan
@@ -0,0 +1,103 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_tcpdump)
+
+# OVERLAY (The Virtual Network)
+# =============================
+#
+# [ ns0: 10.0.0.1 ]     [ ns1: 10.0.0.2 ]     [ ns2: 10.0.0.3 ]
+#     |                      |                     |
+#    (vxlan0)             (vxlan0)            (vxlan0)
+#     |                      |                     |
+#     |~~~~~~~~~~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~|
+#     |                 nftables                   |
+#     |         (attaches the Underlay IP)         |
+#     |~~~~~~~~~~~~~~~~~~~~~~|~~~~~~~~~~~~~~~~~~~~~|
+#     |                      |                     |
+#     [ 192.168.1.1 ]   [ 192.168.1.2 ]   [ 192.168.1.3 ]
+#     |                      |                     |
+#     +------------------[ Bridge ]----------------+
+#UNDERLAY (The Physical Network)
+
+tmpfile=""
+cleanup() {
+	rm -f "$tmpfile"
+	for i in "${ns[@]}"; do
+		ip netns del "$i"
+	done
+}
+trap cleanup EXIT
+
+set -e
+set -x
+
+rnd=$(mktemp -u XXXXXXXX)
+ns=("sw-$rnd" "vxlan-ns1-$rnd" "vxlan-ns2-$rnd" "vxlan-ns3-$rnd")
+tmpfile=$(mktemp)
+
+for i in $(seq 0 3); do
+	ip netns add "${ns[$i]}"
+done
+
+ip -n "${ns[0]}" link add br0 type bridge
+ip -n "${ns[0]}" link set br0 up
+
+for i in 1 2 3; do
+	# create the link and move ends to appropriate namespaces
+	ip link add veth$i type veth peer name veth${i}_sw netns "${ns[0]}"
+	ip link set veth$i netns "${ns[$i]}"
+
+	# linux bridge (switch)
+	ip -n "${ns[0]}" link set veth${i}_sw master br0 up
+
+	# configure the node side
+	ip -n "${ns[$i]}" addr add 192.168.1.$i/24 dev veth$i
+	ip -n "${ns[$i]}" link set veth$i up
+	ip -n "${ns[$i]}" link set lo up
+
+	# create the Overlay VXLAN interface
+	ip -n "${ns[$i]}" link add vxlan0 type vxlan dstport 4789 external
+	ip -n "${ns[$i]}" addr add 10.0.0.$i/24 dev vxlan0
+	ip -n "${ns[$i]}" link set vxlan0 up
+
+	# route the ENTIRE overlay subnet into the single VXLAN device
+# ip -n "${ns[$i]}" route add 10.0.0.0/24 dev vxlan0
+done
+
+# check we cannot reach the peer via the overlay network as-is
+ip netns exec ${ns[1]} ping -c 1 10.0.0.2 && exit 1
+ip netns exec ${ns[1]} ping -c 2 10.0.0.3 && exit 1
+
+for i in 1 2 3; do
+	echo "table netdev t {" > "$tmpfile"
+
+	for j in 1 2 3 ; do
+		[ $j -eq $i ] && continue
+		echo "tunnel tun_to_ns$j { id 100; ip saddr 192.168.1.$i; ip daddr 192.168.1.$j; }" >> "$tmpfile"
+	done
+cat - >> "$tmpfile" <<EOF
+chain egress_filter {
+         type filter hook egress device "vxlan0" priority 0; policy accept;
+EOF
+	for j in 1 2 3 ; do
+		[ $j -eq $i ] && continue
+		echo ip daddr 10.0.0.$j tunnel name "tun_to_ns$j" >> "$tmpfile"
+		echo arp daddr ip 10.0.0.$j tunnel name "tun_to_ns$j" >> "$tmpfile"
+	done
+cat - >> "$tmpfile" <<EOF
+     }
+}
+EOF
+ip netns exec ${ns[$i]} $NFT -f $tmpfile
+done
+
+timeout 3 ip netns exec ${ns[0]} tcpdump --immediate-mode -nni br0 -w "$tmpfile" &
+tpid=$!
+sleep 1
+
+ip netns exec ${ns[1]} ping -c 1 10.0.0.2
+ip netns exec ${ns[1]} ping -c 2 10.0.0.3
+
+kill "$tpid"
+wait
+tcpdump -n -r "$tmpfile" | grep -q VXLAN
-- 
2.54.0

