From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: shell: cover transactions via nft -f using flat syntax
Date: Wed, 22 Jun 2016 13:18:56 +0200
Message-ID: <1466594336-24231-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57683 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbcFVMAw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 08:00:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5667B492262
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:19:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F42D26675D
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:19:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DFD89EBD9
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 13:19:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch covers transactions using the flat syntax representation, eg.

	add table x
	add chain x y { type filter hook forward priority 0; }
	add chain x y { policy drop; }

This also covers things like:

	add element x whitelist { 1.1.1.1 }
	delete element x whitelist { 1.1.1.1 }

The one above may look silly from a human behaviour point of view, but
silly robots may very well behave like this.

These tests require several kernel patches though in order to pass
successfully.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/0001table_0 | 36 +++++++++++++++++++++
 tests/shell/testcases/transactions/0002table_0 | 35 +++++++++++++++++++++
 tests/shell/testcases/transactions/0003table_0 | 32 +++++++++++++++++++
 tests/shell/testcases/transactions/0010chain_0 | 37 ++++++++++++++++++++++
 tests/shell/testcases/transactions/0011chain_0 | 38 +++++++++++++++++++++++
 tests/shell/testcases/transactions/0012chain_0 | 42 +++++++++++++++++++++++++
 tests/shell/testcases/transactions/0013chain_0 | 43 ++++++++++++++++++++++++++
 tests/shell/testcases/transactions/0014chain_1 | 20 ++++++++++++
 tests/shell/testcases/transactions/0020rule_0  | 33 ++++++++++++++++++++
 tests/shell/testcases/transactions/0021rule_0  | 40 ++++++++++++++++++++++++
 tests/shell/testcases/transactions/0022rule_1  | 21 +++++++++++++
 tests/shell/testcases/transactions/0023rule_1  | 20 ++++++++++++
 tests/shell/testcases/transactions/0030set_0   | 34 ++++++++++++++++++++
 tests/shell/testcases/transactions/0031set_0   | 37 ++++++++++++++++++++++
 tests/shell/testcases/transactions/0032set_0   | 38 +++++++++++++++++++++++
 tests/shell/testcases/transactions/0033set_0   | 33 ++++++++++++++++++++
 tests/shell/testcases/transactions/0034set_0   | 37 ++++++++++++++++++++++
 tests/shell/testcases/transactions/0035set_0   | 40 ++++++++++++++++++++++++
 tests/shell/testcases/transactions/0036set_1   | 22 +++++++++++++
 tests/shell/testcases/transactions/0037set_0   | 38 +++++++++++++++++++++++
 tests/shell/testcases/transactions/0038set_0   | 41 ++++++++++++++++++++++++
 tests/shell/testcases/transactions/0039set_0   | 41 ++++++++++++++++++++++++
 22 files changed, 758 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0001table_0
 create mode 100755 tests/shell/testcases/transactions/0002table_0
 create mode 100755 tests/shell/testcases/transactions/0003table_0
 create mode 100755 tests/shell/testcases/transactions/0010chain_0
 create mode 100755 tests/shell/testcases/transactions/0011chain_0
 create mode 100755 tests/shell/testcases/transactions/0012chain_0
 create mode 100755 tests/shell/testcases/transactions/0013chain_0
 create mode 100755 tests/shell/testcases/transactions/0014chain_1
 create mode 100755 tests/shell/testcases/transactions/0020rule_0
 create mode 100755 tests/shell/testcases/transactions/0021rule_0
 create mode 100755 tests/shell/testcases/transactions/0022rule_1
 create mode 100755 tests/shell/testcases/transactions/0023rule_1
 create mode 100755 tests/shell/testcases/transactions/0030set_0
 create mode 100755 tests/shell/testcases/transactions/0031set_0
 create mode 100755 tests/shell/testcases/transactions/0032set_0
 create mode 100755 tests/shell/testcases/transactions/0033set_0
 create mode 100755 tests/shell/testcases/transactions/0034set_0
 create mode 100755 tests/shell/testcases/transactions/0035set_0
 create mode 100755 tests/shell/testcases/transactions/0036set_1
 create mode 100755 tests/shell/testcases/transactions/0037set_0
 create mode 100755 tests/shell/testcases/transactions/0038set_0
 create mode 100755 tests/shell/testcases/transactions/0039set_0

