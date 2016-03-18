From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: add new testcases for commit/rollback
Date: Fri, 18 Mar 2016 14:32:08 +0100
Message-ID: <145830792808.5446.13784125186138242867.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43851 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752417AbcCRNcR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 09:32:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New simple testcases for kernel commit/rollback operations.

* ruleset A is loaded (good ruleset)
* ruleset B is loaded (bad ruleset): fail is expected
* ruleset A should remain in the kernel

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/nft-f/0002rollback_rule_0 |   67 ++++++++++++++++++++++
 tests/shell/testcases/nft-f/0003rollback_jump_0 |   67 ++++++++++++++++++++++
 tests/shell/testcases/nft-f/0004rollback_set_0  |   67 ++++++++++++++++++++++
 tests/shell/testcases/nft-f/0005rollback_map_0  |   70 +++++++++++++++++++++++
 4 files changed, 271 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0002rollback_rule_0
 create mode 100755 tests/shell/testcases/nft-f/0003rollback_jump_0
 create mode 100755 tests/shell/testcases/nft-f/0004rollback_set_0
 create mode 100755 tests/shell/testcases/nft-f/0005rollback_map_0

diff --git a/tests/shell/testcases/nft-f/0002rollback_rule_0 b/tests/shell/testcases/nft-f/0002rollback_rule_0
new file mode 100755
index 0000000..fa40024
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0002rollback_rule_0
@@ -0,0 +1,67 @@
+#!/bin/bash
+
+# test a kernel rollback operation
+# fail reason: rule
+
+MKTEMP=$(which mktemp)
+if [ -x $MKTEMP ] ; then
+	tmpfile=$(${MKTEMP})
+else
+	tmpfile=$(/tmp/${RANDOM})
+fi
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+GOOD_RULESET="table ip t {
+	set t {
+		type ipv4_addr
+		elements = { 1.1.1.1}
+	}
+
+	chain c {
+		ct state new 
+		tcp dport { 22222} 
+		ip saddr @t drop 
+		jump other 
+	}
+
+	chain other {
+	}
+}"
+
+BAD_RULESET="flush ruleset
+table ip t2 {
+	chain c2 {
+		this is an invalid rule
+	}
+}"
+
+echo "$GOOD_RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load good ruleset" >&2
+	exit 1
+fi
+
+echo "$BAD_RULESET" > $tmpfile
+$NFT -f $tmpfile 2>/dev/null
+if [ $? -eq 0 ]	; then
+	echo "E: bogus ruleset loaded?" >&2
+	exit 1
+fi
+
+KERNEL_RULESET="$($NFT list ruleset)"
+
+if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
+        DIFF="$(which diff)"
+        [ -x $DIFF ] && $DIFF -u <(echo "$GOOD_RULESET") <(echo "$KERNEL_RULESET")
+        exit 1
+fi
+
+exit 0
+
diff --git a/tests/shell/testcases/nft-f/0003rollback_jump_0 b/tests/shell/testcases/nft-f/0003rollback_jump_0
new file mode 100755
index 0000000..d1f6edf
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0003rollback_jump_0
@@ -0,0 +1,67 @@
+#!/bin/bash
+
+# test a kernel rollback operation
+# fail reason: invalid jump
+
+MKTEMP=$(which mktemp)
+if [ -x $MKTEMP ] ; then
+	tmpfile=$(${MKTEMP})
+else
+	tmpfile=$(/tmp/${RANDOM})
+fi
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+GOOD_RULESET="table ip t {
+	set t {
+		type ipv4_addr
+		elements = { 1.1.1.1}
+	}
+
+	chain c {
+		ct state new 
+		tcp dport { 22222} 
+		ip saddr @t drop 
+		jump other 
+	}
+
+	chain other {
+	}
+}"
+
+BAD_RULESET="flush ruleset
+table ip t2 {
+	chain c2 {
+		jump other
+	}
+}"
+
+echo "$GOOD_RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load good ruleset" >&2
+	exit 1
+fi
+
+echo "$BAD_RULESET" > $tmpfile
+$NFT -f $tmpfile 2>/dev/null
+if [ $? -eq 0 ]	; then
+	echo "E: bogus ruleset loaded?" >&2
+	exit 1
+fi
+
+KERNEL_RULESET="$($NFT list ruleset)"
+
+if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
+        DIFF="$(which diff)"
+        [ -x $DIFF ] && $DIFF -u <(echo "$GOOD_RULESET") <(echo "$KERNEL_RULESET")
+        exit 1
+fi
+
+exit 0
+
diff --git a/tests/shell/testcases/nft-f/0004rollback_set_0 b/tests/shell/testcases/nft-f/0004rollback_set_0
new file mode 100755
index 0000000..2a65da9
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0004rollback_set_0
@@ -0,0 +1,67 @@
+#!/bin/bash
+
+# test a kernel rollback operation
+# fail reason: invalid set
+
+MKTEMP=$(which mktemp)
+if [ -x $MKTEMP ] ; then
+	tmpfile=$(${MKTEMP})
+else
+	tmpfile=$(/tmp/${RANDOM})
+fi
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+GOOD_RULESET="table ip t {
+	set t {
+		type ipv4_addr
+		elements = { 1.1.1.1}
+	}
+
+	chain c {
+		ct state new 
+		tcp dport { 22222} 
+		ip saddr @t drop 
+		jump other 
+	}
+
+	chain other {
+	}
+}"
+
+BAD_RULESET="flush ruleset
+table ip t2 {
+	set s2 {
+		type invalid
+	}
+}"
+
+echo "$GOOD_RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load good ruleset" >&2
+	exit 1
+fi
+
+echo "$BAD_RULESET" > $tmpfile
+$NFT -f $tmpfile 2>/dev/null
+if [ $? -eq 0 ]	; then
+	echo "E: bogus ruleset loaded?" >&2
+	exit 1
+fi
+
+KERNEL_RULESET="$($NFT list ruleset)"
+
+if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
+        DIFF="$(which diff)"
+        [ -x $DIFF ] && $DIFF -u <(echo "$GOOD_RULESET") <(echo "$KERNEL_RULESET")
+        exit 1
+fi
+
+exit 0
+
diff --git a/tests/shell/testcases/nft-f/0005rollback_map_0 b/tests/shell/testcases/nft-f/0005rollback_map_0
new file mode 100755
index 0000000..c2dbc8a
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0005rollback_map_0
@@ -0,0 +1,70 @@
+#!/bin/bash
+
+# test a kernel rollback operation
+# fail reason: invalid map
+
+MKTEMP=$(which mktemp)
+if [ -x $MKTEMP ] ; then
+	tmpfile=$(${MKTEMP})
+else
+	tmpfile=$(/tmp/${RANDOM})
+fi
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+GOOD_RULESET="table ip t {
+	set t {
+		type ipv4_addr
+		elements = { 1.1.1.1}
+	}
+
+	chain c {
+		ct state new 
+		tcp dport { 22222} 
+		ip saddr @t drop 
+		jump other 
+	}
+
+	chain other {
+	}
+}"
+
+BAD_RULESET="flush ruleset
+table ip t2 {
+	chain c2 {
+		tcp dport map {22222: jump other, 11111: jump invalid}
+	}
+
+	chain other {
+	}
+}"
+
+echo "$GOOD_RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load good ruleset" >&2
+	exit 1
+fi
+
+echo "$BAD_RULESET" > $tmpfile
+$NFT -f $tmpfile 2>/dev/null
+if [ $? -eq 0 ]	; then
+	echo "E: bogus ruleset loaded?" >&2
+	exit 1
+fi
+
+KERNEL_RULESET="$($NFT list ruleset)"
+
+if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
+        DIFF="$(which diff)"
+        [ -x $DIFF ] && $DIFF -u <(echo "$GOOD_RULESET") <(echo "$KERNEL_RULESET")
+        exit 1
+fi
+
+exit 0
+

