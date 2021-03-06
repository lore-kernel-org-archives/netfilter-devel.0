Return-Path: <SRS0=HMuw=IE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6732CC43332
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC436501B
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhCFMMx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 07:12:53 -0500
Received: from correo.us.es ([193.147.175.20]:46374 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230417AbhCFMMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 183F9C517C
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 089D8DA792
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F1F2ADA78F; Sat,  6 Mar 2021 13:12:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AF71DA704;
        Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 610A442DC6E2;
        Sat,  6 Mar 2021 13:12:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/9] selftests: netfilter: test nat port clash resolution interaction with tcp early demux
Date:   Sat,  6 Mar 2021 13:12:19 +0100
Message-Id: <20210306121223.28711-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Convert Antonio Ojeas bug reproducer to a kselftest.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.20.1

