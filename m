Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87044C282CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54036206A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfDVUsM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:12 -0400
Received: from mail.us.es ([193.147.175.20]:46690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbfDVUsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E047443829
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E9DADA704
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53F41DA703; Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94316DA706;
        Mon, 22 Apr 2019 22:48:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6300E4265A5B;
        Mon, 22 Apr 2019 22:48:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/10] selftests: netfilter: check icmp pkttoobig errors are set as related
Date:   Mon, 22 Apr 2019 22:47:52 +0200
Message-Id: <20190422204801.26321-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190422204801.26321-1-pablo@netfilter.org>
References: <20190422204801.26321-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When an icmp error such as pkttoobig is received, conntrack checks
if the "inner" header (header of packet that did not fit link mtu)
is matches an existing connection, and, if so, sets that packet as
being related to the conntrack entry it found.

It was recently reported that this "related" setting also works
if the inner header is from another, different connection (i.e.,
artificial/forged icmp error).

Add a test, followup patch will add additional "inner dst matches
outer dst in reverse direction" check before setting related state.

Link: https://www.synacktiv.com/posts/systems/icmp-reachable.html
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  | 283 +++++++++++++++++++++
 2 files changed, 284 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_icmp_related.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index c9ff2b47bd1c..a37cb1192c6a 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for netfilter selftests
 
-TEST_PROGS := nft_trans_stress.sh nft_nat.sh
+TEST_PROGS := nft_trans_stress.sh nft_nat.sh conntrack_icmp_related.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/conntrack_icmp_related.sh b/tools/testing/selftests/netfilter/conntrack_icmp_related.sh
new file mode 100755
index 000000000000..b48e1833bc89
--- /dev/null
+++ b/tools/testing/selftests/netfilter/conntrack_icmp_related.sh
@@ -0,0 +1,283 @@
+#!/bin/bash
+#
+# check that ICMP df-needed/pkttoobig icmp are set are set as related
+# state
+#
+# Setup is:
+#
+# nsclient1 -> nsrouter1 -> nsrouter2 -> nsclient2
+# MTU 1500, except for nsrouter2 <-> nsclient2 link (1280).
+# ping nsclient2 from nsclient1, checking that conntrack did set RELATED
+# 'fragmentation needed' icmp packet.
+#
+# In addition, nsrouter1 will perform IP masquerading, i.e. also
+# check the icmp errors are propagated to the correct host as per
+# nat of "established" icmp-echo "connection".
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
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
+cleanup() {
+	for i in 1 2;do ip netns del nsclient$i;done
+	for i in 1 2;do ip netns del nsrouter$i;done
+}
+
+ipv4() {
+    echo -n 192.168.$1.2
+}
+
+ipv6 () {
+    echo -n dead:$1::2
+}
+
+check_counter()
+{
+	ns=$1
+	name=$2
+	expect=$3
+	local lret=0
+
+	cnt=$(ip netns exec $ns nft list counter inet filter "$name" | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		echo "ERROR: counter $name in $ns has unexpected value (expected $expect)" 1>&2
+		ip netns exec $ns nft list counter inet filter "$name" 1>&2
+		lret=1
+	fi
+
+	return $lret
+}
+
+check_unknown()
+{
+	expect="packets 0 bytes 0"
+	for n in nsclient1 nsclient2 nsrouter1 nsrouter2; do
+		check_counter $n "unknown" "$expect"
+		if [ $? -ne 0 ] ;then
+			return 1
+		fi
+	done
+
+	return 0
+}
+
+for n in nsclient1 nsclient2 nsrouter1 nsrouter2; do
+  ip netns add $n
+  ip -net $n link set lo up
+done
+
+DEV=veth0
+ip link add $DEV netns nsclient1 type veth peer name eth1 netns nsrouter1
+DEV=veth0
+ip link add $DEV netns nsclient2 type veth peer name eth1 netns nsrouter2
+
+DEV=veth0
+ip link add $DEV netns nsrouter1 type veth peer name eth2 netns nsrouter2
+
+DEV=veth0
+for i in 1 2; do
+    ip -net nsclient$i link set $DEV up
+    ip -net nsclient$i addr add $(ipv4 $i)/24 dev $DEV
+    ip -net nsclient$i addr add $(ipv6 $i)/64 dev $DEV
+done
+
+ip -net nsrouter1 link set eth1 up
+ip -net nsrouter1 link set veth0 up
+
+ip -net nsrouter2 link set eth1 up
+ip -net nsrouter2 link set eth2 up
+
+ip -net nsclient1 route add default via 192.168.1.1
+ip -net nsclient1 -6 route add default via dead:1::1
+
+ip -net nsclient2 route add default via 192.168.2.1
+ip -net nsclient2 route add default via dead:2::1
+
+i=3
+ip -net nsrouter1 addr add 192.168.1.1/24 dev eth1
+ip -net nsrouter1 addr add 192.168.3.1/24 dev veth0
+ip -net nsrouter1 addr add dead:1::1/64 dev eth1
+ip -net nsrouter1 addr add dead:3::1/64 dev veth0
+ip -net nsrouter1 route add default via 192.168.3.10
+ip -net nsrouter1 -6 route add default via dead:3::10
+
+ip -net nsrouter2 addr add 192.168.2.1/24 dev eth1
+ip -net nsrouter2 addr add 192.168.3.10/24 dev eth2
+ip -net nsrouter2 addr add dead:2::1/64 dev eth1
+ip -net nsrouter2 addr add dead:3::10/64 dev eth2
+ip -net nsrouter2 route add default via 192.168.3.1
+ip -net nsrouter2 route add default via dead:3::1
+
+sleep 2
+for i in 4 6; do
+	ip netns exec nsrouter1 sysctl -q net.ipv$i.conf.all.forwarding=1
+	ip netns exec nsrouter2 sysctl -q net.ipv$i.conf.all.forwarding=1
+done
+
+for netns in nsrouter1 nsrouter2; do
+ip netns exec $netns nft -f - <<EOF
+table inet filter {
+	counter unknown { }
+	counter related { }
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+		meta l4proto icmpv6 icmpv6 type "packet-too-big" ct state "related" counter name "related" accept
+		meta l4proto icmp icmp type "destination-unreachable" ct state "related" counter name "related" accept
+		meta l4proto { icmp, icmpv6 } ct state new,established accept
+		counter name "unknown" drop
+	}
+}
+EOF
+done
+
+ip netns exec nsclient1 nft -f - <<EOF
+table inet filter {
+	counter unknown { }
+	counter related { }
+	chain input {
+		type filter hook input priority 0; policy accept;
+		meta l4proto { icmp, icmpv6 } ct state established,untracked accept
+
+		meta l4proto { icmp, icmpv6 } ct state "related" counter name "related" accept
+		counter name "unknown" drop
+	}
+}
+EOF
+
+ip netns exec nsclient2 nft -f - <<EOF
+table inet filter {
+	counter unknown { }
+	counter new { }
+	counter established { }
+
+	chain input {
+		type filter hook input priority 0; policy accept;
+		meta l4proto { icmp, icmpv6 } ct state established,untracked accept
+
+		meta l4proto { icmp, icmpv6 } ct state "new" counter name "new" accept
+		meta l4proto { icmp, icmpv6 } ct state "established" counter name "established" accept
+		counter name "unknown" drop
+	}
+	chain output {
+		type filter hook output priority 0; policy accept;
+		meta l4proto { icmp, icmpv6 } ct state established,untracked accept
+
+		meta l4proto { icmp, icmpv6 } ct state "new" counter name "new"
+		meta l4proto { icmp, icmpv6 } ct state "established" counter name "established"
+		counter name "unknown" drop
+	}
+}
+EOF
+
+
+# make sure NAT core rewrites adress of icmp error if nat is used according to
+# conntrack nat information (icmp error will be directed at nsrouter1 address,
+# but it needs to be routed to nsclient1 address).
+ip netns exec nsrouter1 nft -f - <<EOF
+table ip nat {
+	chain postrouting {
+		type nat hook postrouting priority 0; policy accept;
+		ip protocol icmp oifname "veth0" counter masquerade
+	}
+}
+table ip6 nat {
+	chain postrouting {
+		type nat hook postrouting priority 0; policy accept;
+		ip6 nexthdr icmpv6 oifname "veth0" counter masquerade
+	}
+}
+EOF
+
+ip netns exec nsrouter2 ip link set eth1  mtu 1280
+ip netns exec nsclient2 ip link set veth0 mtu 1280
+sleep 1
+
+ip netns exec nsclient1 ping -c 1 -s 1000 -q -M do 192.168.2.2 >/dev/null
+if [ $? -ne 0 ]; then
+	echo "ERROR: netns ip routing/connectivity broken" 1>&2
+	cleanup
+	exit 1
+fi
+ip netns exec nsclient1 ping6 -q -c 1 -s 1000 dead:2::2 >/dev/null
+if [ $? -ne 0 ]; then
+	echo "ERROR: netns ipv6 routing/connectivity broken" 1>&2
+	cleanup
+	exit 1
+fi
+
+check_unknown
+if [ $? -ne 0 ]; then
+	ret=1
+fi
+
+expect="packets 0 bytes 0"
+for netns in nsrouter1 nsrouter2 nsclient1;do
+	check_counter "$netns" "related" "$expect"
+	if [ $? -ne 0 ]; then
+		ret=1
+	fi
+done
+
+expect="packets 2 bytes 2076"
+check_counter nsclient2 "new" "$expect"
+if [ $? -ne 0 ]; then
+	ret=1
+fi
+
+ip netns exec nsclient1 ping -q -c 1 -s 1300 -M do 192.168.2.2 > /dev/null
+if [ $? -eq 0 ]; then
+	echo "ERROR: ping should have failed with PMTU too big error" 1>&2
+	ret=1
+fi
+
+# nsrouter2 should have generated the icmp error, so
+# related counter should be 0 (its in forward).
+expect="packets 0 bytes 0"
+check_counter "nsrouter2" "related" "$expect"
+if [ $? -ne 0 ]; then
+	ret=1
+fi
+
+# but nsrouter1 should have seen it, same for nsclient1.
+expect="packets 1 bytes 576"
+for netns in nsrouter1 nsclient1;do
+	check_counter "$netns" "related" "$expect"
+	if [ $? -ne 0 ]; then
+		ret=1
+	fi
+done
+
+ip netns exec nsclient1 ping6 -c 1 -s 1300 dead:2::2 > /dev/null
+if [ $? -eq 0 ]; then
+	echo "ERROR: ping6 should have failed with PMTU too big error" 1>&2
+	ret=1
+fi
+
+expect="packets 2 bytes 1856"
+for netns in nsrouter1 nsclient1;do
+	check_counter "$netns" "related" "$expect"
+	if [ $? -ne 0 ]; then
+		ret=1
+	fi
+done
+
+if [ $ret -eq 0 ];then
+	echo "PASS: icmp mtu error had RELATED state"
+else
+	echo "ERROR: icmp error RELATED state test has failed"
+fi
+
+cleanup
+exit $ret
-- 
2.11.0

