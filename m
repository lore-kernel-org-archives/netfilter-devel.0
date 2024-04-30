Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A3A152799;
	Tue, 30 Apr 2024 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490041; cv=none; b=CyyTsjGSmBSvckRN2jxm2bEsin0gWbYtC6ENZ+JfXVOHqn6sD0mCDT/ebVtx9kmIrLfBkv8zoRuM31s0lHGjI4zZ0PHU7L76k6HYTUQWId8lz1PQC3PczfKduxcorc4O+6cs8i5Ur3eoElQlTX6ZYX0SbBkvemD09m+AxdCHywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490041; c=relaxed/simple;
	bh=oK4GHrFC398K3Gg4Ek1f4bcol1anIXwz2yoiJP9AEUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ot/zvsXAH0Kg2+LO5583qiMijOR37SwwSaw73GqiqmUfiYd0K1SWMXgKVVVcDlSfb8QAjV2d8F78GQqv51FWz3sOpQCDGmur+ykPlcuTkXK6E7MoV+GWZK9VynjKpk8QlBauIX9yW1jXyl9K9UIEIPyDsr8UsO3JFf5NIW0my78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s1pB2-0004dT-5y; Tue, 30 Apr 2024 17:13:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next] selftests: netfilter: nft_concat_range.sh: reduce debug kernel run time
Date: Tue, 30 Apr 2024 16:58:07 +0200
Message-ID: <20240430145810.23447-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Even a 1h timeout isn't enough for nft_concat_range.sh to complete on
debug kernels.

Reduce test complexity and only match on single entry if
KSFT_MACHINE_SLOW is set.

To spot 'slow' tests, print the subtest duration (in seconds) in
addition to the status.

Add new nft_concat_range_perf.sh script, not executed via kselftest,
to run the performance (pps match rate) tests.

Those need about 25m to complete which seems too much to run this
via 'make run_tests'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testing/selftests/net/netfilter/Makefile  |  2 ++
 tools/testing/selftests/net/netfilter/config  |  1 +
 .../net/netfilter/nft_concat_range.sh         | 28 +++++++++++++++----
 .../net/netfilter/nft_concat_range_perf.sh    |  9 ++++++
 4 files changed, 34 insertions(+), 6 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_concat_range_perf.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index 72c6001964a6..e9a6c702b8c9 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -28,6 +28,8 @@ TEST_PROGS += nft_zones_many.sh
 TEST_PROGS += rpath.sh
 TEST_PROGS += xt_string.sh
 
+TEST_PROGS_EXTENDED = nft_concat_range_perf.sh
+
 TEST_GEN_PROGS = conntrack_dump_flush
 
 TEST_GEN_FILES = audit_logread
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 60b86c7f3ea1..5b5b764f6cd0 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -85,3 +85,4 @@ CONFIG_VETH=m
 CONFIG_VLAN_8021Q=m
 CONFIG_XFRM_USER=m
 CONFIG_XFRM_STATISTICS=y
+CONFIG_NET_PKTGEN=m
diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 2b6661519055..6d66240e149c 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -19,7 +19,7 @@ source lib.sh
 # - timeout: check that packets match entries until they expire
 # - performance: estimate matching rate, compare with rbtree and hash baselines
 TESTS="reported_issues correctness concurrency timeout"
-[ "${quicktest}" != "1" ] && TESTS="${TESTS} performance"
+[ -n "$NFT_CONCAT_RANGE_TESTS" ] && TESTS="${NFT_CONCAT_RANGE_TESTS}"
 
 # Set types, defined by TYPE_ variables below
 TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
@@ -31,7 +31,7 @@ BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
-	../../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+	../../../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
 	pktgen/pktgen_bench_xmit_mode_netif_receive.sh"
 
 # Definition of set types:
@@ -951,6 +951,10 @@ cleanup() {
 	killall iperf				2>/dev/null
 	killall netperf				2>/dev/null
 	killall netserver			2>/dev/null
+}
+
+cleanup_exit() {
+	cleanup
 	rm -f "$tmp"
 }
 
@@ -1371,6 +1375,9 @@ test_timeout() {
 	setup veth send_"${proto}" set || return ${ksft_skip}
 
 	timeout=3
+
+	[ "$KSFT_MACHINE_SLOW" = "yes" ] && timeout=8
+
 	range_size=1
 	for i in $(seq "$start" $((start + count))); do
 		end=$((start + range_size))
@@ -1386,7 +1393,7 @@ test_timeout() {
 		range_size=$((range_size + 1))
 		start=$((end + range_size))
 	done
-	sleep 3
+	sleep $timeout
 	for i in $(seq "$start" $((start + count))); do
 		end=$((start + range_size))
 		srcstart=$((start + src_delta))
@@ -1480,10 +1487,13 @@ test_performance() {
 }
 
 test_bug_flush_remove_add() {
+	rounds=100
+	[ "$KSFT_MACHINE_SLOW" = "yes" ] && rounds=10
+
 	set_cmd='{ set s { type ipv4_addr . inet_service; flags interval; }; }'
 	elem1='{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
 	elem2='{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'
-	for i in $(seq 1 100); do
+	for i in $(seq 1 $rounds); do
 		nft add table t "$set_cmd"	|| return ${ksft_skip}
 		nft add element t s "$elem1"	2>/dev/null || return 1
 		nft flush set t s		2>/dev/null || return 1
@@ -1552,7 +1562,7 @@ test_reported_issues() {
 # Run everything in a separate network namespace
 [ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }
 tmp="$(mktemp)"
-trap cleanup EXIT
+trap cleanup_exit EXIT
 
 # Entry point for test runs
 passed=0
@@ -1584,10 +1594,16 @@ for name in ${TESTS}; do
 			continue
 		fi
 
-		printf "  %-60s  " "${display}"
+		[ "$KSFT_MACHINE_SLOW" = "yes" ] && count=1
+
+		printf "  %-32s  " "${display}"
+		tthen=$(date +%s)
 		eval test_"${name}"
 		ret=$?
 
+		tnow=$(date +%s)
+		printf "%5ds%-30s" $((tnow-tthen))
+
 		if [ $ret -eq 0 ]; then
 			printf "[ OK ]\n"
 			info_flush
diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range_perf.sh b/tools/testing/selftests/net/netfilter/nft_concat_range_perf.sh
new file mode 100755
index 000000000000..5d276995a5c5
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range_perf.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+
+source lib.sh
+
+[ "$KSFT_MACHINE_SLOW" = yes ] && exit ${ksft_skip}
+
+NFT_CONCAT_RANGE_TESTS="performance" exec ./nft_concat_range.sh
-- 
2.43.2

