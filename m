Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD94C47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 11:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 128B06139A
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 11:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhFHLuX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 07:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhFHLuX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 07:50:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A447C061787
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Jun 2021 04:48:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lqaDc-0000oN-JC; Tue, 08 Jun 2021 13:48:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] selftests: netfilter: add fib test case
Date:   Tue,  8 Jun 2021 13:48:17 +0200
Message-Id: <20210608114818.23397-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608114818.23397-1-fw@strlen.de>
References: <20210608114818.23397-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a bug report on netfilter.org bugzilla pointing to fib
expression dropping ipv6 DAD packets.

Add a test case that demonstrates this problem.

Next patch excludes icmpv6 packets coming from any to linklocal.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/Makefile   |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh | 221 +++++++++++++++++++
 2 files changed, 222 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_fib.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 3171069a6b46..cd6430b39982 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for netfilter selftests
 
-TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
+TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
 	nft_queue.sh nft_meta.sh nf_nat_edemux.sh \
diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
new file mode 100755
index 000000000000..6caf6ac8c285
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -0,0 +1,221 @@
+#!/bin/bash
+#
+# This tests the fib expression.
+#
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+nsrouter="nsrouter-$sfx"
+timeout=4
+
+log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
+
+cleanup()
+{
+	ip netns del ${ns1}
+	ip netns del ${ns2}
+	ip netns del ${nsrouter}
+
+	[ $log_netns -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns=$log_netns
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
+ip netns add ${nsrouter}
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
+dmesg | grep -q ' nft_rpfilter: '
+if [ $? -eq 0 ]; then
+	dmesg -c | grep ' nft_rpfilter: '
+	echo "WARN: a previous test run has failed" 1>&2
+fi
+
+sysctl -q net.netfilter.nf_log_all_netns=1
+ip netns add ${ns1}
+ip netns add ${ns2}
+
+load_ruleset() {
+	local netns=$1
+
+ip netns exec ${netns} nft -f /dev/stdin <<EOF
+table inet filter {
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+	        fib saddr . iif oif missing counter log prefix "$netns nft_rpfilter: " drop
+	}
+}
+EOF
+}
+
+load_ruleset_count() {
+	local netns=$1
+
+ip netns exec ${netns} nft -f /dev/stdin <<EOF
+table inet filter {
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+		ip daddr 1.1.1.1 fib saddr . iif oif missing counter drop
+		ip6 daddr 1c3::c01d fib saddr . iif oif missing counter drop
+	}
+}
+EOF
+}
+
+check_drops() {
+	dmesg | grep -q ' nft_rpfilter: '
+	if [ $? -eq 0 ]; then
+		dmesg | grep ' nft_rpfilter: '
+		echo "FAIL: rpfilter did drop packets"
+		return 1
+	fi
+
+	return 0
+}
+
+check_fib_counter() {
+	local want=$1
+	local ns=$2
+	local address=$3
+
+	line=$(ip netns exec ${ns} nft list table inet filter | grep 'fib saddr . iif' | grep $address | grep "packets $want" )
+	ret=$?
+
+	if [ $ret -ne 0 ];then
+		echo "Netns $ns fib counter doesn't match expected packet count of $want for $address" 1>&2
+		ip netns exec ${ns} nft list table inet filter
+		return 1
+	fi
+
+	if [ $want -gt 0 ]; then
+		echo "PASS: fib expression did drop packets for $address"
+	fi
+
+	return 0
+}
+
+load_ruleset ${nsrouter}
+load_ruleset ${ns1}
+load_ruleset ${ns2}
+
+ip link add veth0 netns ${nsrouter} type veth peer name eth0 netns ${ns1} > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+ip link add veth1 netns ${nsrouter} type veth peer name eth0 netns ${ns2}
+
+ip -net ${nsrouter} link set lo up
+ip -net ${nsrouter} link set veth0 up
+ip -net ${nsrouter} addr add 10.0.1.1/24 dev veth0
+ip -net ${nsrouter} addr add dead:1::1/64 dev veth0
+
+ip -net ${nsrouter} link set veth1 up
+ip -net ${nsrouter} addr add 10.0.2.1/24 dev veth1
+ip -net ${nsrouter} addr add dead:2::1/64 dev veth1
+
+ip -net ${ns1} link set lo up
+ip -net ${ns1} link set eth0 up
+
+ip -net ${ns2} link set lo up
+ip -net ${ns2} link set eth0 up
+
+ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
+ip -net ${ns1} addr add dead:1::99/64 dev eth0
+ip -net ${ns1} route add default via 10.0.1.1
+ip -net ${ns1} route add default via dead:1::1
+
+ip -net ${ns2} addr add 10.0.2.99/24 dev eth0
+ip -net ${ns2} addr add dead:2::99/64 dev eth0
+ip -net ${ns2} route add default via 10.0.2.1
+ip -net ${ns2} route add default via dead:2::1
+
+test_ping() {
+  local daddr4=$1
+  local daddr6=$2
+
+  ip netns exec ${ns1} ping -c 1 -q $daddr4 > /dev/null
+  ret=$?
+  if [ $ret -ne 0 ];then
+	check_drops
+	echo "FAIL: ${ns1} cannot reach $daddr4, ret $ret" 1>&2
+	return 1
+  fi
+
+  ip netns exec ${ns1} ping -c 3 -q $daddr6 > /dev/null
+  ret=$?
+  if [ $ret -ne 0 ];then
+	check_drops
+	echo "FAIL: ${ns1} cannot reach $daddr6, ret $ret" 1>&2
+	return 1
+  fi
+
+  return 0
+}
+
+ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+sleep 3
+
+test_ping 10.0.2.1 dead:2::1 || exit 1
+check_drops || exit 1
+
+test_ping 10.0.2.99 dead:2::99 || exit 1
+check_drops || exit 1
+
+echo "PASS: fib expression did not cause unwanted packet drops"
+
+ip netns exec ${nsrouter} nft flush table inet filter
+
+ip -net ${ns1} route del default
+ip -net ${ns1} -6 route del default
+
+ip -net ${ns1} addr del 10.0.1.99/24 dev eth0
+ip -net ${ns1} addr del dead:1::99/64 dev eth0
+
+ip -net ${ns1} addr add 10.0.2.99/24 dev eth0
+ip -net ${ns1} addr add dead:2::99/64 dev eth0
+
+ip -net ${ns1} route add default via 10.0.2.1
+ip -net ${ns1} -6 route add default via dead:2::1
+
+ip -net ${nsrouter} addr add dead:2::1/64 dev veth0
+
+# switch to ruleset that doesn't log, this time
+# its expected that this does drop the packets.
+load_ruleset_count ${nsrouter}
+
+# ns1 has a default route, but nsrouter does not.
+# must not check return value, ping to 1.1.1.1 will
+# fail.
+check_fib_counter 0 ${nsrouter} 1.1.1.1 || exit 1
+check_fib_counter 0 ${nsrouter} 1c3::c01d || exit 1
+
+ip netns exec ${ns1} ping -c 1 -W 1 -q 1.1.1.1 > /dev/null
+check_fib_counter 1 ${nsrouter} 1.1.1.1 || exit 1
+
+sleep 2
+ip netns exec ${ns1} ping -c 3 -q 1c3::c01d > /dev/null
+check_fib_counter 3 ${nsrouter} 1c3::c01d || exit 1
+
+exit 0
-- 
2.31.1

