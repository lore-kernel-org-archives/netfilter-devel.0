From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 4/4] tests/operations: add some listing tests
Date: Mon, 04 Jan 2016 13:18:42 +0100
Message-ID: <145190992226.22285.6986028051299342181.stgit@r2d2.cica.es>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47726 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522AbcADMSt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 07:18:49 -0500
In-Reply-To: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's test what is shown with the 'list' command, for ruleset, tables and sets.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/listing/0001ruleset_0        |   10 ++++
 tests/shell/testcases/listing/0002ruleset_1        |   10 ++++
 tests/shell/testcases/listing/0003table_0          |   13 +++++
 tests/shell/testcases/listing/0004table_1          |   10 ++++
 tests/shell/testcases/listing/0005ruleset_ip_0     |   15 +++++
 tests/shell/testcases/listing/0006ruleset_ip6_0    |   15 +++++
 tests/shell/testcases/listing/0007ruleset_inet_0   |   15 +++++
 tests/shell/testcases/listing/0008ruleset_arp_0    |   15 +++++
 tests/shell/testcases/listing/0009ruleset_bridge_0 |   15 +++++
 tests/shell/testcases/listing/0009sets_0           |   33 ++++++++++++
 tests/shell/testcases/listing/0010sets_0           |   57 ++++++++++++++++++++
 tests/shell/testcases/listing/0011sets_0           |   26 +++++++++
 12 files changed, 234 insertions(+)
 create mode 100755 tests/shell/testcases/listing/0001ruleset_0
 create mode 100755 tests/shell/testcases/listing/0002ruleset_1
 create mode 100755 tests/shell/testcases/listing/0003table_0
 create mode 100755 tests/shell/testcases/listing/0004table_1
 create mode 100755 tests/shell/testcases/listing/0005ruleset_ip_0
 create mode 100755 tests/shell/testcases/listing/0006ruleset_ip6_0
 create mode 100755 tests/shell/testcases/listing/0007ruleset_inet_0
 create mode 100755 tests/shell/testcases/listing/0008ruleset_arp_0
 create mode 100755 tests/shell/testcases/listing/0009ruleset_bridge_0
 create mode 100755 tests/shell/testcases/listing/0009sets_0
 create mode 100755 tests/shell/testcases/listing/0010sets_0
 create mode 100755 tests/shell/testcases/listing/0011sets_0

