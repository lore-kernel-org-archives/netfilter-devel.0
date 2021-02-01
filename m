Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5C0C433E6
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F77764E2A
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhBARBI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:01:08 -0500
Received: from correo.us.es ([193.147.175.20]:52498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhBARBF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:01:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B431712BFF6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 18:00:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2D58DA72F
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 18:00:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9860DDA78E; Mon,  1 Feb 2021 18:00:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35E1BDA78B;
        Mon,  1 Feb 2021 18:00:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Feb 2021 18:00:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1BFCA42DC6DD;
        Mon,  1 Feb 2021 18:00:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     arturo@netfilter.org
Subject: [PATCH conntrack-tools] tests: conntrackd: move basic netns scenario setup to shell script
Date:   Mon,  1 Feb 2021 18:00:15 +0100
Message-Id: <20210201170015.28217-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows for running the script away from the test infrastructure,
which is convenient when developing new tests. This also allows for
reusing the same netns setup from new tests.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/conntrackd/scenarios.yaml               | 29 +--------
 .../scenarios/basic/network-setup.sh          | 59 +++++++++++++++++++
 2 files changed, 61 insertions(+), 27 deletions(-)
 create mode 100755 tests/conntrackd/scenarios/basic/network-setup.sh

diff --git a/tests/conntrackd/scenarios.yaml b/tests/conntrackd/scenarios.yaml
index 798d9ebafece..6c425d04c64e 100644
--- a/tests/conntrackd/scenarios.yaml
+++ b/tests/conntrackd/scenarios.yaml
@@ -20,29 +20,7 @@
 
 - name: basic_2_peer_network_tcp_notrack
   start:
-    - ip netns add ns1
-    - ip netns add ns2
-    - ip netns add nsr1
-    - ip netns add nsr2
-    - ip link add veth0 netns ns1 type veth peer name veth1 netns nsr1
-    - ip link add veth0 netns nsr1 type veth peer name veth0 netns ns2
-    - ip link add veth2 netns nsr1 type veth peer name veth0 netns nsr2
-    - ip -net ns1 addr add 192.168.10.2/24 dev veth0
-    - ip -net ns1 link set up dev veth0
-    - ip -net ns1 ro add 10.0.1.0/24 via 192.168.10.1 dev veth0
-    - ip -net nsr1 addr add 10.0.1.1/24 dev veth0
-    - ip -net nsr1 addr add 192.168.10.1/24 dev veth1
-    - ip -net nsr1 link set up dev veth0
-    - ip -net nsr1 link set up dev veth1
-    - ip -net nsr1 route add default via 192.168.10.2
-    - ip netns exec nsr1 sysctl -q net.ipv4.ip_forward=1
-    - ip -net nsr1 addr add 192.168.100.2/24 dev veth2
-    - ip -net nsr1 link set up dev veth2
-    - ip -net nsr2 addr add 192.168.100.3/24 dev veth0
-    - ip -net nsr2 link set up dev veth0
-    - ip -net ns2 addr add 10.0.1.2/24 dev veth0
-    - ip -net ns2 link set up dev veth0
-    - ip -net ns2 route add default via 10.0.1.1
+    - scenarios/basic/./network-setup.sh start
     - |
       cat << EOF > /tmp/ruleset.nft
       table ip filter {
@@ -114,7 +92,4 @@
     - $CONNTRACKD -C /tmp/nsr2.conf -k 2>/dev/null
     - rm -f /tmp/ruleset.nft /tmp/nsr2.conf /tmp/nsr1.conf
     - rm -f /var/lock/conntrack-nsr1.lock /var/lock/conntrack-nsr2.lock
-    - ip netns del ns1 || true
-    - ip netns del ns2 || true
-    - ip netns del nsr1 || true
-    - ip netns del nsr2 || true
+    - scenarios/basic/./network-setup.sh stop
diff --git a/tests/conntrackd/scenarios/basic/network-setup.sh b/tests/conntrackd/scenarios/basic/network-setup.sh
new file mode 100755
index 000000000000..ff8df26d6a1e
--- /dev/null
+++ b/tests/conntrackd/scenarios/basic/network-setup.sh
@@ -0,0 +1,59 @@
+#!/bin/bash
+
+if [ $UID -ne 0 ]
+then
+	echo "You must be root to run this test script"
+	exit 0
+fi
+
+start () {
+	ip netns add ns1
+	ip netns add ns2
+	ip netns add nsr1
+	ip netns add nsr2
+
+	ip link add veth0 netns ns1 type veth peer name veth1 netns nsr1
+	ip link add veth0 netns nsr1 type veth peer name veth0 netns ns2
+	ip link add veth2 netns nsr1 type veth peer name veth0 netns nsr2
+
+	ip -net ns1 addr add 192.168.10.2/24 dev veth0
+	ip -net ns1 link set up dev veth0
+	ip -net ns1 ro add 10.0.1.0/24 via 192.168.10.1 dev veth0
+
+	ip -net nsr1 addr add 10.0.1.1/24 dev veth0
+	ip -net nsr1 addr add 192.168.10.1/24 dev veth1
+	ip -net nsr1 link set up dev veth0
+	ip -net nsr1 link set up dev veth1
+	ip -net nsr1 route add default via 192.168.10.2
+	ip netns exec nsr1 sysctl net.ipv4.ip_forward=1
+
+	ip -net nsr1 addr add 192.168.100.2/24 dev veth2
+	ip -net nsr1 link set up dev veth2
+	ip -net nsr2 addr add 192.168.100.3/24 dev veth0
+	ip -net nsr2 link set up dev veth0
+
+	ip -net ns2 addr add 10.0.1.2/24 dev veth0
+	ip -net ns2 link set up dev veth0
+	ip -net ns2 route add default via 10.0.1.1
+}
+
+stop () {
+	ip netns del ns1
+	ip netns del ns2
+	ip netns del nsr1
+	ip netns del nsr2
+}
+
+case $1 in
+start)
+	start
+	;;
+stop)
+	stop
+	;;
+*)
+	echo "$0 [start|stop]"
+	;;
+esac
+
+exit 0
-- 
2.20.1

