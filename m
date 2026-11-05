Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793888638;
	b=hIfMiTKo1UXDX4Q+SrXLjMHvW5JQ84jIUF2qqc5QsNFNdzfzuR3AodYDRShBRJftCG2L
	 bfl0Ptygw4mRokUpDud0w/mNNxqhAOnJ03aCMQTYdK6fwxfsLoD4MrQTV61wqDSMGRpSp
	 ue4aHOx3MZ55EbUXg4qXnRlGIOJg9yFkAA1OF/wBokasTUNxkAkhYi47yA3JOpLCJEA1r
	 957sbDPveMvUqchY5i23A0EQbvD6E1Bo2bqb+SKxHeD8jvQ0HLx8St4+Xh2mfUcBeJy6B
	 k9KTgOgXYwWG2DLrOcIOtnETdpsM5wClqffckXnSolH3Wlz06Qa1AnYS+tPjGzrJjww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793888638;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eebdjfmvo5zSWz7Fn8LT9NhlqwiP8pc04Hjl8qTs/QU=;
	b=cJGm8tCLFz0ugWdptC3bCtBIoBwEBOZvPElb+svYUYgPpASbB/RtfpI6DYMtP2noS/LH
	 UFgVmcd7h/+3Mc4jCWKR3+7hM0/MaLLhpRQl6cSTU4566Sg2lNL8P5HP7neRbb5T7GE6o
	 mxEVbx5NKy575lyvazRV6zsOMpzVQAwiIN/HdKlmLUX4b1PcZgBI62JCR+JP7i/kCPo0Q
	 JadvvserFekN8z5O1ThiyDq1r/4QcMeNPD9N/RIVR9MDc/4alNT2wQpQx7UlM4gzTt9aH
	 FSsvu9Pp1aK0om7jQQ4yMpjRII5Rie7D4u8CRfGkmEPTikWC4+TR540fNd3MBQecbAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A61606A326
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 14:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27A61606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 958BF60380; Thu, 05 Nov 2026 15:23:54 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] selftests: netfilter: add ipset flush vs. concurrent insert perf test
Date: Thu,  5 Nov 2026 15:23:47 +0100
Message-ID: <20261105142347.23673-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
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

Add (not run by default) selftest that measures latency while flushing a
large hash:net set contends with concurrent packet-path insertions
(via "-j SET --add-set").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Artifact from LLM trying to convince me that rhashtable conversion
 sucks and makes flush too slow.  Since this doesn't hurt and might
 come in useful later, sending this so its archived on lore.

 I'm not sure its worth applying it, ever.

 .../testing/selftests/net/netfilter/Makefile  |   5 +-
 tools/testing/selftests/net/netfilter/config  |   3 +
 .../net/netfilter/ipset_flush_perf.sh         | 105 ++++++++++++++++++
 3 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/netfilter/ipset_flush_perf.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index df3c20c90f5d..0a732ce12c81 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -45,7 +45,10 @@ TEST_PROGS := \
 	xt_string.sh \
 # end of TEST_PROGS
 
-TEST_PROGS_EXTENDED = nft_concat_range_perf.sh
+TEST_PROGS_EXTENDED = \
+	ipset_flush_perf.sh \
+	nft_concat_range_perf.sh \
+# end of TEST_PROGS_EXTENDED
 
 TEST_GEN_FILES = \
 	audit_logread \
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 629b2b29ed1a..d6047a8db318 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -32,6 +32,8 @@ CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_RAW=m
 CONFIG_IP_SCTP=m
+CONFIG_IP_SET=m
+CONFIG_IP_SET_HASH_NET=m
 CONFIG_IPV6=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_IPV6_TUNNEL=m
@@ -53,6 +55,7 @@ CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
 CONFIG_NETFILTER_XT_MATCH_STATE=m
 CONFIG_NETFILTER_XT_MATCH_STRING=m
 CONFIG_NETFILTER_XT_NAT=m
+CONFIG_NETFILTER_XT_SET=m
 CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
 CONFIG_NET_IPIP=m
 CONFIG_NET_L3_MASTER_DEV=y
