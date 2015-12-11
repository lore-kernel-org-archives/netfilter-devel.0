From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH 4/5] tests/shell: add tests for handles and comments
Date: Fri, 11 Dec 2015 11:10:30 +0100
Message-ID: <144982863023.31246.1243999908078428421.stgit@r2d2.cica.es>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36371 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754265AbbLKKKc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 05:10:32 -0500
In-Reply-To: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here some tests for optional things like rule handles and comments.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/optionals/comments_0         |    8 ++++++
 tests/shell/testcases/optionals/comments_handles_0 |   10 +++++++
 .../testcases/optionals/comments_handles_monitor_0 |   29 ++++++++++++++++++++
 tests/shell/testcases/optionals/handles_0          |    8 ++++++
 tests/shell/testcases/optionals/handles_1          |    8 ++++++
 5 files changed, 63 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/comments_0
 create mode 100755 tests/shell/testcases/optionals/comments_handles_0
 create mode 100755 tests/shell/testcases/optionals/comments_handles_monitor_0
 create mode 100755 tests/shell/testcases/optionals/handles_0
 create mode 100755 tests/shell/testcases/optionals/handles_1

diff --git a/tests/shell/testcases/optionals/comments_0 b/tests/shell/testcases/optionals/comments_0
new file mode 100755
index 0000000..29b8506
--- /dev/null
+++ b/tests/shell/testcases/optionals/comments_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# comments are shown
+
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept comment test_comment
+$NFT list table test -a | grep 'accept comment \"test_comment\"' >/dev/null
diff --git a/tests/shell/testcases/optionals/comments_handles_0 b/tests/shell/testcases/optionals/comments_handles_0
new file mode 100755
index 0000000..30539bf
--- /dev/null
+++ b/tests/shell/testcases/optionals/comments_handles_0
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+# handles and comments mix well
+
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept comment test_comment
+set -e
+$NFT list table test -a | grep 'accept comment \"test_comment\" # handle '[[:digit:]]$ >/dev/null
+$NFT list table test | grep 'accept comment \"test_comment\"' | grep -v '# handle '[[:digit:]]$ >/dev/null
diff --git a/tests/shell/testcases/optionals/comments_handles_monitor_0 b/tests/shell/testcases/optionals/comments_handles_monitor_0
new file mode 100755
index 0000000..f1e2004
--- /dev/null
+++ b/tests/shell/testcases/optionals/comments_handles_monitor_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# handles and comments mix well in monitor
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
+set -e
+
+$NFT add table test
+$NFT add chain test test
+$NFT monitor -a > $tmpfile &
+$NFT add rule test test tcp dport 22 counter accept comment test_comment
+# race :-(
+sleep 1
+kill $!
+grep 'accept comment \"test_comment\" # handle '[[:digit:]]$ $tmpfile >/dev/null
+rm -rf $tmpfile
diff --git a/tests/shell/testcases/optionals/handles_0 b/tests/shell/testcases/optionals/handles_0
new file mode 100755
index 0000000..7c6a437
--- /dev/null
+++ b/tests/shell/testcases/optionals/handles_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# handles are shown last
+
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept
+$NFT list table test -a | grep 'accept # handle '[[:digit:]]$ >/dev/null
diff --git a/tests/shell/testcases/optionals/handles_1 b/tests/shell/testcases/optionals/handles_1
new file mode 100755
index 0000000..a3ae1a7
--- /dev/null
+++ b/tests/shell/testcases/optionals/handles_1
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# handles are not shown if not asked for them
+
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept
+$NFT list table test | grep 'accept # handle '[[:digit:]]$ >/dev/null

