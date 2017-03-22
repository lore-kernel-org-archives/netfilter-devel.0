From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/3] tests: Add test cases for nested anonymous sets
Date: Wed, 22 Mar 2017 01:26:34 +0100
Message-ID: <20170322002636.14081-1-phil@nwl.cc>
References: <20170321131902.GA30047@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56081 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757867AbdCVA1d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 20:27:33 -0400
In-Reply-To: <20170321131902.GA30047@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes sure nesting of anonymous sets works regardless of whether
defines are used or not. As a side-effect, it also checks that overlap
checking when IP address prefixes are used, works.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip/sets.t                       |  4 +++
 tests/py/ip/sets.t.payload.inet          | 19 +++++++++++++
 tests/py/ip/sets.t.payload.ip            | 15 +++++++++++
 tests/py/ip/sets.t.payload.netdev        | 19 +++++++++++++
 tests/shell/testcases/sets/0021nesting_0 | 46 ++++++++++++++++++++++++++++++++
 5 files changed, 103 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0021nesting_0

diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index 4cca02b61ff04..4d14e8253e528 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -46,3 +46,7 @@ ip saddr != @set33 drop;fail
 ?set4 192.168.2.0/24;ok
 ?set4 192.168.1.1;fail
 ?set4 192.168.3.0/24;ok
+
+# test nested anonymous sets
+ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 };ok;ip saddr { 1.1.1.0, 2.2.2.0, 3.3.3.0 }
+ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 };ok;ip saddr { 1.1.1.0/24, 2.2.2.0/24, 3.3.3.0/24 }
diff --git a/tests/py/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
index 6d8d6bc3bbce6..35f699c7a13b4 100644
--- a/tests/py/ip/sets.t.payload.inet
+++ b/tests/py/ip/sets.t.payload.inet
@@ -30,3 +30,22 @@ inet test-inet input
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 }
+__set%d t 3
+__set%d t 0
+	element 00010101  : 0 [end]	element 00030303  : 0 [end]	element 00020202  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 }
+__set%d t 7
+__set%d t 0
+	element 00000000  : 1 [end]	element 00010101  : 0 [end]	element 00020101  : 1 [end]	element 00020202  : 0 [end]	element 00030202  : 1 [end]	element 00030303  : 0 [end]	element 00040303  : 1 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/py/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
index 858a5e1c6bb3e..891a1ee404c7f 100644
--- a/tests/py/ip/sets.t.payload.ip
+++ b/tests/py/ip/sets.t.payload.ip
@@ -22,3 +22,18 @@ ip test-ip4 input
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 }
+__set%d test-ip4 3
+__set%d test-ip4 0
+	element 00010101  : 0 [end]	element 00030303  : 0 [end]	element 00020202  : 0 [end]
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 }
+__set%d test-ip4 7
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00010101  : 0 [end]	element 00020101  : 1 [end]	element 00020202  : 0 [end]	element 00030202  : 1 [end]	element 00030303  : 0 [end]	element 00040303  : 1 [end]
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
index 87d54a0f4813e..ae8b6e7c8c46f 100644
--- a/tests/py/ip/sets.t.payload.netdev
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -30,3 +30,22 @@ netdev test-netdev ingress
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 drop ]
 
+# ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 }
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00010101  : 0 [end]	element 00030303  : 0 [end]	element 00020202  : 0 [end]
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# ip saddr { { 1.1.1.0/24, 3.3.3.0/24 }, 2.2.2.0/24 }
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00010101  : 0 [end]	element 00020101  : 1 [end]	element 00020202  : 0 [end]	element 00030202  : 1 [end]	element 00030303  : 0 [end]	element 00040303  : 1 [end]
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/shell/testcases/sets/0021nesting_0 b/tests/shell/testcases/sets/0021nesting_0
new file mode 100755
index 0000000000000..3bcb61473198c
--- /dev/null
+++ b/tests/shell/testcases/sets/0021nesting_0
@@ -0,0 +1,46 @@
+#!/bin/bash
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+#trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET='
+define set1 = {
+	2.2.2.0/24,
+}
+define set2 = {
+	$set1,
+	1.1.1.0/24
+}
+table ip x {
+	chain y {
+		ip saddr { 3.3.3.0/24, $set2 }
+	}
+}'
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	chain y {
+		ip saddr { 1.1.1.0/24, 2.2.2.0/24, 3.3.3.0/24}
+	}
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.11.0

