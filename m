Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC68A2EC571
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jun 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781189428; cv=none; b=k97YWC7CIJyWHXXDFJE5NjqED8dKU2uTiR9SwGLCJr9NoKganK1uZjtCBChlbzILGYDFHQ59fHgpVPrsI3qYcg6eHtjyLfox001ocHIPJaOxFI2jnCFTo7U/k2m8B8ZLkmiR/bKBmOvoD7j0PA6Yd2x7/ebah0z9kMk88M9S8BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781189428; c=relaxed/simple;
	bh=AO97Btc7cHViCwcAAHYxKZ4+PbStnEUSqsLdGrLy5KE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=W/jeVIL87kzojiBUGITyixyWxbyJp+SM/q4SrLPOzuM2oyrpNJI5M3ZEY/dhJRb2/TyV3cIX2GQ1GGdteUajeYJ8S3SUdlcRxvZF9UzuEetkSwBi3DM8P0XQ7RbNAfRMDOy0dFZoN8pYBRjQRgZzvswlDy6iIXkCQCpy/SkwWHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4F94F602B9; Thu, 11 Jun 2026 16:50:24 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf v3] selftests: netfilter: conntrack_sctp_collision.sh: Introduce SCTP INIT collision test
Date: Thu, 11 Jun 2026 16:50:13 +0200
Message-ID: <20260611145015.4781-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Chen <yiche.cy@gmail.com>

The existing test covered a scenario where a delayed INIT_ACK chunk
updates the vtag in conntrack after the association has already been
established.

A similar issue can occur with a delayed SCTP INIT chunk.

Add a new simultaneous-open test case where the client's INIT is
delayed, allowing conntrack to establish the association based on
the server-initiated handshake.

When the stale INIT arrives later, it may get recorded and cause a
following INIT_ACK from the peer to be accepted instead of dropped.
This INIT_ACK overwrites the vtag in conntrack, causing subsequent
SCTP DATA chunks to be considered as invalid and then dropped by
nft rules matching on ct state invalid.

This test verifies such stale INIT chunks do not cause problems.

Signed-off-by: Yi Chen <yiche.cy@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: address AI feedback.  Test passes on current nf.
 .../net/netfilter/conntrack_sctp_collision.sh | 89 ++++++++++++++-----
 1 file changed, 67 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh b/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh
index d860f7d9744b..7261975957ef 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh
@@ -2,18 +2,32 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Testing For SCTP COLLISION SCENARIO as Below:
-#
+# 1. Stale INIT_ACK capture:
 #   14:35:47.655279 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT] [init tag: 2017837359]
 #   14:35:48.353250 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT] [init tag: 1187206187]
 #   14:35:48.353275 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT ACK] [init tag: 2017837359]
 #   14:35:48.353283 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [COOKIE ECHO]
 #   14:35:48.353977 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [COOKIE ACK]
 #   14:35:48.855335 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT ACK] [init tag: 164579970]
+#   (Delayed)
+#
+# 2. Stale INIT capture:
+#   14:35:48.353250 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT] [init tag: 1187206187]
+#   14:35:48.353275 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT ACK] [init tag: 2017837359]
+#   14:35:48.353283 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [COOKIE ECHO]
+#   14:35:48.353977 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [COOKIE ACK]
+#   14:35:47.655279 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT] [init tag: 2017837359]
+#   (Delayed)
+#   14:35:48.855335 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT ACK] [init tag: 164579970]
 #
 # TOPO: SERVER_NS (link0)<--->(link1) ROUTER_NS (link2)<--->(link3) CLIENT_NS
 
 source lib.sh
 
+checktool "nft --version" "run test without nft"
+checktool "tc -h" "run test without tc"
+checktool "modprobe -q sctp" "load sctp module"
+
 CLIENT_IP="198.51.200.1"
 CLIENT_PORT=1234
 
@@ -24,7 +38,8 @@ CLIENT_GW="198.51.200.2"
 SERVER_GW="198.51.100.2"
 
 # setup the topo
