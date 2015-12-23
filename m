From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: add tests for handles and comments
Date: Wed, 23 Dec 2015 14:19:22 +0100
Message-ID: <145087676257.18415.12296398243898533136.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43135 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752318AbbLWNTb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 08:19:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here some tests for optional things like rule handles and comments.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/optionals/comments_0         |    8 ++++++++
 tests/shell/testcases/optionals/comments_handles_0 |   10 ++++++++++
 tests/shell/testcases/optionals/handles_0          |    8 ++++++++
 tests/shell/testcases/optionals/handles_1          |    8 ++++++++
 4 files changed, 34 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/comments_0
 create mode 100755 tests/shell/testcases/optionals/comments_handles_0
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

