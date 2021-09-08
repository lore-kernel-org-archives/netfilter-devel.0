Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0DBC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A16A260E77
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348610AbhIHMaZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348488AbhIHMaY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 08:30:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B7BC061575
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Sep 2021 05:29:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mNwhX-0004c7-JF; Wed, 08 Sep 2021 14:29:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 5/5] selftests: netfilter: add zone stress test with colliding tuples
Date:   Wed,  8 Sep 2021 14:28:39 +0200
Message-Id: <20210908122839.7526-7-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210908122839.7526-1-fw@strlen.de>
References: <20210908122839.7526-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add 20k entries to the connection tracking table, once from the
data plane, once via ctnetlink.

In both cases, each entry lives in a different conntrack zone
and addresses/ports are identical.

Expectation is that insertions work and occurs in constant time:

PASS: added 10000 entries in 1215 ms (now 10000 total, loop 1)
PASS: added 10000 entries in 1214 ms (now 20000 total, loop 2)
PASS: inserted 20000 entries from packet path in 2434 ms total
PASS: added 10000 entries in 57631 ms (now 10000 total)
PASS: added 10000 entries in 58572 ms (now 20000 total)
PASS: inserted 20000 entries via ctnetlink in 116205 ms

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/netfilter/nft_zones_many.sh     | 156 ++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100755 tools/testing/selftests/netfilter/nft_zones_many.sh

diff --git a/tools/testing/selftests/netfilter/nft_zones_many.sh b/tools/testing/selftests/netfilter/nft_zones_many.sh
new file mode 100755
index 000000000000..ac646376eb01
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_zones_many.sh
@@ -0,0 +1,156 @@
+#!/bin/bash
+
+# Test insertion speed for packets with identical addresses/ports
+# that are all placed in distinct conntrack zones.
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns="ns-$sfx"
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+zones=20000
+have_ct_tool=0
+ret=0
+
+cleanup()
+{
+	ip netns del $ns
+}
+
+ip netns add $ns
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace $gw"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
+conntrack -V > /dev/null 2>&1
+if [ $? -eq 0 ];then
+	have_ct_tool=1
+fi
+
+ip -net "$ns" link set lo up
+
+test_zones() {
+	local max_zones=$1
+
+ip netns exec $ns sysctl -q net.netfilter.nf_conntrack_udp_timeout=3600
+ip netns exec $ns nft -f /dev/stdin<<EOF
+flush ruleset
+table inet raw {
+	map rndzone {
+		typeof numgen inc mod $max_zones : ct zone
+	}
+
+	chain output {
+		type filter hook output priority -64000; policy accept;
+		udp dport 12345  ct zone set numgen inc mod 65536 map @rndzone
+	}
+}
+EOF
+	(
+		echo "add element inet raw rndzone {"
+	for i in $(seq 1 $max_zones);do
+		echo -n "$i : $i"
+		if [ $i -lt $max_zones ]; then
+			echo ","
+		else
+			echo "}"
+		fi
+	done
+	) | ip netns exec $ns nft -f /dev/stdin
+
+	local i=0
+	local j=0
+	local outerstart=$(date +%s%3N)
+	local stop=$outerstart
+
+	while [ $i -lt $max_zones ]; do
+		local start=$(date +%s%3N)
+		i=$((i + 10000))
+		j=$((j + 1))
+		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" nc -w 1 -q 1 -u -p 12345 127.0.0.1 12345 > /dev/null
+		if [ $? -ne 0 ] ;then
+			ret=1
+			break
+		fi
+
+		stop=$(date +%s%3N)
+		local duration=$((stop-start))
+		echo "PASS: added 10000 entries in $duration ms (now $i total, loop $j)"
+	done
+
+	if [ $have_ct_tool -eq 1 ]; then
+		local count=$(ip netns exec "$ns" conntrack -C)
+		local duration=$((stop-outerstart))
+
+		if [ $count -eq $max_zones ]; then
+			echo "PASS: inserted $count entries from packet path in $duration ms total"
+		else
+			ip netns exec $ns conntrack -S 1>&2
+			echo "FAIL: inserted $count entries from packet path in $duration ms total, expected $max_zones entries"
+			ret=1
+		fi
+	fi
+
+	if [ $ret -ne 0 ];then
+		echo "FAIL: insert $max_zones entries from packet path" 1>&2
+	fi
+}
+
+test_conntrack_tool() {
+	local max_zones=$1
+
+	ip netns exec $ns conntrack -F >/dev/null 2>/dev/null
+
+	local outerstart=$(date +%s%3N)
+	local start=$(date +%s%3N)
+	local stop=$start
+	local i=0
+	while [ $i -lt $max_zones ]; do
+		i=$((i + 1))
+		ip netns exec "$ns" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
+	                 --timeout 3600 --state ESTABLISHED --sport 12345 --dport 1000 --zone $i >/dev/null 2>&1
+		if [ $? -ne 0 ];then
+			ip netns exec "$ns" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
+	                 --timeout 3600 --state ESTABLISHED --sport 12345 --dport 1000 --zone $i > /dev/null
+			echo "FAIL: conntrack -I returned an error"
+			ret=1
+			break
+		fi
+
+		if [ $((i%10000)) -eq 0 ];then
+			stop=$(date +%s%3N)
+
+			local duration=$((stop-start))
+			echo "PASS: added 10000 entries in $duration ms (now $i total)"
+			start=$stop
+		fi
+	done
+
+	local count=$(ip netns exec "$ns" conntrack -C)
+	local duration=$((stop-outerstart))
+
+	if [ $count -eq $max_zones ]; then
+		echo "PASS: inserted $count entries via ctnetlink in $duration ms"
+	else
+		ip netns exec $ns conntrack -S 1>&2
+		echo "FAIL: inserted $count entries via ctnetlink in $duration ms, expected $max_zones entries ($duration ms)"
+		ret=1
+	fi
+}
+
+test_zones $zones
+
+if [ $have_ct_tool -eq 1 ];then
+	test_conntrack_tool $zones
+else
+	echo "SKIP: Could not run ctnetlink insertion test without conntrack tool"
+	if [ $ret -eq 0 ];then
+		exit $ksft_skip
+	fi
+fi
+
+exit $ret
-- 
2.32.0

