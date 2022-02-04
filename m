Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F19C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 13:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbiBDNCk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 08:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244168AbiBDNCk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 08:02:40 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC77C061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 05:02:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nFyEY-0007qN-53; Fri, 04 Feb 2022 14:02:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: add synproxy test
Date:   Fri,  4 Feb 2022 14:02:33 +0100
Message-Id: <20220204130233.8207-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Simple test for synproxy feature, iperf3 should be intercepted
by synproxy netns, but connection should still succeed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 .../selftests/netfilter/nft_synproxy.sh       | 115 ++++++++++++++++++
 2 files changed, 116 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_synproxy.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index ffca314897c4..e4f845dd942b 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -6,7 +6,7 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
 	nft_queue.sh nft_meta.sh nf_nat_edemux.sh \
 	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
-	conntrack_vrf.sh
+	conntrack_vrf.sh nft_synproxy.sh
 
 LDLIBS = -lmnl
 TEST_GEN_FILES =  nf-queue
diff --git a/tools/testing/selftests/netfilter/nft_synproxy.sh b/tools/testing/selftests/netfilter/nft_synproxy.sh
new file mode 100755
index 000000000000..09bb95c87198
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_synproxy.sh
@@ -0,0 +1,115 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+rnd=$(mktemp -u XXXXXXXX)
+nsr="nsr-$rnd"	# synproxy machine
+ns1="ns1-$rnd"  # iperf client
+ns2="ns2-$rnd"  # iperf server
+
+checktool (){
+	if ! $1 > /dev/null 2>&1; then
+		echo "SKIP: Could not $2"
+		exit $ksft_skip
+	fi
+}
+
+checktool "nft --version" "run test without nft tool"
+checktool "ip -Version" "run test without ip tool"
+checktool "iperf3 --version" "run test without iperf3"
+checktool "ip netns add $nsr" "create net namespace"
+
+ip netns add $ns1
+ip netns add $ns2
+
+cleanup() {
+	ip netns pids $ns1 | xargs kill 2>/dev/null
+	ip netns pids $ns2 | xargs kill 2>/dev/null
+	ip netns del $ns1
+	ip netns del $ns2
+
+	ip netns del $nsr
+}
+
+trap cleanup EXIT
+
+ip link add veth0 netns $nsr type veth peer name eth0 netns $ns1
+ip link add veth1 netns $nsr type veth peer name eth0 netns $ns2
+
+for dev in lo veth0 veth1; do
+ip -net $nsr link set $dev up
+done
+
+ip -net $nsr addr add 10.0.1.1/24 dev veth0
+ip -net $nsr addr add 10.0.2.1/24 dev veth1
+
+ip netns exec $nsr sysctl -q net.ipv4.conf.veth0.forwarding=1
+ip netns exec $nsr sysctl -q net.ipv4.conf.veth1.forwarding=1
+ip netns exec $nsr sysctl -q net.netfilter.nf_conntrack_tcp_loose=0
+
+for n in $ns1 $ns2; do
+  ip -net $n link set lo up
+  ip -net $n link set eth0 up
+done
+ip -net $ns1 addr add 10.0.1.99/24 dev eth0
+ip -net $ns2 addr add 10.0.2.99/24 dev eth0
+ip -net $ns1 route add default via 10.0.1.1
+ip -net $ns2 route add default via 10.0.2.1
+
+# test basic connectivity
+if ! ip netns exec $ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
+  echo "ERROR: $ns1 cannot reach $ns2" 1>&2
+  exit 1
+fi
+
+if ! ip netns exec $ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
+  echo "ERROR: $ns2 cannot reach $ns1" 1>&2
+  exit 1
+fi
+
+ip netns exec $ns2 iperf3 -s > /dev/null 2>&1 &
+# ip netns exec $nsr tcpdump -vvv -n -i veth1 tcp | head -n 10 &
+
+sleep 1
+
+ip netns exec $nsr nft -f - <<EOF
+table inet filter {
+   chain prerouting {
+      type filter hook prerouting priority -300; policy accept;
+      meta iif veth0 tcp flags syn counter notrack
+   }
+
+  chain forward {
+      type filter hook forward priority 0; policy accept;
+
+      ct state new,established counter accept
+
+      meta iif veth0 meta l4proto tcp ct state untracked,invalid synproxy mss 1460 sack-perm timestamp
+
+      ct state invalid counter drop
+
+      # make ns2 unreachable w.o. tcp synproxy
+      tcp flags syn counter drop
+   }
+}
+EOF
+if [ $? -ne 0 ]; then
+	echo "SKIP: Cannot add nft synproxy"
+	exit $ksft_skip
+fi
+
+ip netns exec $ns1 timeout 5 iperf3 -c 10.0.2.99 -n $((1 * 1024 * 1024)) > /dev/null
+
+if [ $? -ne 0 ]; then
+	echo "FAIL: iperf3 returned an error" 1>&2
+	ret=$?
+	ip netns exec $nsr nft list ruleset
+else
+	echo "PASS: synproxy connection successful"
+fi
+
+exit $ret
-- 
2.34.1