diff --git a/tests/shell/testcases/listing/0001ruleset_0 b/tests/shell/testcases/listing/0001ruleset_0
new file mode 100755
index 0000000..662dd1a
--- /dev/null
+++ b/tests/shell/testcases/listing/0001ruleset_0
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+# list ruleset shows a table
+
+EXPECTED="table ip test {
+}"
+
+$NFT add table test
+GET="$($NFT list ruleset)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0002ruleset_1 b/tests/shell/testcases/listing/0002ruleset_1
new file mode 100755
index 0000000..938936e
--- /dev/null
+++ b/tests/shell/testcases/listing/0002ruleset_1
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+# list ruleset don't show tables that dont exist
+
+EXPECTED="table ip test {
+}"
+
+$NFT add table test2
+GET="$($NFT list ruleset)"
+[ "$EXPECTED" == "$GET" ] && exit 1
diff --git a/tests/shell/testcases/listing/0003table_0 b/tests/shell/testcases/listing/0003table_0
new file mode 100755
index 0000000..9249154
--- /dev/null
+++ b/tests/shell/testcases/listing/0003table_0
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+# list table show what is expected
+
+EXPECTED="table ip test {
+}"
+
+$NFT add table test
+GET="$($NFT list table test)"
+[ "$EXPECTED" == "$GET" ] || exit 1
+
+GET="$($NFT list table ip test)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0004table_1 b/tests/shell/testcases/listing/0004table_1
new file mode 100755
index 0000000..617a935
--- /dev/null
+++ b/tests/shell/testcases/listing/0004table_1
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+# list table can't show tables that dont exist
+
+EXPECTED="table ip test a {
+}"
+
+$NFT add table test2
+GET="$($NFT list table test)"
+[ "$EXPECTED" == "$GET" ] && exit 1
diff --git a/tests/shell/testcases/listing/0005ruleset_ip_0 b/tests/shell/testcases/listing/0005ruleset_ip_0
new file mode 100755
index 0000000..d70bc9b
--- /dev/null
+++ b/tests/shell/testcases/listing/0005ruleset_ip_0
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table ip test {
+}"
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset ip)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0006ruleset_ip6_0 b/tests/shell/testcases/listing/0006ruleset_ip6_0
new file mode 100755
index 0000000..f9f718b
--- /dev/null
+++ b/tests/shell/testcases/listing/0006ruleset_ip6_0
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table ip6 test {
+}"
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset ip6)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0007ruleset_inet_0 b/tests/shell/testcases/listing/0007ruleset_inet_0
new file mode 100755
index 0000000..428e9a8
--- /dev/null
+++ b/tests/shell/testcases/listing/0007ruleset_inet_0
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table inet test {
+}"
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset inet)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0008ruleset_arp_0 b/tests/shell/testcases/listing/0008ruleset_arp_0
new file mode 100755
index 0000000..9a8b054
--- /dev/null
+++ b/tests/shell/testcases/listing/0008ruleset_arp_0
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table arp test {
+}"
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset arp)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0009ruleset_bridge_0 b/tests/shell/testcases/listing/0009ruleset_bridge_0
new file mode 100755
index 0000000..e914aeb
--- /dev/null
+++ b/tests/shell/testcases/listing/0009ruleset_bridge_0
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table bridge test {
+}"
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset bridge)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0009sets_0 b/tests/shell/testcases/listing/0009sets_0
new file mode 100755
index 0000000..d92c5b1
--- /dev/null
+++ b/tests/shell/testcases/listing/0009sets_0
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+# listing all sets, filtering by family
+
+EXPECTED="table inet filter {
+	set set0 {
+		type inet_service
+	}
+	set set1 {
+		type inet_service
+		flags constant
+	}
+	set set2 {
+		type icmpv6_type
+	}
+}"
+
+$NFT add table ip nat
+$NFT add set ip nat ssh { type ipv4_addr \; }
+$NFT add table ip6 test
+$NFT add set ip6 test testset { type ipv6_addr \; }
+$NFT add table arp test_arp
+$NFT add set arp test_arp test_set_arp00 { type inet_service \; }
+$NFT add set arp test_arp test_set_arp01 { type inet_service \; flags constant \; }
+$NFT add table bridge test_bridge
+$NFT add set bridge test_bridge test_set_bridge { type inet_service \; }
+$NFT add table inet filter
+$NFT add set inet filter set0 { type inet_service \; }
+$NFT add set inet filter set1 { type inet_service \; flags constant \; }
+$NFT add set inet filter set2 { type icmpv6_type \; }
+
+GET="$($NFT list sets inet)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0010sets_0 b/tests/shell/testcases/listing/0010sets_0
new file mode 100755
index 0000000..547b8c4
--- /dev/null
+++ b/tests/shell/testcases/listing/0010sets_0
@@ -0,0 +1,57 @@
+#!/bin/bash
+
+# listing all sets
+
+EXPECTED="table ip nat {
+	set ssh {
+		type ipv4_addr
+	}
+}
+table ip6 test {
+	set testset {
+		type ipv6_addr
+	}
+}
+table inet filter {
+	set set0 {
+		type inet_service
+	}
+	set set1 {
+		type inet_service
+		flags constant
+	}
+	set set2 {
+		type icmpv6_type
+	}
+}
+table bridge test_bridge {
+	set test_set_bridge {
+		type inet_service
+	}
+}
+table arp test_arp {
+	set test_set_arp00 {
+		type inet_service
+	}
+	set test_set_arp01 {
+		type inet_service
+		flags constant
+	}
+}"
+
+$NFT add table ip nat
+$NFT add set ip nat ssh { type ipv4_addr \; }
+$NFT add table ip6 test
+$NFT add set ip6 test testset { type ipv6_addr \; }
+$NFT add table arp test_arp
+$NFT add set arp test_arp test_set_arp00 { type inet_service \; }
+$NFT add set arp test_arp test_set_arp01 { type inet_service \; flags constant \; }
+$NFT add table bridge test_bridge
+$NFT add set bridge test_bridge test_set_bridge { type inet_service \; }
+$NFT add table inet filter
+$NFT add set inet filter set0 { type inet_service \; }
+$NFT add set inet filter set1 { type inet_service \; flags constant \; }
+$NFT add set inet filter set2 { type icmpv6_type \; }
+
+GET="$($NFT list sets)"
+[ "$EXPECTED" == "$GET" ] || exit 1
diff --git a/tests/shell/testcases/listing/0011sets_0 b/tests/shell/testcases/listing/0011sets_0
new file mode 100755
index 0000000..514c6f1
--- /dev/null
+++ b/tests/shell/testcases/listing/0011sets_0
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# listing all sets, no anonymous sets allowed
+
+set -e
+$NFT add table ip nat
+$NFT add chain ip nat test
+$NFT add rule ip nat test tcp dport {123}
+
+$NFT add table ip6 test
+$NFT add chain ip6 test test
+$NFT add rule ip6 test test udp sport {123}
+
+$NFT add table arp test_arp
+$NFT add chain arp test_arp test
+$NFT add rule arp test_arp test meta nfproto {ipv4}
+
+$NFT add table bridge test_bridge
+$NFT add chain bridge test_bridge test
+$NFT add rule bridge test_bridge test ip daddr {1.1.1.1}
+
+$NFT add table inet filter
+$NFT add chain inet filter test
+$NFT add rule inet filter test tcp dport {80, 443}
+
+[ $($NFT list sets | wc -l) == 0 ] || exit 1

