From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nft PATCH 3/3] tests/operations: add tests for handles and
 comments
Date: Fri, 09 Oct 2015 14:38:22 +0200
Message-ID: <20151009123822.32207.10062.stgit@r2d2.cica.es>
References: <20151009123529.32207.81925.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51463 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933333AbbJINsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 09:48:05 -0400
In-Reply-To: <20151009123529.32207.81925.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here some tests for optional things like rule handles and comments.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/operations/testcases/optionals/comments_0    |    9 +++++++++
 .../testcases/optionals/comments_handles_0         |   11 ++++++++++
 .../testcases/optionals/comments_handles_monitor_0 |   21 ++++++++++++++++++++
 tests/operations/testcases/optionals/handles_0     |    9 +++++++++
 tests/operations/testcases/optionals/handles_1     |    9 +++++++++
 5 files changed, 59 insertions(+)
 create mode 100755 tests/operations/testcases/optionals/comments_0
 create mode 100755 tests/operations/testcases/optionals/comments_handles_0
 create mode 100755 tests/operations/testcases/optionals/comments_handles_monitor_0
 create mode 100755 tests/operations/testcases/optionals/handles_0
 create mode 100755 tests/operations/testcases/optionals/handles_1

diff --git a/tests/operations/testcases/optionals/comments_0 b/tests/operations/testcases/optionals/comments_0
new file mode 100755
index 0000000..51024c8
--- /dev/null
+++ b/tests/operations/testcases/optionals/comments_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+# comments are shown
+
+$NFT flush ruleset
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept comment test_comment
+$NFT list table test -a | grep 'accept comment \"test_comment\"' >/dev/null
diff --git a/tests/operations/testcases/optionals/comments_handles_0 b/tests/operations/testcases/optionals/comments_handles_0
new file mode 100755
index 0000000..85048e8
--- /dev/null
+++ b/tests/operations/testcases/optionals/comments_handles_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# handles and comments mix well
+
+$NFT flush ruleset
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept comment test_comment
+set -e
+$NFT list table test -a | grep 'accept comment \"test_comment\" # handle '[[:digit:]]$ >/dev/null
+$NFT list table test | grep 'accept comment \"test_comment\"' | grep -v '# handle '[[:digit:]]$ >/dev/null
diff --git a/tests/operations/testcases/optionals/comments_handles_monitor_0 b/tests/operations/testcases/optionals/comments_handles_monitor_0
new file mode 100755
index 0000000..81fe85f
--- /dev/null
+++ b/tests/operations/testcases/optionals/comments_handles_monitor_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# handles and comments mix well in monitor
+
+MKTEMP=$(which mktemp)
+[ ! -x $MKTEMP ] && exit 0 # :-( no mktemp
+
+tmpfile=$(${MKTEMP})
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+$NFT flush ruleset
+$NFT add table test
+$NFT add chain test test
+
+$NFT monitor -a > $tmpfile &
+$NFT add rule test test tcp dport 22 counter accept comment test_comment
+kill $!
+set -e
+grep 'accept comment \"test_comment\" # handle '[[:digit:]]$ $tmpfile >/dev/null
+set +e
+rm -rf $tmpfile
diff --git a/tests/operations/testcases/optionals/handles_0 b/tests/operations/testcases/optionals/handles_0
new file mode 100755
index 0000000..b082eca
--- /dev/null
+++ b/tests/operations/testcases/optionals/handles_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+# handles are shown last
+
+$NFT flush ruleset
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept
+$NFT list table test -a | grep 'accept # handle '[[:digit:]]$ >/dev/null
diff --git a/tests/operations/testcases/optionals/handles_1 b/tests/operations/testcases/optionals/handles_1
new file mode 100755
index 0000000..517637c
--- /dev/null
+++ b/tests/operations/testcases/optionals/handles_1
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+# handles are not shown if not asked for them
+
+$NFT flush ruleset
+$NFT add table test
+$NFT add chain test test
+$NFT add rule test test tcp dport 22 counter accept
+$NFT list table test | grep 'accept # handle '[[:digit:]]$ >/dev/null

