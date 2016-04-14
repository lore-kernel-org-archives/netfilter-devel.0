From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: add testcases for Netfilter bug #965
Date: Thu, 14 Apr 2016 09:58:56 +0200
Message-ID: <146062067574.20303.17765460378437095142.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59671 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752687AbcDNH7G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 03:59:06 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 500F551F2AB
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 07:59:03 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 50GqXmHufjYD for <netfilter-devel@vger.kernel.org>;
	Thu, 14 Apr 2016 09:58:57 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id 7A40C51F2B3
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 09:58:57 +0200 (CEST)
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
 Note: simple resubmission

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
index 0000000..e66bfff
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
index 0000000..cf8a568
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
index 0000000..6691c16
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
index 0000000..6a4b949
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
index 0000000..126fe5d
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

