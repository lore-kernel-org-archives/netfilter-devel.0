From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/2] tests/shell: add testcases for Netfilter bug #965
Date: Fri, 18 Mar 2016 20:29:34 +0100
Message-ID: <145832937468.1466.1675834855792100862.stgit@nfdev2.cica.es>
References: <145832936930.1466.10807188686798508369.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: sander.contrib@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58481 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753464AbcCRT3n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 15:29:43 -0400
In-Reply-To: <145832936930.1466.10807188686798508369.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Testscases for Netfilter bug #965:
 * add rule at position
 * insert rule at position
 * replace rule with given handle
 * delete rule with given handle
 * don't allow to delete rules with position keyword

Netfilter Bugzilla: http://bugzilla.netfilter.org/show_bug.cgi?id=965
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 .../testcases/rule_management/0001addposition_0    |   27 ++++++++++++++++++++
 .../testcases/rule_management/0002insertposition_0 |   27 ++++++++++++++++++++
 tests/shell/testcases/rule_management/0003insert_0 |   27 ++++++++++++++++++++
 .../shell/testcases/rule_management/0004replace_0  |   24 ++++++++++++++++++
 .../shell/testcases/rule_management/0005replace_1  |   11 ++++++++
 .../shell/testcases/rule_management/0006replace_1  |   11 ++++++++
 tests/shell/testcases/rule_management/0007delete_0 |   25 +++++++++++++++++++
 tests/shell/testcases/rule_management/0008delete_1 |   11 ++++++++
 tests/shell/testcases/rule_management/0009delete_1 |   11 ++++++++
 9 files changed, 174 insertions(+)
 create mode 100755 tests/shell/testcases/rule_management/0001addposition_0
 create mode 100755 tests/shell/testcases/rule_management/0002insertposition_0
 create mode 100755 tests/shell/testcases/rule_management/0003insert_0
 create mode 100755 tests/shell/testcases/rule_management/0004replace_0
 create mode 100755 tests/shell/testcases/rule_management/0005replace_1
 create mode 100755 tests/shell/testcases/rule_management/0006replace_1
 create mode 100755 tests/shell/testcases/rule_management/0007delete_0
 create mode 100755 tests/shell/testcases/rule_management/0008delete_1
 create mode 100755 tests/shell/testcases/rule_management/0009delete_1

diff --git a/tests/shell/testcases/rule_management/0001addposition_0 b/tests/shell/testcases/rule_management/0001addposition_0
new file mode 100755
index 0000000..f6294ad
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0001addposition_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT add rule t c accept	# should have handle 2
+$NFT add rule t c accept	# should have handle 3
+$NFT add rule t c position 2 drop
+
+EXPECTED="table ip t {
+	chain c {
+		accept 
+		drop 
+		accept 
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
diff --git a/tests/shell/testcases/rule_management/0002insertposition_0 b/tests/shell/testcases/rule_management/0002insertposition_0
new file mode 100755
index 0000000..49fcf7c
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0002insertposition_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT add rule t c accept	# should have handle 2
+$NFT add rule t c accept	# should have handle 3
+$NFT insert rule t c position 2 drop
+
+EXPECTED="table ip t {
+	chain c {
+		drop 
+		accept 
+		accept 
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
diff --git a/tests/shell/testcases/rule_management/0003insert_0 b/tests/shell/testcases/rule_management/0003insert_0
new file mode 100755
index 0000000..407a293
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0003insert_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT insert rule t c accept
+$NFT insert rule t c drop
+$NFT insert rule t c masquerade
+
+EXPECTED="table ip t {
+	chain c {
+		masquerade 
+		drop 
+		accept 
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
diff --git a/tests/shell/testcases/rule_management/0004replace_0 b/tests/shell/testcases/rule_management/0004replace_0
new file mode 100755
index 0000000..92acc30
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0004replace_0
@@ -0,0 +1,24 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT add rule t c accept	# should have handle 2
+$NFT replace rule t c handle 2 drop
+
+EXPECTED="table ip t {
+	chain c {
+		drop 
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
diff --git a/tests/shell/testcases/rule_management/0005replace_1 b/tests/shell/testcases/rule_management/0005replace_1
new file mode 100755
index 0000000..e82995a
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0005replace_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+# kernel should return ENOENT
+$NFT replace rule t c handle 2 drop 2>/dev/null
+echo "E: missing kernel ENOENT" >&2
diff --git a/tests/shell/testcases/rule_management/0006replace_1 b/tests/shell/testcases/rule_management/0006replace_1
new file mode 100755
index 0000000..5dfcba0
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0006replace_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+# position keyword with replace action is not allowed, this should fail
+$NFT replace rule t c position 2 drop 2>/dev/null
+echo "E: allowed replace with position specification" >&2
diff --git a/tests/shell/testcases/rule_management/0007delete_0 b/tests/shell/testcases/rule_management/0007delete_0
new file mode 100755
index 0000000..8b00cd3
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0007delete_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT add rule t c accept	# should have handle 2
+$NFT add rule t c drop		# should have handle 3
+$NFT delete rule t c handle 2
+
+EXPECTED="table ip t {
+	chain c {
+		drop 
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
diff --git a/tests/shell/testcases/rule_management/0008delete_1 b/tests/shell/testcases/rule_management/0008delete_1
new file mode 100755
index 0000000..3dce219
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0008delete_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+# this should fail, we don't allow delete with position
+$NFT delete rule t c position 2 drop 2>/dev/null
+echo "E: allowed position spec with delete action" >&2
diff --git a/tests/shell/testcases/rule_management/0009delete_1 b/tests/shell/testcases/rule_management/0009delete_1
new file mode 100755
index 0000000..87fec60
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0009delete_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# tests for Netfilter bug #965 and the related fix
+# (regarding rule management with a given position/handle spec)
+
+set -e
+$NFT add table t
+$NFT add chain t c
+# kernel ENOENT
+$NFT delete rule t c handle 3333 2>/dev/null
+echo "E: missing kernel ENOENT" >&2

