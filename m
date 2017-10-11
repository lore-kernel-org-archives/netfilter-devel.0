From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 5/9] tests: shell: Add tests for variable definition.
Date: Wed, 11 Oct 2017 10:21:11 +0530
Message-ID: <97f570632bd36c21237a3997afc61599476a8d63.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35207 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbdJKEv1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:51:27 -0400
Received: by mail-pg0-f66.google.com with SMTP id l24so894106pgu.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:51:27 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test cases for a variable definition and redefinition.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/nft-f/0013defines_1 | 25 +++++++++++++++++++++++++
 tests/shell/testcases/nft-f/0014defines_1 | 25 +++++++++++++++++++++++++
 tests/shell/testcases/nft-f/0015defines_1 | 24 ++++++++++++++++++++++++
 3 files changed, 74 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0013defines_1
 create mode 100755 tests/shell/testcases/nft-f/0014defines_1
 create mode 100755 tests/shell/testcases/nft-f/0015defines_1

diff --git a/tests/shell/testcases/nft-f/0013defines_1 b/tests/shell/testcases/nft-f/0013defines_1
new file mode 100755
index 0000000..5519703
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0013defines_1
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# Tests use of variable before definition.
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+define var2 = \$var1
+define var1 = lo
+
+table ip t {
+	chain c {
+		iif \$var2
+	}
+}" >> $tmpfile
+
+$NFT -f $tmpfile
diff --git a/tests/shell/testcases/nft-f/0014defines_1 b/tests/shell/testcases/nft-f/0014defines_1
new file mode 100755
index 0000000..914d910
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0014defines_1
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# Tests redefinition of an existing variable.
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+define var1 = lo
+define var1 = lo
+
+table ip t {
+	chain c {
+		iif \$var1
+	}
+}" >> $tmpfile
+
+$NFT -f $tmpfile
diff --git a/tests/shell/testcases/nft-f/0015defines_1 b/tests/shell/testcases/nft-f/0015defines_1
new file mode 100755
index 0000000..1f9db11
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0015defines_1
@@ -0,0 +1,24 @@
+#!/bin/bash
+
+# Tests recursive definition of a variable.
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+define var1 = \$var1
+
+table ip t {
+	chain c {
+		iif \$var1
+	}
+}" >> $tmpfile
+
+$NFT -f $tmpfile
-- 
2.13.6

