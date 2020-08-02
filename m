Return-Path: <SRS0=Ke5S=BM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F59C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB812076A
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHBB0b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Aug 2020 21:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHBB0b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Aug 2020 21:26:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDFDC06174A
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2020 18:26:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k22lh-0000PV-S4; Sun, 02 Aug 2020 03:26:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: add meta iif/oif match test
Date:   Sun,  2 Aug 2020 03:26:21 +0200
Message-Id: <20200802012622.15041-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

simple test case, but would have caught this:

FAIL: iifgroupcount, want "packets 2", got
table inet filter {
        counter iifgroupcount {
                packets 0 bytes 0
        }
}

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 tools/testing/selftests/netfilter/nft_meta.sh | 124 ++++++++++++++++++
 2 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_meta.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index a179f0dca8ce..a374e10ef506 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -4,7 +4,7 @@
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
-	nft_queue.sh
+	nft_queue.sh nft_meta.sh
 
 LDLIBS = -lmnl
 TEST_GEN_FILES =  nf-queue
diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
new file mode 100755
index 000000000000..d250b84dd5bc
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -0,0 +1,124 @@
+#!/bin/bash
+
+# check iif/iifname/oifgroup/iiftype match.
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+sfx=$(mktemp -u "XXXXXXXX")
+ns0="ns0-$sfx"
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+cleanup()
+{
+	ip netns del "$ns0"
+}
+
+ip netns add "$ns0"
+ip -net "$ns0" link set lo up
+ip -net "$ns0" addr add 127.0.0.1 dev lo
+
+trap cleanup EXIT
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table inet filter {
+	counter iifcount {}
+	counter iifnamecount {}
+	counter iifgroupcount {}
+	counter iiftypecount {}
+	counter infproto4count {}
+	counter il4protocounter {}
+	counter imarkcounter {}
+
+	counter oifcount {}
+	counter oifnamecount {}
+	counter oifgroupcount {}
+	counter oiftypecount {}
+	counter onfproto4count {}
+	counter ol4protocounter {}
+	counter oskuidcounter {}
+	counter oskgidcounter {}
+	counter omarkcounter {}
+
+	chain input {
+		type filter hook input priority 0; policy accept;
+
+		meta iif lo counter name "iifcount"
+		meta iifname "lo" counter name "iifnamecount"
+		meta iifgroup "default" counter name "iifgroupcount"
+		meta iiftype "loopback" counter name "iiftypecount"
+		meta nfproto ipv4 counter name "infproto4count"
+		meta l4proto icmp counter name "il4protocounter"
+		meta mark 42 counter name "imarkcounter"
+	}
+
+	chain output {
+		type filter hook output priority 0; policy accept;
+		meta oif lo counter name "oifcount" counter
+		meta oifname "lo" counter name "oifnamecount"
+		meta oifgroup "default" counter name "oifgroupcount"
+		meta oiftype "loopback" counter name "oiftypecount"
+		meta nfproto ipv4 counter name "onfproto4count"
+		meta l4proto icmp counter name "ol4protocounter"
+		meta skuid 0 counter name "oskuidcounter"
+		meta skgid 0 counter name "oskgidcounter"
+		meta mark 42 counter name "omarkcounter"
+	}
+}
+EOF
+
+if [ $? -ne 0 ]; then
+	echo "SKIP: Could not add test ruleset"
+	exit $ksft_skip
+fi
+
+ret=0
+
+check_one_counter()
+{
+	local cname="$1"
+	local want="packets $2"
+	local verbose="$3"
+
+	cnt=$(ip netns exec "$ns0" nft list counter inet filter $cname | grep -q "$want")
+	if [ $? -ne 0 ];then
+		echo "FAIL: $cname, want \"$want\", got"
+		ret=1
+		ip netns exec "$ns0" nft list counter inet filter $counter
+	fi
+}
+
+check_lo_counters()
+{
+	local want="$1"
+	local verbose="$2"
+	local counter
+
+	for counter in iifcount iifnamecount iifgroupcount iiftypecount infproto4count \
+		       oifcount oifnamecount oifgroupcount oiftypecount onfproto4count \
+		       il4protocounter \
+		       ol4protocounter \
+	     ; do
+		check_one_counter "$counter" "$want" "$verbose"
+	done
+}
+
+check_lo_counters "0" false
+ip netns exec "$ns0" ping -q -c 1 127.0.0.1 -m 42 > /dev/null
+
+check_lo_counters "2" true
+
+check_one_counter oskuidcounter "1" true
+check_one_counter oskgidcounter "1" true
+check_one_counter imarkcounter "1" true
+check_one_counter omarkcounter "1" true
+
+if [ $ret -eq 0 ];then
+	echo "OK: nftables meta iif/oif counters at expected values"
+fi
+
+exit $ret
-- 
2.26.2

