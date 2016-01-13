From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v2] tests/listing: add some listing tests
Date: Wed, 13 Jan 2016 19:29:09 +0100
Message-ID: <145270955304.16020.15628702903369123172.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50178 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756011AbcAMS3S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 13:29:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's test what is shown with the 'list' command, for ruleset, tables and sets.

In order to ease debug in case of failure, if the diff tool is in the system,
then a textual diff is printed.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: the diff stuff and always set -e if possible, plus updates regarding
    discarded patch in v1 series.

 tests/shell/testcases/listing/0001ruleset_0        |   18 ++++++
 tests/shell/testcases/listing/0002ruleset_0        |   16 +++++
 tests/shell/testcases/listing/0003table_0          |   25 ++++++++
 tests/shell/testcases/listing/0004table_0          |   19 ++++++
 tests/shell/testcases/listing/0005ruleset_ip_0     |   21 +++++++
 tests/shell/testcases/listing/0006ruleset_ip6_0    |   21 +++++++
 tests/shell/testcases/listing/0007ruleset_inet_0   |   21 +++++++
 tests/shell/testcases/listing/0008ruleset_arp_0    |   21 +++++++
 tests/shell/testcases/listing/0009ruleset_bridge_0 |   21 +++++++
 tests/shell/testcases/listing/0010sets_0           |   63 ++++++++++++++++++++
 tests/shell/testcases/listing/0011sets_0           |   44 ++++++++++++++
 tests/shell/testcases/listing/0012sets_0           |   39 ++++++++++++
 12 files changed, 329 insertions(+)
 create mode 100755 tests/shell/testcases/listing/0001ruleset_0
 create mode 100755 tests/shell/testcases/listing/0002ruleset_0
 create mode 100755 tests/shell/testcases/listing/0003table_0
 create mode 100755 tests/shell/testcases/listing/0004table_0
 create mode 100755 tests/shell/testcases/listing/0005ruleset_ip_0
 create mode 100755 tests/shell/testcases/listing/0006ruleset_ip6_0
 create mode 100755 tests/shell/testcases/listing/0007ruleset_inet_0
 create mode 100755 tests/shell/testcases/listing/0008ruleset_arp_0
 create mode 100755 tests/shell/testcases/listing/0009ruleset_bridge_0
 create mode 100755 tests/shell/testcases/listing/0010sets_0
 create mode 100755 tests/shell/testcases/listing/0011sets_0
 create mode 100755 tests/shell/testcases/listing/0012sets_0

diff --git a/tests/shell/testcases/listing/0001ruleset_0 b/tests/shell/testcases/listing/0001ruleset_0
new file mode 100755
index 0000000..1a3a73b
--- /dev/null
+++ b/tests/shell/testcases/listing/0001ruleset_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+# list ruleset shows a table
+
+EXPECTED="table ip test {
+}"
+
+set -e
+
+$NFT add table test
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
diff --git a/tests/shell/testcases/listing/0002ruleset_0 b/tests/shell/testcases/listing/0002ruleset_0
new file mode 100755
index 0000000..916034f
--- /dev/null
+++ b/tests/shell/testcases/listing/0002ruleset_0
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+# list ruleset show nothing if emtpy ruleset
+
+EXPECTED=""
+
+set -e
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
diff --git a/tests/shell/testcases/listing/0003table_0 b/tests/shell/testcases/listing/0003table_0
new file mode 100755
index 0000000..1b288e4
--- /dev/null
+++ b/tests/shell/testcases/listing/0003table_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# list table show what is expected
+
+EXPECTED="table ip test {
+}"
+
+set -e
+
+$NFT add table test
+
+GET="$($NFT list table test)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+# also this way
+GET="$($NFT list table ip test)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0004table_0 b/tests/shell/testcases/listing/0004table_0
new file mode 100755
index 0000000..2c7c995
--- /dev/null
+++ b/tests/shell/testcases/listing/0004table_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+# list table only show table asked for
+
+EXPECTED="table ip test {
+}"
+
+set -e
+
+$NFT add table test
+$NFT add table test2
+
+GET="$($NFT list table test)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
diff --git a/tests/shell/testcases/listing/0005ruleset_ip_0 b/tests/shell/testcases/listing/0005ruleset_ip_0
new file mode 100755
index 0000000..c326680
--- /dev/null
+++ b/tests/shell/testcases/listing/0005ruleset_ip_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table ip test {
+}"
+
+set -e
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset ip)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0006ruleset_ip6_0 b/tests/shell/testcases/listing/0006ruleset_ip6_0
new file mode 100755
index 0000000..093d5a5
--- /dev/null
+++ b/tests/shell/testcases/listing/0006ruleset_ip6_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table ip6 test {
+}"
+
+set -e
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset ip6)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0007ruleset_inet_0 b/tests/shell/testcases/listing/0007ruleset_inet_0
new file mode 100755
index 0000000..b24cc4c
--- /dev/null
+++ b/tests/shell/testcases/listing/0007ruleset_inet_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table inet test {
+}"
+
+set -e
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset inet)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0008ruleset_arp_0 b/tests/shell/testcases/listing/0008ruleset_arp_0
new file mode 100755
index 0000000..fff0fee
--- /dev/null
+++ b/tests/shell/testcases/listing/0008ruleset_arp_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table arp test {
+}"
+
+set -e
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset arp)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0009ruleset_bridge_0 b/tests/shell/testcases/listing/0009ruleset_bridge_0
new file mode 100755
index 0000000..247ed47
--- /dev/null
+++ b/tests/shell/testcases/listing/0009ruleset_bridge_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# listing ruleset per family
+
+EXPECTED="table bridge test {
+}"
+
+set -e
+
+$NFT add table ip test
+$NFT add table ip6 test
+$NFT add table inet test
+$NFT add table arp test
+$NFT add table bridge test
+
+GET="$($NFT list ruleset bridge)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0010sets_0 b/tests/shell/testcases/listing/0010sets_0
new file mode 100755
index 0000000..42d60b4
--- /dev/null
+++ b/tests/shell/testcases/listing/0010sets_0
@@ -0,0 +1,63 @@
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
+table arp test_arp {
+	set test_set_arp00 {
+		type inet_service
+	}
+	set test_set_arp01 {
+		type inet_service
+		flags constant
+	}
+}
+table bridge test_bridge {
+	set test_set_bridge {
+		type inet_service
+	}
+}"
+
+set -e
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
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0011sets_0 b/tests/shell/testcases/listing/0011sets_0
new file mode 100755
index 0000000..1bf6887
--- /dev/null
+++ b/tests/shell/testcases/listing/0011sets_0
@@ -0,0 +1,44 @@
+#!/bin/bash
+
+# listing all sets, no anonymous sets allowed
+
+EXPECTED="table ip nat {
+}
+table ip6 test {
+}
+table inet filter {
+}
+table arp test_arp {
+}
+table bridge test_bridge {
+}"
+
+set -e
+
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
+GET="$($NFT list sets)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/listing/0012sets_0 b/tests/shell/testcases/listing/0012sets_0
new file mode 100755
index 0000000..da16d94
--- /dev/null
+++ b/tests/shell/testcases/listing/0012sets_0
@@ -0,0 +1,39 @@
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
+set -e
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
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi

