Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E666BC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 08:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB58720706
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 08:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgFVI2r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFVI2r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 04:28:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB4CC061794
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 01:28:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jnHoq-0002pt-7H; Mon, 22 Jun 2020 10:28:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/1] selftests: netfilter: add test case for conntrack helper assignment
Date:   Mon, 22 Jun 2020 10:28:32 +0200
Message-Id: <20200622082832.2883-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

check that 'nft ... ct helper set <foo>' works:
 1. configure ftp helper via nft and assign it to
    connections on port 2121
 2. check with 'conntrack -L' that the next connection
    has the ftp helper attached to it.

Also add a test for auto-assign (old behaviour).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 .../netfilter/nft_conntrack_helper.sh         | 175 ++++++++++++++++++
 2 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_conntrack_helper.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 9c0f758310fe..a179f0dca8ce 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -3,7 +3,7 @@
 
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
-	nft_concat_range.sh \
+	nft_concat_range.sh nft_conntrack_helper.sh \
 	nft_queue.sh
 
 LDLIBS = -lmnl
diff --git a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
new file mode 100755
index 000000000000..edf0a48da6bf
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
@@ -0,0 +1,175 @@
+#!/bin/bash
+#
+# This tests connection tracking helper assignment:
+# 1. can attach ftp helper to a connection from nft ruleset.
+# 2. auto-assign still works.
+#
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+testipv6=1
+
+cleanup()
+{
+	ip netns del ${ns1}
+	ip netns del ${ns2}
+}
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+conntrack -V > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without conntrack tool"
+	exit $ksft_skip
+fi
+
+which nc >/dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without netcat tool"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
+ip netns add ${ns1}
+ip netns add ${ns2}
+
+ip link add veth0 netns ${ns1} type veth peer name veth0 netns ${ns2} > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+
+ip -net ${ns1} link set lo up
+ip -net ${ns1} link set veth0 up
+
+ip -net ${ns2} link set lo up
+ip -net ${ns2} link set veth0 up
+
+ip -net ${ns1} addr add 10.0.1.1/24 dev veth0
+ip -net ${ns1} addr add dead:1::1/64 dev veth0
+
+ip -net ${ns2} addr add 10.0.1.2/24 dev veth0
+ip -net ${ns2} addr add dead:1::2/64 dev veth0
+
+load_ruleset_family() {
+	local family=$1
+	local ns=$2
+
+ip netns exec ${ns} nft -f - <<EOF
+table $family raw {
+	ct helper ftp {
+             type "ftp" protocol tcp
+        }
+	chain pre {
+		type filter hook prerouting priority 0; policy accept;
+		tcp dport 2121 ct helper set "ftp"
+	}
+	chain output {
+		type filter hook output priority 0; policy accept;
+		tcp dport 2121 ct helper set "ftp"
+	}
+}
+EOF
+	return $?
+}
+
+check_for_helper()
+{
+	local netns=$1
+	local message=$2
+	local port=$3
+
+	ip netns exec ${netns} conntrack -L -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
+	if [ $? -ne 0 ] ; then
+		echo "FAIL: ${netns} did not show attached helper $message" 1>&2
+		ret=1
+	fi
+
+	echo "PASS: ${netns} connection on port $port has ftp helper attached" 1>&2
+	return 0
+}
+
+test_helper()
+{
+	local port=$1
+	local msg=$2
+
+	sleep 3 | ip netns exec ${ns2} nc -w 2 -l -p $port > /dev/null &
+
+	sleep 1
+	sleep 1 | ip netns exec ${ns1} nc -w 2 10.0.1.2 $port > /dev/null &
+
+	check_for_helper "$ns1" "ip $msg" $port
+	check_for_helper "$ns2" "ip $msg" $port
+
+	wait
+
+	if [ $testipv6 -eq 0 ] ;then
+		return 0
+	fi
+
+	ip netns exec ${ns1} conntrack -F 2> /dev/null
+	ip netns exec ${ns2} conntrack -F 2> /dev/null
+
+	sleep 3 | ip netns exec ${ns2} nc -w 2 -6 -l -p $port > /dev/null &
+
+	sleep 1
+	sleep 1 | ip netns exec ${ns1} nc -w 2 -6 dead:1::2 $port > /dev/null &
+
+	check_for_helper "$ns1" "ipv6 $msg" $port
+	check_for_helper "$ns2" "ipv6 $msg" $port
+
+	wait
+}
+
+load_ruleset_family ip ${ns1}
+if [ $? -ne 0 ];then
+	echo "FAIL: ${ns1} cannot load ip ruleset" 1>&2
+	exit 1
+fi
+
+load_ruleset_family ip6 ${ns1}
+if [ $? -ne 0 ];then
+	echo "SKIP: ${ns1} cannot load ip6 ruleset" 1>&2
+	testipv6=0
+fi
+
+load_ruleset_family inet ${ns2}
+if [ $? -ne 0 ];then
+	echo "SKIP: ${ns1} cannot load inet ruleset" 1>&2
+	load_ruleset_family ip ${ns2}
+	if [ $? -ne 0 ];then
+		echo "FAIL: ${ns2} cannot load ip ruleset" 1>&2
+		exit 1
+	fi
+
+	if [ $testipv6 -eq 1 ] ;then
+		load_ruleset_family ip6 ${ns2}
+		if [ $? -ne 0 ];then
+			echo "FAIL: ${ns2} cannot load ip6 ruleset" 1>&2
+			exit 1
+		fi
+	fi
+fi
+
+test_helper 2121 "set via ruleset"
+ip netns exec ${ns1} sysctl -q 'net.netfilter.nf_conntrack_helper=1'
+ip netns exec ${ns2} sysctl -q 'net.netfilter.nf_conntrack_helper=1'
+test_helper 21 "auto-assign"
+
+exit $ret
-- 
2.26.2