diff --git a/tools/testing/selftests/net/netfilter/ipset_flush_perf.sh b/tools/testing/selftests/net/netfilter/ipset_flush_perf.sh
new file mode 100755
index 000000000000..72dc8966a537
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/ipset_flush_perf.sh
@@ -0,0 +1,105 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Measures ipset flush latency on a large hash:net set, both idle and while
+# the set is concurrently being inserted into via a real "-j SET --add-set
+# ... src" iptables rule, and reports flush latency and ping RTT so a
+# reader can judge the impact of concurrent insert load from real numbers.
+#
+# This is NOT a regression test.
+
+source lib.sh
+
+checktool "ipset -v" "run test without ipset"
+checktool "iptables --version" "run test without iptables"
+checktool "ping -V" "run test without ping"
+
+entries=200000
+duration=10
+[ "$KSFT_MACHINE_SLOW" = "yes" ] && entries=20000
+
+pingout=$(mktemp)
+
+cleanup() {
+	cleanup_all_ns
+	rm -f "$pingout"
+}
+trap cleanup EXIT
+
+setup_ns nsclient
+
+# Mostly /32 entries, like a dynamic IP block/allow list (fail2ban-style),
+# plus a handful of wider prefixes so h->rnets[] tracks more than one CIDR
+# length.
+gen_restore()
+{
+	local set="$1"
+	local n="$2"
+
+	awk -v set="$set" -v n="$n" 'BEGIN {
+		print "create " set " hash:net family inet maxelem " (n + 64) " -exist"
+		for (i = 0; i < n; i++)
+			print "add " set " 10." int(i/65536)%256 "." int(i/256)%256 "." i%256 "/32"
+		for (i = 0; i < 16; i++) {
+			print "add " set " 172.16." i ".0/24"
+			print "add " set " 172." i ".0.0/16"
+		}
+		print "add " set " 11.0.0.0/8"
+		print "add " set " 12.0.0.0/8"
+	}'
+}
+
+populate()
+{
+	gen_restore perfset "$entries" | ip netns exec "$nsclient" ipset restore
+}
+
+flush_once()
+{
+	local t0 t1
+
+	t0=$(date +%s%N)
+	ip netns exec "$nsclient" ipset flush perfset
+	t1=$(date +%s%N)
+	echo $(( (t1 - t0) / 1000000 ))
+}
+
+echo "INFO: populating hash:net set with $entries /32 entries (+ a few wider prefixes)"
+if ! populate; then
+	echo "SKIP: could not create/populate ipset"
+	exit $ksft_skip
+fi
+
+base_ms=$(flush_once)
+echo "INFO: flush of a freshly populated, otherwise idle set took ${base_ms}ms"
+
+populate
+
+if ! ip netns exec "$nsclient" iptables -t raw -A OUTPUT -j SET --add-set perfset src; then
+	echo "SKIP: could not load the SET target (xt_set)"
+	exit $ksft_skip
+fi
+
+echo "INFO: flushing the set back-to-back for ${duration}s while flooding it with inserts via -j SET"
+ip netns exec "$nsclient" ping -f -q -w "$duration" 127.0.0.1 > "$pingout" 2>&1 &
+pingpid=$!
+
+max_ms=0
+count=0
+end=$(( $(date +%s) + duration ))
+while [ "$(date +%s)" -lt "$end" ]; do
+	ms=$(flush_once)
+	count=$((count + 1))
+	[ "$ms" -gt "$max_ms" ] && max_ms="$ms"
+	populate
+done
+
+wait "$pingpid"
+
+echo "INFO: ping -f summary while the set was being repeatedly flushed:"
+sed -n '/packets transmitted/,$p' "$pingout"
+
+echo "INFO: completed $count flush+repopulate cycles in ${duration}s under concurrent insert load"
+echo "INFO: max flush latency under load: ${max_ms}ms (idle baseline: ${base_ms}ms)"
+
+exit 0
-- 
2.56.0