-setup() {
+topo_setup() {
+	# setup_ns cleans up existing net namespaces first.
 	setup_ns CLIENT_NS SERVER_NS ROUTER_NS
 	ip -n "$SERVER_NS" link add link0 type veth peer name link1 netns "$ROUTER_NS"
 	ip -n "$CLIENT_NS" link add link3 type veth peer name link2 netns "$ROUTER_NS"
@@ -38,35 +53,53 @@ setup() {
 	ip -n "$ROUTER_NS" addr add $SERVER_GW/24 dev link1
 	ip -n "$ROUTER_NS" addr add $CLIENT_GW/24 dev link2
 	ip net exec "$ROUTER_NS" sysctl -wq net.ipv4.ip_forward=1
+	sysctl -wq net.netfilter.nf_log_all_netns=1
 
 	ip -n "$CLIENT_NS" link set link3 up
 	ip -n "$CLIENT_NS" addr add $CLIENT_IP/24 dev link3
 	ip -n "$CLIENT_NS" route add $SERVER_IP dev link3 via $CLIENT_GW
+}
+
+conf_delay()
+{
+	# simulate the delay on OVS upcall by setting up a delay for INIT_ACK/INIT with
+	local ns=$1
+	local link=$2
+	local chunk_type=$3
 
-	# simulate the delay on OVS upcall by setting up a delay for INIT_ACK with
-	# tc on $SERVER_NS side
-	tc -n "$SERVER_NS" qdisc add dev link0 root handle 1: htb r2q 64
-	tc -n "$SERVER_NS" class add dev link0 parent 1: classid 1:1 htb rate 100mbit
-	tc -n "$SERVER_NS" filter add dev link0 parent 1: protocol ip u32 match ip protocol 132 \
-		0xff match u8 2 0xff at 32 flowid 1:1
-	if ! tc -n "$SERVER_NS" qdisc add dev link0 parent 1:1 handle 10: netem delay 1200ms; then
+	# use a smaller number for assoc's max_retrans to reproduce the issue
+	ip net exec "$CLIENT_NS" sysctl -wq net.sctp.association_max_retrans=3
+
+	tc -n "$ns" qdisc add dev "$link" root handle 1: htb r2q 64
+	tc -n "$ns" class add dev "$link" parent 1: classid 1:1 htb rate 100mbit
+	tc -n "$ns" filter add dev "$link" parent 1: protocol ip \
+		u32 match ip protocol 132 0xff match u8 "$chunk_type" 0xff at 32 flowid 1:1
+	if ! tc -n "$ns" qdisc add dev "$link" parent 1:1 handle 10: netem delay 1200ms; then
 		echo "SKIP: Cannot add netem qdisc"
-		exit $ksft_skip
+		return $ksft_skip
 	fi
 
 	# simulate the ctstate check on OVS nf_conntrack
-	ip net exec "$ROUTER_NS" iptables -A FORWARD -m state --state INVALID,UNTRACKED -j DROP
-	ip net exec "$ROUTER_NS" iptables -A INPUT -p sctp -j DROP
-
-	# use a smaller number for assoc's max_retrans to reproduce the issue
-	modprobe -q sctp
-	ip net exec "$CLIENT_NS" sysctl -wq net.sctp.association_max_retrans=3
+	ip net exec "$ROUTER_NS" nft -f - <<-EOF
+	table ip t {
+		chain forward {
+			type filter hook forward priority filter; policy accept;
+			meta l4proto icmp counter accept
+			ct state new counter accept
+			ct state established,related counter accept
+			ct state invalid log flags all counter drop comment \
+			"Expect to drop stale INIT/INIT_ACK chunks"
+			counter
+		}
+	}
+	EOF
+	return 0
 }
 
 cleanup() {
-	ip net exec "$CLIENT_NS" pkill sctp_collision >/dev/null 2>&1
-	ip net exec "$SERVER_NS" pkill sctp_collision >/dev/null 2>&1
+	# cleanup_all_ns terminates running processes in the namespaces.
 	cleanup_all_ns
+	sysctl -wq net.netfilter.nf_log_all_netns=0
 }
 
 do_test() {
@@ -81,7 +114,19 @@ do_test() {
 
 # run the test case
 trap cleanup EXIT
-setup && \
-echo "Test for SCTP Collision in nf_conntrack:" && \
-do_test && echo "PASS!"
-exit $?
+
+echo "Test for SCTP INIT_ACK Collision in nf_conntrack:"
+topo_setup || exit $?
+conf_delay $SERVER_NS link0 2 || exit $?
+
+if ! do_test; then
+	exit $ksft_fail
+fi
+
+echo "Test for SCTP INIT Collision in nf_conntrack:"
+topo_setup || exit $?
+conf_delay $CLIENT_NS link3 1 || exit $?
+
+if ! do_test; then
+	exit $ksft_fail
+fi
-- 
2.53.0