diff --git a/tests/shell/testcases/transactions/0001table_0 b/tests/shell/testcases/transactions/0001table_0
new file mode 100755
index 0000000..0bde101
--- /dev/null
+++ b/tests/shell/testcases/transactions/0001table_0
@@ -0,0 +1,36 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+delete table x
+add table x
+add table y"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+}
+table ip y {
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/transactions/0002table_0 b/tests/shell/testcases/transactions/0002table_0
new file mode 100755
index 0000000..c5f319e
--- /dev/null
+++ b/tests/shell/testcases/transactions/0002table_0
@@ -0,0 +1,35 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+delete table x
+add table x
+add table x { flags dormant; }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	flags dormant
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/transactions/0003table_0 b/tests/shell/testcases/transactions/0003table_0
new file mode 100755
index 0000000..f17285e
--- /dev/null
+++ b/tests/shell/testcases/transactions/0003table_0
@@ -0,0 +1,32 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add table y
+flush ruleset"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED=""
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/transactions/0010chain_0 b/tests/shell/testcases/transactions/0010chain_0
new file mode 100755
index 0000000..f4c1fbd
--- /dev/null
+++ b/tests/shell/testcases/transactions/0010chain_0
@@ -0,0 +1,37 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+flush ruleset
+add table w
+add chain w y"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip w {
+	chain y {
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
diff --git a/tests/shell/testcases/transactions/0011chain_0 b/tests/shell/testcases/transactions/0011chain_0
new file mode 100755
index 0000000..71afa6e
--- /dev/null
+++ b/tests/shell/testcases/transactions/0011chain_0
@@ -0,0 +1,38 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+delete chain x y
+add chain x y { type filter hook input priority 0; }
+add chain x y { policy drop; }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	chain y {
+		type filter hook input priority 0; policy drop;
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
diff --git a/tests/shell/testcases/transactions/0012chain_0 b/tests/shell/testcases/transactions/0012chain_0
new file mode 100755
index 0000000..757bc75
--- /dev/null
+++ b/tests/shell/testcases/transactions/0012chain_0
@@ -0,0 +1,42 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+flush ruleset
+add table x
+add chain x y { type filter hook input priority 0; }
+add chain x y { policy drop; }
+flush ruleset
+add table w
+add chain w y { type filter hook output priority 0; }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip w {
+	chain y {
+		type filter hook output priority 0; policy accept;
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
diff --git a/tests/shell/testcases/transactions/0013chain_0 b/tests/shell/testcases/transactions/0013chain_0
new file mode 100755
index 0000000..2c75bd4
--- /dev/null
+++ b/tests/shell/testcases/transactions/0013chain_0
@@ -0,0 +1,43 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+delete chain x y
+delete table x
+add table x
+add chain x y { type filter hook input priority 0; }
+add chain x y { policy drop; }
+flush ruleset
+add table w
+add chain w y { type filter hook output priority 0; }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip w {
+	chain y {
+		type filter hook output priority 0; policy accept;
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
diff --git a/tests/shell/testcases/transactions/0014chain_1 b/tests/shell/testcases/transactions/0014chain_1
new file mode 100755
index 0000000..a03ef12
--- /dev/null
+++ b/tests/shell/testcases/transactions/0014chain_1
@@ -0,0 +1,20 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+delete chain x y
+delete chain x y"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+echo "E: allowing double-removal of chain" >&2
diff --git a/tests/shell/testcases/transactions/0020rule_0 b/tests/shell/testcases/transactions/0020rule_0
new file mode 100755
index 0000000..1ad4362
--- /dev/null
+++ b/tests/shell/testcases/transactions/0020rule_0
@@ -0,0 +1,33 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+add rule x y ip saddr 1.1.1.1 counter
+flush ruleset"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED=""
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/transactions/0021rule_0 b/tests/shell/testcases/transactions/0021rule_0
new file mode 100755
index 0000000..2467124
--- /dev/null
+++ b/tests/shell/testcases/transactions/0021rule_0
@@ -0,0 +1,40 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+add rule x y ip saddr 1.1.1.1 counter
+flush ruleset
+add table x
+add chain x y
+add rule x y ip saddr 2.2.2.2 counter"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	chain y {
+		ip saddr 2.2.2.2 counter packets 0 bytes 0
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
diff --git a/tests/shell/testcases/transactions/0022rule_1 b/tests/shell/testcases/transactions/0022rule_1
new file mode 100755
index 0000000..5b937ac
--- /dev/null
+++ b/tests/shell/testcases/transactions/0022rule_1
@@ -0,0 +1,21 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+delete chain x y
+add rule x y jump y"
+
+echo "$RULESET" > $tmpfile
+# kernel must return ENOENT
+$NFT -f $tmpfile 2>/dev/null
+echo "E: allowing jump loop to unexisting chain"
diff --git a/tests/shell/testcases/transactions/0023rule_1 b/tests/shell/testcases/transactions/0023rule_1
new file mode 100755
index 0000000..4c4e24c
--- /dev/null
+++ b/tests/shell/testcases/transactions/0023rule_1
@@ -0,0 +1,20 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add chain x y
+add rule x y jump y"
+
+echo "$RULESET" > $tmpfile
+# kernel must return ELOOP
+$NFT -f $tmpfile 2>/dev/null
+echo "E: allowing jump to chain loop"
diff --git a/tests/shell/testcases/transactions/0030set_0 b/tests/shell/testcases/transactions/0030set_0
new file mode 100755
index 0000000..1fefb94
--- /dev/null
+++ b/tests/shell/testcases/transactions/0030set_0
@@ -0,0 +1,34 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; }
+flush ruleset
+add table x"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/transactions/0031set_0 b/tests/shell/testcases/transactions/0031set_0
new file mode 100755
index 0000000..87848b4
--- /dev/null
+++ b/tests/shell/testcases/transactions/0031set_0
@@ -0,0 +1,37 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; }
+delete set x y
+add set x y { type ipv4_addr; }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	set y {
+		type ipv4_addr
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
diff --git a/tests/shell/testcases/transactions/0032set_0 b/tests/shell/testcases/transactions/0032set_0
new file mode 100755
index 0000000..d4d7e7e
--- /dev/null
+++ b/tests/shell/testcases/transactions/0032set_0
@@ -0,0 +1,38 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; }
+flush ruleset
+add table w
+add set w y { type ipv4_addr; }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip w {
+	set y {
+		type ipv4_addr
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
diff --git a/tests/shell/testcases/transactions/0033set_0 b/tests/shell/testcases/transactions/0033set_0
new file mode 100755
index 0000000..b73b6fc
--- /dev/null
+++ b/tests/shell/testcases/transactions/0033set_0
@@ -0,0 +1,33 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; }
+delete set x y"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
diff --git a/tests/shell/testcases/transactions/0034set_0 b/tests/shell/testcases/transactions/0034set_0
new file mode 100755
index 0000000..25e6500
--- /dev/null
+++ b/tests/shell/testcases/transactions/0034set_0
@@ -0,0 +1,37 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; }
+add element x y { 1.1.1.1 }
+delete element x y { 1.1.1.1 }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	set y {
+		type ipv4_addr
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
diff --git a/tests/shell/testcases/transactions/0035set_0 b/tests/shell/testcases/transactions/0035set_0
new file mode 100755
index 0000000..a014a69
--- /dev/null
+++ b/tests/shell/testcases/transactions/0035set_0
@@ -0,0 +1,40 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; }
+add element x y { 1.1.1.1, 2.2.2.2 }
+delete element x y { 1.1.1.1 }
+delete element x y { 2.2.2.2 }
+add element x y { 3.3.3.3 }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	set y {
+		type ipv4_addr
+		elements = { 3.3.3.3}
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
diff --git a/tests/shell/testcases/transactions/0036set_1 b/tests/shell/testcases/transactions/0036set_1
new file mode 100755
index 0000000..46f9457
--- /dev/null
+++ b/tests/shell/testcases/transactions/0036set_1
@@ -0,0 +1,22 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; }
+add element x y { 1.1.1.1, 2.2.2.2 }
+delete element x y { 1.1.1.1 }
+delete element x y { 1.1.1.1 }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile 2> /dev/null
+# Kernel must return ENOENT
+echo "E: allowing double-removal of element"
diff --git a/tests/shell/testcases/transactions/0037set_0 b/tests/shell/testcases/transactions/0037set_0
new file mode 100755
index 0000000..3e48c80
--- /dev/null
+++ b/tests/shell/testcases/transactions/0037set_0
@@ -0,0 +1,38 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; flags interval;}
+add element x y { 1.1.1.0/24 }
+delete element x y { 1.1.1.0/24 }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	set y {
+		type ipv4_addr
+		flags interval
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
diff --git a/tests/shell/testcases/transactions/0038set_0 b/tests/shell/testcases/transactions/0038set_0
new file mode 100755
index 0000000..2e36fa3
--- /dev/null
+++ b/tests/shell/testcases/transactions/0038set_0
@@ -0,0 +1,41 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; flags interval;}
+add element x y { 192.168.0.0/24, 192.168.2.0/24 }
+delete element x y { 192.168.0.0/24 }
+delete element x y { 192.168.2.0/24 }
+add element x y { 192.168.4.0/24 }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	set y {
+		type ipv4_addr
+		flags interval
+		elements = { 192.168.4.0/24}
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
diff --git a/tests/shell/testcases/transactions/0039set_0 b/tests/shell/testcases/transactions/0039set_0
new file mode 100755
index 0000000..2e36fa3
--- /dev/null
+++ b/tests/shell/testcases/transactions/0039set_0
@@ -0,0 +1,41 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="add table x
+add set x y { type ipv4_addr; flags interval;}
+add element x y { 192.168.0.0/24, 192.168.2.0/24 }
+delete element x y { 192.168.0.0/24 }
+delete element x y { 192.168.2.0/24 }
+add element x y { 192.168.4.0/24 }"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	set y {
+		type ipv4_addr
+		flags interval
+		elements = { 192.168.4.0/24}
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
2.1.4

