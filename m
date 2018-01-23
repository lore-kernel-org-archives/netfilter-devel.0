From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/6] tests: shell: add flowtable tests
Date: Tue, 23 Jan 2018 13:16:21 +0100
Message-ID: <20180123121622.16287-5-pablo@netfilter.org>
References: <20180123121622.16287-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44828 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751393AbeAWMQh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 07:16:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA1002519A6
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4A45DA842
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 693D6DA845
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:30 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 327D441E4817
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:30 +0100 (CET)
In-Reply-To: <20180123121622.16287-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add basic flowtable tests.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/run-tests.sh                           |  4 ++-
 tests/shell/testcases/flowtable/0001flowtable_0    | 33 ++++++++++++++++++++++
 .../testcases/flowtable/0002create_flowtable_0     | 12 ++++++++
 .../testcases/flowtable/0003add_after_flush_0      |  8 ++++++
 .../testcases/flowtable/0004delete_after_add0      |  6 ++++
 .../shell/testcases/flowtable/0005delete_in_use_1  |  9 ++++++
 6 files changed, 71 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/flowtable/0001flowtable_0
 create mode 100755 tests/shell/testcases/flowtable/0002create_flowtable_0
 create mode 100755 tests/shell/testcases/flowtable/0003add_after_flush_0
 create mode 100755 tests/shell/testcases/flowtable/0004delete_after_add0
 create mode 100755 tests/shell/testcases/flowtable/0005delete_in_use_1

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index fe30115e0807..3eee99dfb739 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -68,7 +68,9 @@ kernel_cleanup() {
 	nft_set_hash nft_set_rbtree nft_set_bitmap \
 	nft_chain_nat_ipv4 nft_chain_nat_ipv6 \
 	nf_tables_inet nf_tables_bridge nf_tables_arp \
-	nf_tables_ipv4 nf_tables_ipv6 nf_tables
+	nf_tables_ipv4 nf_tables_ipv6 nf_tables \
+	nf_flow_table nf_flow_table_ipv4 nf_flow_tables_ipv6 \
+	nf_flow_table_inet nft_flow_offload
 }
 
 find_tests() {
diff --git a/tests/shell/testcases/flowtable/0001flowtable_0 b/tests/shell/testcases/flowtable/0001flowtable_0
new file mode 100755
index 000000000000..307f06f62ebd
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0001flowtable_0
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+
+EXPECTED='table inet t {
+	flowtable f {
+		hook ingress priority 10
+		devices = { eth0, wlan0 }
+	}
+
+	chain c {
+		flow offload @f
+	}
+}'
+
+echo "$EXPECTED" > $tmpfile
+set -e
+$NFT -f $tmpfile
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/flowtable/0002create_flowtable_0 b/tests/shell/testcases/flowtable/0002create_flowtable_0
new file mode 100755
index 000000000000..b6941c58eea9
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0002create_flowtable_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+set -e
+$NFT add table t
+$NFT add flowtable t f { hook ingress priority 10 \; devices = { eth0, wlan0 }\; }
+if $NFT create flowtable t f { hook ingress priority 10 \; devices = { eth0, wlan0 }\; } 2>/dev/null ; then
+	echo "E: flowtable creation not failing on existing set" >&2
+	exit 1
+fi
+$NFT add flowtable t f { hook ingress priority 10 \; devices = { eth0, wlan0 }\; }
+
+exit 0
diff --git a/tests/shell/testcases/flowtable/0003add_after_flush_0 b/tests/shell/testcases/flowtable/0003add_after_flush_0
new file mode 100755
index 000000000000..1f3cb18a46d9
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0003add_after_flush_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+$NFT add table x
+$NFT add flowtable x y { hook ingress priority 0\; devices = { eth0, wlan0 }\;}
+$NFT flush ruleset
+$NFT add table x
+$NFT add flowtable x y { hook ingress priority 0\; devices = { eth0, wlan0 }\;}
diff --git a/tests/shell/testcases/flowtable/0004delete_after_add0 b/tests/shell/testcases/flowtable/0004delete_after_add0
new file mode 100755
index 000000000000..b72977b37ce6
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0004delete_after_add0
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+$NFT add table x
+$NFT add flowtable x y { hook ingress priority 0\; devices = { eth0, wlan0 }\;}
+$NFT delete flowtable x y
diff --git a/tests/shell/testcases/flowtable/0005delete_in_use_1 b/tests/shell/testcases/flowtable/0005delete_in_use_1
new file mode 100755
index 000000000000..ce39e24e601d
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0005delete_in_use_1
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+$NFT add table x
+$NFT add chain x x
+$NFT add flowtable x y { hook ingress priority 0\; devices = { eth0, wlan0 }\;}
+$NFT add rule x x flow offload @y
+$NFT delete flowtable x y
+echo "E: delete flowtable in use"
-- 
2.11.0

