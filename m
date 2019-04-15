Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0637CC282DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D45842075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfDORAt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:49 -0400
Received: from mail.us.es ([193.147.175.20]:50448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbfDORAr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3CB0D1C4449
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CA36DA705
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28B7DDA70B; Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0B66DA701;
        Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A119F4265A31;
        Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/22] selftests: netfilter: add ebtables broute test case
Date:   Mon, 15 Apr 2019 19:00:24 +0200
Message-Id: <20190415170028.3470-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ebtables -t broute allows to redirect packets in a way that
they get pushed up the stack, even if the interface is part
of a bridge.

In case of IP packets to non-local address, this means
those IP packets are routed instead of bridged-forwarded, just
as if the bridge would not have existed.

Expected test output is:
PASS: netns connectivity: ns1 and ns2 can reach each other
PASS: ns1/ns2 connectivity with active broute rule
PASS: ns1/ns2 connectivity with active broute rule and bridge forward drop

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../testing/selftests/netfilter/bridge_brouter.sh  | 146 +++++++++++++++++++++
 2 files changed, 147 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/bridge_brouter.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index c9ff2b47bd1c..80dae72a25c7 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for netfilter selftests
 
-TEST_PROGS := nft_trans_stress.sh nft_nat.sh
+TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/bridge_brouter.sh b/tools/testing/selftests/netfilter/bridge_brouter.sh
new file mode 100755
index 000000000000..29f3955b9af7
--- /dev/null
+++ b/tools/testing/selftests/netfilter/bridge_brouter.sh
@@ -0,0 +1,146 @@
+#!/bin/bash
+#
+# This test is for bridge 'brouting', i.e. make some packets being routed
+# rather than getting bridged even though they arrive on interface that is
+# part of a bridge.
+
+#           eth0    br0     eth0
+# setup is: ns1 <-> ns0 <-> ns2
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+ebtables -V > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ebtables"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ip netns add ns0
+ip netns add ns1
+ip netns add ns2
+
+ip link add veth0 netns ns0 type veth peer name eth0 netns ns1
+if [ $? -ne 0 ]; then
+	echo "SKIP: Can't create veth device"
+	exit $ksft_skip
+fi
+ip link add veth1 netns ns0 type veth peer name eth0 netns ns2
+
+ip -net ns0 link set lo up
+ip -net ns0 link set veth0 up
+ip -net ns0 link set veth1 up
+
+ip -net ns0 link add br0 type bridge
+if [ $? -ne 0 ]; then
+	echo "SKIP: Can't create bridge br0"
+	exit $ksft_skip
+fi
+
+ip -net ns0 link set veth0 master br0
+ip -net ns0 link set veth1 master br0
+ip -net ns0 link set br0 up
+ip -net ns0 addr add 10.0.0.1/24 dev br0
+
+# place both in same subnet, ns1 and ns2 connected via ns0:br0
+for i in 1 2; do
+  ip -net ns$i link set lo up
+  ip -net ns$i link set eth0 up
+  ip -net ns$i addr add 10.0.0.1$i/24 dev eth0
+done
+
+test_ebtables_broute()
+{
+	local cipt
+
+	# redirect is needed so the dstmac is rewritten to the bridge itself,
+	# ip stack won't process OTHERHOST (foreign unicast mac) packets.
+	ip netns exec ns0 ebtables -t broute -A BROUTING -p ipv4 --ip-protocol icmp -j redirect --redirect-target=DROP
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add ebtables broute redirect rule"
+		return $ksft_skip
+	fi
+
+	# ping netns1, expected to not work (ip forwarding is off)
+	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null 2>&1
+	if [ $? -eq 0 ]; then
+		echo "ERROR: ping works, should have failed" 1>&2
+		return 1
+	fi
+
+	# enable forwarding on both interfaces.
+	# neither needs an ip address, but at least the bridge needs
+	# an ip address in same network segment as ns1 and ns2 (ns0
+	# needs to be able to determine route for to-be-forwarded packet).
+	ip netns exec ns0 sysctl -q net.ipv4.conf.veth0.forwarding=1
+	ip netns exec ns0 sysctl -q net.ipv4.conf.veth1.forwarding=1
+
+	sleep 1
+
+	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null
+	if [ $? -ne 0 ]; then
+		echo "ERROR: ping did not work, but it should (broute+forward)" 1>&2
+		return 1
+	fi
+
+	echo "PASS: ns1/ns2 connectivity with active broute rule"
+	ip netns exec ns0 ebtables -t broute -F
+
+	# ping netns1, expected to work (frames are bridged)
+	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null
+	if [ $? -ne 0 ]; then
+		echo "ERROR: ping did not work, but it should (bridged)" 1>&2
+		return 1
+	fi
+
+	ip netns exec ns0 ebtables -t filter -A FORWARD -p ipv4 --ip-protocol icmp -j DROP
+
+	# ping netns1, expected to not work (DROP in bridge forward)
+	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null 2>&1
+	if [ $? -eq 0 ]; then
+		echo "ERROR: ping works, should have failed (icmp forward drop)" 1>&2
+		return 1
+	fi
+
+	# re-activate brouter
+	ip netns exec ns0 ebtables -t broute -A BROUTING -p ipv4 --ip-protocol icmp -j redirect --redirect-target=DROP
+
+	ip netns exec ns2 ping -q -c 1 10.0.0.11 > /dev/null
+	if [ $? -ne 0 ]; then
+		echo "ERROR: ping did not work, but it should (broute+forward 2)" 1>&2
+		return 1
+	fi
+
+	echo "PASS: ns1/ns2 connectivity with active broute rule and bridge forward drop"
+	return 0
+}
+
+# test basic connectivity
+ip netns exec ns1 ping -c 1 -q 10.0.0.12 > /dev/null
+if [ $? -ne 0 ]; then
+    echo "ERROR: Could not reach ns2 from ns1" 1>&2
+    ret=1
+fi
+
+ip netns exec ns2 ping -c 1 -q 10.0.0.11 > /dev/null
+if [ $? -ne 0 ]; then
+    echo "ERROR: Could not reach ns1 from ns2" 1>&2
+    ret=1
+fi
+
+if [ $ret -eq 0 ];then
+    echo "PASS: netns connectivity: ns1 and ns2 can reach each other"
+fi
+
+test_ebtables_broute
+ret=$?
+for i in 0 1 2; do ip netns del ns$i;done
+
+exit $ret
-- 
2.11.0

