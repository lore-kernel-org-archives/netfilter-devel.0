Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D01AC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C0C64EF1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhBXQYm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhBXQY0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 11:24:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786EAC06178A
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Feb 2021 08:23:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lEwwy-00031h-68; Wed, 24 Feb 2021 17:23:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/3] selftests: netfilter: test nat port clash resolution interaction with tcp early demux
Date:   Wed, 24 Feb 2021 17:23:21 +0100
Message-Id: <20210224162321.4899-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210224162321.4899-1-fw@strlen.de>
References: <20210224162321.4899-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Convert Antonio Ojeas bug reproducer to a kselftest.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/Makefile    |  2 +-
 .../selftests/netfilter/nf_nat_edemux.sh      | 99 +++++++++++++++++++
 2 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nf_nat_edemux.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 3006a8e5b41a..3171069a6b46 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -4,7 +4,7 @@
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
-	nft_queue.sh nft_meta.sh \
+	nft_queue.sh nft_meta.sh nf_nat_edemux.sh \
 	ipip-conntrack-mtu.sh
 
 LDLIBS = -lmnl
diff --git a/tools/testing/selftests/netfilter/nf_nat_edemux.sh b/tools/testing/selftests/netfilter/nf_nat_edemux.sh
new file mode 100755
index 000000000000..cfee3b65be0f
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nf_nat_edemux.sh
@@ -0,0 +1,99 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test NAT source port clash resolution
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+
+cleanup()
+{
+	ip netns del $ns1
+	ip netns del $ns2
+}
+
+iperf3 -v > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without iperf3"
+	exit $ksft_skip
+fi
+
+iptables --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without iptables"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ip netns add "$ns1"
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace $ns1"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
+ip netns add $ns2
+
+# Connect the namespaces using a veth pair
+ip link add name veth2 type veth peer name veth1
+ip link set netns $ns1 dev veth1
+ip link set netns $ns2 dev veth2
+
+ip netns exec $ns1 ip link set up dev lo
+ip netns exec $ns1 ip link set up dev veth1
+ip netns exec $ns1 ip addr add 192.168.1.1/24 dev veth1
+
+ip netns exec $ns2 ip link set up dev lo
+ip netns exec $ns2 ip link set up dev veth2
+ip netns exec $ns2 ip addr add 192.168.1.2/24 dev veth2
+
+# Create a server in one namespace
+ip netns exec $ns1 iperf3 -s > /dev/null 2>&1 &
+iperfs=$!
+
+# Restrict source port to just one so we don't have to exhaust
+# all others.
+ip netns exec $ns2 sysctl -q net.ipv4.ip_local_port_range="10000 10000"
+
+# add a virtual IP using DNAT
+ip netns exec $ns2 iptables -t nat -A OUTPUT -d 10.96.0.1/32 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.1:5201
+
+# ... and route it to the other namespace
+ip netns exec $ns2 ip route add 10.96.0.1 via 192.168.1.1
+
+sleep 1
+
+# add a persistent connection from the other namespace
+ip netns exec $ns2 nc -q 10 -w 10 192.168.1.1 5201 > /dev/null &
+
+sleep 1
+
+# ip daddr:dport will be rewritten to 192.168.1.1 5201
+# NAT must reallocate source port 10000 because
+# 192.168.1.2:10000 -> 192.168.1.1:5201 is already in use
+echo test | ip netns exec $ns2 nc -w 3 -q 3 10.96.0.1 443 >/dev/null
+ret=$?
+
+kill $iperfs
+
+# Check nc can connect to 10.96.0.1:443 (aka 192.168.1.1:5201).
+if [ $ret -eq 0 ]; then
+	echo "PASS: nc can connect via NAT'd address"
+else
+	echo "FAIL: nc cannot connect via NAT'd address"
+	exit 1
+fi
+
+exit 0
-- 
2.26.2

